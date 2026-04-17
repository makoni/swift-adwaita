import CAdwaita
import GObjectSupport

/// Provides access to the system clipboard for copy/paste.
///
/// Wraps `GdkClipboard`. Obtain an instance via `Widget.clipboard`.
@MainActor
public final class Clipboard: GObjectRef {

    /// Sets the clipboard content to the given text.
    public func setText(_ text: String) {
        gdk_clipboard_set_text(opaquePointer, text)
    }

    /// Sets the clipboard content to an image via a `GdkTexture`.
    ///
    /// ```swift
    /// if let texture = Texture(filename: "/path/to/image.png") {
    ///     widget.clipboard.setTexture(texture)
    /// }
    /// ```
    public func setTexture(_ texture: Texture) {
        gdk_clipboard_set_texture(opaquePointer, OpaquePointer(texture.pointer))
    }

    /// Reads text from the clipboard using async/await.
    ///
    /// - Returns: The clipboard text, or nil if not available.
    public func readText() async -> String? {
        await withCheckedContinuation { continuation in
            let box = DialogAsyncSupport.retainBox(continuation)
            gdk_clipboard_read_text_async(
                opaquePointer,
                nil,
                { source, result, userData in
                    Clipboard.finishText(userData: userData, source: source, result: result)
                },
                box
            )
        }
    }

    /// Reads a texture (image) from the clipboard using async/await.
    ///
    /// - Returns: The texture, or nil if not available.
    public func readTexture() async -> Texture? {
        await withCheckedContinuation { continuation in
            let box = DialogAsyncSupport.retainBox(continuation)
            gdk_clipboard_read_texture_async(
                opaquePointer,
                nil,
                { source, result, userData in
                    Clipboard.finishTexture(userData: userData, source: source, result: result)
                },
                box
            )
        }
    }

    /// Whether the clipboard content is local (set by this application).
    public var isLocal: Bool {
        gdk_clipboard_is_local(opaquePointer) != 0
    }

    /// Emitted when the clipboard content changes.
    ///
    /// - Parameter handler: Called when the clipboard content changes.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .changed, handler: handler)
    }
}

private extension Clipboard {
    static func finishText(
        userData: UnsafeMutableRawPointer?,
        source: UnsafeMutablePointer<GObject>?,
        result: OpaquePointer?
    ) {
        let continuation = DialogAsyncSupport.takeBox(
            userData,
            as: CheckedContinuation<String?, Never>.self,
            context: #function
        ).closure
        guard let source, let result else {
            continuation.resume(returning: nil)
            return
        }
        var error: UnsafeMutablePointer<GError>?
        let cStr = gdk_clipboard_read_text_finish(OpaquePointer(source), result, &error)
        if let error { g_error_free(error) }
        guard let cStr else {
            continuation.resume(returning: nil)
            return
        }
        let text = String(cString: cStr)
        g_free(gpointer(mutating: cStr))
        continuation.resume(returning: text)
    }

    static func finishTexture(
        userData: UnsafeMutableRawPointer?,
        source: UnsafeMutablePointer<GObject>?,
        result: OpaquePointer?
    ) {
        let continuation = DialogAsyncSupport.takeBox(
            userData,
            as: CheckedContinuation<Texture?, Never>.self,
            context: #function
        ).closure
        guard let source, let result else {
            continuation.resume(returning: nil)
            return
        }
        var error: UnsafeMutablePointer<GError>?
        let texture = gdk_clipboard_read_texture_finish(OpaquePointer(source), result, &error)
        if let error { g_error_free(error) }
        guard let texture else {
            continuation.resume(returning: nil)
            return
        }
        continuation.resume(returning: Texture(raw: UnsafeMutableRawPointer(texture)))
    }
}

// MARK: - Widget extension

public extension Widget {
    /// The clipboard for this widget's display.
    var clipboard: Clipboard {
        let ptr = gtk_widget_get_clipboard(widgetPointer)!
        return Clipboard(borrowing: UnsafeMutableRawPointer(ptr))
    }
}
