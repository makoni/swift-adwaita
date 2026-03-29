import CAdwaita
import GObjectSupport

/// A container that arranges child widgets in a single row or column.
///
/// Wraps `GtkBox`. The most common container for linear layouts.
/// Use a vertical box for stacking widgets top-to-bottom, or a horizontal
/// box for arranging them side-by-side.
///
/// ```swift
/// // Vertical layout with spacing between children
/// let vbox = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 12)
/// vbox.append(Label("Title"))
/// vbox.append(Label("Subtitle"))
/// vbox.append(Button("Click Me"))
///
/// // Horizontal button bar with equal-width buttons
/// let hbox = Box(orientation: GTK_ORIENTATION_HORIZONTAL, spacing: 6)
///     .homogeneous(true)
/// hbox.append(Button("Cancel"))
/// hbox.append(Button("OK"))
/// ```
@MainActor
public final class Box: Widget, Container {
    /// Creates a new box.
    ///
    /// - Parameters:
    ///   - orientation: Whether to lay out children horizontally or vertically.
    ///   - spacing: The space (in pixels) between children.
    public init(orientation: GtkOrientation = GTK_ORIENTATION_VERTICAL, spacing: Int = 0) {
        let ptr = gtk_box_new(orientation, Int32(spacing))!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
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

    /// Reorders a child to be placed after a sibling (or at the start if sibling is nil).
    public func reorderChildAfter(_ child: Widget, sibling: Widget?) {
        gtk_box_reorder_child_after(castedPointer(), child.widgetPointer, sibling?.widgetPointer)
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

    /// Appends multiple child widgets.
    public func appendAll(_ children: [Widget]) {
        for child in children {
            append(child)
        }
    }

    /// Sets spacing and returns self for chaining.
    @discardableResult
    public func spacing(_ spacing: Int) -> Self {
        self.spacing = spacing
        return self
    }

    /// Sets homogeneous and returns self for chaining.
    @discardableResult
    public func homogeneous(_ homogeneous: Bool = true) -> Self {
        self.homogeneous = homogeneous
        return self
    }
}
