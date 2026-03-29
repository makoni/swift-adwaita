import CAdwaita
import GObjectSupport

/// A frame that maintains a specific aspect ratio for its child.
///
/// Wraps `GtkAspectFrame`. The child is letterboxed or pillarboxed to
/// maintain the specified aspect ratio within the allocated space.
///
/// ```swift
/// // Keep a 16:9 aspect ratio for a video area
/// let frame = AspectFrame(ratio: 16.0 / 9.0)
/// frame.child = videoWidget
///
/// // Or let the child determine the ratio
/// let frame2 = AspectFrame(obeyChild: true)
/// frame2.child = picture
/// ```
@MainActor
public final class AspectFrame: Widget {
    /// Creates a new aspect frame.
    ///
    /// - Parameters:
    ///   - xalign: Horizontal alignment of the child (0.0 = left, 1.0 = right).
    ///   - yalign: Vertical alignment of the child (0.0 = top, 1.0 = bottom).
    ///   - ratio: The desired aspect ratio (width / height).
    ///   - obeyChild: If `true`, use the child's aspect ratio instead of `ratio`.
    public init(xalign: Float = 0.5, yalign: Float = 0.5, ratio: Float = 1.0, obeyChild: Bool = false) {
        let ptr = gtk_aspect_frame_new(xalign, yalign, ratio, obeyChild ? 1 : 0)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The child widget.
    public var child: Widget? {
        get {
            guard let ptr = gtk_aspect_frame_get_child(opaquePointer) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set { gtk_aspect_frame_set_child(opaquePointer, newValue?.widgetPointer) }
    }

    /// The horizontal alignment (0.0 = left, 1.0 = right).
    public var xalign: Float {
        get { gtk_aspect_frame_get_xalign(opaquePointer) }
        set { gtk_aspect_frame_set_xalign(opaquePointer, newValue) }
    }

    /// The vertical alignment (0.0 = top, 1.0 = bottom).
    public var yalign: Float {
        get { gtk_aspect_frame_get_yalign(opaquePointer) }
        set { gtk_aspect_frame_set_yalign(opaquePointer, newValue) }
    }

    /// The desired aspect ratio (width / height).
    public var ratio: Float {
        get { gtk_aspect_frame_get_ratio(opaquePointer) }
        set { gtk_aspect_frame_set_ratio(opaquePointer, newValue) }
    }

    /// Whether to use the child's aspect ratio instead of the `ratio` property.
    public var obeyChild: Bool {
        get { gtk_aspect_frame_get_obey_child(opaquePointer) != 0 }
        set { gtk_aspect_frame_set_obey_child(opaquePointer, newValue ? 1 : 0) }
    }
}
