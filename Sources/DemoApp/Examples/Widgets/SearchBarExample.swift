import Adwaita
import CAdwaita

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
    searchBar.showCloseButton = true

    // Toggle search mode
    searchBar.searchModeEnabled = true

    // Connect to entry
    entry.onSearchChanged {
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
        group1.add(searchBar)

        let resultLabel = Label("Type to search...")
        resultLabel.addCSSClass("dim-label")
        resultLabel.setMargins(12)
        group1.add(resultLabel)

        searchEntry.onSearchChanged { [searchEntry, resultLabel] in
            let query = searchEntry.text
            if query.isEmpty {
                resultLabel.text = "Type to search..."
            } else {
                resultLabel.text = "Searching for: \(query)"
            }
        }

        let toggleRow = ActionRow()
        toggleRow.title = "Search Mode"
        toggleRow.subtitle = "Toggle the search bar visibility"
        let toggleSwitch = Switch()
        toggleSwitch.valign = .center
        toggleSwitch.onActiveChanged { [toggleSwitch, searchBar] in
            searchBar.searchModeEnabled = toggleSwitch.active
        }
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
        closeSwitch.onActiveChanged { [closeSwitch, searchBar] in
            searchBar.showCloseButton = closeSwitch.active
        }
        closeRow.addSuffix(closeSwitch)
        group2.add(closeRow)

        box.append(group2)

        let clamp = Clamp()
        clamp.maximumSize = 600
        clamp.child = box

        let scrolled = ScrolledWindow()
        scrolled.child = clamp
        return scrolled
    }
}
