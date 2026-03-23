import Adwaita

@MainActor
struct ListViewExample: DemoExample {
    let name = "List View"
    let id = "listview"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    // Data
    var items = ["Hello!", "How are you?", "Great!"]

    // Store (one placeholder per item)
    let store = ListStore()
    for _ in items { store.appendPlaceholder() }

    // Factory — create & bind widgets
    let factory = SignalListItemFactory()
    factory.onSetup { listItem in
        let label = Label("")
        label.xalign = 0
        listItem.child = label
    }
    factory.onBind { listItem in
        let text = items[listItem.position]
        listItem.child?.cast(Label.self).text = text
    }

    // View
    let selection = NoSelection(model: store)
    let listView = ListView(model: selection, factory: factory)
    """

    func buildWidget() -> Widget {
        // Chat-like message data
        var messages: [(sender: String, text: String)] = [
            ("Alice", "Hey! Have you tried swift-adwaita yet?"),
            ("Bob", "Yes! Just started today."),
            ("Alice", "How do you like the API?"),
            ("Bob", "It's really clean. Imperative style feels natural."),
            ("Alice", "Did you try the ListView? It's virtualized!"),
            ("Bob", "That's what I'm looking at right now."),
            ("Alice", "It recycles widgets as you scroll. Super efficient."),
            ("Bob", "How many items can it handle?"),
            ("Alice", "Thousands, no problem. Only visible items get widgets."),
            ("Bob", "That's impressive. Much better than ListBox for big lists."),
            ("Alice", "Exactly. ListBox creates all widgets upfront."),
            ("Bob", "I'll use ListView for my chat app then."),
            ("Alice", "Good choice! The factory pattern takes some getting used to."),
            ("Bob", "onSetup creates the widget, onBind fills in data?"),
            ("Alice", "Exactly! And widgets get recycled automatically."),
        ]

        let store = ListStore()
        for _ in messages {
            store.appendPlaceholder()
        }

        let factory = SignalListItemFactory()
        factory.onSetup { listItem in
            let label = Label("")
            label.xalign = 0
            label.wrap = true
            label.setMargins(8)
            listItem.child = label
        }

        factory.onBind { listItem in
            let pos = listItem.position
            guard pos < messages.count else { return }
            let msg = messages[pos]
            let text = "\(msg.sender): \(msg.text)"
            listItem.child?.cast(Label.self).text = text
        }

        let selection = NoSelection(model: store)
        let listView = ListView(model: selection, factory: factory)
        listView.showSeparators = true

        // Controls
        let outerBox = Box(orientation: .vertical, spacing: 12)
        outerBox.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Virtualized Chat List"
        group.description = "ListView recycles widgets — only visible items use memory"

        // Info row
        let infoRow = ActionRow()
        infoRow.title = "Items in model"
        let countLabel = Label("\(store.count)")
        countLabel.addCSSClass("dim-label")
        countLabel.valign = .center
        infoRow.addSuffix(countLabel)
        group.add(infoRow)

        // Add message button
        let addRow = ActionRow()
        addRow.title = "Add Message"
        addRow.subtitle = "Append a new message to the list"
        let addBtn = Button(label: "Add")
        addBtn.addCSSClass("suggested-action")
        addBtn.valign = .center
        addBtn.onClicked { [store, countLabel, listView] in
            let newMsg = (sender: "Bob", text: "Message #\(messages.count + 1)")
            messages.append(newMsg)
            store.appendPlaceholder()
            countLabel.text = "\(store.count)"
            listView.scrollTo(store.count - 1)
        }
        addRow.addSuffix(addBtn)
        addRow.activatableWidget = addBtn
        group.add(addRow)

        // Remove last button
        let removeRow = ActionRow()
        removeRow.title = "Remove Last"
        removeRow.subtitle = "Remove the last message"
        let removeBtn = Button(label: "Remove")
        removeBtn.addCSSClass("destructive-action")
        removeBtn.valign = .center
        removeBtn.onClicked { [store, countLabel] in
            guard !messages.isEmpty else { return }
            messages.removeLast()
            store.remove(at: store.count - 1)
            countLabel.text = "\(store.count)"
        }
        removeRow.addSuffix(removeBtn)
        removeRow.activatableWidget = removeBtn
        group.add(removeRow)

        outerBox.append(group)

        // ListView in a frame
        let frame = Frame()
        frame.child = listView
        listView.setSizeRequest(width: -1, height: 300)
        outerBox.append(frame)

        return outerBox.scrollableClamped()
    }
}
