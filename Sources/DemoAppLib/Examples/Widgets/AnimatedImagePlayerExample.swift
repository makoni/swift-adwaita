// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita
import Foundation

private let animatedImagePlayerKey = "swift-adwaita-demo-animated-image-player"

@MainActor
struct AnimatedImagePlayerExample: DemoExample {
    let name = "Animated Image"
    let id = "animatedimage"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let picture = Picture()

    let player = try AnimatedImagePlayer(contentsOf: url, displayedBy: picture)
    player.start()

    let meta = player.metadata
    print(\\(meta.width) x \\(meta.height))
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

        openBtn.onClicked { [box, picture, status] in
            let dialog = FileDialog()
            dialog.title = "Open Animated Image"
            dialog.setFilters([
                FileFilter(name: "Animated images", suffixes: ["gif", "webp"]),
                FileFilter(name: "All files", patterns: ["*"])
            ])
            dialog.open(parent: box.root) { [picture, status] result in
                guard case let .success(path?) = result else { return }
                let url = URL(fileURLWithPath: path)
                do {
                    if let player = try AnimatedImagePlayer(contentsOf: url, displayedBy: picture) {
                        // Keep the player alive for the picture's lifetime and release
                        // it when the picture is finalized — same retention idiom as
                        // Dialog.enableBackdropClickDismiss (Dialog+BackdropDismiss.swift):
                        // passRetained + g_object_set_data_full with a destroy-notify.
                        // The destroy-notify runs on the main thread during finalize,
                        // which satisfies AnimatedImagePlayer's MainActor-isolated deinit.
                        let playerPointer = Unmanaged.passRetained(player).toOpaque()
                        g_object_set_data_full(picture.gobjectPointer, animatedImagePlayerKey, playerPointer) { data in
                            guard let data else { return }
                            Unmanaged<AnimatedImagePlayer>.fromOpaque(data).release()
                        }
                        player.start()
                        let meta = player.metadata
                        status.text = "Playing \(meta.width)×\(meta.height)"
                    } else {
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
