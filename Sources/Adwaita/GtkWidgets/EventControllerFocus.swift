import CAdwaita
import GObjectSupport

/// Tracks keyboard focus events.
///
/// Wraps `GtkEventControllerFocus`.
@MainActor
public final class EventControllerFocus: GObjectRef {
    /// Creates a new focus event controller.
    public init() {
        let ptr = gtk_event_controller_focus_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Whether the widget has focus.
    public var isFocus: Bool {
        gtk_event_controller_focus_is_focus(opaquePointer) != 0
    }

    /// Whether the widget or one of its descendants has focus.
    public var containsFocus: Bool {
        gtk_event_controller_focus_contains_focus(opaquePointer) != 0
    }

    /// Connects to the `enter` signal — widget gains focus.
    @discardableResult
    public func onEnter(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "enter", handler: handler)
    }

    /// Connects to the `leave` signal — widget loses focus.
    @discardableResult
    public func onLeave(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "leave", handler: handler)
    }
}
