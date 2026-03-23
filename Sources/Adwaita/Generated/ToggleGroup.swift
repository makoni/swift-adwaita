// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A group of exclusive toggles.
/// - Since: libadwaita 1.7
@MainActor
public final class ToggleGroup: Widget {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ToggleGroup`.
    public init() {
        let ptr = adw_toggle_group_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `active` property.
    /// - Since: libadwaita 1.7
    public var active: Int {
        get { Int(adw_toggle_group_get_active(opaquePointer)) }
        set { adw_toggle_group_set_active(opaquePointer, UInt32(newValue)) }
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
    public var nToggles: Int {
        Int(adw_toggle_group_get_n_toggles(opaquePointer))
    }

    /// Adds a toggle (transfer-full: adds a ref before passing).
    public func add(_ toggle: Toggle) {
        g_object_ref(toggle.pointer)
        adw_toggle_group_add(opaquePointer, toggle.opaquePointer)
    }

    /// Returns the toggle at the given index.
    @discardableResult
    public func getToggle(_ index: Int) -> Toggle? {
        return (adw_toggle_group_get_toggle(opaquePointer, UInt32(index))).map { Toggle(borrowing: UnsafeMutableRawPointer($0)) }
    }

    /// Returns the toggle with the given name.
    @discardableResult
    public func getToggleByName(_ name: String) -> Toggle? {
        return (adw_toggle_group_get_toggle_by_name(opaquePointer, name)).map { Toggle(borrowing: UnsafeMutableRawPointer($0)) }
    }

    /// Removes a toggle from the group.
    public func remove(_ toggle: Toggle) {
        adw_toggle_group_remove(opaquePointer, toggle.opaquePointer)
    }

    /// Calls `adw_toggle_group_remove_all`.
    public func removeAll() {
        adw_toggle_group_remove_all(opaquePointer)
    }
}
