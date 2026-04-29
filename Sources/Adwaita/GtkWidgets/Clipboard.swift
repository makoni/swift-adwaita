import CAdwaita
import Foundation
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
    /// > Warning: Inside a GTK application use ``readText(completion:)``.
    /// > `Task { @MainActor in await readText() }` never runs under the GLib
    /// > main loop — Swift's default main actor executor is
    /// > `DispatchQueue.main`, which GLib does not drain. The `async` form
    /// > is intended for tests and non-GTK contexts.
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
    /// > Warning: Inside a GTK application use ``readTexture(completion:)``
    /// > — see the warning on ``readText()`` for why.
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

    /// Reads text from the clipboard; completion is invoked on the main
    /// actor from the GLib main loop.
    ///
    /// Prefer this over ``readText()`` inside GTK applications: Swift's
    /// default main actor executor is `DispatchQueue.main`, which the
    /// GLib main loop does not drain, so `Task { @MainActor in await
    /// readText() }` bodies never execute.
    public func readText(completion: @escaping @MainActor (String?) -> Void) {
        let box = DialogAsyncSupport.retainBox(completion)
        gdk_clipboard_read_text_async(
            opaquePointer,
            nil,
            { source, result, userData in
                Clipboard.finishTextCallback(userData: userData, source: source, result: result)
            },
            box
        )
    }

    /// Reads a texture (image) from the clipboard; completion is invoked on
    /// the main actor from the GLib main loop.
    ///
    /// Callback-based counterpart to ``readTexture()``.
    public func readTexture(completion: @escaping @MainActor (Texture?) -> Void) {
        let box = DialogAsyncSupport.retainBox(completion)
        gdk_clipboard_read_texture_async(
            opaquePointer,
            nil,
            { source, result, userData in
                Clipboard.finishTextureCallback(userData: userData, source: source, result: result)
            },
            box
        )
    }

    /// Whether the clipboard content is local (set by this application).
    public var isLocal: Bool {
        gdk_clipboard_is_local(opaquePointer) != 0
    }

    /// Synchronously reports whether the clipboard advertises an
    /// image. Useful for paste-handler fast-paths that need to decide
    /// whether to intercept the `paste-clipboard` signal before
    /// kicking off the asynchronous ``readTexture(completion:)`` —
    /// reading the texture is async, but choosing whether to
    /// short-circuit the default text-paste behaviour has to happen
    /// in the same call frame as the signal.
    public var containsImage: Bool {
        guard let formats = gdk_clipboard_get_formats(opaquePointer) else {
            return false
        }
        return gdk_content_formats_contain_gtype(formats, gdk_texture_get_type()) != 0
    }

    /// Synchronously reports whether the clipboard advertises a file
    /// list — for example when the user copies items in a file
    /// manager (Nautilus, Files, …). Symmetric with ``containsImage``:
    /// lets a paste-handler decide whether to intercept the
    /// `paste-clipboard` signal for file-manager copies before
    /// kicking off the asynchronous ``readFiles(completion:)``.
    public var containsFiles: Bool {
        guard let formats = gdk_clipboard_get_formats(opaquePointer) else {
            return false
        }
        return gdk_content_formats_contain_gtype(formats, gdk_file_list_get_type()) != 0
    }

    /// Reads the file list from the clipboard. Completion gets a
    /// (possibly empty) array of `file://` URLs.
    public func readFiles(completion: @escaping @MainActor ([URL]) -> Void) {
        let box = DialogAsyncSupport.retainBox(completion)
        gdk_clipboard_read_value_async(
            opaquePointer,
            gdk_file_list_get_type(),
            Int32(G_PRIORITY_DEFAULT),
            nil,
            { source, result, userData in
                Clipboard.finishFilesCallback(userData: userData, source: source, result: result)
            },
            box
        )
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

    static func finishTextCallback(
        userData: UnsafeMutableRawPointer?,
        source: UnsafeMutablePointer<GObject>?,
        result: OpaquePointer?
    ) {
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
        let cStr = gdk_clipboard_read_text_finish(OpaquePointer(source), result, &error)
        if let error { g_error_free(error) }
        guard let cStr else {
            MainActor.assumeIsolated { box.closure(nil) }
            return
        }
        let text = String(cString: cStr)
        g_free(gpointer(mutating: cStr))
        MainActor.assumeIsolated { box.closure(text) }
    }

    static func finishTextureCallback(
        userData: UnsafeMutableRawPointer?,
        source: UnsafeMutablePointer<GObject>?,
        result: OpaquePointer?
    ) {
        let box = DialogAsyncSupport.takeBox(
            userData,
            as: (@MainActor (Texture?) -> Void).self,
            context: #function
        )
        guard let source, let result else {
            MainActor.assumeIsolated { box.closure(nil) }
            return
        }
        var error: UnsafeMutablePointer<GError>?
        let texture = gdk_clipboard_read_texture_finish(OpaquePointer(source), result, &error)
        if let error { g_error_free(error) }
        guard let texture else {
            MainActor.assumeIsolated { box.closure(nil) }
            return
        }
        let wrapped = Texture(raw: UnsafeMutableRawPointer(texture))
        MainActor.assumeIsolated { box.closure(wrapped) }
    }

    static func finishFilesCallback(
        userData: UnsafeMutableRawPointer?,
        source: UnsafeMutablePointer<GObject>?,
        result: OpaquePointer?
    ) {
        let box = DialogAsyncSupport.takeBox(
            userData,
            as: (@MainActor ([URL]) -> Void).self,
            context: #function
        )
        guard let source, let result else {
            MainActor.assumeIsolated { box.closure([]) }
            return
        }
        var error: UnsafeMutablePointer<GError>?
        let valuePtr = gdk_clipboard_read_value_finish(OpaquePointer(source), result, &error)
        if let error { g_error_free(error) }
        guard let valuePtr,
              let fileList = cadw_value_get_file_list(valuePtr) else {
            MainActor.assumeIsolated { box.closure([]) }
            return
        }
        var urls: [URL] = []
        let head = gdk_file_list_get_files(fileList)
        var node = head
        while let current = node {
            if let filePtr = current.pointee.data {
                let cFile = OpaquePointer(filePtr)
                if let cURI = g_file_get_uri(cFile) {
                    let uri = String(cString: cURI)
                    g_free(gpointer(mutating: cURI))
                    if let url = URL(string: uri) {
                        urls.append(url)
                    }
                }
            }
            node = current.pointee.next
        }
        // `gdk_file_list_get_files` returns a GSList we own (the
        // contained `GFile*`s remain owned by the GValue), so free
        // the container but leave the entries alone.
        if head != nil {
            g_slist_free(head)
        }
        MainActor.assumeIsolated { box.closure(urls) }
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
