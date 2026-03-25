// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A simple single-child container widget.
///
/// Wraps `AdwBin`. A basic container that holds exactly one child widget.
/// Use it as a building block for custom composite widgets or as a wrapper
/// to apply CSS styling to a single child.
///
/// ```swift
/// let bin = Bin()
///
/// let label = Label(str: "Wrapped content")
/// bin.child = label
///
/// // Add the bin to a parent container
/// box.append(bin)
/// ```
///
/// - Key properties:
///   - ``child``: The single child widget held by the bin.
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

    /// The single child widget contained in the bin.
    public var child: Widget? {
        get { (adw_bin_get_child(castedPointer() as UnsafeMutablePointer<AdwBin>)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_bin_set_child(castedPointer() as UnsafeMutablePointer<AdwBin>, newValue?.widgetPointer) }
    }
}
