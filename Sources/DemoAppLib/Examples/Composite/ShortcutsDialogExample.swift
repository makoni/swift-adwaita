// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct ShortcutsDialogExample: DemoExample {
    let name = "Shortcuts Dialog"
    let id = "shortcutsdialog"
    let category: ExampleCategory = .composite

    let sourceCode = """
        let dialog = ShortcutsDialog()

        if let section = ShortcutsSection(title: "General") {
            if let goBack = ShortcutsItem(title: "Go Back", accelerator: "<Primary>Left") {
                section.add(goBack)
            }
            if let find = ShortcutsItem(title: "Find", accelerator: "<Primary>f") {
                section.add(find)
            }
            dialog.add(section)
        }

        dialog.present(parent)
        """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Shortcuts Dialog"
        group.description = "AdwShortcutsDialog shows a keyboard-shortcut overview (libadwaita 1.8+)"

        let openBtn = Button(label: "Show Shortcuts…")
        openBtn.addCSSClass("suggested-action")
        openBtn.addCSSClass("pill")
        openBtn.halign = .center
        openBtn.sensitive = ShortcutsDialog.isAvailable
        // The button lives inside `box`: capture it weakly, or the button's
        // handler would keep the whole page alive forever.
        openBtn.onClicked { [weak box] in
            guard let box, ShortcutsDialog.isAvailable else { return }
            let dialog = ShortcutsDialog()

            if let general = ShortcutsSection(title: "General") {
                for (title, accel) in [
                    ("Go Back", "<Primary>Left"),
                    ("Go Forward", "<Primary>Right"),
                    ("Find", "<Primary>f"),
                    ("Reload", "<Primary>r"),
                ] {
                    if let item = ShortcutsItem(title: title, accelerator: accel) {
                        general.add(item)
                    }
                }
                dialog.add(general)
            }

            if let editing = ShortcutsSection(title: "Editing") {
                for (title, accel) in [
                    ("Bold", "<Primary>b"),
                    ("Italic", "<Primary>i"),
                    ("Undo", "<Primary>z"),
                    ("Redo", "<Primary><Shift>z"),
                ] {
                    if let item = ShortcutsItem(title: title, accelerator: accel) {
                        editing.add(item)
                    }
                }
                dialog.add(editing)
            }

            dialog.present(box.root)
        }
        group.add(openBtn)
        if !ShortcutsDialog.isAvailable {
            let note = Label("Requires libadwaita 1.8+ (shortcuts dialog not available).")
            note.addCSSClass("dim-label")
            group.add(note)
        }

        box.append(group)

        return box.scrollableClamped()
    }
}
