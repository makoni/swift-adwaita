// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

/// A container that arranges child widgets in rows and columns.
///
/// Wraps `GtkGrid`.
@MainActor
public final class Grid: Widget {
    /// Creates a new grid.
    public init() {
        let ptr = gtk_grid_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a grid with column and row spacing.
    public convenience init(columnSpacing: Int, rowSpacing: Int) {
        self.init()
        self.columnSpacing = columnSpacing
        self.rowSpacing = rowSpacing
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Attaches a child widget at the given position.
    ///
    /// - Parameters:
    ///   - child: The widget to add.
    ///   - column: The column index.
    ///   - row: The row index.
    ///   - width: The number of columns the widget should span.
    ///   - height: The number of rows the widget should span.
    public func attach(_ child: Widget, column: Int, row: Int, width: Int = 1, height: Int = 1) {
        gtk_grid_attach(castedPointer(), child.widgetPointer, Int32(column), Int32(row), Int32(width), Int32(height))
    }

    /// Attaches a child widget next to an existing child.
    public func attachNextTo(_ child: Widget, sibling: Widget?, side: GtkPositionType, width: Int = 1,
                             height: Int = 1) {
        gtk_grid_attach_next_to(
            castedPointer(),
            child.widgetPointer,
            sibling?.widgetPointer,
            side,
            Int32(width),
            Int32(height)
        )
    }

    /// Removes a child widget from the grid.
    public func remove(_ child: Widget) {
        gtk_grid_remove(castedPointer(), child.widgetPointer)
    }

    /// Returns the child widget at the given position, or nil.
    public func childAt(column: Int, row: Int) -> Widget? {
        guard let ptr = gtk_grid_get_child_at(castedPointer(), Int32(column), Int32(row)) else { return nil }
        return Widget(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// The spacing between columns.
    public var columnSpacing: Int {
        get { Int(gtk_grid_get_column_spacing(castedPointer())) }
        set { gtk_grid_set_column_spacing(castedPointer(), UInt32(newValue)) }
    }

    /// The spacing between rows.
    public var rowSpacing: Int {
        get { Int(gtk_grid_get_row_spacing(castedPointer())) }
        set { gtk_grid_set_row_spacing(castedPointer(), UInt32(newValue)) }
    }

    /// Whether all columns should have the same width.
    public var columnHomogeneous: Bool {
        get { gtk_grid_get_column_homogeneous(castedPointer()) != 0 }
        set { gtk_grid_set_column_homogeneous(castedPointer(), newValue ? 1 : 0) }
    }

    /// Whether all rows should have the same height.
    public var rowHomogeneous: Bool {
        get { gtk_grid_get_row_homogeneous(castedPointer()) != 0 }
        set { gtk_grid_set_row_homogeneous(castedPointer(), newValue ? 1 : 0) }
    }

    /// Inserts a row at the given position.
    public func insertRow(at position: Int) {
        gtk_grid_insert_row(castedPointer(), Int32(position))
    }

    /// Inserts a column at the given position.
    public func insertColumn(at position: Int) {
        gtk_grid_insert_column(castedPointer(), Int32(position))
    }

    /// Removes a row at the given position.
    public func removeRow(at position: Int) {
        gtk_grid_remove_row(castedPointer(), Int32(position))
    }

    /// Removes a column at the given position.
    public func removeColumn(at position: Int) {
        gtk_grid_remove_column(castedPointer(), Int32(position))
    }
}
