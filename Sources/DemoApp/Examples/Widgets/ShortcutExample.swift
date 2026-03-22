import Adwaita

@MainActor
struct ShortcutExample: DemoExample {
    let name = "Keyboard Shortcuts"
    let id = "shortcuts"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    // Simple shortcut on any widget
    widget.addKeyboardShortcut(key: .s, modifiers: .control) {
        print("Save!")
        return true
    }

    // Multiple modifiers
    widget.addKeyboardShortcut(key: .z,
        modifiers: [.control, .shift]) {
        print("Redo!")
        return true
    }

    // ShortcutController for grouped shortcuts
    let controller = ShortcutController()
    controller.scope = GTK_SHORTCUT_SCOPE_MANAGED
    controller.addShortcut(key: .z, modifiers: .control) {
        print("Undo!")
        return true
    }
    widget.addController(controller)
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Keyboard Shortcuts"
        group.description = "Press the keyboard shortcuts to see them in action"

        let logLabel = Label("Press a shortcut...")
        logLabel.addCSSClass("monospace")
        logLabel.xalign = 0
        logLabel.wrap = true
        logLabel.setMargins(16)

        let logFrame = Frame()
        logFrame.child = logLabel
        logFrame.setSizeRequest(width: -1, height: 80)

        group.add(logFrame)

        // Shortcuts using enum-based API
        let shortcuts: [(Key, KeyModifiers, String)] = [
            (.digit1, .control, "Ctrl+1"),
            (.digit2, .control, "Ctrl+2"),
            (.digit3, .control, "Ctrl+3"),
            (.s, .control, "Ctrl+S — Save"),
            (.z, [.control, .shift], "Ctrl+Shift+Z — Redo"),
        ]

        let infoGroup = PreferencesGroup()
        infoGroup.title = "Registered Shortcuts"
        infoGroup.description = "Click the area above first, then use these keyboard shortcuts"

        for (_, _, desc) in shortcuts {
            let row = ActionRow()
            row.title = desc
            let icon = Image(iconName: "input-keyboard-symbolic")
            icon.valign = .center
            icon.addCSSClass("dim-label")
            row.addSuffix(icon)
            infoGroup.add(row)
        }

        box.append(group)
        box.append(infoGroup)

        // Attach shortcuts using the enum-based API
        let controller = ShortcutController()
        for (key, modifiers, desc) in shortcuts {
            let description = desc
            controller.addShortcut(key: key, modifiers: modifiers) { [logLabel] in
                logLabel.text = "\(description) triggered!"
                return true
            }
        }
        box.addController(controller)
        box.isFocusable = true

        return box.scrollableClamped()
    }
}
