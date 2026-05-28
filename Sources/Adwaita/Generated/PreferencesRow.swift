// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// The base row type for building preference/settings list UIs.
///
/// Wraps `AdwPreferencesRow`. Extends ``ListBoxRow`` with a ``title`` and
/// optional markup and mnemonic support. Subclassed by ``ActionRow``,
/// ``ComboRow``, ``EntryRow``, ``SwitchRow``, ``SpinRow``, ``ExpanderRow``,
/// and others for specialized preference controls.
///
/// ```swift
/// let row = PreferencesRow()
/// row.title = "Language"
/// row.useMarkup = false
///
/// listBox.append(row)
/// ```
///
/// - Key properties:
///   - ``title``: The row's title text.
///   - ``titleSelectable``: Whether the title can be selected/copied (since libadwaita 1.1).
///   - ``useMarkup``: Whether Pango markup is interpreted in the title (since libadwaita 1.2).
///   - ``useUnderline``: Whether an underscore in the title marks a mnemonic.
@MainActor
public class PreferencesRow: ListBoxRow {
    override public class var gtkType: GType {
        adw_preferences_row_get_type()
    }

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `PreferencesRow`.
    override public init() {
        let ptr = adw_preferences_row_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The title text displayed in the row.
    public var title: String {
        get {
            String(cString: adw_preferences_row_get_title(castedPointer() as UnsafeMutablePointer<AdwPreferencesRow>))
        }
        set { adw_preferences_row_set_title(castedPointer() as UnsafeMutablePointer<AdwPreferencesRow>, newValue) }
    }

    /// Whether the title text can be selected and copied by the user.
    /// - Since: libadwaita 1.1
    public var titleSelectable: Bool {
        get { adw_preferences_row_get_title_selectable(castedPointer() as UnsafeMutablePointer<AdwPreferencesRow>) != 0
        }
        set { adw_preferences_row_set_title_selectable(
            castedPointer() as UnsafeMutablePointer<AdwPreferencesRow>,
            newValue ? 1 : 0
        ) }
    }

    /// Whether Pango markup is interpreted in the title text.
    /// - Since: libadwaita 1.2
    public var useMarkup: Bool {
        get { adw_preferences_row_get_use_markup(castedPointer() as UnsafeMutablePointer<AdwPreferencesRow>) != 0 }
        set { adw_preferences_row_set_use_markup(
            castedPointer() as UnsafeMutablePointer<AdwPreferencesRow>,
            newValue ? 1 : 0
        ) }
    }

    /// Whether an underscore in the title marks a mnemonic accelerator.
    public var useUnderline: Bool {
        get { adw_preferences_row_get_use_underline(castedPointer() as UnsafeMutablePointer<AdwPreferencesRow>) != 0 }
        set { adw_preferences_row_set_use_underline(
            castedPointer() as UnsafeMutablePointer<AdwPreferencesRow>,
            newValue ? 1 : 0
        ) }
    }
}
