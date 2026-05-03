// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct DataBindingExample: DemoExample {
    let name = "Data Binding"
    let id = "databinding"
    let category: ExampleCategory = .composite

    let sourceCode = """
    var counter = 0
    let maxValue = 20

    // Multiple widgets reflecting the same value
    let countLabel = Label("0")
    let progressBar = ProgressBar()
    let levelBar = LevelBar(min: 0, max: Double(maxValue))

    // Helper to update all views from one data source
    func updateAll() {
        countLabel.text = "\\(counter)"
        progressBar.fraction = Double(counter) / Double(maxValue)
        levelBar.value = Double(counter)
    }

    // Buttons mutate the model, then update all views
    incrementBtn.onClicked {
        counter = min(counter + 1, maxValue)
        updateAll()
    }
    decrementBtn.onClicked {
        counter = max(counter - 1, 0)
        updateAll()
    }
    resetBtn.onClicked {
        counter = 0
        updateAll()
    }
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let maxValue = 20
        var counter = 0

        // -- Display widgets (all reflect the same counter value) --
        let countLabel = Label("0")
        countLabel.addCSSClass("title-1")
        countLabel.halign = .center

        let fractionLabel = Label("0 / \(maxValue)")
        fractionLabel.addCSSClass("dim-label")
        fractionLabel.halign = .center

        let progressBar = ProgressBar()
        progressBar.fraction = 0
        progressBar.showText = true
        progressBar.text = "0%"

        let levelBar = LevelBar(min: 0, max: Double(maxValue))
        levelBar.value = 0

        /// -- Update function: single source of truth -> all views --
        func updateAll() {
            countLabel.text = "\(counter)"
            fractionLabel.text = "\(counter) / \(maxValue)"
            let fraction = Double(counter) / Double(maxValue)
            progressBar.fraction = fraction
            progressBar.text = "\(Int(fraction * 100))%"
            levelBar.value = Double(counter)
        }

        // -- Counter display section --
        let displayGroup = PreferencesGroup()
        displayGroup.title = "Counter Display"
        displayGroup.description = "All widgets below reflect the same counter value"

        let counterBox = Box(orientation: .vertical, spacing: 8)
        counterBox.setMargins(16)
        counterBox.append(countLabel)
        counterBox.append(fractionLabel)
        displayGroup.add(counterBox)

        box.append(displayGroup)

        // -- Progress indicators section --
        let progressGroup = PreferencesGroup()
        progressGroup.title = "Progress Indicators"

        let progressRow = ActionRow()
        progressRow.title = "ProgressBar"
        progressRow.subtitle = "Shows fraction as a horizontal bar"
        progressGroup.add(progressRow)

        let progressContainer = Box(orientation: .vertical, spacing: 0)
        progressContainer.setMargins(16)
        progressContainer.append(progressBar)
        progressGroup.add(progressContainer)

        let levelRow = ActionRow()
        levelRow.title = "LevelBar"
        levelRow.subtitle = "Shows value as a segmented level indicator"
        progressGroup.add(levelRow)

        let levelContainer = Box(orientation: .vertical, spacing: 0)
        levelContainer.setMargins(16)
        levelContainer.append(levelBar)
        progressGroup.add(levelContainer)

        box.append(progressGroup)

        // -- Controls section --
        let controlGroup = PreferencesGroup()
        controlGroup.title = "Controls"
        controlGroup.description = "Modify the counter and watch all views update"

        let controlRow = ActionRow()
        controlRow.title = "Increment / Decrement"
        controlRow.subtitle = "Range: 0 to \(maxValue)"

        let controlBox = Box(orientation: .horizontal, spacing: 8)
        controlBox.valign = .center

        let decrementBtn = Button(iconName: "list-remove-symbolic")
        decrementBtn.addCSSClass("circular")
        decrementBtn.tooltipText = "Decrement"
        decrementBtn.onClicked {
            counter = max(counter - 1, 0)
            updateAll()
        }

        let incrementBtn = Button(iconName: "list-add-symbolic")
        incrementBtn.addCSSClass("circular")
        incrementBtn.tooltipText = "Increment"
        incrementBtn.onClicked {
            counter = min(counter + 1, maxValue)
            updateAll()
        }

        controlBox.append(decrementBtn)
        controlBox.append(incrementBtn)
        controlRow.addSuffix(controlBox)
        controlGroup.add(controlRow)

        let stepRow = ActionRow()
        stepRow.title = "Add 5"
        stepRow.subtitle = "Jump the counter by 5"
        let addFiveBtn = Button(label: "+5")
        addFiveBtn.valign = .center
        addFiveBtn.onClicked {
            counter = min(counter + 5, maxValue)
            updateAll()
        }
        stepRow.addSuffix(addFiveBtn)
        stepRow.activatableWidget = addFiveBtn
        controlGroup.add(stepRow)

        let resetRow = ActionRow()
        resetRow.title = "Reset"
        resetRow.subtitle = "Set counter back to zero"
        let resetBtn = Button(label: "Reset")
        resetBtn.valign = .center
        resetBtn.addCSSClass("destructive-action")
        resetBtn.onClicked {
            counter = 0
            updateAll()
        }
        resetRow.addSuffix(resetBtn)
        resetRow.activatableWidget = resetBtn
        controlGroup.add(resetRow)

        box.append(controlGroup)

        return box.scrollableClamped()
    }
}
