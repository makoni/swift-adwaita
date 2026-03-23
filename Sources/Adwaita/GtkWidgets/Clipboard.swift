import CAdwaita
import GObjectSupport

/// A helper for the async callback pattern.
private final class ClipboardAsyncBox<T>: @unchecked Sendable {
    let closure: T
    init(_ closure: T) { self.closure = closure }
}

/// Provides access to the system clipboard for copy/paste.
///
/// Wraps `GdkClipboard`. Obtain an instance via `Widget.clipboard`.
@MainActor
public final class Clipboard: GObjectRef {

    /// Sets the clipboard content to the given text.
    public func setText(_ text: String) {
        gdk_clipboard_set_text(opaquePointer, text)
    }

    /// Reads text from the clipboard asynchronously.
    ///
    /// - Parameter completion: Called with the clipboard text, or nil if not available.
    public func readText(completion: @escaping @MainActor (String?) -> Void) {
        let box = Unmanaged.passRetained(ClipboardAsyncBox(completion)).toOpaque()
        gdk_clipboard_read_text_async(
            opaquePointer,
            nil,
            { source, result, userData in
                guard let userData, let source, let result else { return }
                var error: UnsafeMutablePointer<GError>?
                let cStr = gdk_clipboard_read_text_finish(OpaquePointer(source), result, &error)
                let text: String?
                if let cStr {
                    text = String(cString: cStr)
                    g_free(gpointer(mutating: cStr))
                } else {
                    text = nil
                }
                if let error { g_error_free(error) }
                let box = Unmanaged<ClipboardAsyncBox<@MainActor (String?) -> Void>>.fromOpaque(userData).takeRetainedValue()
                MainActor.assumeIsolated { box.closure(text) }
            },
            box
        )
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

    /// Whether the clipboard content is local (set by this application).
    public var isLocal: Bool {
        gdk_clipboard_is_local(opaquePointer) != 0
    }

    /// Connects to the `changed` signal — clipboard content changed.
    @discardableResult
    public func onChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "changed", handler: handler)
    }
}

// MARK: - Widget extension

extension Widget {
    /// The clipboard for this widget's display.
    public var clipboard: Clipboard {
        let ptr = gtk_widget_get_clipboard(widgetPointer)!
        return Clipboard(borrowing: UnsafeMutableRawPointer(ptr))
    }
}
