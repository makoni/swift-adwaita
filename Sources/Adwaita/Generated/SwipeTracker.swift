// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A swipe tracker used in [class@Carousel], [class@NavigationView] and
/// [class@OverlaySplitView].
@MainActor
public final class SwipeTracker: GObjectRef {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `SwipeTracker` for the given swipeable widget.
    public init(swipeable: any Swipeable) {
        let ptr = adw_swipe_tracker_new(swipeable.swipeablePointer)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Whether the swipe can skip more than one snap point at a time (e.g. skipping multiple pages in a carousel).
    public var allowLongSwipes: Bool {
        get { adw_swipe_tracker_get_allow_long_swipes(opaquePointer) != 0 }
        set { adw_swipe_tracker_set_allow_long_swipes(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether mouse click-and-drag gestures are treated as swipes in addition to touch gestures.
    public var allowMouseDrag: Bool {
        get { adw_swipe_tracker_get_allow_mouse_drag(opaquePointer) != 0 }
        set { adw_swipe_tracker_set_allow_mouse_drag(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether swiping is allowed over window handle areas (title bars and similar drag regions).
    /// - Since: libadwaita 1.5
    public var allowWindowHandle: Bool {
        get { adw_swipe_tracker_get_allow_window_handle(opaquePointer) != 0 }
        set { adw_swipe_tracker_set_allow_window_handle(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether this swipe tracker is actively handling swipe gestures.
    public var enabled: Bool {
        get { adw_swipe_tracker_get_enabled(opaquePointer) != 0 }
        set { adw_swipe_tracker_set_enabled(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the user can swipe past the first snap point, creating a spring-back overshoot effect.
    /// - Since: libadwaita 1.4
    public var lowerOvershoot: Bool {
        get { adw_swipe_tracker_get_lower_overshoot(opaquePointer) != 0 }
        set { adw_swipe_tracker_set_lower_overshoot(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the swipe direction is reversed (e.g. swiping right goes to the previous page instead of the next).
    public var reversed: Bool {
        get { adw_swipe_tracker_get_reversed(opaquePointer) != 0 }
        set { adw_swipe_tracker_set_reversed(opaquePointer, newValue ? 1 : 0) }
    }

    /// The swipeable widget this tracker is attached to.
    public var swipeable: GObjectRef {
        let ptr = adw_swipe_tracker_get_swipeable(opaquePointer)!
        return GObjectRef(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Whether the user can swipe past the last snap point, creating a spring-back overshoot effect.
    /// - Since: libadwaita 1.4
    public var upperOvershoot: Bool {
        get { adw_swipe_tracker_get_upper_overshoot(opaquePointer) != 0 }
        set { adw_swipe_tracker_set_upper_overshoot(opaquePointer, newValue ? 1 : 0) }
    }

    /// Shifts all snap points by the given offset, adjusting the swipe position accordingly.
    ///
    /// This is useful when the number of pages changes during a swipe.
    ///
    /// - Parameter delta: The offset to add to the current position and snap points.
    public func shiftPosition(_ delta: Double) {
        adw_swipe_tracker_shift_position(opaquePointer, delta)
    }

    /// Emitted when a swipe gesture begins.
    ///
    /// - Parameter handler: A closure invoked at the start of the swipe.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onBeginSwipe(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .beginSwipe, handler: handler)
    }

    /// Emitted when the user lifts their finger and the swipe gesture ends.
    ///
    /// - Parameter handler: A closure receiving the final velocity and the snap point the swipe will settle to.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onEndSwipe(_ handler: @escaping @MainActor (Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectDoubleDouble(self, signal: .endSwipe, handler: handler)
    }

    /// Emitted when the tracker is preparing for a new swipe, before the gesture starts.
    ///
    /// - Parameter handler: A closure receiving the navigation direction (back or forward) of the upcoming swipe.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onPrepare(_ handler: @escaping @MainActor (AdwNavigationDirection) -> Void) -> SignalConnection {
        SignalHelper.connectEnum(self, signal: .prepare, handler: handler)
    }

    /// Emitted on each frame while the swipe gesture is in progress.
    ///
    /// - Parameter handler: A closure receiving the current swipe progress as a fractional position between snap
    /// points.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onUpdateSwipe(_ handler: @escaping @MainActor (Double) -> Void) -> SignalConnection {
        SignalHelper.connectDouble(self, signal: .updateSwipe, handler: handler)
    }
}
