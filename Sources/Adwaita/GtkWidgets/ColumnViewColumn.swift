// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

/// A column definition for a ``ColumnView``.
///
/// Each column has a title and a ``SignalListItemFactory`` that creates
/// and binds the cell widgets for that column.
///
/// ```swift
/// let factory = SignalListItemFactory()
/// factory.onSetup { listItem in listItem.child = Label("") }
/// factory.onBind { listItem in
///     (listItem.child as? Label)?.text = data[listItem.position].name
/// }
///
/// let column = ColumnViewColumn(title: "Name", factory: factory)
/// column.expand = true
/// column.resizable = true
/// columnView.appendColumn(column)
/// ```
@MainActor
public final class ColumnViewColumn: GObjectRef {

    /// Creates a new column with the given title and factory.
    public init(title: String?, factory: SignalListItemFactory) {
        let ptr = gtk_column_view_column_new(title, OpaquePointer(factory.pointer))!
        // gtk_column_view_column_new takes ownership of the factory ref,
        // so add a ref to keep the Swift wrapper valid.
        g_object_ref(factory.pointer)
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    // MARK: - Properties

    /// The title displayed in the column header.
    public var title: String? {
        get {
            guard let cStr = gtk_column_view_column_get_title(opaquePointer) else { return nil }
            return String(cString: cStr)
        }
        set { gtk_column_view_column_set_title(opaquePointer, newValue) }
    }

    /// The fixed width of the column in pixels, or -1 for automatic sizing.
    public var fixedWidth: Int {
        get { Int(gtk_column_view_column_get_fixed_width(opaquePointer)) }
        set { gtk_column_view_column_set_fixed_width(opaquePointer, Int32(newValue)) }
    }

    /// Whether the column can be resized by the user.
    public var resizable: Bool {
        get { gtk_column_view_column_get_resizable(opaquePointer) != 0 }
        set { gtk_column_view_column_set_resizable(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the column expands to fill available space.
    public var expand: Bool {
        get { gtk_column_view_column_get_expand(opaquePointer) != 0 }
        set { gtk_column_view_column_set_expand(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the column is visible.
    public var isVisible: Bool {
        get { gtk_column_view_column_get_visible(opaquePointer) != 0 }
        set { gtk_column_view_column_set_visible(opaquePointer, newValue ? 1 : 0) }
    }
}
