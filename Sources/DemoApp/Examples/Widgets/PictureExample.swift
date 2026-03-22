import Adwaita
import CAdwaita

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

    // Change content fit mode
    picture.contentFit = .cover
    picture.contentFit = .scaleDown
    picture.contentFit = .fill
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group1 = PreferencesGroup()
        group1.title = "Content Fit Modes"
        group1.description = "GtkPicture scales images using different fit modes"

        // Create a placeholder image using a DrawingArea
        let picture = Picture()
        picture.canShrink = true
        picture.contentFit = .contain
        picture.alternativeText = "Demo picture"
        picture.hexpand = true
        picture.setSizeRequest(width: -1, height: 200)
        picture.setMargins(12)
        group1.add(picture)

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

        let clamp = Clamp()
        clamp.maximumSize = 600
        clamp.child = box

        let scrolled = ScrolledWindow()
        scrolled.child = clamp
        return scrolled
    }
}
