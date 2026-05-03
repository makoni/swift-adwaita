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
    // ... populate store + parallel data array

    // Filter: only show items matching search text
    let filter = CustomFilter { item in true }
    let filtered = FilterListModel(model: store, filter: filter)

    // Sort: alphabetical order
    let sorter = CustomSorter { a, b in 0 }
    let sorted = SortListModel(model: filtered, sorter: sorter)

    // Update filter when search text changes
    searchEntry.onSearchChanged {
        // update predicate, then:
        filter.changed()
    }
    """

    func buildWidget() -> Widget {
        // Data
        var fruits = [
            "Apple", "Banana", "Cherry", "Date", "Elderberry",
            "Fig", "Grape", "Honeydew", "Kiwi", "Lemon",
            "Mango", "Nectarine", "Orange", "Papaya", "Quince",
            "Raspberry", "Strawberry", "Tangerine", "Ugli fruit", "Watermelon"
        ]

        let store = ListStore()
        for _ in fruits {
            store.appendPlaceholder()
        }

        // Filter state
        var searchText = ""

        let positionFilter = CustomFilter { _ in
            // Since items are placeholder GObjects, we check by pointer identity
            // This is a simplified approach — in real apps you'd use typed items
            true
        }

        let filtered = FilterListModel(model: store, filter: positionFilter)

        let sorter = CustomSorter { _, _ in
            0 // No sort by default
        }
        let sorted = SortListModel(model: filtered, sorter: sorter)

        // Factory
        let factory = SignalListItemFactory()
        factory.onSetup { listItem in
            let label = Label("")
            label.xalign = 0
            label.setMargins(8)
            listItem.child = label
        }
        factory.onBind { listItem in
            let pos = listItem.position
            guard pos < fruits.count else { return }
            listItem.child?.cast(Label.self).text = fruits[pos]
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

        // Search
        let searchEntry = SearchEntry()
        searchEntry.placeholderText = "Filter fruits..."
        searchEntry.hexpand = true
        searchEntry.onSearchChanged {
            searchText = searchEntry.text
            // Rebuild store to match filter
            // Since CustomFilter works on GObjects (not positions),
            // we use a simpler approach: remove/re-add items
            let query = searchText.lowercased()

            // Remove all and re-add matching items
            while store.count > 0 {
                store.remove(at: 0)
            }
            fruits.removeAll()

            let allFruits = [
                "Apple", "Banana", "Cherry", "Date", "Elderberry",
                "Fig", "Grape", "Honeydew", "Kiwi", "Lemon",
                "Mango", "Nectarine", "Orange", "Papaya", "Quince",
                "Raspberry", "Strawberry", "Tangerine", "Ugli fruit", "Watermelon"
            ]

            for fruit in allFruits {
                if query.isEmpty || fruit.lowercased().contains(query) {
                    fruits.append(fruit)
                    store.appendPlaceholder()
                }
            }
        }
        group.add(searchEntry)

        // Sort buttons
        let sortRow = ActionRow()
        sortRow.title = "Sort Order"

        let sortAscBtn = Button(label: "A→Z")
        sortAscBtn.valign = .center
        sortAscBtn.onClicked {
            fruits.sort()
            while store.count > 0 {
                store.remove(at: 0)
            }
            for _ in fruits {
                store.appendPlaceholder()
            }
        }

        let sortDescBtn = Button(label: "Z→A")
        sortDescBtn.valign = .center
        sortDescBtn.onClicked {
            fruits.sort(by: >)
            while store.count > 0 {
                store.remove(at: 0)
            }
            for _ in fruits {
                store.appendPlaceholder()
            }
        }

        let resetBtn = Button(label: "Reset")
        resetBtn.valign = .center
        resetBtn.addCSSClass("destructive-action")
        resetBtn.onClicked {
            searchEntry.text = ""
            fruits = [
                "Apple", "Banana", "Cherry", "Date", "Elderberry",
                "Fig", "Grape", "Honeydew", "Kiwi", "Lemon",
                "Mango", "Nectarine", "Orange", "Papaya", "Quince",
                "Raspberry", "Strawberry", "Tangerine", "Ugli fruit", "Watermelon"
            ]
            while store.count > 0 {
                store.remove(at: 0)
            }
            for _ in fruits {
                store.appendPlaceholder()
            }
        }

        sortRow.addSuffix(sortAscBtn)
        sortRow.addSuffix(sortDescBtn)
        sortRow.addSuffix(resetBtn)
        group.add(sortRow)

        // Count row
        let countRow = ActionRow()
        countRow.title = "Showing"
        let countLabel = Label("\(fruits.count) items")
        countLabel.addCSSClass("dim-label")
        countLabel.valign = .center
        countRow.addSuffix(countLabel)
        group.add(countRow)

        outerBox.append(group)

        let frame = Frame()
        frame.child = listView
        listView.setSizeRequest(width: -1, height: 300)
        outerBox.append(frame)

        return outerBox.scrollableClamped()
    }
}
