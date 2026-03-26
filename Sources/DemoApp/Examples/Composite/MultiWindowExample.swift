import Adwaita

@MainActor
struct MultiWindowExample: DemoExample {
    let name = "Multi-Window"
    let id = "multiwindow"
    let category: ExampleCategory = .composite
    let opensInWindow = true

    let sourceCode = """
    // Get the running application instance
    guard let app = Application.current else { return }

    // Create a secondary window
    let secondary = ApplicationWindow(application: app)
    secondary.title = "Secondary Window"
    secondary.defaultWidth = 400
    secondary.defaultHeight = 300

    // Make it transient to the main window
    secondary.transientFor = mainWindow.cast(GtkWindow.self)

    let content = StatusPage()
    content.title = "I'm a secondary window!"
    content.iconName = "window-new-symbolic"
    secondary.setContent(content)
    secondary.present()
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        // Window counter
        var windowCount = 0

        let counterLabel = Label("Windows opened: 0")
        counterLabel.addCSSClass("title-4")

        // New Window section
        let group1 = PreferencesGroup()
        group1.title = "Create Windows"
        group1.description = "Open secondary windows that are transient to this one"

        let row1 = ActionRow()
        row1.title = "New Transient Window"
        row1.subtitle = "Opens a child window linked to this one"
        let newWindowBtn = Button(label: "Open")
        newWindowBtn.valign = .center
        newWindowBtn.addCSSClass("suggested-action")
        newWindowBtn.onClicked { [counterLabel] in
            windowCount += 1

            guard let app = Application.current else { return }

            let secondary = ApplicationWindow(application: app)
            secondary.title = "Window #\(windowCount)"
            secondary.defaultWidth = 400
            secondary.defaultHeight = 300

            // Make the new window transient to the current window
            if let root = newWindowBtn.root {
                secondary.transientFor = root.cast(GtkWindow.self)
            }

            // Build content for the secondary window
            let toolbar = ToolbarView()
            let headerBar = HeaderBar()
            let titleWidget = WindowTitle(
                title: "Window #\(windowCount)",
                subtitle: "Transient child window"
            )
            headerBar.titleWidget = titleWidget
            toolbar.addTopBar(headerBar)

            let page = StatusPage()
            page.iconName = "window-new-symbolic"
            page.title = "Secondary Window #\(windowCount)"
            page.description = "This window is transient to the parent.\nClosing the parent will also close this window."

            let closeBtn = Button(label: "Close This Window")
            closeBtn.addCSSClass("pill")
            closeBtn.halign = .center
            closeBtn.onClicked { [weak closeBtn] in
                closeBtn?.closeWindow()
            }
            page.child = closeBtn
            toolbar.content = page

            secondary.setContent(toolbar)
            secondary.destroyWithParent = true
            secondary.present()
            secondary.retainUntilClose()

            counterLabel.text = "Windows opened: \(windowCount)"
        }
        row1.addSuffix(newWindowBtn)
        row1.activatableWidget = newWindowBtn
        group1.add(row1)

        let row2 = ActionRow()
        row2.title = "New Modal Dialog Window"
        row2.subtitle = "Opens a modal window that blocks interaction with the parent"
        let modalBtn = Button(label: "Open")
        modalBtn.valign = .center
        modalBtn.onClicked { [counterLabel] in
            windowCount += 1

            guard let app = Application.current else { return }

            let modal = ApplicationWindow(application: app)
            modal.title = "Modal #\(windowCount)"
            modal.defaultWidth = 350
            modal.defaultHeight = 250
            modal.modal = true

            if let root = modalBtn.root {
                modal.transientFor = root.cast(GtkWindow.self)
            }

            let toolbar = ToolbarView()
            let headerBar = HeaderBar()
            headerBar.titleWidget = WindowTitle(
                title: "Modal #\(windowCount)",
                subtitle: "Modal window"
            )
            toolbar.addTopBar(headerBar)

            let page = StatusPage()
            page.iconName = "dialog-information-symbolic"
            page.title = "Modal Window"
            page.description = "This is a modal window.\nYou must close it before interacting with the parent."

            let dismissBtn = Button(label: "Dismiss")
            dismissBtn.addCSSClass("suggested-action")
            dismissBtn.addCSSClass("pill")
            dismissBtn.halign = .center
            dismissBtn.onClicked { [weak dismissBtn] in
                dismissBtn?.closeWindow()
            }
            page.child = dismissBtn
            toolbar.content = page

            modal.setContent(toolbar)
            modal.destroyWithParent = true
            modal.present()
            modal.retainUntilClose()

            counterLabel.text = "Windows opened: \(windowCount)"
        }
        row2.addSuffix(modalBtn)
        row2.activatableWidget = modalBtn
        group1.add(row2)

        box.append(group1)

        // Info section
        let group2 = PreferencesGroup()
        group2.title = "Window Info"

        let infoRow = ActionRow()
        infoRow.title = "Total windows created"
        infoRow.addSuffix(counterLabel)
        group2.add(infoRow)

        let noteRow = ActionRow()
        noteRow.title = "transientFor"
        noteRow.subtitle = "Links child windows to their parent so the window manager can position and stack them correctly"
        let checkIcon = Image(iconName: "emblem-ok-symbolic")
        checkIcon.valign = .center
        checkIcon.addCSSClass("success")
        noteRow.addSuffix(checkIcon)
        group2.add(noteRow)

        let modalNoteRow = ActionRow()
        modalNoteRow.title = "modal"
        modalNoteRow.subtitle = "When true, the window blocks interaction with its transient parent"
        let checkIcon2 = Image(iconName: "emblem-ok-symbolic")
        checkIcon2.valign = .center
        checkIcon2.addCSSClass("success")
        modalNoteRow.addSuffix(checkIcon2)
        group2.add(modalNoteRow)

        box.append(group2)

        let headerBar = HeaderBar()
        let toolbarView = ToolbarView()
        toolbarView.addTopBar(headerBar)
        toolbarView.content = box.scrollableClamped()

        return toolbarView
    }
}
