// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A helper widget that displays an icon and a label inside a button.
///
/// Wraps `AdwButtonContent`. Provides a standard layout for buttons that
/// combine an icon and a text label, following GNOME HIG guidelines. Set it
/// as the child of a `GtkButton` to get a properly styled icon-and-label button.
///
/// ```swift
/// let content = ButtonContent()
/// content.iconName = "document-save-symbolic"
/// content.label = "Save"
///
/// let button = Button()
/// button.child = content
/// button.onClicked {
///     print("Save clicked")
/// }
/// ```
///
/// - Key properties:
///   - ``iconName``: The symbolic icon name displayed beside the label.
///   - ``label``: The text label displayed in the button.
///   - ``useUnderline``: Whether an underscore in the label marks a mnemonic.
///   - ``canShrink``: Whether the button can shrink below its natural size (since libadwaita 1.4).
@MainActor
public final class ButtonContent: Widget {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ButtonContent`.
    public init() {
        let ptr = adw_button_content_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Whether the button content can be narrower than its natural size.
    /// - Since: libadwaita 1.4
    public var canShrink: Bool {
        get { adw_button_content_get_can_shrink(opaquePointer) != 0 }
        set { adw_button_content_set_can_shrink(opaquePointer, newValue ? 1 : 0) }
    }

    /// The symbolic icon name displayed beside the label.
    public var iconName: String {
        get { String(cString: adw_button_content_get_icon_name(opaquePointer)) }
        set { adw_button_content_set_icon_name(opaquePointer, newValue) }
    }

    /// The text label displayed in the button.
    public var label: String {
        get { String(cString: adw_button_content_get_label(opaquePointer)) }
        set { adw_button_content_set_label(opaquePointer, newValue) }
    }

    /// Whether an underscore in the label indicates a keyboard mnemonic.
    public var useUnderline: Bool {
        get { adw_button_content_get_use_underline(opaquePointer) != 0 }
        set { adw_button_content_set_use_underline(opaquePointer, newValue ? 1 : 0) }
    }
}
