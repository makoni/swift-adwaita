// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct InlineViewSwitcherExample: DemoExample {
    let name = "Inline View Switcher"
    let id = "inlineviewswitcher"
    let category: ExampleCategory = .composite

    let sourceCode = """
        let stack = ViewStack()
        stack.addTitledWithIcon(page, name: "a", title: "A", iconName: "view-list-symbolic")

        // Compact segmented-control switcher for a ViewStack (libadwaita 1.7+)
        if let switcher = InlineViewSwitcher() {
            switcher.stack = stack
            switcher.displayMode = .both
            switcher.canShrink = true
        }
        """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let stack = ViewStack()
        let p1 = Label("Page A")
        p1.setMargins(24)
        let p2 = Label("Page B")
        p2.setMargins(24)
        let p3 = Label("Page C")
        p3.setMargins(24)
        stack.addTitledWithIcon(p1, name: "a", title: "Alpha", iconName: "view-list-symbolic")
        stack.addTitledWithIcon(p2, name: "b", title: "Beta", iconName: "view-grid-symbolic")
        stack.addTitledWithIcon(p3, name: "c", title: "Gamma", iconName: "view-reveal-symbolic")

        // Controls
        let controlGroup = PreferencesGroup()
        controlGroup.title = "Display"

        let modeRow = ActionRow()
        modeRow.title = "Display mode"
        let modeBox = Box(orientation: .horizontal, spacing: 8)
        modeRow.addSuffix(modeBox)

        let shrinkSwitch = Switch()
        shrinkSwitch.active = true
        shrinkSwitch.valign = .center
        let shrinkRow = ActionRow()
        shrinkRow.title = "Can shrink"
        shrinkRow.subtitle = "Allow the switcher to be narrower than its natural size"
        shrinkRow.addSuffix(shrinkSwitch)
        shrinkRow.activatableWidget = shrinkSwitch

        let homSwitch = Switch()
        homSwitch.active = true
        homSwitch.valign = .center
        let homRow = ActionRow()
        homRow.title = "Homogeneous"
        homRow.subtitle = "Give all toggle buttons equal width"
        homRow.addSuffix(homSwitch)
        homRow.activatableWidget = homSwitch

        controlGroup.add(modeRow)
        controlGroup.add(shrinkRow)
        controlGroup.add(homRow)

        // Content: switcher above the stack
        let contentGroup = PreferencesGroup()
        contentGroup.title = "Content"

        var switcherAvailable = false
        if let switcher = InlineViewSwitcher() {
            switcherAvailable = true
            let contentBox = Box(orientation: .vertical, spacing: 12)
            contentBox.addCSSClass("card")

            switcher.stack = stack
            switcher.displayMode = .both

            for (label, mode) in [
                ("Icons", InlineViewSwitcher.DisplayMode.icons),
                ("Labels", .labels),
                ("Both", .both),
            ] {
                let btn = Button(label: label)
                btn.addCSSClass("pill")
                btn.onClicked { [switcher] in
                    switcher.displayMode = mode
                }
                modeBox.append(btn)
            }
            // Property bindings keep the switcher in step with the switches
            // (and sync the initial values) without capturing any widget.
            shrinkSwitch.bind(.active, to: switcher, property: .custom("can-shrink"))
            homSwitch.bind(.active, to: switcher, property: .homogeneous)

            contentBox.append(switcher)
            contentBox.append(stack)
            contentGroup.add(contentBox)
        } else {
            let fallback = Label("Requires libadwaita 1.7+ (inline view switcher not available).")
            fallback.addCSSClass("dim-label")
            contentGroup.add(fallback)
        }

        // On <1.7 runtimes the switcher is unavailable, so the Display controls
        // have nothing to drive — keep them out of the fallback.
        if switcherAvailable {
            box.append(controlGroup)
        }
        box.append(contentGroup)

        return box.scrollableClamped()
    }
}
