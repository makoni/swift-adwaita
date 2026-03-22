// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A time-based [class@Animation].
@MainActor
public final class TimedAnimation: Animation {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
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

    /// The `alternate` property.
    public var alternate: Bool {
        get { adw_timed_animation_get_alternate(opaquePointer) != 0 }
        set { adw_timed_animation_set_alternate(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `duration` property.
    public var duration: Int {
        get { Int(adw_timed_animation_get_duration(opaquePointer)) }
        set { adw_timed_animation_set_duration(opaquePointer, UInt32(newValue)) }
    }

    /// The `easing` property.
    public var easing: AdwEasing {
        get { adw_timed_animation_get_easing(opaquePointer) }
        set { adw_timed_animation_set_easing(opaquePointer, newValue) }
    }

    /// The `repeat-count` property.
    public var repeatCount: Int {
        get { Int(adw_timed_animation_get_repeat_count(opaquePointer)) }
        set { adw_timed_animation_set_repeat_count(opaquePointer, UInt32(newValue)) }
    }

    /// The `reverse` property.
    public var reverse: Bool {
        get { adw_timed_animation_get_reverse(opaquePointer) != 0 }
        set { adw_timed_animation_set_reverse(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `value-from` property.
    public var valueFrom: Double {
        get { adw_timed_animation_get_value_from(opaquePointer) }
        set { adw_timed_animation_set_value_from(opaquePointer, newValue) }
    }

    /// The `value-to` property.
    public var valueTo: Double {
        get { adw_timed_animation_get_value_to(opaquePointer) }
        set { adw_timed_animation_set_value_to(opaquePointer, newValue) }
    }
}
