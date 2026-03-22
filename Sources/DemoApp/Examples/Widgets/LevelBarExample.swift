import Adwaita

@MainActor
struct LevelBarExample: DemoExample {
    let name = "Level Bar"
    let id = "levelbar"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let bar = LevelBar()
    bar.value = 0.7
    bar.minValue = 0
    bar.maxValue = 1

    // Discrete mode
    let discrete = LevelBar(min: 0, max: 5)
    discrete.mode = GTK_LEVEL_BAR_MODE_DISCRETE
    discrete.value = 3
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        // Continuous level bar
        let group1 = PreferencesGroup()
        group1.title = "Continuous"
        group1.description = "A level bar with continuous fill"

        let bar1 = LevelBar()
        bar1.minValue = 0
        bar1.maxValue = 1
        bar1.value = 0.7
        bar1.hexpand = true
        bar1.setMargins(12)
        group1.add(bar1)

        let scale1 = Scale(orientation: .horizontal, min: 0, max: 100, step: 1)
        scale1.value = 70
        scale1.hexpand = true
        scale1.setMargins(12)
        scale1.onValueChanged { [scale1, bar1] in
            bar1.value = scale1.value / 100.0
        }
        group1.add(scale1)

        box.append(group1)

        // Discrete level bar
        let group2 = PreferencesGroup()
        group2.title = "Discrete"
        group2.description = "A level bar with discrete blocks"

        let bar2 = LevelBar(min: 0, max: 5)
        bar2.mode = GTK_LEVEL_BAR_MODE_DISCRETE
        bar2.value = 3
        bar2.hexpand = true
        bar2.setMargins(12)
        group2.add(bar2)

        let scale2 = Scale(orientation: .horizontal, min: 0, max: 5, step: 1)
        scale2.value = 3
        scale2.drawValue = true
        scale2.digits = 0
        scale2.hexpand = true
        scale2.setMargins(12)
        scale2.onValueChanged { [scale2, bar2] in
            bar2.value = scale2.value
        }
        group2.add(scale2)

        box.append(group2)

        // Inverted level bar
        let group3 = PreferencesGroup()
        group3.title = "Inverted"
        group3.description = "A level bar with inverted direction"

        let bar3 = LevelBar()
        bar3.minValue = 0
        bar3.maxValue = 1
        bar3.value = 0.4
        bar3.inverted = true
        bar3.hexpand = true
        bar3.setMargins(12)
        group3.add(bar3)

        box.append(group3)

        return box.scrollableClamped()
    }
}
