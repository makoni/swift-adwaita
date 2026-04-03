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
    ///
    /// - Returns: `true` if the popover was shown, `false` if it is not attached
    ///   to a live widget tree yet.
    @discardableResult
    public func popup() -> Bool {
        guard parent != nil, root != nil else { return false }
        gtk_popover_popup(castedPointer())
        return true
    }

    /// Hides the popover.
    public func popdown() {
        gtk_popover_popdown(castedPointer())
    }

    /// Attaches the popover to a widget and presents it if the widget is already
    /// in a live widget tree.
    ///
    /// - Parameters:
    ///   - parent: The widget the popover should be anchored to.
    ///   - x: Optional x coordinate of the pointing rectangle in the parent's coordinates.
    ///   - y: Optional y coordinate of the pointing rectangle in the parent's coordinates.
    ///   - width: Width of the pointing rectangle.
    ///   - height: Height of the pointing rectangle.
    /// - Returns: `true` if the popover was shown, `false` otherwise.
    @discardableResult
    public func present(
        from parent: Widget,
        x: Int? = nil,
        y: Int? = nil,
        width: Int = 1,
        height: Int = 1
    ) -> Bool {
        if self.parent !== parent {
            if self.parent != nil {
                gtk_widget_unparent(widgetPointer)
            }
            gtk_widget_set_parent(widgetPointer, parent.widgetPointer)
        }
        if let x, let y {
            var rect = GdkRectangle(x: Int32(x), y: Int32(y), width: Int32(width), height: Int32(height))
            gtk_popover_set_pointing_to(castedPointer(), &rect)
        }
        return popup()
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
