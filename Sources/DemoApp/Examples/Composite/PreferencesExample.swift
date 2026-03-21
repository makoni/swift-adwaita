import Adwaita
import CAdwaita

@MainActor
struct PreferencesExample: DemoExample {
    let name = "Preferences Page"
    let id = "preferences"
    let category: ExampleCategory = .composite

    let sourceCode = """
    // Account settings group
    let accountGroup = PreferencesGroup()
    accountGroup.title = "Account"
    accountGroup.description = "Manage your account settings"

    let nameRow = EntryRow()
    nameRow.title = "Display Name"
    accountGroup.add(nameRow)

    let notifyRow = SwitchRow()
    notifyRow.title = "Notifications"
    notifyRow.subtitle = "Receive push notifications"
    notifyRow.active = true
    accountGroup.add(notifyRow)

    let fontSizeRow = SpinRow.newWithRange(min: 8, max: 72, step: 1)
    fontSizeRow.title = "Font Size"
    fontSizeRow.value = 14
    accountGroup.add(fontSizeRow)

    // Appearance group with expander
    let appearanceGroup = PreferencesGroup()
    appearanceGroup.title = "Appearance"

    let expander = ExpanderRow()
    expander.title = "Advanced Settings"
    expander.subtitle = "Extra configuration options"

    let animRow = SwitchRow()
    animRow.title = "Enable Animations"
    animRow.active = true
    expander.addRow(animRow)

    let dpiRow = SpinRow.newWithRange(min: 72, max: 288, step: 12)
    dpiRow.title = "DPI Scale"
    dpiRow.value = 96
    expander.addRow(dpiRow)

    appearanceGroup.add(expander)
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 24)
        box.setMargins(24)

        // Account group
        let accountGroup = PreferencesGroup()
        accountGroup.title = "Account"
        accountGroup.description = "Manage your account settings"

        let nameRow = EntryRow()
        nameRow.title = "Display Name"
        accountGroup.add(nameRow)

        let notifyRow = SwitchRow()
        notifyRow.title = "Notifications"
        notifyRow.subtitle = "Receive push notifications"
        notifyRow.active = true
        accountGroup.add(notifyRow)

        let fontSizeRow = SpinRow.newWithRange(min: 8, max: 72, step: 1)
        fontSizeRow.title = "Font Size"
        fontSizeRow.value = 14
        accountGroup.add(fontSizeRow)

        box.append(accountGroup)

        // Appearance group
        let appearanceGroup = PreferencesGroup()
        appearanceGroup.title = "Appearance"

        let expander = ExpanderRow()
        expander.title = "Advanced Settings"
        expander.subtitle = "Extra configuration options"

        let animRow = SwitchRow()
        animRow.title = "Enable Animations"
        animRow.active = true
        expander.addRow(animRow)

        let dpiRow = SpinRow.newWithRange(min: 72, max: 288, step: 12)
        dpiRow.title = "DPI Scale"
        dpiRow.value = 96
        expander.addRow(dpiRow)

        appearanceGroup.add(expander)
        box.append(appearanceGroup)

        let clamp = Clamp()
        clamp.maximumSize = 600
        clamp.child = box

        let scrolled = ScrolledWindow()
        scrolled.child = clamp
        return scrolled
    }
}
