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

    required internal init(raw pointer: UnsafeMutableRawPointer) {
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

    /// Sets a sort function for automatic row ordering.
    ///
    /// The closure receives two rows and returns a negative value if the first
    /// should come before the second, positive if after, 0 if equal.
    public func setSortFunc(_ compare: @escaping @MainActor (ListBoxRow, ListBoxRow) -> Int) {
        let box = Unmanaged.passRetained(PublicClosureBox(compare)).toOpaque()
        gtk_list_box_set_sort_func(
            opaquePointer,
            { row1, row2, userData -> Int32 in
                guard let userData, let row1, let row2 else { return 0 }
                let box = Unmanaged<PublicClosureBox<@MainActor (ListBoxRow, ListBoxRow) -> Int>>
                    .fromOpaque(userData).takeUnretainedValue()
                return MainActor.assumeIsolated {
                    Int32(box.closure(
                        ListBoxRow(borrowing: UnsafeMutableRawPointer(row1)),
                        ListBoxRow(borrowing: UnsafeMutableRawPointer(row2))
                    ))
                }
            },
            box,
            { userData in
                guard let userData else { return }
                Unmanaged<AnyObject>.fromOpaque(userData).release()
            }
        )
    }

    /// Clears the sort function, restoring insertion order.
    public func clearSortFunc() {
        gtk_list_box_set_sort_func(opaquePointer, nil, nil, nil)
    }

    /// Sets a filter function to control which rows are visible.
    ///
    /// The closure receives a row and returns `true` to show it, `false` to hide it.
    public func setFilterFunc(_ filter: @escaping @MainActor (ListBoxRow) -> Bool) {
        let box = Unmanaged.passRetained(PublicClosureBox(filter)).toOpaque()
        gtk_list_box_set_filter_func(
            opaquePointer,
            { row, userData -> Int32 in
                guard let userData, let row else { return 1 }
                let box = Unmanaged<PublicClosureBox<@MainActor (ListBoxRow) -> Bool>>
                    .fromOpaque(userData).takeUnretainedValue()
                return MainActor.assumeIsolated {
                    box.closure(ListBoxRow(borrowing: UnsafeMutableRawPointer(row))) ? 1 : 0
                }
            },
            box,
            { userData in
                guard let userData else { return }
                Unmanaged<AnyObject>.fromOpaque(userData).release()
            }
        )
    }

    /// Clears the filter function, showing all rows.
    public func clearFilterFunc() {
        gtk_list_box_set_filter_func(opaquePointer, nil, nil, nil)
    }

    /// Re-evaluates the sort function for all rows.
    public func invalidateSort() {
        gtk_list_box_invalidate_sort(opaquePointer)
    }

    /// Re-evaluates the filter function for all rows.
    public func invalidateFilter() {
        gtk_list_box_invalidate_filter(opaquePointer)
    }

    /// Sets a header function for grouping rows.
    ///
    /// The closure receives the current row and the row before it (nil for
    /// the first row). Call `row.setHeader(widget)` to add a header above
    /// the row, or `row.setHeader(nil)` to remove it.
    public func setHeaderFunc(_ update: @escaping @MainActor (ListBoxRow, ListBoxRow?) -> Void) {
        let box = Unmanaged.passRetained(PublicClosureBox(update)).toOpaque()
        gtk_list_box_set_header_func(
            opaquePointer,
            { row, before, userData in
                guard let userData, let row else { return }
                let box = Unmanaged<PublicClosureBox<@MainActor (ListBoxRow, ListBoxRow?) -> Void>>
                    .fromOpaque(userData).takeUnretainedValue()
                MainActor.assumeIsolated {
                    let beforeRow: ListBoxRow? = before.map { ListBoxRow(borrowing: UnsafeMutableRawPointer($0)) }
                    box.closure(
                        ListBoxRow(borrowing: UnsafeMutableRawPointer(row)),
                        beforeRow
                    )
                }
            },
            box,
            { userData in
                guard let userData else { return }
                Unmanaged<AnyObject>.fromOpaque(userData).release()
            }
        )
    }

    /// Clears the header function.
    public func clearHeaderFunc() {
        gtk_list_box_set_header_func(opaquePointer, nil, nil, nil)
    }

    /// Re-evaluates the header function for all rows.
    public func invalidateHeaders() {
        gtk_list_box_invalidate_headers(opaquePointer)
    }
}
