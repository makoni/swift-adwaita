// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A page from [class@PreferencesDialog].
@MainActor
open class PreferencesPage: Widget {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `PreferencesPage`.
    public init() {
        let ptr = adw_preferences_page_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `banner` property.
    /// - Since: libadwaita 1.7
    public var banner: OpaquePointer? {
        get { adw_preferences_page_get_banner(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>) }
        set { adw_preferences_page_set_banner(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>, newValue) }
    }

    /// The `description` property.
    /// - Since: libadwaita 1.4
    public var description: String {
        get { String(cString: adw_preferences_page_get_description(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>)) }
        set { adw_preferences_page_set_description(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>, newValue) }
    }

    /// The `description-centered` property.
    /// - Since: libadwaita 1.6
    public var descriptionCentered: Bool {
        get { adw_preferences_page_get_description_centered(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>) != 0 }
        set { adw_preferences_page_set_description_centered(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>, newValue ? 1 : 0) }
    }

    /// The `icon-name` property.
    public var iconName: String? {
        get { (adw_preferences_page_get_icon_name(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>)).map { String(cString: $0) } }
        set { adw_preferences_page_set_icon_name(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>, newValue) }
    }

    /// The `name` property.
    public var name: String? {
        get { (adw_preferences_page_get_name(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>)).map { String(cString: $0) } }
        set { adw_preferences_page_set_name(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>, newValue) }
    }

    /// The `title` property.
    public var title: String {
        get { String(cString: adw_preferences_page_get_title(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>)) }
        set { adw_preferences_page_set_title(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>, newValue) }
    }

    /// The `use-underline` property.
    public var useUnderline: Bool {
        get { adw_preferences_page_get_use_underline(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>) != 0 }
        set { adw_preferences_page_set_use_underline(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>, newValue ? 1 : 0) }
    }

    /// Calls `adw_preferences_page_add`.
    public func add(_ group: Widget) {
        adw_preferences_page_add(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>, group.castedPointer())
    }

    /// Calls `adw_preferences_page_remove`.
    public func remove(_ group: Widget) {
        adw_preferences_page_remove(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>, group.castedPointer())
    }

    /// Calls `adw_preferences_page_get_group`.
    @discardableResult
    public func getGroup(_ index: UInt32) -> OpaquePointer? {
        return (adw_preferences_page_get_group(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>, index)).map { OpaquePointer($0) }
    }

    /// Calls `adw_preferences_page_scroll_to_top`.
    public func scrollToTop() {
        adw_preferences_page_scroll_to_top(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>)
    }
}
