# swift-adwaita

An imperative Swift 6.2 wrapper for [GTK4](https://docs.gtk.org/gtk4/) and [libadwaita](https://gnome.pages.gitlab.gnome.org/libadwaita/doc/latest/), designed for building native GNOME desktop applications.

## Features

- **Imperative API** — no declarative DSL; create and configure widgets directly
- **164 widget wrappers** — 74 auto-generated Adwaita + 90 hand-written GTK widgets
- **Zero raw pointers in public API** — all `OpaquePointer`/`gpointer` hidden behind Swift types
- **Type-safe signals** — 50+ signal signatures with `@MainActor` closures
- **Async/await** — `FileDialog.open()`, `UriLauncher.launch()`, `Clipboard.readText()`
- **Keyboard shortcuts** — enum-based `Key` + `KeyModifiers` API
- **Property bindings** — `GObjectRef.bind()` for reactive connections
- **Menus & actions** — `GMenuRef`, `SimpleAction`, `MenuButton`
- **Drag & drop** — `DragSource`, `DropTarget`
- **CSS support** — `CSSProvider` for custom stylesheets
- **Animations** — `TimedAnimation`, `SpringAnimation` with callbacks
- **Drawing** — `DrawingArea` with `CairoContext` wrapper
- **Text attributes** — `TextAttributes` for styling entry text (bold, italic, color)
- **Media playback** — `MediaStream`, `Video`, `MediaControls`
- **Swift 6.2 concurrency** — full `@MainActor` isolation, `Sendable` types
- **555 tests**, **76 demo examples**

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
  │
GObjectSupport    GObject lifecycle (ARC), signals, Variant, GValue
  │
Adwaita           Widget wrappers (74 generated + 90 hand-written)
```

### Key Types

| Type | Description |
|------|-------------|
| `GObjectRef` | Base class — GObject lifecycle with ARC |
| `Widget` | Base for all GTK/Adwaita widgets |
| `SignalConnection` | Handle for signal connections |
| `Application` | App entry point (`AdwApplication`) |
| `ApplicationWindow` | Main window |

### Protocols

| Protocol | Purpose | Conforming Types |
|----------|---------|-----------------|
| `ListModelConvertible` | Pass models to list views | `ListStore`, `StringList`, `FilterListModel`, `SortListModel`, `MapListModel`, `FlattenListModel`, `TreeListModel`, `SelectionFilterModel` |
| `SelectionModelConvertible` | Pass selection to views | `SingleSelection`, `MultiSelection`, `NoSelection` |
| `Swipeable` | Swipe gesture target | `Carousel`, `NavigationView`, `OverlaySplitView` |

### Widget Categories

**Layout:** `Box`, `Stack`, `Grid`, `Overlay`, `FlowBox`, `Clamp`, `Paned`, `WrapBox`, `CenterBox`, `Fixed`

**Navigation:** `NavigationView`, `NavigationSplitView`, `OverlaySplitView`, `TabView`, `ViewSwitcher`, `Notebook`, `Carousel`

**Input:** `Button`, `Entry`, `Switch`, `CheckButton`, `ToggleButton`, `Scale`, `SpinRow`, `SearchEntry`, `DropDown`, `Calendar`, `ToggleGroup`

**Display:** `Label`, `Image`, `Picture`, `Spinner`, `ProgressBar`, `LevelBar`, `Avatar`, `Banner`, `Separator`, `Video`

**Lists:** `ListBox`, `ActionRow`, `ExpanderRow`, `ComboRow`, `SwitchRow`, `ButtonRow`, `PreferencesGroup`

**Virtualized Lists:** `ListView`, `GridView`, `ColumnView` + `ListStore`, `StringList`, `SignalListItemFactory`, `TreeListModel`, `FilterListModel`, `SortListModel`

**Containers:** `ScrolledWindow`, `ToolbarView`, `HeaderBar`, `BottomSheet`, `Frame`, `Expander`, `Revealer`, `ActionBar`

**Dialogs:** `AlertDialog`, `Dialog`, `AboutDialog`, `PreferencesDialog`, `FileDialog`

**Menus:** `MenuButton`, `PopoverMenu`, `PopoverMenuBar`, `SplitButton`, `GMenuRef`, `SimpleAction`

**Event Controllers:** `GestureClick`, `GestureDrag`, `GestureLongPress`, `GestureSwipe`, `EventControllerKey`, `EventControllerMotion`, `EventControllerScroll`, `EventControllerFocus`, `DragSource`, `DropTarget`, `ShortcutController`

**Feedback:** `Toast`, `ToastOverlay`, `EmojiChooser`

**Styling:** `CSSProvider`, `StyleManager`, `TextAttributes`

**Animation:** `TimedAnimation`, `SpringAnimation`, `CallbackAnimationTarget`, `PropertyAnimationTarget`

**Media:** `MediaStream`, `Video`, `MediaControls`

**Drawing:** `DrawingArea`, `CairoContext`

**System:** `Clipboard`, `Display`, `Monitor`, `UriLauncher`

## Examples

### Async/Await

```swift
// File dialog
let dialog = FileDialog()
if let file = await dialog.open(parent: window) {
    print("Selected: \(file.path)")
}

// URI launcher
let launcher = UriLauncher(uri: "https://gnome.org")
let success = await launcher.launch()

// Clipboard
let text = await clipboard.readText()
```

### Drawing

```swift
let da = DrawingArea()
da.contentWidth = 200
da.contentHeight = 200
da.setDrawFunc { cr, width, height in
    cr.setSourceRGB(0.2, 0.4, 0.8)
    cr.roundedRectangle(x: 10, y: 10, width: 180, height: 180, radius: 20)
    cr.fill()
}
```

### Keyboard Shortcuts

```swift
button.addKeyboardShortcut(key: .s, modifiers: .control) {
    print("Save!")
    return true
}

widget.addKeyboardShortcut(key: .z, modifiers: [.control, .shift]) {
    print("Redo!")
    return true
}
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

### Text Attributes

```swift
let attrs = TextAttributes()
attrs.addBold()
attrs.addForegroundColor(red: 0.8, green: 0.2, blue: 0.2)
entryRow.textAttributes = attrs
```

### Virtualized Lists

```swift
var items = ["Apple", "Banana", "Cherry"]
let store = ListStore()
for _ in items { store.appendPlaceholder() }

let factory = SignalListItemFactory()
factory.onSetup { listItem in
    listItem.child = Label("")
}
factory.onBind { listItem in
    listItem.child?.cast(Label.self).text = items[listItem.position]
}

let selection = SingleSelection(model: store)
let listView = ListView(model: selection, factory: factory)
```

### Drag & Drop

```swift
let drag = DragSource()
drag.setTextContent("Hello!")
sourceWidget.addController(drag)

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

## Demo App

An interactive gallery with 76 examples showcasing every widget:

```bash
swift run DemoApp
```

Features sidebar navigation with search, source code viewer, and windowed demos for navigation/window-level widgets.

## Building

```bash
swift build       # Build library
swift test        # Run 555 tests
swift run DemoApp # Launch demo gallery
```

## License

Apache License 2.0. See [LICENSE.txt](LICENSE.txt).
