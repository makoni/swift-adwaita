import Adwaita
import CAdwaita

@MainActor
struct PanedExample: DemoExample {
    let name = "Paned"
    let id = "paned"
    let category: ExampleCategory = .composite

    let sourceCode = """
    let paned = Paned(orientation: .horizontal)
    paned.startChild = Label("Left Pane")
    paned.endChild = Label("Right Pane")
    paned.position = 200
    paned.wideHandle = true
    """

    func buildWidget() -> Widget {
        let paned = Paned(orientation: .horizontal)
        paned.wideHandle = true

        // Left pane
        let leftBox = Box(orientation: .vertical, spacing: 12)
        leftBox.setMargins(12)
        let leftTitle = Label("Left Pane")
        leftTitle.addCSSClass("title-4")
        leftBox.append(leftTitle)
        leftBox.append(Label("Drag the handle to resize."))
        paned.startChild = leftBox

        // Right pane — nested vertical paned
        let rightPaned = Paned(orientation: .vertical)
        rightPaned.wideHandle = true

        let topBox = Box(orientation: .vertical, spacing: 6)
        topBox.setMargins(12)
        topBox.append(Label("Top"))
        topBox.append(Label("This is the top section of a nested paned."))
        rightPaned.startChild = topBox

        let bottomBox = Box(orientation: .vertical, spacing: 6)
        bottomBox.setMargins(12)
        bottomBox.append(Label("Bottom"))
        bottomBox.append(Label("This is the bottom section."))
        rightPaned.endChild = bottomBox

        paned.endChild = rightPaned

        paned.hexpand = true
        paned.vexpand = true
        return paned
    }
}
