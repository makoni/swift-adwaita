import CAdwaita
import GObjectSupport

/// A menu bar built from a `GMenuModel`.
///
/// Wraps `GtkPopoverMenuBar`. Creates a traditional desktop menu bar
/// from a `GMenuRef` model.
@MainActor
public final class PopoverMenuBar: Widget {
    /// Creates a new menu bar from a menu model.
    public init(model: GMenuRef) {
        let ptr = gtk_popover_menu_bar_new_from_model(model.menuModelPointer)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The menu model.
    public var menuModel: GMenuRef? {
        get {
            guard let ptr = gtk_popover_menu_bar_get_menu_model(opaquePointer) else { return nil }
            return GMenuRef(raw: UnsafeMutableRawPointer(ptr))
        }
        set {
            gtk_popover_menu_bar_set_menu_model(opaquePointer, newValue?.menuModelPointer)
        }
    }

    /// Adds a custom widget to the menu bar, replacing the menu item
    /// with the given `id` from the model.
    ///
    /// - Parameters:
    ///   - child: The widget to insert.
    ///   - id: The ID of the menu item to replace.
    /// - Returns: `true` if the widget was added.
    @discardableResult
    public func addChild(_ child: Widget, id: String) -> Bool {
        gtk_popover_menu_bar_add_child(opaquePointer, child.widgetPointer, id) != 0
    }

    /// Removes a custom widget previously added with ``addChild(_:id:)``.
    ///
    /// - Parameter child: The widget to remove.
    /// - Returns: `true` if the widget was removed.
    @discardableResult
    public func removeChild(_ child: Widget) -> Bool {
        gtk_popover_menu_bar_remove_child(opaquePointer, child.widgetPointer) != 0
    }
}
