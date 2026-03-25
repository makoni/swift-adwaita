import CAdwaita
import GObjectSupport

/// Tracks pointer motion events.
///
/// Wraps `GtkEventControllerMotion`. Reports cursor position as it moves
/// over a widget, plus enter/leave signals. Attach with `addController()`.
///
/// ```swift
/// let motion = EventControllerMotion()
/// motion.onEnter { x, y in
///     print("Pointer entered at (\(x), \(y))")
/// }
/// motion.onMotion { x, y in
///     print("Pointer at (\(x), \(y))")
/// }
/// motion.onLeave {
///     print("Pointer left the widget")
/// }
/// drawingArea.addController(motion)
/// ```
@MainActor
public final class EventControllerMotion: GObjectRef {
    /// Creates a new motion event controller.
    public init() {
        let ptr = gtk_event_controller_motion_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Connects to the `motion` signal.
    /// Handler receives: x coordinate, y coordinate.
    @discardableResult
    public func onMotion(_ handler: @escaping @MainActor (Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectDoubleDouble(self, signal: .motion, handler: handler)
    }

    /// Connects to the `enter` signal.
    /// Handler receives: x coordinate, y coordinate.
    @discardableResult
    public func onEnter(_ handler: @escaping @MainActor (Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectDoubleDouble(self, signal: .enter, handler: handler)
    }

    /// Connects to the `leave` signal.
    @discardableResult
    public func onLeave(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .leave, handler: handler)
    }
}
