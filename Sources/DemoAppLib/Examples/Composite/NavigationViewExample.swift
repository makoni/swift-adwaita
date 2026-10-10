// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct NavigationViewExample: DemoExample {
    let name = "Navigation View"
    let id = "navigationview"
    let category: ExampleCategory = .composite
    let opensInWindow = true

    let sourceCode = """
        let navView = NavigationView()

        let mainPage = StatusPage()
        mainPage.title = "Home"
        mainPage.iconName = "go-home-symbolic"

        let detailBtn = Button(label: "Go to Detail")
        detailBtn.addCSSClass("pill")
        detailBtn.addCSSClass("suggested-action")
        mainPage.child = detailBtn

        let page1 = NavigationPage(child: mainPage, title: "Home")
        navView.add(page1)

        detailBtn.onClicked { [weak navView] in
            guard let navView else { return }
            let detailPage = StatusPage()
            detailPage.title = "Detail"
            let page2 = NavigationPage(child: detailPage, title: "Detail")
            navView.push(page2)
        }
        """

    func buildWidget() -> Widget {
        let navView = NavigationView()

        // -- Root page (Home) --
        let mainStatus = StatusPage()
        mainStatus.title = "Home"
        mainStatus.iconName = "go-home-symbolic"
        mainStatus.description = "This is the root page of a NavigationView."

        let detailBtn = Button(label: "Go to Detail")
        detailBtn.addCSSClass("pill")
        detailBtn.addCSSClass("suggested-action")
        detailBtn.halign = .center

        let settingsBtn = Button(label: "Go to Settings")
        settingsBtn.addCSSClass("pill")
        settingsBtn.halign = .center

        let btnBox = Box(orientation: .vertical, spacing: 8)
        btnBox.halign = .center
        btnBox.append(detailBtn)
        btnBox.append(settingsBtn)
        mainStatus.child = btnBox

        let mainToolbar = ToolbarView()
        mainToolbar.addTopBar(HeaderBar())
        mainToolbar.content = mainStatus

        let mainPage = NavigationPage(child: mainToolbar, title: "Home")
        navView.add(mainPage)

        // The buttons live inside the navigation view: capture it weakly, or
        // their handlers would keep the whole view alive forever.
        detailBtn.onClicked { [weak navView] in
            guard let navView else { return }
            let detailStatus = StatusPage()
            detailStatus.title = "Detail Page"
            detailStatus.iconName = "folder-documents-symbolic"
            detailStatus.description = "Press Back to return to the Home page."

            let toolbar = ToolbarView()
            toolbar.addTopBar(HeaderBar())
            toolbar.content = detailStatus

            let page = NavigationPage(child: toolbar, title: "Detail")
            navView.push(page)
        }

        settingsBtn.onClicked { [weak navView] in
            guard let navView else { return }
            let settingsStatus = StatusPage()
            settingsStatus.title = "Settings"
            settingsStatus.iconName = "preferences-system-symbolic"
            settingsStatus.description = "Configure your application here."

            let toolbar = ToolbarView()
            toolbar.addTopBar(HeaderBar())
            toolbar.content = settingsStatus

            let page = NavigationPage(child: toolbar, title: "Settings")
            navView.push(page)
        }

        return navView
    }
}
