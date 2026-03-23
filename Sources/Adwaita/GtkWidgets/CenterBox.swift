import CAdwaita
import GObjectSupport

/// A container that positions children at start, center, and end.
///
/// Wraps `GtkCenterBox`.
@MainActor
public final class CenterBox: Widget {
    /// Creates a new center box.
    public init() {
        let ptr = gtk_center_box_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The start (leading) widget.
    public var startWidget: Widget? {
        get {
            guard let ptr = gtk_center_box_get_start_widget(opaquePointer) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set {
            gtk_center_box_set_start_widget(opaquePointer, newValue?.widgetPointer)
        }
    }

    /// The center widget.
    public var centerWidget: Widget? {
        get {
            guard let ptr = gtk_center_box_get_center_widget(opaquePointer) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set {
            gtk_center_box_set_center_widget(opaquePointer, newValue?.widgetPointer)
        }
    }

    /// The end (trailing) widget.
    public var endWidget: Widget? {
        get {
            guard let ptr = gtk_center_box_get_end_widget(opaquePointer) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set {
            gtk_center_box_set_end_widget(opaquePointer, newValue?.widgetPointer)
        }
    }

    /// Whether to shrink the center widget on overflow.
    public var shrinkCenterLast: Bool {
        get { gtk_center_box_get_shrink_center_last(opaquePointer) != 0 }
        set { gtk_center_box_set_shrink_center_last(opaquePointer, newValue ? 1 : 0) }
    }
}
