import CAdwaita
import GObjectSupport

/// A custom sorter backed by `GtkCustomSorter`.
///
/// Wraps a Swift comparison closure and passes it to GTK's sorting
/// infrastructure. Since items in a ``ListStore`` are placeholder `GObject`s,
/// the comparison function receives two ``GObjectRef`` values representing
/// the items being compared. Map them back to your data by looking up their
/// positions in the underlying model.
///
/// ```swift
/// let sorter = CustomSorter { a, b in
///     // Return negative if a < b, 0 if equal, positive if a > b.
///     0
/// }
/// sorter.changed()   // re-runs the sort after data changes
/// ```
@MainActor
public final class CustomSorter: GObjectRef {

    /// Prevent the closure box from being released while the sorter is alive.
    private var closureBox: AnyObject?

    /// Creates a custom sorter with the given comparison function.
    ///
    /// - Parameter compare: A closure that receives two items as ``GObjectRef``
    ///   and returns a negative value if the first should come before the second,
    ///   zero if they are equal, or a positive value if the first should come after.
    public init(_ compare: @escaping @MainActor (GObjectRef, GObjectRef) -> Int) {
        let box = PublicClosureBox(compare)
        let boxPtr = Unmanaged.passRetained(box).toOpaque()

        let ptr = gtk_custom_sorter_new(
            { a, b, userData -> gint in
                guard let userData, let a, let b else { return 0 }
                let box = Unmanaged<PublicClosureBox<@MainActor (GObjectRef, GObjectRef) -> Int>>
                    .fromOpaque(userData).takeUnretainedValue()
                let objA = GObjectRef(borrowing: UnsafeMutableRawPointer(mutating: a))
                let objB = GObjectRef(borrowing: UnsafeMutableRawPointer(mutating: b))
                return MainActor.assumeIsolated {
                    gint(box.closure(objA, objB))
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

    /// Notifies GTK that the sort criteria have changed, triggering a re-sort.
    ///
    /// Call this whenever the external state that affects your comparison changes.
    public func changed() {
        gtk_sorter_changed(UnsafeMutablePointer(OpaquePointer(pointer)), GTK_SORTER_CHANGE_DIFFERENT)
    }
}

/// A sorted view of a list model, backed by `GtkSortListModel`.
///
/// Wraps `GtkSortListModel` and presents items from the underlying model
/// in the order determined by the given ``CustomSorter``. The result itself
/// conforms to `GListModel`, so it can be passed to selection models
/// and ``ListView``.
///
/// ```swift
/// let store = ListStore()
/// let sorter = CustomSorter { _, _ in 0 }
/// let sorted = SortListModel(model: store, sorter: sorter)
/// let selection = NoSelection(listModel: sorted.listModelPointer)
/// ```
@MainActor
public final class SortListModel: GObjectRef, ListModelConvertible {

    /// Creates a sorted list model.
    ///
    /// - Parameters:
    ///   - model: The source ``ListStore`` to sort.
    ///   - sorter: The ``CustomSorter`` whose comparison function determines order.
    public init(model: ListStore, sorter: CustomSorter) {
        let ptr = gtk_sort_list_model_new(nil, nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_sort_list_model_set_model(opaquePointer, model.listModelPointer)
        gtk_sort_list_model_set_sorter(opaquePointer, UnsafeMutablePointer(OpaquePointer(sorter.pointer)))
    }

    /// Creates a sorted list model from any list model.
    ///
    /// - Parameters:
    ///   - model: Any ``ListModelConvertible`` source to sort.
    ///   - sorter: The ``CustomSorter`` whose comparison function determines order.
    public init(model: any ListModelConvertible, sorter: CustomSorter) {
        let ptr = gtk_sort_list_model_new(nil, nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_sort_list_model_set_model(opaquePointer, model.listModelPointer)
        gtk_sort_list_model_set_sorter(opaquePointer, UnsafeMutablePointer(OpaquePointer(sorter.pointer)))
    }

    /// Creates a sorted list model from a raw `GListModel` pointer.
    ///
    /// - Parameters:
    ///   - listModel: A raw `GListModel` pointer.
    ///   - sorter: The ``CustomSorter`` whose comparison function determines order.
    public init(listModel: OpaquePointer, sorter: CustomSorter) {
        let ptr = gtk_sort_list_model_new(nil, nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_sort_list_model_set_model(opaquePointer, listModel)
        gtk_sort_list_model_set_sorter(opaquePointer, UnsafeMutablePointer(OpaquePointer(sorter.pointer)))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    // MARK: - Query

    /// The number of items in the sorted model (same as the source model).
    public var count: Int {
        Int(g_list_model_get_n_items(opaquePointer))
    }

    // MARK: - Pointers

    /// The `GListModel` pointer, for use with selection models.
    public var listModelPointer: OpaquePointer {
        OpaquePointer(pointer)
    }
}
