// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct ColorPickerExample: DemoExample {
    let name = "Color Picker"
    let id = "colorpicker"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let colorBtn = ColorDialogButton()
    colorBtn.rgba = RGBA(red: 0.2, green: 0.6, blue: 1.0)
    colorBtn.onColorChanged {
        let c = colorBtn.rgba
        print("Color: \\(c.red), \\(c.green), \\(c.blue)")
    }
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 16)
        box.halign = .center
        box.valign = .center

        let title = Label("Color Picker")
        title.addCSSClass("title-3")
        box.append(title)

        let colorBtn = ColorDialogButton()
        colorBtn.rgba = RGBA(red: 0.2, green: 0.6, blue: 1.0)

        let resultLabel = Label("Selected: (0.2, 0.6, 1.0)")
        resultLabel.addCSSClass("dim-label")

        colorBtn.onColorChanged { [colorBtn, resultLabel] in
            let c = colorBtn.rgba
            let r = Int(c.red * 255), g = Int(c.green * 255), b = Int(c.blue * 255)
            resultLabel.text = "Selected: rgb(\(r), \(g), \(b))"
        }

        box.append(colorBtn)
        box.append(resultLabel)

        return box
    }
}
