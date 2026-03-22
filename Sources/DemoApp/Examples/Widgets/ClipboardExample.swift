import Adwaita
import CAdwaita

@MainActor
struct ClipboardExample: DemoExample {
    let name = "Clipboard"
    let id = "clipboard"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    // Copy text to clipboard
    widget.clipboard.setText("Hello, clipboard!")

    // Read text from clipboard
    widget.clipboard.readText { text in
        if let text {
            label.text = text
        }
    }

    // Monitor clipboard changes
    widget.clipboard.onChanged {
        print("Clipboard changed!")
    }
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        // Copy section
        let copyGroup = PreferencesGroup()
        copyGroup.title = "Copy to Clipboard"
        copyGroup.description = "Enter text and copy it"

        let entry = Entry()
        entry.text = "Hello from swift-adwaita!"
        entry.hexpand = true
        entry.setMargins(12)
        copyGroup.add(entry)

        let copyBtn = Button(label: "Copy")
        copyBtn.addCSSClass("suggested-action")
        copyBtn.halign = .center
        copyBtn.onClicked { [entry, box] in
            box.clipboard.setText(entry.text)
        }
        copyGroup.add(copyBtn)

        box.append(copyGroup)

        // Paste section
        let pasteGroup = PreferencesGroup()
        pasteGroup.title = "Read from Clipboard"
        pasteGroup.description = "Paste to see the current clipboard content"

        let resultLabel = Label("(click Paste to read clipboard)")
        resultLabel.addCSSClass("monospace")
        resultLabel.wrap = true
        resultLabel.xalign = 0
        resultLabel.setMargins(12)

        let resultFrame = Frame()
        resultFrame.child = resultLabel
        pasteGroup.add(resultFrame)

        let pasteBtn = Button(label: "Paste")
        pasteBtn.addCSSClass("pill")
        pasteBtn.halign = .center
        pasteBtn.onClicked { [box, resultLabel] in
            box.clipboard.readText { text in
                resultLabel.text = text ?? "(empty clipboard)"
            }
        }
        pasteGroup.add(pasteBtn)

        box.append(pasteGroup)

        let clamp = Clamp()
        clamp.maximumSize = 600
        clamp.child = box

        let scrolled = ScrolledWindow()
        scrolled.child = clamp
        return scrolled
    }
}
