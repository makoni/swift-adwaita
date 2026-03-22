// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A base class for animations.
@MainActor
open class Animation: GObjectRef {

    /// The `state` property (read-only).
    public var state: AdwAnimationState {
        adw_animation_get_state(castedPointer() as UnsafeMutablePointer<AdwAnimation>)
    }

    /// The `target` property.
    public var target: AnimationTarget {
        get { AnimationTarget(borrowing: UnsafeMutableRawPointer(adw_animation_get_target(castedPointer() as UnsafeMutablePointer<AdwAnimation>))) }
        set { adw_animation_set_target(castedPointer() as UnsafeMutablePointer<AdwAnimation>, newValue.opaquePointer) }
    }

    /// The `value` property (read-only).
    public var value: Double {
        adw_animation_get_value(castedPointer() as UnsafeMutablePointer<AdwAnimation>)
    }

    /// The `widget` property (read-only).
    public var widget: Widget {
        Widget(borrowing: UnsafeMutableRawPointer(adw_animation_get_widget(castedPointer() as UnsafeMutablePointer<AdwAnimation>)))
    }

    /// Calls `adw_animation_pause`.
    public func pause() {
        adw_animation_pause(castedPointer() as UnsafeMutablePointer<AdwAnimation>)
    }

    /// Calls `adw_animation_play`.
    public func play() {
        adw_animation_play(castedPointer() as UnsafeMutablePointer<AdwAnimation>)
    }

    /// Calls `adw_animation_reset`.
    public func reset() {
        adw_animation_reset(castedPointer() as UnsafeMutablePointer<AdwAnimation>)
    }

    /// Calls `adw_animation_resume`.
    public func resume() {
        adw_animation_resume(castedPointer() as UnsafeMutablePointer<AdwAnimation>)
    }

    /// Calls `adw_animation_skip`.
    public func skip() {
        adw_animation_skip(castedPointer() as UnsafeMutablePointer<AdwAnimation>)
    }

    /// Connects to the `done` signal.
    @discardableResult
    public func onDone(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "done", handler: handler)
    }
}
