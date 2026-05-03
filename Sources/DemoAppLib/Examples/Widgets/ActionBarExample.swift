// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct ActionBarExample: DemoExample {
    let name = "Action Bar"
    let id = "action-bar"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let actionBar = ActionBar()
    actionBar.packStart(Button(label: "Cancel"))
    actionBar.packEnd(Button(label: "Apply"))
    actionBar.centerWidget = Label("3 items selected")
    actionBar.revealed = true
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Action Bar"
        group.description = "GtkActionBar shows contextual actions at the bottom"

        let infoRow = ActionRow()
        infoRow.title = "Revealed"
        infoRow.subtitle = "Toggle the action bar visibility"
        let revealSwitch = Switch()
        revealSwitch.active = true
        revealSwitch.valign = .center
        infoRow.addSuffix(revealSwitch)
        infoRow.activatableWidget = revealSwitch
        group.add(infoRow)

        box.append(group)

        let actionBar = ActionBar()
        let cancelBtn = Button(label: "Cancel")
        cancelBtn.addCSSClass("flat")
        actionBar.packStart(cancelBtn)

        let applyBtn = Button(label: "Apply")
        applyBtn.addCSSClass("suggested-action")
        actionBar.packEnd(applyBtn)

        let centerLabel = Label("3 items selected")
        centerLabel.addCSSClass("dim-label")
        actionBar.centerWidget = centerLabel
        actionBar.revealed = true

        revealSwitch.onActiveChanged { [actionBar, revealSwitch] in
            actionBar.revealed = revealSwitch.active
        }

        box.append(actionBar)

        return box.scrollableClamped()
    }
}
