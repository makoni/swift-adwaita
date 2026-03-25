// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A scrollable variant of `Clamp` that constrains its child to a maximum size.
///
/// Wraps `AdwClampScrollable`. Works like a clamp but also implements
/// `GtkScrollable`, making it suitable for use inside a `ScrolledWindow`.
///
/// ```swift
/// let clamp = ClampScrollable()
/// clamp.maximumSize = 600
/// clamp.tighteningThreshold = 400
/// clamp.child = contentWidget
/// ```
///
@MainActor
public final class ClampScrollable: Widget {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ClampScrollable`.
    public init() {
        let ptr = adw_clamp_scrollable_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The child widget whose size is constrained by the clamp.
    public var child: Widget? {
        get { (adw_clamp_scrollable_get_child(opaquePointer)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_clamp_scrollable_set_child(opaquePointer, newValue?.widgetPointer) }
    }

    /// The maximum allowed size of the child in the clamping direction.
    public var maximumSize: Int {
        get { Int(adw_clamp_scrollable_get_maximum_size(opaquePointer)) }
        set { adw_clamp_scrollable_set_maximum_size(opaquePointer, Int32(newValue)) }
    }

    /// The size at which the clamp begins tightening toward the maximum size.
    public var tighteningThreshold: Int {
        get { Int(adw_clamp_scrollable_get_tightening_threshold(opaquePointer)) }
        set { adw_clamp_scrollable_set_tightening_threshold(opaquePointer, Int32(newValue)) }
    }

    /// The unit used for the maximum size and tightening threshold values.
    /// - Since: libadwaita 1.4
    public var unit: AdwLengthUnit {
        get { adw_clamp_scrollable_get_unit(opaquePointer) }
        set { adw_clamp_scrollable_set_unit(opaquePointer, newValue) }
    }
}
