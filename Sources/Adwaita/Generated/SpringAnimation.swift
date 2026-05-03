// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// An animation driven by spring physics for natural-feeling motion.
///
/// Wraps `AdwSpringAnimation`. Animates a value using a damped spring model,
/// producing organic, physically plausible motion. The duration is not fixed
/// but determined by the spring parameters and epsilon threshold.
///
/// ```swift
/// let target = CallbackAnimationTarget { value in
///     widget.marginTop = Int(value)
/// }
///
/// let params = SpringParams(dampingRatio: 0.8, mass: 1.0, stiffness: 100.0)
/// let animation = SpringAnimation(
///     widget: widget, from: 0, to: 200, springParams: params, target: target
/// )
/// animation.clamp = true
/// animation.play()
/// ```
///
/// - Key properties:
///   - ``springParams``: The `SpringParams` controlling damping, mass, and stiffness.
///   - ``valueFrom``: The starting value.
///   - ``valueTo``: The target value.
///   - ``initialVelocity``: The initial velocity of the spring.
///   - ``clamp``: Whether to clamp the animated value between `valueFrom` and `valueTo`.
///   - ``epsilon``: The threshold below which the animation is considered settled.
///   - ``estimatedDuration``: The estimated duration in milliseconds (read-only).
///   - ``velocity``: The current spring velocity (read-only).
/// - Key methods:
///   - ``calculateValue(_:)``: Computes the spring value at a given time.
///   - ``calculateVelocity(_:)``: Computes the spring velocity at a given time.
@MainActor
public final class SpringAnimation: Animation {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `SpringAnimation`.
    ///
    /// The C function takes ownership of both `springParams` (transfer-full)
    /// and `target` (transfer-full), so we add refs/copies to keep the
    /// Swift wrappers valid.
    public init(widget: Widget, from: Double, to: Double, springParams: SpringParams, target: AnimationTarget) {
        g_object_ref(target.pointer)
        adw_spring_params_ref(springParams.pointer)
        let ptr = adw_spring_animation_new(widget.widgetPointer, from, to, springParams.pointer, target.opaquePointer)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Whether to clamp the animated value between ``valueFrom`` and ``valueTo``.
    ///
    /// When enabled, the spring will not overshoot beyond the start and end values,
    /// which can remove the natural bounce effect.
    public var clamp: Bool {
        get { adw_spring_animation_get_clamp(opaquePointer) != 0 }
        set { adw_spring_animation_set_clamp(opaquePointer, newValue ? 1 : 0) }
    }

    /// The precision threshold below which the spring is considered settled.
    ///
    /// A smaller epsilon results in a longer, more precise animation.
    /// The default is `0.001`.
    public var epsilon: Double {
        get { adw_spring_animation_get_epsilon(opaquePointer) }
        set { adw_spring_animation_set_epsilon(opaquePointer, newValue) }
    }

    /// The estimated duration of the animation in milliseconds, based on the current spring parameters.
    ///
    /// This is not a fixed duration; it depends on damping, mass, stiffness, and epsilon.
    public var estimatedDuration: Int {
        Int(adw_spring_animation_get_estimated_duration(opaquePointer))
    }

    /// The initial velocity of the spring animation, in units per second.
    ///
    /// Set this to give the spring an initial push, for example to match
    /// the velocity of a preceding gesture.
    public var initialVelocity: Double {
        get { adw_spring_animation_get_initial_velocity(opaquePointer) }
        set { adw_spring_animation_set_initial_velocity(opaquePointer, newValue) }
    }

    /// The spring parameters (damping ratio, mass, and stiffness) that control the animation behavior.
    public var springParams: SpringParams {
        // getter is transfer-none: we must borrow (ref)
        get { SpringParams(borrowing: adw_spring_animation_get_spring_params(opaquePointer)) }
        // setter is transfer-none: C side refs internally
        set { adw_spring_animation_set_spring_params(opaquePointer, newValue.pointer) }
    }

    /// The starting value of the spring animation.
    public var valueFrom: Double {
        get { adw_spring_animation_get_value_from(opaquePointer) }
        set { adw_spring_animation_set_value_from(opaquePointer, newValue) }
    }

    /// The target (resting) value of the spring animation.
    public var valueTo: Double {
        get { adw_spring_animation_get_value_to(opaquePointer) }
        set { adw_spring_animation_set_value_to(opaquePointer, newValue) }
    }

    /// The current velocity of the spring, in units per second.
    public var velocity: Double {
        adw_spring_animation_get_velocity(opaquePointer)
    }

    /// Computes the spring's interpolated value at the given time.
    ///
    /// - Parameter time: The elapsed time in milliseconds.
    /// - Returns: The spring value at that point in time.
    @discardableResult
    public func calculateValue(_ time: Int) -> Double {
        adw_spring_animation_calculate_value(opaquePointer, UInt32(time))
    }

    /// Computes the spring's velocity at the given time.
    ///
    /// - Parameter time: The elapsed time in milliseconds.
    /// - Returns: The spring velocity at that point in time.
    @discardableResult
    public func calculateVelocity(_ time: Int) -> Double {
        adw_spring_animation_calculate_velocity(opaquePointer, UInt32(time))
    }
}
