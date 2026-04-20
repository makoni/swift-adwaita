#if swift(>=6.3)
import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct TextBufferTagTests {

    // MARK: - TextBuffer: deep coverage

    @Test @MainActor func textBufferDeleteSelection() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello World"
        buffer.selectAll()
        #expect(buffer.hasSelection == true)
        buffer.deleteSelection()
        #expect(buffer.text == "")
        #expect(buffer.charCount == 0)
    }

    @Test @MainActor func textBufferDeleteSelectionWhenNone() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Keep me"
        buffer.deleteSelection()
        #expect(buffer.text == "Keep me")
    }

    @Test @MainActor func textBufferInsertAtCursorMultiple() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.insertAtCursor("One")
        buffer.insertAtCursor(" Two")
        buffer.insertAtCursor(" Three")
        #expect(buffer.text == "One Two Three")
        #expect(buffer.charCount == 13)
    }

    @Test @MainActor func textBufferLineCountMultiline() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "A\nB\nC\nD\nE"
        #expect(buffer.lineCount == 5)
    }

    @Test @MainActor func textBufferLineCountEmpty() {
        ensureAdwInit()
        let buffer = TextBuffer()
        #expect(buffer.lineCount == 1)
    }

    @Test @MainActor func textBufferSelectedTextNoSelection() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello"
        #expect(buffer.selectedText == "")
    }

    @Test @MainActor func textBufferPlaceCursorInsertMiddle() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "AE"
        buffer.insert("BCD", at: 1)
        #expect(buffer.text == "ABCDE")
    }

    @Test @MainActor func textBufferSelectRange() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello World"
        buffer.select(range: 0 ..< 5)
        #expect(buffer.hasSelection == true)
        #expect(buffer.selectedText == "Hello")
    }

    @Test @MainActor func textBufferSelectedRangeWithSelection() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello World"
        buffer.select(range: 6 ..< 11)
        let range = buffer.selectedRange
        #expect(range == 6 ..< 11)
    }

    @Test @MainActor func textBufferSelectedRangeNoSelection() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello"
        buffer.placeCursor(at: 3)
        let range = buffer.selectedRange
        #expect(range.lowerBound == 3)
        #expect(range.upperBound == 3)
    }

    @Test @MainActor func textBufferDeleteRange() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "ABCDEFG"
        buffer.delete(range: 2 ..< 5)
        #expect(buffer.text == "ABFG")
    }

    @Test @MainActor func textBufferPlaceCursorAtOffset() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "ABCDE"
        buffer.placeCursor(at: 2)
        buffer.insertAtCursor("X")
        #expect(buffer.text == "ABXCDE")
    }

    @Test @MainActor func textBufferModifiedResetAndSet() {
        ensureAdwInit()
        let buffer = TextBuffer()
        #expect(buffer.modified == false)
        buffer.modified = true
        #expect(buffer.modified == true)
        buffer.modified = false
        #expect(buffer.modified == false)
        buffer.text = "Something"
        #expect(buffer.modified == true)
    }

    @Test @MainActor func textBufferOnModifiedChangedSignal() {
        ensureAdwInit()
        let buffer = TextBuffer()
        var modifiedChanged = false
        buffer.onModifiedChanged { modifiedChanged = true }
        buffer.modified = true
        #expect(modifiedChanged == true)
    }

    @Test @MainActor func textBufferTextInRangePartial() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "ABCDEFGHIJ"
        #expect(buffer.text(in: 3 ..< 7) == "DEFG")
        #expect(buffer.text(in: 0 ..< 1) == "A")
        #expect(buffer.text(in: 9 ..< 10) == "J")
    }

    @Test @MainActor func textBufferCreateTagAndApply() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello World"
        let tag = buffer.createTag(name: "highlight")
        tag.weight = 700
        buffer.applyTag(tag, startOffset: 0, endOffset: 5)
        #expect(buffer.text == "Hello World")
    }

    @Test @MainActor func textBufferApplyTagRangeAPI() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello World"
        let tag = buffer.createTag(name: "bold-range")
        tag.weight = 700
        buffer.applyTag(tag, in: 0 ..< 5)
        #expect(buffer.charCount == 11)
    }

    @Test @MainActor func textBufferRemoveTagRangeAPI() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Test text"
        let tag = buffer.createTag(name: "remove-range")
        buffer.applyTag(tag, in: 0 ..< 4)
        buffer.removeTag(tag, in: 0 ..< 4)
        #expect(buffer.text == "Test text")
    }

    @Test @MainActor func textBufferEnableUndo() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.enableUndo = true
        #expect(buffer.enableUndo == true)
        buffer.enableUndo = false
        #expect(buffer.enableUndo == false)
    }

    @Test @MainActor func textBufferUserActionBrackets() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.enableUndo = true
        buffer.beginUserAction()
        buffer.insertAtCursor("Hello")
        buffer.insertAtCursor(" World")
        buffer.endUserAction()
        #expect(buffer.text == "Hello World")
        buffer.undo()
        #expect(buffer.text == "")
    }

    @Test @MainActor func textBufferOnChangedDisconnect() {
        ensureAdwInit()
        let buffer = TextBuffer()
        var count = 0
        let conn = buffer.onChanged { count += 1 }
        buffer.text = "first"
        let firstCount = count
        conn.disconnect()
        buffer.text = "second"
        #expect(count == firstCount, "onChanged should not fire after disconnect")
    }

    // MARK: - TextTag: deep coverage

    @Test @MainActor func textTagNamedCreation() {
        ensureAdwInit()
        let tag = TextTag(name: "custom-tag")
        tag.weight = 400
        #expect(tag.weight == 400)
    }

    @Test @MainActor func textTagAnonymousCreation() {
        ensureAdwInit()
        let tag = TextTag()
        tag.weight = 700
        #expect(tag.weight == 700)
    }

    @Test @MainActor func textTagSizeInPangoUnits() {
        ensureAdwInit()
        let tag = TextTag()
        tag.size = 16 * 1024
        #expect(tag.size == 16 * 1024)
    }

    @Test @MainActor func textTagBoldPresetCustomName() {
        ensureAdwInit()
        let tag = TextTag.bold(name: "my-bold")
        #expect(tag.weight == 700)
    }

    @Test @MainActor func textTagItalicPresetCustomName() {
        ensureAdwInit()
        let tag = TextTag.italic(name: "my-italic")
        #expect(tag.style == .italic)
    }

    @Test @MainActor func textTagMultipleProperties() {
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
        #expect(tag.weight == 700)
        #expect(tag.style == .italic)
        #expect(tag.strikethrough == true)
        #expect(tag.underline == .double)
        #expect(abs(tag.scale - 1.2) < 0.01)
        #expect(abs(tag.sizePoints - 16.0) < 0.01)
    }
}
#endif
