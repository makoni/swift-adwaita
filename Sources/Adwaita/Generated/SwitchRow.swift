// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A [class@Gtk.ListBoxRow] used to represent two states.
/// - Since: libadwaita 1.4
@MainActor
public final class SwitchRow: ActionRow {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `SwitchRow`.
    override public init() {
        let ptr = adw_switch_row_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a `SwitchRow` with a title.
    public convenience init(title: String) {
        self.init()
        self.title = title
    }

    /// Creates a `SwitchRow` with a title and initial active state.
    public convenience init(title: String, active: Bool) {
        self.init()
        self.title = title
        self.active = active
    }

    /// The `active` property.
    /// - Since: libadwaita 1.4
    public var active: Bool {
        get { adw_switch_row_get_active(opaquePointer) != 0 }
        set { adw_switch_row_set_active(opaquePointer, newValue ? 1 : 0) }
    }
}
