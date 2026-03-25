// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A layout manager that constrains children to a maximum size.
///
/// Wraps `AdwClampLayout`. Limits the natural size of its children
/// while allowing them to shrink below the threshold. Commonly used
/// to keep content at a readable width on wide displays.
///
/// ```swift
/// let clampLayout = ClampLayout()
/// clampLayout.maximumSize = 600
/// clampLayout.tighteningThreshold = 400
/// clampLayout.unit = ADW_LENGTH_UNIT_SP
/// ```
///
@MainActor
public final class ClampLayout: LayoutManager {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ClampLayout`.
    public init() {
        let ptr = adw_clamp_layout_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The maximum allowed child size in the clamping direction.
    public var maximumSize: Int {
        get { Int(adw_clamp_layout_get_maximum_size(opaquePointer)) }
        set { adw_clamp_layout_set_maximum_size(opaquePointer, Int32(newValue)) }
    }

    /// The size at which the layout begins smoothly tightening content.
    public var tighteningThreshold: Int {
        get { Int(adw_clamp_layout_get_tightening_threshold(opaquePointer)) }
        set { adw_clamp_layout_set_tightening_threshold(opaquePointer, Int32(newValue)) }
    }

    /// The length unit for ``maximumSize`` and ``tighteningThreshold``.
    /// - Since: libadwaita 1.4
    public var unit: AdwLengthUnit {
        get { adw_clamp_layout_get_unit(opaquePointer) }
        set { adw_clamp_layout_set_unit(opaquePointer, newValue) }
    }
}
