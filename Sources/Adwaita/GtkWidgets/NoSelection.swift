import CAdwaita
import GObjectSupport

/// A selection model that does not allow any selection.
///
/// Wraps `GtkNoSelection`. Use with ``ListView`` for read-only lists
/// where item selection is not needed (e.g. a chat message list).
///
/// ```swift
/// let selection = NoSelection(model: store)
/// let listView = ListView(model: selection, factory: factory)
/// ```
@MainActor
public final class NoSelection: GObjectRef, SelectionModelConvertible {

    /// Creates a no-selection model wrapping the given list store.
    public init(model: ListStore) {
        let ptr = gtk_no_selection_new(nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_no_selection_set_model(OpaquePointer(pointer), model.listModelPointer)
    }

    /// Creates a no-selection model wrapping a `StringList`.
    public init(model: StringList) {
        let ptr = gtk_no_selection_new(nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_no_selection_set_model(OpaquePointer(pointer), model.listModelPointer)
    }

    /// Creates a no-selection model wrapping any list model.
    public init(model: any ListModelConvertible) {
        let ptr = gtk_no_selection_new(nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_no_selection_set_model(OpaquePointer(pointer), model.listModelPointer)
    }

    /// Creates a no-selection model from a raw `GListModel` pointer.
    public init(listModel: OpaquePointer) {
        let ptr = gtk_no_selection_new(nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_no_selection_set_model(OpaquePointer(pointer), listModel)
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    // MARK: - Pointers

    /// The `GtkSelectionModel` pointer, for use with ``ListView``.
    public var selectionModelPointer: OpaquePointer {
        OpaquePointer(pointer)
    }
}
