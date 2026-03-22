import Adwaita
import CAdwaita

@MainActor
struct WrapBoxExample: DemoExample {
    let name = "Wrap Box"
    let id = "wrap-box"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let wrap = WrapBox()
    wrap.childSpacing = 8
    wrap.lineSpacing = 8

    for tag in ["Swift", "GTK4", "Adwaita", "Linux"] {
        let btn = Button(label: tag)
        btn.addCSSClass("pill")
        wrap.append(btn)
    }
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group1 = PreferencesGroup()
        group1.title = "Wrap Box"
        group1.description = "AdwWrapBox flows children into multiple lines"

        let wrap1 = WrapBox()
        wrap1.childSpacing = 8
        wrap1.lineSpacing = 8
        wrap1.setMargins(12)

        let tags = [
            "Swift", "GTK4", "Adwaita", "Linux", "GNOME", "GObject",
            "libadwaita", "Vala", "Flatpak", "Meson", "Blueprint", "Rust",
        ]
        for tag in tags {
            let btn = Button(label: tag)
            btn.addCSSClass("pill")
            wrap1.append(btn)
        }
        group1.add(wrap1)
        box.append(group1)

        let group2 = PreferencesGroup()
        group2.title = "Homogeneous Lines"

        let wrap2 = WrapBox()
        wrap2.childSpacing = 6
        wrap2.lineSpacing = 6
        wrap2.lineHomogeneous = true
        wrap2.setMargins(12)

        for i in 1...12 {
            let label = Label("Item \(i)")
            label.addCSSClass("card")
            label.setMargins(8)
            wrap2.append(label)
        }
        group2.add(wrap2)
        box.append(group2)

        let clamp = Clamp()
        clamp.maximumSize = 600
        clamp.child = box

        let scrolled = ScrolledWindow()
        scrolled.child = clamp
        return scrolled
    }
}
