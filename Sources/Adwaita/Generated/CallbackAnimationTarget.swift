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
}
