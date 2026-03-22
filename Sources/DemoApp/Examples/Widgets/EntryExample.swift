import Adwaita
import CAdwaita

@MainActor
struct EntryExample: DemoExample {
    let name = "Text Entry"
    let id = "entry"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    // GtkEntry — basic text input
    let entry = Entry()
    entry.placeholderText = "Type something..."
    entry.onActivate {
        print("Entered: \\(entry.text)")
    }

    // AdwEntryRow — entry inside a list row
    let entryRow = EntryRow()
    entryRow.title = "Username"

    // AdwPasswordEntryRow — masked input
    let passwordRow = PasswordEntryRow()
    passwordRow.title = "Password"

    // GtkSearchEntry — search-styled input
    let searchEntry = SearchEntry()
    searchEntry.placeholderText = "Search..."
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        // Basic entry
        let basicGroup = PreferencesGroup()
        basicGroup.title = "GtkEntry"
        basicGroup.description = "Basic text input widget"

        let entry = Entry()
        entry.placeholderText = "Type something..."
        basicGroup.add(entry)

        box.append(basicGroup)

        // Adw entry rows
        let rowGroup = PreferencesGroup()
        rowGroup.title = "Entry Rows"
        rowGroup.description = "Adwaita-styled input rows"

        let entryRow = EntryRow()
        entryRow.title = "Username"
        rowGroup.add(entryRow)

        let passwordRow = PasswordEntryRow()
        passwordRow.title = "Password"
        rowGroup.add(passwordRow)

        box.append(rowGroup)

        // Search entry
        let searchGroup = PreferencesGroup()
        searchGroup.title = "Search Entry"

        let searchEntry = SearchEntry()
        searchEntry.placeholderText = "Search..."
        searchGroup.add(searchEntry)

        box.append(searchGroup)

        let clamp = Clamp()
        clamp.maximumSize = 600
        clamp.child = box

        let scrolled = ScrolledWindow()
        scrolled.child = clamp
        return scrolled
    }
}
