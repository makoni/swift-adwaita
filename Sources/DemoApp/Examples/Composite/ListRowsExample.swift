import Adwaita
import CAdwaita

@MainActor
struct ListRowsExample: DemoExample {
    let name = "List Rows"
    let id = "listrows"
    let category: ExampleCategory = .composite

    let sourceCode = """
    let group = PreferencesGroup()
    group.title = "List Rows"
    group.description = "Various row types for lists"

    // Simple action row
    let row1 = ActionRow()
    row1.title = "Wi-Fi"
    row1.subtitle = "Connected"
    let wifiIcon = Image(iconName: "network-wireless-symbolic")
    row1.addPrefix(wifiIcon)
    group.add(row1)

    // Action row with switch suffix
    let row2 = ActionRow()
    row2.title = "Bluetooth"
    row2.subtitle = "Disabled"
    let btIcon = Image(iconName: "bluetooth-symbolic")
    row2.addPrefix(btIcon)
    let btSwitch = Switch()
    btSwitch.valign = .center
    row2.addSuffix(btSwitch)
    group.add(row2)

    // Expander row with nested rows
    let expander = ExpanderRow()
    expander.title = "Privacy"
    expander.subtitle = "Location, Camera, Microphone"
    let privIcon = Image(iconName: "security-high-symbolic")
    expander.addPrefix(privIcon)

    let locRow = ActionRow()
    locRow.title = "Location Services"
    expander.addRow(locRow)

    let camRow = ActionRow()
    camRow.title = "Camera Access"
    expander.addRow(camRow)

    group.add(expander)
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group = PreferencesGroup()
        group.title = "List Rows"
        group.description = "Various row types for lists"

        // Wi-Fi row
        let row1 = ActionRow()
        row1.title = "Wi-Fi"
        row1.subtitle = "Connected"
        let wifiIcon = Image(iconName: "network-wireless-symbolic")
        wifiIcon.valign = .center
        row1.addPrefix(wifiIcon)
        group.add(row1)

        // Bluetooth row with switch
        let row2 = ActionRow()
        row2.title = "Bluetooth"
        row2.subtitle = "Disabled"
        let btIcon = Image(iconName: "bluetooth-symbolic")
        btIcon.valign = .center
        row2.addPrefix(btIcon)
        let btSwitch = Switch()
        btSwitch.valign = .center
        row2.addSuffix(btSwitch)
        row2.activatableWidget = btSwitch
        group.add(row2)

        // Expander row
        let expander = ExpanderRow()
        expander.title = "Privacy"
        expander.subtitle = "Location, Camera, Microphone"
        let privIcon = Image(iconName: "security-high-symbolic")
        privIcon.valign = .center
        expander.addPrefix(privIcon)

        let locRow = ActionRow()
        locRow.title = "Location Services"
        let locSwitch = SwitchRow()
        locSwitch.title = "Location Services"
        locSwitch.active = true
        expander.addRow(locSwitch)

        let camRow = SwitchRow()
        camRow.title = "Camera Access"
        camRow.active = true
        expander.addRow(camRow)

        let micRow = SwitchRow()
        micRow.title = "Microphone"
        micRow.active = false
        expander.addRow(micRow)

        group.add(expander)

        // Button row
        let dangerGroup = PreferencesGroup()
        dangerGroup.title = "Danger Zone"

        let resetRow = ActionRow()
        resetRow.title = "Reset All Settings"
        resetRow.subtitle = "This cannot be undone"
        let resetBtn = Button(label: "Reset")
        resetBtn.addCSSClass("destructive-action")
        resetBtn.valign = .center
        resetRow.addSuffix(resetBtn)
        dangerGroup.add(resetRow)

        box.append(group)
        box.append(dangerGroup)

        let clamp = Clamp()
        clamp.maximumSize = 600
        clamp.child = box

        let scrolled = ScrolledWindow()
        scrolled.child = clamp
        return scrolled
    }
}
