import Adwaita

@MainActor
struct DragDropExample: DemoExample {
    let name = "Drag & Drop"
    let id = "dragdrop"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    // Drag source
    let drag = DragSource()
    drag.setTextContent("Hello!")
    drag.onDragBegin { print("Drag started") }
    sourceWidget.addController(drag)

    // Drop target
    let drop = DropTarget.forText()
    drop.onDrop { text in
        if let text { label.text = text }
        return true
    }
    drop.onEnter { _, _ in
        targetWidget.addCSSClass("drop-highlight")
    }
    drop.onLeave {
        targetWidget.removeCSSClass("drop-highlight")
    }
    targetWidget.addController(drop)
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Drag & Drop"
        group.description = "Drag items from the source area to the target area"

        // Source items
        let sourceBox = Box(orientation: .horizontal, spacing: 12)
        sourceBox.halign = .center
        sourceBox.setMargins(12)

        let items = ["Apple", "Banana", "Cherry"]
        let colors = ["error", "warning", "success"]

        for (i, item) in items.enumerated() {
            let card = Box(orientation: .vertical, spacing: 4)
            card.addCSSClass("card")
            card.setMargins(8)
            card.setSizeRequest(width: 80, height: 70)

            let icon = Image(iconName: "emoji-food-symbolic")
            icon.halign = .center
            icon.marginTop = 12
            card.append(icon)

            let label = Label(item)
            label.addCSSClass(colors[i])
            label.halign = .center
            label.marginBottom = 8
            card.append(label)

            let drag = DragSource()
            drag.setTextContent(item)
            card.addController(drag)

            sourceBox.append(card)
        }

        let sourceLabel = Label("Drag from here")
        sourceLabel.addCSSClass("dim-label")
        sourceLabel.halign = .center

        group.add(sourceLabel)
        group.add(sourceBox)

        // Drop target
        let dropLabel = Label("Drop here")
        dropLabel.addCSSClass("title-2")
        dropLabel.setMargins(24)

        let resultLabel = Label("")
        resultLabel.addCSSClass("monospace")
        resultLabel.setMargins(8)

        let dropBox = Box(orientation: .vertical, spacing: 8)
        dropBox.append(dropLabel)
        dropBox.append(resultLabel)
        dropBox.halign = .center
        dropBox.addCSSClass("card")
        dropBox.setSizeRequest(width: 200, height: 120)

        let drop = DropTarget.forText()
        drop.onDrop { [resultLabel, dropLabel] text in
            if let text {
                resultLabel.text = "Received: \(text)"
                dropLabel.text = text
            }
            return true
        }
        drop.onEnter { [dropBox] _, _ in
            dropBox.addCSSClass("accent")
        }
        drop.onLeave { [dropBox] in
            dropBox.removeCSSClass("accent")
        }
        dropBox.addController(drop)

        let targetLabel = Label("Drop target")
        targetLabel.addCSSClass("dim-label")
        targetLabel.halign = .center

        group.add(targetLabel)
        group.add(dropBox)

        box.append(group)

        return box.scrollableClamped()
    }
}
