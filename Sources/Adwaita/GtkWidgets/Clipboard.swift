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

    /// Reads a texture (image) from the clipboard asynchronously.
    ///
    /// - Parameter completion: Called with the texture, or nil if not available.
    public func readTexture(completion: @escaping @MainActor (Texture?) -> Void) {
        let box = Unmanaged.passRetained(ClipboardAsyncBox(completion)).toOpaque()
        gdk_clipboard_read_texture_async(
            opaquePointer,
            nil,
            { source, result, userData in
                guard let userData, let source, let result else { return }
                var error: UnsafeMutablePointer<GError>?
                let texture = gdk_clipboard_read_texture_finish(OpaquePointer(source), result, &error)
                let value: Texture?
                if let texture {
                    // Transfer full — we own the reference
                    value = Texture(raw: UnsafeMutableRawPointer(texture))
                } else {
                    value = nil
                }
                if let error { g_error_free(error) }
                let box = Unmanaged<ClipboardAsyncBox<@MainActor (Texture?) -> Void>>.fromOpaque(userData).takeRetainedValue()
                MainActor.assumeIsolated { box.closure(value) }
            },
            box
        )
    }

    /// Reads text from the clipboard using async/await.
    ///
    /// - Returns: The clipboard text, or nil if not available.
    public func readText() async -> String? {
        await withCheckedContinuation { continuation in
            readText { text in
                continuation.resume(returning: text)
            }
        }
    }

    /// Reads a texture (image) from the clipboard using async/await.
    ///
    /// - Returns: The texture, or nil if not available.
    public func readTexture() async -> Texture? {
        await withCheckedContinuation { continuation in
            readTexture { texture in
                continuation.resume(returning: texture)
            }
        }
    }

    /// Whether the clipboard content is local (set by this application).
    public var isLocal: Bool {
        gdk_clipboard_is_local(opaquePointer) != 0
    }

    /// Connects to the `changed` signal — clipboard content changed.
    @discardableResult
    public func onChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .changed, handler: handler)
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
