// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// The abstract base class for objects that receive animated values.
///
/// Wraps `AdwAnimationTarget`. An animation target defines what happens
/// when an ``Animation`` produces a new value each frame. Use one of the
/// concrete subclasses:
/// - ``CallbackAnimationTarget``: Calls a Swift closure with the animated value.
/// - ``PropertyAnimationTarget``: Directly updates a GObject property.
///
/// ```swift
/// // Using CallbackAnimationTarget to animate opacity:
/// let target = CallbackAnimationTarget { value in
///     myWidget.opacity = value
/// }
///
/// let animation = TimedAnimation(
///     widget: myWidget, from: 0.0, to: 1.0, duration: 250, target: target
/// )
/// animation.play()
/// ```
@MainActor
public class AnimationTarget: GObjectRef {}
