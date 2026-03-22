import Adwaita

@MainActor
struct SwitchExample: DemoExample {
    let name = "Switches & Checks"
    let id = "switches"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    // GtkSwitch inside an ActionRow
    let row = ActionRow()
    row.title = "Dark Mode"
    let toggle = Switch()
    toggle.valign = .center
    row.addSuffix(toggle)
    row.activatableWidget = toggle

    // AdwSwitchRow — built-in switch row
    let switchRow = SwitchRow()
    switchRow.title = "Notifications"
    switchRow.subtitle = "Receive alerts"
    switchRow.active = true

    // GtkCheckButton
    let check = CheckButton(label: "Accept terms")
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        // Switch group
        let switchGroup = PreferencesGroup()
        switchGroup.title = "Switches"

        let row1 = ActionRow()
        row1.title = "Dark Mode"
        row1.subtitle = "Use dark appearance"
        let toggle = Switch()
        toggle.valign = .center
        row1.addSuffix(toggle)
        row1.activatableWidget = toggle
        switchGroup.add(row1)

        let switchRow = SwitchRow()
        switchRow.title = "Notifications"
        switchRow.subtitle = "Receive alerts"
        switchRow.active = true
        switchGroup.add(switchRow)

        let switchRow2 = SwitchRow()
        switchRow2.title = "Auto-update"
        switchRow2.subtitle = "Keep apps up to date"
        switchRow2.active = false
        switchGroup.add(switchRow2)

        box.append(switchGroup)

        // Check button group
        let checkGroup = PreferencesGroup()
        checkGroup.title = "Check Buttons"

        let checkBox = Box(orientation: .vertical, spacing: 8)
        checkBox.setMargins(12)

        let check1 = CheckButton(label: "Option A")
        let check2 = CheckButton(label: "Option B")
        let check3 = CheckButton(label: "Option C (disabled)")
        check3.sensitive = false
        checkBox.append(check1)
        checkBox.append(check2)
        checkBox.append(check3)

        checkGroup.add(checkBox)
        box.append(checkGroup)

        return box.scrollableClamped()
    }
}
