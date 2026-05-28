// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

/// A virtualized, scrollable grid widget backed by a `GListModel`.
///
/// Wraps `GtkGridView`. Like ``ListView``, `GridView` only creates widgets
/// for visible items and recycles them during scrolling — but arranges them
/// in a grid layout instead of a single column.
///
/// ```swift
/// // 1. Data
/// var images: [ImageInfo] = [...]
///
/// // 2. Store (one proxy object per item)
/// let store = ListStore()
/// for _ in images { store.appendPlaceholder() }
///
/// // 3. Factory (create & bind widgets)
/// let factory = SignalListItemFactory()
/// factory.onSetup { listItem in
///     listItem.child = Label("")
/// }
/// factory.onBind { listItem in
///     let img = images[listItem.position]
///     (listItem.child as? Label)?.text = img.name
/// }
///
/// // 4. Selection + View
/// let selection = NoSelection(model: store)
/// let gridView = GridView(model: selection, factory: factory)
/// gridView.minColumns = 2
/// gridView.maxColumns = 4
/// ```
@MainActor
public final class GridView: Widget {
    override public class var gtkType: GType {
        gtk_grid_view_get_type()
    }


    /// Creates a grid view with a single-selection model and item factory.
    public init(model: SingleSelection, factory: SignalListItemFactory) {
        let ptr = gtk_grid_view_new(nil, nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_grid_view_set_model(OpaquePointer(pointer), model.selectionModelPointer)
        gtk_grid_view_set_factory(OpaquePointer(pointer), OpaquePointer(factory.pointer))
    }

    /// Creates a grid view with no selection and an item factory.
    public init(model: NoSelection, factory: SignalListItemFactory) {
        let ptr = gtk_grid_view_new(nil, nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_grid_view_set_model(OpaquePointer(pointer), model.selectionModelPointer)
        gtk_grid_view_set_factory(OpaquePointer(pointer), OpaquePointer(factory.pointer))
    }

    /// Creates a grid view with a multi-selection model and an item factory.
    public init(model: MultiSelection, factory: SignalListItemFactory) {
        let ptr = gtk_grid_view_new(nil, nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_grid_view_set_model(OpaquePointer(pointer), model.selectionModelPointer)
        gtk_grid_view_set_factory(OpaquePointer(pointer), OpaquePointer(factory.pointer))
    }

    /// Creates a grid view with any selection model and an item factory.
    public init(model: any SelectionModelConvertible, factory: SignalListItemFactory) {
        let ptr = gtk_grid_view_new(nil, nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_grid_view_set_model(OpaquePointer(pointer), model.selectionModelPointer)
        gtk_grid_view_set_factory(OpaquePointer(pointer), OpaquePointer(factory.pointer))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    // MARK: - Properties

    /// The minimum number of columns in the grid.
    public var minColumns: Int {
        get { Int(gtk_grid_view_get_min_columns(opaquePointer)) }
        set { gtk_grid_view_set_min_columns(opaquePointer, UInt32(newValue)) }
    }

    /// The maximum number of columns in the grid.
    public var maxColumns: Int {
        get { Int(gtk_grid_view_get_max_columns(opaquePointer)) }
        set { gtk_grid_view_set_max_columns(opaquePointer, UInt32(newValue)) }
    }

    /// Whether items are activated on single click (vs double click).
    public var singleClickActivate: Bool {
        get { gtk_grid_view_get_single_click_activate(opaquePointer) != 0 }
        set { gtk_grid_view_set_single_click_activate(opaquePointer, newValue ? 1 : 0) }
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
    public func scrollTo(_ position: Int, flags: ListScrollFlags = .none) {
        gtk_grid_view_scroll_to(opaquePointer, UInt32(position), GtkListScrollFlags(rawValue: flags.rawValue), nil)
    }

}
