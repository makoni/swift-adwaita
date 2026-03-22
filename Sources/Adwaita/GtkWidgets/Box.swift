import CAdwaita
import GObjectSupport

/// A container that arranges child widgets in a single row or column.
///
/// Wraps `GtkBox`. The most common container for linear layouts.
@MainActor
public final class Box: Widget {
    /// Creates a new box.
    ///
    /// - Parameters:
    ///   - orientation: Whether to lay out children horizontally or vertically.
    ///   - spacing: The space (in pixels) between children.
    public init(orientation: GtkOrientation = GTK_ORIENTATION_VERTICAL, spacing: Int = 0) {
        let ptr = gtk_box_new(orientation, Int32(spacing))!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Appends a child widget.
    public func append(_ child: Widget) {
        gtk_box_append(castedPointer(), child.widgetPointer)
    }

    /// Prepends a child widget.
    public func prepend(_ child: Widget) {
        gtk_box_prepend(castedPointer(), child.widgetPointer)
    }

    /// Removes a child widget.
    public func remove(_ child: Widget) {
        gtk_box_remove(castedPointer(), child.widgetPointer)
    }

    /// Inserts a child after another widget.
    public func insertChildAfter(_ child: Widget, sibling: Widget?) {
        gtk_box_insert_child_after(castedPointer(), child.widgetPointer, sibling?.widgetPointer)
    }

    /// The spacing between children.
    public var spacing: Int {
        get { Int(gtk_box_get_spacing(castedPointer())) }
        set { gtk_box_set_spacing(castedPointer(), Int32(newValue)) }
    }

    /// Whether children are laid out homogeneously.
    public var homogeneous: Bool {
        get { gtk_box_get_homogeneous(castedPointer()) != 0 }
        set { gtk_box_set_homogeneous(castedPointer(), newValue ? 1 : 0) }
    }
}
