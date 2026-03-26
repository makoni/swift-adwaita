# Responsive Layouts

Make your application adapt to different window sizes with breakpoints.

## Overview

GNOME applications should work well at any window size — from small phone
screens to wide desktop monitors. swift-adwaita provides ``Breakpoint``,
``BreakpointBin``, and adaptive widgets like ``OverlaySplitView`` to build
responsive layouts.

### Breakpoints

A ``Breakpoint`` triggers layout changes when a widget's size crosses a
threshold. Create a condition, register property setters, and add the
breakpoint to a ``BreakpointBin`` or ``Window``.

```swift
// Cards laid out horizontally
let cardsBox = Box(orientation: .horizontal, spacing: 16)
cardsBox.append(card1)
cardsBox.append(card2)

// Switch to vertical layout below 500sp
let condition = BreakpointCondition(parse: "max-width: 500sp")
let bp = Breakpoint(condition: condition)

// Change properties when the breakpoint activates
bp.addSetter(cardsBox, property: .orientation, value: 1)  // vertical
bp.addSetter(cardsBox, property: .spacing, value: 8)

// Optional callbacks
bp.onApply {
    statusLabel.text = "Narrow layout"
}
bp.onUnapply {
    statusLabel.text = "Wide layout"
}

// Wrap content in a BreakpointBin
let bin = BreakpointBin()
bin.child = cardsBox
bin.addBreakpoint(bp)
```

You can also add breakpoints directly to windows:

```swift
let window = ApplicationWindow(application: app)
window.addBreakpoint(bp)
```

### Breakpoint conditions

Conditions use the format `"<property>: <value>"`. Common patterns:

| Condition | Meaning |
|-----------|---------|
| `"max-width: 600sp"` | Triggers when width is at most 600sp |
| `"min-width: 800sp"` | Triggers when width is at least 800sp |
| `"max-height: 400sp"` | Triggers when height is at most 400sp |

The `sp` unit is scale-independent pixels, accounting for font scaling.

### Adaptive sidebar with OverlaySplitView

``OverlaySplitView`` automatically handles sidebar visibility based on
available space. When the window is wide, the sidebar is shown alongside
content. When narrow, it becomes an overlay that slides in and out.

```swift
let splitView = OverlaySplitView()
splitView.pinSidebar = false
splitView.enableShowGesture = true
splitView.enableHideGesture = true

// Sidebar content
let sidebarList = ListBox()
sidebarList.addCSSClass("navigation-sidebar")
sidebarList.selectionMode = .single

for item in ["Home", "Search", "Library", "Settings"] {
    let label = Label(item)
    label.xalign = 0
    label.setMargins(8)
    sidebarList.append(label)
}

let sidebarToolbar = ToolbarView()
sidebarToolbar.addTopBar(HeaderBar())
sidebarToolbar.content = sidebarList
splitView.sidebar = sidebarToolbar

// Content with toggle button
let toggleBtn = Button(iconName: "sidebar-show-symbolic")
toggleBtn.addCSSClass("flat")
toggleBtn.onClicked {
    splitView.showSidebar = !splitView.showSidebar
}

let contentHeader = HeaderBar()
contentHeader.packStart(toggleBtn)

let contentToolbar = ToolbarView()
contentToolbar.addTopBar(contentHeader)
contentToolbar.content = StatusPage()
splitView.content = contentToolbar

// Auto-close on narrow selection
sidebarList.onRowActivated { _ in
    if splitView.collapsed {
        splitView.showSidebar = false
    }
}
```

### Adaptive view switching

``ViewSwitcher`` in the header bar automatically switches to a bottom
``ViewSwitcherBar`` on narrow windows — a common mobile-friendly pattern:

```swift
let stack = ViewStack()

let page1 = StatusPage()
page1.title = "Recent"
stack.addTitledWithIcon(
    page1, name: "recent",
    title: "Recent",
    iconName: "document-open-recent-symbolic"
)

let page2 = StatusPage()
page2.title = "Starred"
stack.addTitledWithIcon(
    page2, name: "starred",
    title: "Starred",
    iconName: "starred-symbolic"
)

// Top switcher (hidden on narrow)
let topSwitcher = ViewSwitcher()
topSwitcher.stack = stack
topSwitcher.policy = .wide

let headerBar = HeaderBar()
headerBar.titleWidget = topSwitcher

// Bottom switcher bar (shown on narrow)
let bottomBar = ViewSwitcherBar()
bottomBar.stack = stack

let toolbarView = ToolbarView()
toolbarView.addTopBar(headerBar)
toolbarView.addBottomBar(bottomBar)
toolbarView.content = stack
```

### Responsive grid with WrapBox

``WrapBox`` wraps its children to the next line when space runs out,
similar to CSS flexbox wrap:

```swift
let wrapBox = WrapBox()
wrapBox.childWidth = 150
wrapBox.childHeight = 100
wrapBox.lineSpacing = 8
wrapBox.childSpacing = 8

for i in 0..<12 {
    let card = Box(orientation: .vertical, spacing: 4)
    card.setMargins(8)
    card.addCSSClass("card")
    let label = Label("Item \(i + 1)")
    card.append(label)
    wrapBox.append(card)
}
```

### Clamping content width

Use ``Clamp`` to limit content width on wide screens while allowing it
to fill narrow screens:

```swift
let content = Box(orientation: .vertical, spacing: 12)
content.setMargins(12)
// ... add children ...

let clamp = Clamp()
clamp.maximumSize = 600    // Max width in pixels
clamp.tighteningThreshold = 400
clamp.child = content
```

This is especially useful inside ``ScrolledWindow`` for article-style
content that should remain readable at any window width.
