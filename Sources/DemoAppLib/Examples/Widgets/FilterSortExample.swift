// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct FilterSortExample: DemoExample {
    let name = "Filter & Sort"
    let id = "filtersort"
    let category: ExampleCategory = .widgets

    let sourceCode = """
        let store = ListStore()
        // ... one placeholder per fruit, plus a map item → fruit

        // Filter: only show items matching the search text
        var query = ""
        let filter = CustomFilter { item in
            query.isEmpty || fruit(of: item).lowercased().contains(query)
        }
        let filtered = FilterListModel(model: store, filter: filter)

        // Sort: by name, in the chosen direction
        var ascending = true
        let sorter = CustomSorter { a, b in
            let order = fruit(of: a) < fruit(of: b) ? -1 : 1
            return ascending ? order : -order
        }
        let sorted = SortListModel(model: filtered, sorter: sorter)

        // Update the predicate, then tell GTK to re-run it
        searchEntry.onSearchChanged { [weak searchEntry] in
            guard let searchEntry else { return }
            query = searchEntry.text.lowercased()
            filter.changed()
        }
        sortDescButton.onClicked {
            ascending = false
            sorter.changed()
        }
        """

    func buildWidget() -> Widget {
        // Data
        let fruits = [
            "Apple", "Banana", "Cherry", "Date", "Elderberry",
            "Fig", "Grape", "Honeydew", "Kiwi", "Lemon",
            "Mango", "Nectarine", "Orange", "Papaya", "Quince",
            "Raspberry", "Strawberry", "Tangerine", "Ugli fruit", "Watermelon",
        ]

        // One placeholder per fruit. Store items are bare GObjects, so remember
        // which fruit each one stands for (by object identity); the filter,
        // sorter and factory all map an item back to its fruit through this.
        let store = ListStore()
        var indexByItem: [UnsafeMutableRawPointer: Int] = [:]
        for index in fruits.indices {
            store.appendPlaceholder()
            if let item = store.item(at: index) {
                indexByItem[item.pointer] = index
            }
        }
        let fruitIndex = { [indexByItem] (item: GObjectRef) -> Int in
            indexByItem[item.pointer] ?? 0
        }

        // Filter & sort state, read by the predicates below. GTK only re-runs a
        // predicate after `changed()`, so every mutation is followed by one.
        var query = ""
        var order = FruitOrder.original

        let filter = CustomFilter { item in
            query.isEmpty || fruits[fruitIndex(item)].lowercased().contains(query)
        }
        let filtered = FilterListModel(model: store, filter: filter)

        let sorter = CustomSorter { a, b in
            let lhs = fruitIndex(a)
            let rhs = fruitIndex(b)
            switch order {
            case .original: return lhs - rhs
            case .ascending: return compareNames(fruits[lhs], fruits[rhs])
            case .descending: return compareNames(fruits[rhs], fruits[lhs])
            }
        }
        let sorted = SortListModel(model: filtered, sorter: sorter)

        // Factory — positions in the sorted model don't match the data array,
        // so bind from the item itself.
        let factory = SignalListItemFactory()
        factory.onSetup { listItem in
            let label = Label("")
            label.xalign = 0
            label.setMargins(8)
            listItem.child = label
        }
        factory.onBind { listItem in
            guard let item = listItem.item else { return }
            listItem.child?.cast(Label.self).text = fruits[fruitIndex(item)]
        }

        let selection = NoSelection(model: sorted)
        let listView = ListView(model: selection, factory: factory)
        listView.showSeparators = true

        // UI
        let outerBox = Box(orientation: .vertical, spacing: 12)
        outerBox.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Filterable &amp; Sortable List"
        group.description = "Type to filter, click to sort"

        // Count row (added below the sort row)
        let countRow = ActionRow()
        countRow.title = "Showing"
        let countLabel = Label("\(sorted.count) items")
        countLabel.addCSSClass("dim-label")
        countLabel.valign = .center
        countRow.addSuffix(countLabel)

        let refreshCount = { [sorted, countLabel] in
            countLabel.text = "\(sorted.count) items"
        }

        // Search
        let searchEntry = SearchEntry()
        searchEntry.placeholderText = "Filter fruits..."
        searchEntry.hexpand = true
        searchEntry.onSearchChanged { [weak searchEntry, filter] in
            guard let searchEntry else { return }
            query = searchEntry.text.lowercased()
            filter.changed()
            refreshCount()
        }
        group.add(searchEntry)

        // Sort buttons
        let sortRow = ActionRow()
        sortRow.title = "Sort Order"

        let sortAscBtn = Button(label: "A→Z")
        sortAscBtn.valign = .center
        sortAscBtn.onClicked { [sorter] in
            order = .ascending
            sorter.changed()
        }

        let sortDescBtn = Button(label: "Z→A")
        sortDescBtn.valign = .center
        sortDescBtn.onClicked { [sorter] in
            order = .descending
            sorter.changed()
        }

        let resetBtn = Button(label: "Reset")
        resetBtn.valign = .center
        resetBtn.addCSSClass("destructive-action")
        resetBtn.onClicked { [searchEntry, filter, sorter] in
            // Clearing an already-empty entry emits nothing, so re-apply the
            // reset state explicitly rather than relying on search-changed.
            searchEntry.text = ""
            query = ""
            order = .original
            filter.changed()
            sorter.changed()
            refreshCount()
        }

        sortRow.addSuffix(sortAscBtn)
        sortRow.addSuffix(sortDescBtn)
        sortRow.addSuffix(resetBtn)
        group.add(sortRow)
        group.add(countRow)

        outerBox.append(group)

        let frame = Frame()
        frame.child = listView
        listView.setSizeRequest(width: -1, height: 300)
        outerBox.append(frame)

        return outerBox.scrollableClamped()
    }
}

private enum FruitOrder {
    case original
    case ascending
    case descending
}

private func compareNames(_ lhs: String, _ rhs: String) -> Int {
    lhs < rhs ? -1 : (lhs == rhs ? 0 : 1)
}
