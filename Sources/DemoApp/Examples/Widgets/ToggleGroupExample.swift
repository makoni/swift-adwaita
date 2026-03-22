import Adwaita

@MainActor
struct ToggleGroupExample: DemoExample {
    let name = "Toggle Group"
    let id = "toggle-group"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let group = ToggleGroup()
    let t1 = Toggle()
    t1.label = "Day"
    let t2 = Toggle()
    t2.label = "Week"
    let t3 = Toggle()
    t3.label = "Month"
    group.add(t1)
    group.add(t2)
    group.add(t3)
    group.active = 0
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group1 = PreferencesGroup()
        group1.title = "Toggle Groups"
        group1.description = "AdwToggleGroup provides mutually exclusive toggles"

        // Text toggles
        let toggleGroup1 = ToggleGroup()
        toggleGroup1.setMargins(12)
        let d = Toggle()
        d.label = "Day"
        let w = Toggle()
        w.label = "Week"
        let m = Toggle()
        m.label = "Month"
        let y = Toggle()
        y.label = "Year"
        toggleGroup1.add(d)
        toggleGroup1.add(w)
        toggleGroup1.add(m)
        toggleGroup1.add(y)
        toggleGroup1.active = 0
        group1.add(toggleGroup1)

        box.append(group1)

        // Icon toggles
        let group2 = PreferencesGroup()
        group2.title = "Icon Toggles"

        let toggleGroup2 = ToggleGroup()
        toggleGroup2.setMargins(12)
        let grid = Toggle()
        grid.iconName = "view-grid-symbolic"
        grid.tooltip = "Grid View"
        let list = Toggle()
        list.iconName = "view-list-symbolic"
        list.tooltip = "List View"
        toggleGroup2.add(grid)
        toggleGroup2.add(list)
        toggleGroup2.active = 0
        group2.add(toggleGroup2)

        box.append(group2)

        // Homogeneous
        let group3 = PreferencesGroup()
        group3.title = "Homogeneous"

        let toggleGroup3 = ToggleGroup()
        toggleGroup3.setMargins(12)
        toggleGroup3.homogeneous = true
        let s = Toggle()
        s.label = "S"
        let med = Toggle()
        med.label = "M"
        let l = Toggle()
        l.label = "L"
        let xl = Toggle()
        xl.label = "XL"
        toggleGroup3.add(s)
        toggleGroup3.add(med)
        toggleGroup3.add(l)
        toggleGroup3.add(xl)
        toggleGroup3.active = 1
        group3.add(toggleGroup3)

        box.append(group3)

        return box.scrollableClamped()
    }
}
