// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// The abstract base class for all Adwaita animations.
///
/// Wraps `AdwAnimation`. Subclasses such as ``TimedAnimation`` and
/// ``SpringAnimation`` provide concrete animation behaviors. An animation
/// interpolates a value and applies it to an ``AnimationTarget`` (typically
/// a ``CallbackAnimationTarget``). Control playback with `play()`, `pause()`,
/// `resume()`, `reset()`, and `skip()`.
///
/// ```swift
/// let target = CallbackAnimationTarget { value in
///     widget.opacity = value
/// }
/// let animation = TimedAnimation(widget: widget, from: 0, to: 1, duration: 300, target: target)
///
/// animation.onDone {
///     print("Fade-in complete")
/// }
/// animation.play()
/// ```
///
/// - Key properties:
///   - ``state``: The current animation state (playing, paused, finished, etc.) (read-only).
///   - ``value``: The current interpolated value (read-only).
///   - ``target``: The ``AnimationTarget`` receiving animated values.
///   - ``widget``: The widget this animation is associated with (read-only).
/// - Key methods:
///   - ``play()``: Starts or restarts the animation.
///   - ``pause()``: Pauses a playing animation.
///   - ``resume()``: Resumes a paused animation.
///   - ``reset()``: Resets the animation to its initial state.
///   - ``skip()``: Skips to the end value immediately.
///   - ``onDone(_:)``: Connects a handler called when the animation completes.
@MainActor
public class Animation: GObjectRef {

    /// The current playback state of the animation (idle, paused, playing, or finished).
    public var state: AdwAnimationState {
        adw_animation_get_state(castedPointer() as UnsafeMutablePointer<AdwAnimation>)
    }

    /// The animation target that receives interpolated values during playback.
    public var target: AnimationTarget {
        get {
            AnimationTarget(
                borrowing: UnsafeMutableRawPointer(
                    adw_animation_get_target(castedPointer() as UnsafeMutablePointer<AdwAnimation>)
                )
            )
        }
        set { adw_animation_set_target(castedPointer() as UnsafeMutablePointer<AdwAnimation>, newValue.opaquePointer) }
    }

    /// The current interpolated value produced by the animation.
    public var value: Double {
        adw_animation_get_value(castedPointer() as UnsafeMutablePointer<AdwAnimation>)
    }

    /// The widget that this animation is associated with and uses for frame timing.
    public var widget: Widget {
        Widget(
            borrowing: UnsafeMutableRawPointer(
                adw_animation_get_widget(castedPointer() as UnsafeMutablePointer<AdwAnimation>)
            )
        )
    }

    /// Pauses a playing animation, freezing it at the current value.
    ///
    /// Call ``resume()`` to continue from where it left off.
    public func pause() {
        adw_animation_pause(castedPointer() as UnsafeMutablePointer<AdwAnimation>)
    }

    /// Starts or restarts the animation from the beginning.
    ///
    /// If the animation is already playing, it restarts from the initial value.
    public func play() {
        adw_animation_play(castedPointer() as UnsafeMutablePointer<AdwAnimation>)
    }

    /// Resets the animation back to its initial state and value.
    public func reset() {
        adw_animation_reset(castedPointer() as UnsafeMutablePointer<AdwAnimation>)
    }

    /// Resumes a paused animation, continuing from the current value.
    public func resume() {
        adw_animation_resume(castedPointer() as UnsafeMutablePointer<AdwAnimation>)
    }

    /// Skips the animation to the end, immediately setting the final value.
    public func skip() {
        adw_animation_skip(castedPointer() as UnsafeMutablePointer<AdwAnimation>)
    }

    /// Emitted when the animation has finished playing, whether by reaching the
    /// end naturally, being skipped, or completing after being reset.
    ///
    /// - Parameter handler: A closure invoked when the animation finishes.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onDone(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .done, handler: handler)
    }
}
