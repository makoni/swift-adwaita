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

        return box.scrollableClamped()
    }
}
