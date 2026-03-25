# Getting Started

Build your first GNOME desktop application with swift-adwaita.

## Overview

This guide walks you through creating a minimal Adwaita application, adding
widgets, handling signals, and applying styles.

### Create a SwiftPM project

```bash
mkdir MyApp && cd MyApp
swift package init --type executable
```

Edit `Package.swift`:

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MyApp",
    dependencies: [
        .package(url: "https://github.com/makoni/swift-adwaita.git", branch: "main"),
    ],
    targets: [
        .executableTarget(
            name: "MyApp",
            dependencies: [
                .product(name: "Adwaita", package: "swift-adwaita"),
            ]
        ),
    ]
)
```

### Create the application

Every Adwaita app starts with an ``Application`` and an ``ApplicationWindow``:

```swift
import Adwaita

let app = Application(id: "com.example.MyApp")

app.onActivate {
    let window = ApplicationWindow(application: app)
    window.title = "My App"
    window.defaultWidth = 600
    window.defaultHeight = 400
    window.present()
}

app.run()
```

### Add a toolbar and content

Most Adwaita windows use a ``ToolbarView`` with a ``HeaderBar`` as the top bar:

```swift
app.onActivate {
    let window = ApplicationWindow(application: app)
    window.title = "My App"
    window.defaultWidth = 600
    window.defaultHeight = 400

    let toolbar = ToolbarView()
    toolbar.addTopBar(HeaderBar())

    let label = Label("Welcome!")
        .cssClass(.title1)
        .halign(.center)
        .valign(.center)
        .hexpand()
        .vexpand()
    toolbar.setContent(label)

    window.setContent(toolbar)
    window.present()
}
```

### Handle signals

Widgets emit signals when the user interacts with them. Connect handlers
using the `on...` methods:

```swift
let button = Button(label: "Click Me")

button.onClicked {
    print("Button was clicked!")
}
```

Signal handlers return a `SignalConnection` that you can use to disconnect
later:

```swift
let connection = button.onClicked {
    print("Clicked!")
}

// Later, disconnect the handler:
connection.disconnect()
```

### Use fluent setters

Every widget supports fluent setter methods for layout properties. These
return `self` so you can chain them:

```swift
let label = Label("Centered text")
    .halign(.center)
    .valign(.center)
    .hexpand()
    .vexpand()
    .margins(12)
    .cssClass(.body)
```

### Apply CSS classes

Use ``CSSClass`` for type-safe styling:

```swift
let button = Button(label: "Delete")
button.addCSSClass(.destructiveAction)

let heading = Label("Title")
heading.addCSSClass(.title1)
```

Or use the fluent `.cssClass()` method:

```swift
let button = Button(label: "Save")
    .cssClass(.suggestedAction)
    .cssClass(.pill)
```

### Load custom CSS

Use ``CSSProvider`` to load your own stylesheets:

```swift
let css = CSSProvider()
css.loadFromString("""
    .my-widget {
        background-color: @accent_bg_color;
        border-radius: 12px;
        padding: 24px;
    }
""")

let box = Box(orientation: .vertical, spacing: 0)
box.addCSSClass("my-widget")
```

### Build a list with preferences rows

``PreferencesGroup`` and ``ActionRow`` are the standard way to build
settings-style UIs:

```swift
let group = PreferencesGroup()
group.title = "Account"
group.description = "Manage your account settings"

let nameRow = ActionRow()
nameRow.title = "Display Name"
nameRow.subtitle = "John Doe"

let emailRow = ActionRow()
emailRow.title = "Email"
emailRow.subtitle = "john@example.com"

let toggle = Switch()
toggle.valign = .center
let notifyRow = ActionRow()
notifyRow.title = "Notifications"
notifyRow.subtitle = "Receive desktop notifications"
notifyRow.addSuffix(toggle)
notifyRow.activatableWidget = toggle

group.add(nameRow)
group.add(emailRow)
group.add(notifyRow)
```

### Respond to property changes

Observe any GObject property with `onNotify(_:handler:)`:

```swift
let entry = Entry()

entry.onNotify(.text) {
    print("Text changed to: \(entry.text)")
}
```

### Keyboard shortcuts

Add keyboard shortcuts directly to any widget:

```swift
window.addKeyboardShortcut(key: .q, modifiers: .control) {
    app.quit()
    return true
}
```

### Next steps

Explore the widget catalog in the sidebar — every class has inline code
examples in its documentation. The `DemoApp` target in the repository
is a runnable showcase of all widgets.
