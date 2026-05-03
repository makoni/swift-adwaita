// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct GridExample: DemoExample {
    let name = "Grid"
    let id = "grid"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let grid = Grid()
    grid.columnSpacing = 12
    grid.rowSpacing = 12

    let label = Label("Row 0, Col 0")
    grid.attach(label, column: 0, row: 0)

    let wide = Label("Spans 2 columns")
    grid.attach(wide, column: 0, row: 1, width: 2)
    """

    func buildWidget() -> Widget {
        let grid = Grid()
        grid.columnSpacing = 12
        grid.rowSpacing = 12
        grid.columnHomogeneous = true
        grid.halign = .center
        grid.valign = .center

        for row in 0 ..< 3 {
            for col in 0 ..< 3 {
                let btn = Button(label: "(\(col), \(row))")
                btn.addCSSClass("pill")
                grid.attach(btn, column: col, row: row)
            }
        }

        // Wide label spanning all columns
        let wide = Label("This label spans all 3 columns")
        wide.addCSSClass("dim-label")
        grid.attach(wide, column: 0, row: 3, width: 3)

        return grid
    }
}
