// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A toggle within [class@ToggleGroup].
/// - Since: libadwaita 1.7
@MainActor
public final class Toggle: GObjectRef {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `Toggle`.
    public init() {
        let ptr = adw_toggle_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `child` property.
    /// - Since: libadwaita 1.7
    public var child: Widget? {
        get { (adw_toggle_get_child(opaquePointer)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_toggle_set_child(opaquePointer, newValue?.widgetPointer) }
    }

    /// The `enabled` property.
    /// - Since: libadwaita 1.7
    public var enabled: Bool {
        get { adw_toggle_get_enabled(opaquePointer) != 0 }
        set { adw_toggle_set_enabled(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `icon-name` property.
    /// - Since: libadwaita 1.7
    public var iconName: String? {
        get { (adw_toggle_get_icon_name(opaquePointer)).map { String(cString: $0) } }
        set { adw_toggle_set_icon_name(opaquePointer, newValue) }
    }

    /// The `label` property.
    /// - Since: libadwaita 1.7
    public var label: String? {
        get { (adw_toggle_get_label(opaquePointer)).map { String(cString: $0) } }
        set { adw_toggle_set_label(opaquePointer, newValue) }
    }

    /// The `name` property.
    /// - Since: libadwaita 1.7
    public var name: String {
        get { String(cString: adw_toggle_get_name(opaquePointer)) }
        set { adw_toggle_set_name(opaquePointer, newValue) }
    }

    /// The `tooltip` property.
    /// - Since: libadwaita 1.7
    public var tooltip: String {
        get { String(cString: adw_toggle_get_tooltip(opaquePointer)) }
        set { adw_toggle_set_tooltip(opaquePointer, newValue) }
    }

    /// The `use-underline` property.
    /// - Since: libadwaita 1.7
    public var useUnderline: Bool {
        get { adw_toggle_get_use_underline(opaquePointer) != 0 }
        set { adw_toggle_set_use_underline(opaquePointer, newValue ? 1 : 0) }
    }

    /// Calls `adw_toggle_get_index`.
    @discardableResult
    public func getIndex() -> UInt32 {
        return adw_toggle_get_index(opaquePointer)
    }
}
