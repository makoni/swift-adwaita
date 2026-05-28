// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A list box row with a built-in switch for toggling boolean settings.
///
/// Wraps `AdwSwitchRow`. A convenience subclass of `ActionRow` that embeds a
/// toggle switch, commonly used in GNOME preferences for on/off options.
///
/// ```swift
/// let darkMode = SwitchRow(title: "Dark Mode", active: true)
/// darkMode.subtitle = "Use dark color scheme"
///
/// darkMode.onNotify(property: .active) {
///     print("Dark mode is now: \(darkMode.active)")
/// }
///
/// group.add(darkMode)
/// ```
/// - Since: libadwaita 1.4
@MainActor
public final class SwitchRow: ActionRow {
    override public class var gtkType: GType {
        adw_switch_row_get_type()
    }


    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `SwitchRow` with the switch off.
    override public init() {
        let ptr = adw_switch_row_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a `SwitchRow` with a title.
    public convenience init(title: String) {
        self.init()
        self.title = title
    }

    /// Creates a `SwitchRow` with a title and initial active state.
    public convenience init(title: String, active: Bool) {
        self.init()
        self.title = title
        self.active = active
    }

    /// Whether the switch is on (`true`) or off (`false`).
    /// - Since: libadwaita 1.4
    public var active: Bool {
        get { adw_switch_row_get_active(opaquePointer) != 0 }
        set { adw_switch_row_set_active(opaquePointer, newValue ? 1 : 0) }
    }
}
