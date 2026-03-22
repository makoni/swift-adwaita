import CAdwaita
import GObjectSupport

/// A multi-line text editing widget.
///
/// Wraps `GtkTextView`.
@MainActor
public final class TextView: Widget {
    /// Creates a new text view.
    public init() {
        let ptr = gtk_text_view_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The text content of the text view.
    public var text: String {
        get {
            let buffer = gtk_text_view_get_buffer(castedPointer())
            var start = GtkTextIter()
            var end = GtkTextIter()
            gtk_text_buffer_get_start_iter(buffer, &start)
            gtk_text_buffer_get_end_iter(buffer, &end)
            guard let cStr = gtk_text_buffer_get_text(buffer, &start, &end, 0) else {
                return ""
            }
            let result = String(cString: cStr)
            g_free(UnsafeMutableRawPointer(mutating: cStr))
            return result
        }
        set {
            let buffer = gtk_text_view_get_buffer(castedPointer())
            gtk_text_buffer_set_text(buffer, newValue, Int32(newValue.utf8.count))
        }
    }

    /// Whether the text view is editable.
    public var editable: Bool {
        get { gtk_text_view_get_editable(castedPointer()) != 0 }
        set { gtk_text_view_set_editable(castedPointer(), newValue ? 1 : 0) }
    }

    /// Whether the text wraps.
    public var wrapMode: GtkWrapMode {
        get { gtk_text_view_get_wrap_mode(castedPointer()) }
        set { gtk_text_view_set_wrap_mode(castedPointer(), newValue) }
    }

    /// Whether the cursor is visible.
    public var cursorVisible: Bool {
        get { gtk_text_view_get_cursor_visible(castedPointer()) != 0 }
        set { gtk_text_view_set_cursor_visible(castedPointer(), newValue ? 1 : 0) }
    }

    /// Whether the text view is monospace.
    public var monospace: Bool {
        get { gtk_text_view_get_monospace(castedPointer()) != 0 }
        set { gtk_text_view_set_monospace(castedPointer(), newValue ? 1 : 0) }
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

    /// The underlying `TextBuffer`.
    public var buffer: TextBuffer {
        get {
            let ptr = gtk_text_view_get_buffer(castedPointer())!
            return TextBuffer(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set {
            gtk_text_view_set_buffer(castedPointer(), newValue.castedPointer())
        }
    }

    /// The justification of the text.
    public var justification: GtkJustification {
        get { gtk_text_view_get_justification(castedPointer()) }
        set { gtk_text_view_set_justification(castedPointer(), newValue) }
    }

    /// Whether the text view accepts tab characters.
    public var acceptsTab: Bool {
        get { gtk_text_view_get_accepts_tab(castedPointer()) != 0 }
        set { gtk_text_view_set_accepts_tab(castedPointer(), newValue ? 1 : 0) }
    }

    /// The number of pixels to indent wrapped lines (beyond the first line).
    public var indent: Int {
        get { Int(gtk_text_view_get_indent(castedPointer())) }
        set { gtk_text_view_set_indent(castedPointer(), Int32(newValue)) }
    }

    /// Whether the text view has overwrite mode enabled.
    public var overwrite: Bool {
        get { gtk_text_view_get_overwrite(castedPointer()) != 0 }
        set { gtk_text_view_set_overwrite(castedPointer(), newValue ? 1 : 0) }
    }

    /// Connects to the buffer's `changed` signal (text was modified).
    @discardableResult
    public func onChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        let buf = gtk_text_view_get_buffer(castedPointer())!
        let bufRef = GObjectRef(borrowing: UnsafeMutableRawPointer(buf))
        return SignalHelper.connect(bufRef, signal: "changed", handler: handler)
    }
}
