// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A widget constraining its child to a given size.
@MainActor
public final class Clamp: Widget {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `Clamp`.
    public init() {
        let ptr = adw_clamp_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `child` property.
    public var child: Widget? {
        get { (adw_clamp_get_child(opaquePointer)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_clamp_set_child(opaquePointer, newValue?.widgetPointer) }
    }

    /// The `maximum-size` property.
    public var maximumSize: Int {
        get { Int(adw_clamp_get_maximum_size(opaquePointer)) }
        set { adw_clamp_set_maximum_size(opaquePointer, Int32(newValue)) }
    }

    /// The `tightening-threshold` property.
    public var tighteningThreshold: Int {
        get { Int(adw_clamp_get_tightening_threshold(opaquePointer)) }
        set { adw_clamp_set_tightening_threshold(opaquePointer, Int32(newValue)) }
    }

    /// The `unit` property.
    /// - Since: libadwaita 1.4
    public var unit: AdwLengthUnit {
        get { adw_clamp_get_unit(opaquePointer) }
        set { adw_clamp_set_unit(opaquePointer, newValue) }
    }
}
