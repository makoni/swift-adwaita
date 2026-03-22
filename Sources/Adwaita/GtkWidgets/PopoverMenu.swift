import CAdwaita
import GObjectSupport

/// A popover that displays a menu from a `GMenuModel`.
///
/// Wraps `GtkPopoverMenu`.
@MainActor
public final class PopoverMenu: Widget {
    /// Creates a new popover menu from a menu model.
    public init(model: UnsafeMutablePointer<GMenuModel>?) {
        let ptr = gtk_popover_menu_new_from_model(model)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The menu model used to create the popover content.
    public var menuModel: UnsafeMutablePointer<GMenuModel>? {
        get { gtk_popover_menu_get_menu_model(opaquePointer) }
        set { gtk_popover_menu_set_menu_model(opaquePointer, newValue) }
    }

    /// Presents the popover menu.
    public func popup() {
        gtk_popover_popup(castedPointer() as UnsafeMutablePointer<GtkPopover>)
    }

    /// Hides the popover menu.
    public func popdown() {
        gtk_popover_popdown(castedPointer() as UnsafeMutablePointer<GtkPopover>)
    }
}
