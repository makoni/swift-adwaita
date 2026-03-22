# swift-adwaita

An imperative Swift 6.2 wrapper for [GTK4](https://docs.gtk.org/gtk4/) and [libadwaita](https://gnome.pages.gitlab.gnome.org/libadwaita/doc/latest/), designed for building native GNOME desktop applications.

## Features

- **Imperative API** — no declarative DSL; create and configure widgets directly
- **141 widget wrappers** — 74 auto-generated Adwaita + 67 hand-written GTK widgets
- **Type-safe signals** — 20+ signal signatures with `@MainActor` closures
- **Keyboard shortcuts** — enum-based `Key` + `KeyModifiers` API
- **Property bindings** — `GObjectRef.bind()` for reactive connections
- **Menus & actions** — `GMenuRef`, `SimpleAction`, `MenuButton`
- **Drag & drop** — `DragSource`, `DropTarget`
- **File dialogs** — async open/save/folder with `FileDialog`
- **Clipboard** — copy/paste with `Clipboard`
- **CSS support** — `CSSProvider` for custom stylesheets
- **Animations** — `TimedAnimation`, `SpringAnimation` with callbacks
- **Drawing** — `DrawingArea` with Cairo
- **Swift 6.2 concurrency** — full `@MainActor` isolation, `Sendable` types
- **386 tests**, **67 demo examples**

## Requirements

- Swift 6.2+
- libadwaita 1.4+ development headers
- Linux

### Ubuntu/Debian

```bash
sudo apt install libadwaita-1-dev
```

### Fedora

```bash
sudo dnf install libadwaita-devel
```

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/nicegram/swift-adwaita.git", branch: "main"),
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

@MainActor
func buildApp() {
    let app = Application(id: "com.example.HelloWorld")

    app.onActivate {
        let window = ApplicationWindow(application: app)
        window.title = "Hello"
        window.defaultWidth = 400
        window.defaultHeight = 300

        let box = Box(orientation: .vertical, spacing: 12)
        box.setMargins(24)

        let label = Label("Hello from swift-adwaita!")
        label.addCSSClass("title-1")
        box.append(label)

        let button = Button(label: "Click Me")
        button.addCSSClass("suggested-action")
        button.addCSSClass("pill")
        button.halign = .center
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

Three-layer design:

```
CAdwaita          System library (pkg-config: libadwaita-1)
  |
GObjectSupport    GObject lifecycle (ARC), signals, GValue
  |
Adwaita           Widget wrappers (74 generated + 67 hand-written)
```

### Key Types

| Type | Description |
|------|-------------|
| `GObjectRef` | Base class — GObject lifecycle with ARC |
| `Widget` | Base for all GTK/Adwaita widgets |
| `SignalConnection` | Handle for signal connections |
| `Application` | App entry point (`AdwApplication`) |
| `ApplicationWindow` | Main window |

### Widget Categories

**Layout:** `Box`, `Stack`, `Grid`, `Overlay`, `FlowBox`, `Clamp`, `Paned`, `WrapBox`, `CenterBox`, `Fixed`

**Navigation:** `NavigationView`, `NavigationSplitView`, `OverlaySplitView`, `TabView`, `ViewSwitcher`, `Notebook`, `Carousel`

**Input:** `Button`, `Entry`, `Switch`, `CheckButton`, `ToggleButton`, `Scale`, `SpinRow`, `SearchEntry`, `DropDown`, `Calendar`, `ToggleGroup`

**Display:** `Label`, `Image`, `Picture`, `Spinner`, `ProgressBar`, `LevelBar`, `Avatar`, `Banner`, `Separator`, `Video`

**Lists:** `ListBox`, `ActionRow`, `ExpanderRow`, `ComboRow`, `SwitchRow`, `ButtonRow`, `PreferencesGroup`

**Containers:** `ScrolledWindow`, `ToolbarView`, `HeaderBar`, `BottomSheet`, `Frame`, `Expander`, `Revealer`, `ActionBar`

**Dialogs:** `AlertDialog`, `Dialog`, `AboutDialog`, `PreferencesDialog`, `FileDialog`

**Menus:** `MenuButton`, `PopoverMenu`, `PopoverMenuBar`, `SplitButton`, `GMenuRef`, `SimpleAction`

**Event Controllers:** `GestureClick`, `GestureDrag`, `GestureLongPress`, `EventControllerKey`, `EventControllerMotion`, `EventControllerScroll`, `EventControllerFocus`, `DragSource`, `DropTarget`, `ShortcutController`

**Feedback:** `Toast`, `ToastOverlay`, `EmojiChooser`

**Styling:** `CSSProvider`, `StyleManager`

**Animation:** `TimedAnimation`, `SpringAnimation`, `CallbackAnimationTarget`, `PropertyAnimationTarget`

## Examples

### Keyboard Shortcuts

```swift
// Enum-based API
button.addKeyboardShortcut(key: .s, modifiers: .control) {
    print("Save!")
    return true
}

// Multiple modifiers
widget.addKeyboardShortcut(key: .z, modifiers: [.control, .shift]) {
    print("Redo!")
    return true
}

// ShortcutController for grouped shortcuts
let controller = ShortcutController()
controller.addShortcut(key: .n, modifiers: .control) {
    print("New!")
    return true
}
widget.addController(controller)
```

### Menus & Actions

```swift
let menu = GMenuRef()
menu.append("Cut", action: "win.cut")
menu.append("Copy", action: "win.copy")

let menuBtn = MenuButton()
menuBtn.iconName = "open-menu-symbolic"
menuBtn.setMenuModel(menu)

let action = SimpleAction(name: "cut")
action.onActivate { print("Cut!") }
window.addAction(action)
```

### Property Binding

```swift
switch1.bind("active", to: switch2, property: "active",
    flags: G_BINDING_SYNC_CREATE)
```

### File Dialog

```swift
let dialog = FileDialog()
dialog.title = "Open File"
dialog.setFilters([
    FileFilter(name: "Swift files", suffixes: ["swift"]),
    FileFilter(name: "All files", patterns: ["*"]),
])
dialog.open(parent: window) { path in
    if let path { print("Selected: \(path)") }
}
```

### Drag & Drop

```swift
// Drag source
let drag = DragSource()
drag.setTextContent("Hello!")
sourceWidget.addController(drag)

// Drop target
let drop = DropTarget.forText()
drop.onDrop { text in
    if let text { label.text = text }
    return true
}
targetWidget.addController(drop)
```

### Custom CSS

```swift
CSSProvider.loadGlobal("""
.my-widget {
    background: linear-gradient(135deg, @accent_bg_color, @headerbar_bg_color);
    border-radius: 12px;
    padding: 24px;
}
""")
widget.addCSSClass("my-widget")
```

### Signals

```swift
let button = Button(label: "Save")
button.onClicked {
    print("Saved!")
}

// Disconnect later
let connection = button.onClicked { ... }
connection.disconnect()
```

## Demo App

An interactive gallery with 67 examples showcasing every widget:

```bash
swift run DemoApp
```

Features sidebar search, source code viewer, and windowed demos for navigation/window-level widgets.

## Building

```bash
swift build       # Build library
swift test        # Run 386 tests
swift run DemoApp # Launch demo gallery
```

## License

Apache License 2.0. See [LICENSE.txt](LICENSE.txt).
