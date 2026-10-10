// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct PreferencesDialogExample: DemoExample {
    let name = "Preferences Dialog"
    let id = "prefsdialog"
    let category: ExampleCategory = .composite
    let opensInWindow = false

    let sourceCode = """
        let dialog = PreferencesDialog()
        dialog.searchEnabled = true

        let general = PreferencesPage()
        general.title = "General"
        general.iconName = "preferences-other-symbolic"

        let group = PreferencesGroup()
        group.title = "Appearance"
        let darkRow = SwitchRow()
        darkRow.title = "Dark Mode"
        darkRow.active = StyleManager.default.dark
        darkRow.onNotify(.active) { [weak darkRow] in
            guard let darkRow else { return }
            if darkRow.active {
                StyleManager.default.forceDark()
            } else {
                StyleManager.default.forceLight()
            }
        }
        group.add(darkRow)
        general.add(group)

        dialog.add(general)
        dialog.present(parentWidget)
        """

    func buildWidget() -> Widget {
        let statusPage = StatusPage()
        statusPage.iconName = "preferences-other-symbolic"
        statusPage.title = "Preferences Dialog"
        statusPage.description =
            "A multi-page preferences dialog with search. Dark Mode applies to the whole app; the other rows are sample settings."

        let openBtn = Button(label: "Open Preferences")
        openBtn.addCSSClass("suggested-action")
        openBtn.addCSSClass("pill")
        openBtn.halign = .center
        // Weak self-capture: the button owns this handler.
        openBtn.onClicked { [weak openBtn] in
            guard let openBtn else { return }
            let dialog = PreferencesDialog()
            dialog.searchEnabled = true

            // General page
            let general = PreferencesPage()
            general.title = "General"
            general.iconName = "preferences-other-symbolic"

            let appearanceGroup = PreferencesGroup()
            appearanceGroup.title = "Appearance"
            appearanceGroup.description = "Customize the look and feel"

            let darkRow = SwitchRow()
            darkRow.title = "Dark Mode"
            darkRow.subtitle = "Use dark color scheme"
            // Show the app's current darkness (and follow it while open), and
            // force the scheme when the user flips the row. The binding holds
            // the row weakly, and the row's own handler captures it weakly, so
            // nothing on the StyleManager singleton outlives the dialog.
            let styleManager = StyleManager.default
            styleManager.bind(.custom("dark"), to: darkRow, property: .active)
            darkRow.onNotify(.active) { [weak darkRow, styleManager] in
                guard let darkRow, darkRow.active != styleManager.dark else { return }
                if darkRow.active {
                    styleManager.forceDark()
                } else {
                    styleManager.forceLight()
                }
            }
            appearanceGroup.add(darkRow)

            let animationsRow = SwitchRow()
            animationsRow.title = "Enable Animations"
            animationsRow.subtitle = "Show transition animations"
            animationsRow.active = true
            appearanceGroup.add(animationsRow)

            let fontRow = SpinRow.newWithRange(min: 8, max: 32, step: 1)
            fontRow.title = "Font Size"
            fontRow.subtitle = "Base font size in points"
            fontRow.value = 14
            appearanceGroup.add(fontRow)

            general.add(appearanceGroup)

            // Notifications group
            let notifGroup = PreferencesGroup()
            notifGroup.title = "Notifications"

            let soundRow = SwitchRow()
            soundRow.title = "Sound"
            soundRow.subtitle = "Play notification sounds"
            soundRow.active = true
            notifGroup.add(soundRow)

            let badgeRow = SwitchRow()
            badgeRow.title = "Badge Count"
            badgeRow.subtitle = "Show unread count on app icon"
            badgeRow.active = true
            notifGroup.add(badgeRow)

            general.add(notifGroup)
            dialog.add(general)

            // Account page
            let account = PreferencesPage()
            account.title = "Account"
            account.iconName = "avatar-default-symbolic"

            let profileGroup = PreferencesGroup()
            profileGroup.title = "Profile"

            let nameRow = ActionRow()
            nameRow.title = "Display Name"
            nameRow.subtitle = "John Doe"
            let editIcon = Image(iconName: "document-edit-symbolic")
            editIcon.valign = .center
            nameRow.addSuffix(editIcon)
            profileGroup.add(nameRow)

            let emailRow = ActionRow()
            emailRow.title = "Email"
            emailRow.subtitle = "john@example.com"
            profileGroup.add(emailRow)

            account.add(profileGroup)
            dialog.add(account)

            dialog.present(openBtn)
        }

        statusPage.child = openBtn
        return statusPage
    }
}
