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

    /// Removes a CSS class from the widget.
    public func removeCSSClass(_ cssClass: String) {
        gtk_widget_remove_css_class(widgetPointer, cssClass)
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
        SignalHelper.connect(self, signal: "realize", handler: handler)
    }

    /// Connects to the `unrealize` signal -- widget is being disassociated from display.
    @discardableResult
    public func onUnrealize(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "unrealize", handler: handler)
    }

    /// Connects to the `map` signal -- widget is going to be shown.
    @discardableResult
    public func onMap(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "map", handler: handler)
    }

    /// Connects to the `unmap` signal -- widget is going to be hidden.
    @discardableResult
    public func onUnmap(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "unmap", handler: handler)
    }

    /// Connects to the `destroy` signal.
    @discardableResult
    public func onDestroy(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "destroy", handler: handler)
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

    /// Adds a keyboard shortcut to this widget.
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
