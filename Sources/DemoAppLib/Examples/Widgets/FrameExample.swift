import Adwaita

@MainActor
struct FrameExample: DemoExample {
    let name = "Frame"
    let id = "frame"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let frame = Frame(label: "Settings")
    let content = Label("Frame content goes here")
    content.setMargins(12)
    frame.child = content
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 16)
        box.halign = .center
        box.valign = .center
        box.setMargins(24)

        let title = Label("Frame Widget")
        title.addCSSClass("title-3")
        box.append(title)

        // Basic frame
        let frame1 = Frame(label: "Basic Frame")
        let content1 = Label("This content is inside a labeled frame.")
        content1.setMargins(12)
        frame1.child = content1
        box.append(frame1)

        // Frame without label
        let frame2 = Frame()
        let content2 = Label("This frame has no label.")
        content2.setMargins(12)
        frame2.child = content2
        box.append(frame2)

        let clamp = Clamp()
        clamp.maximumSize = 400
        clamp.child = box
        return clamp
    }
}
