import Adwaita
import CAdwaita

@MainActor
struct LabelExample: DemoExample {
    let name = "Labels"
    let id = "labels"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    // Plain label
    let plain = Label("Hello, World!")

    // Bold markup
    let bold = Label("")
    bold.useMarkup = true
    bold.text = "<b>Bold</b> and <i>italic</i> text"

    // Wrapping label
    let wrapping = Label(
        "This is a long text that will wrap to multiple lines..."
    )
    wrapping.wrap = true
    wrapping.xalign = 0

    // Selectable label
    let selectable = Label("Select and copy this text")
    selectable.selectable = true

    // Heading styles
    let heading = Label("Title Heading")
    heading.addCSSClass("title-1")

    let subtitle = Label("Subtitle Text")
    subtitle.addCSSClass("title-4")

    // Dim label
    let dim = Label("Secondary information")
    dim.addCSSClass("dim-label")

    // Monospace
    let mono = Label("let x = 42")
    mono.addCSSClass("monospace")
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        // Typography group
        let typoGroup = PreferencesGroup()
        typoGroup.title = "Typography"

        let typoBox = Box(orientation: .vertical, spacing: 12)
        typoBox.setMargins(12)

        let title1 = Label("Title 1")
        title1.addCSSClass("title-1")
        title1.xalign = 0
        typoBox.append(title1)

        let title2 = Label("Title 2")
        title2.addCSSClass("title-2")
        title2.xalign = 0
        typoBox.append(title2)

        let title3 = Label("Title 3")
        title3.addCSSClass("title-3")
        title3.xalign = 0
        typoBox.append(title3)

        let title4 = Label("Title 4")
        title4.addCSSClass("title-4")
        title4.xalign = 0
        typoBox.append(title4)

        let body = Label("Body text — regular content")
        body.xalign = 0
        typoBox.append(body)

        let dim = Label("Dim label — secondary information")
        dim.addCSSClass("dim-label")
        dim.xalign = 0
        typoBox.append(dim)

        let mono = Label("let greeting = \"Hello, swift-adwaita!\"")
        mono.addCSSClass("monospace")
        mono.xalign = 0
        typoBox.append(mono)

        typoGroup.add(typoBox)
        box.append(typoGroup)

        // Features group
        let featGroup = PreferencesGroup()
        featGroup.title = "Features"

        let featBox = Box(orientation: .vertical, spacing: 12)
        featBox.setMargins(12)

        let wrapping = Label("This is a long paragraph of text that demonstrates word wrapping. When the text exceeds the available width, it wraps to the next line automatically, which is useful for displaying descriptions and multi-line content.")
        wrapping.wrap = true
        wrapping.xalign = 0
        featBox.append(wrapping)

        let sep = Separator(orientation: .horizontal)
        featBox.append(sep)

        let selectable = Label("This text is selectable — try selecting and copying it")
        selectable.selectable = true
        selectable.xalign = 0
        featBox.append(selectable)

        featGroup.add(featBox)
        box.append(featGroup)

        let clamp = Clamp()
        clamp.maximumSize = 600
        clamp.child = box

        let scrolled = ScrolledWindow()
        scrolled.child = clamp
        return scrolled
    }
}
