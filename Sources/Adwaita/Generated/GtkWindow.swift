// Auto-generated intermediate GTK class wrapper
import CAdwaita
import GObjectSupport

/// Minimal wrapper for GtkWindow.
@MainActor
public class GtkWindow: Widget {

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

    /// The transient parent of the window.
    ///
    /// Set this on dialogs or secondary windows so the window manager can
    /// position them relative to the parent.
    public var transientFor: GtkWindow? {
        get {
            guard let ptr = gtk_window_get_transient_for(windowPointer) else { return nil }
            return GtkWindow(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set {
            gtk_window_set_transient_for(
                windowPointer,
                newValue?.pointer.assumingMemoryBound(to: CAdwaita.GtkWindow.self)
            )
        }
    }

    /// The icon name for the window, used by the window manager.
    public var iconName: String? {
        get { gtk_window_get_icon_name(windowPointer).map { String(cString: $0) } }
        set { gtk_window_set_icon_name(windowPointer, newValue) }
    }

    /// Whether the window is resizable.
    public var resizable: Bool {
        get { gtk_window_get_resizable(windowPointer) != 0 }
        set { gtk_window_set_resizable(windowPointer, newValue ? 1 : 0) }
    }

    /// Whether the window is decorated (has title bar).
    public var decorated: Bool {
        get { gtk_window_get_decorated(windowPointer) != 0 }
        set { gtk_window_set_decorated(windowPointer, newValue ? 1 : 0) }
    }

    /// Whether the window should be destroyed when its parent is.
    public var destroyWithParent: Bool {
        get { gtk_window_get_destroy_with_parent(windowPointer) != 0 }
        set { gtk_window_set_destroy_with_parent(windowPointer, newValue ? 1 : 0) }
    }

    /// Whether the window is fullscreen.
    public var isFullscreen: Bool {
        gtk_window_is_fullscreen(windowPointer) != 0
    }

    /// Requests fullscreen mode.
    public func fullscreen() {
        gtk_window_fullscreen(windowPointer)
    }

    /// Exits fullscreen mode.
    public func unfullscreen() {
        gtk_window_unfullscreen(windowPointer)
    }

    /// Whether the window is maximized.
    public var isMaximized: Bool {
        gtk_window_is_maximized(windowPointer) != 0
    }

    /// Requests the window to be maximized.
    public func maximize() {
        gtk_window_maximize(windowPointer)
    }

    /// Unmaximizes the window.
    public func unmaximize() {
        gtk_window_unmaximize(windowPointer)
    }

    /// Minimizes the window.
    public func minimize() {
        gtk_window_minimize(windowPointer)
    }

    /// Connects to the `close-request` signal.
    /// Return `true` from the handler to prevent the window from closing.
    @discardableResult
    public func onCloseRequest(_ handler: @escaping @MainActor () -> Bool) -> SignalConnection {
        SignalHelper.connectReturnBool(self, signal: "close-request", handler: handler)
    }
}
