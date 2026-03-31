// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// Describes a breakpoint for [class@Window] or [class@Dialog].
/// - Since: libadwaita 1.4
@MainActor
public final class Breakpoint: GObjectRef {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
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

    /// The size or layout condition that determines when this breakpoint is applied.
    /// - Since: libadwaita 1.4
    public var condition: BreakpointCondition? {
        // getter is transfer-none: we must copy
        get { adw_breakpoint_get_condition(opaquePointer).map { BreakpointCondition(borrowing: $0) } }
        // setter is transfer-none: C side copies internally
        set { adw_breakpoint_set_condition(opaquePointer, newValue?.pointer) }
    }

    /// Adds a setter that changes a boolean property when the breakpoint is applied.
    public func addSetter(_ object: GObjectRef, property: PropertyName, value: Bool) {
        var gval = GValue()
        g_value_init(&gval, cadw_type_boolean())
        g_value_set_boolean(&gval, value ? 1 : 0)
        adw_breakpoint_add_setter(
            opaquePointer,
            object.pointer.assumingMemoryBound(to: GObject.self),
            property.name,
            &gval
        )
        g_value_unset(&gval)
    }

    /// Adds a setter that changes an integer property when the breakpoint is applied.
    public func addSetter(_ object: GObjectRef, property: PropertyName, value: Int) {
        var gval = GValue()
        g_value_init(&gval, cadw_type_int())
        g_value_set_int(&gval, Int32(value))
        adw_breakpoint_add_setter(
            opaquePointer,
            object.pointer.assumingMemoryBound(to: GObject.self),
            property.name,
            &gval
        )
        g_value_unset(&gval)
    }

    /// Adds a setter that changes a string property when the breakpoint is applied.
    public func addSetter(_ object: GObjectRef, property: PropertyName, value: String) {
        var gval = GValue()
        g_value_init(&gval, cadw_type_string())
        g_value_set_string(&gval, value)
        adw_breakpoint_add_setter(
            opaquePointer,
            object.pointer.assumingMemoryBound(to: GObject.self),
            property.name,
            &gval
        )
        g_value_unset(&gval)
    }

    /// Adds a setter that changes a double property when the breakpoint is applied.
    public func addSetter(_ object: GObjectRef, property: PropertyName, value: Double) {
        var gval = GValue()
        g_value_init(&gval, cadw_type_double())
        g_value_set_double(&gval, value)
        adw_breakpoint_add_setter(
            opaquePointer,
            object.pointer.assumingMemoryBound(to: GObject.self),
            property.name,
            &gval
        )
        g_value_unset(&gval)
    }

    /// Creates a breakpoint that triggers when the minimum width is reached.
    ///
    /// ```swift
    /// let bp = Breakpoint.minWidth(500)
    /// bp.addSetter(box, property: .orientation, value: "vertical")
    /// window.addBreakpoint(bp)
    /// ```
    public static func minWidth(_ width: Double, unit: AdwLengthUnit = .sp) -> Breakpoint {
        let cond = BreakpointCondition.length(type: ADW_BREAKPOINT_CONDITION_MIN_WIDTH, value: width, unit: unit)
        return Breakpoint(condition: cond)
    }

    /// Creates a breakpoint that triggers when the maximum width is reached.
    public static func maxWidth(_ width: Double, unit: AdwLengthUnit = .sp) -> Breakpoint {
        let cond = BreakpointCondition.length(type: ADW_BREAKPOINT_CONDITION_MAX_WIDTH, value: width, unit: unit)
        return Breakpoint(condition: cond)
    }

    /// Creates a breakpoint that triggers when the minimum height is reached.
    public static func minHeight(_ height: Double, unit: AdwLengthUnit = .sp) -> Breakpoint {
        let cond = BreakpointCondition.length(type: ADW_BREAKPOINT_CONDITION_MIN_HEIGHT, value: height, unit: unit)
        return Breakpoint(condition: cond)
    }

    /// Creates a breakpoint that triggers when the maximum height is reached.
    public static func maxHeight(_ height: Double, unit: AdwLengthUnit = .sp) -> Breakpoint {
        let cond = BreakpointCondition.length(type: ADW_BREAKPOINT_CONDITION_MAX_HEIGHT, value: height, unit: unit)
        return Breakpoint(condition: cond)
    }

    /// Emitted when the breakpoint condition is met.
    ///
    /// - Parameter handler: A closure invoked when the breakpoint is applied.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onApply(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .apply, handler: handler)
    }

    /// Emitted when the breakpoint condition is no longer met.
    ///
    /// - Parameter handler: A closure invoked when the breakpoint is unapplied.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onUnapply(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .unapply, handler: handler)
    }
}
