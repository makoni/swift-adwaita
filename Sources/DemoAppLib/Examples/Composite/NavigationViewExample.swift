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

    detailBtn.onClicked {
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

        detailBtn.onClicked { [navView] in
            let detailStatus = StatusPage()
            detailStatus.title = "Detail Page"
            detailStatus.iconName = "emblem-documents-symbolic"
            detailStatus.description = "Press Back to return to the Home page."

            let toolbar = ToolbarView()
            toolbar.addTopBar(HeaderBar())
            toolbar.content = detailStatus

            let page = NavigationPage(child: toolbar, title: "Detail")
            navView.push(page)
        }

        settingsBtn.onClicked { [navView] in
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
