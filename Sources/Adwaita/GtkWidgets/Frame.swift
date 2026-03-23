import CAdwaita
import GObjectSupport

/// A decorative frame around a child widget with an optional label.
///
/// Wraps `GtkFrame`.
@MainActor
public final class Frame: Widget {
    /// Creates a new frame with an optional label.
    public init(label: String? = nil) {
        let ptr = gtk_frame_new(label)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The label text.
    public var label: String? {
        get { gtk_frame_get_label(castedPointer()).map { String(cString: $0) } }
        set { gtk_frame_set_label(castedPointer(), newValue) }
    }

    /// The child widget.
    public var child: Widget? {
        get {
            guard let ptr = gtk_frame_get_child(castedPointer()) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set {
            gtk_frame_set_child(castedPointer(), newValue?.widgetPointer)
        }
    }

    /// A custom widget to use as the label instead of text.
    public var labelWidget: Widget? {
        get {
            guard let ptr = gtk_frame_get_label_widget(castedPointer()) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set {
            gtk_frame_set_label_widget(castedPointer(), newValue?.widgetPointer)
        }
    }

    /// The horizontal alignment of the label (0.0 = left, 1.0 = right).
    public var labelXAlign: Float {
        get { gtk_frame_get_label_align(castedPointer()) }
        set { gtk_frame_set_label_align(castedPointer(), newValue) }
    }
}
