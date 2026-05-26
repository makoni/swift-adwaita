# Working with Dialogs

Present dialogs, alerts, file pickers, and preference sheets.

## Overview

Dialogs are modal surfaces that appear on top of the current window. Use
``Dialog`` for custom content, ``AlertDialog`` for simple confirmation prompts,
``PreferencesDialog`` for multi-page settings, and ``FileDialog`` for file
open/save operations.

All dialog types are presented with the `present(_:)` method, passing the
parent widget.

### Custom dialog

``Dialog`` is the base dialog class. Set ``Dialog/child`` to your content,
configure the size, and present it.

```swift
let dialog = Dialog()
dialog.title = "Edit Profile"
dialog.contentWidth = 400
dialog.contentHeight = 300

let group = PreferencesGroup()
group.title = "Profile"
let nameRow = EntryRow()
nameRow.title = "Name"
group.add(nameRow)

let emailRow = EntryRow()
emailRow.title = "Email"
group.add(emailRow)

let scrolled = ScrolledWindow()
scrolled.child = group

let toolbar = ToolbarView()
toolbar.addTopBar(HeaderBar())
toolbar.content = scrolled

dialog.child = toolbar
dialog.present(parentWidget)
```

### Alert dialog

``AlertDialog`` displays a heading, body text, and a set of response buttons.
Use `setResponseAppearance(_:appearance:)` to mark responses as
suggested or destructive.

```swift
let alert = AlertDialog(
    heading: "Delete File?",
    body: "This will permanently delete \"report.pdf\"."
)
alert.addResponse("cancel", label: "Cancel")
alert.addResponse("delete", label: "Delete")
alert.setResponseAppearance("delete", appearance: .destructive)
alert.defaultResponse = "cancel"
alert.closeResponse = "cancel"

alert.onResponse { response in
    if response == "delete" {
        print("File deleted!")
    }
}

alert.present(parentWidget)
```

A simpler informational alert:

```swift
let info = AlertDialog(
    heading: "Upload Complete",
    body: "Your file was uploaded successfully."
)
info.addResponse("ok", label: "OK")
info.defaultResponse = "ok"
info.present(parentWidget)
```

### Preferences dialog

``PreferencesDialog`` is a multi-page dialog designed for application settings.
Add ``PreferencesPage`` instances, each containing ``PreferencesGroup`` items.
The dialog automatically supports search across all pages.

```swift
let dialog = PreferencesDialog()
dialog.searchEnabled = true

// General page
let general = PreferencesPage()
general.title = "General"
general.iconName = "preferences-other-symbolic"

let appearanceGroup = PreferencesGroup()
appearanceGroup.title = "Appearance"

let darkRow = SwitchRow()
darkRow.title = "Dark Mode"
darkRow.subtitle = "Use dark color scheme"
appearanceGroup.add(darkRow)

let fontRow = SpinRow.newWithRange(min: 8, max: 32, step: 1)
fontRow.title = "Font Size"
fontRow.value = 14
appearanceGroup.add(fontRow)

general.add(appearanceGroup)
dialog.add(general)

// Account page
let account = PreferencesPage()
account.title = "Account"
account.iconName = "avatar-default-symbolic"

let profileGroup = PreferencesGroup()
profileGroup.title = "Profile"

let nameRow = ActionRow()
nameRow.title = "Display Name"
nameRow.subtitle = "John Doe"
profileGroup.add(nameRow)

account.add(profileGroup)
dialog.add(account)

dialog.present(parentWidget)
```

### About dialog

``AboutDialog`` presents application information — name, version, credits,
and links.

```swift
let about = AboutDialog()
about.applicationName = "My App"
about.applicationIcon = "my-app-icon"
about.version = "1.0.0"
about.developerName = "Your Name"
about.website = "https://example.com"
about.licenseType = .mit
about.copyright = "\u{00A9} 2026 Your Name"
about.issueUrl = "https://github.com/you/myapp/issues"
about.addLink("Documentation", url: "https://docs.example.com")

about.present(parentWidget)
```

### File dialog

``FileDialog`` provides native file open and save dialogs. Filter
files with ``FileFilter``.

```swift
let dialog = FileDialog()
dialog.title = "Open Document"

// Add file filters
let filter = FileFilter()
filter.name = "Documents"
filter.addPattern("*.pdf")
filter.addPattern("*.txt")
filter.addMimeType("application/pdf")

let filters = ListStore(itemType: FileFilter.gType)
filters.append(filter)
dialog.filters = filters

// Open a file — cancellation returns nil, GTK failures throw GLibError
MainContext.task {
    do {
        if let path = try await dialog.open(parent: window) {
            print("Selected: \(path)")
        }
    } catch {
        print("Open dialog failed: \((error as? GLibError)?.message ?? error.localizedDescription)")
    }
}

// If you only care about the path (cancel + error both collapse to nil):
MainContext.task {
    if let path = try? await dialog.save(parent: window) {
        print("Save to: \(path)")
    }
}
```

### Color picker

``ColorDialog`` and ``ColorDialogButton`` provide color selection. The
button shows the current color and opens the dialog on click.

```swift
let colorDialog = ColorDialog()
colorDialog.withAlpha = true

let colorButton = ColorDialogButton(dialog: colorDialog)

// React to color changes
colorButton.onNotify(.rgba) {
    let color = colorButton.rgba
    print("Selected color: \(color)")
}
```
