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
    public func setMargins(_ margin: Int32) {
        gtk_widget_set_margin_start(widgetPointer, margin)
        gtk_widget_set_margin_end(widgetPointer, margin)
        gtk_widget_set_margin_top(widgetPointer, margin)
        gtk_widget_set_margin_bottom(widgetPointer, margin)
    }
}
