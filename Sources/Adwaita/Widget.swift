import CAdwaita
import GObjectSupport

/// Base class for all GTK and libadwaita widget wrappers.
///
/// Every visual element — buttons, labels, containers, dialogs — inherits from
/// `Widget`. It provides common properties and methods shared by all widgets:
/// visibility, sensitivity, CSS styling, layout alignment, margins, size
/// requests, event controllers, keyboard shortcuts, and signal handling.
///
/// You typically don't create `Widget` instances directly. Instead, use concrete
/// subclasses like ``Button``, ``Label``, ``Box``, or ``HeaderBar``.
///
/// ```swift
/// let button = Button(label: "OK")
/// button.halign = .center
/// button.addCSSClass(.suggestedAction)
/// button.setMargins(12)
///
/// button.onClicked {
///     print("Clicked!")
/// }
/// ```
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

    /// The widget's current minimum size request, as set by ``setSizeRequest(width:height:)``.
    ///
    /// Returns `-1` for an axis that has no explicit request.
    public var sizeRequest: (width: Int, height: Int) {
        var width: Int32 = 0
        var height: Int32 = 0
        gtk_widget_get_size_request(widgetPointer, &width, &height)
        return (Int(width), Int(height))
    }

    /// Flags this widget as needing a resize.
    ///
    /// Queues a size negotiation pass on the widget and its ancestors. Use
    /// this after changing properties (such as ``setSizeRequest(width:height:)``)
    /// that do not automatically invalidate the layout.
    public func queueResize() {
        gtk_widget_queue_resize(widgetPointer)
    }

    /// The result of measuring a widget along one orientation.
    ///
    /// See ``measure(orientation:forSize:)``.
    public struct Measurement: Sendable {
        /// The minimum size in pixels.
        public var minimum: Int
        /// The natural (preferred) size in pixels.
        public var natural: Int
        /// The minimum baseline, or `-1` if not supported.
        public var minimumBaseline: Int
        /// The natural baseline, or `-1` if not supported.
        public var naturalBaseline: Int
    }

    /// Measures the widget along the given orientation.
    ///
    /// Wraps `gtk_widget_measure`. Returns both the minimum and natural sizes
    /// the widget would request for the given size along the other axis.
    ///
    /// - Parameters:
    ///   - orientation: `GTK_ORIENTATION_HORIZONTAL` to measure width,
    ///     `GTK_ORIENTATION_VERTICAL` to measure height.
    ///   - forSize: The size available on the other axis, or `-1` if
    ///     unconstrained.
    public func measure(orientation: GtkOrientation, forSize: Int = -1) -> Measurement {
        var minimum: Int32 = 0
        var natural: Int32 = 0
        var minimumBaseline: Int32 = 0
        var naturalBaseline: Int32 = 0
        gtk_widget_measure(
            widgetPointer,
            orientation,
            Int32(forSize),
            &minimum,
            &natural,
            &minimumBaseline,
            &naturalBaseline
        )
        return Measurement(
            minimum: Int(minimum),
            natural: Int(natural),
            minimumBaseline: Int(minimumBaseline),
            naturalBaseline: Int(naturalBaseline)
        )
    }

    /// Returns the root widget of the widget tree this widget belongs to.
    public var root: Widget? {
        guard let ptr = gtk_widget_get_root(widgetPointer) else { return nil }
        return Widget(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// The containing ``GtkWindow``, if this widget is inside a window.
    ///
    /// This walks up the widget parent chain to find the nearest containing
    /// toplevel window. Use this
    /// instead of capturing a window reference in signal closures to avoid
    /// preventing deallocation during GTK dispose.
    ///
    /// ```swift
    /// let closeBtn = Button(label: "Close")
    /// closeBtn.onClicked {
    ///     closeBtn.window?.close()
    /// }
    /// ```
    public var window: GtkWindow? {
        var current: UnsafeMutablePointer<GtkWidget>? = widgetPointer

        while let widget = current {
            let instance = UnsafeMutableRawPointer(widget).assumingMemoryBound(to: GTypeInstance.self)
            if g_type_check_instance_is_a(instance, gtk_window_get_type()) != 0 {
                return GtkWindow(borrowing: UnsafeMutableRawPointer(widget))
            }
            current = gtk_widget_get_parent(widget)
        }

        return nil
    }

    /// Closes the containing window.
    ///
    /// Convenience for `self.window?.close()`. Safe to call from signal
    /// handlers without capturing the window reference.
    ///
    /// ```swift
    /// closeBtn.onClicked {
    ///     closeBtn.closeWindow()
    /// }
    /// ```
    public func closeWindow() {
        window?.close()
    }

    /// Keeps the underlying GObject alive until this widget is destroyed.
    ///
    /// Call this on windows or widgets that are created locally and would
    /// otherwise be deallocated when the variable goes out of scope. This
    /// installs a destroy handler that captures `self`, keeping the Swift
    /// wrapper alive until GTK disposes the widget and the signal system
    /// releases the handler on the next main-loop iteration.
    ///
    /// ```swift
    /// let secondary = ApplicationWindow(application: app)
    /// secondary.title = "Popup"
    /// secondary.present()
    /// secondary.retainUntilClose()
    /// ```
    public func retainUntilClose() {
        // Guard against double-calling — idempotent.
        let key = "swift-retained"
        guard g_object_get_data(gobjectPointer, key) == nil else { return }
        g_object_set_data(gobjectPointer, key, UnsafeMutableRawPointer(bitPattern: 1))

        // Capture `self` in a destroy handler so the Swift wrapper's own
        // reference keeps the GObject alive until GTK disposes the widget.
        // SignalHelper already defers closure release to idle, avoiding
        // re-entrant finalization during dispose.
        onDestroy { [self] in
            _ = self
        }
    }

    /// The parent widget.
    public var parent: Widget? {
        guard let ptr = gtk_widget_get_parent(widgetPointer) else { return nil }
        return Widget(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Removes this widget from its current parent, if any.
    public func unparent() {
        gtk_widget_unparent(widgetPointer)
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

    /// The GObject type associated with this widget class.
    ///
    /// Subclasses override this to return their specific `gtk_*_get_type()`
    /// value, enabling ``Widget/tryCast(_:)`` and
    /// ``Widget/isInstance(of:)-(GType)`` to perform a strict runtime type
    /// check. The default returns `gtk_widget_get_type()`.
    open class var gtkType: GType {
        gtk_widget_get_type()
    }

    /// Checks whether this widget is an instance of the given GObject type.
    public func isInstance(of gtkType: GType) -> Bool {
        g_type_check_instance_is_a(
            pointer.assumingMemoryBound(to: GTypeInstance.self),
            gtkType
        ) != 0
    }

    /// Checks whether this widget is an instance of the given widget subclass.
    public func isInstance<T: Widget>(of type: T.Type) -> Bool {
        isInstance(of: T.gtkType)
    }

    /// Attempts to re-wrap this widget's pointer as a specific subclass.
    ///
    /// Returns `nil` if the widget is not an instance of `T`. The check is
    /// performed against ``Widget/gtkType``, so the target class must override
    /// `gtkType` for the check to narrow beyond "is a `GtkWidget`".
    ///
    /// ```swift
    /// if let label = listItem.child?.tryCast(Label.self) {
    ///     label.text = "Hello"
    /// }
    /// ```
    public func tryCast<T: Widget>(_ type: T.Type) -> T? {
        guard isInstance(of: T.gtkType) else { return nil }
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

    // MARK: - Property Observation

    /// Observes changes to any GObject property by name.
    ///
    /// This is the generic way to react to property changes. Many widgets
    /// provide dedicated convenience methods (e.g. ``Switch/onActiveChanged(_:)``),
    /// but you can use this for any property.
    ///
    /// ```swift
    /// entry.onNotify(.text) {
    ///     print("Text changed to: \(entry.text)")
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - property: The property to observe.
    ///   - handler: Called when the property value changes.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onNotify(_ property: PropertyName, handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.onNotify(self, property: property, handler: handler)
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

    /// Emitted when the widget has been associated with a display.
    ///
    /// - Parameter handler: A closure invoked when the widget is realized.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onRealize(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .realize, handler: handler)
    }

    /// Emitted when the widget is being disassociated from its display.
    ///
    /// - Parameter handler: A closure invoked when the widget is unrealized.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onUnrealize(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .unrealize, handler: handler)
    }

    /// Emitted when the widget is about to be shown.
    ///
    /// - Parameter handler: A closure invoked when the widget is mapped.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onMap(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .map, handler: handler)
    }

    /// Emitted when the widget is about to be hidden.
    ///
    /// - Parameter handler: A closure invoked when the widget is unmapped.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onUnmap(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .unmap, handler: handler)
    }

    /// Emitted when the widget is being destroyed.
    ///
    /// - Parameter handler: A closure invoked when the widget is destroyed.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
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
            handler(width, height)
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
            { _, _, userData in
                guard let userData else { return 0 }
                let box = Unmanaged<PublicClosureBox<@MainActor () -> Bool>>
                    .fromOpaque(userData).takeUnretainedValue()
                return MainActor.assumeIsolated {
                    box.closure() ? 1 : 0
                }
            },
            box,
            { userData in
                scheduleDeferredBoxRelease(userData)
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
        gtk_accessible_get_accessible_role(OpaquePointer(pointer))
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
                scheduleDeferredBoxRelease(userData)
            }
        )
        let shortcut = gtk_shortcut_new(trigger, action)
        let controller = gtk_shortcut_controller_new()!
        let controllerOpaque = OpaquePointer(UnsafeMutableRawPointer(controller))
        gtk_shortcut_controller_add_shortcut(controllerOpaque, shortcut)
        gtk_widget_add_controller(widgetPointer, controller)
    }

}
