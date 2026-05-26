# Context Menus

Use popovers and actions for contextual commands.

## Menu button menus

For toolbar or row menus, use ``MenuButton`` with ``GMenuRef``:

```swift
let menu = GMenuRef()
menu.append(label: "Rename", detailedAction: "win.rename")
menu.append(label: "Delete", detailedAction: "win.delete")

let button = MenuButton(iconName: "open-menu-symbolic")
button.menuModel = menu
```

## Right-click context menu

Use ``PopoverMenu`` plus ``GestureClick`` for a custom context menu:

```swift
let popover = PopoverMenu()
popover.menuModel = menu

let click = GestureClick(button: .secondary)
click.onPressed { _, x, y in
    popover.setParent(targetWidget)
    popover.present(from: targetWidget, x: x, y: y)
}
targetWidget.addController(click)
```

## Keep menu actions explicit

Prefer action-based menus over ad-hoc closures hidden inside view code. That
keeps keyboard shortcuts, menu buttons, and context menus all pointing at the
same command implementation.
