// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct UriLauncherExample: DemoExample {
    let name = "URI Launcher"
    let id = "urilauncher"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    // Open a URL in the default browser
    let launcher = UriLauncher(uri: "https://gnome.org")
    launcher.launch()

    // Or with an async result
    launcher.launch { success in
        print("Launched: \\(success)")
    }

    // Change URI and launch again
    launcher.uri = "https://gtk.org"
    launcher.launch()

    // When the URI comes from untrusted input, allowlist the scheme first:
    let uri = "https://gnome.org"
    if uri.lowercased().hasPrefix("http://") || uri.lowercased().hasPrefix("https://") || uri.lowercased().hasPrefix("file://") {
        UriLauncher(uri: uri).launch()
    }
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group = PreferencesGroup()
        group.title = "URI Launcher"
        group.description = "GtkUriLauncher opens URIs with the default system handler"

        let entry = Entry()
        entry.text = "https://gnome.org"

        let status = Label("Idle")
        status.addCSSClass("dim-label")
        status.addCSSClass("monospace")

        let launchBtn = Button(label: "Launch")
        launchBtn.addCSSClass("suggested-action")
        launchBtn.valign = .center
        launchBtn.onClicked { [entry, status] in
            // Launch only the schemes this demo intends to open. The text here is
            // user-typed (local-user threat model), but this is the pattern that
            // gets copy-pasted — so show the safe form: an allowlist is what you
            // need before this ever launches a URI from untrusted data (document
            // links, clipboard, a network source).
            let uri = entry.text
            let lower = uri.lowercased()
            guard lower.hasPrefix("http://") || lower.hasPrefix("https://") || lower.hasPrefix("file://") else {
                status.text = "Only http(s)/file URIs are launched here"
                return
            }
            status.text = "Launching \(uri) …"
            let launcher = UriLauncher(uri: uri)
            launcher.launch(parent: launchBtn.root) { ok in
                status.text = ok ? "Launched ✓" : "Launch failed ✗"
            }
        }

        let row = ActionRow()
        row.title = "URI"
        row.addSuffix(entry)
        row.addSuffix(launchBtn)
        row.activatableWidget = entry
        group.add(row)

        let statusRow = ActionRow()
        statusRow.title = "Result"
        statusRow.addSuffix(status)
        group.add(statusRow)

        // Preset links
        let presetGroup = PreferencesGroup()
        presetGroup.title = "Presets"

        let presetsBox = Box(orientation: .horizontal, spacing: 8)
        for (name, uri) in [
            ("GNOME", "https://gnome.org"),
            ("GTK", "https://gtk.org"),
            ("GitHub", "https://github.com")
        ] {
            let btn = Button(label: name)
            btn.addCSSClass("pill")
            btn.onClicked { [entry] in
                entry.text = uri
            }
            presetsBox.append(btn)
        }
        presetGroup.add(presetsBox)

        box.append(group)
        box.append(presetGroup)

        return box.scrollableClamped()
    }
}
