// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// An [class@AnimationTarget] that calls a given callback during the animation.
@MainActor
public final class CallbackAnimationTarget: AnimationTarget {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `CallbackAnimationTarget`.
    public init(callback: AdwAnimationTargetFunc, userData: gpointer, destroy: GDestroyNotify) {
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
                guard let userData else { return }
                Unmanaged<AnyObject>.fromOpaque(userData).release()
            }
        )
    }
}
