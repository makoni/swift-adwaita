import CAdwaita
import GObjectSupport

/// Tracks keyboard focus events.
///
/// Wraps `GtkEventControllerFocus`. Notifies when a widget gains or loses
/// keyboard focus. Attach to a widget with `addController()`.
///
/// ```swift
/// let focusController = EventControllerFocus()
/// focusController.onEnter {
///     print("Widget gained focus")
/// }
/// focusController.onLeave {
///     print("Widget lost focus")
/// }
/// entry.addController(focusController)
///
/// // Query focus state at any time
/// if focusController.isFocus {
///     print("Currently focused")
/// }
/// ```
@MainActor
public final class EventControllerFocus: GObjectRef {
    /// Creates a new focus event controller.
    public init() {
        let ptr = gtk_event_controller_focus_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
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
        SignalHelper.connect(self, signal: .enter, handler: handler)
    }

    /// Connects to the `leave` signal — widget loses focus.
    @discardableResult
    public func onLeave(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .leave, handler: handler)
    }
}
