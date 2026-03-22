import Adwaita
import CAdwaita

@MainActor
struct SpringAnimationExample: DemoExample {
    let name = "Spring Animation"
    let id = "spring-anim"
    let category: ExampleCategory = .composite

    let sourceCode = """
    let params = SpringParams(dampingRatio: 0.5,
                              mass: 1.0, stiffness: 100)
    let target = CallbackAnimationTarget { value in
        widget.marginTop = Int(value)
    }
    let anim = SpringAnimation(
        widget: widget, from: 0, to: 100,
        springParams: params, target: target)
    anim.play()
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        // Animated ball
        let ball = Box(orientation: .horizontal, spacing: 0)
        ball.addCSSClass("card")
        ball.setSizeRequest(width: 48, height: 48)
        ball.halign = .center

        let animBox = Box(orientation: .vertical, spacing: 0)
        animBox.setSizeRequest(width: -1, height: 200)
        animBox.append(ball)

        let group1 = PreferencesGroup()
        group1.title = "Spring Animation"
        group1.description = "A bouncy spring-based animation"
        group1.add(animBox)
        box.append(group1)

        // Controls
        let group2 = PreferencesGroup()
        group2.title = "Parameters"

        let dampingScale = Scale(orientation: .horizontal, min: 0.1, max: 2.0, step: 0.1)
        dampingScale.value = 0.5
        dampingScale.drawValue = true
        dampingScale.digits = 1
        dampingScale.hexpand = true

        let dampingRow = ActionRow()
        dampingRow.title = "Damping Ratio"
        dampingRow.subtitle = "< 1 = bouncy, 1 = critical, > 1 = overdamped"
        dampingRow.addSuffix(dampingScale)
        group2.add(dampingRow)

        let stiffnessScale = Scale(orientation: .horizontal, min: 10, max: 500, step: 10)
        stiffnessScale.value = 100
        stiffnessScale.drawValue = true
        stiffnessScale.digits = 0
        stiffnessScale.hexpand = true

        let stiffnessRow = ActionRow()
        stiffnessRow.title = "Stiffness"
        stiffnessRow.addSuffix(stiffnessScale)
        group2.add(stiffnessRow)

        box.append(group2)

        // Play button
        let playBtn = Button(label: "Play Animation")
        playBtn.addCSSClass("suggested-action")
        playBtn.addCSSClass("pill")
        playBtn.halign = .center

        playBtn.onClicked { [ball, dampingScale, stiffnessScale] in
            let params = SpringParams(
                dampingRatio: dampingScale.value,
                mass: 1.0,
                stiffness: stiffnessScale.value
            )
            let target = CallbackAnimationTarget { [ball] value in
                ball.marginTop = Int(value)
            }
            let anim = SpringAnimation(
                widget: ball,
                from: 0, to: 120,
                springParams: params,
                target: target
            )
            anim.play()
        }

        box.append(playBtn)

        let clamp = Clamp()
        clamp.maximumSize = 600
        clamp.child = box

        let scrolled = ScrolledWindow()
        scrolled.child = clamp
        return scrolled
    }
}
