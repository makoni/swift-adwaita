import CAdwaita
import GObjectSupport

/// A popover that displays a menu from a `GMenuModel`.
///
/// Wraps `GtkPopoverMenu`. Creates a popup menu from a `GMenuRef` model
/// and presents it as a popover anchored to its parent widget.
///
/// ```swift
/// let menu = GMenuRef()
/// menu.append(label: "Cut", action: "app.cut")
/// menu.append(label: "Copy", action: "app.copy")
/// menu.append(label: "Paste", action: "app.paste")
///
/// let popoverMenu = PopoverMenu(model: menu)
///
/// let button = MenuButton(label: "Edit")
/// button.setPopover(popoverMenu)
/// ```
@MainActor
public final class PopoverMenu: Widget {
    /// Creates a new popover menu from a menu model.
    public init(model: GMenuRef) {
        let ptr = gtk_popover_menu_new_from_model(model.menuModelPointer)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The menu model.
    public var menuModel: GMenuRef? {
        get {
            guard let ptr = gtk_popover_menu_get_menu_model(opaquePointer) else { return nil }
            return GMenuRef(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set { gtk_popover_menu_set_menu_model(opaquePointer, newValue?.menuModelPointer) }
    }

    /// Presents the popover menu.
    ///
    /// - Returns: `true` if the popover was shown, `false` if it is not attached
    ///   to a live widget tree yet.
    @discardableResult
    public func popup() -> Bool {
        guard parent != nil, root != nil else { return false }
        gtk_popover_popup(castedPointer() as UnsafeMutablePointer<GtkPopover>)
        return true
    }

    /// Hides the popover menu.
    public func popdown() {
        gtk_popover_popdown(castedPointer() as UnsafeMutablePointer<GtkPopover>)
    }

    /// Whether the popover menu has an arrow.
    public var hasArrow: Bool {
        get { gtk_popover_get_has_arrow(castedPointer() as UnsafeMutablePointer<GtkPopover>) != 0 }
        set { gtk_popover_set_has_arrow(castedPointer() as UnsafeMutablePointer<GtkPopover>, newValue ? 1 : 0) }
    }

    /// Preferred popup position for the popover menu.
    public var position: GtkPositionType {
        get { gtk_popover_get_position(castedPointer() as UnsafeMutablePointer<GtkPopover>) }
        set { gtk_popover_set_position(castedPointer() as UnsafeMutablePointer<GtkPopover>, newValue) }
    }

    /// Sets the widget this popover menu points to.
    public func setParent(_ parent: Widget) {
        gtk_widget_set_parent(widgetPointer, parent.widgetPointer)
    }

    /// Removes this popover menu from its parent widget.
    public func unparent() {
        gtk_widget_unparent(widgetPointer)
    }

    /// Sets the pointing rectangle used to anchor the popover menu.
    public func setPointingTo(x: Int, y: Int, width: Int = 1, height: Int = 1) {
        var rect = GdkRectangle(x: Int32(x), y: Int32(y), width: Int32(width), height: Int32(height))
        gtk_popover_set_pointing_to(castedPointer() as UnsafeMutablePointer<GtkPopover>, &rect)
    }

    /// Attaches the popover menu to a widget and presents it if the widget is
    /// already in a live widget tree.
    ///
    /// - Parameters:
    ///   - parent: The widget the popover menu should be anchored to.
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
            setPointingTo(x: x, y: y, width: width, height: height)
        }
        return popup()
    }

    /// Emitted when the popover menu is closed.
    @discardableResult
    public func onClosed(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .closed, handler: handler)
    }
}
