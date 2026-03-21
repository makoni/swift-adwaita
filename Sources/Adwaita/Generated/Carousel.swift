// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A paginated scrolling widget.
@MainActor
public final class Carousel: Widget {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `Carousel`.
    public init() {
        let ptr = adw_carousel_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `allow-long-swipes` property.
    public var allowLongSwipes: Bool {
        get { adw_carousel_get_allow_long_swipes(opaquePointer) != 0 }
        set { adw_carousel_set_allow_long_swipes(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `allow-mouse-drag` property.
    public var allowMouseDrag: Bool {
        get { adw_carousel_get_allow_mouse_drag(opaquePointer) != 0 }
        set { adw_carousel_set_allow_mouse_drag(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `allow-scroll-wheel` property.
    public var allowScrollWheel: Bool {
        get { adw_carousel_get_allow_scroll_wheel(opaquePointer) != 0 }
        set { adw_carousel_set_allow_scroll_wheel(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `interactive` property.
    public var interactive: Bool {
        get { adw_carousel_get_interactive(opaquePointer) != 0 }
        set { adw_carousel_set_interactive(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `n-pages` property (read-only).
    public var nPages: UInt32 {
        adw_carousel_get_n_pages(opaquePointer)
    }

    /// The `position` property (read-only).
    public var position: Double {
        adw_carousel_get_position(opaquePointer)
    }

    /// The `reveal-duration` property.
    public var revealDuration: UInt32 {
        get { adw_carousel_get_reveal_duration(opaquePointer) }
        set { adw_carousel_set_reveal_duration(opaquePointer, newValue) }
    }

    /// The `scroll-params` property.
    public var scrollParams: OpaquePointer {
        get { adw_carousel_get_scroll_params(opaquePointer) }
        set { adw_carousel_set_scroll_params(opaquePointer, newValue) }
    }

    /// The `spacing` property.
    public var spacing: UInt32 {
        get { adw_carousel_get_spacing(opaquePointer) }
        set { adw_carousel_set_spacing(opaquePointer, newValue) }
    }

    /// Calls `adw_carousel_append`.
    public func append(_ child: Widget) {
        adw_carousel_append(opaquePointer, child.widgetPointer)
    }

    /// Calls `adw_carousel_get_nth_page`.
    @discardableResult
    public func getNthPage(_ n: UInt32) -> Widget {
        return Widget(borrowing: UnsafeMutableRawPointer(adw_carousel_get_nth_page(opaquePointer, n)))
    }

    /// Calls `adw_carousel_insert`.
    public func insert(_ child: Widget, position: Int32) {
        adw_carousel_insert(opaquePointer, child.widgetPointer, position)
    }

    /// Calls `adw_carousel_prepend`.
    public func prepend(_ child: Widget) {
        adw_carousel_prepend(opaquePointer, child.widgetPointer)
    }

    /// Calls `adw_carousel_remove`.
    public func remove(_ child: Widget) {
        adw_carousel_remove(opaquePointer, child.widgetPointer)
    }

    /// Calls `adw_carousel_reorder`.
    public func reorder(_ child: Widget, position: Int32) {
        adw_carousel_reorder(opaquePointer, child.widgetPointer, position)
    }

    /// Calls `adw_carousel_scroll_to`.
    public func scrollTo(_ widget: Widget, animate: Bool) {
        adw_carousel_scroll_to(opaquePointer, widget.widgetPointer, animate ? 1 : 0)
    }

    /// Connects to the `page-changed` signal.
    @discardableResult
    public func onPageChanged(_ handler: @escaping @MainActor (UInt32) -> Void) -> SignalConnection {
        SignalHelper.connectUInt(self, signal: "page-changed", handler: handler)
    }
}
