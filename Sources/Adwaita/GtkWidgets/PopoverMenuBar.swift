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

    override internal init(raw pointer: UnsafeMutableRawPointer) {
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
}
