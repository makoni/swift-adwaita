import Adwaita

@MainActor
struct ToastExample: DemoExample {
    let name = "Toasts"
    let id = "toast"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let overlay = ToastOverlay()

    // Simple toast
    let toast = Toast(title: "Hello from swift-adwaita!")
    overlay.addToast(toast)

    // Toast with button
    let toast2 = Toast(title: "File deleted")
    toast2.buttonLabel = "Undo"
    toast2.onButtonClicked {
        let undone = Toast(title: "Undo successful")
        overlay.addToast(undone)
    }
    overlay.addToast(toast2)

    // Toast with timeout
    let toast3 = Toast(title: "Auto-dismiss in 3s")
    toast3.timeout = 3
    overlay.addToast(toast3)
    """

    func buildWidget() -> Widget {
        let overlay = ToastOverlay()

        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Toast Demos"
        group.description = "Tap a button to show a toast notification"

        // Simple toast
        let row1 = ActionRow()
        row1.title = "Simple Toast"
        row1.subtitle = "A basic text notification"
        let btn1 = Button(label: "Show")
        btn1.valign = .center
        btn1.onClicked { [overlay] in
            let toast = Toast(title: "Hello from swift-adwaita!")
            overlay.addToast(toast)
        }
        row1.addSuffix(btn1)
        row1.activatableWidget = btn1
        group.add(row1)

        // Toast with button
        let row2 = ActionRow()
        row2.title = "Toast with Action"
        row2.subtitle = "Includes an undo button"
        let btn2 = Button(label: "Show")
        btn2.valign = .center
        btn2.onClicked { [overlay] in
            let toast = Toast(title: "File deleted")
            toast.buttonLabel = "Undo"
            toast.onButtonClicked { [overlay] in
                let undone = Toast(title: "Undo successful")
                undone.timeout = 2
                overlay.addToast(undone)
            }
            overlay.addToast(toast)
        }
        row2.addSuffix(btn2)
        row2.activatableWidget = btn2
        group.add(row2)

        // Toast with custom timeout
        let row3 = ActionRow()
        row3.title = "Timed Toast"
        row3.subtitle = "Auto-dismisses after 3 seconds"
        let btn3 = Button(label: "Show")
        btn3.valign = .center
        btn3.onClicked { [overlay] in
            let toast = Toast(title: "This will disappear in 3 seconds")
            toast.timeout = 3
            overlay.addToast(toast)
        }
        row3.addSuffix(btn3)
        row3.activatableWidget = btn3
        group.add(row3)

        // High priority toast
        let row4 = ActionRow()
        row4.title = "Priority Toast"
        row4.subtitle = "Displayed ahead of other toasts"
        let btn4 = Button(label: "Show")
        btn4.valign = .center
        btn4.onClicked { [overlay] in
            let toast = Toast(title: "Important notification!")
            toast.priority = .high
            overlay.addToast(toast)
        }
        row4.addSuffix(btn4)
        row4.activatableWidget = btn4
        group.add(row4)

        box.append(group)

        let clamp = Clamp()
        clamp.maximumSize = 600
        clamp.child = box

        let scrolled = ScrolledWindow()
        scrolled.child = clamp

        overlay.child = scrolled
        return overlay
    }
}
