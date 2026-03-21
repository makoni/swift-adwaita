import Adwaita
import CAdwaita

@MainActor
struct BannerExample: DemoExample {
    let name = "Banner"
    let id = "banner"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let banner = Banner(title: "New update available")
    banner.buttonLabel = "Update Now"
    banner.revealed = true

    banner.onButtonClicked {
        banner.title = "Updating..."
        banner.buttonLabel = nil
    }

    // Toggle banner visibility
    let toggleBtn = Button(label: "Toggle Banner")
    toggleBtn.onClicked {
        banner.revealed = !banner.revealed
    }
    """

    func buildWidget() -> Widget {
        let outerBox = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 0)

        let banner = Banner(title: "New update available")
        banner.buttonLabel = "Update Now"
        banner.revealed = true
        outerBox.append(banner)

        banner.onButtonClicked { [banner] in
            banner.title = "Updating..."
            banner.buttonLabel = nil
        }

        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 24)
        box.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Banner Controls"

        let toggleRow = ActionRow()
        toggleRow.title = "Toggle Banner"
        toggleRow.subtitle = "Show or hide the banner above"
        let toggleBtn = Button(label: "Toggle")
        toggleBtn.valign = GTK_ALIGN_CENTER
        toggleBtn.onClicked {
            banner.revealed = !banner.revealed
        }
        toggleRow.addSuffix(toggleBtn)
        group.add(toggleRow)

        let resetRow = ActionRow()
        resetRow.title = "Reset Banner"
        resetRow.subtitle = "Restore original text and button"
        let resetBtn = Button(label: "Reset")
        resetBtn.valign = GTK_ALIGN_CENTER
        resetBtn.onClicked {
            banner.title = "New update available"
            banner.buttonLabel = "Update Now"
            banner.revealed = true
        }
        resetRow.addSuffix(resetBtn)
        group.add(resetRow)

        box.append(group)

        let clamp = Clamp()
        clamp.maximumSize = 600
        clamp.child = box
        outerBox.append(clamp)

        let scrolled = ScrolledWindow()
        scrolled.child = outerBox
        return scrolled
    }
}
