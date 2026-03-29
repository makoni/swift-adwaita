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
        guard let toggleGroup1 = ToggleGroup(),
              let toggleGroup2 = ToggleGroup(),
              let toggleGroup3 = ToggleGroup() else {
            return Label("ToggleGroup requires libadwaita 1.7+")
        }

        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group1 = PreferencesGroup()
        group1.title = "Toggle Groups"
        group1.description = "AdwToggleGroup provides mutually exclusive toggles"

        // Text toggles
        toggleGroup1.setMargins(12)
        if let d = Toggle() { d.label = "Day"
            toggleGroup1.add(d)
        }
        if let w = Toggle() { w.label = "Week"
            toggleGroup1.add(w)
        }
        if let m = Toggle() { m.label = "Month"
            toggleGroup1.add(m)
        }
        if let y = Toggle() { y.label = "Year"
            toggleGroup1.add(y)
        }
        toggleGroup1.active = 0
        group1.add(toggleGroup1)

        box.append(group1)

        // Icon toggles
        let group2 = PreferencesGroup()
        group2.title = "Icon Toggles"

        toggleGroup2.setMargins(12)
        if let grid = Toggle() {
            grid.iconName = "view-grid-symbolic"
            grid.tooltip = "Grid View"
            toggleGroup2.add(grid)
        }
        if let list = Toggle() {
            list.iconName = "view-list-symbolic"
            list.tooltip = "List View"
            toggleGroup2.add(list)
        }
        toggleGroup2.active = 0
        group2.add(toggleGroup2)

        box.append(group2)

        // Homogeneous
        let group3 = PreferencesGroup()
        group3.title = "Homogeneous"

        toggleGroup3.setMargins(12)
        toggleGroup3.homogeneous = true
        if let s = Toggle() { s.label = "S"
            toggleGroup3.add(s)
        }
        if let med = Toggle() { med.label = "M"
            toggleGroup3.add(med)
        }
        if let l = Toggle() { l.label = "L"
            toggleGroup3.add(l)
        }
        if let xl = Toggle() { xl.label = "XL"
            toggleGroup3.add(xl)
        }
        toggleGroup3.active = 1
        group3.add(toggleGroup3)

        box.append(group3)

        return box.scrollableClamped()
    }
}
