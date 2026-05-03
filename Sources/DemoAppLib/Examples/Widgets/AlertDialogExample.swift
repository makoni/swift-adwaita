// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct AlertDialogExample: DemoExample {
    let name = "Alert Dialog"
    let id = "alertdialog"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    // Info dialog
    let dialog = AlertDialog(
        heading: "Information",
        body: "The operation completed successfully."
    )
    dialog.addResponse("ok", label: "OK")
    dialog.defaultResponse = "ok"
    dialog.present(parentWidget)

    // Confirmation dialog
    let confirm = AlertDialog(
        heading: "Save Changes?",
        body: "Unsaved changes will be lost."
    )
    confirm.addResponse("cancel", label: "Cancel")
    confirm.addResponse("save", label: "Save")
    confirm.setResponseAppearance(
        "save", appearance: AdwResponseAppearance(1)
    )
    confirm.defaultResponse = "save"
    confirm.closeResponse = "cancel"
    confirm.present(parentWidget)

    // Destructive dialog
    let danger = AlertDialog(
        heading: "Delete File?",
        body: "This action cannot be undone."
    )
    danger.addResponse("cancel", label: "Cancel")
    danger.addResponse("delete", label: "Delete")
    danger.setResponseAppearance(
        "delete", appearance: AdwResponseAppearance(2)
    )
    danger.closeResponse = "cancel"
    danger.present(parentWidget)
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Alert Dialogs"
        group.description = "Tap a button to show different dialog styles"

        // Info dialog
        let row1 = ActionRow()
        row1.title = "Information Dialog"
        row1.subtitle = "A simple informational message"
        let btn1 = Button(label: "Show")
        btn1.valign = .center
        btn1.onClicked { [btn1] in
            let dialog = AlertDialog(
                heading: "Information",
                body: "The operation completed successfully."
            )
            dialog.addResponse("ok", label: "OK")
            dialog.defaultResponse = "ok"
            dialog.present(btn1.root!)
        }
        row1.addSuffix(btn1)
        row1.activatableWidget = btn1
        group.add(row1)

        // Confirmation dialog
        let row2 = ActionRow()
        row2.title = "Confirmation Dialog"
        row2.subtitle = "Ask the user to save changes"
        let btn2 = Button(label: "Show")
        btn2.valign = .center
        btn2.onClicked { [btn2] in
            let dialog = AlertDialog(
                heading: "Save Changes?",
                body: "You have unsaved changes. Do you want to save before closing?"
            )
            dialog.addResponse("cancel", label: "Cancel")
            dialog.addResponse("discard", label: "Discard")
            dialog.addResponse("save", label: "Save")
            dialog.setResponseAppearance("discard", appearance: .destructive)
            dialog.setResponseAppearance("save", appearance: .suggested)
            dialog.defaultResponse = "save"
            dialog.closeResponse = "cancel"
            dialog.present(btn2.root!)
        }
        row2.addSuffix(btn2)
        row2.activatableWidget = btn2
        group.add(row2)

        // Destructive dialog
        let row3 = ActionRow()
        row3.title = "Destructive Dialog"
        row3.subtitle = "Confirm a dangerous action"
        let btn3 = Button(label: "Show")
        btn3.valign = .center
        btn3.addCSSClass("destructive-action")
        btn3.onClicked { [btn3] in
            let dialog = AlertDialog(
                heading: "Delete File?",
                body: "This will permanently delete \"document.txt\". This action cannot be undone."
            )
            dialog.addResponse("cancel", label: "Cancel")
            dialog.addResponse("delete", label: "Delete")
            dialog.setResponseAppearance("delete", appearance: .destructive)
            dialog.defaultResponse = "cancel"
            dialog.closeResponse = "cancel"
            dialog.present(btn3.root!)
        }
        row3.addSuffix(btn3)
        row3.activatableWidget = btn3
        group.add(row3)

        box.append(group)

        return box.scrollableClamped()
    }
}
