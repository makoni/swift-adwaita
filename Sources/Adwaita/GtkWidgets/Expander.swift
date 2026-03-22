import CAdwaita
import GObjectSupport

/// A container that can hide its child with a clickable expander arrow.
///
/// Wraps `GtkExpander`.
@MainActor
public final class Expander: Widget {
    /// Creates a new expander with the given label.
    public init(label: String? = nil) {
        let ptr = gtk_expander_new(label)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Whether the expander is expanded (child visible).
    public var expanded: Bool {
        get { gtk_expander_get_expanded(opaquePointer) != 0 }
        set { gtk_expander_set_expanded(opaquePointer, newValue ? 1 : 0) }
    }

    /// The label text.
    public var label: String? {
        get { gtk_expander_get_label(opaquePointer).map { String(cString: $0) } }
        set { gtk_expander_set_label(opaquePointer, newValue) }
    }

    /// A custom widget to use as the label instead of text.
    public var labelWidget: Widget? {
        get {
            guard let ptr = gtk_expander_get_label_widget(opaquePointer) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set {
            gtk_expander_set_label_widget(opaquePointer, newValue?.widgetPointer)
        }
    }

    /// The child widget.
    public var child: Widget? {
        get {
            guard let ptr = gtk_expander_get_child(opaquePointer) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set {
            gtk_expander_set_child(opaquePointer, newValue?.widgetPointer)
        }
    }

    /// Whether the label uses Pango markup.
    public var useMarkup: Bool {
        get { gtk_expander_get_use_markup(opaquePointer) != 0 }
        set { gtk_expander_set_use_markup(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether an underline in the label text acts as a mnemonic accelerator.
    public var useUnderline: Bool {
        get { gtk_expander_get_use_underline(opaquePointer) != 0 }
        set { gtk_expander_set_use_underline(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the expander resizes the toplevel window when expanded.
    public var resizeToplevel: Bool {
        get { gtk_expander_get_resize_toplevel(opaquePointer) != 0 }
        set { gtk_expander_set_resize_toplevel(opaquePointer, newValue ? 1 : 0) }
    }
}
