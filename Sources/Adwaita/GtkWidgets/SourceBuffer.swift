import CAdwaita
import CGtkSource
import GObjectSupport

/// A text buffer with syntax highlighting support.
///
/// Wraps `GtkSourceBuffer`.
@MainActor
public final class SourceBuffer: GObjectRef {
    /// Creates a new empty source buffer.
    public init() {
        let ptr = gtk_source_buffer_new(nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a new source buffer configured for a specific language.
    public convenience init(language: SourceLanguage) {
        self.init()
        self.language = language
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    private var sourceBufferPointer: UnsafeMutablePointer<GtkSourceBuffer> {
        castedPointer()
    }

    private var textBufferPointer: UnsafeMutablePointer<GtkTextBuffer> {
        castedPointer()
    }

    /// The entire text content of the buffer.
    public var text: String {
        get {
            var start = GtkTextIter()
            var end = GtkTextIter()
            gtk_text_buffer_get_start_iter(textBufferPointer, &start)
            gtk_text_buffer_get_end_iter(textBufferPointer, &end)
            guard let cStr = gtk_text_buffer_get_text(textBufferPointer, &start, &end, 0) else {
                return ""
            }
            let result = String(cString: cStr)
            g_free(UnsafeMutableRawPointer(mutating: cStr))
            return result
        }
        set {
            gtk_text_buffer_set_text(textBufferPointer, newValue, Int32(newValue.utf8.count))
        }
    }

    /// Inserts text at the current cursor position.
    public func insertAtCursor(_ text: String) {
        gtk_text_buffer_insert_at_cursor(textBufferPointer, text, Int32(text.utf8.count))
    }

    /// Inserts text at the given character offset.
    public func insert(_ text: String, at offset: Int) {
        var iter = GtkTextIter()
        gtk_text_buffer_get_iter_at_offset(textBufferPointer, &iter, Int32(offset))
        gtk_text_buffer_insert(textBufferPointer, &iter, text, Int32(text.utf8.count))
    }

    /// Deletes text in the given character-offset range.
    public func delete(range: Range<Int>) {
        var start = GtkTextIter()
        var end = GtkTextIter()
        gtk_text_buffer_get_iter_at_offset(textBufferPointer, &start, Int32(range.lowerBound))
        gtk_text_buffer_get_iter_at_offset(textBufferPointer, &end, Int32(range.upperBound))
        gtk_text_buffer_delete(textBufferPointer, &start, &end)
    }

    /// Selects the text in the given character-offset range.
    public func select(range: Range<Int>) {
        var start = GtkTextIter()
        var end = GtkTextIter()
        gtk_text_buffer_get_iter_at_offset(textBufferPointer, &start, Int32(range.lowerBound))
        gtk_text_buffer_get_iter_at_offset(textBufferPointer, &end, Int32(range.upperBound))
        gtk_text_buffer_select_range(textBufferPointer, &start, &end)
    }

    /// The current selection as a character-offset range.
    ///
    /// When there is no active selection, returns an empty range at the
    /// current insertion cursor position.
    public var selectedRange: Range<Int> {
        var start = GtkTextIter()
        var end = GtkTextIter()
        if gtk_text_buffer_get_selection_bounds(textBufferPointer, &start, &end) != 0 {
            let lower = Int(gtk_text_iter_get_offset(&start))
            let upper = Int(gtk_text_iter_get_offset(&end))
            return lower ..< upper
        }
        guard let insertMark = gtk_text_buffer_get_insert(textBufferPointer) else {
            return 0 ..< 0
        }
        gtk_text_buffer_get_iter_at_mark(textBufferPointer, &start, insertMark)
        let offset = Int(gtk_text_iter_get_offset(&start))
        return offset ..< offset
    }

    /// Places the cursor at the given character offset.
    public func placeCursor(at offset: Int) {
        var iter = GtkTextIter()
        gtk_text_buffer_get_iter_at_offset(textBufferPointer, &iter, Int32(offset))
        gtk_text_buffer_place_cursor(textBufferPointer, &iter)
    }

    /// Begins a user-visible operation that can be undone as a unit.
    public func beginUserAction() {
        gtk_text_buffer_begin_user_action(textBufferPointer)
    }

    /// Ends a user-visible operation started with `beginUserAction()`.
    public func endUserAction() {
        gtk_text_buffer_end_user_action(textBufferPointer)
    }

    /// The configured syntax-highlighting language, if any.
    public var language: SourceLanguage? {
        get {
            guard let ptr = gtk_source_buffer_get_language(sourceBufferPointer) else { return nil }
            return SourceLanguage(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set {
            gtk_source_buffer_set_language(sourceBufferPointer, newValue?.opaquePointer)
        }
    }

    /// The configured style scheme, if any.
    public var styleScheme: SourceStyleScheme? {
        get {
            guard let ptr = gtk_source_buffer_get_style_scheme(sourceBufferPointer) else { return nil }
            return SourceStyleScheme(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set {
            gtk_source_buffer_set_style_scheme(sourceBufferPointer, newValue?.opaquePointer)
        }
    }

    /// Whether syntax highlighting is enabled.
    public var highlightSyntax: Bool {
        get { gtk_source_buffer_get_highlight_syntax(sourceBufferPointer) != 0 }
        set { gtk_source_buffer_set_highlight_syntax(sourceBufferPointer, newValue ? 1 : 0) }
    }

    /// Whether matching brackets are highlighted.
    public var highlightMatchingBrackets: Bool {
        get { gtk_source_buffer_get_highlight_matching_brackets(sourceBufferPointer) != 0 }
        set { gtk_source_buffer_set_highlight_matching_brackets(sourceBufferPointer, newValue ? 1 : 0) }
    }

    /// The number of characters in the buffer.
    public var charCount: Int {
        Int(gtk_text_buffer_get_char_count(textBufferPointer))
    }

    /// The number of lines in the buffer.
    public var lineCount: Int {
        Int(gtk_text_buffer_get_line_count(textBufferPointer))
    }

    /// Whether the buffer has been modified.
    public var modified: Bool {
        get { gtk_text_buffer_get_modified(textBufferPointer) != 0 }
        set { gtk_text_buffer_set_modified(textBufferPointer, newValue ? 1 : 0) }
    }

    /// Whether undo is enabled on this buffer.
    public var enableUndo: Bool {
        get { gtk_text_buffer_get_enable_undo(textBufferPointer) != 0 }
        set { gtk_text_buffer_set_enable_undo(textBufferPointer, newValue ? 1 : 0) }
    }

    /// Whether an undo action is available.
    public var canUndo: Bool {
        gtk_text_buffer_get_can_undo(textBufferPointer) != 0
    }

    /// Whether a redo action is available.
    public var canRedo: Bool {
        gtk_text_buffer_get_can_redo(textBufferPointer) != 0
    }

    /// Undoes the last user action.
    public func undo() {
        gtk_text_buffer_undo(textBufferPointer)
    }

    /// Redoes the last undone action.
    public func redo() {
        gtk_text_buffer_redo(textBufferPointer)
    }

    /// Emitted when the buffer content changes.
    @discardableResult
    public func onChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .changed, handler: handler)
    }

    /// Emitted when the modified flag changes.
    @discardableResult
    public func onModifiedChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .modifiedChanged, handler: handler)
    }
}
