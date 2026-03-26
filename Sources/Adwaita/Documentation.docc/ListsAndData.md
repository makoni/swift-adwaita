# Lists and Data Models

Display collections of data using list boxes, list views, and data models.

## Overview

swift-adwaita provides two main approaches for displaying lists of data:
``ListBox`` for simple, static lists with rich row content, and ``ListView``
for large, scrollable lists backed by data models with factory-based cell
creation.

### Simple lists with ListBox

``ListBox`` is the simplest way to display a list. Add widgets directly
as rows. Use the `.boxed-list` CSS class for the standard GNOME rounded-card
look.

```swift
let listBox = ListBox()
listBox.selectionMode = .single
listBox.addCSSClass("boxed-list")

let row1 = ActionRow()
row1.title = "Bluetooth"
row1.subtitle = "Connected to AirPods"
let toggle1 = Switch()
toggle1.valign = .center
toggle1.active = true
row1.addSuffix(toggle1)
row1.activatableWidget = toggle1
listBox.append(row1)

let row2 = ActionRow()
row2.title = "Wi-Fi"
row2.subtitle = "Home Network"
let toggle2 = Switch()
toggle2.valign = .center
toggle2.active = true
row2.addSuffix(toggle2)
row2.activatableWidget = toggle2
listBox.append(row2)
```

Handle row selection:

```swift
listBox.onRowActivated { row in
    let index = Int(row.index)
    print("Selected row \(index)")
}
```

### Expandable rows

``ExpanderRow`` creates collapsible sections inside a list:

```swift
let expander = ExpanderRow()
expander.title = "Advanced"
expander.subtitle = "Additional settings"
expander.showEnableSwitch = true

let child1 = ActionRow()
child1.title = "Debug mode"
expander.addRow(child1)

let child2 = ActionRow()
child2.title = "Verbose logging"
expander.addRow(child2)

listBox.append(expander)
```

### Combo row for selection

``ComboRow`` provides an inline dropdown selection within a list row:

```swift
let combo = ComboRow()
combo.title = "Theme"
combo.subtitle = "Choose a color scheme"

let model = StringList(strings: ["System", "Light", "Dark"])
combo.model = model

combo.onNotify(.selected) {
    let idx = combo.selected
    print("Selected theme index: \(idx)")
}

listBox.append(combo)
```

### Scalable lists with ListView

For large or dynamic data sets, use ``ListView`` backed by a data model.
A ``SignalListItemFactory`` creates widgets for each visible row on demand.

```swift
// Data model
let model = StringList(strings: [
    "Alice", "Bob", "Charlie", "Diana", "Eve"
])

// Selection model
let selection = SingleSelection()
selection.model = model

// Factory creates row widgets
let factory = SignalListItemFactory()
factory.onSetup { listItem in
    let label = Label("")
    label.xalign = 0
    label.setMargins(8)
    listItem.child = label
}
factory.onBind { listItem in
    guard let item = listItem.item else { return }
    let str = StringList.itemToString(item)
    let label: Label = listItem.child!.cast()
    label.text = str ?? ""
}

// List view
let listView = ListView(model: selection, factory: factory)
listView.addCSSClass("boxed-list")

// Handle activation
listView.onActivate { position in
    let name = model.getString(position)
    print("Activated: \(name)")
}
```

### Filtering data

Wrap any list model in a ``FilterListModel`` with a ``CustomFilter``
to show only matching items:

```swift
let sourceModel = StringList(strings: [
    "Apple", "Banana", "Cherry", "Date", "Elderberry"
])

let filter = CustomFilter { item in
    let name = StringList.itemToString(item) ?? ""
    return name.lowercased().contains("a")
}

let filtered = FilterListModel(model: sourceModel, filter: filter)

// Update filter dynamically
searchEntry.onSearchChanged {
    let query = searchEntry.text.lowercased()
    filter.setFilterFunc { item in
        let name = StringList.itemToString(item) ?? ""
        return query.isEmpty || name.lowercased().contains(query)
    }
}
```

### Sorting data

Use ``SortListModel`` with a ``CustomSorter`` to sort items:

```swift
let sorter = CustomSorter { itemA, itemB in
    let a = StringList.itemToString(itemA) ?? ""
    let b = StringList.itemToString(itemB) ?? ""
    return a < b ? -1 : (a > b ? 1 : 0)
}

let sorted = SortListModel(model: sourceModel, sorter: sorter)
```

### Grid layout with GridView

``GridView`` arranges items in a grid. It uses the same model and factory
pattern as ``ListView``:

```swift
let factory = SignalListItemFactory()
factory.onSetup { listItem in
    let box = Box(orientation: .vertical, spacing: 4)
    box.setMargins(8)
    let icon = Image(iconName: "folder-symbolic")
    icon.pixelSize = 48
    let label = Label("")
    box.append(icon)
    box.append(label)
    listItem.child = box
}
factory.onBind { listItem in
    guard let item = listItem.item else { return }
    let name = StringList.itemToString(item) ?? ""
    let box: Box = listItem.child!.cast()
    // The second child is the label
    let label: Label = box.lastChild!.cast()
    label.text = name
}

let gridView = GridView(model: selection, factory: factory)
gridView.minColumns = 2
gridView.maxColumns = 6
```

### Preferences group as a list

For settings-style UIs, ``PreferencesGroup`` with ``ActionRow``,
``SwitchRow``, and ``SpinRow`` is often simpler than a raw list:

```swift
let group = PreferencesGroup()
group.title = "Notifications"
group.description = "Configure how you receive alerts"

let soundRow = SwitchRow()
soundRow.title = "Sound"
soundRow.subtitle = "Play notification sounds"
soundRow.active = true
group.add(soundRow)

let volumeRow = SpinRow.newWithRange(min: 0, max: 100, step: 10)
volumeRow.title = "Volume"
volumeRow.subtitle = "Notification volume percentage"
volumeRow.value = 80
group.add(volumeRow)
```
