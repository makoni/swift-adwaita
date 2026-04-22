import CAdwaita
import GObjectSupport

/// A simple RGBA color representation.
public struct RGBA: Sendable, Equatable {
    public var red: Double
    public var green: Double
    public var blue: Double
    public var alpha: Double

    public init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    /// Parses a CSS-style hex color string.
    ///
    /// Accepts `#RGB`, `#RGBA`, `#RRGGBB`, and `#RRGGBBAA`. The leading `#`
    /// is optional, and digits are case-insensitive. Three/four-digit
    /// shorthand is expanded by doubling each nibble, matching the CSS
    /// rule (`#F80` → `#FF8800`). Returns `nil` for any other length,
    /// empty input, or non-hex characters.
    ///
    /// ```swift
    /// RGBA(hex: "#FF8000")    // opaque orange
    /// RGBA(hex: "#FF8000CC")  // orange @ ~80% alpha
    /// RGBA(hex: "F80")        // shorthand, no leading hash
    /// ```
    public init?(hex: String) {
        var body = Substring(hex)
        if body.first == "#" { body = body.dropFirst() }
        guard !body.isEmpty else { return nil }

        let expanded: String
        switch body.count {
        case 3, 4:
            expanded = body.reduce(into: "") { $0.append(contentsOf: "\($1)\($1)") }
        case 6, 8:
            expanded = String(body)
        default:
            return nil
        }

        guard let value = UInt32(expanded, radix: 16) else { return nil }
        let hasAlpha = expanded.count == 8
        let r: UInt32, g: UInt32, b: UInt32, a: UInt32
        if hasAlpha {
            r = (value >> 24) & 0xFF
            g = (value >> 16) & 0xFF
            b = (value >> 8) & 0xFF
            a = value & 0xFF
        } else {
            r = (value >> 16) & 0xFF
            g = (value >> 8) & 0xFF
            b = value & 0xFF
            a = 0xFF
        }
        self.init(
            red: Double(r) / 255.0,
            green: Double(g) / 255.0,
            blue: Double(b) / 255.0,
            alpha: Double(a) / 255.0
        )
    }
}

/// A color chooser dialog.
///
/// Wraps `GtkColorDialog` (GTK 4.10+). Async methods resume on the main
/// actor once the user picks a color or dismisses the dialog.
@MainActor
public final class ColorDialog: GObjectRef {
    /// Creates a new color dialog.
    public init() {
        let ptr = gtk_color_dialog_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The title of the dialog.
    public var title: String? {
        get { gtk_color_dialog_get_title(opaquePointer).map { String(cString: $0) } }
        set { gtk_color_dialog_set_title(opaquePointer, newValue) }
    }

    /// Whether the dialog is modal.
    public var modal: Bool {
        get { gtk_color_dialog_get_modal(opaquePointer) != 0 }
        set { gtk_color_dialog_set_modal(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the dialog includes an alpha channel selector.
    public var withAlpha: Bool {
        get { gtk_color_dialog_get_with_alpha(opaquePointer) != 0 }
        set { gtk_color_dialog_set_with_alpha(opaquePointer, newValue ? 1 : 0) }
    }

    /// Opens the color dialog for the user to choose a color.
    ///
    /// Returns the selected color, or `nil` if the user cancelled.
    /// Throws a `GLibError` if the underlying GTK call fails.
    ///
    /// > Warning: Inside a GTK application use
    /// > ``chooseRGBA(parent:initialColor:completion:)``. `Task { @MainActor
    /// > in await chooseRGBA(...) }` never runs under the GLib main loop —
    /// > Swift's default main actor executor is `DispatchQueue.main`, which
    /// > GLib does not drain. The `async` form is intended for tests and
    /// > non-GTK contexts.
    ///
    /// ```swift
    /// let color = try await dialog.chooseRGBA(parent: window)
    /// if let color { print("Selected: \(color)") }
    /// ```
    public func chooseRGBA(parent: Widget?, initialColor: RGBA? = nil) async throws(GLibError) -> RGBA? {
        try await ColorDialog.retype {
            try await withCheckedThrowingContinuation { continuation in
                let box = DialogAsyncSupport.retainBox(continuation)
                let parentPtr = parent.flatMap { cadw_cast_window($0.pointer) }
                let callback: GAsyncReadyCallback = { source, result, userData in
                    ColorDialog.finishColor(userData: userData, source: source, result: result)
                }
                if let initialColor {
                    var gdkColor = GdkRGBA(
                        red: Float(initialColor.red),
                        green: Float(initialColor.green),
                        blue: Float(initialColor.blue),
                        alpha: Float(initialColor.alpha)
                    )
                    gtk_color_dialog_choose_rgba(self.opaquePointer, parentPtr, &gdkColor, nil, callback, box)
                } else {
                    gtk_color_dialog_choose_rgba(self.opaquePointer, parentPtr, nil, nil, callback, box)
                }
            }
        }
    }

    /// Opens the color dialog; completion is invoked on the main actor
    /// from the GLib main loop.
    ///
    /// Prefer this over ``chooseRGBA(parent:initialColor:)`` inside GTK
    /// applications: Swift's default main actor executor is
    /// `DispatchQueue.main`, which the GLib main loop does not drain, so
    /// `Task { @MainActor in await chooseRGBA(...) }` bodies never execute.
    public func chooseRGBA(
        parent: Widget?,
        initialColor: RGBA? = nil,
        completion: @escaping @MainActor (Result<RGBA?, GLibError>) -> Void
    ) {
        let box = DialogAsyncSupport.retainBox(completion)
        let parentPtr = parent.flatMap { cadw_cast_window($0.pointer) }
        let callback: GAsyncReadyCallback = { source, result, userData in
            ColorDialog.finishColorCallback(userData: userData, source: source, result: result)
        }
        if let initialColor {
            var gdkColor = GdkRGBA(
                red: Float(initialColor.red),
                green: Float(initialColor.green),
                blue: Float(initialColor.blue),
                alpha: Float(initialColor.alpha)
            )
            gtk_color_dialog_choose_rgba(opaquePointer, parentPtr, &gdkColor, nil, callback, box)
        } else {
            gtk_color_dialog_choose_rgba(opaquePointer, parentPtr, nil, nil, callback, box)
        }
    }
}

private extension ColorDialog {
    static func retype<T>(_ operation: () async throws -> T) async throws(GLibError) -> T {
        do {
            return try await operation()
        } catch let error as GLibError {
            throw error
        } catch {
            preconditionFailure("ColorDialog continuation threw non-GLibError: \(error)")
        }
    }

    static func finishColor(
        userData: UnsafeMutableRawPointer?,
        source: UnsafeMutablePointer<GObject>?,
        result: OpaquePointer?
    ) {
        let continuation = DialogAsyncSupport.takeBox(
            userData,
            as: CheckedContinuation<RGBA?, any Error>.self,
            context: #function
        ).closure
        guard let source, let result else {
            continuation.resume(returning: nil)
            return
        }
        var error: UnsafeMutablePointer<GError>?
        let rgba = gtk_color_dialog_choose_rgba_finish(OpaquePointer(source), result, &error)
        if let rgba {
            let color = RGBA(
                red: Double(rgba.pointee.red),
                green: Double(rgba.pointee.green),
                blue: Double(rgba.pointee.blue),
                alpha: Double(rgba.pointee.alpha)
            )
            gdk_rgba_free(UnsafeMutablePointer(mutating: rgba))
            continuation.resume(returning: color)
        } else if let error {
            if DialogAsyncSupport.isDismissed(error) {
                g_error_free(error)
                continuation.resume(returning: nil)
            } else {
                continuation.resume(throwing: GLibError(consuming: error))
            }
        } else {
            continuation.resume(returning: nil)
        }
    }

    static func finishColorCallback(
        userData: UnsafeMutableRawPointer?,
        source: UnsafeMutablePointer<GObject>?,
        result: OpaquePointer?
    ) {
        let box = DialogAsyncSupport.takeBox(
            userData,
            as: (@MainActor (Result<RGBA?, GLibError>) -> Void).self,
            context: #function
        )
        guard let source, let result else {
            MainActor.assumeIsolated { box.closure(.success(nil)) }
            return
        }
        var error: UnsafeMutablePointer<GError>?
        let rgba = gtk_color_dialog_choose_rgba_finish(OpaquePointer(source), result, &error)
        let callResult: Result<RGBA?, GLibError>
        if let rgba {
            let color = RGBA(
                red: Double(rgba.pointee.red),
                green: Double(rgba.pointee.green),
                blue: Double(rgba.pointee.blue),
                alpha: Double(rgba.pointee.alpha)
            )
            gdk_rgba_free(UnsafeMutablePointer(mutating: rgba))
            callResult = .success(color)
        } else if let error {
            if DialogAsyncSupport.isDismissed(error) {
                g_error_free(error)
                callResult = .success(nil)
            } else {
                callResult = .failure(GLibError(consuming: error))
            }
        } else {
            callResult = .success(nil)
        }
        MainActor.assumeIsolated { box.closure(callResult) }
    }
}
