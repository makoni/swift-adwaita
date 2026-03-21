import Adwaita
import CAdwaita

@MainActor
struct ProgressBarExample: DemoExample {
    let name = "Progress Bar"
    let id = "progressbar"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let progressBar = ProgressBar()
    progressBar.fraction = 0.4
    progressBar.showText = true
    progressBar.text = "40%"

    // Increase
    let incBtn = Button(label: "Increase")
    incBtn.onClicked {
        let newVal = min(1.0, progressBar.fraction + 0.1)
        progressBar.fraction = newVal
        progressBar.text = "\\(Int(newVal * 100))%"
    }

    // Decrease
    let decBtn = Button(label: "Decrease")
    decBtn.onClicked {
        let newVal = max(0.0, progressBar.fraction - 0.1)
        progressBar.fraction = newVal
        progressBar.text = "\\(Int(newVal * 100))%"
    }

    // Pulse mode
    let pulseBar = ProgressBar()
    pulseBar.pulse()
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 24)
        box.setMargins(24)

        // Determinate progress
        let group1 = PreferencesGroup()
        group1.title = "Determinate Progress"
        group1.description = "Shows a specific fraction of completion"

        let progressBar = ProgressBar()
        progressBar.fraction = 0.4
        progressBar.showText = true
        progressBar.text = "40%"
        progressBar.setMargins(12)
        group1.add(progressBar)

        let incRow = ActionRow()
        incRow.title = "Increase"
        incRow.subtitle = "Add 10% to the progress"
        let incBtn = Button(iconName: "list-add-symbolic")
        incBtn.valign = GTK_ALIGN_CENTER
        incBtn.addCSSClass("flat")
        incBtn.onClicked { [progressBar] in
            let newVal = min(1.0, progressBar.fraction + 0.1)
            progressBar.fraction = newVal
            progressBar.text = "\(Int(newVal * 100))%"
        }
        incRow.addSuffix(incBtn)
        incRow.activatableWidget = incBtn
        group1.add(incRow)

        let decRow = ActionRow()
        decRow.title = "Decrease"
        decRow.subtitle = "Remove 10% from the progress"
        let decBtn = Button(iconName: "list-remove-symbolic")
        decBtn.valign = GTK_ALIGN_CENTER
        decBtn.addCSSClass("flat")
        decBtn.onClicked { [progressBar] in
            let newVal = max(0.0, progressBar.fraction - 0.1)
            progressBar.fraction = newVal
            progressBar.text = "\(Int(newVal * 100))%"
        }
        decRow.addSuffix(decBtn)
        decRow.activatableWidget = decBtn
        group1.add(decRow)

        let resetRow = ActionRow()
        resetRow.title = "Reset"
        resetRow.subtitle = "Set progress back to 0%"
        let resetBtn = Button(label: "Reset")
        resetBtn.valign = GTK_ALIGN_CENTER
        resetBtn.onClicked { [progressBar] in
            progressBar.fraction = 0.0
            progressBar.text = "0%"
        }
        resetRow.addSuffix(resetBtn)
        resetRow.activatableWidget = resetBtn
        group1.add(resetRow)

        box.append(group1)

        // Pulse mode
        let group2 = PreferencesGroup()
        group2.title = "Pulse Mode"
        group2.description = "Indicates activity without a known completion fraction"

        let pulseBar = ProgressBar()
        pulseBar.pulseStep = 0.3
        pulseBar.setMargins(12)
        // Pulse it once to show the initial bounce
        pulseBar.pulse()
        group2.add(pulseBar)

        let pulseRow = ActionRow()
        pulseRow.title = "Pulse"
        pulseRow.subtitle = "Tap to advance the pulse animation"
        let pulseBtn = Button(label: "Pulse")
        pulseBtn.valign = GTK_ALIGN_CENTER
        pulseBtn.addCSSClass("suggested-action")
        pulseBtn.onClicked { [pulseBar] in
            pulseBar.pulse()
        }
        pulseRow.addSuffix(pulseBtn)
        pulseRow.activatableWidget = pulseBtn
        group2.add(pulseRow)

        box.append(group2)

        let clamp = Clamp()
        clamp.maximumSize = 600
        clamp.child = box

        let scrolled = ScrolledWindow()
        scrolled.child = clamp
        return scrolled
    }
}
