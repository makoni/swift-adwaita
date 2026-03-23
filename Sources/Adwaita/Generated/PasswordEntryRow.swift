// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A [class@EntryRow] tailored for entering secrets.
/// - Since: libadwaita 1.2
@MainActor
public final class PasswordEntryRow: EntryRow {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `PasswordEntryRow`.
    override public init() {
        let ptr = adw_password_entry_row_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }
}
