# Styling and Theming

Apply visual styles, manage color schemes, and load custom CSS.

## Overview

GNOME apps use a consistent visual language built on named CSS classes and
a system-wide color scheme. swift-adwaita provides ``CSSClass`` for type-safe
styling, ``StyleManager`` for dark/light mode control, and ``CSSProvider``
for custom stylesheets.

### Built-in CSS classes

libadwaita and GTK4 ship with dozens of predefined CSS classes. The
``CSSClass`` enum provides type-safe access to the most common ones.

**Button styles:**

```swift
let save = Button(label: "Save")
save.addCSSClass(.suggestedAction)   // Blue accent
save.addCSSClass(.pill)              // Rounded corners

let delete = Button(label: "Delete")
delete.addCSSClass(.destructiveAction)  // Red

let flat = Button(iconName: "view-more-symbolic")
flat.addCSSClass(.flat)              // No background
```

**Typography:**

```swift
let title = Label("Welcome")
title.addCSSClass(.title1)    // Large title

let heading = Label("Section")
heading.addCSSClass(.heading) // Section heading

let body = Label("Regular text")
body.addCSSClass(.body)       // Body text

let caption = Label("Last updated: today")
caption.addCSSClass(.caption) // Small caption

let dimmed = Label("Optional info")
dimmed.addCSSClass(.dimLabel) // Reduced opacity
```

**Container styles:**

```swift
let list = ListBox()
list.addCSSClass("boxed-list")  // Rounded card with rows

let card = Box(orientation: .vertical, spacing: 8)
card.addCSSClass("card")        // Elevated card surface
card.setMargins(12)

let toolbar = Box(orientation: .horizontal, spacing: 6)
toolbar.addCSSClass("toolbar")  // Toolbar spacing
```

**Numeric styles:**

```swift
let label = Label("42")
label.addCSSClass(.monospace)   // Monospace font

let code = Label("let x = 1")
code.addCSSClass(.monospace)
```

### Fluent CSS class chaining

Use the `.cssClass()` fluent setter to chain multiple classes:

```swift
let button = Button(label: "Subscribe")
    .cssClass(.suggestedAction)
    .cssClass(.pill)
    .halign(.center)
```

### Dark mode with StyleManager

``StyleManager`` controls the application-wide color scheme. By default,
apps follow the system preference.

```swift
let styleManager = StyleManager.default

// Check current state
if styleManager.dark {
    print("Currently in dark mode")
}

// Force a specific scheme
styleManager.colorScheme = .forceDark
styleManager.colorScheme = .forceLight
styleManager.colorScheme = .default  // Follow system

// React to changes
styleManager.onNotify(.dark) {
    if styleManager.dark {
        print("Switched to dark mode")
    } else {
        print("Switched to light mode")
    }
}
```

Use this to build a theme switcher:

```swift
let themeRow = SwitchRow()
themeRow.title = "Dark Mode"
themeRow.active = StyleManager.default.dark

themeRow.onNotify(.active) {
    let style = StyleManager.default
    style.colorScheme = themeRow.active ? .forceDark : .forceLight
}
```

### Custom CSS with CSSProvider

Load custom stylesheets to override or extend the default theme:

```swift
let css = CSSProvider()
css.loadFromString("""
    .accent-card {
        background-color: alpha(@accent_bg_color, 0.15);
        border-radius: 12px;
        padding: 24px;
    }

    .accent-card label.title {
        font-weight: bold;
        font-size: 18px;
    }

    .success-badge {
        background-color: @success_bg_color;
        color: @success_fg_color;
        border-radius: 99px;
        padding: 4px 12px;
    }
""")

let card = Box(orientation: .vertical, spacing: 8)
card.addCSSClass("accent-card")
```

### Named colors

GTK4 and libadwaita define semantic color variables that automatically
adapt to dark/light mode. Use these in your CSS instead of hardcoded colors:

| Variable | Usage |
|----------|-------|
| `@accent_bg_color` | Primary accent background |
| `@accent_fg_color` | Text on accent background |
| `@destructive_bg_color` | Destructive action background |
| `@success_bg_color` | Success state background |
| `@warning_bg_color` | Warning state background |
| `@card_bg_color` | Card surface |
| `@window_bg_color` | Window background |
| `@view_bg_color` | Content view background |
| `@headerbar_bg_color` | Header bar background |

### Inline CSS with RGBA

For programmatic color manipulation, use ``RGBA``:

```swift
let color = RGBA(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
// Use with ColorDialogButton or widget properties
```

### Icon names

Use ``IconName`` for type-safe access to standard GNOME icons:

```swift
let img = Image(iconName: "document-open-symbolic")
let btn = Button(iconName: "edit-copy-symbolic")

let statusPage = StatusPage()
statusPage.iconName = "preferences-system-symbolic"
```

Browse available icons with the
[Icon Library](https://apps.gnome.org/IconLibrary/) app on GNOME.
