// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// An animation target that calls a Swift closure with each animated value.
///
/// Wraps `AdwCallbackAnimationTarget`. The most common way to consume
/// animated values: provide a closure that receives a `Double` on each
/// frame and use it to update widget properties imperatively.
///
/// ```swift
/// let target = CallbackAnimationTarget { value in
///     // `value` ranges from 0.0 to 1.0 (for timed) or follows spring dynamics
///     myWidget.opacity = value
/// }
///
/// let animation = TimedAnimation(
///     widget: myWidget, from: 0.0, to: 1.0, duration: 300, target: target
/// )
/// animation.play()
/// ```
///
/// The closure is called on the main actor and receives the current
/// interpolated value from the owning ``Animation``.
@MainActor
public final class CallbackAnimationTarget: AnimationTarget {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `CallbackAnimationTarget` from raw C callback components.
    init(callback: AdwAnimationTargetFunc, userData: gpointer, destroy: GDestroyNotify) {
        let ptr = adw_callback_animation_target_new(callback, userData, destroy)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a new `CallbackAnimationTarget` with a Swift closure.
    ///
    /// The closure receives the current animation value (0.0–1.0 for timed, or the
    /// spring value for spring animations).
    public convenience init(_ handler: @escaping @MainActor (Double) -> Void) {
        let box = Unmanaged.passRetained(PublicClosureBox(handler)).toOpaque()
        self.init(
            callback: { value, userData in
                guard let userData else { return }
                let box = Unmanaged<PublicClosureBox<@MainActor (Double) -> Void>>
                    .fromOpaque(userData).takeUnretainedValue()
                MainActor.assumeIsolated {
                    box.closure(value)
                }
            },
            userData: box,
            destroy: { userData in
                scheduleDeferredBoxRelease(userData)
            }
        )
    }
}
