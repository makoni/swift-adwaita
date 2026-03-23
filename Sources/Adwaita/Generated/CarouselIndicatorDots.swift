// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A dots indicator for [class@Carousel].
@MainActor
public final class CarouselIndicatorDots: Widget {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `CarouselIndicatorDots`.
    public init() {
        let ptr = adw_carousel_indicator_dots_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `carousel` property.
    public var carousel: Carousel? {
        get { (adw_carousel_indicator_dots_get_carousel(opaquePointer)).map { Carousel(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_carousel_indicator_dots_set_carousel(opaquePointer, newValue?.opaquePointer) }
    }
}
