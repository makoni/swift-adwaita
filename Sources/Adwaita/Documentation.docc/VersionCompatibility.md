# Version Compatibility

Understand which features require specific libadwaita versions.

## Overview

swift-adwaita supports libadwaita 1.5 and later. Newer libadwaita releases
introduce additional widgets and properties. The library uses failable
initializers and runtime version checks so your app compiles and runs on
any supported version — newer features simply return `nil` on older systems.

### Checking the runtime version

Use `AdwaitaVersion` to check what's available at runtime:

```swift
if AdwaitaVersion.isAtLeast(1, 6) {
    // libadwaita 1.6+ features are available
}
```

### libadwaita 1.5 (baseline)

All core widgets are available at this version, including:

- ``Application``, ``ApplicationWindow``, ``Window``
- ``HeaderBar``, ``ToolbarView``, ``WindowTitle``
- ``NavigationView``, ``NavigationSplitView``, ``OverlaySplitView``
- ``TabView``, ``TabBar``, ``TabOverview``
- ``Carousel``, ``ViewStack``, ``ViewSwitcher``
- ``StatusPage``, ``Banner``, ``Avatar``, ``Toast``, ``ToastOverlay``
- ``PreferencesDialog``, ``PreferencesPage``, ``PreferencesGroup``
- ``ActionRow``, ``SwitchRow``, ``EntryRow``, ``SpinRow``, ``ExpanderRow``, ``ComboRow``
- ``AlertDialog``, ``Dialog``, ``AboutDialog``
- ``Breakpoint``, ``BreakpointBin``
- ``TimedAnimation``, ``SpringAnimation``
- ``Clamp``, ``Bin``, ``MultiLayoutView``
- ``StyleManager``, ``InlineViewSwitcher``

All GTK4 widgets (``Box``, ``Button``, ``Label``, ``Entry``, ``ListBox``,
``ListView``, ``GridView``, ``ColumnView``, etc.) are available regardless
of libadwaita version.

### libadwaita 1.6

Widgets introduced in 1.6 use failable initializers:

```swift
// Returns nil on libadwaita < 1.6
guard let bottomSheet = BottomSheet() else {
    print("BottomSheet requires libadwaita 1.6+")
    return
}
bottomSheet.content = mainView
bottomSheet.sheet = detailPanel
bottomSheet.open = true
```

**New widgets:**
- ``BottomSheet`` — sliding sheet from the bottom edge
- ``Spinner`` — animated loading indicator (replaces GtkSpinner)
- ``SpinnerPaintable`` — paintable version for use in images
- ``ButtonRow`` — action row with a clickable button style

``ButtonRow`` overrides a non-failable parent init, so it uses a different
pattern:

```swift
guard ButtonRow.isAvailable else { return }
let row = ButtonRow()
row.title = "Delete"
```

### libadwaita 1.7

**New widgets:**
- ``Toggle`` — individual toggle within a ``ToggleGroup``
- ``ToggleGroup`` — mutually exclusive toggle group
- ``WrapBox`` — flow-layout container that wraps children to new lines

```swift
guard let group = ToggleGroup() else { return }
if let toggle1 = Toggle() {
    toggle1.label = "Option A"
    group.add(toggle1)
}
```

### libadwaita 1.8

**New widgets:**
- ``ShortcutsDialog`` — dialog for displaying keyboard shortcuts
- ``ShortcutsSection`` — section within a shortcuts dialog
- ``ShortcutsItem`` — individual shortcut entry
- ``ShortcutLabel`` — label displaying a keyboard accelerator

``ShortcutsDialog`` also overrides a non-failable parent init:

```swift
guard ShortcutsDialog.isAvailable else { return }
let dialog = ShortcutsDialog()
```

### Version-gated properties

Some existing widgets gained new properties in later versions. These
properties are always compiled but return default values (false, 0, nil)
on older runtimes via C stubs:

| Widget | Property | Since |
|--------|----------|-------|
| ``AlertDialog`` | `preferWideLayout` | 1.6 |
| ``BottomSheet`` | `revealBottomBar` | 1.7 |
| ``AboutDialog`` | `addOtherApp()` | 1.7 |
| ``ToastOverlay`` | `dismissAll()` | 1.7 |
| ``PreferencesGroup`` | `getRow()` | 1.8 |
| ``PreferencesPage`` | `getGroup()` | 1.8 |

### Distribution and version targeting

When distributing via Flatpak, the GNOME runtime version determines the
available libadwaita version:

| GNOME Runtime | libadwaita | Key additions |
|---------------|-----------|---------------|
| 44 | 1.4 | Baseline |
| 45 | 1.4 | Minor fixes |
| 46 | 1.5 | Ubuntu 24.04 default |
| 47 | 1.6 | BottomSheet, Spinner, ButtonRow |
| 48 | 1.7 | ToggleGroup, WrapBox |

See <doc:FlatpakDistribution> for details on Flatpak packaging.

### CI testing across versions

The CI matrix tests against Ubuntu (libadwaita 1.5) with Swift 6.2
and 6.3. C stubs in `Sources/CAdwaita/shim.h` ensure compilation succeeds
even when newer API symbols are missing from the system headers.
