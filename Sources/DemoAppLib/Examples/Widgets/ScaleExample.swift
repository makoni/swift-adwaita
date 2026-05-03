import Adwaita

@MainActor
struct ScaleExample: DemoExample {
    let name = "Scale"
    let id = "scale"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    // Basic horizontal scale
    let scale = Scale(orientation: .horizontal,
                      min: 0, max: 100, step: 1)
    scale.value = 50
    scale.drawValue = true

    // Custom value formatting
    scale.setFormatValueFunc { value in
        "\\(Int(value))%"
    }

    // Scale with decimal precision
    let precise = Scale(orientation: .horizontal,
                        min: 0, max: 1, step: 0.01)
    precise.digits = 2
    precise.drawValue = true
    precise.hasOrigin = true

    // Value changed callback
    scale.onValueChanged {
        print("Value: \\(scale.value)")
    }
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        // Basic scale
        let group1 = PreferencesGroup()
        group1.title = "Basic Scale"
        group1.description = "A simple slider from 0 to 100"

        let valueLabel1 = Label("50")
        valueLabel1.addCSSClass("title-2")

        let scale1 = Scale(orientation: .horizontal, min: 0, max: 100, step: 1)
        scale1.value = 50
        scale1.drawValue = true
        scale1.hasOrigin = true
        scale1.setFormatValueFunc { value in "\(Int(value))%" }
        scale1.hexpand = true
        scale1.setMargins(12)
        scale1.onValueChanged { [scale1, valueLabel1] in
            valueLabel1.text = "\(Int(scale1.value))"
        }

        group1.add(scale1)

        let valueRow1 = ActionRow()
        valueRow1.title = "Current Value"
        valueLabel1.valign = .center
        valueRow1.addSuffix(valueLabel1)
        group1.add(valueRow1)

        box.append(group1)

        // Precise scale
        let group2 = PreferencesGroup()
        group2.title = "Precise Scale"
        group2.description = "A scale with decimal precision (0.0 to 1.0)"

        let valueLabel2 = Label("0.50")
        valueLabel2.addCSSClass("title-2")

        let scale2 = Scale(orientation: .horizontal, min: 0, max: 1, step: 0.01)
        scale2.value = 0.5
        scale2.drawValue = true
        scale2.digits = 2
        scale2.hasOrigin = true
        scale2.hexpand = true
        scale2.setMargins(12)
        scale2.onValueChanged { [scale2, valueLabel2] in
            let v = Int(scale2.value * 100)
            let frac = v % 100
            valueLabel2.text = "\(v / 100).\(frac < 10 ? "0" : "")\(frac)"
        }

        group2.add(scale2)

        let valueRow2 = ActionRow()
        valueRow2.title = "Current Value"
        valueLabel2.valign = .center
        valueRow2.addSuffix(valueLabel2)
        group2.add(valueRow2)

        box.append(group2)

        // Scale with marks / no origin
        let group3 = PreferencesGroup()
        group3.title = "Scale Options"
        group3.description = "An inverted scale without origin indicator"

        let scale3 = Scale(orientation: .horizontal, min: 0, max: 10, step: 1)
        scale3.value = 7
        scale3.drawValue = true
        scale3.digits = 0
        scale3.hasOrigin = false
        scale3.inverted = true
        scale3.hexpand = true
        scale3.setMargins(12)

        group3.add(scale3)

        let invertRow = ActionRow()
        invertRow.title = "Inverted"
        invertRow.subtitle = "This scale counts right-to-left"
        let invertIcon = Image(iconName: "object-flip-horizontal-symbolic")
        invertIcon.valign = .center
        invertRow.addSuffix(invertIcon)
        group3.add(invertRow)

        box.append(group3)

        return box.scrollableClamped()
    }
}
