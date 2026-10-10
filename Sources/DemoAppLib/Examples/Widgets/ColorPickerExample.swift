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
        colorBtn.onColorChanged { [weak colorBtn] in
            guard let colorBtn else { return }
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

        let resultLabel = Label("")
        resultLabel.addCSSClass("dim-label")

        // One formatter for the initial text and every change, so the label
        // always shows the button's actual color in the same notation. Weak:
        // the button's own handler calls this closure.
        let showColor = { [weak colorBtn, resultLabel] in
            guard let colorBtn else { return }
            let c = colorBtn.rgba
            let r = Int((c.red * 255).rounded())
            let g = Int((c.green * 255).rounded())
            let b = Int((c.blue * 255).rounded())
            resultLabel.text = "Selected: rgb(\(r), \(g), \(b))"
        }
        showColor()
        colorBtn.onColorChanged { showColor() }

        box.append(colorBtn)
        box.append(resultLabel)

        return box
    }
}
