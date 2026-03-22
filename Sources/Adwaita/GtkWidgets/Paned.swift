import CAdwaita
import GObjectSupport

/// A widget with two adjustable panes separated by a draggable handle.
///
/// Wraps `GtkPaned`.
@MainActor
public final class Paned: Widget {
    /// Creates a new paned widget.
    public init(orientation: GtkOrientation = GTK_ORIENTATION_HORIZONTAL) {
        let ptr = gtk_paned_new(orientation)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The start (left or top) child.
    public var startChild: Widget? {
        get {
            guard let ptr = gtk_paned_get_start_child(opaquePointer) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set {
            gtk_paned_set_start_child(opaquePointer, newValue?.widgetPointer)
        }
    }

    /// The end (right or bottom) child.
    public var endChild: Widget? {
        get {
            guard let ptr = gtk_paned_get_end_child(opaquePointer) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set {
            gtk_paned_set_end_child(opaquePointer, newValue?.widgetPointer)
        }
    }

    /// The position of the divider in pixels.
    public var position: Int {
        get { Int(gtk_paned_get_position(opaquePointer)) }
        set { gtk_paned_set_position(opaquePointer, Int32(newValue)) }
    }

    /// Whether the start child expands when the paned is resized.
    public var resizeStartChild: Bool {
        get { gtk_paned_get_resize_start_child(opaquePointer) != 0 }
        set { gtk_paned_set_resize_start_child(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the end child expands when the paned is resized.
    public var resizeEndChild: Bool {
        get { gtk_paned_get_resize_end_child(opaquePointer) != 0 }
        set { gtk_paned_set_resize_end_child(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the start child can be made smaller than its natural size.
    public var shrinkStartChild: Bool {
        get { gtk_paned_get_shrink_start_child(opaquePointer) != 0 }
        set { gtk_paned_set_shrink_start_child(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the end child can be made smaller than its natural size.
    public var shrinkEndChild: Bool {
        get { gtk_paned_get_shrink_end_child(opaquePointer) != 0 }
        set { gtk_paned_set_shrink_end_child(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the separator handle is wide.
    public var wideHandle: Bool {
        get { gtk_paned_get_wide_handle(opaquePointer) != 0 }
        set { gtk_paned_set_wide_handle(opaquePointer, newValue ? 1 : 0) }
    }
}
