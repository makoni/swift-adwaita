// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct TextViewExample: DemoExample {
    let name = "Text View"
    let id = "textview"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let textView = TextView()
    textView.text = "Hello, World!"
    textView.wrapMode = .wordChar
    textView.monospace = true

    let buffer = textView.buffer
    buffer.onChanged {
        print("Text changed: \\(buffer.charCount) chars")
    }
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 12)
        box.halign = .center
        box.valign = .center
        box.setMargins(24)

        let title = Label("Text View")
        title.addCSSClass("title-3")
        box.append(title)

        let textView = TextView()
        textView.text = "Type something here...\n\nThe TextView supports multi-line text editing with word wrapping, undo/redo, and clipboard operations."
        textView.wrapMode = .wordChar
        textView.leftMargin = 8
        textView.rightMargin = 8
        textView.topMargin = 8
        textView.bottomMargin = 8
        textView.setSizeRequest(width: 400, height: 150)

        let scrolled = ScrolledWindow()
        scrolled.child = textView
        scrolled.setSizeRequest(width: 400, height: 150)

        let frame = Frame()
        frame.child = scrolled
        box.append(frame)

        let infoLabel = Label("Characters: 0 | Lines: 0")
        infoLabel.addCSSClass("dim-label")

        let buffer = textView.buffer
        let updateInfo = { [buffer, infoLabel] in
            infoLabel.text = "Characters: \(buffer.charCount) | Lines: \(buffer.lineCount)"
        }
        updateInfo()
        buffer.onChanged { updateInfo() }

        box.append(infoLabel)

        // Controls
        let controlsBox = Box(orientation: .horizontal, spacing: 8)
        controlsBox.halign = .center

        let monoBtn = ToggleButton(label: "Monospace")
        monoBtn.onToggled { [monoBtn, textView] in
            textView.monospace = monoBtn.active
        }
        controlsBox.append(monoBtn)

        let editableBtn = ToggleButton(label: "Editable")
        editableBtn.active = true
        editableBtn.onToggled { [editableBtn, textView] in
            textView.editable = editableBtn.active
        }
        controlsBox.append(editableBtn)

        box.append(controlsBox)

        let clamp = Clamp()
        clamp.maximumSize = 500
        clamp.child = box
        return clamp
    }
}
