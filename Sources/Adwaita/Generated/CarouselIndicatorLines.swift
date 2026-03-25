// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A line-style page indicator for a ``Carousel``.
///
/// Wraps `AdwCarouselIndicatorLines`. Renders a row of thin lines where
/// the highlighted segment tracks the current page of the associated
/// carousel.
///
/// ```swift
/// let carousel = Carousel()
/// carousel.append(pageOne)
/// carousel.append(pageTwo)
///
/// let lines = CarouselIndicatorLines()
/// lines.carousel = carousel
///
/// box.append(carousel)
/// box.append(lines)
/// ```
///
@MainActor
public final class CarouselIndicatorLines: Widget {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `CarouselIndicatorLines`.
    public init() {
        let ptr = adw_carousel_indicator_lines_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The ``Carousel`` whose current page position is tracked by these indicator lines.
    public var carousel: Carousel? {
        get { (adw_carousel_indicator_lines_get_carousel(opaquePointer)).map { Carousel(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_carousel_indicator_lines_set_carousel(opaquePointer, newValue?.opaquePointer) }
    }
}
