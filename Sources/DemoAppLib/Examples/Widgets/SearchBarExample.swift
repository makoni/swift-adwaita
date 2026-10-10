// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct SearchBarExample: DemoExample {
    let name = "Search Bar"
    let id = "searchbar"
    let category: ExampleCategory = .widgets

    let sourceCode = """
        let searchBar = SearchBar()
        let entry = SearchEntry()
        searchBar.child = entry
        searchBar.connectEntry(entry)
        searchBar.setKeyCaptureWidget(window)
        searchBar.showCloseButton = true

        // Toggle search mode
        searchBar.searchModeEnabled = true

        // Keep a switch in sync both ways (close button and Escape too)
        let toggleSwitch = Switch()
        searchBar.bind(
            .custom("search-mode-enabled"), to: toggleSwitch,
            property: .active, flags: [.bidirectional, .syncCreate])

        // Connect to entry
        entry.onSearchChanged { [weak entry] in
            guard let entry else { return }
            let query = entry.text
            print("Searching: \\(query)")
        }
        """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        // Search bar demo
        let group1 = PreferencesGroup()
        group1.title = "Search Bar"
        group1.description = "A toolbar that reveals a search entry"

        let searchEntry = SearchEntry()
        searchEntry.hexpand = true

        let searchBar = SearchBar()
        searchBar.child = searchEntry
        searchBar.connectEntry(searchEntry)
        searchBar.showCloseButton = true
        searchBar.setMargins(12)
        // Typing anywhere on this page reveals the search bar.
        searchBar.setKeyCaptureWidget(box)
        group1.add(searchBar)

        let resultLabel = Label("Type to search...")
        resultLabel.addCSSClass("dim-label")
        resultLabel.setMargins(12)
        group1.add(resultLabel)

        // The entry owns this handler, so capture it weakly.
        searchEntry.onSearchChanged { [weak searchEntry, resultLabel] in
            guard let searchEntry else { return }
            let query = searchEntry.text
            if query.isEmpty {
                resultLabel.text = "Type to search..."
            } else {
                resultLabel.text = "Searching for: \(query)"
            }
        }

        let toggleRow = ActionRow()
        toggleRow.title = "Search Mode"
        toggleRow.subtitle = "Toggle the search bar visibility, or just start typing on this page"
        let toggleSwitch = Switch()
        toggleSwitch.valign = .center
        // A two-way binding instead of a pair of signal handlers: it also
        // follows the close button and Escape, and two handlers capturing each
        // other's widget would form a reference cycle.
        searchBar.bind(
            .custom("search-mode-enabled"), to: toggleSwitch,
            property: .active, flags: [.bidirectional, .syncCreate])
        toggleRow.addSuffix(toggleSwitch)
        group1.add(toggleRow)

        box.append(group1)

        // Options
        let group2 = PreferencesGroup()
        group2.title = "Options"

        let closeRow = ActionRow()
        closeRow.title = "Show Close Button"
        closeRow.subtitle = "Whether the close button is shown in the search bar"
        let closeSwitch = Switch()
        closeSwitch.active = true
        closeSwitch.valign = .center
        closeSwitch.bind(.active, to: searchBar, property: .custom("show-close-button"))
        closeRow.addSuffix(closeSwitch)
        group2.add(closeRow)

        box.append(group2)

        return box.scrollableClamped()
    }
}
