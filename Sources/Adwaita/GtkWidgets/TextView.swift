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
}
