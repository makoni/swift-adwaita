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
        cairo_set_source_rgb(cr, 0.2, 0.4, 0.8)
        cairo_rectangle(cr, 0, 0, Double(width), Double(height))
        cairo_fill(cr)

        // White circle
        cairo_set_source_rgb(cr, 1, 1, 1)
        cairo_arc(cr, Double(width)/2, Double(height)/2, 50, 0, .pi * 2)
        cairo_fill(cr)
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
            cairo_set_source_rgb(cr, 0.15, 0.3, 0.6)
            cairo_rectangle(cr, 0, 0, w, h)
            cairo_fill(cr)

            // White circle
            cairo_set_source_rgb(cr, 1.0, 1.0, 1.0)
            cairo_arc(cr, w / 2, h / 2, 60, 0, Double.pi * 2)
            cairo_fill(cr)

            // Yellow smaller circle
            cairo_set_source_rgb(cr, 1.0, 0.85, 0.2)
            cairo_arc(cr, w / 2, h / 2, 35, 0, Double.pi * 2)
            cairo_fill(cr)

            // Red triangle
            cairo_set_source_rgb(cr, 0.9, 0.2, 0.2)
            cairo_move_to(cr, w * 0.1, h * 0.8)
            cairo_line_to(cr, w * 0.3, h * 0.3)
            cairo_line_to(cr, w * 0.5, h * 0.8)
            cairo_close_path(cr)
            cairo_fill(cr)

            // Green rectangle
            cairo_set_source_rgb(cr, 0.2, 0.8, 0.4)
            cairo_rectangle(cr, w * 0.6, h * 0.2, w * 0.3, h * 0.3)
            cairo_fill(cr)
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
