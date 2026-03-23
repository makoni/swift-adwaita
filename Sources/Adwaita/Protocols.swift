import CAdwaita
import GObjectSupport

/// A type that can be used as a `GListModel` source for selection models,
/// filter/sort wrappers, and list views.
///
/// Conform to this protocol to allow your model to be passed directly
/// to ``SingleSelection``, ``NoSelection``, ``MultiSelection``,
/// ``FilterListModel``, ``SortListModel``, and other list-model consumers
/// without requiring an ``OpaquePointer``.
@MainActor
public protocol ListModelConvertible: AnyObject {
    /// The underlying `GListModel` pointer.
    var listModelPointer: OpaquePointer { get }
}

/// A type that can be used as a `GtkSelectionModel` source for list views,
/// grid views, and column views.
///
/// Conform to this protocol to allow your selection model to be passed
/// directly to ``ListView``, ``GridView``, and ``ColumnView`` without
/// requiring an ``OpaquePointer``.
@MainActor
public protocol SelectionModelConvertible: AnyObject {
    /// The underlying `GtkSelectionModel` pointer.
    var selectionModelPointer: OpaquePointer { get }
}
