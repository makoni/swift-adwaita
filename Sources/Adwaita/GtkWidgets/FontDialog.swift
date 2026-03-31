import CAdwaita
import GObjectSupport

/// A font chooser dialog.
///
/// Wraps `GtkFontDialog` (GTK 4.10+).
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
    ///
    /// ```swift
    /// let font = await dialog.chooseFont(parent: window)
    /// if let font { print("Selected: \(font)") }
    /// ```
    public func chooseFont(parent: Widget?, initialFont: String? = nil) async -> String? {
        await withCheckedContinuation { continuation in
            chooseFont(parent: parent, initialFont: initialFont) { font in
                continuation.resume(returning: font)
            }
        }
    }

    /// Opens the font dialog for the user to choose a font.
    ///
    /// - Parameters:
    ///   - parent: The parent window, or nil.
    ///   - initialFont: A Pango font description string (e.g. "Sans 12"), or nil.
    ///   - completion: Called with the selected font description string, or nil if cancelled.
    public func chooseFont(
        parent: Widget?,
        initialFont: String? = nil,
        completion: @escaping @MainActor (String?) -> Void
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
                let box = DialogAsyncSupport.takeBox(
                    userData,
                    as: (@MainActor (String?) -> Void).self,
                    context: #function
                )
                guard let source, let result else {
                    MainActor.assumeIsolated { box.closure(nil) }
                    return
                }
                var error: UnsafeMutablePointer<GError>?
                let fontDesc = gtk_font_dialog_choose_font_finish(OpaquePointer(source), result, &error)
                let font: String?
                if let fontDesc {
                    let cStr = pango_font_description_to_string(fontDesc)
                    font = cStr.map { String(cString: $0) }
                    if let cStr { g_free(gpointer(mutating: cStr)) }
                    pango_font_description_free(fontDesc)
                } else {
                    font = nil
                }
                if let error { g_error_free(error) }
                MainActor.assumeIsolated { box.closure(font) }
            },
            box
        )
        if let initialDesc { pango_font_description_free(initialDesc) }
    }

    /// Opens the font dialog (throwing version).
    ///
    /// Throws a `GLibError` if the dialog fails for a reason other than
    /// the user cancelling. Cancellation returns `nil`.
    public func chooseFontThrowing(parent: Widget?, initialFont: String? = nil) async throws -> String? {
        try await withCheckedThrowingContinuation { continuation in
            chooseFontThrowing(parent: parent, initialFont: initialFont) { result in
                continuation.resume(with: result)
            }
        }
    }

    /// Opens the font dialog (throwing version).
    ///
    /// The completion handler receives a `Result` — `.success(nil)` on cancel,
    /// `.success(font)` on selection, or `.failure(GLibError)` on error.
    public func chooseFontThrowing(
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
            },
            box
        )
        if let initialDesc { pango_font_description_free(initialDesc) }
    }
}
