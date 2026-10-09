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

        // One video + controls pair, reused across opens: each "Open Video…"
        // just swaps the shared stream, so live pipelines don't pile up.
        let video = Video()
        video.autoplay = false
        video.setSizeRequest(width: -1, height: 280)
        let controls = MediaControls()
        let playerBox = Box(orientation: .vertical, spacing: 0)
        playerBox.append(video)
        playerBox.append(controls)
        playerBox.hide()

        let openBtn = Button(label: "Open Video…")
        openBtn.addCSSClass("suggested-action")
        openBtn.addCSSClass("pill")
        openBtn.halign = .center
        openBtn.setMargins(12)
        openBtn.onClicked { [box, placeholder, video, controls, playerBox] in
            let dialog = FileDialog()
            dialog.title = "Open Video"
            dialog.setFilters([
                FileFilter(name: "Videos", suffixes: ["mp4", "webm", "mkv", "avi", "mov", "ogv"]),
                FileFilter(name: "All files", patterns: ["*"]),
            ])
            dialog.open(parent: box.root) { [placeholder, video, controls, playerBox] result in
                guard case .success(let path?) = result else { return }
                let stream = MediaStream(filename: path)
                // Tear the previous stream's GStreamer pipeline down now, while
                // the main loop is still running, instead of letting it dispose
                // on the GStreamer thread at process exit — see MediaStream.clear().
                video.mediaStream?.clear()
                video.mediaStream = stream
                controls.mediaStream = stream
                placeholder.hide()
                playerBox.show()
            }
        }
        group.add(placeholder)
        group.add(openBtn)
        group.add(playerBox)

        box.append(group)

        return box.scrollableClamped()
    }
}
