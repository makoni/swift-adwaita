// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct CenterBoxExample: DemoExample {
    let name = "Center Box"
    let id = "centerbox"
    let category: ExampleCategory = .widgets

    let sourceCode = """
        let centerBox = CenterBox()
        centerBox.startWidget = Button(iconName: "go-previous-symbolic")
        centerBox.centerWidget = Label("Page Title")
        centerBox.endWidget = Button(iconName: "open-menu-symbolic")

        // When space runs out, shrink the center widget last
        centerBox.shrinkCenterLast = true
        """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Center Box"
        group.description = "GtkCenterBox keeps the center widget centred between the start and end widgets"

        let centerBox = CenterBox()
        centerBox.addCSSClass("card")
        centerBox.setMargins(12)

        let startBtn = Button(iconName: "go-previous-symbolic")
        startBtn.addCSSClass("flat")
        let titleLabel = Label("Page Title")
        titleLabel.addCSSClass("title-4")
        let endBtn = Button(iconName: "open-menu-symbolic")
        endBtn.addCSSClass("flat")

        centerBox.startWidget = startBtn
        centerBox.centerWidget = titleLabel
        centerBox.endWidget = endBtn

        group.add(centerBox)

        // Controls
        let controlGroup = PreferencesGroup()
        controlGroup.title = "Controls"

        let shrinkRow = ActionRow()
        shrinkRow.title = "Shrink center last"
        shrinkRow.subtitle = "Centre widget resizes only when start/end can't shrink"
        let shrinkSwitch = Switch()
        shrinkSwitch.active = true
        shrinkSwitch.valign = .center
        shrinkSwitch.bind(.active, to: centerBox, property: .custom("shrink-center-last"))
        shrinkRow.addSuffix(shrinkSwitch)
        shrinkRow.activatableWidget = shrinkSwitch
        controlGroup.add(shrinkRow)

        let swapRow = ActionRow()
        swapRow.title = "Clear center"
        let clearBtn = Button(label: "Clear")
        clearBtn.valign = .center
        clearBtn.onClicked { [centerBox] in
            centerBox.centerWidget = nil
        }
        let restoreBtn = Button(label: "Restore")
        restoreBtn.valign = .center
        restoreBtn.onClicked { [centerBox] in
            let label = Label("Page Title")
            label.addCSSClass("title-4")
            centerBox.centerWidget = label
        }
        swapRow.addSuffix(clearBtn)
        swapRow.addSuffix(restoreBtn)
        swapRow.activatableWidget = clearBtn
        controlGroup.add(swapRow)

        box.append(group)
        box.append(controlGroup)

        return box.scrollableClamped()
    }
}
