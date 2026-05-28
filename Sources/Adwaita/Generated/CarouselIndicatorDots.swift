// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A dot-style page indicator for a ``Carousel``.
///
/// Wraps `AdwCarouselIndicatorDots`. Renders a row of dots where the
/// highlighted dot tracks the current page of the associated carousel.
///
/// ```swift
/// let carousel = Carousel()
/// carousel.append(pageOne)
/// carousel.append(pageTwo)
///
/// let dots = CarouselIndicatorDots()
/// dots.carousel = carousel
///
/// box.append(carousel)
/// box.append(dots)
/// ```
///
@MainActor
public final class CarouselIndicatorDots: Widget {
    override public class var gtkType: GType {
        adw_carousel_indicator_dots_get_type()
    }

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `CarouselIndicatorDots`.
    public init() {
        let ptr = adw_carousel_indicator_dots_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The ``Carousel`` whose current page position is tracked by these indicator dots.
    public var carousel: Carousel? {
        get {
            adw_carousel_indicator_dots_get_carousel(opaquePointer)
                .map { Carousel(borrowing: UnsafeMutableRawPointer($0)) }
        }
        set { adw_carousel_indicator_dots_set_carousel(opaquePointer, newValue?.opaquePointer) }
    }
}
