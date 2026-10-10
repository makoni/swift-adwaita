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

        let searchBtn = ToggleButton()
        searchBtn.child = Image(iconName: "system-search-symbolic")
        headerBar.packEnd(searchBtn)

        let menuBtn = MenuButton()
        menuBtn.iconName = "open-menu-symbolic"
        headerBar.packEnd(menuBtn)

        toolbarView.addTopBar(headerBar)

        // A second top bar, revealed by the search button
        let searchBar = SearchBar()
        searchBar.child = SearchEntry()
        searchBar.bind(
            .custom("search-mode-enabled"), to: searchBtn,
            property: .active, flags: .bidirectional | .syncCreate)
        toolbarView.addTopBar(searchBar)

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

        let searchBtn = ToggleButton()
        searchBtn.child = Image(iconName: "system-search-symbolic")
        searchBtn.tooltipText = "Search"
        searchBtn.addCSSClass("flat")
        headerBar.packEnd(searchBtn)

        let menuBtn = MenuButton()
        menuBtn.iconName = "open-menu-symbolic"
        menuBtn.tooltipText = "Main Menu"
        menuBtn.addCSSClass("flat")
        headerBar.packEnd(menuBtn)

        toolbarView.addTopBar(headerBar)

        // Second top bar: a search bar the search button reveals. Bound both
        // ways so its close button and Escape also release the toggle.
        let searchEntry = SearchEntry()
        searchEntry.placeholderText = "Search…"
        let searchBar = SearchBar()
        searchBar.child = searchEntry
        searchBar.connectEntry(searchEntry)
        searchBar.bind(
            .custom("search-mode-enabled"), to: searchBtn,
            property: .active, flags: .bidirectional | .syncCreate)
        toolbarView.addTopBar(searchBar)

        // Content
        let defaultDescription = "This is the main content between top and bottom toolbars"
        let content = StatusPage()
        content.title = "Content Area"
        content.description = defaultDescription
        content.iconName = "view-grid-symbolic"
        toolbarView.content = content

        // Weak self-capture: the entry owns this handler.
        searchEntry.onSearchChanged { [weak searchEntry, content] in
            guard let searchEntry else { return }
            let query = searchEntry.text
            content.description = query.isEmpty ? defaultDescription : "Searching for “\(query)”"
        }

        // Bottom bar
        let bottomBar = Box(orientation: .horizontal, spacing: 6)
        bottomBar.halign = .center
        bottomBar.setMargins(6)
        let bottomLabel = Label("Bottom Toolbar")
        bottomLabel.addCSSClass("dim-label")
        bottomBar.append(bottomLabel)
        toolbarView.addBottomBar(bottomBar)

        // The menu toggles the bottom bar (a binding, so it also reflects it).
        let bottomBarCheck = CheckButton(label: "Show Bottom Bar")
        toolbarView.bind(
            .custom("reveal-bottom-bars"), to: bottomBarCheck,
            property: .active, flags: .bidirectional | .syncCreate)
        let menuPopover = Popover()
        menuPopover.child = bottomBarCheck
        menuBtn.popover = menuPopover

        return toolbarView
    }
}
