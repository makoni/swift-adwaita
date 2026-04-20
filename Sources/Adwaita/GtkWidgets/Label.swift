import CAdwaita
import GObjectSupport

/// A widget that displays a small-to-medium amount of text.
///
/// `Label` can show plain text, Pango-markup-styled text, or selectable text.
/// It supports line wrapping, ellipsization, and alignment control.
///
/// Wraps [GtkLabel](https://docs.gtk.org/gtk4/class.Label.html).
///
/// ## Examples
///
/// A simple text label:
/// ```swift
/// let label = Label("Hello, World!")
/// ```
///
/// A label styled with a CSS class:
/// ```swift
/// let title = Label("Settings")
/// title.addCssClass("title-1")
/// ```
///
/// A wrapping, left-aligned label:
/// ```swift
/// let description = Label("This is a long description that will wrap.")
/// description.wrap = true
/// description.xalign = 0
/// ```
///
/// A label with Pango markup:
/// ```swift
/// let rich = Label("")
/// rich.markup = "<b>Bold</b> and <i>italic</i> text"
/// ```
@MainActor
public final class Label: Widget {
    /// Creates a label with the given text.
    public init(_ text: String) {
        let ptr = gtk_label_new(text)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    override public class var gtkType: GType {
        gtk_label_get_type()
    }

    /// The plain text content of the label.
    ///
    /// Setting this property replaces the current text. Any markup is stripped.
    /// Use ``markup`` to set styled text with Pango markup.
    public var text: String {
        get { String(cString: gtk_label_get_text(opaquePointer)) }
        set { gtk_label_set_text(opaquePointer, newValue) }
    }

    /// The label text with Pango markup for rich text styling.
    ///
    /// Supports tags like `<b>`, `<i>`, `<u>`, `<span>`, etc.
    /// See the [Pango Markup](https://docs.gtk.org/Pango/pango_markup.html)
    /// documentation for the full syntax.
    public var markup: String {
        get { String(cString: gtk_label_get_label(opaquePointer)) }
        set { gtk_label_set_markup(opaquePointer, newValue) }
    }

    /// Whether the user can select and copy the label text.
    ///
    /// When `true`, the user can highlight text with the mouse or keyboard
    /// and copy it to the clipboard.
    public var selectable: Bool {
        get { gtk_label_get_selectable(opaquePointer) != 0 }
        set { gtk_label_set_selectable(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the label wraps long lines of text to fit the available width.
    ///
    /// When `false` (the default), the label requests enough width to display
    /// the full text on one line. When `true`, the text wraps at word boundaries.
    public var wrap: Bool {
        get { gtk_label_get_wrap(opaquePointer) != 0 }
        set { gtk_label_set_wrap(opaquePointer, newValue ? 1 : 0) }
    }

    /// The horizontal alignment of text lines relative to each other
    /// (e.g., `GTK_JUSTIFY_LEFT`, `GTK_JUSTIFY_CENTER`, `GTK_JUSTIFY_RIGHT`).
    ///
    /// This only affects multi-line labels. For single-line labels, use ``xalign``.
    public var justify: GtkJustification {
        get { gtk_label_get_justify(opaquePointer) }
        set { gtk_label_set_justify(opaquePointer, newValue) }
    }

    /// The ellipsization mode that controls where text is truncated with "..."
    /// when it does not fit (e.g., `PANGO_ELLIPSIZE_END`).
    ///
    /// Use with ``maxWidthChars`` or ``widthChars`` to constrain the label width.
    public var ellipsize: PangoEllipsizeMode {
        get { gtk_label_get_ellipsize(opaquePointer) }
        set { gtk_label_set_ellipsize(opaquePointer, newValue) }
    }

    /// Whether the label text is interpreted as Pango markup.
    ///
    /// This is automatically set to `true` when you use the ``markup`` property.
    public var useMarkup: Bool {
        get { gtk_label_get_use_markup(opaquePointer) != 0 }
        set { gtk_label_set_use_markup(opaquePointer, newValue ? 1 : 0) }
    }

    /// The horizontal alignment of the label within its allocated area.
    ///
    /// `0.0` is left-aligned, `0.5` is centered, `1.0` is right-aligned.
    public var xalign: Float {
        get { gtk_label_get_xalign(opaquePointer) }
        set { gtk_label_set_xalign(opaquePointer, newValue) }
    }

    /// The vertical alignment of the label within its allocated area.
    ///
    /// `0.0` is top-aligned, `0.5` is centered, `1.0` is bottom-aligned.
    public var yalign: Float {
        get { gtk_label_get_yalign(opaquePointer) }
        set { gtk_label_set_yalign(opaquePointer, newValue) }
    }

    /// The maximum width of the label in characters, or -1 for no limit.
    ///
    /// This sets an upper bound on the label's natural width. Combine with
    /// ``ellipsize`` to truncate text that exceeds this width.
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

    /// The Pango wrap mode used when wrapping long lines.
    ///
    /// Controls how wrapping occurs when ``wrap`` is `true`. Common modes are
    /// `PANGO_WRAP_WORD` (wrap on word boundaries), `PANGO_WRAP_CHAR` (wrap on
    /// any character), and `PANGO_WRAP_WORD_CHAR` (wrap on word boundaries but
    /// fall back to character wrapping for very long words).
    public var pangoWrapMode: PangoWrapMode {
        get { gtk_label_get_wrap_mode(opaquePointer) }
        set { gtk_label_set_wrap_mode(opaquePointer, newValue) }
    }

    /// Emitted when a link in the label's markup is activated.
    ///
    /// The label must contain Pango markup with `<a href="...">`.
    ///
    /// - Parameter handler: Called with the activated URI.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onActivateLink(_ handler: @escaping @MainActor (String) -> Void) -> SignalConnection {
        SignalHelper.connectString(self, signal: .activateLink, handler: handler)
    }
}
