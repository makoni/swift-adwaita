// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct ExpanderRowExample: DemoExample {
    let name = "Expander Row"
    let id = "expander-row"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let row = ExpanderRow()
    row.title = "Advanced Settings"
    row.subtitle = "Fine-tune your experience"
    row.expanded = false

    let child1 = ActionRow()
    child1.title = "Cache Size"
    row.addRow(child1)

    row.showEnableSwitch = true
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Expander Rows"
        group.description = "AdwExpanderRow reveals nested rows when expanded"

        let row1 = ExpanderRow()
        row1.title = "Advanced Settings"
        row1.subtitle = "Fine-tune your experience"

        let child1 = ActionRow()
        child1.title = "Cache Size"
        child1.subtitle = "256 MB"
        row1.addRow(child1)

        let child2 = ActionRow()
        child2.title = "Sync Interval"
        child2.subtitle = "Every 15 minutes"
        row1.addRow(child2)

        let child3 = SwitchRow()
        child3.title = "Debug Logging"
        child3.active = false
        row1.addRow(child3)

        group.add(row1)

        let row2 = ExpanderRow()
        row2.title = "Notifications"
        row2.subtitle = "Toggle to enable"
        row2.showEnableSwitch = true
        row2.enableExpansion = true
        row2.expanded = true

        let notif1 = SwitchRow()
        notif1.title = "Email"
        notif1.active = true
        row2.addRow(notif1)

        let notif2 = SwitchRow()
        notif2.title = "Push"
        notif2.active = false
        row2.addRow(notif2)

        group.add(row2)

        box.append(group)

        return box.scrollableClamped()
    }
}
