// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A single keyboard shortcut entry inside a ``ShortcutsSection``.
///
/// Wraps `AdwShortcutsItem`. Describes one shortcut with a human-readable
/// title, an accelerator string, and optional subtitle and text direction.
/// Can also be created from a named action instead of a raw accelerator.
///
/// ```swift
/// let item = ShortcutsItem(title: "Save", accelerator: "<Control>s")
/// item.subtitle = "Save the current document"
///
/// // Or create from a named action:
/// let actionItem = ShortcutsItem.newFromAction(
///     title: "Quit",
///     actionName: "app.quit"
/// )
///
/// let section = ShortcutsSection(title: "General")
/// section.add(item)
/// section.add(actionItem)
/// ```
///
/// - Since: libadwaita 1.8
@MainActor
public final class ShortcutsItem: GObjectRef {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ShortcutsItem`.
    ///
    /// - Note: Requires libadwaita 1.8+. Returns `nil` on older versions.
    public init?(title: String, accelerator: String) {
        guard AdwaitaVersion.isAtLeast(1, 8) else { return nil }
        let ptr = adw_shortcuts_item_new(title, accelerator)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a new `ShortcutsItem`.
    ///
    /// - Note: Requires libadwaita 1.8+. Returns `nil` on older versions.
    public static func newFromAction(title: String, actionName: String) -> ShortcutsItem? {
        guard AdwaitaVersion.isAtLeast(1, 8) else { return nil }
        let ptr = adw_shortcuts_item_new_from_action(title, actionName)!
        return ShortcutsItem(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The keyboard accelerator string for this shortcut (e.g. "<Control>s").
    /// - Since: libadwaita 1.8
    public var accelerator: String {
        get { String(cString: adw_shortcuts_item_get_accelerator(opaquePointer)) }
        set { adw_shortcuts_item_set_accelerator(opaquePointer, newValue) }
    }

    /// The name of the action this shortcut triggers (e.g. "app.quit").
    /// - Since: libadwaita 1.8
    public var actionName: String {
        get { String(cString: adw_shortcuts_item_get_action_name(opaquePointer)) }
        set { adw_shortcuts_item_set_action_name(opaquePointer, newValue) }
    }

    /// The text direction used when displaying this shortcut.
    /// - Since: libadwaita 1.8
    public var direction: GtkTextDirection {
        get { adw_shortcuts_item_get_direction(opaquePointer) }
        set { adw_shortcuts_item_set_direction(opaquePointer, newValue) }
    }

    /// A secondary description shown below the title.
    /// - Since: libadwaita 1.8
    public var subtitle: String {
        get { String(cString: adw_shortcuts_item_get_subtitle(opaquePointer)) }
        set { adw_shortcuts_item_set_subtitle(opaquePointer, newValue) }
    }

    /// The human-readable title describing this shortcut.
    /// - Since: libadwaita 1.8
    public var title: String {
        get { String(cString: adw_shortcuts_item_get_title(opaquePointer)) }
        set { adw_shortcuts_item_set_title(opaquePointer, newValue) }
    }
}
