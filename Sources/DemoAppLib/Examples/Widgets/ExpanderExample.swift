import Adwaita

@MainActor
struct ExpanderExample: DemoExample {
    let name = "Expander"
    let id = "expander"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let expander = Expander(label: "Click to expand")
    let content = Label("Hidden content revealed!")
    expander.child = content
    expander.expanded = false
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 12)
        box.halign = .center
        box.valign = .center
        box.setMargins(24)

        let title = Label("Expander Widget")
        title.addCSSClass("title-3")
        box.append(title)

        // Basic expander
        let exp1 = Expander(label: "Basic Expander")
        let content1 = Label("This content is hidden until you click the arrow.")
        content1.wrap = true
        exp1.child = content1
        box.append(exp1)

        // Initially expanded
        let exp2 = Expander(label: "Initially Expanded")
        exp2.expanded = true
        let content2Box = Box(orientation: .vertical, spacing: 6)
        content2Box.append(Label("Line 1 of content"))
        content2Box.append(Label("Line 2 of content"))
        content2Box.append(Label("Line 3 of content"))
        exp2.child = content2Box
        box.append(exp2)

        // With markup
        let exp3 = Expander(label: "<b>Bold Label</b> with markup")
        exp3.useMarkup = true
        let content3 = Label("The label above uses Pango markup for bold text.")
        exp3.child = content3
        box.append(exp3)

        let clamp = Clamp()
        clamp.maximumSize = 500
        clamp.child = box
        return clamp
    }
}
