# Navigation Patterns

Build multi-page applications with push/pop navigation and split views.

## Overview

swift-adwaita provides several navigation patterns for different app structures.
``NavigationView`` handles stack-based push/pop navigation,
``NavigationSplitView`` provides a sidebar+detail layout, and
``OverlaySplitView`` adds a collapsible sidebar overlay.

### Push/pop navigation with NavigationView

``NavigationView`` manages a stack of pages. Push pages onto the stack to navigate
forward and pop them to go back. Each page is wrapped in a ``NavigationPage``
that provides the title for the header bar's back button.

Every page should contain its own ``ToolbarView`` with a ``HeaderBar`` — this
lets libadwaita show the back button automatically on pushed pages.

```swift
let navView = NavigationView()

// Root page
let homePage = StatusPage()
homePage.title = "Home"
homePage.iconName = "go-home-symbolic"

let detailBtn = Button(label: "Go to Detail")
detailBtn.addCSSClass("pill")
detailBtn.addCSSClass("suggested-action")
detailBtn.halign = .center
homePage.child = detailBtn

let homeToolbar = ToolbarView()
homeToolbar.addTopBar(HeaderBar())
homeToolbar.content = homePage

let rootPage = NavigationPage(child: homeToolbar, title: "Home")
navView.add(rootPage)

// Push a detail page when the button is clicked
detailBtn.onClicked {
    let detail = StatusPage()
    detail.title = "Detail"
    detail.iconName = "emblem-documents-symbolic"
    detail.description = "Press Back to return."

    let toolbar = ToolbarView()
    toolbar.addTopBar(HeaderBar())
    toolbar.content = detail

    let page = NavigationPage(child: toolbar, title: "Detail")
    navView.push(page)
}
```

You can pop pages programmatically:

```swift
navView.pop()          // Pop one page
navView.popToPage(rootPage)  // Pop to a specific page
```

### Sidebar + detail with NavigationSplitView

``NavigationSplitView`` splits the window into a sidebar and content pane.
On narrow windows it collapses into a single-pane navigation stack. Each
side is a ``NavigationPage``.

```swift
let splitView = NavigationSplitView()
splitView.sidebarWidthFraction = 0.33

// Sidebar
let sidebarList = ListBox()
sidebarList.selectionMode = .single
sidebarList.addCSSClass("navigation-sidebar")

let categories = ["Inbox", "Sent", "Drafts"]
for name in categories {
    let label = Label(name)
    label.xalign = 0
    label.setMargins(8)
    sidebarList.append(label)
}

let sidebarToolbar = ToolbarView()
sidebarToolbar.addTopBar(HeaderBar())
sidebarToolbar.content = sidebarList

let sidebarPage = NavigationPage(
    child: sidebarToolbar, title: "Mail"
)

// Content
let contentStatus = StatusPage()
contentStatus.title = "Select a category"
contentStatus.iconName = "mail-inbox-symbolic"

let contentToolbar = ToolbarView()
contentToolbar.addTopBar(HeaderBar())
contentToolbar.content = contentStatus

let contentPage = NavigationPage(
    child: contentToolbar, title: "Inbox"
)

// Update content on selection
sidebarList.onRowActivated { row in
    let idx = Int(row.index)
    guard idx >= 0, idx < categories.count else { return }
    contentStatus.title = categories[idx]
}

splitView.setSidebar(sidebarPage)
splitView.setContent(contentPage)
```

### Collapsible overlay sidebar

``OverlaySplitView`` shows the sidebar as an overlay that slides in and out.
It collapses automatically on narrow windows.

```swift
let splitView = OverlaySplitView()
splitView.pinSidebar = false
splitView.showSidebar = true
splitView.enableShowGesture = true
splitView.enableHideGesture = true

// Toggle button in the content header bar
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
```

### Page switching with Stack

For simple view switching (tabs, segmented controls), use ``Stack`` with
``ViewSwitcher`` or ``StackSwitcher``:

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

// Put the switcher in the header bar
let switcher = ViewSwitcher()
switcher.stack = stack
switcher.policy = .wide

let headerBar = HeaderBar()
headerBar.titleWidget = switcher
```
