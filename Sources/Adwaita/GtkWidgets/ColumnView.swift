// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

/// A widget that presents data in a multi-column table layout.
///
/// Wraps `GtkColumnView`. Each column is defined by a ``ColumnViewColumn``
/// with its own ``SignalListItemFactory``. Like ``ListView``, it virtualizes
/// rows — only creating widgets for visible items.
///
/// ```swift
/// // 1. Data
/// var files: [FileInfo] = [...]
///
/// // 2. Store
/// let store = ListStore()
/// for _ in files { store.appendPlaceholder() }
///
/// // 3. Factories (one per column)
/// let nameFactory = SignalListItemFactory()
/// nameFactory.onSetup { listItem in listItem.child = Label("") }
/// nameFactory.onBind { listItem in
///     let file = files[listItem.position]
///     (listItem.child as? Label)?.text = file.name
/// }
///
/// let sizeFactory = SignalListItemFactory()
/// sizeFactory.onSetup { listItem in listItem.child = Label("") }
/// sizeFactory.onBind { listItem in
///     let file = files[listItem.position]
///     (listItem.child as? Label)?.text = "\(file.size) bytes"
/// }
///
/// // 4. Columns + Selection + View
/// let selection = SingleSelection(model: store)
/// let columnView = ColumnView(model: selection)
/// columnView.appendColumn(ColumnViewColumn(title: "Name", factory: nameFactory))
/// columnView.appendColumn(ColumnViewColumn(title: "Size", factory: sizeFactory))
/// ```
@MainActor
public final class ColumnView: Widget {

    /// Creates a column view with a single-selection model.
    public init(model: SingleSelection) {
        let ptr = gtk_column_view_new(nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_column_view_set_model(opaquePointer, model.selectionModelPointer)
    }

    /// Creates a column view with no selection.
    public init(model: NoSelection) {
        let ptr = gtk_column_view_new(nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_column_view_set_model(opaquePointer, model.selectionModelPointer)
    }

    /// Creates a column view with multi-selection.
    public init(model: MultiSelection) {
        let ptr = gtk_column_view_new(nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_column_view_set_model(opaquePointer, model.selectionModelPointer)
    }

    /// Creates a column view with any selection model.
    public init(model: any SelectionModelConvertible) {
        let ptr = gtk_column_view_new(nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_column_view_set_model(opaquePointer, model.selectionModelPointer)
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    // MARK: - Column Management

    /// Appends a column to the end of the column view.
    public func appendColumn(_ column: ColumnViewColumn) {
        gtk_column_view_append_column(opaquePointer, column.opaquePointer)
    }

    /// Removes a column from the column view.
    public func removeColumn(_ column: ColumnViewColumn) {
        gtk_column_view_remove_column(opaquePointer, column.opaquePointer)
    }

    /// Inserts a column at the given position.
    public func insertColumn(_ column: ColumnViewColumn, at position: Int) {
        gtk_column_view_insert_column(opaquePointer, UInt32(position), column.opaquePointer)
    }

    // MARK: - Properties

    /// Whether to show separators between rows.
    public var showRowSeparators: Bool {
        get { gtk_column_view_get_show_row_separators(opaquePointer) != 0 }
        set { gtk_column_view_set_show_row_separators(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether to show separators between columns.
    public var showColumnSeparators: Bool {
        get { gtk_column_view_get_show_column_separators(opaquePointer) != 0 }
        set { gtk_column_view_set_show_column_separators(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether items are activated on single click (vs double click).
    public var singleClickActivate: Bool {
        get { gtk_column_view_get_single_click_activate(opaquePointer) != 0 }
        set { gtk_column_view_set_single_click_activate(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether columns can be reordered by dragging.
    public var reorderable: Bool {
        get { gtk_column_view_get_reorderable(opaquePointer) != 0 }
        set { gtk_column_view_set_reorderable(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether rubberband selection is enabled.
    public var enableRubberband: Bool {
        get { gtk_column_view_get_enable_rubberband(opaquePointer) != 0 }
        set { gtk_column_view_set_enable_rubberband(opaquePointer, newValue ? 1 : 0) }
    }

    // MARK: - Signals

    /// Called when an item is activated (clicked or Enter pressed).
    ///
    /// The parameter is the position of the activated item.
    @discardableResult
    public func onActivate(_ handler: @escaping @MainActor (Int) -> Void) -> SignalConnection {
        SignalHelper.connectUInt(self, signal: .activate) { position in
            handler(Int(position))
        }
    }

    // MARK: - Scrolling

    /// Scrolls to the item at the given position.
    public func scrollTo(_ position: Int, column: ColumnViewColumn? = nil, flags: ListScrollFlags = .none) {
        gtk_column_view_scroll_to(
            opaquePointer,
            UInt32(position),
            column?.opaquePointer,
            GtkListScrollFlags(rawValue: flags.rawValue),
            nil
        )
    }
}
