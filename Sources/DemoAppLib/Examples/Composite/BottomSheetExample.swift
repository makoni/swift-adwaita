// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct BottomSheetExample: DemoExample {
    let name = "Bottom Sheet"
    let id = "bottomsheet"
    let category: ExampleCategory = .composite
    let opensInWindow = true

    let sourceCode = """
        let bottomSheet = BottomSheet()
        bottomSheet.showDragHandle = true
        bottomSheet.modal = true

        // Main content
        let content = StatusPage()
        content.title = "Bottom Sheet Demo"
        content.iconName = "view-reveal-symbolic"
        content.description = "Tap the button to open the sheet"
        bottomSheet.content = content

        // Sheet content
        let group = PreferencesGroup()
        group.title = "Settings"
        let row1 = SwitchRow()
        row1.title = "Notifications"
        row1.active = true
        group.add(row1)
        let row2 = SwitchRow()
        row2.title = "Dark Mode"
        group.add(row2)
        bottomSheet.sheet = group

        // Toggle button
        let toggleBtn = Button(label: "Open Sheet")
        // Weak: the sheet owns the button (and so this handler).
        toggleBtn.onClicked { [weak bottomSheet] in
            guard let bottomSheet else { return }
            bottomSheet.open = !bottomSheet.open
        }
        content.child = toggleBtn
        """

    func buildWidget() -> Widget {
        guard let bottomSheet = BottomSheet() else {
            return Label("BottomSheet requires libadwaita 1.6+")
        }
        bottomSheet.showDragHandle = true
        bottomSheet.modal = true

        // Main content
        let content = StatusPage()
        content.title = "Bottom Sheet Demo"
        content.iconName = "view-reveal-symbolic"
        content.description = "Tap the button below to open the sheet"

        let toggleBtn = Button(label: "Open Sheet")
        toggleBtn.addCSSClass("suggested-action")
        toggleBtn.addCSSClass("pill")
        toggleBtn.halign = .center
        toggleBtn.onClicked { [weak bottomSheet] in
            guard let bottomSheet else { return }
            bottomSheet.open = !bottomSheet.open
        }
        content.child = toggleBtn
        bottomSheet.content = content

        // Sheet content
        let sheetBox = Box(orientation: .vertical, spacing: 12)
        sheetBox.setMargins(12)

        let group = PreferencesGroup()
        group.title = "Quick Settings"

        let row1 = SwitchRow()
        row1.title = "Notifications"
        row1.subtitle = "Receive push notifications"
        row1.active = true
        group.add(row1)

        let row2 = SwitchRow()
        row2.title = "Dark Mode"
        row2.subtitle = "Use dark color scheme"
        group.add(row2)
        // Show the app's current darkness (and follow it while open), and
        // force the scheme when the user flips the row.
        let styleManager = StyleManager.default
        styleManager.bind(.custom("dark"), to: row2, property: .active)
        row2.onNotify(.active) { [weak row2, styleManager] in
            guard let row2, row2.active != styleManager.dark else { return }
            if row2.active {
                styleManager.forceDark()
            } else {
                styleManager.forceLight()
            }
        }

        let row3 = SwitchRow()
        row3.title = "Do Not Disturb"
        row3.subtitle = "Silence all alerts"
        group.add(row3)

        sheetBox.append(group)
        bottomSheet.sheet = sheetBox

        // Bottom bar that shows when sheet is closed
        let bottomBar = Box(orientation: .horizontal, spacing: 6)
        bottomBar.halign = .center
        bottomBar.setMargins(6)
        let barLabel = Label("Swipe up for settings")
        barLabel.addCSSClass("dim-label")
        bottomBar.append(barLabel)
        bottomSheet.bottomBar = bottomBar

        let headerBar = HeaderBar()
        let toolbarView = ToolbarView()
        toolbarView.addTopBar(headerBar)
        toolbarView.content = bottomSheet

        return toolbarView
    }
}
