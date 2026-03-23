import CAdwaita
import GObjectSupport

/// A selection model that allows selecting multiple items.
///
/// Wraps `GtkMultiSelection`. Use with ``ListView`` when the user should
/// be able to select multiple items at once.
///
/// ```swift
/// let selection = MultiSelection(model: store)
/// let listView = ListView(model: selection, factory: factory)
/// ```
@MainActor
public final class MultiSelection: GObjectRef, SelectionModelConvertible {

    /// Creates a multi-selection model wrapping the given list model.
    public init(model: ListStore) {
        let ptr = gtk_multi_selection_new(nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_multi_selection_set_model(OpaquePointer(pointer), model.listModelPointer)
    }

    /// Creates a multi-selection model wrapping a `StringList`.
    public init(model: StringList) {
        let ptr = gtk_multi_selection_new(nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_multi_selection_set_model(OpaquePointer(pointer), model.listModelPointer)
    }

    /// Creates a multi-selection model wrapping any list model.
    public init(model: any ListModelConvertible) {
        let ptr = gtk_multi_selection_new(nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_multi_selection_set_model(OpaquePointer(pointer), model.listModelPointer)
    }

    /// Creates a multi-selection model from a raw `GListModel` pointer.
    public init(listModel: OpaquePointer) {
        let ptr = gtk_multi_selection_new(nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_multi_selection_set_model(OpaquePointer(pointer), listModel)
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    // MARK: - Pointers

    /// The `GtkSelectionModel` pointer, for use with ``ListView``.
    public var selectionModelPointer: OpaquePointer {
        OpaquePointer(pointer)
    }

    // MARK: - Selection Operations

    /// Selects the item at the given position.
    ///
    /// If `unselectRest` is `true`, all other items are unselected first.
    @discardableResult
    public func selectItem(position: Int, unselectRest: Bool) -> Bool {
        gtk_selection_model_select_item(
            opaquePointer, UInt32(position), unselectRest ? 1 : 0
        ) != 0
    }

    /// Unselects the item at the given position.
    @discardableResult
    public func unselectItem(position: Int) -> Bool {
        gtk_selection_model_unselect_item(opaquePointer, UInt32(position)) != 0
    }

    /// Selects all items in the model.
    @discardableResult
    public func selectAll() -> Bool {
        gtk_selection_model_select_all(opaquePointer) != 0
    }

    /// Unselects all items in the model.
    @discardableResult
    public func unselectAll() -> Bool {
        gtk_selection_model_unselect_all(opaquePointer) != 0
    }

    /// Returns whether the item at the given position is selected.
    public func isSelected(position: Int) -> Bool {
        gtk_selection_model_is_selected(opaquePointer, UInt32(position)) != 0
    }

    // MARK: - Signals

    /// Connects to selection changes.
    ///
    /// The handler receives the position and number of items whose
    /// selection state may have changed.
    @discardableResult
    public func onSelectionChanged(
        _ handler: @escaping @MainActor (Int, Int) -> Void
    ) -> SignalConnection {
        SignalHelper.connectUIntUInt(self, signal: "selection-changed") { position, nItems in
            handler(Int(position), Int(nItems))
        }
    }

    /// Connects to selection changes with a simple callback.
    @discardableResult
    public func onSelectionChanged(
        _ handler: @escaping @MainActor () -> Void
    ) -> SignalConnection {
        SignalHelper.connectUIntUInt(self, signal: "selection-changed") { _, _ in
            handler()
        }
    }
}
