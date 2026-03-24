import CAdwaita
import GObjectSupport

/// A selection model that allows selecting a single item.
///
/// Wraps `GtkSingleSelection`. Use with ``ListView`` when the user should
/// be able to select one item at a time.
///
/// ```swift
/// let selection = SingleSelection(model: store)
/// let listView = ListView(model: selection, factory: factory)
/// ```
@MainActor
public final class SingleSelection: GObjectRef, SelectionModelConvertible {

    /// Creates a single-selection model wrapping the given list model.
    public init(model: ListStore) {
        let ptr = gtk_single_selection_new(nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_single_selection_set_model(OpaquePointer(pointer), model.listModelPointer)
    }

    /// Creates a single-selection model wrapping a `StringList`.
    public init(model: StringList) {
        let ptr = gtk_single_selection_new(nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_single_selection_set_model(OpaquePointer(pointer), model.listModelPointer)
    }

    /// Creates a single-selection model wrapping any list model.
    public init(model: any ListModelConvertible) {
        let ptr = gtk_single_selection_new(nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_single_selection_set_model(OpaquePointer(pointer), model.listModelPointer)
    }

    /// Creates a single-selection model from a raw `GListModel` pointer.
    public init(listModel: OpaquePointer) {
        let ptr = gtk_single_selection_new(nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_single_selection_set_model(OpaquePointer(pointer), listModel)
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    // MARK: - Properties

    /// The index of the selected item, or `GTK_INVALID_LIST_POSITION` if none.
    public var selected: Int {
        get { Int(gtk_single_selection_get_selected(opaquePointer)) }
        set { gtk_single_selection_set_selected(opaquePointer, UInt32(newValue)) }
    }

    /// Whether the user can unselect the current item.
    public var canUnselect: Bool {
        get { gtk_single_selection_get_can_unselect(opaquePointer) != 0 }
        set { gtk_single_selection_set_can_unselect(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether to automatically select an item when the model changes.
    public var autoselect: Bool {
        get { gtk_single_selection_get_autoselect(opaquePointer) != 0 }
        set { gtk_single_selection_set_autoselect(opaquePointer, newValue ? 1 : 0) }
    }

    /// Connects to selection changes.
    @discardableResult
    public func onSelectionChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.onNotify(self, property: .selected, handler: handler)
    }

}
