import CAdwaita
import GObjectSupport

/// A widget that displays a small amount of text.
///
/// Wraps `GtkLabel`.
@MainActor
public final class Label: Widget {
    /// Creates a label with the given text.
    public init(_ text: String) {
        let ptr = gtk_label_new(text)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The label text.
    public var text: String {
        get { String(cString: gtk_label_get_text(opaquePointer)) }
        set { gtk_label_set_text(opaquePointer, newValue) }
    }

    /// The label text with Pango markup.
    public var markup: String {
        get { String(cString: gtk_label_get_label(opaquePointer)) }
        set { gtk_label_set_markup(opaquePointer, newValue) }
    }

    /// Whether the label text can be selected by the user.
    public var selectable: Bool {
        get { gtk_label_get_selectable(opaquePointer) != 0 }
        set { gtk_label_set_selectable(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the label wraps text.
    public var wrap: Bool {
        get { gtk_label_get_wrap(opaquePointer) != 0 }
        set { gtk_label_set_wrap(opaquePointer, newValue ? 1 : 0) }
    }

    /// The horizontal alignment of text lines relative to each other.
    public var justify: GtkJustification {
        get { gtk_label_get_justify(opaquePointer) }
        set { gtk_label_set_justify(opaquePointer, newValue) }
    }

    /// The ellipsize mode.
    public var ellipsize: PangoEllipsizeMode {
        get { gtk_label_get_ellipsize(opaquePointer) }
        set { gtk_label_set_ellipsize(opaquePointer, newValue) }
    }

    /// Whether markup is used in the label.
    public var useMarkup: Bool {
        get { gtk_label_get_use_markup(opaquePointer) != 0 }
        set { gtk_label_set_use_markup(opaquePointer, newValue ? 1 : 0) }
    }

    /// The horizontal alignment.
    public var xalign: Float {
        get { gtk_label_get_xalign(opaquePointer) }
        set { gtk_label_set_xalign(opaquePointer, newValue) }
    }
}
