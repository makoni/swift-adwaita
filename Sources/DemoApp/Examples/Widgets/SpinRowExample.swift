import Adwaita

@MainActor
struct SpinRowExample: DemoExample {
    let name = "Spin Row"
    let id = "spinrow"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    // Basic spin row
    let spin = SpinRow.newWithRange(min: 0, max: 100, step: 1)
    spin.title = "Quantity"
    spin.value = 42

    // Decimal spin row
    let decimal = SpinRow.newWithRange(min: 0, max: 10, step: 0.1)
    decimal.title = "Temperature"
    decimal.digits = 1
    decimal.value = 3.7

    // Wrapping spin row
    let wrap = SpinRow.newWithRange(min: 0, max: 23, step: 1)
    wrap.title = "Hour"
    wrap.wrap = true
    wrap.value = 12

    // Snap-to-ticks
    let snap = SpinRow.newWithRange(min: 0, max: 100, step: 10)
    snap.title = "Percentage"
    snap.snapToTicks = true
    snap.value = 50
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Spin Rows"
        group.description = "Numeric input with increment/decrement"

        let spin = SpinRow.newWithRange(min: 0, max: 100, step: 1)
        spin.title = "Quantity"
        spin.value = 42
        group.add(spin)

        let decimal = SpinRow.newWithRange(min: 0, max: 10, step: 0.1)
        decimal.title = "Temperature"
        decimal.subtitle = "Decimal precision"
        decimal.digits = 1
        decimal.value = 3.7
        group.add(decimal)

        let wrap = SpinRow.newWithRange(min: 0, max: 23, step: 1)
        wrap.title = "Hour"
        wrap.subtitle = "Wraps around at boundaries"
        wrap.wrap = true
        wrap.value = 12
        group.add(wrap)

        let snap = SpinRow.newWithRange(min: 0, max: 100, step: 10)
        snap.title = "Percentage"
        snap.subtitle = "Snaps to nearest 10"
        snap.snapToTicks = true
        snap.value = 50
        group.add(snap)

        box.append(group)

        return box.scrollableClamped()
    }
}
