// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct GestureExample: DemoExample {
    let name = "Gestures"
    let id = "gestures"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    // Long press
    let longPress = GestureLongPress()
    longPress.onPressed { x, y in
        print("Long press at (\\(x), \\(y))")
    }
    widget.addController(longPress)

    // Swipe
    let swipe = GestureSwipe()
    swipe.onSwipe { vx, vy in
        print("Swipe velocity: (\\(vx), \\(vy))")
    }
    widget.addController(swipe)

    // Click
    let click = GestureClick()
    click.onPressed { button, x, y in
        print("Button \\(button) at (\\(x), \\(y))")
    }
    widget.addController(click)

    // Drag
    let drag = GestureDrag()
    drag.onDragUpdate { dx, dy in
        print("Offset: (\\(dx), \\(dy))")
    }
    widget.addController(drag)
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        // Long Press
        let group1 = PreferencesGroup()
        group1.title = "Long Press"
        group1.description = "Press and hold on the area below"

        let longPressLabel = Label("Press and hold here")
        longPressLabel.addCSSClass("title-3")

        let longPressResult = Label("")
        longPressResult.addCSSClass("monospace")
        longPressResult.addCSSClass("dim-label")

        let longPressBox = Box(orientation: .vertical, spacing: 8)
        longPressBox.append(longPressLabel)
        longPressBox.append(longPressResult)
        longPressBox.halign = .center
        longPressBox.valign = .center
        longPressBox.setMargins(24)
        longPressBox.setSizeRequest(width: -1, height: 120)

        let longPress = GestureLongPress()
        longPress.onPressed { [longPressLabel, longPressResult] x, y in
            longPressLabel.text = "Long press detected!"
            longPressResult.text = "at (\(Int(x)), \(Int(y)))"
            longPressLabel.addCSSClass("success")
        }
        longPress.onCancelled { [longPressLabel, longPressResult] in
            longPressLabel.text = "Press and hold here"
            longPressResult.text = "Cancelled"
            longPressLabel.removeCSSClass("success")
        }
        longPressBox.addController(longPress)

        group1.add(longPressBox)
        box.append(group1)

        // Swipe
        let group2 = PreferencesGroup()
        group2.title = "Swipe"
        group2.description = "Swipe in any direction on the area below"

        let swipeLabel = Label("Swipe here")
        swipeLabel.addCSSClass("title-3")

        let swipeResult = Label("")
        swipeResult.addCSSClass("monospace")
        swipeResult.addCSSClass("dim-label")

        let directionLabel = Label("")
        directionLabel.addCSSClass("heading")

        let swipeBox = Box(orientation: .vertical, spacing: 8)
        swipeBox.append(swipeLabel)
        swipeBox.append(directionLabel)
        swipeBox.append(swipeResult)
        swipeBox.halign = .center
        swipeBox.valign = .center
        swipeBox.setMargins(24)
        swipeBox.setSizeRequest(width: -1, height: 120)

        let swipe = GestureSwipe()
        swipe.onSwipe { [swipeResult, directionLabel] vx, vy in
            swipeResult.text = "Velocity: (\(Int(vx)), \(Int(vy))) px/s"
            let direction: String = if abs(vx) > abs(vy) {
                vx > 0 ? "Right" : "Left"
            } else {
                vy > 0 ? "Down" : "Up"
            }
            directionLabel.text = direction
        }
        swipeBox.addController(swipe)

        group2.add(swipeBox)
        box.append(group2)

        // Click
        let group3 = PreferencesGroup()
        group3.title = "Click"
        group3.description = "Click (tap) the area below; the button number is reported"

        let clickLabel = Label("Click here")
        clickLabel.addCSSClass("title-3")

        let clickResult = Label("")
        clickResult.addCSSClass("monospace")
        clickResult.addCSSClass("dim-label")

        let clickBox = Box(orientation: .vertical, spacing: 8)
        clickBox.append(clickLabel)
        clickBox.append(clickResult)
        clickBox.halign = .center
        clickBox.valign = .center
        clickBox.setMargins(24)
        clickBox.setSizeRequest(width: -1, height: 120)

        let click = GestureClick()
        click.onPressed { [clickLabel, clickResult] button, x, y in
            clickLabel.text = "Button \(button) pressed!"
            clickResult.text = "at (\(Int(x)), \(Int(y)))"
        }
        click.onReleased { [clickLabel] _, _, _ in
            clickLabel.text = "Released"
        }
        clickBox.addController(click)

        group3.add(clickBox)
        box.append(group3)

        // Drag
        let group4 = PreferencesGroup()
        group4.title = "Drag"
        group4.description = "Press and drag the area below; the offset is reported"

        let dragLabel = Label("Drag here")
        dragLabel.addCSSClass("title-3")

        let dragResult = Label("")
        dragResult.addCSSClass("monospace")
        dragResult.addCSSClass("dim-label")

        let dragBox = Box(orientation: .vertical, spacing: 8)
        dragBox.append(dragLabel)
        dragBox.append(dragResult)
        dragBox.halign = .center
        dragBox.valign = .center
        dragBox.setMargins(24)
        dragBox.setSizeRequest(width: -1, height: 120)

        let drag = GestureDrag()
        drag.onDragBegin { [dragResult] dx, dy in
            dragResult.text = "Began at (\(Int(dx)), \(Int(dy)))"
        }
        drag.onDragUpdate { [dragResult] dx, dy in
            dragResult.text = "Offset: (\(Int(dx)), \(Int(dy)))"
        }
        drag.onDragEnd { [dragResult, dragLabel] dx, dy in
            dragResult.text = "Ended at (\(Int(dx)), \(Int(dy)))"
            dragLabel.text = "Dragged"
        }
        dragBox.addController(drag)

        group4.add(dragBox)
        box.append(group4)

        return box.scrollableClamped()
    }
}
