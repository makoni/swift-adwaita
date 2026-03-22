import CAdwaita
import GObjectSupport

/// Base class for GTK widget wrappers.
@MainActor
open class Widget: GObjectRef {
    /// Returns the raw pointer as a `GtkWidget` pointer.
    public var widgetPointer: UnsafeMutablePointer<GtkWidget> {
        castedPointer()
    }

    /// Shows the widget.
    public func show() {
        gtk_widget_set_visible(widgetPointer, 1)
    }

    /// Hides the widget.
    public func hide() {
        gtk_widget_set_visible(widgetPointer, 0)
    }

    /// Whether the widget is visible.
    public var visible: Bool {
        get { gtk_widget_get_visible(widgetPointer) != 0 }
        set { gtk_widget_set_visible(widgetPointer, newValue ? 1 : 0) }
    }

    /// Whether the widget is sensitive (can receive input).
    public var sensitive: Bool {
        get { gtk_widget_get_sensitive(widgetPointer) != 0 }
        set { gtk_widget_set_sensitive(widgetPointer, newValue ? 1 : 0) }
    }

    /// Adds a CSS class to the widget.
    public func addCSSClass(_ cssClass: String) {
        gtk_widget_add_css_class(widgetPointer, cssClass)
    }

    /// Removes a CSS class from the widget.
    public func removeCSSClass(_ cssClass: String) {
        gtk_widget_remove_css_class(widgetPointer, cssClass)
    }

    /// Sets the horizontal expansion preference.
    public var hexpand: Bool {
        get { gtk_widget_get_hexpand(widgetPointer) != 0 }
        set { gtk_widget_set_hexpand(widgetPointer, newValue ? 1 : 0) }
    }

    /// Sets the vertical expansion preference.
    public var vexpand: Bool {
        get { gtk_widget_get_vexpand(widgetPointer) != 0 }
        set { gtk_widget_set_vexpand(widgetPointer, newValue ? 1 : 0) }
    }

    /// The horizontal alignment.
    public var halign: GtkAlign {
        get { gtk_widget_get_halign(widgetPointer) }
        set { gtk_widget_set_halign(widgetPointer, newValue) }
    }

    /// The vertical alignment.
    public var valign: GtkAlign {
        get { gtk_widget_get_valign(widgetPointer) }
        set { gtk_widget_set_valign(widgetPointer, newValue) }
    }

    /// Sets margin on all sides.
    public func setMargins(_ margin: Int) {
        let m = Int32(margin)
        gtk_widget_set_margin_start(widgetPointer, m)
        gtk_widget_set_margin_end(widgetPointer, m)
        gtk_widget_set_margin_top(widgetPointer, m)
        gtk_widget_set_margin_bottom(widgetPointer, m)
    }

    /// The tooltip text.
    public var tooltipText: String? {
        get { gtk_widget_get_tooltip_text(widgetPointer).map { String(cString: $0) } }
        set { gtk_widget_set_tooltip_text(widgetPointer, newValue) }
    }

    /// The tooltip markup.
    public var tooltipMarkup: String? {
        get { gtk_widget_get_tooltip_markup(widgetPointer).map { String(cString: $0) } }
        set { gtk_widget_set_tooltip_markup(widgetPointer, newValue) }
    }

    /// Sets the minimum size of the widget.
    public func setSizeRequest(width: Int = -1, height: Int = -1) {
        gtk_widget_set_size_request(widgetPointer, Int32(width), Int32(height))
    }

    /// Returns the root widget of the widget tree this widget belongs to.
    public var root: Widget? {
        guard let ptr = gtk_widget_get_root(widgetPointer) else { return nil }
        return Widget(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// The opacity of the widget, from 0.0 (fully transparent) to 1.0 (fully opaque).
    public var opacity: Double {
        get { gtk_widget_get_opacity(widgetPointer) }
        set { gtk_widget_set_opacity(widgetPointer, newValue) }
    }
}
