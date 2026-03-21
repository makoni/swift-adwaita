import Adwaita
import CAdwaita

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
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 24)
        box.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Alert Dialogs"
        group.description = "Tap a button to show different dialog styles"

        // Info dialog
        let row1 = ActionRow()
        row1.title = "Information Dialog"
        row1.subtitle = "A simple informational message"
        let btn1 = Button(label: "Show")
        btn1.valign = GTK_ALIGN_CENTER
        btn1.onClicked { [btn1] in
            let dialog = AlertDialog(
                heading: "Information",
                body: "The operation completed successfully."
            )
            dialog.addResponse("ok", label: "OK")
            dialog.defaultResponse = "ok"
            let root = gtk_widget_get_root(btn1.widgetPointer)
            dialog.present(Widget(borrowing: UnsafeMutableRawPointer(root!)))
        }
        row1.addSuffix(btn1)
        row1.activatableWidget = btn1
        group.add(row1)

        // Confirmation dialog
        let row2 = ActionRow()
        row2.title = "Confirmation Dialog"
        row2.subtitle = "Ask the user to save changes"
        let btn2 = Button(label: "Show")
        btn2.valign = GTK_ALIGN_CENTER
        btn2.onClicked { [btn2] in
            let dialog = AlertDialog(
                heading: "Save Changes?",
                body: "You have unsaved changes. Do you want to save before closing?"
            )
            dialog.addResponse("cancel", label: "Cancel")
            dialog.addResponse("discard", label: "Discard")
            dialog.addResponse("save", label: "Save")
            dialog.setResponseAppearance("discard", appearance: AdwResponseAppearance(rawValue: 2)!)
            dialog.setResponseAppearance("save", appearance: AdwResponseAppearance(rawValue: 1)!)
            dialog.defaultResponse = "save"
            dialog.closeResponse = "cancel"
            let root = gtk_widget_get_root(btn2.widgetPointer)
            dialog.present(Widget(borrowing: UnsafeMutableRawPointer(root!)))
        }
        row2.addSuffix(btn2)
        row2.activatableWidget = btn2
        group.add(row2)

        // Destructive dialog
        let row3 = ActionRow()
        row3.title = "Destructive Dialog"
        row3.subtitle = "Confirm a dangerous action"
        let btn3 = Button(label: "Show")
        btn3.valign = GTK_ALIGN_CENTER
        btn3.addCSSClass("destructive-action")
        btn3.onClicked { [btn3] in
            let dialog = AlertDialog(
                heading: "Delete File?",
                body: "This will permanently delete \"document.txt\". This action cannot be undone."
            )
            dialog.addResponse("cancel", label: "Cancel")
            dialog.addResponse("delete", label: "Delete")
            dialog.setResponseAppearance("delete", appearance: AdwResponseAppearance(rawValue: 2)!)
            dialog.defaultResponse = "cancel"
            dialog.closeResponse = "cancel"
            let root = gtk_widget_get_root(btn3.widgetPointer)
            dialog.present(Widget(borrowing: UnsafeMutableRawPointer(root!)))
        }
        row3.addSuffix(btn3)
        row3.activatableWidget = btn3
        group.add(row3)

        box.append(group)

        let clamp = Clamp()
        clamp.maximumSize = 600
        clamp.child = box

        let scrolled = ScrolledWindow()
        scrolled.child = clamp
        return scrolled
    }
}
