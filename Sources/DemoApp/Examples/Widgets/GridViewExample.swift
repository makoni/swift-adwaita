import Adwaita

@MainActor
struct GridViewExample: DemoExample {
    let name = "Grid View"
    let id = "gridview"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let store = ListStore()
    for _ in items { store.appendPlaceholder() }

    let factory = SignalListItemFactory()
    factory.onSetup { listItem in
        let box = Box(orientation: .vertical, spacing: 4)
        let label = Label("")
        label.addCSSClass("title-4")
        box.append(label)
        listItem.child = box
    }
    factory.onBind { listItem in
        let item = items[listItem.position]
        // update child widgets...
    }

    let selection = SingleSelection(model: store)
    let gridView = GridView(model: selection, factory: factory)
    gridView.minColumns = 2
    gridView.maxColumns = 5
    """

    func buildWidget() -> Widget {
        // Color data
        let colors: [(name: String, hex: String)] = [
            ("Red", "#e01b24"), ("Orange", "#ff7800"), ("Yellow", "#f6d32d"),
            ("Green", "#33d17a"), ("Blue", "#3584e4"), ("Purple", "#9141ac"),
            ("Pink", "#e66100"), ("Teal", "#2ec27e"), ("Indigo", "#1c71d8"),
            ("Brown", "#986a44"), ("Gray", "#77767b"), ("Slate", "#5e5c64"),
            ("Lime", "#8ff0a4"), ("Cyan", "#99c1f1"), ("Magenta", "#dc8add"),
            ("Gold", "#e5a50a"), ("Coral", "#ed333b"), ("Mint", "#57e389")
        ]

        let store = ListStore()
        for _ in colors {
            store.appendPlaceholder()
        }

        let factory = SignalListItemFactory()
        factory.onSetup { listItem in
            let box = Box(orientation: .vertical, spacing: 8)
            box.setMargins(12)
            box.halign = .center

            // Color swatch
            let swatch = DrawingArea()
            swatch.contentWidth = 64
            swatch.contentHeight = 64

            let label = Label("")
            label.addCSSClass("caption")

            box.append(swatch)
            box.append(label)
            listItem.child = box
        }

        factory.onBind { listItem in
            let pos = listItem.position
            guard pos < colors.count else { return }
            let color = colors[pos]

            guard let box = listItem.child else { return }
            let swatch = box.firstChild
            let label = swatch?.nextSibling

            label?.cast(Label.self).text = color.name

            // Parse hex color and draw swatch
            let rgba = RGBA(hex: color.hex) ?? RGBA(red: 0, green: 0, blue: 0)
            swatch?.cast(DrawingArea.self).setDrawFunc { cr, width, height in
                cr.roundedRectangle(x: 0, y: 0, width: Double(width), height: Double(height), radius: 12)
                cr.setSourceRGB(rgba.red, rgba.green, rgba.blue)
                cr.fill()
            }
        }

        let selection = SingleSelection(model: store)
        let gridView = GridView(model: selection, factory: factory)
        gridView.minColumns = 3
        gridView.maxColumns = 6

        // Controls
        let outerBox = Box(orientation: .vertical, spacing: 12)
        outerBox.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Color Palette Grid"
        group.description = "Virtualized grid — try resizing the window"

        let colRow = ActionRow()
        colRow.title = "Min / Max Columns"
        let colLabel = Label("3 – 6")
        colLabel.addCSSClass("dim-label")
        colLabel.valign = .center
        colRow.addSuffix(colLabel)
        group.add(colRow)

        let selectRow = ActionRow()
        selectRow.title = "Selected"
        let selectLabel = Label("None")
        selectLabel.addCSSClass("dim-label")
        selectLabel.valign = .center
        selectRow.addSuffix(selectLabel)
        group.add(selectRow)

        selection.onSelectionChanged {
            let idx = selection.selected
            if idx < colors.count {
                selectLabel.text = colors[idx].name
            }
        }

        outerBox.append(group)

        let frame = Frame()
        frame.child = gridView
        gridView.setSizeRequest(width: -1, height: 350)
        outerBox.append(frame)

        return outerBox.scrollableClamped()
    }
}
