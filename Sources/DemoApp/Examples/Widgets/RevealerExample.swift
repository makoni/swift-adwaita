import Adwaita
import CAdwaita

@MainActor
struct RevealerExample: DemoExample {
    let name = "Revealer"
    let id = "revealer"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let revealer = Revealer()
    revealer.transitionType = GTK_REVEALER_TRANSITION_TYPE_SLIDE_DOWN
    revealer.transitionDuration = 300
    revealer.revealChild = true

    let content = Label("This content can be revealed or hidden")
    content.setMargins(12)
    revealer.child = content

    let toggleBtn = Button(label: "Toggle")
    toggleBtn.onClicked {
        revealer.revealChild = !revealer.revealChild
    }
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 24)
        box.setMargins(24)

        // Slide down revealer
        let group1 = PreferencesGroup()
        group1.title = "Slide Down"

        let revealerDown = Revealer()
        revealerDown.transitionType = GTK_REVEALER_TRANSITION_TYPE_SLIDE_DOWN
        revealerDown.transitionDuration = 300
        revealerDown.revealChild = true

        let contentDown = Label("This content slides down to appear and up to disappear. Try toggling it with the button below!")
        contentDown.wrap = true
        contentDown.xalign = 0
        contentDown.setMargins(12)
        contentDown.addCSSClass("card")
        contentDown.setMargins(12)
        revealerDown.child = contentDown
        group1.add(revealerDown)

        let rdRef = revealerDown
        let toggleDown = Button(label: "Toggle Slide Down")
        toggleDown.halign = GTK_ALIGN_CENTER
        toggleDown.addCSSClass("pill")
        toggleDown.onClicked {
            rdRef.revealChild = !rdRef.revealChild
        }
        group1.add(toggleDown)
        box.append(group1)

        // Crossfade revealer
        let group2 = PreferencesGroup()
        group2.title = "Crossfade"

        let revealerFade = Revealer()
        revealerFade.transitionType = GTK_REVEALER_TRANSITION_TYPE_CROSSFADE
        revealerFade.transitionDuration = 500
        revealerFade.revealChild = true

        let contentFade = Label("This content fades in and out smoothly.")
        contentFade.wrap = true
        contentFade.xalign = 0
        contentFade.setMargins(12)
        revealerFade.child = contentFade
        group2.add(revealerFade)

        let rfRef = revealerFade
        let toggleFade = Button(label: "Toggle Crossfade")
        toggleFade.halign = GTK_ALIGN_CENTER
        toggleFade.addCSSClass("pill")
        toggleFade.onClicked {
            rfRef.revealChild = !rfRef.revealChild
        }
        group2.add(toggleFade)
        box.append(group2)

        // Slide left revealer
        let group3 = PreferencesGroup()
        group3.title = "Slide Left"

        let revealerLeft = Revealer()
        revealerLeft.transitionType = GTK_REVEALER_TRANSITION_TYPE_SLIDE_LEFT
        revealerLeft.transitionDuration = 300
        revealerLeft.revealChild = true

        let contentLeft = Label("Slides from the right!")
        contentLeft.setMargins(12)
        revealerLeft.child = contentLeft
        group3.add(revealerLeft)

        let rlRef = revealerLeft
        let toggleLeft = Button(label: "Toggle Slide Left")
        toggleLeft.halign = GTK_ALIGN_CENTER
        toggleLeft.addCSSClass("pill")
        toggleLeft.onClicked {
            rlRef.revealChild = !rlRef.revealChild
        }
        group3.add(toggleLeft)
        box.append(group3)

        let clamp = Clamp()
        clamp.maximumSize = 600
        clamp.child = box

        let scrolled = ScrolledWindow()
        scrolled.child = clamp
        return scrolled
    }
}
