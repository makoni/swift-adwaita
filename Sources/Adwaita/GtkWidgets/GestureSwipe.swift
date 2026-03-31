import CAdwaita
import GObjectSupport

/// Recognizes swipe gestures on a widget.
///
/// Wraps `GtkGestureSwipe`. Reports the velocity of the swipe
/// when the gesture is recognized. Attach to a widget with `addController()`.
///
/// ```swift
/// let swipe = GestureSwipe()
/// swipe.onSwipe { velocityX, velocityY in
///     if velocityX > 500 {
///         print("Fast swipe to the right")
///     } else if velocityX < -500 {
///         print("Fast swipe to the left")
///     }
/// }
/// myWidget.addController(swipe)
/// ```
@MainActor
public final class GestureSwipe: GObjectRef {
    /// Creates a new swipe gesture recognizer.
    public init() {
        let ptr = gtk_gesture_swipe_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Returns the velocity of the current swipe, or nil if no swipe is active.
    public var velocity: (x: Double, y: Double)? {
        var vx: Double = 0
        var vy: Double = 0
        guard gtk_gesture_swipe_get_velocity(opaquePointer, &vx, &vy) != 0 else { return nil }
        return (vx, vy)
    }

    /// Emitted when a swipe gesture is detected.
    ///
    /// - Parameter handler: Called when the swipe is recognized. Receives velocity x and velocity y in pixels per
    /// second.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onSwipe(_ handler: @escaping @MainActor (Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectDoubleDouble(self, signal: .swipe, handler: handler)
    }
}
