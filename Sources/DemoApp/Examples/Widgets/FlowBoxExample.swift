import Adwaita
import CAdwaita

@MainActor
struct FlowBoxExample: DemoExample {
    let name = "Flow Box"
    let id = "flowbox"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let flowBox = FlowBox()
    flowBox.minChildrenPerLine = 2
    flowBox.maxChildrenPerLine = 5
    flowBox.rowSpacing = 8
    flowBox.columnSpacing = 8
    flowBox.homogeneous = true
    flowBox.selectionMode = .single

    for i in 1...12 {
        let btn = Button(label: "Item \\(i)")
        flowBox.append(btn)
    }
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 16)
        box.halign = .center
        box.valign = .center
        box.setMargins(24)

        let title = Label("Flow Box")
        title.addCSSClass("title-3")
        box.append(title)

        let flowBox = FlowBox()
        flowBox.minChildrenPerLine = 3
        flowBox.maxChildrenPerLine = 6
        flowBox.rowSpacing = 8
        flowBox.columnSpacing = 8
        flowBox.homogeneous = true
        flowBox.selectionMode = .single

        let colors = ["red", "blue", "green", "orange", "purple",
                       "teal", "pink", "brown", "grey", "yellow",
                       "cyan", "magenta"]
        for (i, color) in colors.enumerated() {
            let btn = Button(label: "\(color) \(i + 1)")
            btn.setSizeRequest(width: 90, height: 40)
            flowBox.append(btn)
        }

        let frame = Frame()
        frame.child = flowBox
        box.append(frame)

        let caption = Label("Resize the window to see items reflow")
        caption.addCSSClass("dim-label")
        box.append(caption)

        let clamp = Clamp()
        clamp.maximumSize = 600
        clamp.child = box
        return clamp
    }
}
