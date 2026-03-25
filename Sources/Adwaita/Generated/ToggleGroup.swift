// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A group of mutually exclusive toggle buttons.
///
/// Wraps `AdwToggleGroup`. Displays a set of ``Toggle`` items where exactly
/// one is active at a time, similar to a segmented control. Useful for
/// switching between views or modes.
///
/// ```swift
/// let group = ToggleGroup()
/// group.homogeneous = true
///
/// let listToggle = Toggle()
/// listToggle.label = "List"
/// listToggle.name = "list"
///
/// let gridToggle = Toggle()
/// gridToggle.label = "Grid"
/// gridToggle.name = "grid"
///
/// group.add(listToggle)
/// group.add(gridToggle)
///
/// group.activeName = "list"
/// ```
///
/// - Key properties:
///   - ``active``: The index of the currently active toggle.
///   - ``activeName``: The name of the currently active toggle.
///   - ``homogeneous``: Whether all toggles are given equal width.
///   - ``canShrink``: Whether the group can shrink below its natural size.
///   - ``nToggles``: The number of toggles in the group (read-only).
/// - Key methods:
///   - ``add(_:)``: Adds a ``Toggle`` to the group.
///   - ``remove(_:)``: Removes a ``Toggle`` from the group.
///   - ``getToggle(_:)``: Returns the toggle at a given index.
///   - ``getToggleByName(_:)``: Returns the toggle with a given name.
///   - ``removeAll()``: Removes all toggles from the group.
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

    /// The zero-based index of the currently active toggle.
    /// - Since: libadwaita 1.7
    public var active: Int {
        get { Int(adw_toggle_group_get_active(opaquePointer)) }
        set { adw_toggle_group_set_active(opaquePointer, UInt32(newValue)) }
    }

    /// The name of the currently active toggle, or `nil` if no toggle is active.
    /// - Since: libadwaita 1.7
    public var activeName: String? {
        get { (adw_toggle_group_get_active_name(opaquePointer)).map { String(cString: $0) } }
        set { adw_toggle_group_set_active_name(opaquePointer, newValue) }
    }

    /// Whether the toggle group can be smaller than the natural size of its children.
    ///
    /// When enabled, toggle labels may be ellipsized to fit narrow containers.
    /// - Since: libadwaita 1.7
    public var canShrink: Bool {
        get { adw_toggle_group_get_can_shrink(opaquePointer) != 0 }
        set { adw_toggle_group_set_can_shrink(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether all toggles in the group are given equal width.
    /// - Since: libadwaita 1.7
    public var homogeneous: Bool {
        get { adw_toggle_group_get_homogeneous(opaquePointer) != 0 }
        set { adw_toggle_group_set_homogeneous(opaquePointer, newValue ? 1 : 0) }
    }

    /// The number of toggles currently in the group.
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

    /// Removes all toggles from the group.
    public func removeAll() {
        adw_toggle_group_remove_all(opaquePointer)
    }
}
