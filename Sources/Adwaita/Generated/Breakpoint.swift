// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// Describes a breakpoint for [class@Window] or [class@Dialog].
/// - Since: libadwaita 1.4
@MainActor
public final class Breakpoint: GObjectRef {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `Breakpoint`.
    ///
    /// The C function takes ownership of the condition (transfer-full),
    /// so we pass a copy to keep the Swift wrapper valid.
    public init(condition: BreakpointCondition) {
        let conditionCopy = adw_breakpoint_condition_copy(condition.pointer)!
        let ptr = adw_breakpoint_new(conditionCopy)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `condition` property.
    /// - Since: libadwaita 1.4
    public var condition: BreakpointCondition? {
        // getter is transfer-none: we must copy
        get { adw_breakpoint_get_condition(opaquePointer).map { BreakpointCondition(borrowing: $0) } }
        // setter is transfer-none: C side copies internally
        set { adw_breakpoint_set_condition(opaquePointer, newValue?.pointer) }
    }

    /// Adds a setter that changes a boolean property when the breakpoint is applied.
    public func addSetter(_ object: GObjectRef, property: String, value: Bool) {
        var gval = GValue()
        g_value_init(&gval, cadw_type_boolean())
        g_value_set_boolean(&gval, value ? 1 : 0)
        adw_breakpoint_add_setter(opaquePointer, object.pointer.assumingMemoryBound(to: GObject.self), property, &gval)
        g_value_unset(&gval)
    }

    /// Adds a setter that changes an integer property when the breakpoint is applied.
    public func addSetter(_ object: GObjectRef, property: String, value: Int) {
        var gval = GValue()
        g_value_init(&gval, cadw_type_int())
        g_value_set_int(&gval, Int32(value))
        adw_breakpoint_add_setter(opaquePointer, object.pointer.assumingMemoryBound(to: GObject.self), property, &gval)
        g_value_unset(&gval)
    }

    /// Adds a setter that changes a string property when the breakpoint is applied.
    public func addSetter(_ object: GObjectRef, property: String, value: String) {
        var gval = GValue()
        g_value_init(&gval, cadw_type_string())
        g_value_set_string(&gval, value)
        adw_breakpoint_add_setter(opaquePointer, object.pointer.assumingMemoryBound(to: GObject.self), property, &gval)
        g_value_unset(&gval)
    }

    /// Adds a setter that changes a double property when the breakpoint is applied.
    public func addSetter(_ object: GObjectRef, property: String, value: Double) {
        var gval = GValue()
        g_value_init(&gval, cadw_type_double())
        g_value_set_double(&gval, value)
        adw_breakpoint_add_setter(opaquePointer, object.pointer.assumingMemoryBound(to: GObject.self), property, &gval)
        g_value_unset(&gval)
    }

    /// Connects to the `apply` signal.
    @discardableResult
    public func onApply(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "apply", handler: handler)
    }

    /// Connects to the `unapply` signal.
    @discardableResult
    public func onUnapply(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "unapply", handler: handler)
    }
}
