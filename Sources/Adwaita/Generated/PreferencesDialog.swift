// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A dialog showing application's preferences.
/// - Since: libadwaita 1.5
@MainActor
open class PreferencesDialog: Dialog {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `PreferencesDialog`.
    override public init() {
        let ptr = adw_preferences_dialog_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `search-enabled` property.
    /// - Since: libadwaita 1.5
    public var searchEnabled: Bool {
        get { adw_preferences_dialog_get_search_enabled(castedPointer() as UnsafeMutablePointer<AdwPreferencesDialog>) != 0 }
        set { adw_preferences_dialog_set_search_enabled(castedPointer() as UnsafeMutablePointer<AdwPreferencesDialog>, newValue ? 1 : 0) }
    }

    /// The `visible-page-name` property.
    /// - Since: libadwaita 1.5
    public var visiblePageName: String? {
        get { (adw_preferences_dialog_get_visible_page_name(castedPointer() as UnsafeMutablePointer<AdwPreferencesDialog>)).map { String(cString: $0) } }
        set { adw_preferences_dialog_set_visible_page_name(castedPointer() as UnsafeMutablePointer<AdwPreferencesDialog>, newValue) }
    }

    /// Calls `adw_preferences_dialog_add_toast`.
    public func addToast(_ toast: OpaquePointer) {
        adw_preferences_dialog_add_toast(castedPointer() as UnsafeMutablePointer<AdwPreferencesDialog>, toast)
    }

    /// Calls `adw_preferences_dialog_pop_subpage`.
    public func popSubpage() -> Bool {
        return adw_preferences_dialog_pop_subpage(castedPointer() as UnsafeMutablePointer<AdwPreferencesDialog>) != 0
    }
}
