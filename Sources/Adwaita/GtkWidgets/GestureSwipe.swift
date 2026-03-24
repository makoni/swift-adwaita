import CAdwaita
import GObjectSupport

/// Recognizes swipe gestures on a widget.
///
/// Wraps `GtkGestureSwipe`. Reports the velocity of the swipe
/// when the gesture is recognized.
@MainActor
public final class GestureSwipe: GObjectRef {
    /// Creates a new swipe gesture recognizer.
    public init() {
        let ptr = gtk_gesture_swipe_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Returns the velocity of the current swipe, or nil if no swipe is active.
    public var velocity: (x: Double, y: Double)? {
        var vx: Double = 0
        var vy: Double = 0
        guard gtk_gesture_swipe_get_velocity(opaquePointer, &vx, &vy) != 0 else { return nil }
        return (vx, vy)
    }

    /// Connects to the `swipe` signal.
    /// Handler receives: velocity x, velocity y (pixels per second).
    @discardableResult
    public func onSwipe(_ handler: @escaping @MainActor (Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectDoubleDouble(self, signal: .swipe, handler: handler)
    }
}
