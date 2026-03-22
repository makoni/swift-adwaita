import Adwaita
import CAdwaita

@MainActor
struct OverlayExample: DemoExample {
    let name = "Overlay"
    let id = "overlay"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let overlay = Overlay()
    let image = Image(iconName: "folder-symbolic", size: .dialog)
    overlay.child = image

    let badge = Label("3")
    badge.addCSSClass("accent")
    badge.halign = .end
    badge.valign = .start
    overlay.addOverlay(badge)
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 16)
        box.halign = .center
        box.valign = .center

        let title = Label("Overlay")
        title.addCSSClass("title-3")
        box.append(title)

        // Example 1: Badge overlay
        let overlay1 = Overlay()
        let icon1 = Image(iconName: "folder-symbolic")
        icon1.pixelSize = 64
        icon1.setSizeRequest(width: 80, height: 80)
        overlay1.child = icon1

        let badge = Label(" 3 ")
        badge.addCSSClass("accent")
        badge.addCSSClass("caption")
        badge.halign = .end
        badge.valign = .start
        badge.setMargins(4)
        overlay1.addOverlay(badge)
        box.append(overlay1)

        // Example 2: Text overlay on drawing area
        let overlay2 = Overlay()
        let da = DrawingArea()
        da.contentWidth = 200
        da.contentHeight = 100
        da.setDrawFunc { cr, width, height in
            cairo_set_source_rgb(cr, 0.2, 0.5, 0.8)
            cairo_rectangle(cr, 0, 0, Double(width), Double(height))
            cairo_fill(cr)
        }
        overlay2.child = da

        let overlayLabel = Label("Overlaid Text")
        overlayLabel.addCSSClass("title-2")
        overlayLabel.halign = .center
        overlayLabel.valign = .center
        overlay2.addOverlay(overlayLabel)

        let frame = Frame()
        frame.child = overlay2
        box.append(frame)

        let caption = Label("Widgets stacked on top of each other")
        caption.addCSSClass("dim-label")
        box.append(caption)

        return box
    }
}
