import Adwaita

@MainActor
struct OverlaySplitViewExample: DemoExample {
    let name = "Overlay Split View"
    let id = "overlaysplitview"
    let category: ExampleCategory = .composite
    let opensInWindow = true

    let sourceCode = """
    let splitView = OverlaySplitView()
    splitView.pinSidebar = false
    splitView.showSidebar = true
    splitView.enableShowGesture = true
    splitView.enableHideGesture = true

    // Toggle sidebar with a button
    let toggleBtn = Button(iconName: "sidebar-show-symbolic")
    toggleBtn.onClicked {
        splitView.showSidebar = !splitView.showSidebar
    }
    """

    func buildWidget() -> Widget {
        let splitView = OverlaySplitView()
        splitView.pinSidebar = false
        splitView.showSidebar = true
        splitView.enableShowGesture = true
        splitView.enableHideGesture = true
        splitView.sidebarWidthFraction = 0.3

        // Sidebar
        let sidebarBox = Box(orientation: .vertical, spacing: 0)
        let sidebarList = ListBox()
        sidebarList.selectionMode = .single
        sidebarList.addCSSClass("navigation-sidebar")

        let items = ["Home", "Search", "Library", "Settings"]
        for item in items {
            let label = Label(item)
            label.xalign = 0
            label.setMargins(8)
            sidebarList.append(label)
        }
        sidebarBox.append(sidebarList)

        let sidebarScroll = ScrolledWindow()
        sidebarScroll.child = sidebarBox

        let sidebarHeader = HeaderBar()
        let sidebarTitle = Label("Menu")
        sidebarTitle.addCSSClass("heading")
        sidebarHeader.titleWidget = sidebarTitle

        let sidebarToolbar = ToolbarView()
        sidebarToolbar.addTopBar(sidebarHeader)
        sidebarToolbar.content = sidebarScroll

        splitView.sidebar = sidebarToolbar

        // Content
        let contentStatus = StatusPage()
        contentStatus.title = "Home"
        contentStatus.iconName = "go-home-symbolic"
        contentStatus.description = "Swipe from the edge or tap the button to toggle the sidebar overlay"

        let toggleBtn = Button(iconName: "sidebar-show-symbolic")
        toggleBtn.addCSSClass("flat")

        toggleBtn.onClicked { [splitView] in
            splitView.showSidebar = !splitView.showSidebar
        }

        let contentHeader = HeaderBar()
        contentHeader.packStart(toggleBtn)

        let contentToolbar = ToolbarView()
        contentToolbar.addTopBar(contentHeader)
        contentToolbar.content = contentStatus

        splitView.content = contentToolbar

        sidebarList.onRowActivated { [contentStatus, splitView] row in
            let idx = Int(row.index)
            guard idx >= 0, idx < items.count else { return }
            contentStatus.title = items[idx]
            // Auto-close sidebar overlay on selection
            if splitView.collapsed {
                splitView.showSidebar = false
            }
        }

        return splitView
    }
}
