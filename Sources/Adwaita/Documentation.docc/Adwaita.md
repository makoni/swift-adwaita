# ``Adwaita``

An imperative Swift wrapper for GTK4 and libadwaita, providing native GNOME desktop application development.

## Overview

**swift-adwaita** gives you direct, imperative access to the full GTK4 and
libadwaita widget toolkit from Swift. Every widget is a class with mutable
properties and methods — no result builders, no declarative DSL, just
straightforward object-oriented code.

```swift
import Adwaita

let app = Application(id: "com.example.HelloWorld")

app.onActivate {
    let window = ApplicationWindow(application: app)
    window.title = "Hello"
    window.defaultWidth = 400
    window.defaultHeight = 300

    let toolbar = ToolbarView()
    toolbar.addTopBar(HeaderBar())

    let label = Label("Hello from swift-adwaita!")
        .cssClass(.title1)
        .halign(.center)
        .valign(.center)
        .hexpand()
        .vexpand()
    toolbar.setContent(label)

    window.setContent(toolbar)
    window.present()
}

app.run()
```

### Key features

- **74 Adw widgets + 102 GTK widgets** wrapped as Swift classes
- **Signals** — connect handlers with `onClicked`, `onActivate`, and 47 more
- **Fluent setters** — chain `.halign(.center).vexpand().cssClass(.pill)`
- **Type-safe CSS classes** — `CSSClass.destructiveAction`, `.title1`, `.pill`
- **GObject property observation** — `widget.onNotify(.text) { ... }`
- **Data binding** — `source.bind(.active, to: target, property: .sensitive)`
- **Keyboard shortcuts** — `window.addKeyboardShortcut(key: .q, modifiers: .control) { ... }`

### Requirements

- **Linux** with GTK4 and libadwaita installed
- **Swift 6.2+**
- System package: `libadwaita-1-dev` (apt) or equivalent

### Installation

Add swift-adwaita to your `Package.swift`:

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

Then `import Adwaita` — the library re-exports `GObjectSupport` and `CAdwaita`
automatically.

## Topics

### Essentials

- <doc:GettingStarted>
- ``Application``
- ``ApplicationWindow``
- ``Widget``

### Guides

- <doc:NavigationPatterns>
- <doc:WorkingWithDialogs>
- <doc:ListsAndData>
- <doc:ResponsiveLayouts>
- <doc:StylingAndTheming>
- <doc:MenusAndActions>
- <doc:FeedbackWidgets>
- <doc:AnimationsAndGestures>
- <doc:FlatpakDistribution>
- <doc:VersionCompatibility>

### Layout Containers

- ``Box``
- ``CenterBox``
- ``Grid``
- ``Paned``
- ``Fixed``
- ``Frame``
- ``Overlay``
- ``AspectFrame``
- ``Bin``
- ``Clamp``
- ``ClampLayout``
- ``ClampScrollable``
- ``ScrolledWindow``

### Navigation

- ``NavigationView``
- ``NavigationPage``
- ``NavigationSplitView``
- ``OverlaySplitView``
- ``Stack``
- ``StackSwitcher``

### Adaptive Layout

- ``Breakpoint``
- ``BreakpointCondition``
- ``BreakpointBin``
- ``MultiLayoutView``
- ``Layout``
- ``LayoutSlot``
- ``LayoutManager``
- ``WrapBox``
- ``WrapLayout``

### Toolbars and Headers

- ``ToolbarView``
- ``HeaderBar``
- ``WindowTitle``
- ``ActionBar``
- ``WindowControls``

### Buttons

- ``Button``
- ``ToggleButton``
- ``SplitButton``
- ``ButtonContent``
- ``ButtonRow``

### Text and Labels

- ``Label``
- ``Entry``
- ``EntryRow``
- ``PasswordEntryRow``
- ``SearchEntry``
- ``SearchBar``
- ``TextBuffer``
- ``TextView``
- ``TextTag``
- ``TextAttributes``

### Numeric Input

- ``SpinButton``
- ``SpinRow``
- ``Scale``
- ``LevelBar``

### Toggles and Selection

- ``Switch``
- ``SwitchRow``
- ``CheckButton``
- ``Toggle``
- ``ToggleGroup``

### List and Grid Views

- ``ListBox``
- ``ListBoxRow``
- ``ListView``
- ``GridView``
- ``ColumnView``
- ``ColumnViewColumn``
- ``FlowBox``
- ``ListItem``
- ``SignalListItemFactory``
- ``TreeExpander``
- ``TreeListModel``
- ``TreeListRow``
- ``ListScrollFlags``

### Preferences UI

- ``PreferencesDialog``
- ``PreferencesPage``
- ``PreferencesGroup``
- ``PreferencesRow``
- ``ActionRow``
- ``ExpanderRow``
- ``ComboRow``

### Dialogs and Popups

- ``Dialog``
- ``AlertDialog``
- ``AboutDialog``
- ``Popover``
- ``PopoverMenu``
- ``PopoverMenuBar``
- ``FileDialog``
- ``FileFilter``
- ``ColorDialog``
- ``ColorDialogButton``
- ``FontDialog``
- ``FontDialogButton``
- ``EmojiChooser``
- ``MenuButton``
- ``UriLauncher``

### Tabs

- ``TabView``
- ``TabPage``
- ``TabBar``
- ``TabButton``
- ``TabOverview``

### View Switching

- ``ViewStack``
- ``ViewStackPage``
- ``ViewStackPages``
- ``ViewSwitcher``
- ``ViewSwitcherBar``
- ``InlineViewSwitcher``

### Carousel

- ``Carousel``
- ``CarouselIndicatorDots``
- ``CarouselIndicatorLines``

### Display Widgets

- ``Image``
- ``Picture``
- ``Texture``
- ``Avatar``
- ``Spinner``
- ``SpinnerPaintable``
- ``StatusPage``
- ``Banner``
- ``Toast``
- ``ToastOverlay``
- ``ProgressBar``
- ``Separator``
- ``Expander``
- ``Calendar``
- ``DrawingArea``
- ``CairoContext``
- ``Video``
- ``MediaStream``
- ``MediaControls``
- ``Revealer``

### Animation

- ``Animation``
- ``TimedAnimation``
- ``SpringAnimation``
- ``SpringParams``
- ``AnimationTarget``
- ``CallbackAnimationTarget``
- ``PropertyAnimationTarget``
- ``SwipeTracker``

### Data Models

- ``ListStore``
- ``StringList``
- ``FilterListModel``
- ``CustomFilter``
- ``FlattenListModel``
- ``MapListModel``
- ``SortListModel``
- ``CustomSorter``
- ``EnumListModel``
- ``EnumListItem``

### Selection Models

- ``SingleSelection``
- ``MultiSelection``
- ``NoSelection``
- ``SelectionFilterModel``

### Event Controllers

- ``GestureClick``
- ``GestureDrag``
- ``GestureLongPress``
- ``GestureSwipe``
- ``DragSource``
- ``DropTarget``
- ``EventControllerKey``
- ``EventControllerFocus``
- ``EventControllerMotion``
- ``EventControllerScroll``
- ``ShortcutController``

### Keyboard Shortcuts (UI)

- ``ShortcutsDialog``
- ``ShortcutsSection``
- ``ShortcutsItem``
- ``ShortcutLabel``

### Styling

- ``CSSProvider``
- ``CSSClass``
- ``StyleManager``
- ``IconName``
- ``RGBA``

### Windows

- ``Window``
- ``GtkWindow``
- ``BottomSheet``

### System

- ``Monitor``
- ``Display``
- ``Clipboard``
- ``Adjustment``
- ``Settings``
- ``Notebook``

### Settings Persistence

- ``Setting``
- ``SettingValue``

### Protocols

- ``ListModelConvertible``
- ``SelectionModelConvertible``
- ``Container``
- ``Swipeable``

### Menus and Actions

- ``GMenuRef``
- ``GMenuItemRef``
- ``SimpleAction``
- ``SimpleActionGroup``

### Keyboard Input

- ``KeyModifiers``
- ``Key``
