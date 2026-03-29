import Adwaita

@MainActor
struct ColumnViewExample: DemoExample {
    let name = "Column View"
    let id = "columnview"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    // Data — parallel arrays for each column
    let names = ["Documents", "Photos", "report.pdf", "song.mp3"]
    let sizes = ["4 KB", "2.1 MB", "120 KB", "5.2 MB"]
    let types = ["Folder", "Folder", "PDF", "Audio"]

    // Store (one placeholder per row)
    let store = ListStore()
    for _ in names { store.appendPlaceholder() }

    // Factory for each column
    let nameFactory = SignalListItemFactory()
    nameFactory.onSetup { listItem in
        let label = Label("")
        label.xalign = 0
        listItem.child = label
    }
    nameFactory.onBind { listItem in
        listItem.child?.cast(Label.self).text = names[listItem.position]
    }
    // ... same pattern for size and type columns ...

    // Columns with properties
    let nameCol = ColumnViewColumn(title: "Name", factory: nameFactory)
    nameCol.expand = true       // fills available space
    nameCol.resizable = true    // user can drag to resize

    let sizeCol = ColumnViewColumn(title: "Size", factory: sizeFactory)
    sizeCol.fixedWidth = 120

    // Selection + View
    let selection = NoSelection(model: store)
    let columnView = ColumnView(model: selection)
    columnView.appendColumn(nameCol)
    columnView.appendColumn(sizeCol)
    columnView.showRowSeparators = true
    columnView.showColumnSeparators = true
    columnView.reorderable = true   // drag columns to reorder
    """

    func buildWidget() -> Widget {
        // File browser data — parallel arrays for each column
        let names = [
            "Documents", "Photos", "Music", "Videos",
            "report.pdf", "vacation.jpg", "song.mp3", "notes.txt",
            "backup.tar.gz", "presentation.pptx", "database.sqlite",
            "README.md", "config.json", "app.swift"
        ]
        let sizes = [
            "4 KB", "2.1 MB", "860 KB", "1.5 GB",
            "120 KB", "3.4 MB", "5.2 MB", "1 KB",
            "42 MB", "780 KB", "12 MB",
            "2 KB", "512 B", "8 KB"
        ]
        let types = [
            "Folder", "Folder", "Folder", "Folder",
            "PDF", "Image", "Audio", "Text",
            "Archive", "Presentation", "Database",
            "Markdown", "JSON", "Swift"
        ]

        // One placeholder per row
        let store = ListStore()
        for _ in names {
            store.appendPlaceholder()
        }

        // --- Name column: icon + label ---
        let nameFactory = SignalListItemFactory()
        nameFactory.onSetup { listItem in
            let box = Box(orientation: .horizontal, spacing: 8)
            let icon = Image()
            icon.pixelSize = 16
            let label = Label("")
            label.xalign = 0
            label.hexpand = true
            box.append(icon)
            box.append(label)
            box.setMargins(4)
            listItem.child = box
        }
        nameFactory.onBind { listItem in
            let pos = listItem.position
            guard pos < names.count, let child = listItem.child else { return }
            let icon = child.firstChild!.cast(Image.self)
            let label = child.lastChild!.cast(Label.self)

            label.text = names[pos]
            let iconName = switch types[pos] {
            case "Folder": "folder-symbolic"
            case "Image": "image-x-generic-symbolic"
            case "Audio": "audio-x-generic-symbolic"
            case "Archive": "package-x-generic-symbolic"
            default: "text-x-generic-symbolic"
            }
            icon.iconName = iconName
        }

        // --- Size column: right-aligned dim label ---
        let sizeFactory = SignalListItemFactory()
        sizeFactory.onSetup { listItem in
            let label = Label("")
            label.xalign = 1
            label.addCSSClass("dim-label")
            label.setMargins(4)
            listItem.child = label
        }
        sizeFactory.onBind { listItem in
            let pos = listItem.position
            guard pos < sizes.count else { return }
            listItem.child?.cast(Label.self).text = sizes[pos]
        }

        // --- Type column: left-aligned dim label ---
        let typeFactory = SignalListItemFactory()
        typeFactory.onSetup { listItem in
            let label = Label("")
            label.xalign = 0
            label.addCSSClass("dim-label")
            label.setMargins(4)
            listItem.child = label
        }
        typeFactory.onBind { listItem in
            let pos = listItem.position
            guard pos < types.count else { return }
            listItem.child?.cast(Label.self).text = types[pos]
        }

        // Create columns with display properties
        let nameCol = ColumnViewColumn(title: "Name", factory: nameFactory)
        nameCol.expand = true // fills available horizontal space
        nameCol.resizable = true // user can drag to resize

        let sizeCol = ColumnViewColumn(title: "Size", factory: sizeFactory)
        sizeCol.fixedWidth = 120
        sizeCol.resizable = true

        let typeCol = ColumnViewColumn(title: "Type", factory: typeFactory)
        typeCol.fixedWidth = 140
        typeCol.resizable = true

        // NoSelection — read-only table, no row highlighting
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)
        columnView.appendColumn(nameCol)
        columnView.appendColumn(sizeCol)
        columnView.appendColumn(typeCol)
        columnView.showRowSeparators = true
        columnView.showColumnSeparators = true
        columnView.reorderable = true // user can drag column headers to reorder

        // Outer layout
        let outerBox = Box(orientation: .vertical, spacing: 12)
        outerBox.setMargins(24)

        let group = PreferencesGroup()
        group.title = "File Browser"
        group.description = "ColumnView displays data in a multi-column table with resizable, reorderable columns"

        let rowInfoRow = ActionRow()
        rowInfoRow.title = "Rows"
        let countLabel = Label("\(names.count)")
        countLabel.addCSSClass("dim-label")
        countLabel.valign = .center
        rowInfoRow.addSuffix(countLabel)
        group.add(rowInfoRow)

        let colInfoRow = ActionRow()
        colInfoRow.title = "Columns"
        colInfoRow.subtitle = "Name (expand), Size (120px), Type (140px) — all resizable"
        group.add(colInfoRow)

        outerBox.append(group)

        // ColumnView in a frame for visual separation
        let frame = Frame()
        frame.child = columnView
        columnView.setSizeRequest(width: -1, height: 350)
        outerBox.append(frame)

        return outerBox.scrollableClamped()
    }
}
