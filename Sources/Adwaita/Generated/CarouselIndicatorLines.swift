// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A lines indicator for [class@Carousel].
@MainActor
public final class CarouselIndicatorLines: Widget {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `CarouselIndicatorLines`.
    public init() {
        let ptr = adw_carousel_indicator_lines_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `carousel` property.
    public var carousel: Carousel? {
        get { (adw_carousel_indicator_lines_get_carousel(opaquePointer)).map { Carousel(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_carousel_indicator_lines_set_carousel(opaquePointer, newValue?.opaquePointer) }
    }
}
