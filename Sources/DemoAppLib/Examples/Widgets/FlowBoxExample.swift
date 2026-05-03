// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct FlowBoxExample: DemoExample {
    let name = "Flow Box"
    let id = "flowbox"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let flowBox = FlowBox()
    flowBox.minChildrenPerLine = 2
    flowBox.maxChildrenPerLine = 8
    flowBox.rowSpacing = 8
    flowBox.columnSpacing = 8
    flowBox.homogeneous = true
    flowBox.selectionMode = .single

    for i in 1...24 {
        let btn = Button(label: "Item \\(i)")
        flowBox.append(btn)
    }
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 16)
        box.setMargins(24)

        let title = Label("Flow Box")
        title.addCSSClass("title-3")
        box.append(title)

        let hint = Label("Resize the window to see items reflow across rows")
        hint.addCSSClass("dim-label")
        hint.wrap = true
        box.append(hint)

        let flowBox = FlowBox()
        flowBox.minChildrenPerLine = 2
        flowBox.maxChildrenPerLine = 10
        flowBox.rowSpacing = 8
        flowBox.columnSpacing = 8
        flowBox.homogeneous = true
        flowBox.selectionMode = .single

        let items = [
            ("media-playback-start-symbolic", "Play"),
            ("media-playback-pause-symbolic", "Pause"),
            ("media-playback-stop-symbolic", "Stop"),
            ("media-skip-forward-symbolic", "Next"),
            ("media-skip-backward-symbolic", "Prev"),
            ("media-record-symbolic", "Record"),
            ("audio-volume-high-symbolic", "Volume"),
            ("audio-volume-muted-symbolic", "Mute"),
            ("weather-clear-symbolic", "Sunny"),
            ("weather-overcast-symbolic", "Cloudy"),
            ("weather-showers-symbolic", "Rain"),
            ("weather-snow-symbolic", "Snow"),
            ("starred-symbolic", "Star"),
            ("heart-filled-symbolic", "Heart"),
            ("bookmark-new-symbolic", "Bookmark"),
            ("document-new-symbolic", "New"),
            ("document-open-symbolic", "Open"),
            ("document-save-symbolic", "Save"),
            ("edit-copy-symbolic", "Copy"),
            ("edit-paste-symbolic", "Paste"),
            ("edit-cut-symbolic", "Cut"),
            ("edit-undo-symbolic", "Undo"),
            ("edit-redo-symbolic", "Redo"),
            ("folder-symbolic", "Folder")
        ]

        for (icon, label) in items {
            let itemBox = Box(orientation: .vertical, spacing: 4)
            itemBox.halign = .center
            itemBox.valign = .center
            itemBox.setMargins(8)
            let img = Image(iconName: icon)
            img.pixelSize = 32
            let lbl = Label(label)
            lbl.addCSSClass("caption")
            itemBox.append(img)
            itemBox.append(lbl)
            flowBox.append(itemBox)
        }

        let frame = Frame()
        frame.child = flowBox
        box.append(frame)

        let countLabel = Label("\(items.count) items — max 10 per row")
        countLabel.addCSSClass("dim-label")
        box.append(countLabel)

        // No Clamp — let it fill the whole content area for visible reflow
        let scrolled = ScrolledWindow()
        scrolled.child = box
        scrolled.setPolicy(horizontal: .never, vertical: .automatic)
        return scrolled
    }
}
