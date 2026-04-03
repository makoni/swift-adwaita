#if swift(>=6.3)
import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct SourceViewTests {

    @Test @MainActor func sourceLanguageManagerProvidesMarkdown() {
        ensureAdwInit()
        let manager = SourceLanguageManager.default
        #expect(!manager.languageIDs.isEmpty)
        #expect(manager.languages.contains(.markdown))
        let markdown = manager.language(id: .markdown)
        #expect(markdown != nil)
        #expect(markdown?.id == SourceLanguageID.markdown.rawValue)
        #expect(markdown?.identifier == .markdown)
    }

    @Test @MainActor func sourceLanguageIDSupportsTypedAndCustomValues() {
        ensureAdwInit()
        let typed = SourceLanguageID.markdown
        let custom: SourceLanguageID = "custom-language"

        #expect(typed.rawValue == "markdown")
        #expect(custom.rawValue == "custom-language")
    }

    @Test @MainActor func sourceStyleSchemeManagerProvidesSchemes() {
        ensureAdwInit()
        let manager = SourceStyleSchemeManager.default
        #expect(!manager.schemeIDs.isEmpty)
        #expect(manager.preferredSchemeID(dark: false) != nil)
        #expect(manager.preferredScheme(dark: false) != nil)
    }

    @Test @MainActor func sourceStyleSchemeIDSupportsTypedAndCustomValues() {
        ensureAdwInit()
        let typed = SourceStyleSchemeID.adwaita
        let custom: SourceStyleSchemeID = "CustomScheme"

        #expect(typed.rawValue == "Adwaita")
        #expect(custom.rawValue == "CustomScheme")
    }

    @Test @MainActor func preferredSourceStyleSchemeSelectionPrefersKnownPairs() {
        let schemes: [SourceStyleSchemeID] = [.adwaita, .adwaitaDark, .yaru, .yaruDark]
        #expect(SourceStyleSchemeManager.preferredSchemeID(available: schemes, dark: false) == .yaru)
        #expect(SourceStyleSchemeManager.preferredSchemeID(available: schemes, dark: true) == .yaruDark)
    }

    @Test @MainActor func preferredSourceStyleSchemeSelectionFallsBackByDarkness() {
        let schemes: [SourceStyleSchemeID] = ["Custom", "Custom-dark"]
        #expect(SourceStyleSchemeManager.preferredSchemeID(available: schemes, dark: false) == "Custom")
        #expect(SourceStyleSchemeManager.preferredSchemeID(available: schemes, dark: true) == "Custom-dark")
    }

    @Test @MainActor func sourceBufferProperties() {
        ensureAdwInit()
        let markdown = SourceLanguageManager.default.language(id: .markdown)
        #expect(markdown != nil)

        let buffer = markdown.map(SourceBuffer.init(language:)) ?? SourceBuffer()
        buffer.text = "# Hello\n\n`code`"
        buffer.highlightSyntax = true
        buffer.highlightMatchingBrackets = true
        buffer.enableUndo = true

        #expect(buffer.text == "# Hello\n\n`code`")
        #expect(buffer.highlightSyntax)
        #expect(buffer.highlightMatchingBrackets)
        #expect(buffer.enableUndo)
        #expect(buffer.language?.id == markdown?.id)
        #expect(buffer.lineCount == 3)
        #expect(buffer.charCount > 0)

        if let scheme = SourceStyleSchemeManager.default.preferredScheme(dark: false) {
            buffer.styleScheme = scheme
            #expect(buffer.styleScheme?.identifier != nil)
        }
    }

    @Test @MainActor func sourceViewProperties() {
        ensureAdwInit()
        let buffer = SourceBuffer()
        let view = SourceView(buffer: buffer)

        view.showLineNumbers = true
        view.highlightCurrentLine = true
        view.autoIndent = true
        view.insertSpacesInsteadOfTabs = true
        view.showRightMargin = true
        view.rightMarginPosition = 88
        view.tabWidth = 4
        view.monospace = true
        view.wrapMode = .wordChar

        #expect(view.buffer.pointer == buffer.pointer)
        #expect(view.showLineNumbers)
        #expect(view.highlightCurrentLine)
        #expect(view.autoIndent)
        #expect(view.insertSpacesInsteadOfTabs)
        #expect(view.showRightMargin)
        #expect(view.rightMarginPosition == 88)
        #expect(view.tabWidth == 4)
        #expect(view.monospace)
        #expect(view.wrapMode == .wordChar)
    }

    @Test @MainActor func sourceViewChangedSignalFollowsBuffer() {
        ensureAdwInit()
        let buffer = SourceBuffer()
        let view = SourceView(buffer: buffer)
        var changed = false

        view.onChanged {
            changed = true
        }

        view.text = "changed"
        #expect(changed)
    }
}
#endif
