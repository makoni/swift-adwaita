import Adwaita

@MainActor
struct EmojiChooserExample: DemoExample {
    let name = "Emoji Chooser"
    let id = "emojichooser"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let menuBtn = MenuButton()
    menuBtn.label = "Pick Emoji"

    let emojiChooser = EmojiChooser()
    menuBtn.popover = emojiChooser

    emojiChooser.onEmojiPicked { emoji in
        print("Picked: \\(emoji)")
    }
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 16)
        box.halign = .center
        box.valign = .center

        let title = Label("Emoji Chooser")
        title.addCSSClass("title-3")
        box.append(title)

        let resultLabel = Label("Pick an emoji below")
        resultLabel.addCSSClass("title-1")
        box.append(resultLabel)

        let menuBtn = MenuButton()
        menuBtn.label = "Pick Emoji"
        menuBtn.halign = .center

        let emojiChooser = EmojiChooser()
        menuBtn.popover = emojiChooser

        emojiChooser.onEmojiPicked { [resultLabel] emoji in
            resultLabel.text = emoji
        }

        box.append(menuBtn)

        let caption = Label("Uses GtkEmojiChooser in a popover")
        caption.addCSSClass("dim-label")
        box.append(caption)

        return box
    }
}
