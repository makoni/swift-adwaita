// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A box-like layout that can wrap into multiple lines.
/// - Since: libadwaita 1.7
@MainActor
public final class WrapLayout: LayoutManager {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `WrapLayout`.
    public init() {
        let ptr = adw_wrap_layout_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `align` property.
    /// - Since: libadwaita 1.7
    public var align: Float {
        get { adw_wrap_layout_get_align(opaquePointer) }
        set { adw_wrap_layout_set_align(opaquePointer, newValue) }
    }

    /// The `child-spacing` property.
    /// - Since: libadwaita 1.7
    public var childSpacing: Int {
        get { Int(adw_wrap_layout_get_child_spacing(opaquePointer)) }
        set { adw_wrap_layout_set_child_spacing(opaquePointer, Int32(newValue)) }
    }

    /// The `child-spacing-unit` property.
    /// - Since: libadwaita 1.7
    public var childSpacingUnit: AdwLengthUnit {
        get { adw_wrap_layout_get_child_spacing_unit(opaquePointer) }
        set { adw_wrap_layout_set_child_spacing_unit(opaquePointer, newValue) }
    }

    /// The `justify` property.
    /// - Since: libadwaita 1.7
    public var justify: AdwJustifyMode {
        get { adw_wrap_layout_get_justify(opaquePointer) }
        set { adw_wrap_layout_set_justify(opaquePointer, newValue) }
    }

    /// The `justify-last-line` property.
    /// - Since: libadwaita 1.7
    public var justifyLastLine: Bool {
        get { adw_wrap_layout_get_justify_last_line(opaquePointer) != 0 }
        set { adw_wrap_layout_set_justify_last_line(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `line-homogeneous` property.
    /// - Since: libadwaita 1.7
    public var lineHomogeneous: Bool {
        get { adw_wrap_layout_get_line_homogeneous(opaquePointer) != 0 }
        set { adw_wrap_layout_set_line_homogeneous(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `line-spacing` property.
    /// - Since: libadwaita 1.7
    public var lineSpacing: Int {
        get { Int(adw_wrap_layout_get_line_spacing(opaquePointer)) }
        set { adw_wrap_layout_set_line_spacing(opaquePointer, Int32(newValue)) }
    }

    /// The `line-spacing-unit` property.
    /// - Since: libadwaita 1.7
    public var lineSpacingUnit: AdwLengthUnit {
        get { adw_wrap_layout_get_line_spacing_unit(opaquePointer) }
        set { adw_wrap_layout_set_line_spacing_unit(opaquePointer, newValue) }
    }

    /// The `natural-line-length` property.
    /// - Since: libadwaita 1.7
    public var naturalLineLength: Int {
        get { Int(adw_wrap_layout_get_natural_line_length(opaquePointer)) }
        set { adw_wrap_layout_set_natural_line_length(opaquePointer, Int32(newValue)) }
    }

    /// The `natural-line-length-unit` property.
    /// - Since: libadwaita 1.7
    public var naturalLineLengthUnit: AdwLengthUnit {
        get { adw_wrap_layout_get_natural_line_length_unit(opaquePointer) }
        set { adw_wrap_layout_set_natural_line_length_unit(opaquePointer, newValue) }
    }

    /// The `pack-direction` property.
    /// - Since: libadwaita 1.7
    public var packDirection: AdwPackDirection {
        get { adw_wrap_layout_get_pack_direction(opaquePointer) }
        set { adw_wrap_layout_set_pack_direction(opaquePointer, newValue) }
    }

    /// The `wrap-policy` property.
    /// - Since: libadwaita 1.7
    public var wrapPolicy: AdwWrapPolicy {
        get { adw_wrap_layout_get_wrap_policy(opaquePointer) }
        set { adw_wrap_layout_set_wrap_policy(opaquePointer, newValue) }
    }

    /// The `wrap-reverse` property.
    /// - Since: libadwaita 1.7
    public var wrapReverse: Bool {
        get { adw_wrap_layout_get_wrap_reverse(opaquePointer) != 0 }
        set { adw_wrap_layout_set_wrap_reverse(opaquePointer, newValue ? 1 : 0) }
    }
}
