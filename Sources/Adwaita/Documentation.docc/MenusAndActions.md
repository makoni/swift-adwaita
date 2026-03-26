# Menus and Actions

Build menu bars, popover menus, and action-driven UIs.

## Overview

GNOME applications use the GAction framework for menu items and keyboard
shortcuts. swift-adwaita provides ``GMenuRef`` for building menu models,
``SimpleAction`` for handling activations, and widgets like ``PopoverMenu``,
``PopoverMenuBar``, and ``MenuButton`` for presenting menus.

### Building a menu model

``GMenuRef`` represents a menu structure. Add items with action strings,
and organize them into submenus and sections.

```swift
let menu = GMenuRef()
menu.append("New Document", action: "app.new")
menu.append("Open...", action: "app.open")
menu.append("Save", action: "app.save")
menu.append("Quit", action: "app.quit")
```

### Submenus and sections

Use `appendSubmenu(_:submenu:)` for nested menus and `appendSection(_:section:)`
for visual grouping within a menu:

```swift
let fileMenu = GMenuRef()
fileMenu.append("New", action: "app.new")
fileMenu.append("Open", action: "app.open")
fileMenu.append("Save", action: "app.save")

let editMenu = GMenuRef()
editMenu.append("Cut", action: "app.cut")
editMenu.append("Copy", action: "app.copy")
editMenu.append("Paste", action: "app.paste")

let menuBar = GMenuRef()
menuBar.appendSubmenu("File", submenu: fileMenu)
menuBar.appendSubmenu("Edit", submenu: editMenu)
```

Sections create visual separators within a single menu:

```swift
let topSection = GMenuRef()
topSection.append("Preferences", action: "app.prefs")
topSection.append("Keyboard Shortcuts", action: "app.shortcuts")

let bottomSection = GMenuRef()
bottomSection.append("About", action: "app.about")
bottomSection.append("Quit", action: "app.quit")

let mainMenu = GMenuRef()
mainMenu.appendSection(nil, section: topSection)
mainMenu.appendSection(nil, section: bottomSection)
```

### Creating actions

``SimpleAction`` handles menu item activations. Group actions with
``SimpleActionGroup`` and attach them to a widget.

```swift
let actionGroup = SimpleActionGroup()

let newAction = SimpleAction(name: "new")
newAction.onActivate {
    print("New document!")
}
actionGroup.addAction(newAction)

let saveAction = SimpleAction(name: "save")
saveAction.onActivate {
    print("Saving...")
}
actionGroup.addAction(saveAction)

// Attach to a widget — actions become available as "win.new", "win.save"
window.insertActionGroup("win", actionGroup)
```

The action prefix (e.g., `"win"`) in `insertActionGroup` must match the
prefix used in menu item action strings (e.g., `"win.new"`).

### Menu button with popover

``MenuButton`` shows a popover menu when clicked. This is the standard
pattern for application menus in GNOME:

```swift
let menu = GMenuRef()
menu.append("Preferences", action: "app.prefs")
menu.append("About", action: "app.about")

let menuButton = MenuButton()
menuButton.iconName = "open-menu-symbolic"
menuButton.menuModel = menu
menuButton.addCSSClass("flat")

let headerBar = HeaderBar()
headerBar.packEnd(menuButton)
```

### Full menu bar

``PopoverMenuBar`` creates a traditional menu bar for complex apps:

```swift
let fileMenu = GMenuRef()
fileMenu.append("New", action: "bar.new")
fileMenu.append("Open...", action: "bar.open")
fileMenu.append("Save", action: "bar.save")
fileMenu.append("Quit", action: "bar.quit")

let editMenu = GMenuRef()
editMenu.append("Cut", action: "bar.cut")
editMenu.append("Copy", action: "bar.copy")
editMenu.append("Paste", action: "bar.paste")

let viewMenu = GMenuRef()
viewMenu.append("Zoom In", action: "bar.zoomin")
viewMenu.append("Zoom Out", action: "bar.zoomout")

let menuModel = GMenuRef()
menuModel.appendSubmenu("File", submenu: fileMenu)
menuModel.appendSubmenu("Edit", submenu: editMenu)
menuModel.appendSubmenu("View", submenu: viewMenu)

let menuBar = PopoverMenuBar(model: menuModel)

// Place below the header bar
let toolbarView = ToolbarView()
toolbarView.addTopBar(HeaderBar())
toolbarView.addTopBar(menuBar)
toolbarView.content = mainContent

// Create actions
let actionGroup = SimpleActionGroup()
for name in ["new", "open", "save", "quit", "cut", "copy", "paste", "zoomin", "zoomout"] {
    let action = SimpleAction(name: name)
    action.onActivate {
        print("\(name) activated!")
    }
    actionGroup.addAction(action)
}
toolbarView.insertActionGroup("bar", actionGroup)
```

### Split button

``SplitButton`` combines a button with a dropdown menu — useful for
actions with variants:

```swift
let menu = GMenuRef()
menu.append("Save As PDF", action: "win.savepdf")
menu.append("Save As HTML", action: "win.savehtml")
menu.append("Export...", action: "win.export")

let splitButton = SplitButton()
splitButton.label = "Save"
splitButton.menuModel = menu

splitButton.onClicked {
    print("Default save action")
}
```

### Custom popover menu

For menus with custom widgets (not just text items), use ``PopoverMenu``
directly:

```swift
let popover = PopoverMenu()
popover.menuModel = menu

let menuButton = MenuButton()
menuButton.popover = popover
```
