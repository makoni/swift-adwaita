import Adwaita

@MainActor
struct NavigationSplitViewExample: DemoExample {
    let name = "Navigation Split View"
    let id = "navsplitview"
    let category: ExampleCategory = .composite
    let opensInWindow = true

    let sourceCode = """
    let splitView = NavigationSplitView()
    splitView.sidebarWidthFraction = 0.3

    // Sidebar
    let sidebarPage = NavigationPage(
        child: sidebarContent, title: "Categories")

    // Content
    let contentPage = NavigationPage(
        child: contentWidget, title: "Detail")

    splitView.sidebar = sidebarPage
    splitView.content = contentPage
    """

    func buildWidget() -> Widget {
        let splitView = NavigationSplitView()
        splitView.sidebarWidthFraction = 0.33

        // Sidebar with list
        let sidebarBox = Box(orientation: .vertical, spacing: 0)
        let sidebarList = ListBox()
        sidebarList.selectionMode = .single
        sidebarList.addCSSClass("navigation-sidebar")

        let categories = ["Inbox", "Starred", "Sent", "Drafts", "Trash"]
        let icons = [
            "mail-inbox-symbolic", "starred-symbolic", "mail-send-symbolic",
            "document-edit-symbolic", "user-trash-symbolic"
        ]

        for category in categories {
            let label = Label(category)
            label.xalign = 0
            label.setMargins(8)
            sidebarList.append(label)
        }
        sidebarBox.append(sidebarList)

        let sidebarScroll = ScrolledWindow()
        sidebarScroll.child = sidebarBox

        let sidebarHeader = HeaderBar()
        let sidebarTitle = Label("Mail")
        sidebarTitle.addCSSClass("heading")
        sidebarHeader.titleWidget = sidebarTitle

        let sidebarToolbar = ToolbarView()
        sidebarToolbar.addTopBar(sidebarHeader)
        sidebarToolbar.content = sidebarScroll

        let sidebarPage = NavigationPage(child: sidebarToolbar, title: "Mail")

        // Content
        let contentStatus = StatusPage()
        contentStatus.title = "Inbox"
        contentStatus.iconName = "mail-inbox-symbolic"
        contentStatus.description = "Select a category from the sidebar"

        let contentHeader = HeaderBar()
        let contentToolbar = ToolbarView()
        contentToolbar.addTopBar(contentHeader)
        contentToolbar.content = contentStatus

        let contentPage = NavigationPage(child: contentToolbar, title: "Inbox")

        sidebarList.onRowActivated { [contentStatus] row in
            let idx = Int(row.index)
            guard idx >= 0, idx < categories.count else { return }
            contentStatus.title = categories[idx]
            contentStatus.iconName = icons[idx]
            contentStatus.description = "Showing \(categories[idx]) items"
        }

        splitView.setSidebar(sidebarPage)
        splitView.setContent(contentPage)

        return splitView
    }
}
