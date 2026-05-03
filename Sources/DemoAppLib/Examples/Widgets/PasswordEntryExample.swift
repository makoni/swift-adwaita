// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct PasswordEntryExample: DemoExample {
    let name = "Password Entry"
    let id = "password-entry"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    // AdwEntryRow — text input in a list
    let entryRow = EntryRow()
    entryRow.title = "Username"

    // AdwPasswordEntryRow — password input with reveal toggle
    let passRow = PasswordEntryRow()
    passRow.title = "Password"
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Entry &amp; Password Rows"
        group.description = "Adwaita-styled text inputs for lists and forms"

        let entryRow = EntryRow()
        entryRow.title = "Username"
        group.add(entryRow)

        let passRow = PasswordEntryRow()
        passRow.title = "Password"
        group.add(passRow)

        let confirmRow = PasswordEntryRow()
        confirmRow.title = "Confirm Password"
        group.add(confirmRow)

        box.append(group)

        let group2 = PreferencesGroup()
        group2.title = "Entry Row Features"

        let emailRow = EntryRow()
        emailRow.title = "Email Address"
        emailRow.showApplyButton = true
        group2.add(emailRow)

        box.append(group2)

        return box.scrollableClamped()
    }
}
