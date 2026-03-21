// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A view container for [class@ViewSwitcher].
@MainActor
public final class ViewStack: Widget {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
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
    public var transitionDuration: UInt32 {
        get { adw_view_stack_get_transition_duration(opaquePointer) }
        set { adw_view_stack_set_transition_duration(opaquePointer, newValue) }
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

    /// Calls `adw_view_stack_add`.
    @discardableResult
    public func add(_ child: Widget) -> OpaquePointer {
        return adw_view_stack_add(opaquePointer, child.widgetPointer)
    }

    /// Calls `adw_view_stack_add_named`.
    @discardableResult
    public func addNamed(_ child: Widget, name: String?) -> OpaquePointer {
        return adw_view_stack_add_named(opaquePointer, child.widgetPointer, name)
    }

    /// Calls `adw_view_stack_add_titled`.
    @discardableResult
    public func addTitled(_ child: Widget, name: String?, title: String) -> OpaquePointer {
        return adw_view_stack_add_titled(opaquePointer, child.widgetPointer, name, title)
    }

    /// Calls `adw_view_stack_add_titled_with_icon`.
    @discardableResult
    public func addTitledWithIcon(_ child: Widget, name: String?, title: String, iconName: String) -> OpaquePointer {
        return adw_view_stack_add_titled_with_icon(opaquePointer, child.widgetPointer, name, title, iconName)
    }

    /// Calls `adw_view_stack_get_child_by_name`.
    @discardableResult
    public func getChildByName(_ name: String) -> Widget? {
        return (adw_view_stack_get_child_by_name(opaquePointer, name)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) }
    }

    /// Calls `adw_view_stack_get_page`.
    @discardableResult
    public func getPage(_ child: Widget) -> OpaquePointer {
        return adw_view_stack_get_page(opaquePointer, child.widgetPointer)
    }

    /// Calls `adw_view_stack_remove`.
    public func remove(_ child: Widget) {
        adw_view_stack_remove(opaquePointer, child.widgetPointer)
    }
}
