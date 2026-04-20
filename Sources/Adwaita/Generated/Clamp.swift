// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A size-constraining container that limits its child to a maximum width.
///
/// Wraps `AdwClamp`. Use this widget to constrain wide content (such as a
/// preferences page or a text column) to a comfortable reading width, with a
/// smooth transition when the available space exceeds the maximum size.
///
/// ```swift
/// let clamp = Clamp()
/// clamp.maximumSize = 600
/// clamp.tighteningThreshold = 400
///
/// let label = Label(str: "This content won't stretch too wide.")
/// clamp.child = label
///
/// window.child = clamp
/// ```
///
/// - Key properties:
///   - ``child``: The widget to constrain.
///   - ``maximumSize``: The maximum allowed width in pixels (default 600).
///   - ``tighteningThreshold``: The width at which the clamp begins tightening.
///   - ``unit``: The length unit for size values (since libadwaita 1.4).
@MainActor
public final class Clamp: Widget {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `Clamp`.
    public init() {
        let ptr = adw_clamp_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    public override class var gtkType: GType {
        adw_clamp_get_type()
    }

    /// The widget whose width is constrained by the clamp.
    public var child: Widget? {
        get { adw_clamp_get_child(opaquePointer).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_clamp_set_child(opaquePointer, newValue?.widgetPointer) }
    }

    /// The maximum allowed width in pixels (default 600).
    public var maximumSize: Int {
        get { Int(adw_clamp_get_maximum_size(opaquePointer)) }
        set { adw_clamp_set_maximum_size(opaquePointer, Int32(newValue)) }
    }

    /// The width at which the clamp begins smoothly tightening content.
    public var tighteningThreshold: Int {
        get { Int(adw_clamp_get_tightening_threshold(opaquePointer)) }
        set { adw_clamp_set_tightening_threshold(opaquePointer, Int32(newValue)) }
    }

    /// The length unit for ``maximumSize`` and ``tighteningThreshold``.
    /// - Since: libadwaita 1.4
    public var unit: AdwLengthUnit {
        get { adw_clamp_get_unit(opaquePointer) }
        set { adw_clamp_set_unit(opaquePointer, newValue) }
    }
}
