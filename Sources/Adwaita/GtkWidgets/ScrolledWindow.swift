import CAdwaita
import GObjectSupport

/// A scrollable container.
///
/// Wraps `GtkScrolledWindow`. Provides scrollbars and kinetic scrolling
/// for a child widget that is larger than the allocated space.
@MainActor
public final class ScrolledWindow: Widget {
    /// Creates a new scrolled window.
    public init() {
        let ptr = gtk_scrolled_window_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The child widget.
    public var child: Widget? {
        get {
            guard let ptr = gtk_scrolled_window_get_child(opaquePointer) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set { gtk_scrolled_window_set_child(opaquePointer, newValue?.widgetPointer) }
    }

    /// The minimum content width.
    public var minContentWidth: Int32 {
        get { gtk_scrolled_window_get_min_content_width(opaquePointer) }
        set { gtk_scrolled_window_set_min_content_width(opaquePointer, newValue) }
    }

    /// The minimum content height.
    public var minContentHeight: Int32 {
        get { gtk_scrolled_window_get_min_content_height(opaquePointer) }
        set { gtk_scrolled_window_set_min_content_height(opaquePointer, newValue) }
    }

    /// Sets the scrollbar policy for both axes.
    public func setPolicy(horizontal: GtkPolicyType, vertical: GtkPolicyType) {
        gtk_scrolled_window_set_policy(opaquePointer, horizontal, vertical)
    }

    /// Whether kinetic scrolling is enabled.
    public var kineticScrolling: Bool {
        get { gtk_scrolled_window_get_kinetic_scrolling(opaquePointer) != 0 }
        set { gtk_scrolled_window_set_kinetic_scrolling(opaquePointer, newValue ? 1 : 0) }
    }
}
