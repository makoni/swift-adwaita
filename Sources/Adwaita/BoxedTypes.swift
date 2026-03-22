import CAdwaita

// MARK: - SpringParams

/// Parameters for spring-based animations.
///
/// `SpringParams` wraps the `AdwSpringParams` boxed type, which uses
/// reference counting (`adw_spring_params_ref` / `adw_spring_params_unref`).
@MainActor
public final class SpringParams {
    /// The underlying pointer.
    public nonisolated(unsafe) let pointer: OpaquePointer

    /// Creates spring parameters with the given damping ratio, mass, and stiffness.
    public init(dampingRatio: Double, mass: Double, stiffness: Double) {
        self.pointer = adw_spring_params_new(dampingRatio, mass, stiffness)
    }

    /// Creates spring parameters with full control over damping, mass, and stiffness.
    public init(damping: Double, mass: Double, stiffness: Double) {
        self.pointer = adw_spring_params_new_full(damping, mass, stiffness)
    }

    /// Takes ownership of a raw pointer (caller transfers its ref to us).
    internal init(raw pointer: OpaquePointer) {
        self.pointer = pointer
    }

    /// Wraps an existing pointer by adding a reference.
    internal init(borrowing pointer: OpaquePointer) {
        self.pointer = pointer
        adw_spring_params_ref(pointer)
    }

    deinit {
        adw_spring_params_unref(pointer)
    }

    /// The damping value.
    public var damping: Double {
        adw_spring_params_get_damping(pointer)
    }

    /// The damping ratio.
    public var dampingRatio: Double {
        adw_spring_params_get_damping_ratio(pointer)
    }

    /// The mass value.
    public var mass: Double {
        adw_spring_params_get_mass(pointer)
    }

    /// The stiffness value.
    public var stiffness: Double {
        adw_spring_params_get_stiffness(pointer)
    }
}

// MARK: - BreakpointCondition

/// A condition for an ``Breakpoint``.
///
/// `BreakpointCondition` wraps the `AdwBreakpointCondition` boxed type,
/// which uses copy/free semantics.
@MainActor
public final class BreakpointCondition {
    /// The underlying pointer.
    public nonisolated(unsafe) let pointer: OpaquePointer

    /// Creates a length condition.
    public static func length(
        type: AdwBreakpointConditionLengthType,
        value: Double,
        unit: AdwLengthUnit
    ) -> BreakpointCondition {
        let ptr = adw_breakpoint_condition_new_length(type, value, unit)!
        return BreakpointCondition(raw: ptr)
    }

    /// Creates a ratio condition.
    public static func ratio(
        type: AdwBreakpointConditionRatioType,
        width: Int,
        height: Int
    ) -> BreakpointCondition {
        let ptr = adw_breakpoint_condition_new_ratio(type, Int32(width), Int32(height))!
        return BreakpointCondition(raw: ptr)
    }

    /// Creates an AND condition combining two conditions.
    ///
    /// Both conditions are copied before being consumed by the C function.
    public static func and(_ a: BreakpointCondition, _ b: BreakpointCondition) -> BreakpointCondition {
        // new_and takes ownership of both arguments, so pass copies
        let ptr = adw_breakpoint_condition_new_and(
            adw_breakpoint_condition_copy(a.pointer),
            adw_breakpoint_condition_copy(b.pointer)
        )!
        return BreakpointCondition(raw: ptr)
    }

    /// Creates an OR condition combining two conditions.
    ///
    /// Both conditions are copied before being consumed by the C function.
    public static func or(_ a: BreakpointCondition, _ b: BreakpointCondition) -> BreakpointCondition {
        // new_or takes ownership of both arguments, so pass copies
        let ptr = adw_breakpoint_condition_new_or(
            adw_breakpoint_condition_copy(a.pointer),
            adw_breakpoint_condition_copy(b.pointer)
        )!
        return BreakpointCondition(raw: ptr)
    }

    /// Creates a condition by parsing a string description.
    public init(parse string: String) {
        self.pointer = adw_breakpoint_condition_parse(string)!
    }

    /// Takes ownership of a raw pointer (caller transfers ownership to us).
    internal init(raw pointer: OpaquePointer) {
        self.pointer = pointer
    }

    /// Wraps an existing pointer by copying it.
    internal init(borrowing pointer: OpaquePointer) {
        self.pointer = adw_breakpoint_condition_copy(pointer)!
    }

    deinit {
        adw_breakpoint_condition_free(pointer)
    }

    /// Returns the string representation of this condition.
    public func toString() -> String {
        let cStr = adw_breakpoint_condition_to_string(pointer)!
        defer { g_free(gpointer(mutating: cStr)) }
        return String(cString: cStr)
    }
}
