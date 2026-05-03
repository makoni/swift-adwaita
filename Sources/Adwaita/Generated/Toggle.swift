// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A single toggle item used within a ``ToggleGroup``.
///
/// Wraps `AdwToggle`. Represents one selectable option inside a
/// ``ToggleGroup``. Each toggle can display a label, an icon, or a custom
/// child widget, and can be identified by name or index.
///
/// ```swift
/// let toggle = Toggle()
/// toggle.label = "List"
/// toggle.name = "list-view"
/// toggle.iconName = "view-list-symbolic"
///
/// let group = ToggleGroup()
/// group.add(toggle)
/// ```
///
/// - Key properties:
///   - ``label``: The text label displayed on the toggle.
///   - ``iconName``: A symbolic icon displayed on the toggle.
///   - ``name``: A unique string identifier for this toggle.
///   - ``enabled``: Whether the toggle can be activated.
///   - ``child``: A custom child widget replacing the default label/icon.
/// - Key methods:
///   - ``getIndex()``: Returns the position of this toggle within its group.
/// - Since: libadwaita 1.7
@MainActor
public final class Toggle: GObjectRef {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `Toggle`.
    ///
    /// - Note: Requires libadwaita 1.7+. Returns `nil` on older versions.
    public init?() {
        guard AdwaitaVersion.isAtLeast(1, 7) else { return nil }
        let ptr = adw_toggle_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// A custom child widget displayed inside the toggle, replacing the default label and icon.
    /// - Since: libadwaita 1.7
    public var child: Widget? {
        get { adw_toggle_get_child(opaquePointer).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_toggle_set_child(opaquePointer, newValue?.widgetPointer) }
    }

    /// Whether this toggle can be activated by the user. Disabled toggles appear grayed out.
    /// - Since: libadwaita 1.7
    public var enabled: Bool {
        get { adw_toggle_get_enabled(opaquePointer) != 0 }
        set { adw_toggle_set_enabled(opaquePointer, newValue ? 1 : 0) }
    }

    /// The name of a symbolic icon to display on the toggle (e.g. `"view-list-symbolic"`).
    /// - Since: libadwaita 1.7
    public var iconName: String? {
        get { adw_toggle_get_icon_name(opaquePointer).map { String(cString: $0) } }
        set { adw_toggle_set_icon_name(opaquePointer, newValue) }
    }

    /// The text label displayed on the toggle button.
    /// - Since: libadwaita 1.7
    public var label: String? {
        get { adw_toggle_get_label(opaquePointer).map { String(cString: $0) } }
        set { adw_toggle_set_label(opaquePointer, newValue) }
    }

    /// A unique string identifier for this toggle, used for lookup within a ``ToggleGroup``.
    /// - Since: libadwaita 1.7
    public var name: String {
        get { String(cString: adw_toggle_get_name(opaquePointer)) }
        set { adw_toggle_set_name(opaquePointer, newValue) }
    }

    /// The tooltip text shown when the user hovers over the toggle.
    /// - Since: libadwaita 1.7
    public var tooltip: String {
        get { String(cString: adw_toggle_get_tooltip(opaquePointer)) }
        set { adw_toggle_set_tooltip(opaquePointer, newValue) }
    }

    /// Whether an underscore in the label indicates a mnemonic keyboard accelerator.
    /// - Since: libadwaita 1.7
    public var useUnderline: Bool {
        get { adw_toggle_get_use_underline(opaquePointer) != 0 }
        set { adw_toggle_set_use_underline(opaquePointer, newValue ? 1 : 0) }
    }

    /// Returns the position of this toggle within its parent ``ToggleGroup``.
    ///
    /// - Returns: The zero-based index, or `-1` if the toggle is not in a group.
    @discardableResult
    public func getIndex() -> Int {
        Int(adw_toggle_get_index(opaquePointer))
    }
}
