// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct StyleManagerExample: DemoExample {
    let name = "Style Manager"
    let id = "stylemanager"
    let category: ExampleCategory = .composite

    let sourceCode = """
        let styleManager = StyleManager.default

        // Force dark theme
        styleManager.forceDark()

        // Check current state
        print("Dark: \\(styleManager.dark)")
        print("High contrast: \\(styleManager.highContrast)")

        // Listen for changes
        styleManager.onDarkChanged {
            print("Theme changed, dark: \\(styleManager.dark)")
        }

        // Reset to system default
        styleManager.resetColorScheme()
        """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 16)
        box.halign = .center
        box.valign = .center
        box.setMargins(24)

        let title = Label("Style Manager")
        title.addCSSClass("title-3")
        box.append(title)

        let styleManager = StyleManager.default

        let statusLabel = Label("")
        statusLabel.addCSSClass("dim-label")

        let updateStatus = { [styleManager, statusLabel] in
            let scheme =
                switch styleManager.colorScheme {
                case .forceDark: "Force Dark"
                case .forceLight: "Force Light"
                case .preferDark: "Prefer Dark"
                case .preferLight: "Prefer Light"
                default: "Default (System)"
                }
            let dark = styleManager.dark ? "Yes" : "No"
            let hc = styleManager.highContrast ? "Yes" : "No"
            statusLabel.text = "Scheme: \(scheme) | Dark: \(dark) | High-Contrast: \(hc)"
        }
        updateStatus()

        // Theme buttons
        let btnBox = Box(orientation: .horizontal, spacing: 8)
        btnBox.halign = .center

        // The label follows the notifications below, so the buttons only
        // need to set the scheme.
        let systemBtn = Button(label: "System")
        systemBtn.onClicked { [styleManager] in
            styleManager.resetColorScheme()
        }

        let lightBtn = Button(label: "Light")
        lightBtn.onClicked { [styleManager] in
            styleManager.forceLight()
        }

        let darkBtn = Button(label: "Dark")
        darkBtn.onClicked { [styleManager] in
            styleManager.forceDark()
        }

        let preferDarkBtn = Button(label: "Prefer Dark")
        preferDarkBtn.onClicked { [styleManager] in
            styleManager.preferDark()
        }

        btnBox.append(systemBtn)
        btnBox.append(lightBtn)
        btnBox.append(darkBtn)
        btnBox.append(preferDarkBtn)

        box.append(btnBox)
        box.append(statusLabel)

        // Follow every field the label shows, including changes made outside
        // this page (another example, or the system theme): `dark` alone misses
        // a scheme change that keeps the same darkness, and high contrast.
        let connections = [
            styleManager.onDarkChanged { updateStatus() },
            styleManager.onHighContrastChanged { updateStatus() },
            SignalHelper.onNotify(styleManager, property: .custom("color-scheme")) { updateStatus() },
        ]
        // StyleManager is a process-wide singleton: drop the handlers with the page.
        box.onDestroy {
            for connection in connections { connection.disconnect() }
        }

        return box
    }
}
