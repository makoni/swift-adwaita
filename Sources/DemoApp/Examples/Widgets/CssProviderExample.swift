import Adwaita
import CAdwaita

@MainActor
struct CssProviderExample: DemoExample {
    let name = "CSS Provider"
    let id = "cssprovider"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    // Load CSS globally
    CSSProvider.loadGlobal(\"""
    .custom-red { color: @error_color; }
    .custom-big { font-size: 24px; }
    .custom-rounded {
        border-radius: 16px;
        padding: 12px 24px;
    }
    \""")

    // Apply classes to widgets
    label.addCSSClass("custom-red")
    label.addCSSClass("custom-big")

    // Or use a provider instance
    let provider = CSSProvider()
    provider.loadFromString(css)
    provider.addToDefaultDisplay()
    // Later: provider.removeFromDefaultDisplay()
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        // Load custom CSS
        let provider = CSSProvider()
        provider.loadFromString("""
        .demo-gradient {
            background: linear-gradient(135deg, @accent_bg_color, @headerbar_bg_color);
            color: @accent_fg_color;
            border-radius: 12px;
            padding: 24px;
        }
        .demo-shadow {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
            border-radius: 8px;
            padding: 16px;
        }
        .demo-pulsing {
            font-size: 20px;
            font-weight: bold;
        }
        .demo-bordered {
            border: 2px solid @accent_color;
            border-radius: 24px;
            padding: 12px 24px;
        }
        """)
        provider.addToDefaultDisplay()

        // Gradient box
        let group1 = PreferencesGroup()
        group1.title = "Gradient Background"
        group1.description = "Custom CSS gradient using theme accent colors"

        let gradientBox = Box(orientation: .vertical, spacing: 8)
        gradientBox.addCSSClass("demo-gradient")

        let gradientLabel = Label("Gradient Background")
        gradientLabel.addCSSClass("title-2")
        gradientBox.append(gradientLabel)

        let gradientSub = Label("Using @accent_bg_color and @headerbar_bg_color")
        gradientBox.append(gradientSub)

        group1.add(gradientBox)
        box.append(group1)

        // Shadow box
        let group2 = PreferencesGroup()
        group2.title = "Box Shadow"
        group2.description = "CSS box-shadow for depth effect"

        let shadowBox = Box(orientation: .vertical, spacing: 4)
        shadowBox.addCSSClass("demo-shadow")
        shadowBox.addCSSClass("card")
        shadowBox.halign = .center
        shadowBox.setMargins(16)

        let shadowLabel = Label("Elevated Card")
        shadowLabel.addCSSClass("title-3")
        shadowBox.append(shadowLabel)

        let shadowSub = Label("box-shadow: 0 4px 12px rgba(0,0,0,0.3)")
        shadowSub.addCSSClass("dim-label")
        shadowSub.addCSSClass("caption")
        shadowBox.append(shadowSub)

        group2.add(shadowBox)
        box.append(group2)

        // Bordered pill
        let group3 = PreferencesGroup()
        group3.title = "Custom Border"
        group3.description = "Accent-colored border with large radius"

        let borderedLabel = Label("Styled Pill Label")
        borderedLabel.addCSSClass("demo-bordered")
        borderedLabel.addCSSClass("demo-pulsing")
        borderedLabel.halign = .center
        borderedLabel.setMargins(12)

        group3.add(borderedLabel)
        box.append(group3)

        // Global CSS example
        let group4 = PreferencesGroup()
        group4.title = "Global CSS"
        group4.description = "CSSProvider.loadGlobal() applies styles to all widgets instantly"

        let row = ActionRow()
        row.title = "loadGlobal()"
        row.subtitle = "One-liner to add CSS app-wide"
        let checkIcon = Image(iconName: "emblem-ok-symbolic")
        checkIcon.valign = .center
        checkIcon.addCSSClass("success")
        row.addSuffix(checkIcon)
        group4.add(row)

        box.append(group4)

        return box.scrollableClamped()
    }
}
