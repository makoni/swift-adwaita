import CAdwaita
import GObjectSupport

/// A container that shows one of its children at a time.
///
/// Wraps `GtkStack`. For Adwaita view switchers, use `ViewStack` instead.
@MainActor
public final class Stack: Widget {
    /// Creates a new stack.
    public init() {
        let ptr = gtk_stack_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Adds a child.
    public func addChild(_ child: Widget) {
        gtk_stack_add_child(opaquePointer, child.widgetPointer)
    }

    /// Adds a named child.
    public func addNamed(_ child: Widget, name: String) {
        gtk_stack_add_named(opaquePointer, child.widgetPointer, name)
    }

    /// Adds a titled child.
    public func addTitled(_ child: Widget, name: String?, title: String) {
        gtk_stack_add_titled(opaquePointer, child.widgetPointer, name, title)
    }

    /// Removes a child.
    public func remove(_ child: Widget) {
        gtk_stack_remove(opaquePointer, child.widgetPointer)
    }

    /// The visible child widget.
    public var visibleChild: Widget? {
        get {
            guard let ptr = gtk_stack_get_visible_child(opaquePointer) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set { gtk_stack_set_visible_child(opaquePointer, newValue?.widgetPointer) }
    }

    /// The name of the visible child.
    public var visibleChildName: String? {
        get {
            guard let cStr = gtk_stack_get_visible_child_name(opaquePointer) else { return nil }
            return String(cString: cStr)
        }
        set { gtk_stack_set_visible_child_name(opaquePointer, newValue) }
    }

    /// The transition type.
    public var transitionType: GtkStackTransitionType {
        get { gtk_stack_get_transition_type(opaquePointer) }
        set { gtk_stack_set_transition_type(opaquePointer, newValue) }
    }

    /// The transition duration in milliseconds.
    public var transitionDuration: Int {
        get { Int(gtk_stack_get_transition_duration(opaquePointer)) }
        set { gtk_stack_set_transition_duration(opaquePointer, UInt32(newValue)) }
    }
}
