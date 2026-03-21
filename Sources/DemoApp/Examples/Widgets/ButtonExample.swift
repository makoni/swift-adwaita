import Adwaita
import CAdwaita

@MainActor
struct ButtonExample: DemoExample {
    let name = "Buttons"
    let id = "buttons"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    // Standard button
    let btn = Button(label: "Click Me")
    btn.onClicked {
        btn.label = "Clicked!"
    }

    // Icon button (flat)
    let iconBtn = Button(iconName: "edit-copy-symbolic")
    iconBtn.addCSSClass("flat")

    // Toggle button
    let toggleBtn = ToggleButton(label: "Toggle")

    // ButtonContent — icon + label combined
    let bc = ButtonContent()
    bc.iconName = "document-open-symbolic"
    bc.label = "Open File"
    let richBtn = Button()
    richBtn.child = bc
    richBtn.addCSSClass("suggested-action")

    // Destructive button
    let deleteBtn = Button(label: "Delete")
    deleteBtn.addCSSClass("destructive-action")

    // Pill button
    let pillBtn = Button(label: "Pill Shape")
    pillBtn.addCSSClass("pill")
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 24)
        box.setMargins(24)

        // Basic buttons
        let basicGroup = PreferencesGroup()
        basicGroup.title = "Basic Buttons"

        let row1 = ActionRow()
        row1.title = "Standard Button"
        row1.subtitle = "A simple labeled button"
        let btn = Button(label: "Click Me")
        btn.valign = GTK_ALIGN_CENTER
        btn.onClicked { [btn] in
            btn.label = "Clicked!"
        }
        row1.addSuffix(btn)
        row1.activatableWidget = btn
        basicGroup.add(row1)

        let row2 = ActionRow()
        row2.title = "Icon Button"
        row2.subtitle = "Flat style with icon"
        let iconBtn = Button(iconName: "edit-copy-symbolic")
        iconBtn.valign = GTK_ALIGN_CENTER
        iconBtn.addCSSClass("flat")
        row2.addSuffix(iconBtn)
        basicGroup.add(row2)

        let row3 = ActionRow()
        row3.title = "Toggle Button"
        let toggleBtn = ToggleButton(label: "Toggle")
        toggleBtn.valign = GTK_ALIGN_CENTER
        row3.addSuffix(toggleBtn)
        basicGroup.add(row3)

        box.append(basicGroup)

        // Styled buttons
        let styledGroup = PreferencesGroup()
        styledGroup.title = "Styled Buttons"

        let row4 = ActionRow()
        row4.title = "Suggested Action"
        let bc = ButtonContent()
        bc.iconName = "document-open-symbolic"
        bc.label = "Open File"
        let sugBtn = Button()
        sugBtn.child = bc
        sugBtn.valign = GTK_ALIGN_CENTER
        sugBtn.addCSSClass("suggested-action")
        row4.addSuffix(sugBtn)
        styledGroup.add(row4)

        let row5 = ActionRow()
        row5.title = "Destructive Action"
        let delBtn = Button(label: "Delete")
        delBtn.valign = GTK_ALIGN_CENTER
        delBtn.addCSSClass("destructive-action")
        row5.addSuffix(delBtn)
        styledGroup.add(row5)

        let row6 = ActionRow()
        row6.title = "Pill Button"
        let pillBtn = Button(label: "Pill Shape")
        pillBtn.valign = GTK_ALIGN_CENTER
        pillBtn.addCSSClass("pill")
        row6.addSuffix(pillBtn)
        styledGroup.add(row6)

        box.append(styledGroup)

        let clamp = Clamp()
        clamp.maximumSize = 600
        clamp.child = box

        let scrolled = ScrolledWindow()
        scrolled.child = clamp
        return scrolled
    }
}
