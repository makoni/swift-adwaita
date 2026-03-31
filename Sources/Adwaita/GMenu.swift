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

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The underlying GMenuModel pointer for use with widgets.
    public var menuModelPointer: UnsafeMutablePointer<GMenuModel> {
        pointer.assumingMemoryBound(to: GMenuModel.self)
    }

    private var menuPointer: OpaquePointer {
        OpaquePointer(pointer)
    }

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
    public func insert(_ position: Int, label: String, action: String?) {
        g_menu_insert(menuPointer, Int32(position), label, action)
    }

    /// Removes the item at the given position.
    public func remove(_ position: Int) {
        g_menu_remove(menuPointer, Int32(position))
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

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    var itemPointer: OpaquePointer {
        OpaquePointer(pointer)
    }

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

    /// Sets a custom attribute using a `Variant` value.
    public func setAttribute(_ attribute: String, variant: Variant) {
        g_menu_item_set_attribute_value(
            itemPointer,
            attribute,
            variant.pointer
        )
    }

    /// Sets the target value for this menu item.
    ///
    /// The target value is passed as the parameter when the action is activated.
    /// This is commonly used with parameterized actions to distinguish which
    /// menu item triggered the activation.
    public func setTargetValue(_ target: Variant) {
        g_menu_item_set_attribute_value(
            itemPointer,
            "target",
            target.pointer
        )
    }
}

/// A simple GAction that triggers a callback when activated.
///
/// Wraps `GSimpleAction`. Add to an application or window action map.
///
/// Three forms are supported:
/// - **Stateless, no parameter:** `SimpleAction(name: "quit") { ... }`
/// - **With parameter type:** `SimpleAction(name: "open", parameterType: "s") { variant in ... }`
/// - **Stateful (toggle):** `SimpleAction(name: "bold", state: .boolean(false)) { ... }`
@MainActor
public final class SimpleAction: GObjectRef {
    /// Creates a new stateless action with no parameter.
    public init(name: String) {
        let ptr = g_simple_action_new(name, nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates an action with a name and activation handler (no parameter).
    public convenience init(name: String, handler: @escaping @MainActor () -> Void) {
        self.init(name: name)
        onActivate(handler)
    }

    /// Creates an action that receives a typed parameter on activation.
    ///
    /// The `parameterType` is a GVariant type string:
    /// - `"s"` for string
    /// - `"i"` for int32
    /// - `"d"` for double
    /// - `"b"` for boolean
    ///
    /// ```swift
    /// let action = SimpleAction(name: "open-uri", parameterType: "s") { variant in
    ///     if let uri = variant.stringValue {
    ///         print("Opening \(uri)")
    ///     }
    /// }
    /// ```
    public init(name: String, parameterType: String, handler: @escaping @MainActor (Variant) -> Void) {
        let variantType = g_variant_type_new(parameterType)
        let ptr = g_simple_action_new(name, variantType)!
        if let variantType { g_variant_type_free(variantType) }
        super.init(raw: UnsafeMutableRawPointer(ptr))
        onActivateWithParameter(handler)
    }

    /// Creates a stateful action with an initial state.
    ///
    /// Stateful actions are used for toggles and radio buttons. The state
    /// is a `Variant` value that persists across activations.
    ///
    /// ```swift
    /// let boldAction = SimpleAction(name: "bold", state: .boolean(false)) {
    ///     // Toggle the state
    ///     let current = boldAction.state?.boolValue ?? false
    ///     boldAction.state = .boolean(!current)
    /// }
    /// ```
    public init(name: String, state: Variant, handler: @escaping @MainActor () -> Void) {
        let ptr = g_simple_action_new_stateful(name, nil, state.pointer)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        onActivate(handler)
    }

    /// Creates a stateful action with a parameter type and initial state.
    public init(
        name: String,
        parameterType: String,
        state: Variant,
        handler: @escaping @MainActor (Variant) -> Void
    ) {
        let variantType = g_variant_type_new(parameterType)
        let ptr = g_simple_action_new_stateful(name, variantType, state.pointer)!
        if let variantType { g_variant_type_free(variantType) }
        super.init(raw: UnsafeMutableRawPointer(ptr))
        onActivateWithParameter(handler)
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Whether the action is enabled.
    public var enabled: Bool {
        get { g_action_get_enabled(OpaquePointer(pointer)) != 0 }
        set { g_simple_action_set_enabled(OpaquePointer(pointer), newValue ? 1 : 0) }
    }

    /// The current state of the action, or `nil` if the action is stateless.
    public var state: Variant? {
        get {
            guard let ptr = g_action_get_state(OpaquePointer(pointer)) else { return nil }
            // g_action_get_state transfers ownership (returns a new ref)
            let variant = Variant(borrowing: ptr)
            g_variant_unref(ptr)
            return variant
        }
        set {
            g_simple_action_set_state(OpaquePointer(pointer), newValue?.pointer)
        }
    }

    /// Connects a handler to the `activate` signal (no parameter).
    ///
    /// The GSimpleAction `activate` signal always passes a `GVariant*` parameter
    /// (nil for stateless actions), so we use a 3-arg trampoline that ignores it.
    @discardableResult
    public func onActivate(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connectPointer(self, signal: .activate) { _ in
            handler()
        }
    }

    /// Connects a handler to the `activate` signal that receives the parameter.
    ///
    /// The `activate` signal for parameterized actions has the C signature:
    /// `void (*)(GSimpleAction*, GVariant*, gpointer)`.
    @discardableResult
    public func onActivateWithParameter(
        _ handler: @escaping @MainActor (Variant) -> Void
    ) -> SignalConnection {
        let trampoline: @convention(c) (
            UnsafeMutableRawPointer, OpaquePointer?, UnsafeMutableRawPointer
        ) -> Void = { _, variantPtr, userData in
            let box = Unmanaged<PublicClosureBox<@MainActor (Variant) -> Void>>
                .fromOpaque(userData).takeUnretainedValue()
            guard let variantPtr else { return }
            MainActor.assumeIsolated {
                let variant = Variant(borrowing: variantPtr)
                box.closure(variant)
            }
        }
        return SignalHelper.connectCustom(
            self,
            signal: .activate,
            trampoline: unsafeBitCast(trampoline, to: GCallback.self),
            box: PublicClosureBox(handler)
        )
    }
}

/// A group of actions that can be attached to a widget.
///
/// Wraps `GSimpleActionGroup`. Attach to a widget with
/// `widget.insertActionGroup("prefix", group)`, then reference actions
/// in menus as `"prefix.actionName"`.
///
/// ```swift
/// let group = SimpleActionGroup()
/// group.addAction(SimpleAction(name: "copy") { print("Copy!") })
/// widget.insertActionGroup("edit", group)
/// ```
@MainActor
public final class SimpleActionGroup: GObjectRef {
    /// Creates a new empty action group.
    public init() {
        let ptr = g_simple_action_group_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Adds an action to this group.
    public func addAction(_ action: SimpleAction) {
        g_action_map_add_action(OpaquePointer(pointer), OpaquePointer(action.pointer))
    }
}

// MARK: - Integration with Application and Window

public extension Application {
    /// Adds an action to the application's action map.
    func addAction(_ action: SimpleAction) {
        g_action_map_add_action(OpaquePointer(pointer), OpaquePointer(action.pointer))
    }
}

public extension ApplicationWindow {
    /// Adds an action to the window's action map.
    func addAction(_ action: SimpleAction) {
        g_action_map_add_action(OpaquePointer(pointer), OpaquePointer(action.pointer))
    }
}
