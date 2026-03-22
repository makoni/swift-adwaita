import Adwaita

@MainActor
struct SeparatorExample: DemoExample {
    let name = "Separator"
    let id = "separator"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    // Horizontal separator
    let hSep = Separator(orientation: .horizontal)

    // Vertical separator
    let vSep = Separator(orientation: .vertical)

    // Common usage: between items in a vertical box
    box.append(Label("Above"))
    box.append(Separator())
    box.append(Label("Below"))
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        // Horizontal separators
        let group1 = PreferencesGroup()
        group1.title = "Horizontal Separator"
        group1.description = "Draws a horizontal line between content"

        let hbox = Box(orientation: .vertical, spacing: 16)
        hbox.setMargins(12)

        let label1 = Label("Content above")
        label1.addCSSClass("title-4")
        hbox.append(label1)

        hbox.append(Separator(orientation: .horizontal))

        let label2 = Label("Content below")
        label2.addCSSClass("title-4")
        hbox.append(label2)

        hbox.append(Separator(orientation: .horizontal))

        let label3 = Label("More content")
        label3.addCSSClass("title-4")
        hbox.append(label3)

        group1.add(hbox)
        box.append(group1)

        // Vertical separators
        let group2 = PreferencesGroup()
        group2.title = "Vertical Separator"
        group2.description = "Draws a vertical line between content"

        let vbox = Box(orientation: .horizontal, spacing: 16)
        vbox.setMargins(12)
        vbox.halign = .center

        let left = Label("Left")
        left.addCSSClass("title-4")
        vbox.append(left)

        let vSep = Separator(orientation: .vertical)
        vSep.setSizeRequest(width: -1, height: 40)
        vbox.append(vSep)

        let middle = Label("Middle")
        middle.addCSSClass("title-4")
        vbox.append(middle)

        let vSep2 = Separator(orientation: .vertical)
        vSep2.setSizeRequest(width: -1, height: 40)
        vbox.append(vSep2)

        let right = Label("Right")
        right.addCSSClass("title-4")
        vbox.append(right)

        group2.add(vbox)
        box.append(group2)

        return box.scrollableClamped()
    }
}
