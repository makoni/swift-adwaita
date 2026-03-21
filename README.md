# swift-adwaita

An imperative Swift 6.2 wrapper for [GTK4](https://docs.gtk.org/gtk4/) and [libadwaita](https://gnome.pages.gitlab.gnome.org/libadwaita/doc/latest/), designed for building native GNOME desktop applications.

## Features

- **Imperative API** — no declarative DSL; create and configure widgets directly
- **74 generated Adwaita wrappers** — `ActionRow`, `OverlaySplitView`, `TabView`, `Carousel`, `Toast`, and more
- **22 hand-written GTK wrappers** — `Button`, `Box`, `Label`, `Entry`, `ListBox`, `Stack`, `Scale`, `TextView`, etc.
- **49 signals** — type-safe signal connections with `@MainActor` closures
- **Property bindings** — `GObjectRef.bind()` for `g_object_bind_property`
- **CSS support** — `CSSProvider` for custom stylesheets
- **Swift 6.2 concurrency** — full `@MainActor` isolation, `Sendable` widget types
- **Code generator** — GIR-based generator produces wrappers from introspection data

## Requirements

- Swift 6.2+
- libadwaita 1.x (`libadwaita-1-dev` on Ubuntu/Debian, `libadwaita` on Fedora/Arch)
- Linux (GTK4 is Linux-native)

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/nicegamer7/swift-adwaita.git", branch: "main"),
],
targets: [
    .executableTarget(
        name: "MyApp",
        dependencies: [
            .product(name: "Adwaita", package: "swift-adwaita"),
        ]
    ),
]
```

## Quick Start

```swift
import Adwaita
import CAdwaita

@MainActor
func buildApp() {
    let app = Application(id: "com.example.HelloWorld")

    app.onActivate {
        let window = ApplicationWindow(application: app)
        window.title = "Hello"
        window.defaultWidth = 400
        window.defaultHeight = 300

        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 12)
        box.setMargins(24)

        let label = Label("Hello from swift-adwaita!")
        label.addCSSClass("title-1")
        box.append(label)

        let button = Button(label: "Click Me")
        button.onClicked {
            label.text = "Button clicked!"
        }
        box.append(button)

        window.setContent(box)
        window.present()
    }

    app.run()
}

buildApp()
```

## Architecture

The library has a three-layer architecture:

```
CAdwaita          — system module importing libadwaita via pkg-config
    ↓
GObjectSupport    — GObject lifecycle management (ref counting, signals, GValue)
    ↓
Adwaita           — Swift widget wrappers (generated + hand-written)
```

### Key Types

| Type | Description |
|------|-------------|
| `GObjectRef` | Base class managing GObject lifecycle with ref counting |
| `Widget` | Base class for all GTK/Adwaita widgets |
| `SignalConnection` | Handle for connected signals (supports disconnect) |
| `Application` | `AdwApplication` wrapper — entry point for apps |
| `ApplicationWindow` | Main application window |

### Widget Categories

**Layout:** `Box`, `Stack`, `Overlay`, `FlowBox`, `Clamp`, `OverlaySplitView`, `NavigationView`

**Input:** `Button`, `Entry`, `Switch`, `CheckButton`, `ToggleButton`, `Scale`, `SpinRow`, `SearchEntry`

**Display:** `Label`, `Image`, `Spinner`, `ProgressBar`, `LevelBar`, `Avatar`, `Banner`

**Lists:** `ListBox`, `ActionRow`, `ExpanderRow`, `ComboRow`, `SwitchRow`, `PreferencesGroup`

**Containers:** `ScrolledWindow`, `ToolbarView`, `HeaderBar`, `TabView`, `Carousel`, `BottomSheet`

**Dialogs:** `AlertDialog`, `Dialog`, `AboutDialog`, `PreferencesDialog`

**Feedback:** `Toast`, `ToastOverlay`

## Demo App

A built-in demo app showcases all widgets with interactive examples and source code:

```bash
swift run DemoApp
```

The demo includes 20 examples organized into composite layouts and individual widgets, with a "Show Code" button for each example.

## Signals

Connect to widget signals with closures:

```swift
let button = Button(label: "Save")
button.onClicked {
    print("Saved!")
}

let entry = Entry()
entry.onChanged {
    print("Text: \(entry.text)")
}

// Disconnect later
let connection = button.onClicked { ... }
connection.disconnect()
```

## Custom CSS

```swift
let css = CSSProvider()
css.loadFromString("""
    .my-button {
        background: #3584e4;
        color: white;
        border-radius: 12px;
    }
""")
css.addToDefaultDisplay()

let button = Button(label: "Styled")
button.addCSSClass("my-button")
```

## Building

```bash
# Install dependencies (Ubuntu/Debian)
sudo apt install libadwaita-1-dev

# Build
swift build

# Run tests
swift test

# Run demo
swift run DemoApp
```

## License

MIT
