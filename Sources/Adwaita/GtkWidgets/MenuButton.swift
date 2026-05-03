// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

/// A button that shows a popover or menu when clicked.
///
/// Wraps `GtkMenuButton`. Can display a `Popover`, `PopoverMenu`, or a
/// `GMenuRef` model. Commonly used for hamburger menus and dropdown actions.
///
/// ```swift
/// // Hamburger-style primary menu
/// let menu = GMenuRef()
/// menu.append(label: "About", action: "app.about")
/// menu.append(label: "Quit", action: "app.quit")
///
/// let menuButton = MenuButton()
/// menuButton.primary = true
/// menuButton.iconName = "open-menu-symbolic"
/// menuButton.setMenuModel(menu)
///
/// // Or with a custom popover
/// let popover = Popover()
/// popover.child = Label("Custom content")
/// let button = MenuButton(label: "Options")
/// button.setPopover(popover)
/// ```
@MainActor
public final class MenuButton: Widget {
    /// Creates a new menu button.
    public init() {
        let ptr = gtk_menu_button_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a menu button with a text label.
    public convenience init(label: String) {
        self.init()
        self.label = label
    }

    /// Creates a menu button with an icon.
    public convenience init(icon: IconName) {
        self.init()
        iconName = icon.name
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The label text.
    public var label: String? {
        get {
            guard let cStr = gtk_menu_button_get_label(opaquePointer) else { return nil }
            return String(cString: cStr)
        }
        set { gtk_menu_button_set_label(opaquePointer, newValue) }
    }

    /// The icon name.
    public var iconName: String? {
        get {
            guard let cStr = gtk_menu_button_get_icon_name(opaquePointer) else { return nil }
            return String(cString: cStr)
        }
        set { gtk_menu_button_set_icon_name(opaquePointer, newValue) }
    }

    /// The popover widget.
    public var popover: Widget? {
        get {
            guard let ptr = gtk_menu_button_get_popover(opaquePointer) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set { gtk_menu_button_set_popover(opaquePointer, newValue?.widgetPointer) }
    }

    /// Sets the popover widget.
    public func setPopover(_ popover: Widget?) {
        gtk_menu_button_set_popover(opaquePointer, popover?.widgetPointer)
    }

    /// Whether the button has a frame.
    public var hasFrame: Bool {
        get { gtk_menu_button_get_has_frame(opaquePointer) != 0 }
        set { gtk_menu_button_set_has_frame(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the menu button is a primary menu (hamburger icon).
    public var primary: Bool {
        get { gtk_menu_button_get_primary(opaquePointer) != 0 }
        set { gtk_menu_button_set_primary(opaquePointer, newValue ? 1 : 0) }
    }

    /// The arrow direction.
    public var direction: GtkArrowType {
        get { gtk_menu_button_get_direction(opaquePointer) }
        set { gtk_menu_button_set_direction(opaquePointer, newValue) }
    }

    /// Sets a GMenuModel as the menu for this button.
    public func setMenuModel(_ menu: GMenuRef) {
        gtk_menu_button_set_menu_model(opaquePointer, menu.menuModelPointer)
    }
}
