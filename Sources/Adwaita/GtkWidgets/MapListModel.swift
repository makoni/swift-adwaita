import CAdwaita
import GObjectSupport

/// The C-callable map callback for `GtkMapListModel`.
/// The C-callable map callback for `GtkMapListModel`.
private func _mapListModelCallback(
    item: gpointer?, userData: gpointer?
) -> gpointer? {
    guard let userData, let item else { return nil }
    let box = Unmanaged<PublicClosureBox<@MainActor (GObjectRef) -> GObjectRef>>
        .fromOpaque(userData).takeUnretainedValue()
    struct Wrapped: @unchecked Sendable { let ptr: gpointer }
    let wrapped = Wrapped(ptr: item)
    nonisolated(unsafe) var result: gpointer?
    MainActor.assumeIsolated {
        let obj = GObjectRef(borrowing: UnsafeMutableRawPointer(wrapped.ptr))
        let mapped = box.closure(obj)
        // Transfer full: GTK takes ownership, so retain before returning.
        result = Unmanaged.passRetained(mapped).toOpaque()
    }
    return result
}

/// A mapped view of a list model, backed by `GtkMapListModel`.
///
/// Wraps `GtkMapListModel` and transforms each item from the source model
/// using a user-supplied closure. The result itself conforms to `GListModel`,
/// so it can be passed to selection models and ``ListView``.
///
/// The map function receives each source item as a ``GObjectRef`` and must
/// return a new ``GObjectRef`` that becomes the item in the mapped model.
/// Since the items in a ``ListStore`` are placeholder `GObject`s, a common
/// pattern is to create a new placeholder for each mapped item.
///
/// ```swift
/// let store = ListStore()
/// let mapped = MapListModel(model: store) { item in
///     // Return a new GObject for each source item.
///     GObjectRef(raw: cadw_object_new(cadw_type_object())!)
/// }
/// let selection = NoSelection(listModel: mapped.listModelPointer)
/// ```
@MainActor
public final class MapListModel: GObjectRef, ListModelConvertible {

    /// Prevent the closure box from being released while the model is alive.
    private var closureBox: AnyObject?

    /// Creates a mapped list model.
    ///
    /// - Parameters:
    ///   - model: The source ``ListStore`` to map.
    ///   - mapFunc: A closure that receives each item as a ``GObjectRef``
    ///     and returns a new ``GObjectRef`` for the mapped model.
    public init(model: ListStore, mapFunc: @escaping @MainActor (GObjectRef) -> GObjectRef) {
        let box = PublicClosureBox(mapFunc)
        let boxPtr = Unmanaged.passRetained(box).toOpaque()

        let ptr = gtk_map_list_model_new(nil, nil, nil, nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        closureBox = box

        gtk_map_list_model_set_model(opaquePointer, model.listModelPointer)
        gtk_map_list_model_set_map_func(
            opaquePointer,
            _mapListModelCallback,
            boxPtr,
            { userData in
                guard let userData else { return }
                Unmanaged<AnyObject>.fromOpaque(userData).release()
            }
        )
    }

    /// Creates a mapped list model from a raw `GListModel` pointer.
    ///
    /// - Parameters:
    ///   - listModel: A raw `GListModel` pointer.
    ///   - mapFunc: A closure that receives each item as a ``GObjectRef``
    ///     and returns a new ``GObjectRef`` for the mapped model.
    public init(listModel: OpaquePointer, mapFunc: @escaping @MainActor (GObjectRef) -> GObjectRef) {
        let box = PublicClosureBox(mapFunc)
        let boxPtr = Unmanaged.passRetained(box).toOpaque()

        let ptr = gtk_map_list_model_new(nil, nil, nil, nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        closureBox = box

        gtk_map_list_model_set_model(opaquePointer, listModel)
        gtk_map_list_model_set_map_func(
            opaquePointer,
            _mapListModelCallback,
            boxPtr,
            { userData in
                guard let userData else { return }
                Unmanaged<AnyObject>.fromOpaque(userData).release()
            }
        )
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    // MARK: - Query

    /// The number of items in the mapped model.
    public var count: Int {
        Int(g_list_model_get_n_items(opaquePointer))
    }

}
