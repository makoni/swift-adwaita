// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

/// A list model that wraps a flat `GListModel` into a tree structure.
///
/// Wraps `GtkTreeListModel`. It uses a callback to lazily create child models
/// for expandable items, enabling tree views with ``ListView`` or ``ColumnView``.
///
/// ```swift
/// let rootStore = ListStore()
/// for _ in rootItems { rootStore.appendPlaceholder() }
///
/// let treeModel = TreeListModel(
///     root: rootStore,
///     passthrough: false,
///     autoexpand: false
/// ) { item in
///     // Return a ListStore for children, or nil for leaf nodes
///     let children = getChildren(for: item)
///     guard !children.isEmpty else { return nil }
///     let childStore = ListStore()
///     for _ in children { childStore.appendPlaceholder() }
///     return childStore
/// }
///
/// let selection = SingleSelection(listModel: treeModel.listModelPointer)
/// ```
@MainActor
public final class TreeListModel: GObjectRef, ListModelConvertible {

    /// Prevent the create-children closure from being deallocated.
    private var closureBox: AnyObject?

    /// Creates a tree list model from a root list model.
    ///
    /// - Parameters:
    ///   - root: The root list model providing top-level items.
    ///   - passthrough: If `true`, the model passes through the items from the
    ///     child models directly. If `false`, items are wrapped in `GtkTreeListRow`.
    ///   - autoexpand: If `true`, rows are expanded by default.
    ///   - createChildren: A callback that returns a ``ListStore`` of children
    ///     for the given item, or `nil` if the item is a leaf node.
    public init(
        root: ListStore,
        passthrough: Bool = false,
        autoexpand: Bool = false,
        createChildren: @escaping @MainActor (GObjectRef) -> ListStore?
    ) {
        let box = PublicClosureBox(createChildren)

        // We need to ref the root model because gtk_tree_list_model_new takes
        // ownership (transfer full) of it.
        g_object_ref(root.pointer)

        let boxPtr = Unmanaged.passRetained(box).toOpaque()

        let ptr = gtk_tree_list_model_new(
            root.listModelPointer,
            passthrough ? 1 : 0,
            autoexpand ? 1 : 0,
            { item, userData -> OpaquePointer? in
                guard let userData, let item else { return nil }
                let box = Unmanaged<PublicClosureBox<@MainActor (GObjectRef) -> ListStore?>>
                    .fromOpaque(userData).takeUnretainedValue()
                struct WrappedItem: @unchecked Sendable { let ptr: gpointer }
                let wrapped = WrappedItem(ptr: item)
                nonisolated(unsafe) var resultPtr: UnsafeMutableRawPointer? = nil
                MainActor.assumeIsolated {
                    let gobject = GObjectRef(borrowing: UnsafeMutableRawPointer(wrapped.ptr))
                    guard let childStore = box.closure(gobject) else { return }
                    // gtk_tree_list_model takes ownership (transfer full),
                    // so add a ref to keep the Swift wrapper valid.
                    g_object_ref(childStore.pointer)
                    resultPtr = UnsafeMutableRawPointer(childStore.listModelPointer)
                }
                guard let resultPtr else { return nil }
                return OpaquePointer(resultPtr)
            },
            boxPtr,
            { userData in
                scheduleDeferredBoxRelease(userData)
            }
        )!

        super.init(raw: UnsafeMutableRawPointer(ptr))

        // Keep a reference to the box for safety.
        closureBox = box
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    // MARK: - Properties

    /// Whether rows are automatically expanded.
    public var autoexpand: Bool {
        get { gtk_tree_list_model_get_autoexpand(opaquePointer) != 0 }
        set { gtk_tree_list_model_set_autoexpand(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the model passes through items directly (vs wrapping in `GtkTreeListRow`).
    public var passthrough: Bool {
        gtk_tree_list_model_get_passthrough(opaquePointer) != 0
    }

    // MARK: - Row Access

    /// Returns the `TreeListRow` at the given position, or `nil` if out of range.
    public func row(at position: Int) -> TreeListRow? {
        guard let ptr = gtk_tree_list_model_get_row(opaquePointer, UInt32(position)) else {
            return nil
        }
        // gtk_tree_list_model_get_row returns a new ref (transfer full)
        return TreeListRow(raw: UnsafeMutableRawPointer(ptr))
    }
}

/// A wrapper for `GtkTreeListRow`, representing a single row in a ``TreeListModel``.
///
/// Provides access to the item, expansion state, and depth of a tree row.
@MainActor
public final class TreeListRow: GObjectRef {

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    // MARK: - Properties

    /// The underlying model item for this row.
    public var item: GObjectRef? {
        guard let ptr = gtk_tree_list_row_get_item(opaquePointer) else { return nil }
        // gtk_tree_list_row_get_item returns a new ref (transfer full)
        return GObjectRef(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Whether this row is expanded to show its children.
    public var expanded: Bool {
        get { gtk_tree_list_row_get_expanded(opaquePointer) != 0 }
        set { gtk_tree_list_row_set_expanded(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether this row can be expanded (has children).
    public var isExpandable: Bool {
        gtk_tree_list_row_is_expandable(opaquePointer) != 0
    }

    /// The depth of this row in the tree (0 for root items).
    public var depth: Int {
        Int(gtk_tree_list_row_get_depth(opaquePointer))
    }

    /// The position of this row in the flattened list.
    public var position: Int {
        Int(gtk_tree_list_row_get_position(opaquePointer))
    }
}
