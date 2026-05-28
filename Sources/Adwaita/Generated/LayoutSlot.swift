// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A named placeholder in a ``Layout`` that receives a child widget at runtime.
///
/// Wraps `AdwLayoutSlot`. Each slot has a string identifier. When a
/// ``MultiLayoutView`` switches layouts, it maps previously assigned
/// children to the matching slot IDs in the new layout.
///
/// - Note: Requires libadwaita 1.6+. The initializer returns `nil` at runtime
///   if the installed version is too old.
///
/// - Since: libadwaita 1.6
@MainActor
public final class LayoutSlot: Widget {
    override public class var gtkType: GType {
        // adw_layout_slot_get_type() is a libadwaita 1.6+ symbol absent from the baseline (1.5)
        // headers, so resolve the type by name at runtime instead of linking
        // the symbol. Returns G_TYPE_INVALID (0) on older runtimes / before the
        // first instance registers the type — fine, since a tryCast/isInstance
        // only matters once an instance of this 1.6+ widget actually exists.
        g_type_from_name("AdwLayoutSlot")
    }

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `LayoutSlot`. Returns `nil` if libadwaita < 1.6.
    public init?(id: String) {
        guard AdwaitaVersion.isAtLeast(1, 6) else { return nil }
        let ptr = cadw_layout_slot_new(id)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `id` property (read-only).
    /// - Since: libadwaita 1.6
    public var id: String {
        String(cString: cadw_layout_slot_get_slot_id(pointer))
    }
}
