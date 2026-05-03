import Adwaita
import Foundation

#if canImport(Darwin)
import Darwin
#endif

/// Ensures GLib can find Homebrew's compiled GSettings schemas even when
/// `XDG_DATA_DIRS` is inherited from a shell that does not include the
/// Homebrew share path (e.g. Ghostty / iTerm with their own profile).
///
/// Info.plist's `LSEnvironment` is only honoured by Launch Services when
/// the variable is not already set in the parent process — which is what
/// makes `open DemoApp.app` from a normal terminal session crash inside
/// `gtk_emoji_chooser_init` on a missing `org.gtk.gtk4.emoji-chooser`
/// schema. Setting the path programmatically here, before `gtk_init`,
/// is the only macOS-portable fix that does not require a launcher shim.
@MainActor
private func ensureHomebrewSchemasOnPath() {
    #if os(macOS)
    let prefix = "/opt/homebrew/share"
    let intel = "/usr/local/share"
    let existing = ProcessInfo.processInfo.environment["XDG_DATA_DIRS"] ?? ""
    let parts = existing.split(separator: ":").map(String.init)
    let candidates = [prefix, intel].filter { FileManager.default.fileExists(atPath: $0) }
    let missing = candidates.filter { !parts.contains($0) }
    guard !missing.isEmpty else { return }
    let combined = (missing + parts).joined(separator: ":")
    setenv("XDG_DATA_DIRS", combined, 1)
    #endif
}

private nonisolated(unsafe) var demoIconsRegistered = false

@MainActor
private func registerDemoIcons(for display: Display) {
    guard !demoIconsRegistered else { return }

    let fileManager = FileManager.default
    let candidatePaths = [
        Bundle.module.resourceURL?
            .appendingPathComponent("Resources", isDirectory: true)
            .appendingPathComponent("icons", isDirectory: true),
        Bundle.module.resourceURL?
            .appendingPathComponent("icons", isDirectory: true)
    ].compactMap(\.self)

    guard let iconsPath = candidatePaths.first(where: { fileManager.fileExists(atPath: $0.path) }) else {
        assertionFailure("DemoApp icon resources were not found in the resource bundle.")
        return
    }

    display.iconTheme.addSearchPath(iconsPath.path)
    demoIconsRegistered = true
}

/// Builds and runs the swift-adwaita example gallery.
///
/// This is the public entry point exposed by ``DemoAppLib`` so that the
/// Sources/DemoApp executable target, the macOS Xcode example, and any
/// downstream embedder can launch the same gallery in-process.
///
/// - Parameter arguments: Argument vector handed to `g_application_run`.
///   Pass `[CommandLine.arguments[0]]` from an Xcode `main.swift` to keep
///   GApplication from choking on Xcode's debug-only `-NSDocumentRevisionsDebugMode`
///   / `-ApplePersistenceIgnoreState` flags.
/// - Returns: The exit code from `g_application_run`. Hand it to `exit(_:)`
///   or use it as the process exit status.
@MainActor
@discardableResult
public func runDemoApp(arguments: [String] = CommandLine.arguments) -> Int {
    ensureHomebrewSchemasOnPath()

    // GTK 4 emits spurious `Trying to snapshot … without a current allocation`
    // warnings from internal GtkScrolledWindow / GtkScrollbar children at
    // certain allocation boundaries. The helper below filters just those
    // and leaves every other log message alone.
    MainContext.silenceSpuriousScrollbarWarnings()

    let app = Application(id: "io.github.makoni.SwiftAdwaitaDemo")

    app.onActivate {
        let window = ApplicationWindow(application: app)
        registerDemoIcons(for: window.display)
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
            if example.opensInWindow {
                let preview = StatusPage()
                preview.iconName = "preferences-desktop-remote-desktop-symbolic"
                preview.title = example.name
                preview.description = "This example opens in its own window to showcase window-level features."
                let tryBtn = Button(label: "Try It")
                tryBtn.addCSSClass("suggested-action")
                tryBtn.addCSSClass("pill")
                tryBtn.halign = .center
                tryBtn.onClicked { [window] in
                    let demoWindow = Window()
                    demoWindow.title = example.name
                    demoWindow.defaultWidth = 700
                    demoWindow.defaultHeight = 500
                    demoWindow.content = example.buildWidget()
                    demoWindow.transientFor = window
                    demoWindow.destroyWithParent = true
                    demoWindow.present()
                }
                preview.child = tryBtn
                contentStack.addNamed(preview, name: example.id)
            } else {
                let widget = example.buildWidget()
                widget.hexpand = true
                widget.vexpand = true
                contentStack.addNamed(widget, name: example.id)
            }
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

        // Search entry
        let searchEntry = SearchEntry()
        searchEntry.placeholderText = "Search examples…"
        searchEntry.setMargins(6)
        sidebarBox.append(searchEntry)

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

        // Search filtering
        searchEntry.onSearchChanged { [compositeList, widgetsList, compositeHeading, widgetsHeading] in
            let query = searchEntry.text.lowercased()

            compositeList.setFilterFunc { row in
                guard !query.isEmpty else { return true }
                let idx = Int(row.index)
                guard idx >= 0, idx < compositeExamples.count else { return true }
                return compositeExamples[idx].name.lowercased().contains(query)
            }
            compositeList.invalidateFilter()

            widgetsList.setFilterFunc { row in
                guard !query.isEmpty else { return true }
                let idx = Int(row.index)
                guard idx >= 0, idx < widgetExamples.count else { return true }
                return widgetExamples[idx].name.lowercased().contains(query)
            }
            widgetsList.invalidateFilter()

            // Hide section headings when all rows are filtered out or show them
            if query.isEmpty {
                compositeHeading.visible = true
                widgetsHeading.visible = true
            } else {
                let hasComposite = compositeExamples.contains { $0.name.lowercased().contains(query) }
                let hasWidgets = widgetExamples.contains { $0.name.lowercased().contains(query) }
                compositeHeading.visible = hasComposite
                widgetsHeading.visible = hasWidgets
            }
        }

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

    return app.run(arguments: arguments)
}
