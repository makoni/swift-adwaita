// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class SourceViewXCTests: XCTestCase {

    @MainActor func test_sourceLanguageManagerProvidesMarkdown() {
        ensureAdwInit()
        let manager = SourceLanguageManager.default
        XCTAssertFalse(manager.languageIDs.isEmpty)
        XCTAssertTrue(manager.languages.contains(.markdown))
        let markdown = manager.language(id: .markdown)
        XCTAssertNotNil(markdown)
        XCTAssertTrue(markdown?.id == SourceLanguageID.markdown.rawValue)
        XCTAssertTrue(markdown?.identifier == .markdown)
    }

    @MainActor func test_sourceLanguageIDSupportsTypedAndCustomValues() {
        ensureAdwInit()
        let typed = SourceLanguageID.markdown
        let custom: SourceLanguageID = "custom-language"

        XCTAssertTrue(typed.rawValue == "markdown")
        XCTAssertTrue(custom.rawValue == "custom-language")
    }

    @MainActor func test_sourceStyleSchemeManagerProvidesSchemes() {
        ensureAdwInit()
        let manager = SourceStyleSchemeManager.default
        XCTAssertFalse(manager.schemeIDs.isEmpty)
        XCTAssertNotNil(manager.preferredSchemeID(dark: false))
        XCTAssertNotNil(manager.preferredScheme(dark: false))
    }

    @MainActor func test_sourceStyleSchemeIDSupportsTypedAndCustomValues() {
        ensureAdwInit()
        let typed = SourceStyleSchemeID.adwaita
        let custom: SourceStyleSchemeID = "CustomScheme"

        XCTAssertTrue(typed.rawValue == "Adwaita")
        XCTAssertTrue(custom.rawValue == "CustomScheme")
    }

    @MainActor func test_preferredSourceStyleSchemeSelectionPrefersKnownPairs() {
        let schemes: [SourceStyleSchemeID] = [.adwaita, .adwaitaDark, .yaru, .yaruDark]
        XCTAssertTrue(SourceStyleSchemeManager.preferredSchemeID(available: schemes, dark: false) == .yaru)
        XCTAssertTrue(SourceStyleSchemeManager.preferredSchemeID(available: schemes, dark: true) == .yaruDark)
    }

    @MainActor func test_preferredSourceStyleSchemeSelectionFallsBackByDarkness() {
        let schemes: [SourceStyleSchemeID] = ["Custom", "Custom-dark"]
        XCTAssertTrue(SourceStyleSchemeManager.preferredSchemeID(available: schemes, dark: false) == "Custom")
        XCTAssertTrue(SourceStyleSchemeManager.preferredSchemeID(available: schemes, dark: true) == "Custom-dark")
    }

    @MainActor func test_sourceBufferProperties() {
        ensureAdwInit()
        let markdown = SourceLanguageManager.default.language(id: .markdown)
        XCTAssertNotNil(markdown)

        let buffer = markdown.map(SourceBuffer.init(language:)) ?? SourceBuffer()
        buffer.text = "# Hello\n\n`code`"
        buffer.highlightSyntax = true
        buffer.highlightMatchingBrackets = true
        buffer.enableUndo = true

        XCTAssertTrue(buffer.text == "# Hello\n\n`code`")
        XCTAssertTrue(buffer.highlightSyntax)
        XCTAssertTrue(buffer.highlightMatchingBrackets)
        XCTAssertTrue(buffer.enableUndo)
        XCTAssertTrue(buffer.language?.id == markdown?.id)
        XCTAssertTrue(buffer.lineCount == 3)
        XCTAssertTrue(buffer.charCount > 0)

        if let scheme = SourceStyleSchemeManager.default.preferredScheme(dark: false) {
            buffer.styleScheme = scheme
            XCTAssertNotNil(buffer.styleScheme?.identifier)
        }
    }

    @MainActor func test_sourceBufferRangeAPIs() {
        ensureAdwInit()
        let buffer = SourceBuffer()
        buffer.text = "Hello World"

        buffer.select(range: 0 ..< 5)
        XCTAssertTrue(buffer.selectedRange == 0 ..< 5)

        buffer.placeCursor(at: 6)
        XCTAssertTrue(buffer.selectedRange == 6 ..< 6)

        buffer.delete(range: 0 ..< 6)
        XCTAssertTrue(buffer.text == "World")

        buffer.insert("!", at: 5)
        XCTAssertTrue(buffer.text == "World!")
    }

    @MainActor func test_sourceBufferUserAction() {
        ensureAdwInit()
        let buffer = SourceBuffer()
        buffer.enableUndo = true
        buffer.beginUserAction()
        buffer.insertAtCursor("Hello")
        buffer.insertAtCursor(" World")
        buffer.endUserAction()
        XCTAssertTrue(buffer.text == "Hello World")
        buffer.undo()
        XCTAssertTrue(buffer.text == "")
    }

    @MainActor func test_sourceViewProperties() {
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

        XCTAssertTrue(view.buffer.pointer == buffer.pointer)
        XCTAssertTrue(view.showLineNumbers)
        XCTAssertTrue(view.highlightCurrentLine)
        XCTAssertTrue(view.autoIndent)
        XCTAssertTrue(view.insertSpacesInsteadOfTabs)
        XCTAssertTrue(view.showRightMargin)
        XCTAssertTrue(view.rightMarginPosition == 88)
        XCTAssertTrue(view.tabWidth == 4)
        XCTAssertTrue(view.monospace)
        XCTAssertTrue(view.wrapMode == .wordChar)
    }

    @MainActor func test_sourceViewChangedSignalFollowsBuffer() {
        ensureAdwInit()
        let buffer = SourceBuffer()
        let view = SourceView(buffer: buffer)
        var changed = false

        view.onChanged {
            changed = true
        }

        view.text = "changed"
        XCTAssertTrue(changed)
    }
}
#endif
