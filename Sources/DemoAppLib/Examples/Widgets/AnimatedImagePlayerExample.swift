// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita
import Foundation

/// Retains the currently-playing player so it outlives the transient file-picker
/// closure while still being released when the button (and the closure that
/// captures it) is torn down. A strong reference here is cycle-free: the
/// picture is owned by the widget tree and the player→picture edge is one-way.
@MainActor
private final class PlayerHolder {
    var player: AnimatedImagePlayer?
}

@MainActor
struct AnimatedImagePlayerExample: DemoExample {
    let name = "Animated Image"
    let id = "animatedimage"
    let category: ExampleCategory = .widgets

    let sourceCode = """
        let picture = Picture()

        if let player = try? AnimatedImagePlayer(contentsOf: url, displayedBy: picture) {
            player.start()
            let meta = player.metadata
            print("\\(meta.width) x \\(meta.height)")
        }
        """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Animated Image"
        group.description = "AnimatedImagePlayer drives a Picture with GIF/WebP animation frames"

        let picture = Picture()
        picture.addCSSClass("frame")
        picture.setSizeRequest(width: 280, height: 210)
        picture.halign = .center
        picture.setMargins(12)

        let openBtn = Button(label: "Open Animated Image…")
        openBtn.addCSSClass("suggested-action")
        openBtn.addCSSClass("pill")
        openBtn.halign = .center
        openBtn.setMargins(12)

        let status = Label("No image loaded")
        status.addCSSClass("dim-label")
        status.addCSSClass("monospace")
        status.wrap = true

        let playerHolder = PlayerHolder()

        openBtn.onClicked { [weak openBtn, picture, status, playerHolder] in
            let dialog = FileDialog()
            dialog.title = "Open Animated Image"
            dialog.setFilters([
                FileFilter(name: "Animated images", suffixes: ["gif", "webp"]),
                FileFilter(name: "All files", patterns: ["*"]),
            ])
            dialog.open(parent: openBtn?.root) { [picture, status, playerHolder] result in
                guard case .success(let path?) = result else { return }
                let url = URL(fileURLWithPath: path)
                do {
                    if let player = try AnimatedImagePlayer(contentsOf: url, displayedBy: picture) {
                        // Stop the previously-playing animation (if any) so its
                        // timer does not keep repainting the picture with stale
                        // frames, then hand the picture to the new player and
                        // hold it in the button's closure for the UI's lifetime.
                        playerHolder.player?.stop()
                        playerHolder.player = player
                        player.start()
                        let meta = player.metadata
                        status.text = "Playing \(meta.width)×\(meta.height)"
                    } else {
                        // A static file: stop any running animation (its timer
                        // would otherwise repaint on top of the single frame),
                        // then show the still image.
                        playerHolder.player?.stop()
                        playerHolder.player = nil
                        picture.setFilename(path)
                        status.text = "Static image (single frame, no animation)"
                    }
                } catch {
                    status.text = "Failed to load: \(error.localizedDescription)"
                }
            }
        }

        group.add(picture)
        group.add(openBtn)
        group.add(status)

        box.append(group)

        return box.scrollableClamped()
    }
}
