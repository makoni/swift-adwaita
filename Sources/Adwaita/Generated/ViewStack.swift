// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A view container for [class@ViewSwitcher].
@MainActor
public final class ViewStack: Widget {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ViewStack`.
    public init() {
        let ptr = adw_view_stack_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `enable-transitions` property.
    /// - Since: libadwaita 1.7
    public var enableTransitions: Bool {
        get { adw_view_stack_get_enable_transitions(opaquePointer) != 0 }
        set { adw_view_stack_set_enable_transitions(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `hhomogeneous` property.
    public var hhomogeneous: Bool {
        get { adw_view_stack_get_hhomogeneous(opaquePointer) != 0 }
        set { adw_view_stack_set_hhomogeneous(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `transition-duration` property.
    /// - Since: libadwaita 1.7
    public var transitionDuration: Int {
        get { Int(adw_view_stack_get_transition_duration(opaquePointer)) }
        set { adw_view_stack_set_transition_duration(opaquePointer, UInt32(newValue)) }
    }

    /// The `transition-running` property (read-only).
    /// - Since: libadwaita 1.7
    public var transitionRunning: Bool {
        adw_view_stack_get_transition_running(opaquePointer) != 0
    }

    /// The `vhomogeneous` property.
    public var vhomogeneous: Bool {
        get { adw_view_stack_get_vhomogeneous(opaquePointer) != 0 }
        set { adw_view_stack_set_vhomogeneous(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `visible-child` property.
    public var visibleChild: Widget? {
        get { (adw_view_stack_get_visible_child(opaquePointer)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_view_stack_set_visible_child(opaquePointer, newValue?.widgetPointer) }
    }

    /// The `visible-child-name` property.
    public var visibleChildName: String? {
        get { (adw_view_stack_get_visible_child_name(opaquePointer)).map { String(cString: $0) } }
        set { adw_view_stack_set_visible_child_name(opaquePointer, newValue) }
    }

    /// Adds a child widget, returning its page object.
    @discardableResult
    public func add(_ child: Widget) -> ViewStackPage {
        let ptr = adw_view_stack_add(opaquePointer, child.widgetPointer)!
        return ViewStackPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Adds a named child widget, returning its page object.
    @discardableResult
    public func addNamed(_ child: Widget, name: String?) -> ViewStackPage {
        let ptr = adw_view_stack_add_named(opaquePointer, child.widgetPointer, name)!
        return ViewStackPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Adds a titled child widget, returning its page object.
    @discardableResult
    public func addTitled(_ child: Widget, name: String?, title: String) -> ViewStackPage {
        let ptr = adw_view_stack_add_titled(opaquePointer, child.widgetPointer, name, title)!
        return ViewStackPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Adds a titled child widget with an icon, returning its page object.
    @discardableResult
    public func addTitledWithIcon(_ child: Widget, name: String?, title: String, iconName: String) -> ViewStackPage {
        let ptr = adw_view_stack_add_titled_with_icon(opaquePointer, child.widgetPointer, name, title, iconName)!
        return ViewStackPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Returns the child widget with the given name.
    @discardableResult
    public func getChildByName(_ name: String) -> Widget? {
        return (adw_view_stack_get_child_by_name(opaquePointer, name)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) }
    }

    /// Returns the page object for the given child.
    @discardableResult
    public func getPage(_ child: Widget) -> ViewStackPage {
        let ptr = adw_view_stack_get_page(opaquePointer, child.widgetPointer)!
        return ViewStackPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Calls `adw_view_stack_remove`.
    public func remove(_ child: Widget) {
        adw_view_stack_remove(opaquePointer, child.widgetPointer)
    }
}
