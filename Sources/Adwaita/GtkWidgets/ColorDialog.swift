import CAdwaita
import GObjectSupport

/// A helper for the async callback pattern.
private final class ColorAsyncBox<T>: @unchecked Sendable {
    let closure: T
    init(_ closure: T) { self.closure = closure }
}

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
}

/// A color chooser dialog.
///
/// Wraps `GtkColorDialog` (GTK 4.10+).
@MainActor
public final class ColorDialog: GObjectRef {
    /// Creates a new color dialog.
    public init() {
        let ptr = gtk_color_dialog_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
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
    ///
    /// ```swift
    /// let color = await dialog.chooseRGBA(parent: window)
    /// if let color { print("Selected: \(color)") }
    /// ```
    public func chooseRGBA(parent: Widget?, initialColor: RGBA? = nil) async -> RGBA? {
        await withCheckedContinuation { continuation in
            chooseRGBA(parent: parent, initialColor: initialColor) { color in
                continuation.resume(returning: color)
            }
        }
    }

    /// Opens the color dialog for the user to choose a color.
    ///
    /// - Parameters:
    ///   - parent: The parent window, or nil.
    ///   - initialColor: The initial color, or nil.
    ///   - completion: Called with the selected color, or nil if cancelled.
    public func chooseRGBA(parent: Widget?, initialColor: RGBA? = nil, completion: @escaping @MainActor (RGBA?) -> Void) {
        let box = Unmanaged.passRetained(ColorAsyncBox(completion)).toOpaque()
        let parentPtr = parent.flatMap { cadw_cast_window($0.pointer) }
        let callback: GAsyncReadyCallback = { source, result, userData in
            guard let userData, let source, let result else { return }
            var error: UnsafeMutablePointer<GError>?
            let rgba = gtk_color_dialog_choose_rgba_finish(OpaquePointer(source), result, &error)
            let color: RGBA?
            if let rgba {
                color = RGBA(
                    red: Double(rgba.pointee.red),
                    green: Double(rgba.pointee.green),
                    blue: Double(rgba.pointee.blue),
                    alpha: Double(rgba.pointee.alpha)
                )
                gdk_rgba_free(UnsafeMutablePointer(mutating: rgba))
            } else {
                color = nil
            }
            if let error { g_error_free(error) }
            let box = Unmanaged<ColorAsyncBox<@MainActor (RGBA?) -> Void>>.fromOpaque(userData).takeRetainedValue()
            MainActor.assumeIsolated { box.closure(color) }
        }
        if let initialColor {
            var gdkColor = GdkRGBA(red: Float(initialColor.red), green: Float(initialColor.green), blue: Float(initialColor.blue), alpha: Float(initialColor.alpha))
            gtk_color_dialog_choose_rgba(opaquePointer, parentPtr, &gdkColor, nil, callback, box)
        } else {
            gtk_color_dialog_choose_rgba(opaquePointer, parentPtr, nil, nil, callback, box)
        }
    }

    /// Opens the color dialog (throwing version).
    ///
    /// Throws a ``GLibError`` if the dialog fails for a reason other than
    /// the user cancelling. Cancellation returns `nil`.
    public func chooseRGBAThrowing(parent: Widget?, initialColor: RGBA? = nil) async throws -> RGBA? {
        try await withCheckedThrowingContinuation { continuation in
            chooseRGBAThrowing(parent: parent, initialColor: initialColor) { result in
                continuation.resume(with: result)
            }
        }
    }

    /// Opens the color dialog (throwing version).
    ///
    /// The completion handler receives a `Result` — `.success(nil)` on cancel,
    /// `.success(color)` on selection, or `.failure(GLibError)` on error.
    public func chooseRGBAThrowing(
        parent: Widget?,
        initialColor: RGBA? = nil,
        completion: @escaping @MainActor (Result<RGBA?, GLibError>) -> Void
    ) {
        let box = Unmanaged.passRetained(ColorAsyncBox(completion)).toOpaque()
        let parentPtr = parent.flatMap { cadw_cast_window($0.pointer) }
        let callback: GAsyncReadyCallback = { source, result, userData in
            guard let userData, let source, let result else { return }
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
                let dismissed = g_quark_try_string("gtk-dialog-error-quark")
                if error.pointee.domain == dismissed && error.pointee.code == 2 {
                    g_error_free(error)
                    callResult = .success(nil)
                } else {
                    callResult = .failure(GLibError(consuming: error))
                }
            } else {
                callResult = .success(nil)
            }
            let box = Unmanaged<ColorAsyncBox<@MainActor (Result<RGBA?, GLibError>) -> Void>>
                .fromOpaque(userData).takeRetainedValue()
            MainActor.assumeIsolated { box.closure(callResult) }
        }
        if let initialColor {
            var gdkColor = GdkRGBA(red: Float(initialColor.red), green: Float(initialColor.green), blue: Float(initialColor.blue), alpha: Float(initialColor.alpha))
            gtk_color_dialog_choose_rgba(opaquePointer, parentPtr, &gdkColor, nil, callback, box)
        } else {
            gtk_color_dialog_choose_rgba(opaquePointer, parentPtr, nil, nil, callback, box)
        }
    }
}
