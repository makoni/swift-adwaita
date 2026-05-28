// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A [class@EntryRow] tailored for entering secrets.
/// - Since: libadwaita 1.2
@MainActor
public final class PasswordEntryRow: EntryRow {
    override public class var gtkType: GType {
        adw_password_entry_row_get_type()
    }

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `PasswordEntryRow`.
    override public init() {
        let ptr = adw_password_entry_row_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a `PasswordEntryRow` with a title.
    public convenience init(title: String) {
        self.init()
        self.title = title
    }
}
