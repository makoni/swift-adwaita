import CAdwaita
import GObjectSupport

/// A toggle switch widget.
///
/// Wraps `GtkSwitch`. For Adwaita-styled switches in lists, prefer `SwitchRow`.
@MainActor
public final class Switch: Widget {
    /// Creates a new switch.
    public init() {
        let ptr = gtk_switch_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Whether the switch is active.
    public var active: Bool {
        get { gtk_switch_get_active(opaquePointer) != 0 }
        set { gtk_switch_set_active(opaquePointer, newValue ? 1 : 0) }
    }

    /// Connects to changes of the `active` property.
    @discardableResult
    public func onActiveChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.onNotify(self, property: "active", handler: handler)
    }
}
