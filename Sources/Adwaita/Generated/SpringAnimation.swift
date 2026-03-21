// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A spring-based [class@Animation].
@MainActor
public final class SpringAnimation: Animation {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `SpringAnimation`.
    public init(widget: Widget, from: Double, to: Double, springParams: OpaquePointer, target: OpaquePointer) {
        let ptr = adw_spring_animation_new(widget.widgetPointer, from, to, springParams, target)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `clamp` property.
    public var clamp: Bool {
        get { adw_spring_animation_get_clamp(opaquePointer) != 0 }
        set { adw_spring_animation_set_clamp(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `epsilon` property.
    public var epsilon: Double {
        get { adw_spring_animation_get_epsilon(opaquePointer) }
        set { adw_spring_animation_set_epsilon(opaquePointer, newValue) }
    }

    /// The `estimated-duration` property (read-only).
    public var estimatedDuration: UInt32 {
        adw_spring_animation_get_estimated_duration(opaquePointer)
    }

    /// The `initial-velocity` property.
    public var initialVelocity: Double {
        get { adw_spring_animation_get_initial_velocity(opaquePointer) }
        set { adw_spring_animation_set_initial_velocity(opaquePointer, newValue) }
    }

    /// The `spring-params` property.
    public var springParams: OpaquePointer {
        get { adw_spring_animation_get_spring_params(opaquePointer) }
        set { adw_spring_animation_set_spring_params(opaquePointer, newValue) }
    }

    /// The `value-from` property.
    public var valueFrom: Double {
        get { adw_spring_animation_get_value_from(opaquePointer) }
        set { adw_spring_animation_set_value_from(opaquePointer, newValue) }
    }

    /// The `value-to` property.
    public var valueTo: Double {
        get { adw_spring_animation_get_value_to(opaquePointer) }
        set { adw_spring_animation_set_value_to(opaquePointer, newValue) }
    }

    /// The `velocity` property (read-only).
    public var velocity: Double {
        adw_spring_animation_get_velocity(opaquePointer)
    }

    /// Calls `adw_spring_animation_calculate_value`.
    @discardableResult
    public func calculateValue(_ time: UInt32) -> Double {
        return adw_spring_animation_calculate_value(opaquePointer, time)
    }

    /// Calls `adw_spring_animation_calculate_velocity`.
    @discardableResult
    public func calculateVelocity(_ time: UInt32) -> Double {
        return adw_spring_animation_calculate_velocity(opaquePointer, time)
    }
}
