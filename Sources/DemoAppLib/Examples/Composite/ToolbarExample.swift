// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct ToolbarExample: DemoExample {
    let name = "Toolbar View"
    let id = "toolbar"
    let category: ExampleCategory = .composite
    let opensInWindow = true

    let sourceCode = """
    let toolbarView = ToolbarView()

    // Top bar with custom title widget
    let headerBar = HeaderBar()
    let title = WindowTitle(title: "My App", subtitle: "Toolbar Example")
    headerBar.titleWidget = title

    let searchBtn = Button(iconName: "system-search-symbolic")
    searchBtn.addCSSClass("flat")
    headerBar.packEnd(searchBtn)

    let menuBtn = Button(iconName: "open-menu-symbolic")
    menuBtn.addCSSClass("flat")
    headerBar.packEnd(menuBtn)

    toolbarView.addTopBar(headerBar)

    // Content
    let content = StatusPage()
    content.title = "Content Area"
    content.description = "This is the main content"
    toolbarView.content = content

    // Bottom bar
    let bottomBar = Box(orientation: .horizontal, spacing: 6)
    bottomBar.halign = .center
    bottomBar.setMargins(6)
    let bottomLabel = Label("Bottom Toolbar")
    bottomBar.append(bottomLabel)
    toolbarView.addBottomBar(bottomBar)
    """

    func buildWidget() -> Widget {
        let toolbarView = ToolbarView()

        // Top bar
        let headerBar = HeaderBar()
        let title = WindowTitle(title: "My App", subtitle: "Toolbar Example")
        headerBar.titleWidget = title

        let searchBtn = Button(iconName: "system-search-symbolic")
        searchBtn.addCSSClass("flat")
        headerBar.packEnd(searchBtn)

        let menuBtn = Button(iconName: "open-menu-symbolic")
        menuBtn.addCSSClass("flat")
        headerBar.packEnd(menuBtn)

        toolbarView.addTopBar(headerBar)

        // Content
        let content = StatusPage()
        content.title = "Content Area"
        content.description = "This is the main content between top and bottom toolbars"
        content.iconName = "view-grid-symbolic"
        toolbarView.content = content

        // Bottom bar
        let bottomBar = Box(orientation: .horizontal, spacing: 6)
        bottomBar.halign = .center
        bottomBar.setMargins(6)
        let bottomLabel = Label("Bottom Toolbar")
        bottomLabel.addCSSClass("dim-label")
        bottomBar.append(bottomLabel)
        toolbarView.addBottomBar(bottomBar)

        return toolbarView
    }
}
