// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A group of exclusive toggles.
/// - Since: libadwaita 1.7
@MainActor
public final class ToggleGroup: Widget {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ToggleGroup`.
    public init() {
        let ptr = adw_toggle_group_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `active` property.
    /// - Since: libadwaita 1.7
    public var active: UInt32 {
        get { adw_toggle_group_get_active(opaquePointer) }
        set { adw_toggle_group_set_active(opaquePointer, newValue) }
    }

    /// The `active-name` property.
    /// - Since: libadwaita 1.7
    public var activeName: String? {
        get { (adw_toggle_group_get_active_name(opaquePointer)).map { String(cString: $0) } }
        set { adw_toggle_group_set_active_name(opaquePointer, newValue) }
    }

    /// The `can-shrink` property.
    /// - Since: libadwaita 1.7
    public var canShrink: Bool {
        get { adw_toggle_group_get_can_shrink(opaquePointer) != 0 }
        set { adw_toggle_group_set_can_shrink(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `homogeneous` property.
    /// - Since: libadwaita 1.7
    public var homogeneous: Bool {
        get { adw_toggle_group_get_homogeneous(opaquePointer) != 0 }
        set { adw_toggle_group_set_homogeneous(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `n-toggles` property (read-only).
    /// - Since: libadwaita 1.7
    public var nToggles: UInt32 {
        adw_toggle_group_get_n_toggles(opaquePointer)
    }

    /// Calls `adw_toggle_group_add`.
    public func add(_ toggle: OpaquePointer) {
        adw_toggle_group_add(opaquePointer, toggle)
    }

    /// Calls `adw_toggle_group_get_toggle`.
    @discardableResult
    public func getToggle(_ index: UInt32) -> OpaquePointer? {
        return adw_toggle_group_get_toggle(opaquePointer, index)
    }

    /// Calls `adw_toggle_group_get_toggle_by_name`.
    @discardableResult
    public func getToggleByName(_ name: String) -> OpaquePointer? {
        return adw_toggle_group_get_toggle_by_name(opaquePointer, name)
    }

    /// Calls `adw_toggle_group_remove`.
    public func remove(_ toggle: OpaquePointer) {
        adw_toggle_group_remove(opaquePointer, toggle)
    }

    /// Calls `adw_toggle_group_remove_all`.
    public func removeAll() {
        adw_toggle_group_remove_all(opaquePointer)
    }
}
