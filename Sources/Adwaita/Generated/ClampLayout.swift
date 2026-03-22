// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A layout manager constraining its children to a given size.
@MainActor
public final class ClampLayout: LayoutManager {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ClampLayout`.
    public init() {
        let ptr = adw_clamp_layout_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `maximum-size` property.
    public var maximumSize: Int {
        get { Int(adw_clamp_layout_get_maximum_size(opaquePointer)) }
        set { adw_clamp_layout_set_maximum_size(opaquePointer, Int32(newValue)) }
    }

    /// The `tightening-threshold` property.
    public var tighteningThreshold: Int {
        get { Int(adw_clamp_layout_get_tightening_threshold(opaquePointer)) }
        set { adw_clamp_layout_set_tightening_threshold(opaquePointer, Int32(newValue)) }
    }

    /// The `unit` property.
    /// - Since: libadwaita 1.4
    public var unit: AdwLengthUnit {
        get { adw_clamp_layout_get_unit(opaquePointer) }
        set { adw_clamp_layout_set_unit(opaquePointer, newValue) }
    }
}
