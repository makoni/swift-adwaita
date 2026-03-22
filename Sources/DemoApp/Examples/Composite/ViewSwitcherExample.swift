import Adwaita
import CAdwaita

@MainActor
struct ViewSwitcherExample: DemoExample {
    let name = "View Switcher"
    let id = "viewswitcher"
    let category: ExampleCategory = .composite

    let sourceCode = """
    let viewStack = ViewStack()

    let page1 = StatusPage()
    page1.title = "Recent"
    page1.iconName = "document-open-recent-symbolic"
    viewStack.addTitledWithIcon(page1, name: "recent",
        title: "Recent", iconName: "document-open-recent-symbolic")

    let page2 = StatusPage()
    page2.title = "Starred"
    page2.iconName = "starred-symbolic"
    viewStack.addTitledWithIcon(page2, name: "starred",
        title: "Starred", iconName: "starred-symbolic")

    let switcher = ViewSwitcher()
    switcher.stack = viewStack
    switcher.policy = .wide
    """

    func buildWidget() -> Widget {
        let viewStack = ViewStack()
        viewStack.enableTransitions = true

        // Page 1 — Recent
        let page1 = StatusPage()
        page1.title = "Recent Files"
        page1.iconName = "document-open-recent-symbolic"
        page1.description = "Your recently accessed files appear here."
        viewStack.addTitledWithIcon(page1, name: "recent", title: "Recent", iconName: "document-open-recent-symbolic")

        // Page 2 — Starred
        let page2 = StatusPage()
        page2.title = "Starred Items"
        page2.iconName = "starred-symbolic"
        page2.description = "Items you have starred for quick access."
        viewStack.addTitledWithIcon(page2, name: "starred", title: "Starred", iconName: "starred-symbolic")

        // Page 3 — Shared
        let page3 = StatusPage()
        page3.title = "Shared"
        page3.iconName = "emblem-shared-symbolic"
        page3.description = "Files shared with you by others."
        viewStack.addTitledWithIcon(page3, name: "shared", title: "Shared", iconName: "emblem-shared-symbolic")

        // ViewSwitcher in a header bar
        let switcher = ViewSwitcher()
        switcher.stack = viewStack
        switcher.policy = .wide

        let headerBar = HeaderBar()
        headerBar.titleWidget = switcher

        // Bottom bar for narrow mode
        let switcherBar = ViewSwitcherBar()
        switcherBar.stack = viewStack

        let toolbarView = ToolbarView()
        toolbarView.addTopBar(headerBar)
        toolbarView.addBottomBar(switcherBar)
        toolbarView.content = viewStack

        return toolbarView
    }
}
