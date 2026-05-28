// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A dialog that displays the application's keyboard shortcuts grouped by section.
///
/// Wraps `AdwShortcutsDialog`. Present this dialog to show users a
/// categorised overview of all available keyboard shortcuts. Populate
/// it with ``ShortcutsSection`` objects, each containing one or more
/// ``ShortcutsItem`` entries.
///
/// ```swift
/// let item = ShortcutsItem(title: "Save", accelerator: "<Control>s")
///
/// let section = ShortcutsSection(title: "General")
/// section.add(item)
///
/// let dialog = ShortcutsDialog()
/// dialog.add(section)
/// dialog.present(window)
/// ```
///
/// - Since: libadwaita 1.8
@MainActor
public final class ShortcutsDialog: Dialog {
    override public class var gtkType: GType {
        // adw_shortcuts_dialog_get_type() is a libadwaita 1.6+ symbol absent from the baseline (1.5)
        // headers, so resolve the type by name at runtime instead of linking
        // the symbol. Returns G_TYPE_INVALID (0) on older runtimes / before the
        // first instance registers the type — fine, since a tryCast/isInstance
        // only matters once an instance of this 1.6+ widget actually exists.
        g_type_from_name("AdwShortcutsDialog")
    }

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ShortcutsDialog`.
    ///
    /// - Note: Requires libadwaita 1.8+. Use ``isAvailable`` to check at runtime.
    override public init() {
        let ptr = if let p = adw_shortcuts_dialog_new() {
            UnsafeMutableRawPointer(p)
        } else {
            UnsafeMutableRawPointer(adw_dialog_new()!)
        }
        super.init(raw: ptr)
    }

    /// Whether `ShortcutsDialog` is available on the running libadwaita version (1.8+).
    public static var isAvailable: Bool {
        AdwaitaVersion.isAtLeast(1, 8)
    }

    /// Adds a section (transfer-full: adds a ref before passing).
    public func add(_ section: ShortcutsSection) {
        g_object_ref(section.pointer)
        adw_shortcuts_dialog_add(opaquePointer, section.opaquePointer)
    }
}
