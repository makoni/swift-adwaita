// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// An object representing an individual shortcut in [class@ShortcutsSection].
/// - Since: libadwaita 1.8
@MainActor
public final class ShortcutsItem: GObjectRef {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ShortcutsItem`.
    public init(title: String, accelerator: String) {
        let ptr = adw_shortcuts_item_new(title, accelerator)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a new `ShortcutsItem`.
    public static func newFromAction(title: String, actionName: String) -> ShortcutsItem {
        let ptr = adw_shortcuts_item_new_from_action(title, actionName)!
        return ShortcutsItem(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `accelerator` property.
    /// - Since: libadwaita 1.8
    public var accelerator: String {
        get { String(cString: adw_shortcuts_item_get_accelerator(opaquePointer)) }
        set { adw_shortcuts_item_set_accelerator(opaquePointer, newValue) }
    }

    /// The `action-name` property.
    /// - Since: libadwaita 1.8
    public var actionName: String {
        get { String(cString: adw_shortcuts_item_get_action_name(opaquePointer)) }
        set { adw_shortcuts_item_set_action_name(opaquePointer, newValue) }
    }

    /// The `direction` property.
    /// - Since: libadwaita 1.8
    public var direction: GtkTextDirection {
        get { adw_shortcuts_item_get_direction(opaquePointer) }
        set { adw_shortcuts_item_set_direction(opaquePointer, newValue) }
    }

    /// The `subtitle` property.
    /// - Since: libadwaita 1.8
    public var subtitle: String {
        get { String(cString: adw_shortcuts_item_get_subtitle(opaquePointer)) }
        set { adw_shortcuts_item_set_subtitle(opaquePointer, newValue) }
    }

    /// The `title` property.
    /// - Since: libadwaita 1.8
    public var title: String {
        get { String(cString: adw_shortcuts_item_get_title(opaquePointer)) }
        set { adw_shortcuts_item_set_title(opaquePointer, newValue) }
    }
}
