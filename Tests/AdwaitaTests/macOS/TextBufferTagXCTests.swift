#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class TextBufferTagXCTests: XCTestCase {

    // MARK: - TextBuffer: deep coverage

    @MainActor func test_textBufferDeleteSelection() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello World"
        buffer.selectAll()
        XCTAssertTrue(buffer.hasSelection == true)
        buffer.deleteSelection()
        XCTAssertTrue(buffer.text == "")
        XCTAssertTrue(buffer.charCount == 0)
    }

    @MainActor func test_textBufferDeleteSelectionWhenNone() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Keep me"
        buffer.deleteSelection()
        XCTAssertTrue(buffer.text == "Keep me")
    }

    @MainActor func test_textBufferInsertAtCursorMultiple() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.insertAtCursor("One")
        buffer.insertAtCursor(" Two")
        buffer.insertAtCursor(" Three")
        XCTAssertTrue(buffer.text == "One Two Three")
        XCTAssertTrue(buffer.charCount == 13)
    }

    @MainActor func test_textBufferLineCountMultiline() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "A\nB\nC\nD\nE"
        XCTAssertTrue(buffer.lineCount == 5)
    }

    @MainActor func test_textBufferLineCountEmpty() {
        ensureAdwInit()
        let buffer = TextBuffer()
        XCTAssertTrue(buffer.lineCount == 1)
    }

    @MainActor func test_textBufferSelectedTextNoSelection() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello"
        XCTAssertTrue(buffer.selectedText == "")
    }

    @MainActor func test_textBufferPlaceCursorInsertMiddle() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "AE"
        buffer.insert("BCD", at: 1)
        XCTAssertTrue(buffer.text == "ABCDE")
    }

    @MainActor func test_textBufferSelectRange() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello World"
        buffer.select(range: 0 ..< 5)
        XCTAssertTrue(buffer.hasSelection == true)
        XCTAssertTrue(buffer.selectedText == "Hello")
    }

    @MainActor func test_textBufferSelectedRangeWithSelection() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello World"
        buffer.select(range: 6 ..< 11)
        let range = buffer.selectedRange
        XCTAssertTrue(range == 6 ..< 11)
    }

    @MainActor func test_textBufferSelectedRangeNoSelection() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello"
        buffer.placeCursor(at: 3)
        let range = buffer.selectedRange
        XCTAssertTrue(range.lowerBound == 3)
        XCTAssertTrue(range.upperBound == 3)
    }

    @MainActor func test_textBufferDeleteRange() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "ABCDEFG"
        buffer.delete(range: 2 ..< 5)
        XCTAssertTrue(buffer.text == "ABFG")
    }

    @MainActor func test_textBufferPlaceCursorAtOffset() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "ABCDE"
        buffer.placeCursor(at: 2)
        buffer.insertAtCursor("X")
        XCTAssertTrue(buffer.text == "ABXCDE")
    }

    @MainActor func test_textBufferModifiedResetAndSet() {
        ensureAdwInit()
        let buffer = TextBuffer()
        XCTAssertTrue(buffer.modified == false)
        buffer.modified = true
        XCTAssertTrue(buffer.modified == true)
        buffer.modified = false
        XCTAssertTrue(buffer.modified == false)
        buffer.text = "Something"
        XCTAssertTrue(buffer.modified == true)
    }

    @MainActor func test_textBufferOnModifiedChangedSignal() {
        ensureAdwInit()
        let buffer = TextBuffer()
        var modifiedChanged = false
        buffer.onModifiedChanged { modifiedChanged = true }
        buffer.modified = true
        XCTAssertTrue(modifiedChanged == true)
    }

    @MainActor func test_textBufferTextInRangePartial() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "ABCDEFGHIJ"
        XCTAssertTrue(buffer.text(in: 3 ..< 7) == "DEFG")
        XCTAssertTrue(buffer.text(in: 0 ..< 1) == "A")
        XCTAssertTrue(buffer.text(in: 9 ..< 10) == "J")
    }

    @MainActor func test_textBufferCreateTagAndApply() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello World"
        let tag = buffer.createTag(name: "highlight")
        tag.weight = 700
        buffer.applyTag(tag, startOffset: 0, endOffset: 5)
        XCTAssertTrue(buffer.text == "Hello World")
    }

    @MainActor func test_textBufferApplyTagRangeAPI() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello World"
        let tag = buffer.createTag(name: "bold-range")
        tag.weight = 700
        buffer.applyTag(tag, in: 0 ..< 5)
        XCTAssertTrue(buffer.charCount == 11)
    }

    @MainActor func test_textBufferRemoveTagRangeAPI() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Test text"
        let tag = buffer.createTag(name: "remove-range")
        buffer.applyTag(tag, in: 0 ..< 4)
        buffer.removeTag(tag, in: 0 ..< 4)
        XCTAssertTrue(buffer.text == "Test text")
    }

    @MainActor func test_textBufferEnableUndo() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.enableUndo = true
        XCTAssertTrue(buffer.enableUndo == true)
        buffer.enableUndo = false
        XCTAssertTrue(buffer.enableUndo == false)
    }

    @MainActor func test_textBufferUserActionBrackets() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.enableUndo = true
        buffer.beginUserAction()
        buffer.insertAtCursor("Hello")
        buffer.insertAtCursor(" World")
        buffer.endUserAction()
        XCTAssertTrue(buffer.text == "Hello World")
        buffer.undo()
        XCTAssertTrue(buffer.text == "")
    }

    @MainActor func test_textBufferOnChangedDisconnect() {
        ensureAdwInit()
        let buffer = TextBuffer()
        var count = 0
        let conn = buffer.onChanged { count += 1 }
        buffer.text = "first"
        let firstCount = count
        conn.disconnect()
        buffer.text = "second"
        XCTAssertTrue(count == firstCount, "onChanged should not fire after disconnect")
    }

    // MARK: - TextTag: deep coverage

    @MainActor func test_textTagNamedCreation() {
        ensureAdwInit()
        let tag = TextTag(name: "custom-tag")
        tag.weight = 400
        XCTAssertTrue(tag.weight == 400)
    }

    @MainActor func test_textTagAnonymousCreation() {
        ensureAdwInit()
        let tag = TextTag()
        tag.weight = 700
        XCTAssertTrue(tag.weight == 700)
    }

    @MainActor func test_textTagSizeInPangoUnits() {
        ensureAdwInit()
        let tag = TextTag()
        tag.size = 16 * 1024
        XCTAssertTrue(tag.size == 16 * 1024)
    }

    @MainActor func test_textTagBoldPresetCustomName() {
        ensureAdwInit()
        let tag = TextTag.bold(name: "my-bold")
        XCTAssertTrue(tag.weight == 700)
    }

    @MainActor func test_textTagItalicPresetCustomName() {
        ensureAdwInit()
        let tag = TextTag.italic(name: "my-italic")
        XCTAssertTrue(tag.style == .italic)
    }

    @MainActor func test_textTagMultipleProperties() {
        ensureAdwInit()
        let tag = TextTag(name: "multi")
        tag.weight = 700
        tag.style = .italic
        tag.strikethrough = true
        tag.underline = .double
        tag.scale = 1.2
        tag.sizePoints = 16.0
        tag.foreground = "#ff0000"
        tag.background = "#0000ff"
        tag.family = "serif"
        XCTAssertTrue(tag.weight == 700)
        XCTAssertTrue(tag.style == .italic)
        XCTAssertTrue(tag.strikethrough == true)
        XCTAssertTrue(tag.underline == .double)
        XCTAssertTrue(abs(tag.scale - 1.2) < 0.01)
        XCTAssertTrue(abs(tag.sizePoints - 16.0) < 0.01)
    }
}
#endif
