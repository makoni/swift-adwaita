import Adwaita

@MainActor
struct SourceViewExample: DemoExample {
    let name = "Source View"
    let id = "sourceview"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let manager = SourceLanguageManager.default
    let markdown = manager.language(id: .markdown)
    let buffer = markdown.map(SourceBuffer.init(language:)) ?? SourceBuffer()
    buffer.highlightSyntax = true

    let view = SourceView(buffer: buffer)
    view.showLineNumbers = true
    view.highlightCurrentLine = true
    view.autoIndent = true
    """

    func buildWidget() -> Widget {
        let buffer = if let markdown = SourceLanguageManager.default.language(id: .markdown) {
            SourceBuffer(language: markdown)
        } else {
            SourceBuffer()
        }

        buffer.text = """
        # Markdown Example

        - Live syntax highlighting
        - Line numbers
        - Right margin guide

        ```swift
        print("Hello from GtkSourceView")
        ```
        """
        buffer.highlightSyntax = true
        buffer.highlightMatchingBrackets = true
        buffer.enableUndo = true
        if let scheme = SourceStyleSchemeManager.default.scheme(id: .adwaita) {
            buffer.styleScheme = scheme
        }

        let view = SourceView(buffer: buffer)
        view.showLineNumbers = true
        view.highlightCurrentLine = true
        view.autoIndent = true
        view.insertSpacesInsteadOfTabs = true
        view.showRightMargin = true
        view.rightMarginPosition = 80
        view.tabWidth = 4
        view.wrapMode = .wordChar
        view.leftMargin = 8
        view.rightMargin = 8
        view.topMargin = 8
        view.bottomMargin = 8

        let scrolled = ScrolledWindow(child: view)
        scrolled.minContentHeight = 300

        let frame = Frame()
        frame.child = scrolled

        let outer = Box(orientation: .vertical, spacing: 12)
        outer.setMargins(24)
        outer.append(Label("GtkSourceView-backed editor").cssClass(.title3))
        outer.append(frame)

        return outer.scrollableClamped()
    }
}
