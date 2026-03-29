import CAdwaita
import GObjectSupport

/// A flattened view of a model of models, backed by `GtkFlattenListModel`.
///
/// Wraps `GtkFlattenListModel` and presents the items from all child models
/// as a single flat list. The source model must be a `GListModel` whose items
/// are themselves `GListModel`s. The result itself conforms to `GListModel`,
/// so it can be passed to selection models and ``ListView``.
///
/// ```swift
/// let outerStore = ListStore()   // a model of models
/// let flattened = FlattenListModel(model: outerStore)
/// let selection = NoSelection(listModel: flattened.listModelPointer)
/// ```
@MainActor
public final class FlattenListModel: GObjectRef, ListModelConvertible {

    /// Creates a flattened list model.
    ///
    /// - Parameter model: A ``GObjectRef`` whose underlying pointer is a
    ///   `GListModel` of `GListModel`s.
    public init(model: GObjectRef) {
        let ptr = gtk_flatten_list_model_new(nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_flatten_list_model_set_model(opaquePointer, OpaquePointer(model.pointer))
    }

    /// Creates a flattened list model from a raw `GListModel` pointer.
    ///
    /// - Parameter listModel: A raw `GListModel` pointer whose items are
    ///   themselves `GListModel`s.
    public init(listModel: OpaquePointer) {
        let ptr = gtk_flatten_list_model_new(nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_flatten_list_model_set_model(opaquePointer, listModel)
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    // MARK: - Query

    /// The number of items across all child models.
    public var count: Int {
        Int(g_list_model_get_n_items(opaquePointer))
    }

}
