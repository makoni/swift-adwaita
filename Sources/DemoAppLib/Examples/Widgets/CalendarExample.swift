// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct CalendarExample: DemoExample {
    let name = "Calendar"
    let id = "calendar"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let calendar = Calendar()
    calendar.showWeekNumbers = true
    calendar.markDay(15)
    calendar.onDaySelected {
        print("Selected: \\(calendar.year)-\\(calendar.month)-\\(calendar.day)")
    }
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 16)
        box.halign = .center
        box.valign = .center

        let title = Label("Calendar")
        title.addCSSClass("title-3")
        box.append(title)

        let calendar = Calendar()
        calendar.showWeekNumbers = true
        calendar.markDay(15)
        calendar.markDay(25)

        let resultLabel = Label("Select a date")
        resultLabel.addCSSClass("dim-label")

        calendar.onDaySelected { [calendar, resultLabel] in
            resultLabel.text = "Selected: \(calendar.year)-\(calendar.month)-\(calendar.day)"
        }

        box.append(calendar)
        box.append(resultLabel)

        return box
    }
}
