// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A [class@Gtk.ListBoxRow] used to represent two states.
/// - Since: libadwaita 1.4
@MainActor
public final class SwitchRow: ActionRow {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `SwitchRow`.
    override public init() {
        let ptr = adw_switch_row_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `active` property.
    /// - Since: libadwaita 1.4
    public var active: Bool {
        get { adw_switch_row_get_active(opaquePointer) != 0 }
        set { adw_switch_row_set_active(opaquePointer, newValue ? 1 : 0) }
    }
}
