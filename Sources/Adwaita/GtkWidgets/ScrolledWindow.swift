import CAdwaita
import GObjectSupport

/// A scrollable container that adds scrollbars around a child widget.
///
/// Wraps `GtkScrolledWindow`. Provides scrollbars and kinetic scrolling
/// for a child widget that is larger than the allocated space. Commonly
/// used to wrap ``ListView``, ``ListBox``, or any tall/wide content.
///
/// ```swift
/// // Wrap a ListView in a scrolled window
/// let listView = ListView(model: selection, factory: factory)
/// let scrolled = ScrolledWindow(child: listView)
/// scrolled.minContentHeight = 300
/// scrolled.setPolicy(horizontal: GTK_POLICY_NEVER, vertical: GTK_POLICY_AUTOMATIC)
///
/// // Scrollable text area
/// let textView = TextView()
/// let scrolled = ScrolledWindow(child: textView)
/// scrolled.vexpand = true
/// ```
@MainActor
public final class ScrolledWindow: Widget {
    /// Creates a new scrolled window.
    public init() {
        let ptr = gtk_scrolled_window_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a scrolled window wrapping the given child.
    public convenience init(child: Widget) {
        self.init()
        self.child = child
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The child widget displayed inside the scrollable area.
    public var child: Widget? {
        get {
            guard let ptr = gtk_scrolled_window_get_child(opaquePointer) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set { gtk_scrolled_window_set_child(opaquePointer, newValue?.widgetPointer) }
    }

    /// The minimum content width in pixels. The scrolled window will not shrink below this width.
    public var minContentWidth: Int {
        get { Int(gtk_scrolled_window_get_min_content_width(opaquePointer)) }
        set { gtk_scrolled_window_set_min_content_width(opaquePointer, Int32(newValue)) }
    }

    /// The minimum content height in pixels. The scrolled window will not shrink below this height.
    public var minContentHeight: Int {
        get { Int(gtk_scrolled_window_get_min_content_height(opaquePointer)) }
        set { gtk_scrolled_window_set_min_content_height(opaquePointer, Int32(newValue)) }
    }

    /// Sets the scrollbar policy for both axes.
    ///
    /// Common policies: `GTK_POLICY_AUTOMATIC` (show when needed),
    /// `GTK_POLICY_NEVER` (never show), `GTK_POLICY_ALWAYS` (always show).
    public func setPolicy(horizontal: GtkPolicyType, vertical: GtkPolicyType) {
        gtk_scrolled_window_set_policy(opaquePointer, horizontal, vertical)
    }

    /// Whether kinetic scrolling is enabled.
    public var kineticScrolling: Bool {
        get { gtk_scrolled_window_get_kinetic_scrolling(opaquePointer) != 0 }
        set { gtk_scrolled_window_set_kinetic_scrolling(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether overlay scrollbars are used (scrollbars drawn on top of the content
    /// and automatically hidden when not in use).
    public var overlayScrolling: Bool {
        get { gtk_scrolled_window_get_overlay_scrolling(opaquePointer) != 0 }
        set { gtk_scrolled_window_set_overlay_scrolling(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the natural height of the child should be propagated as the
    /// natural height of the scrolled window.
    public var propagateNaturalHeight: Bool {
        get { gtk_scrolled_window_get_propagate_natural_height(opaquePointer) != 0 }
        set { gtk_scrolled_window_set_propagate_natural_height(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the natural width of the child should be propagated as the
    /// natural width of the scrolled window.
    public var propagateNaturalWidth: Bool {
        get { gtk_scrolled_window_get_propagate_natural_width(opaquePointer) != 0 }
        set { gtk_scrolled_window_set_propagate_natural_width(opaquePointer, newValue ? 1 : 0) }
    }

    /// The vertical adjustment controlling the scroll position.
    public var verticalAdjustment: Adjustment {
        let ptr = gtk_scrolled_window_get_vadjustment(opaquePointer)!
        return Adjustment(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// The horizontal adjustment controlling the scroll position.
    public var horizontalAdjustment: Adjustment {
        let ptr = gtk_scrolled_window_get_hadjustment(opaquePointer)!
        return Adjustment(borrowing: UnsafeMutableRawPointer(ptr))
    }
}
