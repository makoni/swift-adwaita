// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A [class@Gtk.ListBoxRow] that looks like a button.
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

    /// The `end-icon-name` property.
    /// - Since: libadwaita 1.6
    public var endIconName: String? {
        get { (adw_button_row_get_end_icon_name(opaquePointer)).map { String(cString: $0) } }
        set { adw_button_row_set_end_icon_name(opaquePointer, newValue) }
    }

    /// The `start-icon-name` property.
    /// - Since: libadwaita 1.6
    public var startIconName: String? {
        get { (adw_button_row_get_start_icon_name(opaquePointer)).map { String(cString: $0) } }
        set { adw_button_row_set_start_icon_name(opaquePointer, newValue) }
    }

    /// Connects to the `activated` signal.
    @discardableResult
    public func onActivated(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .activated, handler: handler)
    }
}
