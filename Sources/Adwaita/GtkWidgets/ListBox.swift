import CAdwaita
import GObjectSupport

/// A vertical list of selectable rows.
///
/// Wraps `GtkListBox`. For Adwaita-styled lists, combine with
/// `PreferencesGroup` or add the `"boxed-list"` CSS class.
@MainActor
public final class ListBox: Widget {
    /// Creates a new list box.
    public init() {
        let ptr = gtk_list_box_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Appends a child widget as a row.
    public func append(_ child: Widget) {
        gtk_list_box_append(opaquePointer, child.widgetPointer)
    }

    /// Prepends a child widget as a row.
    public func prepend(_ child: Widget) {
        gtk_list_box_prepend(opaquePointer, child.widgetPointer)
    }

    /// Removes a row.
    public func remove(_ child: Widget) {
        gtk_list_box_remove(opaquePointer, child.widgetPointer)
    }

    /// Inserts a child at the given position.
    public func insert(_ child: Widget, position: Int) {
        gtk_list_box_insert(opaquePointer, child.widgetPointer, Int32(position))
    }

    /// Removes all rows.
    public func removeAll() {
        gtk_list_box_remove_all(opaquePointer)
    }

    /// The selection mode.
    public var selectionMode: GtkSelectionMode {
        get { gtk_list_box_get_selection_mode(opaquePointer) }
        set { gtk_list_box_set_selection_mode(opaquePointer, newValue) }
    }

    /// Whether to show separators between rows.
    public var showSeparators: Bool {
        get { gtk_list_box_get_show_separators(opaquePointer) != 0 }
        set { gtk_list_box_set_show_separators(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether to activate rows on single click.
    public var activateOnSingleClick: Bool {
        get { gtk_list_box_get_activate_on_single_click(opaquePointer) != 0 }
        set { gtk_list_box_set_activate_on_single_click(opaquePointer, newValue ? 1 : 0) }
    }

    /// Deselects all rows.
    public func unselectAll() {
        gtk_list_box_unselect_all(opaquePointer)
    }

    /// Selects all rows.
    public func selectAll() {
        gtk_list_box_select_all(opaquePointer)
    }

    /// Connects to the `row-activated` signal.
    @discardableResult
    public func onRowActivated(_ handler: @escaping @MainActor (ListBoxRow) -> Void) -> SignalConnection {
        SignalHelper.connectPointer(self, signal: "row-activated") { (ptr: OpaquePointer) in
            handler(ListBoxRow(borrowing: UnsafeMutableRawPointer(ptr)))
        }
    }

    /// Connects to the `row-selected` signal.
    @discardableResult
    public func onRowSelected(_ handler: @escaping @MainActor (ListBoxRow) -> Void) -> SignalConnection {
        SignalHelper.connectPointer(self, signal: "row-selected") { (ptr: OpaquePointer) in
            handler(ListBoxRow(borrowing: UnsafeMutableRawPointer(ptr)))
        }
    }

    /// Selects the row at the given index.
    public func selectRow(at index: Int) {
        guard let row = gtk_list_box_get_row_at_index(opaquePointer, Int32(index)) else { return }
        gtk_list_box_select_row(opaquePointer, row)
    }

    /// Deselects the row at the given index.
    public func unselectRow(at index: Int) {
        guard let row = gtk_list_box_get_row_at_index(opaquePointer, Int32(index)) else { return }
        gtk_list_box_unselect_row(opaquePointer, row)
    }

    /// Returns the row at the given index, or nil if out of bounds.
    public func rowAt(_ index: Int) -> ListBoxRow? {
        guard let row = gtk_list_box_get_row_at_index(opaquePointer, Int32(index)) else { return nil }
        return ListBoxRow(borrowing: UnsafeMutableRawPointer(row))
    }

    /// The currently selected row, or nil.
    public var selectedRow: ListBoxRow? {
        guard let row = gtk_list_box_get_selected_row(opaquePointer) else { return nil }
        return ListBoxRow(borrowing: UnsafeMutableRawPointer(row))
    }

    /// Placeholder widget shown when the list is empty.
    public func setPlaceholder(_ widget: Widget?) {
        gtk_list_box_set_placeholder(opaquePointer, widget?.widgetPointer)
    }
}
