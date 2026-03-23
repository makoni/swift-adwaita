import Adwaita

@MainActor
struct MenuBarExample: DemoExample {
    let name = "Menu Bar"
    let id = "menubar"
    let category: ExampleCategory = .composite
    let opensInWindow = true

    let sourceCode = """
    // Build menu model
    let fileMenu = GMenuRef()
    fileMenu.append("New", action: "win.new")
    fileMenu.append("Open...", action: "win.open")
    fileMenu.append("Save", action: "win.save")

    let editMenu = GMenuRef()
    editMenu.append("Cut", action: "win.cut")
    editMenu.append("Copy", action: "win.copy")
    editMenu.append("Paste", action: "win.paste")

    let menuModel = GMenuRef()
    menuModel.appendSubmenu("File", submenu: fileMenu)
    menuModel.appendSubmenu("Edit", submenu: editMenu)

    let menuBar = PopoverMenuBar(model: menuModel)
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 0)

        // Build the menu model
        let fileMenu = GMenuRef()
        fileMenu.append("New", action: "bar.new")
        fileMenu.append("Open...", action: "bar.open")
        fileMenu.append("Save", action: "bar.save")
        fileMenu.append("Quit", action: "bar.quit")

        let editMenu = GMenuRef()
        editMenu.append("Cut", action: "bar.cut")
        editMenu.append("Copy", action: "bar.copy")
        editMenu.append("Paste", action: "bar.paste")
        editMenu.append("Select All", action: "bar.selectall")

        let viewMenu = GMenuRef()
        viewMenu.append("Zoom In", action: "bar.zoomin")
        viewMenu.append("Zoom Out", action: "bar.zoomout")
        viewMenu.append("Reset Zoom", action: "bar.resetzoom")

        let helpMenu = GMenuRef()
        helpMenu.append("Documentation", action: "bar.docs")
        helpMenu.append("About", action: "bar.about")

        let menuModel = GMenuRef()
        menuModel.appendSubmenu("File", submenu: fileMenu)
        menuModel.appendSubmenu("Edit", submenu: editMenu)
        menuModel.appendSubmenu("View", submenu: viewMenu)
        menuModel.appendSubmenu("Help", submenu: helpMenu)

        let menuBar = PopoverMenuBar(model: menuModel)

        // Status label
        let statusLabel = Label("Select a menu item")
        statusLabel.addCSSClass("title-3")
        statusLabel.vexpand = true
        statusLabel.valign = .center
        statusLabel.halign = .center

        box.append(menuBar)
        box.append(statusLabel)

        // Create actions
        let actionGroup = SimpleActionGroup()
        let actionNames = [
            "new", "open", "save", "quit",
            "cut", "copy", "paste", "selectall",
            "zoomin", "zoomout", "resetzoom",
            "docs", "about",
        ]
        for name in actionNames {
            let action = SimpleAction(name: name)
            let actionName = name
            action.onActivate { [statusLabel] in
                statusLabel.text = "\(actionName) activated!"
            }
            actionGroup.addAction(action)
        }
        box.insertActionGroup("bar", actionGroup)

        return box
    }
}
