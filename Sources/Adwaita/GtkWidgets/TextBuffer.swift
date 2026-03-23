import CAdwaita
import GObjectSupport

/// A text buffer for use with `TextView`.
///
/// Wraps `GtkTextBuffer`. Provides rich text editing capabilities
/// including insertion, deletion, marks, and tags.
@MainActor
public final class TextBuffer: GObjectRef {
    /// Creates a new empty text buffer.
    public init() {
        let ptr = gtk_text_buffer_new(nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    private var bufferPointer: UnsafeMutablePointer<GtkTextBuffer> { castedPointer() }

    /// The entire text content of the buffer.
    public var text: String {
        get {
            var start = GtkTextIter()
            var end = GtkTextIter()
            gtk_text_buffer_get_start_iter(bufferPointer, &start)
            gtk_text_buffer_get_end_iter(bufferPointer, &end)
            guard let cStr = gtk_text_buffer_get_text(bufferPointer, &start, &end, 0) else {
                return ""
            }
            let result = String(cString: cStr)
            g_free(UnsafeMutableRawPointer(mutating: cStr))
            return result
        }
        set {
            gtk_text_buffer_set_text(bufferPointer, newValue, Int32(newValue.utf8.count))
        }
    }

    /// The number of characters in the buffer.
    public var charCount: Int {
        Int(gtk_text_buffer_get_char_count(bufferPointer))
    }

    /// The number of lines in the buffer.
    public var lineCount: Int {
        Int(gtk_text_buffer_get_line_count(bufferPointer))
    }

    /// Whether the buffer has been modified since the last call to `modified = false`.
    public var modified: Bool {
        get { gtk_text_buffer_get_modified(bufferPointer) != 0 }
        set { gtk_text_buffer_set_modified(bufferPointer, newValue ? 1 : 0) }
    }

    /// Whether the buffer has a selection.
    public var hasSelection: Bool {
        gtk_text_buffer_get_has_selection(bufferPointer) != 0
    }

    /// The currently selected text, or an empty string if no selection.
    public var selectedText: String {
        var start = GtkTextIter()
        var end = GtkTextIter()
        guard gtk_text_buffer_get_selection_bounds(bufferPointer, &start, &end) != 0 else {
            return ""
        }
        guard let cStr = gtk_text_buffer_get_text(bufferPointer, &start, &end, 0) else {
            return ""
        }
        let result = String(cString: cStr)
        g_free(UnsafeMutableRawPointer(mutating: cStr))
        return result
    }

    /// Inserts text at the cursor position.
    public func insertAtCursor(_ text: String) {
        gtk_text_buffer_insert_at_cursor(bufferPointer, text, Int32(text.utf8.count))
    }

    /// Deletes the currently selected text.
    public func deleteSelection(interactive: Bool = false, defaultEditable: Bool = true) {
        gtk_text_buffer_delete_selection(bufferPointer, interactive ? 1 : 0, defaultEditable ? 1 : 0)
    }

    /// Selects all text in the buffer.
    public func selectAll() {
        var start = GtkTextIter()
        var end = GtkTextIter()
        gtk_text_buffer_get_start_iter(bufferPointer, &start)
        gtk_text_buffer_get_end_iter(bufferPointer, &end)
        gtk_text_buffer_select_range(bufferPointer, &start, &end)
    }

    /// Places the cursor at the beginning of the buffer.
    public func placeCursorAtStart() {
        var iter = GtkTextIter()
        gtk_text_buffer_get_start_iter(bufferPointer, &iter)
        gtk_text_buffer_place_cursor(bufferPointer, &iter)
    }

    /// Places the cursor at the end of the buffer.
    public func placeCursorAtEnd() {
        var iter = GtkTextIter()
        gtk_text_buffer_get_end_iter(bufferPointer, &iter)
        gtk_text_buffer_place_cursor(bufferPointer, &iter)
    }

    /// Begins a user-visible operation that can be undone as a unit.
    public func beginUserAction() {
        gtk_text_buffer_begin_user_action(bufferPointer)
    }

    /// Ends a user-visible operation started with `beginUserAction()`.
    public func endUserAction() {
        gtk_text_buffer_end_user_action(bufferPointer)
    }

    /// Connects to the `changed` signal.
    @discardableResult
    public func onChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "changed", handler: handler)
    }

    /// Connects to the `modified-changed` signal.
    @discardableResult
    public func onModifiedChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "modified-changed", handler: handler)
    }

    // MARK: - Tags

    /// Creates and registers a text tag with the given name.
    ///
    /// Returns the tag for further property configuration via GObject properties.
    public func createTag(name: String?) -> TextTag {
        let tag = TextTag(name: name)
        let table = gtk_text_buffer_get_tag_table(bufferPointer)!
        gtk_text_tag_table_add(table, tag.castedPointer())
        return tag
    }

    /// Applies a tag to the text range [startOffset, endOffset).
    public func applyTag(_ tag: TextTag, startOffset: Int, endOffset: Int) {
        var start = GtkTextIter()
        var end = GtkTextIter()
        gtk_text_buffer_get_iter_at_offset(bufferPointer, &start, Int32(startOffset))
        gtk_text_buffer_get_iter_at_offset(bufferPointer, &end, Int32(endOffset))
        gtk_text_buffer_apply_tag(bufferPointer, tag.castedPointer(), &start, &end)
    }

    /// Removes a tag from the text range [startOffset, endOffset).
    public func removeTag(_ tag: TextTag, startOffset: Int, endOffset: Int) {
        var start = GtkTextIter()
        var end = GtkTextIter()
        gtk_text_buffer_get_iter_at_offset(bufferPointer, &start, Int32(startOffset))
        gtk_text_buffer_get_iter_at_offset(bufferPointer, &end, Int32(endOffset))
        gtk_text_buffer_remove_tag(bufferPointer, tag.castedPointer(), &start, &end)
    }

    /// Removes all tags from the text range [startOffset, endOffset).
    public func removeAllTags(startOffset: Int, endOffset: Int) {
        var start = GtkTextIter()
        var end = GtkTextIter()
        gtk_text_buffer_get_iter_at_offset(bufferPointer, &start, Int32(startOffset))
        gtk_text_buffer_get_iter_at_offset(bufferPointer, &end, Int32(endOffset))
        gtk_text_buffer_remove_all_tags(bufferPointer, &start, &end)
    }

    // MARK: - Undo / Redo

    /// Whether undo is enabled on this buffer.
    public var enableUndo: Bool {
        get { gtk_text_buffer_get_enable_undo(bufferPointer) != 0 }
        set { gtk_text_buffer_set_enable_undo(bufferPointer, newValue ? 1 : 0) }
    }

    /// Whether an undo action is available.
    public var canUndo: Bool {
        gtk_text_buffer_get_can_undo(bufferPointer) != 0
    }

    /// Whether a redo action is available.
    public var canRedo: Bool {
        gtk_text_buffer_get_can_redo(bufferPointer) != 0
    }

    /// Undoes the last user action.
    public func undo() {
        gtk_text_buffer_undo(bufferPointer)
    }

    /// Redoes the last undone user action.
    public func redo() {
        gtk_text_buffer_redo(bufferPointer)
    }
}
