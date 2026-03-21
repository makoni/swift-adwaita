import CAdwaita
import GObjectSupport

/// A simple menu model for use with `MenuButton` and `PopoverMenu`.
///
/// Wraps `GMenu`. Build menus by appending items, sections, and submenus,
/// then assign to a `MenuButton.menuModel`.
@MainActor
public final class GMenuRef: GObjectRef {
    /// Creates a new empty menu.
    public init() {
        let ptr = g_menu_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The underlying GMenuModel pointer for use with widgets.
    public var menuModelPointer: UnsafeMutablePointer<GMenuModel> {
        pointer.assumingMemoryBound(to: GMenuModel.self)
    }

    private var menuPointer: OpaquePointer { OpaquePointer(pointer) }

    /// Appends a labeled item that triggers the given action.
    public func append(_ label: String, action: String) {
        g_menu_append(menuPointer, label, action)
    }

    /// Appends a section with an optional label.
    public func appendSection(_ label: String?, section: GMenuRef) {
        g_menu_append_section(menuPointer, label, section.menuModelPointer)
    }

    /// Appends a submenu with a label.
    public func appendSubmenu(_ label: String, submenu: GMenuRef) {
        g_menu_append_submenu(menuPointer, label, submenu.menuModelPointer)
    }

    /// Appends a menu item.
    public func appendItem(_ item: GMenuItemRef) {
        g_menu_append_item(menuPointer, item.itemPointer)
    }

    /// Inserts a labeled item at the given position.
    public func insert(_ position: Int32, label: String, action: String?) {
        g_menu_insert(menuPointer, position, label, action)
    }

    /// Removes the item at the given position.
    public func remove(_ position: Int32) {
        g_menu_remove(menuPointer, position)
    }

    /// Removes all items from the menu.
    public func removeAll() {
        g_menu_remove_all(menuPointer)
    }

    /// Freezes the menu, making it immutable and safe for sharing.
    public func freeze() {
        g_menu_freeze(menuPointer)
    }
}

/// A menu item that can be added to a `GMenuRef`.
///
/// Wraps `GMenuItem`. Use this for items that need icons or custom attributes.
@MainActor
public final class GMenuItemRef: GObjectRef {
    /// Creates a new menu item.
    public init(label: String?, action: String?) {
        let ptr = g_menu_item_new(label, action)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    internal var itemPointer: OpaquePointer { OpaquePointer(pointer) }

    /// Sets the label of the menu item.
    public func setLabel(_ label: String) {
        g_menu_item_set_label(itemPointer, label)
    }

    /// Sets the icon from an icon name.
    public func setIconName(_ iconName: String) {
        guard let icon = g_themed_icon_new(iconName) else { return }
        g_menu_item_set_icon(itemPointer, icon)
        g_object_unref(UnsafeMutableRawPointer(icon))
    }

    /// Sets a custom string attribute.
    public func setAttribute(_ attribute: String, value: String) {
        g_menu_item_set_attribute_value(
            itemPointer,
            attribute,
            g_variant_new_string(value)
        )
    }
}

/// A simple GAction that triggers a callback when activated.
///
/// Wraps `GSimpleAction`. Add to an application or window action map.
@MainActor
public final class SimpleAction: GObjectRef {
    /// Creates a new stateless action.
    public init(name: String) {
        let ptr = g_simple_action_new(name, nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Whether the action is enabled.
    public var enabled: Bool {
        get { g_action_get_enabled(OpaquePointer(pointer)) != 0 }
        set { g_simple_action_set_enabled(OpaquePointer(pointer), newValue ? 1 : 0) }
    }

    /// Connects a handler to the `activate` signal.
    @discardableResult
    public func onActivate(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "activate", handler: handler)
    }
}

// MARK: - Integration with Application and Window

extension Application {
    /// Adds an action to the application's action map.
    public func addAction(_ action: SimpleAction) {
        g_action_map_add_action(OpaquePointer(pointer), OpaquePointer(action.pointer))
    }
}

extension ApplicationWindow {
    /// Adds an action to the window's action map.
    public func addAction(_ action: SimpleAction) {
        g_action_map_add_action(OpaquePointer(pointer), OpaquePointer(action.pointer))
    }
}
