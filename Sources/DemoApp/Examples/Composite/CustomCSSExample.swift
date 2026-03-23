import Adwaita

@MainActor
struct CustomCSSExample: DemoExample {
    let name = "Custom CSS"
    let id = "customcss"
    let category: ExampleCategory = .composite

    let sourceCode = """
    // Create and load a CSS provider
    let provider = CSSProvider()
    provider.loadFromString(\"""
    .neon-green {
        color: #39ff14;
        font-weight: bold;
        font-size: 18px;
    }
    .rounded-border {
        border: 2px solid @accent_color;
        border-radius: 16px;
        padding: 12px 20px;
    }
    .gradient-bg {
        background: linear-gradient(
            135deg, #6366f1, #a855f7, #ec4899);
        color: white;
        border-radius: 12px;
        padding: 16px;
    }
    \""")
    provider.addToDefaultDisplay()

    // Apply classes to widgets
    let label = Label("Neon Text")
    label.addCSSClass("neon-green")

    // Or use the one-liner
    CSSProvider.loadGlobal(".big { font-size: 32px; }")

    // CSS names identify widget types
    print(label.cssName)   // "label"
    print(button.cssName)  // "button"
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        // Load custom CSS for this example
        let provider = CSSProvider()
        provider.loadFromString("""
        .demo-neon {
            color: #39ff14;
            font-weight: bold;
            font-size: 20px;
            text-shadow: 0 0 8px rgba(57, 255, 20, 0.5);
        }
        .demo-rounded-accent {
            border: 2px solid @accent_color;
            border-radius: 16px;
            padding: 12px 20px;
        }
        .demo-gradient-card {
            background: linear-gradient(135deg, #6366f1, #a855f7, #ec4899);
            color: white;
            border-radius: 12px;
            padding: 20px;
        }
        .demo-dashed {
            border: 2px dashed @warning_color;
            border-radius: 8px;
            padding: 12px 16px;
        }
        .demo-large-text {
            font-size: 28px;
            font-weight: 900;
        }
        """)
        provider.addToDefaultDisplay()

        // Section 1: Text Styling
        let group1 = PreferencesGroup()
        group1.title = "Text Styling"
        group1.description = "Custom colors, sizes, and effects via CSS classes"

        let neonLabel = Label("Neon Green Text")
        neonLabel.addCSSClass("demo-neon")
        neonLabel.halign = .center
        neonLabel.setMargins(12)
        group1.add(neonLabel)

        let largeLabel = Label("Extra Bold")
        largeLabel.addCSSClass("demo-large-text")
        largeLabel.halign = .center
        largeLabel.setMargins(8)
        group1.add(largeLabel)

        box.append(group1)

        // Section 2: Borders
        let group2 = PreferencesGroup()
        group2.title = "Border Styling"
        group2.description = "Solid and dashed borders with rounded corners"

        let accentLabel = Label("Accent Border (rounded)")
        accentLabel.addCSSClass("demo-rounded-accent")
        accentLabel.halign = .center
        accentLabel.setMargins(12)
        group2.add(accentLabel)

        let dashedLabel = Label("Dashed Warning Border")
        dashedLabel.addCSSClass("demo-dashed")
        dashedLabel.halign = .center
        dashedLabel.setMargins(12)
        group2.add(dashedLabel)

        box.append(group2)

        // Section 3: Backgrounds
        let group3 = PreferencesGroup()
        group3.title = "Background Gradients"
        group3.description = "CSS gradients applied as backgrounds"

        let gradientBox = Box(orientation: .vertical, spacing: 8)
        gradientBox.addCSSClass("demo-gradient-card")

        let gradTitle = Label("Gradient Background")
        gradTitle.addCSSClass("title-2")

        let gradSub = Label("linear-gradient(135deg, #6366f1, #a855f7, #ec4899)")
        gradientBox.append(gradTitle)
        gradientBox.append(gradSub)

        group3.add(gradientBox)
        box.append(group3)

        // Section 4: CSS Names
        let group4 = PreferencesGroup()
        group4.title = "CSS Names"
        group4.description = "Every widget has a CSS name used for type-based style matching"

        let sampleWidgets: [(String, Widget)] = [
            ("Label", Label("sample")),
            ("Button", Button(label: "sample")),
            ("Box", Box(orientation: .horizontal, spacing: 0)),
            ("ProgressBar", ProgressBar()),
            ("LevelBar", LevelBar()),
        ]

        for (displayName, widget) in sampleWidgets {
            let row = ActionRow()
            row.title = displayName
            row.subtitle = "CSS name: \(widget.cssName)"
            let badge = Label(widget.cssName)
            badge.addCSSClass("monospace")
            badge.addCSSClass("dim-label")
            badge.valign = .center
            row.addSuffix(badge)
            group4.add(row)
        }

        box.append(group4)

        return box.scrollableClamped()
    }
}
