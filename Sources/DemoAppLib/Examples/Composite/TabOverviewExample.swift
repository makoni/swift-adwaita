// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct TabOverviewExample: DemoExample {
    let name = "Tab Overview"
    let id = "taboverview"
    let category: ExampleCategory = .composite

    let sourceCode = """
    let tabView = TabView()
    let tabBar = TabBar()
    tabBar.view = tabView

    let overview = TabOverview()
    overview.view = tabView
    overview.child = mainContent
    overview.enableNewTab = true
    overview.enableSearch = true
    overview.onCreateTab {
        let page = tabView.append(newPage)
        page.title = "New Tab"
    }
    """

    func buildWidget() -> Widget {
        let tabView = TabView()
        for i in 1 ... 3 {
            let label = Label("Content of tab \(i)")
            label.setMargins(24)
            let page = tabView.append(label)
            page.title = "Tab \(i)"
        }
        let tabBar = TabBar()
        tabBar.view = tabView

        let contentBox = Box(orientation: .vertical, spacing: 0)
        contentBox.append(tabBar)
        contentBox.append(tabView)

        let overview = TabOverview()
        overview.view = tabView
        overview.child = contentBox
        overview.enableNewTab = true
        overview.enableSearch = true
        overview.vexpand = true
        overview.onCreateTab {
            let label = Label("A new tab")
            label.setMargins(24)
            let page = tabView.append(label)
            page.title = "New Tab"
        }

        let controlBox = Box(orientation: .horizontal, spacing: 12)
        let toggleBtn = Button(label: "Toggle Tab Overview")
        toggleBtn.addCSSClass("pill")
        toggleBtn.onClicked { [overview] in
            overview.open = !overview.open
        }
        let hint = Label("The overview grids all open tabs; use New Tab / search.")
        hint.addCSSClass("dim-label")
        controlBox.append(toggleBtn)
        controlBox.append(hint)
        controlBox.setMargins(12)

        let outerBox = Box(orientation: .vertical, spacing: 0)
        outerBox.append(overview)
        outerBox.append(controlBox)

        return outerBox
    }
}
