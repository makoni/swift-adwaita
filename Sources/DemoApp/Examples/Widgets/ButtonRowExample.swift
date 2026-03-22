import Adwaita

@MainActor
struct ButtonRowExample: DemoExample {
    let name = "Button Row"
    let id = "button-row"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let row = ButtonRow()
    row.title = "Clear Cache"
    row.startIconName = "user-trash-symbolic"
    row.endIconName = "go-next-symbolic"
    row.onActivated { print("Activated!") }
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Button Rows"
        group.description = "AdwButtonRow is a list row that acts as a button"

        let row1 = ButtonRow()
        row1.title = "Clear Cache"
        row1.startIconName = "user-trash-symbolic"
        group.add(row1)

        let row2 = ButtonRow()
        row2.title = "Export Data"
        row2.startIconName = "document-save-symbolic"
        row2.endIconName = "go-next-symbolic"
        group.add(row2)

        let row3 = ButtonRow()
        row3.title = "Reset All Settings"
        row3.startIconName = "edit-clear-all-symbolic"
        row3.addCSSClass("destructive-action")
        group.add(row3)

        box.append(group)

        return box.scrollableClamped()
    }
}
