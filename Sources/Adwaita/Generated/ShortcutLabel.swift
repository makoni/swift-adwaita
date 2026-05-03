// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A widget that renders a keyboard shortcut as styled key caps.
///
/// Wraps `AdwShortcutLabel`. Parses an accelerator string such as
/// `"<Control>s"` and displays it as a human-readable key combination
/// with graphical key cap styling.
///
/// ```swift
/// let label = ShortcutLabel(accelerator: "<Control>s")
/// label.disabledText = "Disabled"
///
/// box.append(label)
/// ```
///
/// - Since: libadwaita 1.8
@MainActor
public final class ShortcutLabel: Widget {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ShortcutLabel`.
    ///
    /// - Note: Requires libadwaita 1.8+. Returns `nil` on older versions.
    public init?(accelerator: String) {
        guard AdwaitaVersion.isAtLeast(1, 8) else { return nil }
        let ptr = adw_shortcut_label_new(accelerator)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The keyboard accelerator string (e.g. `"<Control>s"`) rendered as styled key caps.
    /// - Since: libadwaita 1.8
    public var accelerator: String {
        get { String(cString: adw_shortcut_label_get_accelerator(opaquePointer)) }
        set { adw_shortcut_label_set_accelerator(opaquePointer, newValue) }
    }

    /// The text displayed when the shortcut is disabled or no accelerator is set.
    /// - Since: libadwaita 1.8
    public var disabledText: String {
        get { String(cString: adw_shortcut_label_get_disabled_text(opaquePointer)) }
        set { adw_shortcut_label_set_disabled_text(opaquePointer, newValue) }
    }
}
