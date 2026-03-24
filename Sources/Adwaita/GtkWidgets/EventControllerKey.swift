import CAdwaita
import GObjectSupport

/// Handles keyboard input events.
///
/// Wraps `GtkEventControllerKey`.
@MainActor
public final class EventControllerKey: GObjectRef {
    /// Creates a new keyboard event controller.
    public init() {
        let ptr = gtk_event_controller_key_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Connects to the `key-pressed` signal.
    /// Handler receives: keyval (GDK key code), keycode, modifier state.
    /// Return `true` to stop propagation.
    @discardableResult
    public func onKeyPressed(_ handler: @escaping @MainActor (UInt32, UInt32, GdkModifierType) -> Bool) -> SignalConnection {
        SignalHelper.connectUIntUIntUIntReturnBool(self, signal: .keyPressed) { keyval, keycode, state in
            handler(keyval, keycode, GdkModifierType(rawValue: state))
        }
    }

    /// Connects to the `key-released` signal.
    /// Handler receives: keyval (GDK key code), keycode, modifier state.
    @discardableResult
    public func onKeyReleased(_ handler: @escaping @MainActor (UInt32, UInt32, GdkModifierType) -> Void) -> SignalConnection {
        SignalHelper.connectUIntUIntUInt(self, signal: .keyReleased) { keyval, keycode, state in
            handler(keyval, keycode, GdkModifierType(rawValue: state))
        }
    }
}
