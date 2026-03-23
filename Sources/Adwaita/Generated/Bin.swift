// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A widget with one child.
@MainActor
public class Bin: Widget {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `Bin`.
    public init() {
        let ptr = adw_bin_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `child` property.
    public var child: Widget? {
        get { (adw_bin_get_child(castedPointer() as UnsafeMutablePointer<AdwBin>)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_bin_set_child(castedPointer() as UnsafeMutablePointer<AdwBin>, newValue?.widgetPointer) }
    }
}
