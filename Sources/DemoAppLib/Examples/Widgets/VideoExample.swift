// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct VideoExample: DemoExample {
    let name = "Video"
    let id = "video"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let video = Video()
    video.autoplay = true
    video.loop = true

    // Load via FileDialog
    let dialog = FileDialog()
    dialog.setFilters([
        FileFilter(name: "Videos", suffixes: ["mp4", "webm", "mkv", "avi"]),
    ])
    dialog.open(parent: window) { result in
        if case .success(let path?) = result {
            video.setFilename(path)
        }
    }
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group1 = PreferencesGroup()
        group1.title = "Video Widget"
        group1.description = "GtkVideo can play video files with built-in controls"

        let video = Video()
        video.autoplay = false
        video.loop = true
        video.setSizeRequest(width: -1, height: 240)

        group1.add(video)

        let openBtn = Button(label: "Open Video...")
        openBtn.addCSSClass("suggested-action")
        openBtn.addCSSClass("pill")
        openBtn.halign = .center
        openBtn.setMargins(12)
        openBtn.onClicked { [video, box] in
            let dialog = FileDialog()
            dialog.title = "Open Video"
            dialog.setFilters([
                FileFilter(name: "Videos", suffixes: ["mp4", "webm", "mkv", "avi", "mov", "ogv"]),
                FileFilter(name: "All files", patterns: ["*"])
            ])
            dialog.open(parent: box.root) { [video] result in
                if case let .success(path?) = result {
                    video.setFilename(path)
                }
            }
        }
        group1.add(openBtn)

        box.append(group1)

        // Properties
        let group2 = PreferencesGroup()
        group2.title = "Properties"

        let autoplayRow = ActionRow()
        autoplayRow.title = "Autoplay"
        autoplayRow.subtitle = "Start playing automatically when loaded"
        let autoSwitch = Switch()
        autoSwitch.active = false
        autoSwitch.valign = .center
        autoSwitch.onActiveChanged { [video, autoSwitch] in
            video.autoplay = autoSwitch.active
        }
        autoplayRow.addSuffix(autoSwitch)
        autoplayRow.activatableWidget = autoSwitch
        group2.add(autoplayRow)

        let loopRow = ActionRow()
        loopRow.title = "Loop"
        loopRow.subtitle = "Repeat video when it finishes"
        let loopSwitch = Switch()
        loopSwitch.active = true
        loopSwitch.valign = .center
        loopSwitch.onActiveChanged { [video, loopSwitch] in
            video.loop = loopSwitch.active
        }
        loopRow.addSuffix(loopSwitch)
        loopRow.activatableWidget = loopSwitch
        group2.add(loopRow)

        box.append(group2)

        return box.scrollableClamped()
    }
}
