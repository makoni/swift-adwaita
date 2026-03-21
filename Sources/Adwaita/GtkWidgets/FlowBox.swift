import CAdwaita
import GObjectSupport

/// A container that arranges children in a reflowing grid.
///
/// Wraps `GtkFlowBox`. Children are arranged in rows, wrapping to
/// the next row when space runs out. For Adwaita apps, consider
/// `WrapBox` as an alternative.
@MainActor
public final class FlowBox: Widget {
    /// Creates a new flow box.
    public init() {
        let ptr = gtk_flow_box_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Appends a child widget.
    public func append(_ child: Widget) {
        gtk_flow_box_append(opaquePointer, child.widgetPointer)
    }

    /// Prepends a child widget.
    public func prepend(_ child: Widget) {
        gtk_flow_box_prepend(opaquePointer, child.widgetPointer)
    }

    /// Inserts a child at the given position.
    public func insert(_ child: Widget, position: Int32) {
        gtk_flow_box_insert(opaquePointer, child.widgetPointer, position)
    }

    /// Removes a child.
    public func remove(_ child: Widget) {
        gtk_flow_box_remove(opaquePointer, child.widgetPointer)
    }

    /// The minimum number of children per line.
    public var minChildrenPerLine: UInt32 {
        get { gtk_flow_box_get_min_children_per_line(opaquePointer) }
        set { gtk_flow_box_set_min_children_per_line(opaquePointer, newValue) }
    }

    /// The maximum number of children per line.
    public var maxChildrenPerLine: UInt32 {
        get { gtk_flow_box_get_max_children_per_line(opaquePointer) }
        set { gtk_flow_box_set_max_children_per_line(opaquePointer, newValue) }
    }

    /// The selection mode.
    public var selectionMode: GtkSelectionMode {
        get { gtk_flow_box_get_selection_mode(opaquePointer) }
        set { gtk_flow_box_set_selection_mode(opaquePointer, newValue) }
    }

    /// The row spacing.
    public var rowSpacing: UInt32 {
        get { gtk_flow_box_get_row_spacing(opaquePointer) }
        set { gtk_flow_box_set_row_spacing(opaquePointer, newValue) }
    }

    /// The column spacing.
    public var columnSpacing: UInt32 {
        get { gtk_flow_box_get_column_spacing(opaquePointer) }
        set { gtk_flow_box_set_column_spacing(opaquePointer, newValue) }
    }

    /// Whether children are laid out homogeneously.
    public var homogeneous: Bool {
        get { gtk_flow_box_get_homogeneous(opaquePointer) != 0 }
        set { gtk_flow_box_set_homogeneous(opaquePointer, newValue ? 1 : 0) }
    }
}
