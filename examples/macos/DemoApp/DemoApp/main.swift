import Adwaita

// Minimal swift-adwaita application packaged as a macOS .app bundle.
//
// The Xcode project deliberately drives `Adwaita.Application.run()` directly
// instead of `NSApplicationMain` / `@main`: GTK4's Quartz backend installs its
// own `NSApplication` and runs GLib's main loop, and a second Cocoa runloop
// driving `DispatchQueue.main` would conflict with it (see the project's
// `MainContext.swift` documentation for the gory details).

let app = Application(id: "me.spaceinbox.swift-adwaita.DemoApp")

app.onActivate {
    let window = ApplicationWindow(application: app)
    window.title = "swift-adwaita on macOS"
    window.defaultWidth = 480
    window.defaultHeight = 320

    let toolbar = ToolbarView()
    toolbar.addTopBar(HeaderBar())

    let box = Box(orientation: .vertical, spacing: 18)
    box.setMargins(36)
    box.halign = .center
    box.valign = .center

    let title = Label("Hello from libadwaita")
        .cssClass(.title1)
    box.append(title)

    let subtitle = Label("Built with Xcode, packaged as a .app bundle.")
        .cssClass(.dimLabel)
    box.append(subtitle)

    let counterLabel = Label("Clicked 0 times")
        .cssClass(.body)
    box.append(counterLabel)

    var clicks = 0
    let button = Button(label: "Click me")
        .cssClass(.suggestedAction)
        .cssClass(.pill)
        .halign(.center)
    button.onClicked {
        clicks += 1
        counterLabel.text = "Clicked \(clicks) time\(clicks == 1 ? "" : "s")"
    }
    box.append(button)

    toolbar.setContent(box)
    window.setContent(toolbar)
    window.present()
}

// Strip everything but argv[0] before handing the args to GApplication.
// Xcode injects flags like `-NSDocumentRevisionsDebugMode YES` and
// `-NSDocumentRevisionsDebugMode -ApplePersistenceIgnoreState` when
// launching a debug session, and GApplication aborts immediately on the
// first unknown option ("Unknown option …"). The binary still has to
// know its own name, so we keep argv[0].
let executableName = CommandLine.arguments.first ?? "DemoApp"
_ = app.run(arguments: [executableName])
