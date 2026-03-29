import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct TextAndMediaTests {

    // MARK: - Entry

    @Test @MainActor func entryCreation() {
        ensureAdwInit()
        let entry = Entry()
        #expect(entry.text == "")
    }

    @Test @MainActor func entryConvenienceInit() {
        ensureAdwInit()
        let entry = Entry(placeholder: "Name")
        #expect(entry.placeholderText == "Name")
        #expect(entry.text == "")
    }

    @Test @MainActor func entryTextProperty() {
        ensureAdwInit()
        let entry = Entry()
        entry.text = "Hello"
        #expect(entry.text == "Hello")
        entry.text = ""
        #expect(entry.text == "")
    }

    @Test @MainActor func entryPlaceholderText() {
        ensureAdwInit()
        let entry = Entry()
        entry.placeholderText = "Search..."
        #expect(entry.placeholderText == "Search...")
        entry.placeholderText = "Type here"
        #expect(entry.placeholderText == "Type here")
    }

    @Test @MainActor func entryVisibility() {
        ensureAdwInit()
        let entry = Entry()
        #expect(entry.visibility == true)
        entry.visibility = false
        #expect(entry.visibility == false)
        entry.visibility = true
        #expect(entry.visibility == true)
    }

    @Test @MainActor func entryMaxLength() {
        ensureAdwInit()
        let entry = Entry()
        #expect(entry.maxLength == 0)
        entry.maxLength = 50
        #expect(entry.maxLength == 50)
    }

    @Test @MainActor func entryHasFrame() {
        ensureAdwInit()
        let entry = Entry()
        #expect(entry.hasFrame == true)
        entry.hasFrame = false
        #expect(entry.hasFrame == false)
    }

    @Test @MainActor func entryAlignment() {
        ensureAdwInit()
        let entry = Entry()
        entry.alignment = 0.5
        #expect(abs(entry.alignment - 0.5) < 0.01)
        entry.alignment = 1.0
        #expect(abs(entry.alignment - 1.0) < 0.01)
    }

    @Test @MainActor func entryInputPurpose() {
        ensureAdwInit()
        let entry = Entry()
        entry.inputPurpose = GTK_INPUT_PURPOSE_PASSWORD
        #expect(entry.inputPurpose == GTK_INPUT_PURPOSE_PASSWORD)
        entry.inputPurpose = GTK_INPUT_PURPOSE_FREE_FORM
        #expect(entry.inputPurpose == GTK_INPUT_PURPOSE_FREE_FORM)
    }

    @Test @MainActor func entryProgressFraction() {
        ensureAdwInit()
        let entry = Entry()
        #expect(abs(entry.progressFraction - 0.0) < 0.01)
        entry.progressFraction = 0.75
        #expect(abs(entry.progressFraction - 0.75) < 0.01)
    }

    @Test @MainActor func entryProgressPulseStep() {
        ensureAdwInit()
        let entry = Entry()
        entry.progressPulseStep = 0.2
        #expect(abs(entry.progressPulseStep - 0.2) < 0.01)
    }

    @Test @MainActor func entryOnChangedSignal() {
        ensureAdwInit()
        let entry = Entry()
        var changed = false
        entry.onChanged { changed = true }
        entry.text = "trigger"
        #expect(changed, "onChanged should fire when text is set")
    }

    @Test @MainActor func entryOnActivateSignal() {
        ensureAdwInit()
        let entry = Entry()
        var activated = false
        let conn = entry.onActivate { activated = true }
        // We cannot programmatically emit activate without GTK main loop,
        // but we can verify the signal connection was created.
        #expect(activated == false)
        _ = conn
    }

    @Test @MainActor func entryCursorAndSelection() {
        ensureAdwInit()
        let entry = Entry()
        entry.text = "Hello World"
        entry.cursorPosition = 5
        #expect(entry.cursorPosition == 5)
        entry.selectAll()
        #expect(entry.hasSelection == true)
        entry.clearSelection()
        #expect(entry.hasSelection == false)
    }

    @Test @MainActor func entryIconSetAndGet() {
        ensureAdwInit()
        let entry = Entry()
        entry.setIcon(position: GTK_ENTRY_ICON_PRIMARY, iconName: "edit-find-symbolic")
        #expect(entry.iconName(at: GTK_ENTRY_ICON_PRIMARY) == "edit-find-symbolic")
        entry.setIcon(position: GTK_ENTRY_ICON_PRIMARY, iconName: nil)
        #expect(entry.iconName(at: GTK_ENTRY_ICON_PRIMARY) == nil)
    }

    // MARK: - Scale

    @Test @MainActor func scaleCreation() {
        ensureAdwInit()
        let scale = Scale()
        #expect(abs(scale.value - 0.0) < 0.01)
    }

    @Test @MainActor func scaleCreationWithParams() {
        ensureAdwInit()
        let scale = Scale(orientation: GTK_ORIENTATION_VERTICAL, min: 10, max: 200, step: 5)
        #expect(abs(scale.value - 10.0) < 0.01)
    }

    @Test @MainActor func scaleValue() {
        ensureAdwInit()
        let scale = Scale(min: 0, max: 100, step: 1)
        scale.value = 42
        #expect(abs(scale.value - 42.0) < 0.01)
    }

    @Test @MainActor func scaleDrawValue() {
        ensureAdwInit()
        let scale = Scale()
        scale.drawValue = true
        #expect(scale.drawValue == true)
        scale.drawValue = false
        #expect(scale.drawValue == false)
    }

    @Test @MainActor func scaleDigits() {
        ensureAdwInit()
        let scale = Scale()
        scale.digits = 3
        #expect(scale.digits == 3)
    }

    @Test @MainActor func scaleHasOrigin() {
        ensureAdwInit()
        let scale = Scale()
        scale.hasOrigin = false
        #expect(scale.hasOrigin == false)
        scale.hasOrigin = true
        #expect(scale.hasOrigin == true)
    }

    @Test @MainActor func scaleInverted() {
        ensureAdwInit()
        let scale = Scale()
        #expect(scale.inverted == false)
        scale.inverted = true
        #expect(scale.inverted == true)
    }

    @Test @MainActor func scaleValuePos() {
        ensureAdwInit()
        let scale = Scale()
        scale.drawValue = true
        scale.valuePos = .left
        #expect(scale.valuePos == .left)
        scale.valuePos = .right
        #expect(scale.valuePos == .right)
    }

    @Test @MainActor func scaleSetRange() {
        ensureAdwInit()
        let scale = Scale(min: 0, max: 100, step: 1)
        scale.setRange(min: -50, max: 50)
        scale.value = -25
        #expect(abs(scale.value - -25.0) < 0.01)
    }

    @Test @MainActor func scaleAddAndClearMarks() {
        ensureAdwInit()
        let scale = Scale(min: 0, max: 100, step: 1)
        scale.addMark(value: 25, position: .top, markup: "25%")
        scale.addMark(value: 50, position: .bottom)
        scale.addMark(value: 75)
        // clearMarks should not crash
        scale.clearMarks()
    }

    // MARK: - TextBuffer

    @Test @MainActor func textBufferCreation() {
        ensureAdwInit()
        let buffer = TextBuffer()
        #expect(buffer.text == "")
        #expect(buffer.charCount == 0)
    }

    @Test @MainActor func textBufferSetText() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello, world!"
        #expect(buffer.text == "Hello, world!")
        #expect(buffer.charCount == 13)
    }

    @Test @MainActor func textBufferInsertAtCursor() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.insertAtCursor("ABC")
        #expect(buffer.text == "ABC")
        buffer.insertAtCursor("DEF")
        #expect(buffer.text == "ABCDEF")
    }

    @Test @MainActor func textBufferLineCount() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Line1\nLine2\nLine3"
        #expect(buffer.lineCount == 3)
    }

    @Test @MainActor func textBufferSelectAndGetSelected() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello World"
        #expect(buffer.hasSelection == false)
        buffer.selectAll()
        #expect(buffer.hasSelection == true)
        #expect(buffer.selectedText == "Hello World")
    }

    @Test @MainActor func textBufferPlaceCursor() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello"
        buffer.placeCursorAtStart()
        buffer.insertAtCursor(">> ")
        #expect(buffer.text == ">> Hello")
        buffer.placeCursorAtEnd()
        buffer.insertAtCursor(" <<")
        #expect(buffer.text == ">> Hello <<")
    }

    @Test @MainActor func textBufferModified() {
        ensureAdwInit()
        let buffer = TextBuffer()
        #expect(buffer.modified == false)
        buffer.text = "Changed"
        #expect(buffer.modified == true)
        buffer.modified = false
        #expect(buffer.modified == false)
    }

    @Test @MainActor func textBufferOnChanged() {
        ensureAdwInit()
        let buffer = TextBuffer()
        var changeCount = 0
        buffer.onChanged { changeCount += 1 }
        buffer.text = "first"
        #expect(changeCount > 0, "onChanged should fire when text is set")
    }

    @Test @MainActor func textBufferInsertAtOffset() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello World"
        buffer.insert(" Beautiful", at: 5)
        #expect(buffer.text == "Hello Beautiful World")
    }

    @Test @MainActor func textBufferTextInRange() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello World"
        let sub = buffer.text(in: 0 ..< 5)
        #expect(sub == "Hello")
    }

    // MARK: - TextView

    @Test @MainActor func textViewCreation() {
        ensureAdwInit()
        let tv = TextView()
        #expect(tv.text == "")
    }

    @Test @MainActor func textViewTextProperty() {
        ensureAdwInit()
        let tv = TextView()
        tv.text = "Some content"
        #expect(tv.text == "Some content")
    }

    @Test @MainActor func textViewEditable() {
        ensureAdwInit()
        let tv = TextView()
        #expect(tv.editable == true)
        tv.editable = false
        #expect(tv.editable == false)
    }

    @Test @MainActor func textViewCursorVisible() {
        ensureAdwInit()
        let tv = TextView()
        #expect(tv.cursorVisible == true)
        tv.cursorVisible = false
        #expect(tv.cursorVisible == false)
    }

    @Test @MainActor func textViewWrapMode() {
        ensureAdwInit()
        let tv = TextView()
        tv.wrapMode = .word
        #expect(tv.wrapMode == .word)
        tv.wrapMode = .char
        #expect(tv.wrapMode == .char)
        tv.wrapMode = .none
        #expect(tv.wrapMode == .none)
    }

    @Test @MainActor func textViewMonospace() {
        ensureAdwInit()
        let tv = TextView()
        #expect(tv.monospace == false)
        tv.monospace = true
        #expect(tv.monospace == true)
    }

    @Test @MainActor func textViewMargins() {
        ensureAdwInit()
        let tv = TextView()
        tv.leftMargin = 10
        tv.rightMargin = 20
        tv.topMargin = 5
        tv.bottomMargin = 15
        #expect(tv.leftMargin == 10)
        #expect(tv.rightMargin == 20)
        #expect(tv.topMargin == 5)
        #expect(tv.bottomMargin == 15)
    }

    @Test @MainActor func textViewJustification() {
        ensureAdwInit()
        let tv = TextView()
        tv.justification = .center
        #expect(tv.justification == .center)
        tv.justification = .right
        #expect(tv.justification == .right)
    }

    @Test @MainActor func textViewOverwrite() {
        ensureAdwInit()
        let tv = TextView()
        #expect(tv.overwrite == false)
        tv.overwrite = true
        #expect(tv.overwrite == true)
    }

    @Test @MainActor func textViewIndent() {
        ensureAdwInit()
        let tv = TextView()
        tv.indent = 16
        #expect(tv.indent == 16)
    }

    @Test @MainActor func textViewBuffer() {
        ensureAdwInit()
        let tv = TextView()
        let buffer = TextBuffer()
        buffer.text = "Shared buffer"
        tv.buffer = buffer
        #expect(tv.text == "Shared buffer")
    }
}
