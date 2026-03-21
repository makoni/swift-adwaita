// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A group of preference rows.
@MainActor
open class PreferencesGroup: Widget {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `PreferencesGroup`.
    public init() {
        let ptr = adw_preferences_group_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `description` property.
    public var description: String? {
        get { (adw_preferences_group_get_description(castedPointer() as UnsafeMutablePointer<AdwPreferencesGroup>)).map { String(cString: $0) } }
        set { adw_preferences_group_set_description(castedPointer() as UnsafeMutablePointer<AdwPreferencesGroup>, newValue) }
    }

    /// The `header-suffix` property.
    /// - Since: libadwaita 1.1
    public var headerSuffix: Widget? {
        get { (adw_preferences_group_get_header_suffix(castedPointer() as UnsafeMutablePointer<AdwPreferencesGroup>)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_preferences_group_set_header_suffix(castedPointer() as UnsafeMutablePointer<AdwPreferencesGroup>, newValue?.widgetPointer) }
    }

    /// The `separate-rows` property.
    /// - Since: libadwaita 1.6
    public var separateRows: Bool {
        get { adw_preferences_group_get_separate_rows(castedPointer() as UnsafeMutablePointer<AdwPreferencesGroup>) != 0 }
        set { adw_preferences_group_set_separate_rows(castedPointer() as UnsafeMutablePointer<AdwPreferencesGroup>, newValue ? 1 : 0) }
    }

    /// The `title` property.
    public var title: String {
        get { String(cString: adw_preferences_group_get_title(castedPointer() as UnsafeMutablePointer<AdwPreferencesGroup>)) }
        set { adw_preferences_group_set_title(castedPointer() as UnsafeMutablePointer<AdwPreferencesGroup>, newValue) }
    }

    /// Calls `adw_preferences_group_add`.
    public func add(_ child: Widget) {
        adw_preferences_group_add(castedPointer() as UnsafeMutablePointer<AdwPreferencesGroup>, child.widgetPointer)
    }

    /// Calls `adw_preferences_group_get_row`.
    @discardableResult
    public func getRow(_ index: UInt32) -> Widget? {
        return (adw_preferences_group_get_row(castedPointer() as UnsafeMutablePointer<AdwPreferencesGroup>, index)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) }
    }

    /// Calls `adw_preferences_group_remove`.
    public func remove(_ child: Widget) {
        adw_preferences_group_remove(castedPointer() as UnsafeMutablePointer<AdwPreferencesGroup>, child.widgetPointer)
    }
}
