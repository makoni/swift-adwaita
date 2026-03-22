import Adwaita

@MainActor
struct DialogExample: DemoExample {
    let name = "Dialog"
    let id = "dialog"
    let category: ExampleCategory = .composite

    let sourceCode = """
    let dialog = Dialog()
    dialog.title = "Preferences"
    dialog.contentWidth = 500
    dialog.contentHeight = 400

    let group = PreferencesGroup()
    group.title = "General"
    let row = SwitchRow()
    row.title = "Dark Mode"
    group.add(row)

    let scrolled = ScrolledWindow()
    scrolled.child = group
    dialog.child = scrolled

    dialog.present(parentWidget)
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Dialogs"
        group.description = "AdwDialog presents content as a modal sheet or floating window"

        let row1 = ActionRow()
        row1.title = "Simple Dialog"
        row1.subtitle = "A dialog with preferences content"
        let btn1 = Button(iconName: "go-next-symbolic")
        btn1.addCSSClass("flat")
        btn1.valign = .center
        row1.addSuffix(btn1)
        row1.activatableWidget = btn1
        group.add(row1)

        let row2 = ActionRow()
        row2.title = "Wide Dialog"
        row2.subtitle = "A larger dialog with more content"
        let btn2 = Button(iconName: "go-next-symbolic")
        btn2.addCSSClass("flat")
        btn2.valign = .center
        row2.addSuffix(btn2)
        row2.activatableWidget = btn2
        group.add(row2)

        box.append(group)

        // Dialog 1 handler — will be attached after box is in widget tree
        btn1.onClicked { [box] in
            let dialog = Dialog()
            dialog.title = "Preferences"
            dialog.contentWidth = 400
            dialog.contentHeight = 350

            let content = Box(orientation: .vertical, spacing: 12)
            content.setMargins(12)

            let g = PreferencesGroup()
            g.title = "General"
            let sr1 = SwitchRow()
            sr1.title = "Dark Mode"
            sr1.subtitle = "Use dark color scheme"
            g.add(sr1)
            let sr2 = SwitchRow()
            sr2.title = "Notifications"
            sr2.active = true
            g.add(sr2)
            content.append(g)

            let scrolled = ScrolledWindow()
            scrolled.child = content
            dialog.child = scrolled
            dialog.present(box)
        }

        // Dialog 2 handler
        btn2.onClicked { [box] in
            let dialog = Dialog()
            dialog.title = "Account Settings"
            dialog.contentWidth = 600
            dialog.contentHeight = 500

            let content = Box(orientation: .vertical, spacing: 12)
            content.setMargins(12)

            let g1 = PreferencesGroup()
            g1.title = "Profile"
            let nameRow = EntryRow()
            nameRow.title = "Display Name"
            g1.add(nameRow)
            let emailRow = EntryRow()
            emailRow.title = "Email"
            g1.add(emailRow)
            content.append(g1)

            let g2 = PreferencesGroup()
            g2.title = "Security"
            let passRow = PasswordEntryRow()
            passRow.title = "Change Password"
            g2.add(passRow)
            let twoFaRow = SwitchRow()
            twoFaRow.title = "Two-Factor Authentication"
            twoFaRow.active = true
            g2.add(twoFaRow)
            content.append(g2)

            let scrolled = ScrolledWindow()
            scrolled.child = content
            dialog.child = scrolled
            dialog.present(box)
        }

        return box.scrollableClamped()
    }
}
