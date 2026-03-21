import CAdwaita
import GObjectSupport

/// A button that retains its pressed/active state.
///
/// Wraps `GtkToggleButton`.
@MainActor
public final class ToggleButton: Widget {
    /// Creates a new toggle button.
    public init() {
        let ptr = gtk_toggle_button_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a toggle button with a label.
    public init(label: String) {
        let ptr = gtk_toggle_button_new_with_label(label)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Whether the button is active (pressed).
    public var active: Bool {
        get { gtk_toggle_button_get_active(castedPointer()) != 0 }
        set { gtk_toggle_button_set_active(castedPointer(), newValue ? 1 : 0) }
    }

    /// Sets the radio group by linking to another toggle button.
    public func setGroup(_ other: ToggleButton?) {
        gtk_toggle_button_set_group(castedPointer(), other.map { $0.castedPointer() })
    }

    /// Connects to the `toggled` signal.
    @discardableResult
    public func onToggled(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "toggled", handler: handler)
    }
}
