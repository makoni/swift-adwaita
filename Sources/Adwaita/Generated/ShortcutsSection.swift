// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// An object representing a section in [class@ShortcutsDialog].
/// - Since: libadwaita 1.8
@MainActor
public final class ShortcutsSection: GObjectRef {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ShortcutsSection`.
    public init(title: String?) {
        let ptr = adw_shortcuts_section_new(title)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `title` property.
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
