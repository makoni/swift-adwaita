# Feedback Widgets

Show progress, notifications, and status information to users.

## Overview

Good applications keep users informed about what's happening. swift-adwaita
provides ``Toast`` and ``Banner`` for in-app notifications, ``ProgressBar``
and ``Spinner`` for loading states, ``StatusPage`` for empty or error states,
and ``Revealer`` for animated visibility transitions.

### Toast notifications

``Toast`` displays a temporary message at the bottom of the window. Wrap
your content in a ``ToastOverlay`` to enable toasts.

```swift
let overlay = ToastOverlay()
overlay.child = mainContent

// Show a simple toast
let toast = Toast(title: "File saved successfully")
toast.timeout = 3  // seconds
overlay.addToast(toast)
```

Add an action button to the toast:

```swift
let toast = Toast(title: "Message deleted")
toast.buttonLabel = "Undo"
toast.onButtonClicked {
    print("Undo delete!")
}
overlay.addToast(toast)
```

A common pattern — wrap the window content in a ToastOverlay and show
toasts from anywhere:

```swift
let toastOverlay = ToastOverlay()

let toolbar = ToolbarView()
toolbar.addTopBar(HeaderBar())
toolbar.content = toastOverlay

let saveBtn = Button(label: "Save")
saveBtn.onClicked {
    // ... perform save ...
    let toast = Toast(title: "Document saved")
    toastOverlay.addToast(toast)
}

toastOverlay.child = contentBox
window.setContent(toolbar)
```

### Banners

``Banner`` shows a persistent message bar at the top of a view. Use it for
important notices that require user acknowledgment.

```swift
let banner = Banner()
banner.title = "No internet connection"
banner.buttonLabel = "Retry"
banner.revealed = true

banner.onButtonClicked {
    print("Retrying connection...")
    banner.revealed = false
}

// Place at the top of content
let box = Box(orientation: .vertical, spacing: 0)
box.append(banner)
box.append(mainContent)
```

Toggle banner visibility programmatically:

```swift
// Show the banner
banner.revealed = true

// Hide it
banner.revealed = false
```

### Progress indicators

**ProgressBar** shows determinate progress:

```swift
let progress = ProgressBar()
progress.fraction = 0.0   // 0.0 to 1.0

// Update progress
progress.fraction = 0.5   // 50%
progress.fraction = 1.0   // Complete

// Indeterminate mode (pulsing)
progress.pulse()
```

Style the progress bar:

```swift
progress.addCSSClass("osd")    // On-screen-display style
progress.showText = true       // Show percentage text
progress.text = "Uploading..."
```

**Spinner** shows an indeterminate loading state:

```swift
let spinner = Spinner()
spinner.spinning = true

// Stop when done
spinner.spinning = false
```

Combine with a status page for loading screens:

```swift
let loadingPage = StatusPage()
loadingPage.title = "Loading..."
loadingPage.description = "Please wait while data is fetched"
let spinner = Spinner()
spinner.spinning = true
spinner.setSize(32)
loadingPage.child = spinner
```

### Status pages

``StatusPage`` displays full-page status messages — ideal for empty states,
errors, and onboarding:

```swift
// Empty state
let emptyPage = StatusPage()
emptyPage.iconName = "folder-open-symbolic"
emptyPage.title = "No Documents"
emptyPage.description = "Create a new document to get started"

let createBtn = Button(label: "New Document")
    .cssClass(.suggestedAction)
    .cssClass(.pill)
    .halign(.center)
emptyPage.child = createBtn
```

```swift
// Error state
let errorPage = StatusPage()
errorPage.iconName = "dialog-error-symbolic"
errorPage.title = "Something Went Wrong"
errorPage.description = "Could not load your data. Check your connection and try again."

let retryBtn = Button(label: "Retry")
    .cssClass(.pill)
    .halign(.center)
errorPage.child = retryBtn
```

### Animated reveal

``Revealer`` shows or hides a child widget with a transition animation:

```swift
let revealer = Revealer()
revealer.transitionType = .slideDown
revealer.transitionDuration = 300
revealer.revealChild = false

let content = Label("Revealed content!")
content.setMargins(12)
revealer.child = content

// Toggle visibility
let toggleBtn = Button(label: "Toggle Details")
toggleBtn.onClicked {
    revealer.revealChild = !revealer.revealChild
}
```

Available transition types:
- `.slideDown`, `.slideUp`, `.slideLeft`, `.slideRight`
- `.crossfade`
- `.none`

### Level bar

``LevelBar`` visualizes a value within a range — useful for strength
indicators, battery levels, or ratings:

```swift
let level = LevelBar()
level.minValue = 0
level.maxValue = 100
level.value = 75

// The bar changes color at offset thresholds
level.addOffsetValue("low", value: 25)
level.addOffsetValue("high", value: 75)
level.addOffsetValue("full", value: 100)
```

### Combining feedback widgets

A typical pattern: show a spinner while loading, then switch to content
or an error page:

```swift
let stack = Stack()
stack.transitionType = .crossfade

let loadingBox = Box(orientation: .vertical, spacing: 12)
loadingBox.halign = .center
loadingBox.valign = .center
let spinner = Spinner()
spinner.spinning = true
loadingBox.append(spinner)
loadingBox.append(Label("Loading..."))
stack.addNamed(loadingBox, name: "loading")

let contentBox = Box(orientation: .vertical, spacing: 0)
// ... populate content ...
stack.addNamed(contentBox, name: "content")

let errorPage = StatusPage()
errorPage.title = "Error"
stack.addNamed(errorPage, name: "error")

// Start with loading
stack.visibleChildName = "loading"

// Switch to content when ready
stack.visibleChildName = "content"

// Or show error
stack.visibleChildName = "error"
```
