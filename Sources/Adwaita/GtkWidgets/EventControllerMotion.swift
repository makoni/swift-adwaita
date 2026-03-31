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

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Emitted when the pointer moves over the widget.
    ///
    /// - Parameter handler: Called when the pointer moves. Receives the x and y coordinates.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onMotion(_ handler: @escaping @MainActor (Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectDoubleDouble(self, signal: .motion, handler: handler)
    }

    /// Emitted when the pointer enters the widget.
    ///
    /// - Parameter handler: Called when the pointer enters. Receives the x and y coordinates.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onEnter(_ handler: @escaping @MainActor (Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectDoubleDouble(self, signal: .enter, handler: handler)
    }

    /// Emitted when the pointer leaves the widget.
    ///
    /// - Parameter handler: Called when the pointer leaves.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onLeave(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .leave, handler: handler)
    }
}
