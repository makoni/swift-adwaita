import CAdwaita
import GObjectSupport

/// Tracks pointer motion events.
///
/// Wraps `GtkEventControllerMotion`.
@MainActor
public final class EventControllerMotion: GObjectRef {
    /// Creates a new motion event controller.
    public init() {
        let ptr = gtk_event_controller_motion_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Connects to the `motion` signal.
    /// Handler receives: x coordinate, y coordinate.
    @discardableResult
    public func onMotion(_ handler: @escaping @MainActor (Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectDoubleDouble(self, signal: "motion", handler: handler)
    }

    /// Connects to the `enter` signal.
    /// Handler receives: x coordinate, y coordinate.
    @discardableResult
    public func onEnter(_ handler: @escaping @MainActor (Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectDoubleDouble(self, signal: "enter", handler: handler)
    }

    /// Connects to the `leave` signal.
    @discardableResult
    public func onLeave(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "leave", handler: handler)
    }
}
