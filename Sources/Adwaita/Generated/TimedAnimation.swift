// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A time-based animation with a fixed duration and easing curve.
///
/// Wraps `AdwTimedAnimation`. Interpolates a value from ``valueFrom`` to
/// ``valueTo`` over a specified ``duration`` using an easing function.
/// Supports repeating, reversing, and alternating playback.
///
/// ```swift
/// let target = CallbackAnimationTarget { value in
///     widget.opacity = value
/// }
///
/// let animation = TimedAnimation(
///     widget: widget, from: 0.0, to: 1.0, duration: 500, target: target
/// )
/// animation.easing = .easeInOutCubic
/// animation.repeatCount = 1
///
/// animation.onDone {
///     print("Animation finished")
/// }
/// animation.play()
/// ```
///
/// - Key properties:
///   - ``duration``: The animation duration in milliseconds.
///   - ``easing``: The easing function (e.g., linear, ease-in-out).
///   - ``valueFrom``: The starting value.
///   - ``valueTo``: The ending value.
///   - ``repeatCount``: How many times to repeat (0 for infinite).
///   - ``reverse``: Whether to play the animation in reverse.
///   - ``alternate``: Whether to alternate direction on each repeat.
@MainActor
public final class TimedAnimation: Animation {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `TimedAnimation`.
    ///
    /// The C function takes ownership of `target` (transfer-full),
    /// so we add a ref to keep the Swift wrapper valid.
    public init(widget: Widget, from: Double, to: Double, duration: Int, target: AnimationTarget) {
        g_object_ref(target.pointer)
        let ptr = adw_timed_animation_new(widget.widgetPointer, from, to, UInt32(duration), target.opaquePointer)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Whether the animation alternates direction on each repeat cycle.
    public var alternate: Bool {
        get { adw_timed_animation_get_alternate(opaquePointer) != 0 }
        set { adw_timed_animation_set_alternate(opaquePointer, newValue ? 1 : 0) }
    }

    /// The animation duration in milliseconds.
    public var duration: Int {
        get { Int(adw_timed_animation_get_duration(opaquePointer)) }
        set { adw_timed_animation_set_duration(opaquePointer, UInt32(newValue)) }
    }

    /// The easing function used for interpolation (e.g. linear, ease-in-out).
    public var easing: AdwEasing {
        get { adw_timed_animation_get_easing(opaquePointer) }
        set { adw_timed_animation_set_easing(opaquePointer, newValue) }
    }

    /// How many times the animation repeats. Use `0` for infinite repetition.
    public var repeatCount: Int {
        get { Int(adw_timed_animation_get_repeat_count(opaquePointer)) }
        set { adw_timed_animation_set_repeat_count(opaquePointer, UInt32(newValue)) }
    }

    /// Whether the animation plays in reverse (from ``valueTo`` to ``valueFrom``).
    public var reverse: Bool {
        get { adw_timed_animation_get_reverse(opaquePointer) != 0 }
        set { adw_timed_animation_set_reverse(opaquePointer, newValue ? 1 : 0) }
    }

    /// The starting value of the animation.
    public var valueFrom: Double {
        get { adw_timed_animation_get_value_from(opaquePointer) }
        set { adw_timed_animation_set_value_from(opaquePointer, newValue) }
    }

    /// The ending value of the animation.
    public var valueTo: Double {
        get { adw_timed_animation_get_value_to(opaquePointer) }
        set { adw_timed_animation_set_value_to(opaquePointer, newValue) }
    }
}
