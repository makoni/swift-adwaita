import Adwaita

@MainActor
struct OverlayExample: DemoExample {
    let name = "Overlay"
    let id = "overlay"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let overlay = Overlay()
    let image = Image(iconName: "folder-symbolic")
    image.pixelSize = 48
    overlay.child = image

    let badge = Label("3")
    badge.addCSSClass("accent")
    badge.halign = .end
    badge.valign = .start
    overlay.addOverlay(badge)
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        // Example 1: Notification badge on avatar
        let group1 = PreferencesGroup()
        group1.title = "Badge Overlay"
        group1.description = "Overlay a notification badge on an avatar"

        let overlay1 = Overlay()
        let avatar = Avatar(size: 64, text: "Ada", showInitials: true)
        overlay1.child = avatar

        let badge = Label(" 5 ")
        badge.addCSSClass("accent")
        badge.addCSSClass("caption-heading")
        badge.halign = .end
        badge.valign = .start
        overlay1.addOverlay(badge)
        overlay1.halign = .center
        overlay1.setMargins(12)
        group1.add(overlay1)

        box.append(group1)

        // Example 2: Icon overlays
        let group2 = PreferencesGroup()
        group2.title = "Icon Overlays"
        group2.description = "Overlay status indicators on icons"

        let iconsBox = Box(orientation: .horizontal, spacing: 24)
        iconsBox.halign = .center
        iconsBox.setMargins(12)

        let icons = [
            ("folder-symbolic", "emblem-ok-symbolic", "success"),
            ("mail-unread-symbolic", "starred-symbolic", "warning"),
            ("drive-harddisk-symbolic", "process-stop-symbolic", "error")
        ]
        for (base, overlay, style) in icons {
            let ov = Overlay()
            let baseIcon = Image(iconName: base)
            baseIcon.pixelSize = 48
            ov.child = baseIcon

            let badge = Image(iconName: overlay)
            badge.pixelSize = 16
            badge.halign = .end
            badge.valign = .end
            badge.addCSSClass(style)
            ov.addOverlay(badge)
            iconsBox.append(ov)
        }
        group2.add(iconsBox)

        box.append(group2)

        // Example 3: Text overlay on a colored surface
        let group3 = PreferencesGroup()
        group3.title = "Content Overlay"
        group3.description = "Place widgets on top of other content"

        let overlay3 = Overlay()
        let da = DrawingArea()
        da.contentWidth = 300
        da.contentHeight = 80
        da.setDrawFunc { cr, width, height in
            cr.setSourceRGB(0.2, 0.45, 0.7)
            cr.rectangle(x: 0, y: 0, width: Double(width), height: Double(height))
            cr.fill()
        }
        overlay3.child = da

        let overlayLabel = Label("Overlaid Text")
        overlayLabel.addCSSClass("title-3")
        overlayLabel.halign = .center
        overlayLabel.valign = .center
        overlay3.addOverlay(overlayLabel)

        let frame = Frame()
        frame.child = overlay3
        frame.setMargins(12)
        group3.add(frame)

        box.append(group3)

        return box.scrollableClamped()
    }
}
