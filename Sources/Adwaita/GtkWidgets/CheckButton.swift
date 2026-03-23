import CAdwaita
import GObjectSupport

/// A check button widget with an optional label.
///
/// Wraps `GtkCheckButton`. Can also be used as a radio button by grouping.
@MainActor
public final class CheckButton: Widget {
    /// Creates a new check button.
    public init() {
        let ptr = gtk_check_button_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a check button with a label.
    public init(label: String) {
        let ptr = gtk_check_button_new_with_label(label)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a check button with a label and a toggle handler.
    public convenience init(label: String, onToggled handler: @escaping @MainActor () -> Void) {
        self.init(label: label)
        self.onToggled(handler)
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Whether the check button is active (checked).
    public var active: Bool {
        get { gtk_check_button_get_active(castedPointer()) != 0 }
        set { gtk_check_button_set_active(castedPointer(), newValue ? 1 : 0) }
    }

    /// The label text.
    public var label: String? {
        get {
            guard let cStr = gtk_check_button_get_label(castedPointer()) else { return nil }
            return String(cString: cStr)
        }
        set { gtk_check_button_set_label(castedPointer(), newValue) }
    }

    /// Whether the check button is in an inconsistent (tri-state) state.
    public var inconsistent: Bool {
        get { gtk_check_button_get_inconsistent(castedPointer()) != 0 }
        set { gtk_check_button_set_inconsistent(castedPointer(), newValue ? 1 : 0) }
    }

    /// The child widget displayed instead of the label.
    public var child: Widget? {
        get {
            guard let ptr = gtk_check_button_get_child(castedPointer()) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set { gtk_check_button_set_child(castedPointer(), newValue?.widgetPointer) }
    }

    /// Whether the check button uses underline for mnemonics.
    public var useUnderline: Bool {
        get { gtk_check_button_get_use_underline(castedPointer()) != 0 }
        set { gtk_check_button_set_use_underline(castedPointer(), newValue ? 1 : 0) }
    }

    /// Sets the radio group by linking to another check button.
    public func setGroup(_ other: CheckButton?) {
        gtk_check_button_set_group(castedPointer(), other.map { $0.castedPointer() })
    }

    /// Connects to the `toggled` signal.
    @discardableResult
    public func onToggled(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "toggled", handler: handler)
    }
}
