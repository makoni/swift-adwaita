// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct AspectFrameExample: DemoExample {
    let name = "Aspect Frame"
    let id = "aspectframe"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    // Keep a 16:9 aspect ratio for a video area
    let frame = AspectFrame(ratio: 16.0 / 9.0)
    frame.child = videoWidget

    // Or let the child determine the ratio
    let frame2 = AspectFrame(obeyChild: true)
    frame2.child = picture
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Aspect Frame"
        group.description = "GtkAspectFrame letterboxes or pillarboxes its child to keep a fixed aspect ratio"

        // The child we are preserving the ratio of
        let content = Box(orientation: .vertical, spacing: 0)
        content.addCSSClass("card")
        content.addCSSClass("view")
        let contentLabel = Label("Content")
        contentLabel.addCSSClass("title-4")
        content.append(contentLabel)

        let frame = AspectFrame(ratio: Float(16.0 / 9.0))
        frame.hexpand = true
        frame.vexpand = true
        frame.child = content
        frame.setMargins(12)

        group.add(frame)

        // Ratio presets
        let controlGroup = PreferencesGroup()
        controlGroup.title = "Ratio"

        let ratioRow = ActionRow()
        ratioRow.title = "Aspect ratio"
        ratioRow.subtitle = "Width : height of the preserved box"

        let ratioBox = Box(orientation: .horizontal, spacing: 8)
        for (name, value) in [("16:9", 16.0 / 9.0), ("4:3", 4.0 / 3.0), ("1:1", 1.0), ("1:2", 0.5)] {
            let btn = Button(label: name)
            btn.addCSSClass("pill")
            btn.onClicked { [frame] in
                frame.ratio = Float(value)
                frame.obeyChild = false
            }
            ratioBox.append(btn)
        }
        ratioRow.addSuffix(ratioBox)
        ratioRow.activatableWidget = ratioBox
        controlGroup.add(ratioRow)

        let obeyRow = ActionRow()
        obeyRow.title = "Obey child"
        obeyRow.subtitle = "Use the child's own ratio instead of the preset"
        let obeySwitch = Switch()
        obeySwitch.valign = .center
        obeySwitch.onActiveChanged { [frame, obeySwitch] in
            frame.obeyChild = obeySwitch.active
        }
        obeyRow.addSuffix(obeySwitch)
        obeyRow.activatableWidget = obeySwitch
        controlGroup.add(obeyRow)

        box.append(group)
        box.append(controlGroup)

        return box.scrollableClamped()
    }
}
