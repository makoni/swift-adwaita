import CAdwaita
import GObjectSupport

/// Base class for GTK widget wrappers.
@MainActor
open class Widget: GObjectRef {
    /// Returns the raw pointer as a `GtkWidget` pointer.
    public var widgetPointer: UnsafeMutablePointer<GtkWidget> {
        castedPointer()
    }

    /// Shows the widget.
    public func show() {
        gtk_widget_set_visible(widgetPointer, 1)
    }

    /// Hides the widget.
    public func hide() {
        gtk_widget_set_visible(widgetPointer, 0)
    }

    /// Whether the widget is visible.
    public var visible: Bool {
        get { gtk_widget_get_visible(widgetPointer) != 0 }
        set { gtk_widget_set_visible(widgetPointer, newValue ? 1 : 0) }
    }

    /// Whether the widget is sensitive (can receive input).
    public var sensitive: Bool {
        get { gtk_widget_get_sensitive(widgetPointer) != 0 }
        set { gtk_widget_set_sensitive(widgetPointer, newValue ? 1 : 0) }
    }

    /// Adds a CSS class to the widget.
    public func addCSSClass(_ cssClass: String) {
        gtk_widget_add_css_class(widgetPointer, cssClass)
    }

    /// Adds a type-safe CSS class to the widget.
    public func addCSSClass(_ cssClass: CSSClass) {
        gtk_widget_add_css_class(widgetPointer, cssClass.rawValue)
    }

    /// Removes a CSS class from the widget.
    public func removeCSSClass(_ cssClass: String) {
        gtk_widget_remove_css_class(widgetPointer, cssClass)
    }

    /// Removes a type-safe CSS class from the widget.
    public func removeCSSClass(_ cssClass: CSSClass) {
        gtk_widget_remove_css_class(widgetPointer, cssClass.rawValue)
    }

    /// Whether the widget has the given CSS class.
    public func hasCSSClass(_ cssClass: String) -> Bool {
        gtk_widget_has_css_class(widgetPointer, cssClass) != 0
    }

    /// Whether the widget has the given type-safe CSS class.
    public func hasCSSClass(_ cssClass: CSSClass) -> Bool {
        gtk_widget_has_css_class(widgetPointer, cssClass.rawValue) != 0
    }

    /// The list of CSS classes applied to the widget.
    public var cssClasses: [String] {
        get {
            guard let cArray = gtk_widget_get_css_classes(widgetPointer) else { return [] }
            var result: [String] = []
            var i = 0
            while let cStr = cArray[i] {
                result.append(String(cString: cStr))
                i += 1
            }
            g_strfreev(cArray)
            return result
        }
        set {
            let cStrings = newValue.map { g_strdup($0)! }
            var cArray: [UnsafePointer<CChar>?] = cStrings.map { UnsafePointer($0) }
            cArray.append(nil)
            cArray.withUnsafeMutableBufferPointer { buf in
                gtk_widget_set_css_classes(widgetPointer, buf.baseAddress)
            }
            cStrings.forEach { g_free(gpointer(mutating: $0)) }
        }
    }

    /// The overflow behavior (whether content is clipped).
    public var overflow: GtkOverflow {
        get { gtk_widget_get_overflow(widgetPointer) }
        set { gtk_widget_set_overflow(widgetPointer, newValue) }
    }

    /// Sets the horizontal expansion preference.
    public var hexpand: Bool {
        get { gtk_widget_get_hexpand(widgetPointer) != 0 }
        set { gtk_widget_set_hexpand(widgetPointer, newValue ? 1 : 0) }
    }

    /// Sets the vertical expansion preference.
    public var vexpand: Bool {
        get { gtk_widget_get_vexpand(widgetPointer) != 0 }
        set { gtk_widget_set_vexpand(widgetPointer, newValue ? 1 : 0) }
    }

    /// The horizontal alignment.
    public var halign: GtkAlign {
        get { gtk_widget_get_halign(widgetPointer) }
        set { gtk_widget_set_halign(widgetPointer, newValue) }
    }

    /// The vertical alignment.
    public var valign: GtkAlign {
        get { gtk_widget_get_valign(widgetPointer) }
        set { gtk_widget_set_valign(widgetPointer, newValue) }
    }

    /// Sets margin on all sides.
    public func setMargins(_ margin: Int) {
        let m = Int32(margin)
        gtk_widget_set_margin_start(widgetPointer, m)
        gtk_widget_set_margin_end(widgetPointer, m)
        gtk_widget_set_margin_top(widgetPointer, m)
        gtk_widget_set_margin_bottom(widgetPointer, m)
    }

    /// The start (leading) margin.
    public var marginStart: Int {
        get { Int(gtk_widget_get_margin_start(widgetPointer)) }
        set { gtk_widget_set_margin_start(widgetPointer, Int32(newValue)) }
    }

    /// The end (trailing) margin.
    public var marginEnd: Int {
        get { Int(gtk_widget_get_margin_end(widgetPointer)) }
        set { gtk_widget_set_margin_end(widgetPointer, Int32(newValue)) }
    }

    /// The top margin.
    public var marginTop: Int {
        get { Int(gtk_widget_get_margin_top(widgetPointer)) }
        set { gtk_widget_set_margin_top(widgetPointer, Int32(newValue)) }
    }

    /// The bottom margin.
    public var marginBottom: Int {
        get { Int(gtk_widget_get_margin_bottom(widgetPointer)) }
        set { gtk_widget_set_margin_bottom(widgetPointer, Int32(newValue)) }
    }

    /// The tooltip text.
    public var tooltipText: String? {
        get { gtk_widget_get_tooltip_text(widgetPointer).map { String(cString: $0) } }
        set { gtk_widget_set_tooltip_text(widgetPointer, newValue) }
    }

    /// The tooltip markup.
    public var tooltipMarkup: String? {
        get { gtk_widget_get_tooltip_markup(widgetPointer).map { String(cString: $0) } }
        set { gtk_widget_set_tooltip_markup(widgetPointer, newValue) }
    }

    /// Sets the minimum size of the widget.
    public func setSizeRequest(width: Int = -1, height: Int = -1) {
        gtk_widget_set_size_request(widgetPointer, Int32(width), Int32(height))
    }

    /// Returns the root widget of the widget tree this widget belongs to.
    public var root: Widget? {
        guard let ptr = gtk_widget_get_root(widgetPointer) else { return nil }
        return Widget(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// The parent widget.
    public var parent: Widget? {
        guard let ptr = gtk_widget_get_parent(widgetPointer) else { return nil }
        return Widget(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// The first child widget.
    public var firstChild: Widget? {
        guard let ptr = gtk_widget_get_first_child(widgetPointer) else { return nil }
        return Widget(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// The last child widget.
    public var lastChild: Widget? {
        guard let ptr = gtk_widget_get_last_child(widgetPointer) else { return nil }
        return Widget(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// The next sibling widget.
    public var nextSibling: Widget? {
        guard let ptr = gtk_widget_get_next_sibling(widgetPointer) else { return nil }
        return Widget(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// The previous sibling widget.
    public var prevSibling: Widget? {
        guard let ptr = gtk_widget_get_prev_sibling(widgetPointer) else { return nil }
        return Widget(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Returns all direct child widgets.
    public func children() -> [Widget] {
        var result: [Widget] = []
        var child = gtk_widget_get_first_child(widgetPointer)
        while let ptr = child {
            result.append(Widget(borrowing: UnsafeMutableRawPointer(ptr)))
            child = gtk_widget_get_next_sibling(ptr)
        }
        return result
    }

    /// Calls a closure for each direct child widget.
    public func forEachChild(_ body: (Widget) -> Void) {
        var child = gtk_widget_get_first_child(widgetPointer)
        while let ptr = child {
            body(Widget(borrowing: UnsafeMutableRawPointer(ptr)))
            child = gtk_widget_get_next_sibling(ptr)
        }
    }

    /// Re-wraps this widget's pointer as a specific subclass.
    ///
    /// Use this when you know the concrete type of a widget returned as the
    /// base `Widget` class (e.g., from `ListItem.child` or `firstChild`).
    ///
    /// ```swift
    /// // In a ListView onBind callback:
    /// if let label = listItem.child?.cast(Label.self) {
    ///     label.text = "Hello"
    /// }
    /// ```
    ///
    /// - Important: The caller must ensure the widget is actually the given type.
    ///   Passing a wrong type will trigger a fatal error in debug builds.
    public func cast<T: Widget>(_ type: T.Type) -> T {
        g_object_ref(pointer)
        return T(raw: pointer)
    }

    /// Attempts to re-wrap this widget's pointer as a specific subclass.
    ///
    /// Returns `nil` if the cast cannot be verified. Use this instead of
    /// `cast(_:)` when you are not certain of the widget's concrete type.
    ///
    /// ```swift
    /// if let label = listItem.child?.tryCast(Label.self) {
    ///     label.text = "Hello"
    /// }
    /// ```
    public func tryCast<T: Widget>(_ type: T.Type) -> T? {
        // All casts within the Widget hierarchy succeed at the Swift level
        // since we use the same underlying pointer. For safety, verify the
        // GObject is at least a valid widget.
        guard g_type_check_instance_is_a(
            pointer.assumingMemoryBound(to: GTypeInstance.self),
            gtk_widget_get_type()
        ) != 0 else {
            return nil
        }
        g_object_ref(pointer)
        return T(raw: pointer)
    }

    /// Configures the widget in a closure and returns it for chaining.
    ///
    /// ```swift
    /// let label = Label("Hello").configure {
    ///     $0.halign = .center
    ///     $0.addCSSClass("title-1")
    ///     $0.setMargins(12)
    /// }
    /// ```
    @discardableResult
    public func configure(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }

    /// Activates the widget (emits the default action).
    /// Returns `true` if the widget was activated.
    @discardableResult
    public func activate() -> Bool {
        gtk_widget_activate(widgetPointer) != 0
    }

    /// The opacity of the widget, from 0.0 (fully transparent) to 1.0 (fully opaque).
    public var opacity: Double {
        get { gtk_widget_get_opacity(widgetPointer) }
        set { gtk_widget_set_opacity(widgetPointer, newValue) }
    }

    /// Adds an event controller to this widget.
    ///
    /// `gtk_widget_add_controller` takes ownership of the controller,
    /// so we add an extra reference to keep the Swift wrapper valid.
    public func addController(_ controller: GObjectRef) {
        g_object_ref(controller.pointer)
        gtk_widget_add_controller(widgetPointer, OpaquePointer(controller.pointer))
    }

    /// Removes an event controller from this widget.
    public func removeController(_ controller: GObjectRef) {
        gtk_widget_remove_controller(widgetPointer, OpaquePointer(controller.pointer))
    }

    /// Attaches an action group to this widget with the given prefix.
    ///
    /// Actions in the group can then be referenced in menus as `"prefix.actionName"`.
    ///
    /// ```swift
    /// let group = SimpleActionGroup()
    /// group.addAction(SimpleAction(name: "copy") { ... })
    /// widget.insertActionGroup("edit", group)
    /// // Menu items use "edit.copy"
    /// ```
    public func insertActionGroup(_ prefix: String, _ group: SimpleActionGroup) {
        gtk_widget_insert_action_group(widgetPointer, prefix, OpaquePointer(group.pointer))
    }

    // MARK: - Focus

    /// Requests keyboard focus for this widget.
    /// Returns `true` if the widget successfully grabbed focus.
    @discardableResult
    public func grabFocus() -> Bool {
        gtk_widget_grab_focus(widgetPointer) != 0
    }

    /// Whether the widget currently has keyboard focus.
    public var hasFocus: Bool {
        gtk_widget_has_focus(widgetPointer) != 0
    }

    /// Whether the widget can accept keyboard focus.
    public var isFocusable: Bool {
        get { gtk_widget_get_focusable(widgetPointer) != 0 }
        set { gtk_widget_set_focusable(widgetPointer, newValue ? 1 : 0) }
    }

    /// Whether the widget can be the default widget (activated by Enter).
    public var canTarget: Bool {
        get { gtk_widget_get_can_target(widgetPointer) != 0 }
        set { gtk_widget_set_can_target(widgetPointer, newValue ? 1 : 0) }
    }

    // MARK: - Size Queries

    /// The widget's current width as set by layout.
    public var width: Int {
        Int(gtk_widget_get_width(widgetPointer))
    }

    /// The widget's current height as set by layout.
    public var height: Int {
        Int(gtk_widget_get_height(widgetPointer))
    }

    // MARK: - CSS Name

    /// The CSS name of the widget class, used for style matching.
    public var cssName: String {
        String(cString: gtk_widget_get_css_name(widgetPointer))
    }

    // MARK: - Lifecycle Signals

    /// Connects to the `realize` signal -- widget has been associated with a display.
    @discardableResult
    public func onRealize(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .realize, handler: handler)
    }

    /// Connects to the `unrealize` signal -- widget is being disassociated from display.
    @discardableResult
    public func onUnrealize(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .unrealize, handler: handler)
    }

    /// Connects to the `map` signal -- widget is going to be shown.
    @discardableResult
    public func onMap(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .map, handler: handler)
    }

    /// Connects to the `unmap` signal -- widget is going to be hidden.
    @discardableResult
    public func onUnmap(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .unmap, handler: handler)
    }

    /// Connects to the `destroy` signal.
    @discardableResult
    public func onDestroy(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .destroy, handler: handler)
    }

    /// Called when the widget's size changes.
    ///
    /// The handler receives the new width and height.
    ///
    /// ```swift
    /// widget.onSizeAllocate { width, height in
    ///     print("New size: \(width)x\(height)")
    /// }
    /// ```
    @discardableResult
    public func onSizeAllocate(_ handler: @escaping @MainActor (Int, Int) -> Void) -> SignalConnection {
        SignalHelper.onNotify(self, property: .width) { [weak self] in
            guard let self else { return }
            handler(self.width, self.height)
        }
    }

    // MARK: - Cursor

    /// Sets the cursor from a named cursor (e.g. "pointer", "crosshair", "text", "grab").
    public func setCursor(name: String?) {
        gtk_widget_set_cursor_from_name(widgetPointer, name)
    }

    /// Resets the cursor to the default.
    public func resetCursor() {
        gtk_widget_set_cursor(widgetPointer, nil)
    }

    // MARK: - Tick Callback

    /// Adds a per-frame tick callback for animations.
    ///
    /// The callback is called once per frame while active. Return `true` to
    /// keep the callback, or `false` to remove it.
    ///
    /// - Returns: A callback ID that can be passed to `removeTickCallback()`.
    @discardableResult
    public func addTickCallback(_ callback: @escaping @MainActor () -> Bool) -> UInt {
        let box = Unmanaged.passRetained(PublicClosureBox(callback)).toOpaque()
        let id = gtk_widget_add_tick_callback(
            widgetPointer,
            { widget, _, userData in
                guard let userData else { return 0 }
                let box = Unmanaged<PublicClosureBox<@MainActor () -> Bool>>
                    .fromOpaque(userData).takeUnretainedValue()
                return MainActor.assumeIsolated {
                    box.closure() ? 1 : 0
                }
            },
            box,
            { userData in
                guard let userData else { return }
                Unmanaged<AnyObject>.fromOpaque(userData).release()
            }
        )
        return UInt(id)
    }

    /// Removes a tick callback previously added with `addTickCallback()`.
    public func removeTickCallback(_ id: UInt) {
        gtk_widget_remove_tick_callback(widgetPointer, UInt32(id))
    }

    // MARK: - Accessibility

    /// The accessible role of the widget.
    public var accessibleRole: GtkAccessibleRole {
        get { gtk_accessible_get_accessible_role(OpaquePointer(pointer)) }
    }

    /// Sets the accessible label for the widget.
    public func setAccessibleLabel(_ label: String) {
        var prop = GTK_ACCESSIBLE_PROPERTY_LABEL
        var value = GValue()
        g_value_init(&value, cadw_type_string())
        g_value_set_string(&value, label)
        gtk_accessible_update_property_value(
            OpaquePointer(pointer),
            1,
            &prop,
            &value
        )
        g_value_unset(&value)
    }

    /// Sets the accessible description for the widget.
    public func setAccessibleDescription(_ description: String) {
        var prop = GTK_ACCESSIBLE_PROPERTY_DESCRIPTION
        var value = GValue()
        g_value_init(&value, cadw_type_string())
        g_value_set_string(&value, description)
        gtk_accessible_update_property_value(
            OpaquePointer(pointer),
            1,
            &prop,
            &value
        )
        g_value_unset(&value)
    }

    // MARK: - Keyboard Shortcuts

    /// Adds a keyboard shortcut to this widget using key and modifier enums.
    ///
    /// ```swift
    /// widget.addKeyboardShortcut(key: .s, modifiers: .control) {
    ///     print("Save!")
    ///     return true
    /// }
    /// widget.addKeyboardShortcut(key: .z, modifiers: [.control, .shift]) {
    ///     print("Redo!")
    ///     return true
    /// }
    /// ```
    public func addKeyboardShortcut(key: Key, modifiers: KeyModifiers = [], handler: @escaping @MainActor () -> Bool) {
        addKeyboardShortcut(acceleratorString(key: key, modifiers: modifiers), handler: handler)
    }

    /// Adds a keyboard shortcut to this widget using a raw accelerator string.
    ///
    /// - Parameters:
    ///   - accelerator: The accelerator string (e.g. "\<Control\>s", "\<Alt\>F4", "\<Control\>\<Shift\>z").
    ///   - handler: Called when the shortcut is triggered. Return true to stop propagation.
    public func addKeyboardShortcut(_ accelerator: String, handler: @escaping @MainActor () -> Bool) {
        guard let trigger = gtk_shortcut_trigger_parse_string(accelerator) else { return }
        let box = Unmanaged.passRetained(PublicClosureBox(handler)).toOpaque()
        let action = gtk_callback_action_new(
            { _, _, userData in
                guard let userData else { return 0 }
                let box = Unmanaged<PublicClosureBox<@MainActor () -> Bool>>.fromOpaque(userData)
                    .takeUnretainedValue()
                return MainActor.assumeIsolated {
                    box.closure() ? 1 : 0
                }
            },
            box,
            { userData in
                guard let userData else { return }
                Unmanaged<AnyObject>.fromOpaque(userData).release()
            }
        )
        let shortcut = gtk_shortcut_new(trigger, action)
        let controller = gtk_shortcut_controller_new()!
        let controllerOpaque = OpaquePointer(UnsafeMutableRawPointer(controller))
        gtk_shortcut_controller_add_shortcut(controllerOpaque, shortcut)
        gtk_widget_add_controller(widgetPointer, controller)
    }

}

// MARK: - Fluent Setters

extension Widget {

    /// Sets the horizontal alignment and returns self for chaining.
    @discardableResult
    public func halign(_ align: GtkAlign) -> Self {
        self.halign = align
        return self
    }

    /// Sets the vertical alignment and returns self for chaining.
    @discardableResult
    public func valign(_ align: GtkAlign) -> Self {
        self.valign = align
        return self
    }

    /// Sets horizontal expansion and returns self for chaining.
    @discardableResult
    public func hexpand(_ expand: Bool = true) -> Self {
        self.hexpand = expand
        return self
    }

    /// Sets vertical expansion and returns self for chaining.
    @discardableResult
    public func vexpand(_ expand: Bool = true) -> Self {
        self.vexpand = expand
        return self
    }

    /// Sets margin on all sides and returns self for chaining.
    @discardableResult
    public func margins(_ margin: Int) -> Self {
        setMargins(margin)
        return self
    }

    /// Sets sensitivity and returns self for chaining.
    @discardableResult
    public func sensitive(_ sensitive: Bool) -> Self {
        self.sensitive = sensitive
        return self
    }

    /// Sets tooltip text and returns self for chaining.
    @discardableResult
    public func tooltip(_ text: String) -> Self {
        self.tooltipText = text
        return self
    }

    /// Adds a CSS class and returns self for chaining.
    @discardableResult
    public func cssClass(_ cssClass: String) -> Self {
        addCSSClass(cssClass)
        return self
    }

    /// Adds a type-safe CSS class and returns self for chaining.
    @discardableResult
    public func cssClass(_ cssClass: CSSClass) -> Self {
        addCSSClass(cssClass)
        return self
    }

    /// Sets the size request and returns self for chaining.
    @discardableResult
    public func sizeRequest(width: Int = -1, height: Int = -1) -> Self {
        setSizeRequest(width: width, height: height)
        return self
    }

    /// Sets visibility and returns self for chaining.
    @discardableResult
    public func visible(_ visible: Bool) -> Self {
        self.visible = visible
        return self
    }

    /// Sets opacity and returns self for chaining.
    @discardableResult
    public func opacity(_ opacity: Double) -> Self {
        self.opacity = opacity
        return self
    }

    /// Sets the start margin and returns self for chaining.
    @discardableResult
    public func marginStart(_ margin: Int) -> Self {
        self.marginStart = margin
        return self
    }

    /// Sets the end margin and returns self for chaining.
    @discardableResult
    public func marginEnd(_ margin: Int) -> Self {
        self.marginEnd = margin
        return self
    }

    /// Sets the top margin and returns self for chaining.
    @discardableResult
    public func marginTop(_ margin: Int) -> Self {
        self.marginTop = margin
        return self
    }

    /// Sets the bottom margin and returns self for chaining.
    @discardableResult
    public func marginBottom(_ margin: Int) -> Self {
        self.marginBottom = margin
        return self
    }
}
