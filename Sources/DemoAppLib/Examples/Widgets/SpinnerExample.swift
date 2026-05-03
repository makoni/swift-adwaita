import Adwaita

@MainActor
struct SpinnerExample: DemoExample {
    let name = "Spinner"
    let id = "spinner"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    // AdwSpinner — always animating loading indicator
    let spinner = Spinner()

    // Larger spinner via size request
    let bigSpinner = Spinner()
    bigSpinner.setSizeRequest(width: 48, height: 48)

    // Spinner can be shown/hidden with .visible
    spinner.visible = true   // show
    spinner.visible = false  // hide
    """

    func buildWidget() -> Widget {
        guard let spinner1 = Spinner(), let spinner2 = Spinner(), let spinner3 = Spinner() else {
            return Label("Spinner requires libadwaita 1.6+")
        }

        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Spinners"
        group.description = "AdwSpinner is always animating when visible"

        let spinnerBox = Box(orientation: .horizontal, spacing: 32)
        spinnerBox.halign = .center
        spinnerBox.setMargins(24)

        spinnerBox.append(spinner1)

        spinner2.setSizeRequest(width: 48, height: 48)
        spinnerBox.append(spinner2)

        spinner3.setSizeRequest(width: 64, height: 64)
        spinnerBox.append(spinner3)

        group.add(spinnerBox)
        box.append(group)

        // Visibility control
        let controlGroup = PreferencesGroup()
        controlGroup.title = "Controls"

        let toggleRow = ActionRow()
        toggleRow.title = "Toggle Visibility"
        toggleRow.subtitle = "Show or hide the spinners"
        let toggleBtn = Button(label: "Toggle")
        toggleBtn.valign = .center
        let s1 = spinner1
        let s2 = spinner2
        let s3 = spinner3
        toggleBtn.onClicked {
            let newState = !s1.visible
            s1.visible = newState
            s2.visible = newState
            s3.visible = newState
        }
        toggleRow.addSuffix(toggleBtn)
        controlGroup.add(toggleRow)

        box.append(controlGroup)

        return box.scrollableClamped()
    }
}
