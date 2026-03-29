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
    public func popup() {
        gtk_popover_popup(castedPointer() as UnsafeMutablePointer<GtkPopover>)
    }

    /// Hides the popover menu.
    public func popdown() {
        gtk_popover_popdown(castedPointer() as UnsafeMutablePointer<GtkPopover>)
    }
}
