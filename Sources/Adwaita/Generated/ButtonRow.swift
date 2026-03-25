// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A clickable row that looks like a button inside a list box.
///
/// Wraps `AdwButtonRow`. A `PreferencesRow` subclass styled to look and
/// behave like a button. Ideal for action items in preference panels, such
/// as "Reset Settings" or "Export Data".
///
/// ```swift
/// let row = ButtonRow()
/// row.title = "Reset All Settings"
/// row.startIconName = "edit-clear-symbolic"
///
/// row.onActivated {
///     print("Settings reset")
/// }
///
/// listBox.append(row)
/// ```
///
/// - Key properties:
///   - ``startIconName``: An icon displayed at the leading edge of the row.
///   - ``endIconName``: An icon displayed at the trailing edge of the row.
/// - Key methods:
///   - ``onActivated(_:)``: Connects a handler called when the row is activated.
/// - Since: libadwaita 1.6
@MainActor
public final class ButtonRow: PreferencesRow {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ButtonRow`.
    override public init() {
        let ptr = adw_button_row_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The icon name displayed at the trailing edge of the row.
    /// - Since: libadwaita 1.6
    public var endIconName: String? {
        get { (adw_button_row_get_end_icon_name(opaquePointer)).map { String(cString: $0) } }
        set { adw_button_row_set_end_icon_name(opaquePointer, newValue) }
    }

    /// The icon name displayed at the leading edge of the row.
    /// - Since: libadwaita 1.6
    public var startIconName: String? {
        get { (adw_button_row_get_start_icon_name(opaquePointer)).map { String(cString: $0) } }
        set { adw_button_row_set_start_icon_name(opaquePointer, newValue) }
    }

    /// Emitted when the row is clicked or activated via keyboard.
    @discardableResult
    public func onActivated(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .activated, handler: handler)
    }
}
