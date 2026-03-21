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
    public var defaultWidth: Int32 {
        get {
            var w: Int32 = 0
            gtk_window_get_default_size(castedPointer(), &w, nil)
            return w
        }
        set {
            var h: Int32 = 0
            gtk_window_get_default_size(castedPointer(), nil, &h)
            gtk_window_set_default_size(castedPointer(), newValue, h)
        }
    }

    /// The default height of the window.
    public var defaultHeight: Int32 {
        get {
            var h: Int32 = 0
            gtk_window_get_default_size(castedPointer(), nil, &h)
            return h
        }
        set {
            var w: Int32 = 0
            gtk_window_get_default_size(castedPointer(), &w, nil)
            gtk_window_set_default_size(castedPointer(), w, newValue)
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
}
