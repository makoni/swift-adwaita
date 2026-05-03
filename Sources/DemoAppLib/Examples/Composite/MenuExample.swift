// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct MenuExample: DemoExample {
    let name = "Menu & Actions"
    let id = "menu"
    let category: ExampleCategory = .composite

    let sourceCode = """
    // Create actions
    let copyAction = SimpleAction(name: "copy")
    copyAction.onActivate { print("Copy!") }

    let pasteAction = SimpleAction(name: "paste")
    pasteAction.onActivate { print("Paste!") }

    // Add to window action map
    window.addAction(copyAction)
    window.addAction(pasteAction)

    // Build menu model
    let menu = GMenuRef()
    menu.append("Copy", action: "win.copy")
    menu.append("Paste", action: "win.paste")

    // Menu button with hamburger icon
    let menuBtn = MenuButton()
    menuBtn.iconName = "open-menu-symbolic"
    menuBtn.setMenuModel(menu)
    headerBar.packEnd(menuBtn)
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let logLabel = Label("Click a menu item...")
        logLabel.addCSSClass("monospace")
        logLabel.wrap = true
        logLabel.xalign = 0
        logLabel.setMargins(16)

        // Basic menu
        let group1 = PreferencesGroup()
        group1.title = "Basic Menu"
        group1.description = "A MenuButton with GMenuModel and SimpleAction"

        let menu = GMenuRef()

        let editSection = GMenuRef()
        editSection.append("Cut", action: "demo.cut")
        editSection.append("Copy", action: "demo.copy")
        editSection.append("Paste", action: "demo.paste")
        menu.appendSection("Edit", section: editSection)

        let fileSection = GMenuRef()
        fileSection.append("New", action: "demo.new")
        fileSection.append("Open...", action: "demo.open")
        fileSection.append("Save", action: "demo.save")
        menu.appendSection("File", section: fileSection)

        let menuBtn = MenuButton()
        menuBtn.iconName = "open-menu-symbolic"
        menuBtn.setMenuModel(menu)
        menuBtn.halign = .center

        // Create actions using a simple pattern
        let actionGroup = SimpleActionGroup()

        let actions = ["cut", "copy", "paste", "new", "open", "save"]
        for name in actions {
            let action = SimpleAction(name: name)
            let actionName = name
            action.onActivate { [logLabel] in
                logLabel.text = "\(actionName) activated!"
            }
            actionGroup.addAction(action)
        }

        // Attach action group to the menu button
        menuBtn.insertActionGroup("demo", actionGroup)

        group1.add(menuBtn)

        let logFrame = Frame()
        logFrame.child = logLabel
        group1.add(logFrame)

        box.append(group1)

        // Menu with icons
        let group2 = PreferencesGroup()
        group2.title = "Menu with Icons"
        group2.description = "Use GMenuItemRef to add icons to menu items"

        let iconMenu = GMenuRef()

        let item1 = GMenuItemRef(label: "Preferences", action: "demo2.prefs")
        item1.setIconName("preferences-other-symbolic")
        iconMenu.appendItem(item1)

        let item2 = GMenuItemRef(label: "About", action: "demo2.about")
        item2.setIconName("help-about-symbolic")
        iconMenu.appendItem(item2)

        let item3 = GMenuItemRef(label: "Quit", action: "demo2.quit")
        item3.setIconName("application-exit-symbolic")
        iconMenu.appendItem(item3)

        let iconMenuBtn = MenuButton()
        iconMenuBtn.label = "Menu with Icons"
        iconMenuBtn.setMenuModel(iconMenu)
        iconMenuBtn.halign = .center

        let actionGroup2 = SimpleActionGroup()
        for name in ["prefs", "about", "quit"] {
            let action = SimpleAction(name: name)
            let actionName = name
            action.onActivate { [logLabel] in
                logLabel.text = "\(actionName) (with icon) activated!"
            }
            actionGroup2.addAction(action)
        }
        iconMenuBtn.insertActionGroup("demo2", actionGroup2)

        group2.add(iconMenuBtn)
        box.append(group2)

        // Submenu
        let group3 = PreferencesGroup()
        group3.title = "Submenu"
        group3.description = "Nested menu structure"

        let mainMenu = GMenuRef()
        mainMenu.append("Action 1", action: "sub.action1")

        let sub = GMenuRef()
        sub.append("Sub Item A", action: "sub.a")
        sub.append("Sub Item B", action: "sub.b")
        mainMenu.appendSubmenu("More Options", submenu: sub)

        let subMenuBtn = MenuButton()
        subMenuBtn.label = "Submenu Demo"
        subMenuBtn.setMenuModel(mainMenu)
        subMenuBtn.halign = .center

        let actionGroup3 = SimpleActionGroup()
        for name in ["action1", "a", "b"] {
            let action = SimpleAction(name: name)
            let actionName = name
            action.onActivate { [logLabel] in
                logLabel.text = "submenu: \(actionName) activated!"
            }
            actionGroup3.addAction(action)
        }
        subMenuBtn.insertActionGroup("sub", actionGroup3)

        group3.add(subMenuBtn)
        box.append(group3)

        return box.scrollableClamped()
    }
}
