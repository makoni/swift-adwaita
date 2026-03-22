import Adwaita

@MainActor
struct BreakpointExample: DemoExample {
    let name = "Breakpoint"
    let id = "breakpoint"
    let category: ExampleCategory = .composite

    let sourceCode = """
    // Create a breakpoint for narrow windows
    let condition = BreakpointCondition(parse: "max-width: 500px")
    let bp = Breakpoint(condition: condition)

    // Change properties when breakpoint is applied
    bp.addSetter(splitView, property: "collapsed", value: true)

    // React to breakpoint changes
    bp.onApply { print("Narrow layout") }
    bp.onUnapply { print("Wide layout") }

    // Add to window/dialog
    dialog.addBreakpoint(bp)
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group1 = PreferencesGroup()
        group1.title = "Responsive Breakpoints"
        group1.description = "AdwBreakpoint adapts UI for different window sizes"

        let statusLabel = Label("Resize the window to trigger breakpoints")
        statusLabel.addCSSClass("dim-label")
        statusLabel.wrap = true
        statusLabel.setMargins(12)
        group1.add(statusLabel)

        let infoRow = ActionRow()
        infoRow.title = "Breakpoint Conditions"
        infoRow.subtitle = "Defined with strings like \"max-width: 500px\" or length/ratio API"
        let infoIcon = Image(iconName: "dialog-information-symbolic")
        infoIcon.valign = .center
        infoRow.addSuffix(infoIcon)
        group1.add(infoRow)

        box.append(group1)

        // Condition types
        let group2 = PreferencesGroup()
        group2.title = "Condition Types"

        let lengthRow = ActionRow()
        lengthRow.title = "Length Condition"
        lengthRow.subtitle = "BreakpointCondition.length(type:value:unit:)"
        group2.add(lengthRow)

        let ratioRow = ActionRow()
        ratioRow.title = "Ratio Condition"
        ratioRow.subtitle = "BreakpointCondition.ratio(type:width:height:)"
        group2.add(ratioRow)

        let parseRow = ActionRow()
        parseRow.title = "Parse from String"
        parseRow.subtitle = "BreakpointCondition(parse: \"max-width: 400sp\")"
        group2.add(parseRow)

        let andRow = ActionRow()
        andRow.title = "Combine with AND / OR"
        andRow.subtitle = "BreakpointCondition.and(a, b)"
        group2.add(andRow)

        box.append(group2)

        // Setter types
        let group3 = PreferencesGroup()
        group3.title = "Property Setters"
        group3.description = "addSetter() changes widget properties when breakpoint activates"

        let boolRow = ActionRow()
        boolRow.title = "Bool setter"
        boolRow.subtitle = "bp.addSetter(view, property: \"collapsed\", value: true)"
        group3.add(boolRow)

        let intRow = ActionRow()
        intRow.title = "Int setter"
        intRow.subtitle = "bp.addSetter(view, property: \"spacing\", value: 8)"
        group3.add(intRow)

        let stringRow = ActionRow()
        stringRow.title = "String setter"
        stringRow.subtitle = "bp.addSetter(label, property: \"label\", value: \"Compact\")"
        group3.add(stringRow)

        box.append(group3)

        return box.scrollableClamped()
    }
}
