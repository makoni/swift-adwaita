import Adwaita

@MainActor
struct SplitButtonExample: DemoExample {
    let name = "Split Button"
    let id = "splitbutton"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let splitBtn = SplitButton()
    splitBtn.label = "Action"

    // Use a popover with custom content
    let popover = Popover()
    let popBox = Box(orientation: .vertical, spacing: 4)
    let optBtn = Button(label: "Option A")
    optBtn.addCSSClass("flat")
    optBtn.onClicked {
        print("Option A selected")
        popover.popdown()
    }
    popBox.append(optBtn)
    popover.child = popBox
    splitBtn.setPopover(popover)

    splitBtn.onClicked {
        print("Main button clicked")
    }
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        // SplitButton with popover
        let group1 = PreferencesGroup()
        group1.title = "Split Button with Popover"
        group1.description = "A button with a dropdown for additional actions"

        let statusLabel = Label("Click the button or dropdown")
        statusLabel.addCSSClass("dim-label")

        let popover1 = Popover()
        let popBox1 = Box(orientation: .vertical, spacing: 2)
        popBox1.setMargins(4)
        for option in ["Option A", "Option B", "Option C"] {
            let btn = Button(label: option)
            btn.addCSSClass("flat")
            btn.onClicked { [statusLabel, popover1] in
                statusLabel.text = "\(option) selected"
                popover1.popdown()
            }
            popBox1.append(btn)
        }
        popover1.child = popBox1

        let splitBtn = SplitButton()
        splitBtn.label = "Action"
        splitBtn.setPopover(popover1)
        splitBtn.halign = .center
        splitBtn.setMargins(12)
        splitBtn.onClicked { [statusLabel] in
            statusLabel.text = "Main button clicked!"
        }
        group1.add(splitBtn)
        group1.add(statusLabel)

        box.append(group1)

        // SplitButton with icon
        let group2 = PreferencesGroup()
        group2.title = "Icon Split Button"
        group2.description = "A split button with an icon instead of text"

        let popover2 = Popover()
        let popBox2 = Box(orientation: .vertical, spacing: 2)
        popBox2.setMargins(4)
        for (label, icon) in [("New Window", "window-new-symbolic"), ("New Tab", "tab-new-symbolic")] {
            let btn = Button()
            let content = ButtonContent()
            content.label = label
            content.iconName = icon
            btn.child = content
            btn.addCSSClass("flat")
            btn.onClicked { [popover2] in
                popover2.popdown()
            }
            popBox2.append(btn)
        }
        popover2.child = popBox2

        let iconSplit = SplitButton()
        iconSplit.iconName = "document-new-symbolic"
        iconSplit.setPopover(popover2)
        iconSplit.halign = .center
        iconSplit.setMargins(12)
        group2.add(iconSplit)

        box.append(group2)

        // SplitButton styles
        let group3 = PreferencesGroup()
        group3.title = "Styles"

        let pop3 = Popover()
        let pop3Box = Box(orientation: .vertical, spacing: 2)
        pop3Box.setMargins(4)
        let pop3Btn = Button(label: "Save As...")
        pop3Btn.addCSSClass("flat")
        pop3Btn.onClicked { [pop3] in pop3.popdown() }
        pop3Box.append(pop3Btn)
        pop3.child = pop3Box

        let suggestedSplit = SplitButton()
        suggestedSplit.label = "Save"
        suggestedSplit.setPopover(pop3)
        suggestedSplit.addCSSClass("suggested-action")
        suggestedSplit.halign = .center

        let pop4 = Popover()
        let pop4Box = Box(orientation: .vertical, spacing: 2)
        pop4Box.setMargins(4)
        let pop4Btn = Button(label: "Delete All")
        pop4Btn.addCSSClass("flat")
        pop4Btn.onClicked { [pop4] in pop4.popdown() }
        pop4Box.append(pop4Btn)
        pop4.child = pop4Box

        let destructiveSplit = SplitButton()
        destructiveSplit.label = "Delete"
        destructiveSplit.setPopover(pop4)
        destructiveSplit.addCSSClass("destructive-action")
        destructiveSplit.halign = .center

        let styleBox = Box(orientation: .horizontal, spacing: 12)
        styleBox.halign = .center
        styleBox.setMargins(12)
        styleBox.append(suggestedSplit)
        styleBox.append(destructiveSplit)
        group3.add(styleBox)

        box.append(group3)

        return box.scrollableClamped()
    }
}
