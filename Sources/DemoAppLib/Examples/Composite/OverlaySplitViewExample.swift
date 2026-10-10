// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

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
        toggleBtn.onClicked { [weak splitView] in
            guard let splitView else { return }
            splitView.showSidebar = !splitView.showSidebar
        }

        // Collapse into an overlay when narrow (gestures need this)
        let breakpoint = Breakpoint.maxWidth(500)
        breakpoint.addSetter(splitView, property: .custom("collapsed"), value: true)
        let bin = BreakpointBin()
        bin.child = splitView
        bin.addBreakpoint(breakpoint)
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
        contentStatus.description =
            "Tap the button to toggle the sidebar. Narrow the window to turn it into an overlay you can also swipe in from the edge."

        let toggleBtn = Button(iconName: "sidebar-show-symbolic")
        toggleBtn.addCSSClass("flat")

        // The button and the list live inside the split view: capture it
        // weakly, or their handlers would keep the whole view alive forever.
        toggleBtn.onClicked { [weak splitView] in
            guard let splitView else { return }
            splitView.showSidebar = !splitView.showSidebar
        }

        let contentHeader = HeaderBar()
        contentHeader.packStart(toggleBtn)

        let contentToolbar = ToolbarView()
        contentToolbar.addTopBar(contentHeader)
        contentToolbar.content = contentStatus

        splitView.content = contentToolbar

        sidebarList.onRowActivated { [contentStatus, weak splitView] row in
            let idx = Int(row.index)
            guard idx >= 0, idx < items.count else { return }
            contentStatus.title = items[idx]
            // Auto-close sidebar overlay on selection
            if let splitView, splitView.collapsed {
                splitView.showSidebar = false
            }
        }

        // The swipe gestures and the auto-close above only apply while the
        // view is collapsed, which nothing else would ever set: collapse it
        // into an overlay at narrow widths, as libadwaita apps do.
        let breakpoint = Breakpoint.maxWidth(500)
        breakpoint.addSetter(splitView, property: .custom("collapsed"), value: true)

        let bin = BreakpointBin()
        bin.child = splitView
        bin.addBreakpoint(breakpoint)
        bin.setSizeRequest(width: 360, height: 300)
        return bin
    }
}
