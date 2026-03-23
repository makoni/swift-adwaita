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

    required internal init(raw pointer: UnsafeMutableRawPointer) {
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

    /// The vertical alignment.
    public var yalign: Float {
        get { gtk_label_get_yalign(opaquePointer) }
        set { gtk_label_set_yalign(opaquePointer, newValue) }
    }

    /// The maximum width in characters (-1 for no limit).
    public var maxWidthChars: Int {
        get { Int(gtk_label_get_max_width_chars(opaquePointer)) }
        set { gtk_label_set_max_width_chars(opaquePointer, Int32(newValue)) }
    }

    /// The desired width in characters (-1 for automatic).
    public var widthChars: Int {
        get { Int(gtk_label_get_width_chars(opaquePointer)) }
        set { gtk_label_set_width_chars(opaquePointer, Int32(newValue)) }
    }

    /// The number of lines to show (-1 for no limit).
    public var lines: Int {
        get { Int(gtk_label_get_lines(opaquePointer)) }
        set { gtk_label_set_lines(opaquePointer, Int32(newValue)) }
    }

    /// The widget to activate when a mnemonic key is pressed.
    public var mnemonicWidget: Widget? {
        get {
            guard let ptr = gtk_label_get_mnemonic_widget(opaquePointer) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set { gtk_label_set_mnemonic_widget(opaquePointer, newValue?.widgetPointer) }
    }

    /// Whether the label uses underline for mnemonics.
    public var useUnderline: Bool {
        get { gtk_label_get_use_underline(opaquePointer) != 0 }
        set { gtk_label_set_use_underline(opaquePointer, newValue ? 1 : 0) }
    }

    /// The natural wrap mode.
    public var naturalWrapMode: GtkNaturalWrapMode {
        get { gtk_label_get_natural_wrap_mode(opaquePointer) }
        set { gtk_label_set_natural_wrap_mode(opaquePointer, newValue) }
    }
}
