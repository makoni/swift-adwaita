// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct NotebookExample: DemoExample {
    let name = "Notebook"
    let id = "notebook"
    let category: ExampleCategory = .composite

    let sourceCode = """
    let notebook = Notebook()
    notebook.appendPage(Label("Page 1"), label: "Tab 1")
    notebook.appendPage(Label("Page 2"), label: "Tab 2")
    notebook.scrollable = true
    notebook.tabPos = .top
    """

    func buildWidget() -> Widget {
        let notebook = Notebook()
        notebook.scrollable = true

        // Add several pages
        for i in 1 ... 5 {
            let page = Box(orientation: .vertical, spacing: 12)
            page.setMargins(24)
            page.halign = .center
            page.valign = .center

            let title = Label("Page \(i)")
            title.addCSSClass("title-2")
            page.append(title)

            let desc = Label("This is the content of tab \(i).\nNotebook provides classic tabbed navigation.")
            desc.wrap = true
            desc.halign = .center
            page.append(desc)

            notebook.appendPage(page, label: "Tab \(i)")
        }

        notebook.currentPage = 0
        notebook.hexpand = true
        notebook.vexpand = true

        return notebook
    }
}
