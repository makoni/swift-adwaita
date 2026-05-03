import Adwaita

@MainActor
struct SourceViewExample: DemoExample {
    let name = "Source View"
    let id = "sourceview"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let markdownEditor = makeEditor(
        title: "Markdown",
        languageID: .markdown,
        text: "# Hello\\n\\n- Markdown highlighting",
        wrapMode: .wordChar
    )

    let swiftEditor = makeEditor(
        title: "Swift",
        languageID: .swift,
        text: "import Foundation\\n\\nprint(\\"Hello\\")",
        wrapMode: .none
    )
    """

    func buildWidget() -> Widget {
        let outer = Box(orientation: .vertical, spacing: 12)
        outer.setMargins(24)
        outer.append(Label("GtkSourceView-backed editors").cssClass(.title3))
        outer.append(Label("Markdown and Swift syntax highlighting using the same widget API.").cssClass(.dimLabel))
        outer.append(makeEditor(
            title: "Markdown",
            languageID: .markdown,
            text: """
            # Markdown Example

            - Live syntax highlighting
            - Line numbers
            - Right margin guide

            ```swift
            print("Hello from GtkSourceView")
            ```
            """,
            wrapMode: .wordChar
        ))
        outer.append(makeEditor(
            title: "Swift",
            languageID: .swift,
            text: """
            import Foundation

            struct Greeter {
                let name: String

                func message() -> String {
                    "Hello, \\(name)!"
                }
            }

            let greeter = Greeter(name: "GtkSourceView")
            print(greeter.message())
            """,
            wrapMode: .none,
            minContentHeight: 280
        ))

        return outer.scrollableClamped()
    }

    private func makeEditor(
        title: String,
        languageID: SourceLanguageID,
        text: String,
        wrapMode: GtkWrapMode,
        minContentHeight: Int = 220
    ) -> Widget {
        let styleManager = StyleManager.default
        let buffer = if let language = SourceLanguageManager.default.language(id: languageID) {
            SourceBuffer(language: language)
        } else {
            SourceBuffer()
        }

        func applyStyleScheme() {
            buffer.styleScheme = SourceStyleSchemeManager.default.preferredScheme(dark: styleManager.dark)
        }

        buffer.text = text
        buffer.highlightSyntax = true
        buffer.highlightMatchingBrackets = true
        buffer.enableUndo = true
        applyStyleScheme()

        let view = SourceView(buffer: buffer)
        view.showLineNumbers = true
        view.highlightCurrentLine = true
        view.autoIndent = true
        view.insertSpacesInsteadOfTabs = true
        view.showRightMargin = true
        view.rightMarginPosition = 80
        view.tabWidth = 4
        view.wrapMode = wrapMode
        view.leftMargin = 8
        view.rightMargin = 8
        view.topMargin = 8
        view.bottomMargin = 8
        view.monospace = true

        let scrolled = ScrolledWindow(child: view)
        scrolled.minContentHeight = minContentHeight

        let frame = Frame()
        frame.child = scrolled

        let section = Box(orientation: .vertical, spacing: 6)
        section.append(Label(title).cssClass(.heading))
        section.append(frame)
        let themeConnection = styleManager.onDarkChanged { applyStyleScheme() }
        section.onDestroy {
            themeConnection.disconnect()
        }
        return section
    }
}
