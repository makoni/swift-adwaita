import Adwaita

@MainActor
struct TabViewExample: DemoExample {
    let name = "Tab View"
    let id = "tabview"
    let category: ExampleCategory = .composite
    let opensInWindow = true

    let sourceCode = """
    let tabView = TabView()

    // Add tabs with StatusPage content
    let page1 = StatusPage()
    page1.title = "Documents"
    page1.iconName = "document-open-symbolic"
    let tab1 = tabView.append(page1)
    tab1.title = "Documents"

    let page2 = StatusPage()
    page2.title = "Music"
    page2.iconName = "audio-x-generic-symbolic"
    let tab2 = tabView.append(page2)
    tab2.title = "Music"

    // TabBar linked to TabView
    let tabBar = TabBar()
    tabBar.view = tabView

    // "New Tab" button as end action
    let addBtn = Button(iconName: "tab-new-symbolic")
    addBtn.onClicked {
        let n = tabView.nPages + 1
        let page = StatusPage()
        page.title = "Tab \\(n)"
        page.iconName = "tab-new-symbolic"
        let tab = tabView.append(page)
        tab.title = "Tab \\(n)"
    }
    tabBar.endActionWidget = addBtn
    """

    func buildWidget() -> Widget {
        let tabView = TabView()

        // Tab 1 — Documents
        let page1 = StatusPage()
        page1.title = "Documents"
        page1.iconName = "document-open-symbolic"
        page1.description = "Your recent documents"
        let tab1 = tabView.append(page1)
        tab1.title = "Documents"

        // Tab 2 — Music
        let page2 = StatusPage()
        page2.title = "Music"
        page2.iconName = "audio-x-generic-symbolic"
        page2.description = "Your music library"
        let tab2 = tabView.append(page2)
        tab2.title = "Music"

        // Tab 3 — Pictures
        let page3 = StatusPage()
        page3.title = "Pictures"
        page3.iconName = "image-x-generic-symbolic"
        page3.description = "Your photo gallery"
        let tab3 = tabView.append(page3)
        tab3.title = "Pictures"

        // TabBar
        let tabBar = TabBar()
        tabBar.view = tabView

        // "New Tab" button
        let addBtn = Button(iconName: "tab-new-symbolic")
        addBtn.addCSSClass("flat")
        addBtn.onClicked { [tabView] in
            let n = tabView.nPages + 1
            let newPage = StatusPage()
            newPage.title = "Tab \(n)"
            newPage.iconName = "tab-new-symbolic"
            let tab = tabView.append(newPage)
            tab.title = "Tab \(n)"
        }
        tabBar.endActionWidget = addBtn

        // Layout with ToolbarView
        let headerBar = HeaderBar()
        let toolbarView = ToolbarView()
        toolbarView.addTopBar(headerBar)
        toolbarView.addTopBar(tabBar)
        toolbarView.content = tabView

        return toolbarView
    }
}
