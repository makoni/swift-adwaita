// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A page from [class@PreferencesDialog].
@MainActor
public class PreferencesPage: Widget {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `PreferencesPage`.
    public init() {
        let ptr = adw_preferences_page_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a `PreferencesPage` with a title.
    public convenience init(title: String) {
        self.init()
        self.title = title
    }

    /// Creates a `PreferencesPage` with a title and icon name.
    public convenience init(title: String, iconName: String) {
        self.init()
        self.title = title
        self.iconName = iconName
    }

    /// The banner widget displayed at the top of the page, above all groups.
    /// - Since: libadwaita 1.7
    public var banner: Banner? {
        get {
            adw_preferences_page_get_banner(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>)
                .map { Banner(borrowing: UnsafeMutableRawPointer($0)) }
        }
        set { adw_preferences_page_set_banner(
            castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>,
            newValue?.opaquePointer
        ) }
    }

    /// The descriptive text displayed below the page title.
    /// - Since: libadwaita 1.4
    public var description: String {
        get {
            String(
                cString: adw_preferences_page_get_description(
                    castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>
                )
            )
        }
        set {
            adw_preferences_page_set_description(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>, newValue)
        }
    }

    /// Whether the description text is horizontally centered on the page.
    /// - Since: libadwaita 1.6
    public var descriptionCentered: Bool {
        get {
            adw_preferences_page_get_description_centered(
                castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>
            ) !=
                0
        }
        set { adw_preferences_page_set_description_centered(
            castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>,
            newValue ? 1 : 0
        ) }
    }

    /// The icon name shown alongside the page title in the sidebar or tab bar.
    public var iconName: String? {
        get {
            adw_preferences_page_get_icon_name(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>)
                .map { String(cString: $0) }
        }
        set { adw_preferences_page_set_icon_name(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>, newValue)
        }
    }

    /// A unique identifier for the page, used for programmatic navigation.
    public var name: String? {
        get {
            adw_preferences_page_get_name(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>)
                .map { String(cString: $0) }
        }
        set { adw_preferences_page_set_name(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>, newValue) }
    }

    /// The title displayed in the sidebar or tab bar for this page.
    public var title: String {
        get {
            String(cString: adw_preferences_page_get_title(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>))
        }
        set { adw_preferences_page_set_title(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>, newValue) }
    }

    /// Whether an underscore in the title indicates a mnemonic accelerator.
    public var useUnderline: Bool {
        get { adw_preferences_page_get_use_underline(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>) != 0 }
        set { adw_preferences_page_set_use_underline(
            castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>,
            newValue ? 1 : 0
        ) }
    }

    /// Adds a preferences group to this page.
    ///
    /// - Parameter group: The preferences group widget to add.
    public func add(_ group: Widget) {
        adw_preferences_page_add(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>, group.castedPointer())
    }

    /// Removes a preferences group from this page.
    ///
    /// - Parameter group: The preferences group widget to remove.
    public func remove(_ group: Widget) {
        adw_preferences_page_remove(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>, group.castedPointer())
    }

    /// Returns the preferences group at the given index.
    @discardableResult
    public func getGroup(_ index: Int) -> PreferencesGroup? {
        adw_preferences_page_get_group(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>, UInt32(index))
            .map { PreferencesGroup(borrowing: UnsafeMutableRawPointer($0)) }
    }

    /// Scrolls the page content back to the top.
    public func scrollToTop() {
        adw_preferences_page_scroll_to_top(castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>)
    }
}
