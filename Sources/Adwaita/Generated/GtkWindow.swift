// Auto-generated intermediate GTK class wrapper
import CAdwaita
import GObjectSupport

/// Minimal wrapper for GtkWindow.
@MainActor
open class GtkWindow: Widget {

    private var windowPointer: UnsafeMutablePointer<CAdwaita.GtkWindow> {
        pointer.assumingMemoryBound(to: CAdwaita.GtkWindow.self)
    }

    /// Presents the window to the user.
    public func present() {
        gtk_window_present(windowPointer)
    }

    /// The window title.
    public var title: String? {
        get { gtk_window_get_title(windowPointer).map { String(cString: $0) } }
        set { gtk_window_set_title(windowPointer, newValue) }
    }

    /// The default width of the window.
    public var defaultWidth: Int {
        get {
            var w: Int32 = 0
            var h: Int32 = 0
            gtk_window_get_default_size(windowPointer, &w, &h)
            return Int(w)
        }
        set {
            var h: Int32 = 0
            gtk_window_get_default_size(windowPointer, nil, &h)
            gtk_window_set_default_size(windowPointer, Int32(newValue), h)
        }
    }

    /// The default height of the window.
    public var defaultHeight: Int {
        get {
            var w: Int32 = 0
            var h: Int32 = 0
            gtk_window_get_default_size(windowPointer, &w, &h)
            return Int(h)
        }
        set {
            var w: Int32 = 0
            gtk_window_get_default_size(windowPointer, &w, nil)
            gtk_window_set_default_size(windowPointer, w, Int32(newValue))
        }
    }

    /// Whether the window is modal.
    public var modal: Bool {
        get { gtk_window_get_modal(windowPointer) != 0 }
        set { gtk_window_set_modal(windowPointer, newValue ? 1 : 0) }
    }

    /// Closes the window.
    public func close() {
        gtk_window_close(windowPointer)
    }

    /// Connects to the `close-request` signal.
    /// Return `true` from the handler to prevent the window from closing.
    @discardableResult
    public func onCloseRequest(_ handler: @escaping @MainActor () -> Bool) -> SignalConnection {
        SignalHelper.connectReturnBool(self, signal: "close-request", handler: handler)
    }
}
