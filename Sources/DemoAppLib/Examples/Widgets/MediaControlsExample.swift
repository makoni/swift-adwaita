// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct MediaControlsExample: DemoExample {
    let name = "Media Controls"
    let id = "mediacontrols"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    // One MediaStream shared between the display and the controls
    let stream = MediaStream(filename: "video.mp4")

    let video = Video()
    video.mediaStream = stream
    video.autoplay = false

    let controls = MediaControls(stream: stream)

    let vbox = Box(orientation: .vertical)
    vbox.append(video)
    vbox.append(controls)
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Media Controls"
        group.description = "GtkMediaControls drives a GtkMediaStream (play/pause, seek, volume)"

        // Placeholder shown before a video is loaded
        let placeholder = StatusPage()
        placeholder.iconName = "video-x-generic-symbolic"
        placeholder.title = "No video loaded"
        placeholder.description = "Pick a file below to see the controls in action."

        let openBtn = Button(label: "Open Video…")
        openBtn.addCSSClass("suggested-action")
        openBtn.addCSSClass("pill")
        openBtn.halign = .center
        openBtn.setMargins(12)
        openBtn.onClicked { [box, placeholder, group] in
            let dialog = FileDialog()
            dialog.title = "Open Video"
            dialog.setFilters([
                FileFilter(name: "Videos", suffixes: ["mp4", "webm", "mkv", "avi", "mov", "ogv"]),
                FileFilter(name: "All files", patterns: ["*"])
            ])
            dialog.open(parent: box.root) { [group, placeholder] result in
                guard case let .success(path?) = result else { return }
                placeholder.hide()
                let stream = MediaStream(filename: path)
                let video = Video()
                video.mediaStream = stream
                video.autoplay = false
                video.setSizeRequest(width: -1, height: 280)
                let controls = MediaControls(stream: stream)

                let playerBox = Box(orientation: .vertical, spacing: 0)
                playerBox.append(video)
                playerBox.append(controls)
                group.add(playerBox)
            }
        }
        group.add(placeholder)
        group.add(openBtn)

        box.append(group)

        return box.scrollableClamped()
    }
}
