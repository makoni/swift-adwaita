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
    overview.child = Label("Main content")
    overview.enableNewTab = true
    overview.enableSearch = true
    // The handler must append a page to the TabView and return it; the
    // overview selects it and closes, and does not re-add it.
    overview.onCreateTab {
        let label = Label("A new tab")
        let page = tabView.append(label)
        page.title = "New Tab"
        return page
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
        // Embedded in the demo window (not a top-level), so suppress the
        // overview's own start/end window title buttons — the GIR default is
        // TRUE, which would duplicate the real window controls.
        overview.showStartTitleButtons = false
        overview.showEndTitleButtons = false
        overview.vexpand = true
        overview.onCreateTab {
            let label = Label("A new tab")
            label.setMargins(24)
            let page = tabView.append(label)
            page.title = "New Tab"
            return page
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
