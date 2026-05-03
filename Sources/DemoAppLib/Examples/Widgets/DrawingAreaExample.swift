import Adwaita

@MainActor
struct DrawingAreaExample: DemoExample {
    let name = "Drawing Area"
    let id = "drawingarea"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let drawingArea = DrawingArea()
    drawingArea.contentWidth = 300
    drawingArea.contentHeight = 200
    drawingArea.setDrawFunc { cr, width, height in
        // Blue background
        cr.setSourceRGB(0.2, 0.4, 0.8)
        cr.rectangle(x: 0, y: 0, width: Double(width), height: Double(height))
        cr.fill()

        // White circle
        let cx = Double(width) / 2, cy = Double(height) / 2
        cr.setSourceRGB(1, 1, 1)
        cr.arc(centerX: cx, centerY: cy, radius: 50, startAngle: 0, endAngle: .pi * 2)
        cr.fill()
    }
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 16)
        box.halign = .center
        box.valign = .center

        let title = Label("Drawing Area")
        title.addCSSClass("title-3")
        box.append(title)

        let drawingArea = DrawingArea()
        drawingArea.contentWidth = 300
        drawingArea.contentHeight = 200

        drawingArea.setDrawFunc { cr, width, height in
            let w = Double(width)
            let h = Double(height)

            // Gradient background
            cr.setSourceRGB(0.15, 0.3, 0.6)
            cr.rectangle(x: 0, y: 0, width: w, height: h)
            cr.fill()

            // White circle
            cr.setSourceRGB(1.0, 1.0, 1.0)
            cr.arc(centerX: w / 2, centerY: h / 2, radius: 60, startAngle: 0, endAngle: .pi * 2)
            cr.fill()

            // Yellow smaller circle
            cr.setSourceRGB(1.0, 0.85, 0.2)
            cr.arc(centerX: w / 2, centerY: h / 2, radius: 35, startAngle: 0, endAngle: .pi * 2)
            cr.fill()

            // Red triangle
            cr.setSourceRGB(0.9, 0.2, 0.2)
            cr.moveTo(x: w * 0.1, y: h * 0.8)
            cr.lineTo(x: w * 0.3, y: h * 0.3)
            cr.lineTo(x: w * 0.5, y: h * 0.8)
            cr.closePath()
            cr.fill()

            // Green rectangle
            cr.setSourceRGB(0.2, 0.8, 0.4)
            cr.rectangle(x: w * 0.6, y: h * 0.2, width: w * 0.3, height: h * 0.3)
            cr.fill()
        }

        let frame = Frame()
        frame.child = drawingArea
        box.append(frame)

        let caption = Label("Custom drawing with Cairo")
        caption.addCSSClass("dim-label")
        box.append(caption)

        return box
    }
}
