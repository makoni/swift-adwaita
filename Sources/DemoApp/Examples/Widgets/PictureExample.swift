import Adwaita

@MainActor
struct PictureExample: DemoExample {
    let name = "Picture"
    let id = "picture"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let picture = Picture(filename: "/path/to/image.png")
    picture.contentFit = .contain
    picture.canShrink = true
    picture.alternativeText = "A photo"

    // Or create from a Texture
    let texture = Texture(rgbaData: pixels, width: 200, height: 150)
    picture.setPaintable(texture)

    // Load via FileDialog
    let dialog = FileDialog()
    Task { @MainActor in
        if let path = try? await dialog.open(parent: window) {
            picture.setFilename(path)
        }
    }
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group1 = PreferencesGroup()
        group1.title = "Content Fit Modes"
        group1.description = "GtkPicture scales images using different fit modes"

        let picture = Picture()
        picture.canShrink = true
        picture.contentFit = .contain
        picture.alternativeText = "Demo picture"
        picture.hexpand = true
        picture.setSizeRequest(width: -1, height: 200)
        picture.setMargins(12)

        // Generate a gradient texture as default content
        let width = 400
        let height = 300
        var pixels = [UInt8](repeating: 0, count: width * height * 4)
        for y in 0 ..< height {
            for x in 0 ..< width {
                let i = (y * width + x) * 4
                let fx = Double(x) / Double(width)
                let fy = Double(y) / Double(height)
                pixels[i] = UInt8(min(255, fx * 140 + 80))
                pixels[i + 1] = UInt8(min(255, (1 - fy) * 120 + 100))
                pixels[i + 2] = UInt8(min(255, (1 - fx) * 180 + 60))
                pixels[i + 3] = 255
            }
        }
        let texture = Texture(rgbaData: pixels, width: width, height: height)
        picture.setPaintable(texture)

        group1.add(picture)

        // Load image button
        let loadBtn = Button(label: "Load Image...")
        loadBtn.addCSSClass("pill")
        loadBtn.halign = .center
        loadBtn.setMargins(8)
        loadBtn.onClicked { [picture, box] in
            let dialog = FileDialog()
            dialog.title = "Open Image"
            dialog.setFilters([
                FileFilter(name: "Images", suffixes: ["png", "jpg", "jpeg", "webp", "svg", "bmp", "gif"]),
                FileFilter(name: "All files", patterns: ["*"])
            ])
            Task { @MainActor in
                if let path = try? await dialog.open(parent: box.root) {
                    picture.setFilename(path)
                }
            }
        }
        group1.add(loadBtn)

        let fitRow = ActionRow()
        fitRow.title = "Content Fit"
        fitRow.subtitle = "How the image fills the widget"
        let fitDropDown = DropDown(strings: ["Contain", "Cover", "Fill", "Scale Down"])
        fitDropDown.valign = .center
        fitDropDown.onSelectedChanged { [fitDropDown, picture] in
            switch fitDropDown.selected {
            case 0: picture.contentFit = .contain
            case 1: picture.contentFit = .cover
            case 2: picture.contentFit = .fill
            case 3: picture.contentFit = .scaleDown
            default: break
            }
        }
        fitRow.addSuffix(fitDropDown)
        group1.add(fitRow)

        let shrinkRow = ActionRow()
        shrinkRow.title = "Can Shrink"
        shrinkRow.subtitle = "Whether the picture can be smaller than its natural size"
        let shrinkSwitch = Switch()
        shrinkSwitch.active = true
        shrinkSwitch.valign = .center
        shrinkSwitch.onActiveChanged { [shrinkSwitch, picture] in
            picture.canShrink = shrinkSwitch.active
        }
        shrinkRow.addSuffix(shrinkSwitch)
        group1.add(shrinkRow)

        box.append(group1)

        let group2 = PreferencesGroup()
        group2.title = "Accessibility"

        let altRow = ActionRow()
        altRow.title = "Alternative Text"
        altRow.subtitle = "Provides accessible description for the image"
        let altIcon = Image(iconName: "preferences-desktop-accessibility-symbolic")
        altIcon.valign = .center
        altRow.addSuffix(altIcon)
        group2.add(altRow)

        box.append(group2)

        return box.scrollableClamped()
    }
}
