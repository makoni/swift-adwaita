import Adwaita
import CAdwaita

@MainActor
func buildApp() {
    let app = Application(id: "com.example.SwiftAdwaitaDemo")

    app.onActivate {
        let window = ApplicationWindow(application: app)
        window.title = "swift-adwaita Demo"
        window.defaultWidth = 900
        window.defaultHeight = 600

        // -- Content stack --
        let contentStack = Stack()
        contentStack.transitionType = .crossfade
        contentStack.transitionDuration = 200

        // Welcome / landing page
        let welcomePage = StatusPage()
        welcomePage.iconName = "applications-science-symbolic"
        welcomePage.title = "swift-adwaita Demo"
        welcomePage.description = "An imperative Swift 6.2 wrapper for GTK4 and libadwaita.\nSelect an example from the sidebar to get started."
        contentStack.addNamed(welcomePage, name: "welcome")

        for example in allExamples {
            let widget = example.buildWidget()
            widget.hexpand = true
            widget.vexpand = true
            contentStack.addNamed(widget, name: example.id)
        }
        contentStack.visibleChildName = "welcome"

        // -- Content header bar --
        let contentWindowTitle = WindowTitle(
            title: "Welcome",
            subtitle: "swift-adwaita Demo"
        )
        let showCodeButton = Button(iconName: "code-symbolic")
        showCodeButton.addCSSClass("flat")
        showCodeButton.tooltipText = "Show Code"
        showCodeButton.visible = false

        showCodeButton.onClicked { [window, contentStack] in
            let currentId = contentStack.visibleChildName ?? ""
            guard let example = allExamples.first(where: { $0.id == currentId }) else { return }
            showCodeDialog(sourceCode: example.sourceCode, title: example.name, parent: window)
        }

        let contentHeaderBar = HeaderBar()
        contentHeaderBar.titleWidget = contentWindowTitle
        contentHeaderBar.packEnd(showCodeButton)

        let contentToolbar = ToolbarView()
        contentToolbar.addTopBar(contentHeaderBar)
        contentToolbar.content = contentStack

        // -- Sidebar --
        let compositeExamples = allExamples.filter { $0.category == .composite }
        let widgetExamples = allExamples.filter { $0.category == .widgets }

        let sidebarBox = Box(orientation: .vertical, spacing: 0)

        // Composite section
        let compositeHeading = Label("Composite Layouts")
        compositeHeading.addCSSClass("heading")
        compositeHeading.xalign = 0
        compositeHeading.setMargins(12)
        sidebarBox.append(compositeHeading)

        let compositeList = ListBox()
        compositeList.selectionMode = .single
        compositeList.addCSSClass("navigation-sidebar")
        for example in compositeExamples {
            let label = Label(example.name)
            label.xalign = 0
            label.setMargins(6)
            compositeList.append(label)
        }
        sidebarBox.append(compositeList)

        // Widgets section
        let widgetsHeading = Label("Individual Widgets")
        widgetsHeading.addCSSClass("heading")
        widgetsHeading.xalign = 0
        widgetsHeading.setMargins(12)
        sidebarBox.append(widgetsHeading)

        let widgetsList = ListBox()
        widgetsList.selectionMode = .single
        widgetsList.addCSSClass("navigation-sidebar")
        for example in widgetExamples {
            let label = Label(example.name)
            label.xalign = 0
            label.setMargins(6)
            widgetsList.append(label)
        }
        sidebarBox.append(widgetsList)

        // Sidebar selection handlers
        compositeList.onRowActivated { [contentStack, contentWindowTitle, widgetsList, showCodeButton] row in
            let idx = row.index
            guard idx >= 0, Int(idx) < compositeExamples.count else { return }
            let example = compositeExamples[Int(idx)]
            contentStack.visibleChildName = example.id
            contentWindowTitle.title = example.name
            showCodeButton.visible = true
            widgetsList.unselectAll()
        }

        widgetsList.onRowActivated { [contentStack, contentWindowTitle, compositeList, showCodeButton] row in
            let idx = row.index
            guard idx >= 0, Int(idx) < widgetExamples.count else { return }
            let example = widgetExamples[Int(idx)]
            contentStack.visibleChildName = example.id
            contentWindowTitle.title = example.name
            showCodeButton.visible = true
            compositeList.unselectAll()
        }

        let sidebarScroll = ScrolledWindow()
        sidebarScroll.child = sidebarBox
        sidebarScroll.setPolicy(horizontal: .never, vertical: .automatic)

        let sidebarHeaderBar = HeaderBar()
        let sidebarTitle = Label("Examples")
        sidebarTitle.addCSSClass("heading")
        sidebarHeaderBar.titleWidget = sidebarTitle

        let sidebarToolbar = ToolbarView()
        sidebarToolbar.addTopBar(sidebarHeaderBar)
        sidebarToolbar.content = sidebarScroll

        // -- Main layout --
        let splitView = OverlaySplitView()
        splitView.sidebar = sidebarToolbar
        splitView.content = contentToolbar
        splitView.pinSidebar = true
        splitView.sidebarWidthFraction = 0.28

        window.setContent(splitView)
        window.present()
    }

    app.run()
}

buildApp()
