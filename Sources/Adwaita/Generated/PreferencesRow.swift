// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A [class@Gtk.ListBoxRow] used to present preferences.
@MainActor
public class PreferencesRow: ListBoxRow {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `PreferencesRow`.
    public init() {
        let ptr = adw_preferences_row_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `title` property.
    public var title: String {
        get { String(cString: adw_preferences_row_get_title(castedPointer() as UnsafeMutablePointer<AdwPreferencesRow>)) }
        set { adw_preferences_row_set_title(castedPointer() as UnsafeMutablePointer<AdwPreferencesRow>, newValue) }
    }

    /// The `title-selectable` property.
    /// - Since: libadwaita 1.1
    public var titleSelectable: Bool {
        get { adw_preferences_row_get_title_selectable(castedPointer() as UnsafeMutablePointer<AdwPreferencesRow>) != 0 }
        set { adw_preferences_row_set_title_selectable(castedPointer() as UnsafeMutablePointer<AdwPreferencesRow>, newValue ? 1 : 0) }
    }

    /// The `use-markup` property.
    /// - Since: libadwaita 1.2
    public var useMarkup: Bool {
        get { adw_preferences_row_get_use_markup(castedPointer() as UnsafeMutablePointer<AdwPreferencesRow>) != 0 }
        set { adw_preferences_row_set_use_markup(castedPointer() as UnsafeMutablePointer<AdwPreferencesRow>, newValue ? 1 : 0) }
    }

    /// The `use-underline` property.
    public var useUnderline: Bool {
        get { adw_preferences_row_get_use_underline(castedPointer() as UnsafeMutablePointer<AdwPreferencesRow>) != 0 }
        set { adw_preferences_row_set_use_underline(castedPointer() as UnsafeMutablePointer<AdwPreferencesRow>, newValue ? 1 : 0) }
    }
}
