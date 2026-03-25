import CAdwaita
import GObjectSupport

/// Handles scroll events.
///
/// Wraps `GtkEventControllerScroll`. Reports scroll deltas on one or both
/// axes. Use flags to select vertical, horizontal, or both axes, and whether
/// to use discrete or kinetic scrolling. Attach with `addController()`.
///
/// ```swift
/// let scroll = EventControllerScroll(flags: GTK_EVENT_CONTROLLER_SCROLL_VERTICAL)
/// scroll.onScroll { dx, dy in
///     print("Scrolled vertically by \(dy)")
///     return true  // stop propagation
/// }
/// scroll.onScrollBegin {
///     print("Scroll gesture started")
/// }
/// scroll.onScrollEnd {
///     print("Scroll gesture ended")
/// }
/// myWidget.addController(scroll)
/// ```
@MainActor
public final class EventControllerScroll: GObjectRef {
    /// Creates a scroll event controller with the given flags.
    public init(flags: GtkEventControllerScrollFlags = GTK_EVENT_CONTROLLER_SCROLL_BOTH_AXES) {
        let ptr = gtk_event_controller_scroll_new(flags)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Emitted when a scroll event occurs.
    ///
    /// - Parameter handler: Called on scroll. Receives dx and dy deltas. Return `true` to stop propagation.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onScroll(_ handler: @escaping @MainActor (Double, Double) -> Bool) -> SignalConnection {
        SignalHelper.connectDoubleDoubleReturnBool(self, signal: .scroll, handler: handler)
    }

    /// Emitted when scrolling begins.
    ///
    /// - Parameter handler: Called when a scroll gesture starts.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onScrollBegin(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .scrollBegin, handler: handler)
    }

    /// Emitted when scrolling ends.
    ///
    /// - Parameter handler: Called when a scroll gesture ends.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onScrollEnd(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .scrollEnd, handler: handler)
    }
}
