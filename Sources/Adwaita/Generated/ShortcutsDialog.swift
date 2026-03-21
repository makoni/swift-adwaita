// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A dialog that displays application's keyboard shortcuts.
/// - Since: libadwaita 1.8
@MainActor
public final class ShortcutsDialog: Dialog {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ShortcutsDialog`.
    override public init() {
        let ptr = adw_shortcuts_dialog_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Adds a section (transfer-full: adds a ref before passing).
    public func add(_ section: ShortcutsSection) {
        g_object_ref(section.pointer)
        adw_shortcuts_dialog_add(opaquePointer, section.opaquePointer)
    }
}
