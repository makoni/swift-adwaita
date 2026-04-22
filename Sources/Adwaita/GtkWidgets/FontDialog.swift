import CAdwaita
import GObjectSupport

/// A font chooser dialog.
///
/// Wraps `GtkFontDialog` (GTK 4.10+). Async methods resume on the main
/// actor once the user picks a font or dismisses the dialog.
@MainActor
public final class FontDialog: GObjectRef {
    /// Creates a new font dialog.
    public init() {
        let ptr = gtk_font_dialog_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The title of the dialog.
    public var title: String? {
        get { gtk_font_dialog_get_title(opaquePointer).map { String(cString: $0) } }
        set { gtk_font_dialog_set_title(opaquePointer, newValue) }
    }

    /// Whether the dialog is modal.
    public var modal: Bool {
        get { gtk_font_dialog_get_modal(opaquePointer) != 0 }
        set { gtk_font_dialog_set_modal(opaquePointer, newValue ? 1 : 0) }
    }

    /// Opens the font dialog for the user to choose a font.
    ///
    /// Returns the selected font description string, or `nil` if the user cancelled.
    /// Throws a `GLibError` if the underlying GTK call fails.
    ///
    /// ```swift
    /// let font = try await dialog.chooseFont(parent: window)
    /// if let font { print("Selected: \(font)") }
    /// ```
    public func chooseFont(parent: Widget?, initialFont: String? = nil) async throws(GLibError) -> String? {
        try await FontDialog.retype {
            try await withCheckedThrowingContinuation { continuation in
                let box = DialogAsyncSupport.retainBox(continuation)
                let initialDesc: OpaquePointer? = if let initialFont {
                    pango_font_description_from_string(initialFont)
                } else {
                    nil
                }
                gtk_font_dialog_choose_font(
                    self.opaquePointer,
                    parent.map { cadw_cast_window($0.pointer) },
                    initialDesc,
                    nil,
                    { source, result, userData in
                        FontDialog.finishFont(userData: userData, source: source, result: result)
                    },
                    box
                )
                if let initialDesc { pango_font_description_free(initialDesc) }
            }
        }
    }

    /// Opens the font dialog; completion is invoked on the main actor
    /// from the GLib main loop.
    ///
    /// Prefer this over ``chooseFont(parent:initialFont:)`` inside GTK
    /// applications: Swift's default main actor executor is
    /// `DispatchQueue.main`, which the GLib main loop does not drain, so
    /// `Task { @MainActor in await chooseFont(...) }` bodies never execute.
    public func chooseFont(
        parent: Widget?,
        initialFont: String? = nil,
        completion: @escaping @MainActor (Result<String?, GLibError>) -> Void
    ) {
        let box = DialogAsyncSupport.retainBox(completion)
        let initialDesc: OpaquePointer? = if let initialFont {
            pango_font_description_from_string(initialFont)
        } else {
            nil
        }
        gtk_font_dialog_choose_font(
            opaquePointer,
            parent.map { cadw_cast_window($0.pointer) },
            initialDesc,
            nil,
            { source, result, userData in
                FontDialog.finishFontCallback(userData: userData, source: source, result: result)
            },
            box
        )
        if let initialDesc { pango_font_description_free(initialDesc) }
    }
}

private extension FontDialog {
    static func retype<T>(_ operation: () async throws -> T) async throws(GLibError) -> T {
        do {
            return try await operation()
        } catch let error as GLibError {
            throw error
        } catch {
            preconditionFailure("FontDialog continuation threw non-GLibError: \(error)")
        }
    }

    static func finishFont(
        userData: UnsafeMutableRawPointer?,
        source: UnsafeMutablePointer<GObject>?,
        result: OpaquePointer?
    ) {
        let continuation = DialogAsyncSupport.takeBox(
            userData,
            as: CheckedContinuation<String?, any Error>.self,
            context: #function
        ).closure
        guard let source, let result else {
            continuation.resume(returning: nil)
            return
        }
        var error: UnsafeMutablePointer<GError>?
        let fontDesc = gtk_font_dialog_choose_font_finish(OpaquePointer(source), result, &error)
        if let fontDesc {
            let cStr = pango_font_description_to_string(fontDesc)
            let font = cStr.map { String(cString: $0) }
            if let cStr { g_free(gpointer(mutating: cStr)) }
            pango_font_description_free(fontDesc)
            continuation.resume(returning: font)
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

    static func finishFontCallback(
        userData: UnsafeMutableRawPointer?,
        source: UnsafeMutablePointer<GObject>?,
        result: OpaquePointer?
    ) {
        let box = DialogAsyncSupport.takeBox(
            userData,
            as: (@MainActor (Result<String?, GLibError>) -> Void).self,
            context: #function
        )
        guard let source, let result else {
            MainActor.assumeIsolated { box.closure(.success(nil)) }
            return
        }
        var error: UnsafeMutablePointer<GError>?
        let fontDesc = gtk_font_dialog_choose_font_finish(OpaquePointer(source), result, &error)
        let callResult: Result<String?, GLibError>
        if let fontDesc {
            let cStr = pango_font_description_to_string(fontDesc)
            let font = cStr.map { String(cString: $0) }
            if let cStr { g_free(gpointer(mutating: cStr)) }
            pango_font_description_free(fontDesc)
            callResult = .success(font)
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
