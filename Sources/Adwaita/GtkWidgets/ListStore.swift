import CAdwaita
import GObjectSupport

/// A list model that stores GObjects, backed by `GListStore`.
///
/// Use with ``ListView`` and a ``SignalListItemFactory`` for virtualized,
/// high-performance scrollable lists. Each item in the store is a proxy
/// `GObject` — keep your real data in a parallel Swift array and access
/// it by position in the factory's `onBind` callback.
///
/// ```swift
/// let store = ListStore()
/// store.appendPlaceholder()   // one proxy object per data item
/// store.remove(at: 3)         // mirrors changes in your data array
/// ```
@MainActor
public final class ListStore: GObjectRef {

    /// Creates an empty `GListStore` for `GObject` items.
    public init() {
        let ptr = g_list_store_new(cadw_type_object())
        super.init(raw: UnsafeMutableRawPointer(ptr!))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    // MARK: - Convenience: proxy objects

    /// Appends a new bare `GObject` as a placeholder item.
    ///
    /// Use this when your real data lives in a Swift array — the store only
    /// needs to hold one object per item so `ListView` knows the count.
    public func appendPlaceholder() {
        let obj = cadw_object_new(cadw_type_object())!
        g_list_store_append(opaquePointer, obj)
        g_object_unref(obj)
    }

    /// Inserts a new placeholder at the given position.
    public func insertPlaceholder(at position: Int) {
        let obj = cadw_object_new(cadw_type_object())!
        g_list_store_insert(opaquePointer, UInt32(position), obj)
        g_object_unref(obj)
    }

    // MARK: - Direct GObject operations

    /// Appends an existing GObject to the store.
    public func append(_ item: GObjectRef) {
        g_list_store_append(opaquePointer, gpointer(item.pointer))
    }

    /// Inserts an existing GObject at the given position.
    public func insert(_ item: GObjectRef, at position: Int) {
        g_list_store_insert(opaquePointer, UInt32(position), gpointer(item.pointer))
    }

    // MARK: - Removal

    /// Removes the item at the given position.
    public func remove(at position: Int) {
        g_list_store_remove(opaquePointer, UInt32(position))
    }

    /// Removes all items from the store.
    public func removeAll() {
        g_list_store_remove_all(opaquePointer)
    }

    // MARK: - Query

    /// The number of items in the store.
    public var count: Int {
        Int(g_list_model_get_n_items(opaquePointer))
    }

    // MARK: - Pointers

    /// The `GListModel` pointer, for use with selection models.
    public var listModelPointer: OpaquePointer {
        OpaquePointer(pointer)
    }
}
