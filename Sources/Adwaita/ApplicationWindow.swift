import CAdwaita
import GObjectSupport

/// An Adwaita application window.
///
/// Wraps `AdwApplicationWindow`, which provides adaptive layout features
/// on top of `GtkApplicationWindow`.
@MainActor
public final class ApplicationWindow: Widget {
    /// Creates a new application window.
    ///
    /// - Parameter application: The application this window belongs to.
    public init(application: Application) {
        let ptr = adw_application_window_new(application.gtkApplicationPointer)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The underlying `AdwApplicationWindow` pointer.
    public var adwWindowPointer: UnsafeMutablePointer<AdwApplicationWindow> {
        castedPointer()
    }

    /// The content widget of the window.
    public var content: Widget? {
        get {
            guard let ptr = adw_application_window_get_content(adwWindowPointer) else {
                return nil
            }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set {
            adw_application_window_set_content(adwWindowPointer, newValue?.widgetPointer)
        }
    }

    /// Sets the content using the raw widget pointer (avoids double-wrapping).
    public func setContent(_ widget: Widget) {
        adw_application_window_set_content(adwWindowPointer, widget.widgetPointer)
    }

    /// Presents the window to the user.
    public func present() {
        gtk_window_present(castedPointer())
    }

    /// The default width of the window.
    public var defaultWidth: Int {
        get {
            var w: Int32 = 0
            gtk_window_get_default_size(castedPointer(), &w, nil)
            return Int(w)
        }
        set {
            var h: Int32 = 0
            gtk_window_get_default_size(castedPointer(), nil, &h)
            gtk_window_set_default_size(castedPointer(), Int32(newValue), h)
        }
    }

    /// The default height of the window.
    public var defaultHeight: Int {
        get {
            var h: Int32 = 0
            gtk_window_get_default_size(castedPointer(), nil, &h)
            return Int(h)
        }
        set {
            var w: Int32 = 0
            gtk_window_get_default_size(castedPointer(), &w, nil)
            gtk_window_set_default_size(castedPointer(), w, Int32(newValue))
        }
    }

    /// The title of the window.
    public var title: String? {
        get {
            guard let cStr = gtk_window_get_title(castedPointer()) else { return nil }
            return String(cString: cStr)
        }
        set {
            gtk_window_set_title(castedPointer(), newValue)
        }
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    // MARK: - Window State

    /// Requests fullscreen mode.
    public func fullscreen() {
        gtk_window_fullscreen(castedPointer())
    }

    /// Exits fullscreen mode.
    public func unfullscreen() {
        gtk_window_unfullscreen(castedPointer())
    }

    /// Whether the window is fullscreen.
    public var isFullscreen: Bool {
        gtk_window_is_fullscreen(castedPointer()) != 0
    }

    /// Requests the window to be maximized.
    public func maximize() {
        gtk_window_maximize(castedPointer())
    }

    /// Unmaximizes the window.
    public func unmaximize() {
        gtk_window_unmaximize(castedPointer())
    }

    /// Whether the window is maximized.
    public var isMaximized: Bool {
        gtk_window_is_maximized(castedPointer()) != 0
    }

    /// Minimizes the window.
    public func minimize() {
        gtk_window_minimize(castedPointer())
    }

    /// Closes the window.
    public func close() {
        gtk_window_close(castedPointer())
    }

    /// Whether the window is modal.
    public var modal: Bool {
        get { gtk_window_get_modal(castedPointer()) != 0 }
        set { gtk_window_set_modal(castedPointer(), newValue ? 1 : 0) }
    }

    /// The icon name for the window, used by the window manager.
    public var iconName: String? {
        get { gtk_window_get_icon_name(castedPointer()).map { String(cString: $0) } }
        set { gtk_window_set_icon_name(castedPointer(), newValue) }
    }

    /// Whether the window is resizable.
    public var resizable: Bool {
        get { gtk_window_get_resizable(castedPointer()) != 0 }
        set { gtk_window_set_resizable(castedPointer(), newValue ? 1 : 0) }
    }

    /// Whether the window is decorated (has title bar).
    public var decorated: Bool {
        get { gtk_window_get_decorated(castedPointer()) != 0 }
        set { gtk_window_set_decorated(castedPointer(), newValue ? 1 : 0) }
    }

    /// Whether the window should be destroyed when its parent is.
    public var destroyWithParent: Bool {
        get { gtk_window_get_destroy_with_parent(castedPointer()) != 0 }
        set { gtk_window_set_destroy_with_parent(castedPointer(), newValue ? 1 : 0) }
    }

    /// Connects to the `close-request` signal.
    /// Return `true` from the handler to prevent the window from closing.
    @discardableResult
    public func onCloseRequest(_ handler: @escaping @MainActor () -> Bool) -> SignalConnection {
        SignalHelper.connectReturnBool(self, signal: "close-request", handler: handler)
    }

    /// The transient parent of the window (for dialogs).
    public var transientFor: Widget? {
        get {
            guard let ptr = gtk_window_get_transient_for(castedPointer()) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set {
            if let parent = newValue {
                gtk_window_set_transient_for(castedPointer(), parent.castedPointer())
            } else {
                gtk_window_set_transient_for(castedPointer(), nil)
            }
        }
    }
}
