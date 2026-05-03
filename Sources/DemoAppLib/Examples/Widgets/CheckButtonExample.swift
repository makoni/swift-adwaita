// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct CheckButtonExample: DemoExample {
    let name = "Check Button"
    let id = "checkbutton"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    // Simple check button
    let check = CheckButton(label: "Enable feature")
    check.onToggled {
        print("Active: \\(check.active)")
    }

    // Radio group
    let radio1 = CheckButton(label: "Option A")
    let radio2 = CheckButton(label: "Option B")
    let radio3 = CheckButton(label: "Option C")
    radio2.setGroup(radio1)
    radio3.setGroup(radio1)
    radio1.active = true

    // Tri-state (inconsistent)
    let tri = CheckButton(label: "Select all")
    tri.inconsistent = true
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        // Check buttons
        let group1 = PreferencesGroup()
        group1.title = "Check Buttons"
        group1.description = "Standard toggle check buttons"

        let statusLabel = Label("No selection")
        statusLabel.addCSSClass("dim-label")

        let check1 = CheckButton(label: "Feature A")
        check1.setMargins(12)
        let check2 = CheckButton(label: "Feature B")
        check2.setMargins(12)
        let check3 = CheckButton(label: "Feature C")
        check3.setMargins(12)

        let updateStatus = { [statusLabel, check1, check2, check3] in
            var selected: [String] = []
            if check1.active { selected.append("A") }
            if check2.active { selected.append("B") }
            if check3.active { selected.append("C") }
            statusLabel.text = selected.isEmpty ? "No selection" : "Selected: \(selected.joined(separator: ", "))"
        }

        check1.onToggled { updateStatus() }
        check2.onToggled { updateStatus() }
        check3.onToggled { updateStatus() }

        group1.add(check1)
        group1.add(check2)
        group1.add(check3)
        group1.add(statusLabel)

        box.append(group1)

        // Radio buttons
        let group2 = PreferencesGroup()
        group2.title = "Radio Buttons"
        group2.description = "Mutually exclusive options using setGroup()"

        let radioLabel = Label("Selected: Option 1")
        radioLabel.addCSSClass("dim-label")

        let radio1 = CheckButton(label: "Option 1")
        radio1.setMargins(12)
        radio1.active = true
        let radio2 = CheckButton(label: "Option 2")
        radio2.setMargins(12)
        radio2.setGroup(radio1)
        let radio3 = CheckButton(label: "Option 3")
        radio3.setMargins(12)
        radio3.setGroup(radio1)

        radio1.onToggled { [radio1, radioLabel] in
            if radio1.active { radioLabel.text = "Selected: Option 1" }
        }
        radio2.onToggled { [radio2, radioLabel] in
            if radio2.active { radioLabel.text = "Selected: Option 2" }
        }
        radio3.onToggled { [radio3, radioLabel] in
            if radio3.active { radioLabel.text = "Selected: Option 3" }
        }

        group2.add(radio1)
        group2.add(radio2)
        group2.add(radio3)
        group2.add(radioLabel)

        box.append(group2)

        // Tri-state
        let group3 = PreferencesGroup()
        group3.title = "Tri-State"
        group3.description = "A check button with an inconsistent (indeterminate) state"

        let triCheck = CheckButton(label: "Select all items")
        triCheck.inconsistent = true
        triCheck.setMargins(12)
        triCheck.onToggled { [triCheck] in
            triCheck.inconsistent = false
        }
        group3.add(triCheck)

        box.append(group3)

        return box.scrollableClamped()
    }
}
