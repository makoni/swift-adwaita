import Adwaita

@MainActor
struct DropDownExample: DemoExample {
    let name = "DropDown"
    let id = "dropdown"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let dropdown = DropDown(strings: ["Option A", "Option B", "Option C"])
    dropdown.onSelectedChanged {
        print("Selected: \\(dropdown.selected)")
    }
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.halign = .center
        box.valign = .center

        let title = Label("Choose an option")
        title.addCSSClass("title-3")
        box.append(title)

        let fruits = DropDown(strings: ["Apple", "Banana", "Cherry", "Date", "Elderberry"])

        let resultLabel = Label("Selected: Apple")
        resultLabel.addCSSClass("dim-label")

        fruits.onSelectedChanged { [fruits, resultLabel] in
            let names = ["Apple", "Banana", "Cherry", "Date", "Elderberry"]
            let idx = fruits.selected
            if idx >= 0, idx < names.count {
                resultLabel.text = "Selected: \(names[idx])"
            }
        }

        box.append(fruits)
        box.append(resultLabel)

        return box
    }
}
