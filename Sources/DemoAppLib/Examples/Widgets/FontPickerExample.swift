// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct FontPickerExample: DemoExample {
    let name = "Font Picker"
    let id = "fontpicker"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let fontBtn = FontDialogButton()
    fontBtn.fontDescription = "Sans 14"
    fontBtn.onFontChanged {
        print("Font: \\(fontBtn.fontDescription ?? "none")")
    }
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 16)
        box.halign = .center
        box.valign = .center

        let title = Label("Font Picker")
        title.addCSSClass("title-3")
        box.append(title)

        let fontBtn = FontDialogButton()
        fontBtn.fontDescription = "Sans 14"

        let resultLabel = Label("Selected: Sans 14")
        resultLabel.addCSSClass("dim-label")

        fontBtn.onFontChanged { [fontBtn, resultLabel] in
            resultLabel.text = "Selected: \(fontBtn.fontDescription ?? "none")"
        }

        box.append(fontBtn)
        box.append(resultLabel)

        return box
    }
}
