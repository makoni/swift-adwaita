import Adwaita
import CAdwaita

@MainActor
struct SplitButtonExample: DemoExample {
    let name = "Split Button"
    let id = "splitbutton"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let menu = GMenuRef()
    menu.append("Copy", action: "app.copy")
    menu.append("Paste", action: "app.paste")

    let splitBtn = SplitButton()
    splitBtn.label = "Open"
    splitBtn.setMenuModel(menu)
    splitBtn.onClicked {
        print("Main button clicked")
    }
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        // SplitButton with menu
        let group1 = PreferencesGroup()
        group1.title = "Split Button with Menu"
        group1.description = "A button with a dropdown menu for additional actions"

        let statusLabel = Label("Click the button or dropdown")
        statusLabel.addCSSClass("dim-label")

        let menu = GMenuRef()
        menu.append("Option A", action: "win.optionA")
        menu.append("Option B", action: "win.optionB")
        menu.append("Option C", action: "win.optionC")

        let splitBtn = SplitButton()
        splitBtn.label = "Action"
        splitBtn.setMenuModel(menu)
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

        let menu2 = GMenuRef()
        menu2.append("New Window", action: "app.newWindow")
        menu2.append("New Tab", action: "app.newTab")

        let iconSplit = SplitButton()
        iconSplit.iconName = "document-new-symbolic"
        iconSplit.setMenuModel(menu2)
        iconSplit.halign = .center
        iconSplit.setMargins(12)
        group2.add(iconSplit)

        box.append(group2)

        // SplitButton styles
        let group3 = PreferencesGroup()
        group3.title = "Styles"

        let menu3 = GMenuRef()
        menu3.append("Item 1", action: "app.item1")

        let suggestedSplit = SplitButton()
        suggestedSplit.label = "Suggested"
        suggestedSplit.setMenuModel(menu3)
        suggestedSplit.addCSSClass("suggested-action")
        suggestedSplit.halign = .center

        let menu4 = GMenuRef()
        menu4.append("Item 1", action: "app.item1")

        let destructiveSplit = SplitButton()
        destructiveSplit.label = "Destructive"
        destructiveSplit.setMenuModel(menu4)
        destructiveSplit.addCSSClass("destructive-action")
        destructiveSplit.halign = .center

        let styleBox = Box(orientation: .horizontal, spacing: 12)
        styleBox.halign = .center
        styleBox.setMargins(12)
        styleBox.append(suggestedSplit)
        styleBox.append(destructiveSplit)
        group3.add(styleBox)

        box.append(group3)

        let clamp = Clamp()
        clamp.maximumSize = 600
        clamp.child = box

        let scrolled = ScrolledWindow()
        scrolled.child = clamp
        return scrolled
    }
}
