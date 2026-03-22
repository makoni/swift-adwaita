import Adwaita

@MainActor
struct AnimationExample: DemoExample {
    let name = "Animation"
    let id = "animation"
    let category: ExampleCategory = .composite

    let sourceCode = """
    let target = CallbackAnimationTarget { value in
        label.opacity = value
    }
    let anim = TimedAnimation(
        widget: label,
        from: 0.0, to: 1.0,
        duration: 1000,
        target: target
    )
    anim.easing = .easeInOutCubic
    anim.play()

    // Spring animation
    let springTarget = CallbackAnimationTarget { value in
        widget.marginStart = Int(value)
    }
    let springParams = SpringParams(damping: 0.7, mass: 1.0, stiffness: 100)
    let spring = SpringAnimation(
        widget: widget,
        from: 0, to: 200,
        springParams: springParams,
        target: springTarget
    )
    spring.play()
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 16)
        box.halign = .center
        box.valign = .center
        box.setMargins(24)

        let title = Label("Animations")
        title.addCSSClass("title-3")
        box.append(title)

        // Fade animation
        let fadeLabel = Label("Fade In / Out")
        fadeLabel.addCSSClass("title-1")
        box.append(fadeLabel)

        let fadeBtn = Button(label: "Fade")
        fadeBtn.addCSSClass("pill")
        fadeBtn.halign = .center
        fadeBtn.onClicked { [fadeLabel] in
            let target = CallbackAnimationTarget { value in
                fadeLabel.opacity = value
            }
            let anim = TimedAnimation(
                widget: fadeLabel,
                from: fadeLabel.opacity,
                to: fadeLabel.opacity < 0.5 ? 1.0 : 0.0,
                duration: 500,
                target: target
            )
            anim.easing = .easeInOutCubic
            anim.play()
        }
        box.append(fadeBtn)

        // Move animation with spring
        let moveBox = Box(orientation: .horizontal, spacing: 0)
        moveBox.setSizeRequest(width: 400, height: 50)
        let moveLabel = Label("  ●  ")
        moveLabel.addCSSClass("title-1")
        moveLabel.addCSSClass("accent")
        moveBox.append(moveLabel)
        box.append(moveBox)

        let springBtn = Button(label: "Spring Bounce")
        springBtn.addCSSClass("pill")
        springBtn.halign = .center
        springBtn.onClicked { [moveLabel] in
            let springTarget = CallbackAnimationTarget { value in
                moveLabel.marginStart = Int(value)
            }
            let spring = SpringAnimation(
                widget: moveLabel,
                from: 0, to: 300,
                springParams: SpringParams(dampingRatio: 0.6, mass: 1.0, stiffness: 80.0),
                target: springTarget
            )
            spring.play()
        }
        box.append(springBtn)

        let caption = Label("AdwTimedAnimation and AdwSpringAnimation")
        caption.addCSSClass("dim-label")
        box.append(caption)

        let clamp = Clamp()
        clamp.maximumSize = 500
        clamp.child = box
        return clamp
    }
}
