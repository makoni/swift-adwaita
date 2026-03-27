// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A titled group of shortcut items displayed inside a ``ShortcutsDialog``.
///
/// Wraps `AdwShortcutsSection`. Each section has a title and contains
/// one or more ``ShortcutsItem`` entries. Use multiple sections to
/// organise shortcuts by category (e.g. "Editing", "Navigation").
///
/// ```swift
/// let section = ShortcutsSection(title: "Editing")
/// section.add(ShortcutsItem(title: "Cut", accelerator: "<Control>x"))
/// section.add(ShortcutsItem(title: "Copy", accelerator: "<Control>c"))
/// section.add(ShortcutsItem(title: "Paste", accelerator: "<Control>v"))
///
/// let dialog = ShortcutsDialog()
/// dialog.add(section)
/// ```
///
/// - Since: libadwaita 1.8
@MainActor
public final class ShortcutsSection: GObjectRef {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ShortcutsSection`.
    ///
    /// - Note: Requires libadwaita 1.8+. Returns `nil` on older versions.
    public init?(title: String?) {
        guard AdwaitaVersion.isAtLeast(1, 8) else { return nil }
        let ptr = adw_shortcuts_section_new(title)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The heading displayed above this section's shortcut items.
    /// - Since: libadwaita 1.8
    public var title: String? {
        get { (adw_shortcuts_section_get_title(opaquePointer)).map { String(cString: $0) } }
        set { adw_shortcuts_section_set_title(opaquePointer, newValue) }
    }

    /// Adds an item (transfer-full: adds a ref before passing).
    public func add(_ item: ShortcutsItem) {
        g_object_ref(item.pointer)
        adw_shortcuts_section_add(opaquePointer, item.opaquePointer)
    }
}
