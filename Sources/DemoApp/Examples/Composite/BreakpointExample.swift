import Adwaita

@MainActor
struct BreakpointExample: DemoExample {
    let name = "Breakpoint"
    let id = "breakpoint"
    let category: ExampleCategory = .composite

    let sourceCode = """
    // Create a breakpoint for narrow windows
    let condition = BreakpointCondition(parse: "max-width: 500sp")
    let bp = Breakpoint(condition: condition)

    // Change layout when breakpoint activates
    bp.addSetter(box, property: .orientation, value: 1) // vertical
    bp.addSetter(box, property: .spacing, value: 8)

    bp.onApply { print("Narrow layout") }
    bp.onUnapply { print("Wide layout") }

    let bin = BreakpointBin()
    bin.child = box
    bin.addBreakpoint(bp)
    """

    func buildWidget() -> Widget {
        // Status label
        let statusLabel = Label("Wide layout")
        statusLabel.addCSSClass("title-4")

        // Two content cards side by side (horizontal) that stack vertically when narrow
        let card1 = Box(orientation: .vertical, spacing: 8)
        card1.setMargins(16)
        let icon1 = Image(iconName: "weather-clear-symbolic")
        icon1.pixelSize = 48
        let label1 = Label("Card One")
        label1.addCSSClass("heading")
        let desc1 = Label("This card sits beside the other in wide layout")
        desc1.addCSSClass("dim-label")
        desc1.wrap = true
        card1.append(icon1)
        card1.append(label1)
        card1.append(desc1)
        card1.addCSSClass("card")
        card1.hexpand = true

        let card2 = Box(orientation: .vertical, spacing: 8)
        card2.setMargins(16)
        let icon2 = Image(iconName: "weather-overcast-symbolic")
        icon2.pixelSize = 48
        let label2 = Label("Card Two")
        label2.addCSSClass("heading")
        let desc2 = Label("In narrow layout, cards stack vertically")
        desc2.addCSSClass("dim-label")
        desc2.wrap = true
        card2.append(icon2)
        card2.append(label2)
        card2.append(desc2)
        card2.addCSSClass("card")
        card2.hexpand = true

        // The layout box that changes orientation
        let cardsBox = Box(orientation: .horizontal, spacing: 16)
        cardsBox.append(card1)
        cardsBox.append(card2)

        // Breakpoint: switch to vertical below 500sp
        let condition = BreakpointCondition(parse: "max-width: 500sp")
        let bp = Breakpoint(condition: condition)
        // orientation: 1 = vertical (GTK_ORIENTATION_VERTICAL)
        bp.addSetter(cardsBox, property: .orientation, value: 1)
        bp.addSetter(cardsBox, property: .spacing, value: 8)
        bp.onApply { statusLabel.text = "Narrow layout (< 500sp)" }
        bp.onUnapply { statusLabel.text = "Wide layout (\u{2265} 500sp)" }

        // Outer layout
        let outerBox = Box(orientation: .vertical, spacing: 16)
        outerBox.setMargins(24)
        outerBox.halign = .fill

        let title = Label("Responsive Breakpoint")
        title.addCSSClass("title-3")
        outerBox.append(title)

        let hint = Label("Resize the window to see cards reflow between horizontal and vertical layout")
        hint.addCSSClass("dim-label")
        hint.wrap = true
        outerBox.append(hint)

        outerBox.append(statusLabel)
        outerBox.append(cardsBox)

        // Wrap in BreakpointBin so the breakpoint responds to this widget's size
        let bin = BreakpointBin()
        bin.child = outerBox
        bin.addBreakpoint(bp)
        bin.hexpand = true
        bin.vexpand = true
        bin.setSizeRequest(width: 360, height: 260)

        return bin
    }
}
