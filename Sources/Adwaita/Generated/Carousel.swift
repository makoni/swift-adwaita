// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A paginated scrolling widget.
@MainActor
public final class Carousel: Widget, Swipeable, Container {
    override public class var gtkType: GType {
        adw_carousel_get_type()
    }

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `Carousel`.
    public init() {
        let ptr = adw_carousel_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Whether the carousel allows swiping past more than one page at a time.
    public var allowLongSwipes: Bool {
        get { adw_carousel_get_allow_long_swipes(opaquePointer) != 0 }
        set { adw_carousel_set_allow_long_swipes(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the carousel can be navigated by clicking and dragging with a mouse.
    public var allowMouseDrag: Bool {
        get { adw_carousel_get_allow_mouse_drag(opaquePointer) != 0 }
        set { adw_carousel_set_allow_mouse_drag(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the carousel can be navigated using the scroll wheel.
    public var allowScrollWheel: Bool {
        get { adw_carousel_get_allow_scroll_wheel(opaquePointer) != 0 }
        set { adw_carousel_set_allow_scroll_wheel(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the user can navigate the carousel by swiping or other gestures.
    public var interactive: Bool {
        get { adw_carousel_get_interactive(opaquePointer) != 0 }
        set { adw_carousel_set_interactive(opaquePointer, newValue ? 1 : 0) }
    }

    /// The number of pages in the carousel (read-only).
    public var nPages: Int {
        Int(adw_carousel_get_n_pages(opaquePointer))
    }

    /// The current scrolling position as a fractional page index (read-only).
    public var position: Double {
        adw_carousel_get_position(opaquePointer)
    }

    /// The duration of the animation when a child is added or removed, in milliseconds.
    public var revealDuration: Int {
        get { Int(adw_carousel_get_reveal_duration(opaquePointer)) }
        set { adw_carousel_set_reveal_duration(opaquePointer, UInt32(newValue)) }
    }

    /// The spring animation parameters used for scroll transitions.
    public var scrollParams: SpringParams {
        // getter is transfer-full: we own the returned ref
        get { SpringParams(raw: adw_carousel_get_scroll_params(opaquePointer)) }
        // setter is transfer-none: C side refs internally
        set { adw_carousel_set_scroll_params(opaquePointer, newValue.pointer) }
    }

    /// The spacing between pages, in pixels.
    public var spacing: Int {
        get { Int(adw_carousel_get_spacing(opaquePointer)) }
        set { adw_carousel_set_spacing(opaquePointer, UInt32(newValue)) }
    }

    /// Appends a child widget to the end of the carousel.
    ///
    /// - Parameter child: The widget to append.
    public func append(_ child: Widget) {
        adw_carousel_append(opaquePointer, child.widgetPointer)
    }

    /// Returns the child widget at the given page index.
    ///
    /// - Parameter n: The zero-based index of the page to retrieve.
    /// - Returns: The widget at position `n`.
    @discardableResult
    public func getNthPage(_ n: Int) -> Widget {
        Widget(borrowing: UnsafeMutableRawPointer(adw_carousel_get_nth_page(opaquePointer, UInt32(n))))
    }

    /// Inserts a child widget at the given position in the carousel.
    ///
    /// - Parameter child: The widget to insert.
    /// - Parameter position: The zero-based index at which to insert the widget.
    public func insert(_ child: Widget, position: Int) {
        adw_carousel_insert(opaquePointer, child.widgetPointer, Int32(position))
    }

    /// Prepends a child widget to the beginning of the carousel.
    ///
    /// - Parameter child: The widget to prepend.
    public func prepend(_ child: Widget) {
        adw_carousel_prepend(opaquePointer, child.widgetPointer)
    }

    /// Removes a child widget from the carousel.
    ///
    /// - Parameter child: The widget to remove.
    public func remove(_ child: Widget) {
        adw_carousel_remove(opaquePointer, child.widgetPointer)
    }

    /// Moves a child widget to a new position within the carousel.
    ///
    /// - Parameter child: The widget to reorder.
    /// - Parameter position: The new zero-based index for the widget.
    public func reorder(_ child: Widget, position: Int) {
        adw_carousel_reorder(opaquePointer, child.widgetPointer, Int32(position))
    }

    /// Scrolls the carousel to bring the given widget into view.
    ///
    /// - Parameter widget: The child widget to scroll to.
    /// - Parameter animate: Whether to animate the scroll transition.
    public func scrollTo(_ widget: Widget, animate: Bool) {
        adw_carousel_scroll_to(opaquePointer, widget.widgetPointer, animate ? 1 : 0)
    }

    /// Called when the visible page changes.
    ///
    /// - Parameter handler: A closure receiving the new page index.
    /// - Returns: A signal connection that can be used to disconnect the handler.
    @discardableResult
    public func onPageChanged(_ handler: @escaping @MainActor (Int) -> Void) -> SignalConnection {
        SignalHelper.connectUInt(self, signal: .pageChanged) { (value: UInt32) in
            handler(Int(value))
        }
    }

    /// Appends multiple child widgets.
    public func appendAll(_ children: [Widget]) {
        for child in children {
            append(child)
        }
    }

    /// Sets spacing and returns self for chaining.
    @discardableResult
    public func spacing(_ spacing: Int) -> Self {
        self.spacing = spacing
        return self
    }

    /// Sets interactive and returns self for chaining.
    @discardableResult
    public func interactive(_ interactive: Bool) -> Self {
        self.interactive = interactive
        return self
    }
}
