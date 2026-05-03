// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct AboutDialogExample: DemoExample {
    let name = "About Dialog"
    let id = "aboutdialog"
    let category: ExampleCategory = .composite

    let sourceCode = """
    let about = AboutDialog()
    about.applicationName = "My App"
    about.applicationIcon = "applications-science-symbolic"
    about.developerName = "Developer Name"
    about.version = "1.0.0"
    about.website = "https://example.com"
    about.copyright = "© 2026"
    about.licenseType = .mit
    about.comments = "A demo application"
    about.issueUrl = "https://github.com/example/issues"
    about.addLink("Documentation", url: "https://docs.example.com")
    about.present(parentWidget)
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 16)
        box.halign = .center
        box.valign = .center

        let title = Label("About Dialog")
        title.addCSSClass("title-3")
        box.append(title)

        let description = Label("AdwAboutDialog shows application information,\ncredits, license, and links.")
        description.addCSSClass("dim-label")
        box.append(description)

        let showBtn = Button(label: "Show About Dialog")
        showBtn.addCSSClass("suggested-action")
        showBtn.addCSSClass("pill")
        showBtn.halign = .center

        showBtn.onClicked { [showBtn] in
            let about = AboutDialog()
            about.applicationName = "swift-adwaita Demo"
            about.applicationIcon = "applications-science-symbolic"
            about.developerName = "swift-adwaita Contributors"
            about.version = "1.0.0"
            about.website = "https://github.com/example/swift-adwaita"
            about.copyright = "\u{00A9} 2026 swift-adwaita"
            about.licenseType = .mit
            about.comments = "An imperative Swift wrapper for GTK4 and libadwaita."
            about.issueUrl = "https://github.com/example/swift-adwaita/issues"
            about.addLink("Documentation", url: "https://example.com/docs")
            about.addLink("Source Code", url: "https://github.com/example/swift-adwaita")
            about.present(showBtn)
        }

        box.append(showBtn)
        return box
    }
}
