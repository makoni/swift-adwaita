import CAdwaita
import CGtkSource
import GObjectSupport

/// A source-code editor widget built on `GtkSourceView`.
///
/// Use it together with ``SourceBuffer`` to get syntax highlighting,
/// line numbers, current-line highlighting, and indentation helpers.
@MainActor
public final class SourceView: Widget {
    override public class var gtkType: GType {
        gtk_source_view_get_type()
    }

    /// Creates a new source view with a default ``SourceBuffer``.
    public init() {
        let ptr = gtk_source_view_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a new source view backed by the given buffer.
    public init(buffer: SourceBuffer) {
        let ptr = gtk_source_view_new_with_buffer(buffer.castedPointer())!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    private var sourceViewPointer: UnsafeMutablePointer<GtkSourceView> {
        castedPointer()
    }

    /// The underlying source buffer.
    public var buffer: SourceBuffer {
        get {
            let ptr = gtk_text_view_get_buffer(castedPointer())!
            return SourceBuffer(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set {
            gtk_text_view_set_buffer(castedPointer(), newValue.castedPointer())
        }
    }

    /// The text content of the source buffer.
    public var text: String {
        get { buffer.text }
        set { buffer.text = newValue }
    }

    /// Whether the view is editable.
    public var editable: Bool {
        get { gtk_text_view_get_editable(castedPointer()) != 0 }
        set { gtk_text_view_set_editable(castedPointer(), newValue ? 1 : 0) }
    }

    /// Whether the view uses a monospace font.
    public var monospace: Bool {
        get { gtk_text_view_get_monospace(castedPointer()) != 0 }
        set { gtk_text_view_set_monospace(castedPointer(), newValue ? 1 : 0) }
    }

    /// The wrap mode used when lines exceed the available width.
    public var wrapMode: GtkWrapMode {
        get { gtk_text_view_get_wrap_mode(castedPointer()) }
        set { gtk_text_view_set_wrap_mode(castedPointer(), newValue) }
    }

    /// Whether the cursor is visible.
    public var cursorVisible: Bool {
        get { gtk_text_view_get_cursor_visible(castedPointer()) != 0 }
        set { gtk_text_view_set_cursor_visible(castedPointer(), newValue ? 1 : 0) }
    }

    /// The left margin in pixels.
    public var leftMargin: Int {
        get { Int(gtk_text_view_get_left_margin(castedPointer())) }
        set { gtk_text_view_set_left_margin(castedPointer(), Int32(newValue)) }
    }

    /// The right margin in pixels.
    public var rightMargin: Int {
        get { Int(gtk_text_view_get_right_margin(castedPointer())) }
        set { gtk_text_view_set_right_margin(castedPointer(), Int32(newValue)) }
    }

    /// The top margin in pixels.
    public var topMargin: Int {
        get { Int(gtk_text_view_get_top_margin(castedPointer())) }
        set { gtk_text_view_set_top_margin(castedPointer(), Int32(newValue)) }
    }

    /// The bottom margin in pixels.
    public var bottomMargin: Int {
        get { Int(gtk_text_view_get_bottom_margin(castedPointer())) }
        set { gtk_text_view_set_bottom_margin(castedPointer(), Int32(newValue)) }
    }

    /// Whether line numbers are shown.
    public var showLineNumbers: Bool {
        get { gtk_source_view_get_show_line_numbers(sourceViewPointer) != 0 }
        set { gtk_source_view_set_show_line_numbers(sourceViewPointer, newValue ? 1 : 0) }
    }

    /// Whether the current line is highlighted.
    public var highlightCurrentLine: Bool {
        get { gtk_source_view_get_highlight_current_line(sourceViewPointer) != 0 }
        set { gtk_source_view_set_highlight_current_line(sourceViewPointer, newValue ? 1 : 0) }
    }

    /// Whether auto indentation is enabled.
    public var autoIndent: Bool {
        get { gtk_source_view_get_auto_indent(sourceViewPointer) != 0 }
        set { gtk_source_view_set_auto_indent(sourceViewPointer, newValue ? 1 : 0) }
    }

    /// Whether pressing Tab inserts spaces instead of tab characters.
    public var insertSpacesInsteadOfTabs: Bool {
        get { gtk_source_view_get_insert_spaces_instead_of_tabs(sourceViewPointer) != 0 }
        set { gtk_source_view_set_insert_spaces_instead_of_tabs(sourceViewPointer, newValue ? 1 : 0) }
    }

    /// The tab width in spaces.
    public var tabWidth: Int {
        get { Int(gtk_source_view_get_tab_width(sourceViewPointer)) }
        set { gtk_source_view_set_tab_width(sourceViewPointer, UInt32(newValue)) }
    }

    /// Whether to draw a right margin guide.
    public var showRightMargin: Bool {
        get { gtk_source_view_get_show_right_margin(sourceViewPointer) != 0 }
        set { gtk_source_view_set_show_right_margin(sourceViewPointer, newValue ? 1 : 0) }
    }

    /// The column where the right margin guide is drawn.
    public var rightMarginPosition: Int {
        get { Int(gtk_source_view_get_right_margin_position(sourceViewPointer)) }
        set { gtk_source_view_set_right_margin_position(sourceViewPointer, UInt32(newValue)) }
    }

    /// Emitted when the buffer content changes.
    @discardableResult
    public func onChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        buffer.onChanged(handler)
    }
}
