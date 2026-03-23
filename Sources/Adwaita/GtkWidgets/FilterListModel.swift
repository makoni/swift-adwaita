import CAdwaita
import GObjectSupport

/// A custom filter backed by `GtkCustomFilter`.
///
/// Wraps a Swift predicate closure and passes it to GTK's filter infrastructure.
/// Since items in a ``ListStore`` are placeholder `GObject`s, the predicate
/// receives a ``GObjectRef`` representing the item. Map it back to your data
/// by looking up its position in the underlying model.
///
/// ```swift
/// let filter = CustomFilter { item in
///     // Return true to keep the item, false to hide it.
///     true
/// }
/// filter.changed()   // re-runs the filter after data changes
/// ```
@MainActor
public final class CustomFilter: GObjectRef {

    /// Prevent the closure box from being released while the filter is alive.
    private var closureBox: AnyObject?

    /// Creates a custom filter with the given predicate.
    ///
    /// - Parameter predicate: A closure that receives each item as a
    ///   ``GObjectRef`` and returns `true` to keep it or `false` to hide it.
    public init(_ predicate: @escaping @MainActor (GObjectRef) -> Bool) {
        let box = PublicClosureBox(predicate)
        let boxPtr = Unmanaged.passRetained(box).toOpaque()

        let ptr = gtk_custom_filter_new(
            { item, userData -> gboolean in
                guard let userData, let item else { return 0 }
                let box = Unmanaged<PublicClosureBox<@MainActor (GObjectRef) -> Bool>>
                    .fromOpaque(userData).takeUnretainedValue()
                let obj = GObjectRef(borrowing: UnsafeMutableRawPointer(item))
                return MainActor.assumeIsolated {
                    box.closure(obj) ? 1 : 0
                }
            },
            boxPtr,
            { userData in
                guard let userData else { return }
                Unmanaged<AnyObject>.fromOpaque(userData).release()
            }
        )!

        super.init(raw: UnsafeMutableRawPointer(ptr))
        self.closureBox = box
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Notifies GTK that the filter criteria have changed, triggering a re-filter.
    ///
    /// Call this whenever the external state that affects your predicate changes.
    public func changed() {
        gtk_filter_changed(UnsafeMutablePointer(OpaquePointer(pointer)), GTK_FILTER_CHANGE_DIFFERENT)
    }
}

/// A filtered view of a list model, backed by `GtkFilterListModel`.
///
/// Wraps `GtkFilterListModel` and presents only the items from the
/// underlying model that match the given ``CustomFilter``. The result
/// itself conforms to `GListModel`, so it can be passed to selection
/// models and ``ListView``.
///
/// ```swift
/// let store = ListStore()
/// let filter = CustomFilter { _ in true }
/// let filtered = FilterListModel(model: store, filter: filter)
/// let selection = NoSelection(listModel: filtered.listModelPointer)
/// ```
@MainActor
public final class FilterListModel: GObjectRef, ListModelConvertible {

    /// Creates a filtered list model.
    ///
    /// - Parameters:
    ///   - model: The source ``ListStore`` to filter.
    ///   - filter: The ``CustomFilter`` whose predicate determines visibility.
    public init(model: ListStore, filter: CustomFilter) {
        let ptr = gtk_filter_list_model_new(nil, nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_filter_list_model_set_model(opaquePointer, model.listModelPointer)
        gtk_filter_list_model_set_filter(opaquePointer, UnsafeMutablePointer(OpaquePointer(filter.pointer)))
    }

    /// Creates a filtered list model from any list model.
    ///
    /// - Parameters:
    ///   - model: Any ``ListModelConvertible`` source to filter.
    ///   - filter: The ``CustomFilter`` whose predicate determines visibility.
    public init(model: any ListModelConvertible, filter: CustomFilter) {
        let ptr = gtk_filter_list_model_new(nil, nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_filter_list_model_set_model(opaquePointer, model.listModelPointer)
        gtk_filter_list_model_set_filter(opaquePointer, UnsafeMutablePointer(OpaquePointer(filter.pointer)))
    }

    /// Creates a filtered list model from a raw `GListModel` pointer.
    ///
    /// - Parameters:
    ///   - listModel: A raw `GListModel` pointer.
    ///   - filter: The ``CustomFilter`` whose predicate determines visibility.
    public init(listModel: OpaquePointer, filter: CustomFilter) {
        let ptr = gtk_filter_list_model_new(nil, nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_filter_list_model_set_model(opaquePointer, listModel)
        gtk_filter_list_model_set_filter(opaquePointer, UnsafeMutablePointer(OpaquePointer(filter.pointer)))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    // MARK: - Query

    /// The number of items that pass the filter.
    public var count: Int {
        Int(g_list_model_get_n_items(opaquePointer))
    }

    // MARK: - Pointers

    /// The `GListModel` pointer, for use with selection models.
    public var listModelPointer: OpaquePointer {
        OpaquePointer(pointer)
    }
}
