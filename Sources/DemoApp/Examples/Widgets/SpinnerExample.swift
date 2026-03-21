import Adwaita
import CAdwaita

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
    gtk_widget_set_size_request(bigSpinner.widgetPointer, 48, 48)

    // Spinner can be shown/hidden with .visible
    spinner.visible = true   // show
    spinner.visible = false  // hide
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 24)
        box.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Spinners"
        group.description = "AdwSpinner is always animating when visible"

        let spinnerBox = Box(orientation: GTK_ORIENTATION_HORIZONTAL, spacing: 32)
        spinnerBox.halign = GTK_ALIGN_CENTER
        spinnerBox.setMargins(24)

        let spinner1 = Spinner()
        spinnerBox.append(spinner1)

        let spinner2 = Spinner()
        gtk_widget_set_size_request(spinner2.widgetPointer, 48, 48)
        spinnerBox.append(spinner2)

        let spinner3 = Spinner()
        gtk_widget_set_size_request(spinner3.widgetPointer, 64, 64)
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
        toggleBtn.valign = GTK_ALIGN_CENTER
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

        let clamp = Clamp()
        clamp.maximumSize = 600
        clamp.child = box

        let scrolled = ScrolledWindow()
        scrolled.child = clamp
        return scrolled
    }
}
