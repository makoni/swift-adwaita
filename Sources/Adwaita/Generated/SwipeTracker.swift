// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A swipe tracker used in [class@Carousel], [class@NavigationView] and
/// [class@OverlaySplitView].
@MainActor
public final class SwipeTracker: GObjectRef {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `SwipeTracker`.
    public init(swipeable: OpaquePointer) {
        let ptr = adw_swipe_tracker_new(swipeable)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `allow-long-swipes` property.
    public var allowLongSwipes: Bool {
        get { adw_swipe_tracker_get_allow_long_swipes(opaquePointer) != 0 }
        set { adw_swipe_tracker_set_allow_long_swipes(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `allow-mouse-drag` property.
    public var allowMouseDrag: Bool {
        get { adw_swipe_tracker_get_allow_mouse_drag(opaquePointer) != 0 }
        set { adw_swipe_tracker_set_allow_mouse_drag(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `allow-window-handle` property.
    /// - Since: libadwaita 1.5
    public var allowWindowHandle: Bool {
        get { adw_swipe_tracker_get_allow_window_handle(opaquePointer) != 0 }
        set { adw_swipe_tracker_set_allow_window_handle(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `enabled` property.
    public var enabled: Bool {
        get { adw_swipe_tracker_get_enabled(opaquePointer) != 0 }
        set { adw_swipe_tracker_set_enabled(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `lower-overshoot` property.
    /// - Since: libadwaita 1.4
    public var lowerOvershoot: Bool {
        get { adw_swipe_tracker_get_lower_overshoot(opaquePointer) != 0 }
        set { adw_swipe_tracker_set_lower_overshoot(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `reversed` property.
    public var reversed: Bool {
        get { adw_swipe_tracker_get_reversed(opaquePointer) != 0 }
        set { adw_swipe_tracker_set_reversed(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `swipeable` property (read-only).
    public var swipeable: OpaquePointer {
        adw_swipe_tracker_get_swipeable(opaquePointer)
    }

    /// The `upper-overshoot` property.
    /// - Since: libadwaita 1.4
    public var upperOvershoot: Bool {
        get { adw_swipe_tracker_get_upper_overshoot(opaquePointer) != 0 }
        set { adw_swipe_tracker_set_upper_overshoot(opaquePointer, newValue ? 1 : 0) }
    }

    /// Calls `adw_swipe_tracker_shift_position`.
    public func shiftPosition(_ delta: Double) {
        adw_swipe_tracker_shift_position(opaquePointer, delta)
    }

    /// Connects to the `begin-swipe` signal.
    @discardableResult
    public func onBeginSwipe(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "begin-swipe", handler: handler)
    }

    /// Connects to the `end-swipe` signal.
    @discardableResult
    public func onEndSwipe(_ handler: @escaping @MainActor (Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectDoubleDouble(self, signal: "end-swipe", handler: handler)
    }

    /// Connects to the `prepare` signal.
    @discardableResult
    public func onPrepare(_ handler: @escaping @MainActor (AdwNavigationDirection) -> Void) -> SignalConnection {
        SignalHelper.connectEnum(self, signal: "prepare", handler: handler)
    }

    /// Connects to the `update-swipe` signal.
    @discardableResult
    public func onUpdateSwipe(_ handler: @escaping @MainActor (Double) -> Void) -> SignalConnection {
        SignalHelper.connectDouble(self, signal: "update-swipe", handler: handler)
    }
}
