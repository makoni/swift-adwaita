// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct KeyboardShortcutsExample: DemoExample {
    let name = "Shortcut Controller"
    let id = "shortcutcontroller"
    let category: ExampleCategory = .composite

    let sourceCode = """
    // ShortcutController with managed scope (window-wide)
    let controller = ShortcutController()
    controller.scope = GTK_SHORTCUT_SCOPE_MANAGED

    // Add shortcuts using Key enum + KeyModifiers
    controller.addShortcut(key: .s, modifiers: .control) {
        log("Ctrl+S: Save")
        return true
    }
    controller.addShortcut(key: .z,
        modifiers: [.control, .shift]) {
        log("Ctrl+Shift+Z: Redo")
        return true
    }
    widget.addController(controller)

    // Simple per-widget shortcut via Widget API
    button.addKeyboardShortcut(key: .return,
        modifiers: []) {
        log("Enter pressed on button")
        return true
    }

    // Scopes:
    //   GTK_SHORTCUT_SCOPE_LOCAL — widget only
    //   GTK_SHORTCUT_SCOPE_MANAGED — window
    //   GTK_SHORTCUT_SCOPE_GLOBAL — entire app
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)
        box.isFocusable = true

        // -- Log area --
        var logLines: [String] = []
        let maxLogLines = 12

        let logLabel = Label("Press a shortcut to see it logged here...")
        logLabel.addCSSClass("monospace")
        logLabel.xalign = 0
        logLabel.wrap = true
        logLabel.setMargins(16)

        func appendLog(_ message: String) {
            logLines.append(message)
            if logLines.count > maxLogLines {
                logLines.removeFirst()
            }
            logLabel.text = logLines.joined(separator: "\n")
        }

        let logGroup = PreferencesGroup()
        logGroup.title = "Shortcut Log"
        logGroup.description = "Focus this area and press any registered shortcut"

        let logFrame = Frame()
        logFrame.child = logLabel
        logFrame.setSizeRequest(width: -1, height: 120)
        logGroup.add(logFrame)

        let clearBtn = Button(label: "Clear Log")
        clearBtn.halign = .center
        clearBtn.addCSSClass("flat")
        clearBtn.onClicked { [logLabel] in
            logLines.removeAll()
            logLabel.text = "Log cleared."
        }
        logGroup.add(clearBtn)

        box.append(logGroup)

        // -- Managed scope shortcuts (window-wide) --
        let managedGroup = PreferencesGroup()
        managedGroup.title = "Managed Scope (Window-Wide)"
        managedGroup.description = "These shortcuts work anywhere in the window using ShortcutController"

        let managedShortcuts: [(Key, KeyModifiers, String)] = [
            (.s, .control, "Ctrl+S"),
            (.z, .control, "Ctrl+Z"),
            (.z, [.control, .shift], "Ctrl+Shift+Z"),
            (.n, .control, "Ctrl+N"),
            (.w, .control, "Ctrl+W")
        ]

        let managedController = ShortcutController()
        managedController.scope = GTK_SHORTCUT_SCOPE_MANAGED

        for (key, modifiers, desc) in managedShortcuts {
            let description = desc
            managedController.addShortcut(key: key, modifiers: modifiers) {
                appendLog("[\(description)] managed scope")
                return true
            }

            let row = ActionRow()
            row.title = description
            row.subtitle = "Scope: managed (window)"
            let badge = Label("managed")
            badge.addCSSClass("dim-label")
            badge.addCSSClass("caption")
            badge.valign = .center
            row.addSuffix(badge)
            managedGroup.add(row)
        }

        box.addController(managedController)
        box.append(managedGroup)

        // -- Local scope shortcuts (widget-only) --
        let localGroup = PreferencesGroup()
        localGroup.title = "Local Scope (Widget-Only)"
        localGroup.description = "These shortcuts only work when the widget has focus, using addKeyboardShortcut()"

        let localShortcuts: [(Key, KeyModifiers, String)] = [
            (.f1, [], "F1"),
            (.f2, [], "F2"),
            (.space, .control, "Ctrl+Space")
        ]

        for (key, modifiers, desc) in localShortcuts {
            let description = desc
            box.addKeyboardShortcut(key: key, modifiers: modifiers) {
                appendLog("[\(description)] local scope")
                return true
            }

            let row = ActionRow()
            row.title = description
            row.subtitle = "Scope: local (widget.addKeyboardShortcut)"
            let badge = Label("local")
            badge.addCSSClass("dim-label")
            badge.addCSSClass("caption")
            badge.valign = .center
            row.addSuffix(badge)
            localGroup.add(row)
        }

        box.append(localGroup)

        // -- Key and modifier reference --
        let refGroup = PreferencesGroup()
        refGroup.title = "Key &amp; Modifier Reference"
        refGroup.description = "Available Key enum values and KeyModifiers"

        let modRow = ActionRow()
        modRow.title = "KeyModifiers"
        modRow.subtitle = ".control, .shift, .alt, .super — combine with [.control, .shift]"
        refGroup.add(modRow)

        let keyRow = ActionRow()
        keyRow.title = "Key enum"
        keyRow.subtitle = ".a-.z, .digit0-.digit9, .f1-.f12, .escape, .return, .tab, .space, .up/.down/.left/.right, and more"
        refGroup.add(keyRow)

        let scopeRow = ActionRow()
        scopeRow.title = "Scopes"
        scopeRow.subtitle = "LOCAL (widget), MANAGED (window), GLOBAL (app)"
        refGroup.add(scopeRow)

        box.append(refGroup)

        return box.scrollableClamped()
    }
}
