import CAdwaita
import GObjectSupport

/// A widget that provides expand/collapse UI for tree rows.
///
/// Wraps `GtkTreeExpander`. Place this as the cell widget inside a
/// ``SignalListItemFactory`` when using a ``TreeListModel`` to show
/// an indented tree structure with expand/collapse arrows.
///
/// ```swift
/// let factory = SignalListItemFactory()
/// factory.onSetup { listItem in
///     let expander = TreeExpander()
///     expander.child = Label("")
///     listItem.child = expander
/// }
/// factory.onBind { listItem in
///     guard let expander = listItem.child?.cast(TreeExpander.self) else { return }
///     // Bind the tree list row so the expander knows about expand state
///     if let item = listItem.item {
///         expander.setListRow(item.opaquePointer)
///     }
///     // Update the label
///     if let label = expander.child?.cast(Label.self) {
///         label.text = data[listItem.position].name
///     }
/// }
/// ```
@MainActor
public final class TreeExpander: Widget {

    /// Creates a new tree expander widget.
    public init() {
        let ptr = gtk_tree_expander_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    // MARK: - Properties

    /// The child widget displayed next to the expander arrow.
    public var child: Widget? {
        get {
            guard let ptr = gtk_tree_expander_get_child(opaquePointer) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set {
            gtk_tree_expander_set_child(opaquePointer, newValue?.widgetPointer)
        }
    }

    /// Whether to indent based on the depth of the row.
    public var indentForDepth: Bool {
        get { gtk_tree_expander_get_indent_for_depth(opaquePointer) != 0 }
        set { gtk_tree_expander_set_indent_for_depth(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether to indent to leave space for the expander icon.
    public var indentForIcon: Bool {
        get { gtk_tree_expander_get_indent_for_icon(opaquePointer) != 0 }
        set { gtk_tree_expander_set_indent_for_icon(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the expander arrow is hidden.
    public var hideExpander: Bool {
        get { gtk_tree_expander_get_hide_expander(opaquePointer) != 0 }
        set { gtk_tree_expander_set_hide_expander(opaquePointer, newValue ? 1 : 0) }
    }

    // MARK: - Tree List Row

    /// Sets the `GtkTreeListRow` that this expander manages.
    ///
    /// Pass the item from the list item (which is a `GtkTreeListRow` when
    /// using a non-passthrough ``TreeListModel``).
    public func setListRow(_ listRow: GObjectRef) {
        gtk_tree_expander_set_list_row(opaquePointer, OpaquePointer(listRow.pointer))
    }

    /// Returns the `GtkTreeListRow` this expander manages, or `nil`.
    public var listRow: TreeListRow? {
        guard let ptr = gtk_tree_expander_get_list_row(opaquePointer) else { return nil }
        return TreeListRow(borrowing: UnsafeMutableRawPointer(ptr))
    }
}
