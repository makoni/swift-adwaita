import CAdwaita
import GObjectSupport

/// A bubble-like popup attached to a widget.
///
/// Wraps `GtkPopover`. Displays arbitrary content in a floating bubble
/// anchored to its parent widget. Set the popover as a child of a
/// `MenuButton`, or call `popup()` / `popdown()` to show and hide it.
///
/// ```swift
/// let popover = Popover()
/// popover.hasArrow = true
/// popover.position = GTK_POS_BOTTOM
/// popover.autohide = true
/// popover.child = Label("Hello from the popover!")
///
/// let button = MenuButton(label: "Show Info")
/// button.setPopover(popover)
///
/// popover.onClosed {
///     print("Popover was closed")
/// }
/// ```
@MainActor
public final class Popover: Widget {
    /// Creates a new popover.
    public init() {
        let ptr = gtk_popover_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The child widget of the popover.
    public var child: Widget? {
        get {
            guard let ptr = gtk_popover_get_child(castedPointer()) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set {
            gtk_popover_set_child(castedPointer(), newValue?.widgetPointer)
        }
    }

    /// Presents the popover to the user.
    public func popup() {
        gtk_popover_popup(castedPointer())
    }

    /// Hides the popover.
    public func popdown() {
        gtk_popover_popdown(castedPointer())
    }

    /// Whether the popover has an arrow.
    public var hasArrow: Bool {
        get { gtk_popover_get_has_arrow(castedPointer()) != 0 }
        set { gtk_popover_set_has_arrow(castedPointer(), newValue ? 1 : 0) }
    }

    /// The preferred position of the popover.
    public var position: GtkPositionType {
        get { gtk_popover_get_position(castedPointer()) }
        set { gtk_popover_set_position(castedPointer(), newValue) }
    }

    /// Whether the popover auto-hides on outside clicks.
    public var autohide: Bool {
        get { gtk_popover_get_autohide(castedPointer()) != 0 }
        set { gtk_popover_set_autohide(castedPointer(), newValue ? 1 : 0) }
    }

    /// Whether the popover is a menu-style popover.
    public var mnemonicsVisible: Bool {
        get { gtk_popover_get_mnemonics_visible(castedPointer()) != 0 }
        set { gtk_popover_set_mnemonics_visible(castedPointer(), newValue ? 1 : 0) }
    }

    /// Emitted when the popover is closed.
    ///
    /// - Parameter handler: Called when the popover is closed.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onClosed(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .closed, handler: handler)
    }

    /// Called when the popover visibility changes (shown or hidden).
    @discardableResult
    public func onVisibilityChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.onNotify(self, property: .visible, handler: handler)
    }
}
