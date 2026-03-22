import Adwaita

@MainActor
struct ComboRowExample: DemoExample {
    let name = "Combo Row"
    let id = "combo-row"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let combo = ComboRow()
    combo.title = "Color Theme"
    combo.subtitle = "Choose your preferred theme"

    let model = StringList(["Default", "Light", "Dark"])
    combo.setModel(model)
    combo.selected = 0
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Combo Rows"
        group.description = "AdwComboRow lets users pick from a dropdown list"

        let combo1 = ComboRow()
        combo1.title = "Color Theme"
        combo1.subtitle = "Choose your preferred theme"
        let model1 = StringList(["Default", "Light", "Dark", "High Contrast"])
        combo1.setModel(model1)
        combo1.selected = 0
        group.add(combo1)

        let combo2 = ComboRow()
        combo2.title = "Language"
        combo2.subtitle = "Select display language"
        let model2 = StringList(["English", "Deutsch", "Français", "Español", "日本語"])
        combo2.setModel(model2)
        combo2.selected = 0
        combo2.enableSearch = true
        group.add(combo2)

        let combo3 = ComboRow()
        combo3.title = "Font Size"
        let model3 = StringList(["Small", "Medium", "Large", "Extra Large"])
        combo3.setModel(model3)
        combo3.selected = 1
        combo3.useSubtitle = true
        group.add(combo3)

        box.append(group)

        return box.scrollableClamped()
    }
}
