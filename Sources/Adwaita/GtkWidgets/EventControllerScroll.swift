import CAdwaita
import GObjectSupport

/// Handles scroll events.
///
/// Wraps `GtkEventControllerScroll`.
@MainActor
public final class EventControllerScroll: GObjectRef {
    /// Creates a scroll event controller with the given flags.
    public init(flags: GtkEventControllerScrollFlags = GTK_EVENT_CONTROLLER_SCROLL_BOTH_AXES) {
        let ptr = gtk_event_controller_scroll_new(flags)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Connects to the `scroll` signal.
    /// Handler receives: dx, dy deltas. Return `true` to stop propagation.
    @discardableResult
    public func onScroll(_ handler: @escaping @MainActor (Double, Double) -> Bool) -> SignalConnection {
        SignalHelper.connectDoubleDoubleReturnBool(self, signal: "scroll", handler: handler)
    }

    /// Connects to the `scroll-begin` signal.
    @discardableResult
    public func onScrollBegin(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "scroll-begin", handler: handler)
    }

    /// Connects to the `scroll-end` signal.
    @discardableResult
    public func onScrollEnd(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "scroll-end", handler: handler)
    }
}
