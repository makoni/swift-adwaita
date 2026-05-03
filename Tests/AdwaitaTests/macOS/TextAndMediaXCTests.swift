// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class TextAndMediaXCTests: XCTestCase {

    // MARK: - Entry

    @MainActor func test_entryCreation() {
        ensureAdwInit()
        let entry = Entry()
        XCTAssertTrue(entry.text == "")
    }

    @MainActor func test_entryTextProperty() {
        ensureAdwInit()
        let entry = Entry()
        entry.text = "Hello"
        XCTAssertTrue(entry.text == "Hello")
        entry.text = ""
        XCTAssertTrue(entry.text == "")
    }

    @MainActor func test_entryPlaceholderText() {
        ensureAdwInit()
        let entry = Entry()
        entry.placeholderText = "Search..."
        XCTAssertTrue(entry.placeholderText == "Search...")
        entry.placeholderText = "Type here"
        XCTAssertTrue(entry.placeholderText == "Type here")
    }

    @MainActor func test_entryProgressPulseStep() {
        ensureAdwInit()
        let entry = Entry()
        entry.progressPulseStep = 0.2
        XCTAssertTrue(abs(entry.progressPulseStep - 0.2) < 0.01)
    }

    @MainActor func test_entryOnChangedSignal() {
        ensureAdwInit()
        let entry = Entry()
        var changed = false
        entry.onChanged { changed = true }
        entry.text = "trigger"
        XCTAssertTrue(changed, "onChanged should fire when text is set")
    }

    @MainActor func test_entryOnActivateSignal() {
        ensureAdwInit()
        let entry = Entry()
        var activated = false
        let conn = entry.onActivate { activated = true }
        // We cannot programmatically emit activate without GTK main loop,
        // but we can verify the signal connection was created.
        XCTAssertTrue(activated == false)
        _ = conn
    }

    @MainActor func test_entryCursorAndSelection() {
        ensureAdwInit()
        let entry = Entry()
        entry.text = "Hello World"
        entry.cursorPosition = 5
        XCTAssertTrue(entry.cursorPosition == 5)
        entry.selectAll()
        XCTAssertTrue(entry.hasSelection == true)
        entry.clearSelection()
        XCTAssertTrue(entry.hasSelection == false)
    }

    @MainActor func test_entryIconSetAndGet() {
        ensureAdwInit()
        let entry = Entry()
        entry.setIcon(position: GTK_ENTRY_ICON_PRIMARY, iconName: "edit-find-symbolic")
        XCTAssertTrue(entry.iconName(at: GTK_ENTRY_ICON_PRIMARY) == "edit-find-symbolic")
        entry.setIcon(position: GTK_ENTRY_ICON_PRIMARY, iconName: nil)
        XCTAssertNil(entry.iconName(at: GTK_ENTRY_ICON_PRIMARY))
    }

    // MARK: - Scale

    @MainActor func test_scaleCreation() {
        ensureAdwInit()
        let scale = Scale()
        XCTAssertTrue(abs(scale.value - 0.0) < 0.01)
    }

    @MainActor func test_scaleCreationWithParams() {
        ensureAdwInit()
        let scale = Scale(orientation: GTK_ORIENTATION_VERTICAL, min: 10, max: 200, step: 5)
        XCTAssertTrue(abs(scale.value - 10.0) < 0.01)
    }

    @MainActor func test_scaleValue() {
        ensureAdwInit()
        let scale = Scale(min: 0, max: 100, step: 1)
        scale.value = 42
        XCTAssertTrue(abs(scale.value - 42.0) < 0.01)
    }

    @MainActor func test_scaleDrawValue() {
        ensureAdwInit()
        let scale = Scale()
        scale.drawValue = true
        XCTAssertTrue(scale.drawValue == true)
        scale.drawValue = false
        XCTAssertTrue(scale.drawValue == false)
    }

    @MainActor func test_scaleDigits() {
        ensureAdwInit()
        let scale = Scale()
        scale.digits = 3
        XCTAssertTrue(scale.digits == 3)
    }

    @MainActor func test_scaleHasOrigin() {
        ensureAdwInit()
        let scale = Scale()
        scale.hasOrigin = false
        XCTAssertTrue(scale.hasOrigin == false)
        scale.hasOrigin = true
        XCTAssertTrue(scale.hasOrigin == true)
    }

    @MainActor func test_scaleValuePos() {
        ensureAdwInit()
        let scale = Scale()
        scale.drawValue = true
        scale.valuePos = .left
        XCTAssertTrue(scale.valuePos == .left)
        scale.valuePos = .right
        XCTAssertTrue(scale.valuePos == .right)
    }

    @MainActor func test_scaleSetRange() {
        ensureAdwInit()
        let scale = Scale(min: 0, max: 100, step: 1)
        scale.setRange(min: -50, max: 50)
        scale.value = -25
        XCTAssertTrue(abs(scale.value - -25.0) < 0.01)
    }

    @MainActor func test_scaleAddAndClearMarks() {
        ensureAdwInit()
        let scale = Scale(min: 0, max: 100, step: 1)
        scale.addMark(value: 25, position: .top, markup: "25%")
        scale.addMark(value: 50, position: .bottom)
        scale.addMark(value: 75)
        // clearMarks should not crash
        scale.clearMarks()
    }

    // MARK: - TextBuffer

    @MainActor func test_textBufferLineCount() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Line1\nLine2\nLine3"
        XCTAssertTrue(buffer.lineCount == 3)
    }

    @MainActor func test_textBufferSelectAndGetSelected() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello World"
        XCTAssertTrue(buffer.hasSelection == false)
        buffer.selectAll()
        XCTAssertTrue(buffer.hasSelection == true)
        XCTAssertTrue(buffer.selectedText == "Hello World")
    }

    @MainActor func test_textBufferOnChanged() {
        ensureAdwInit()
        let buffer = TextBuffer()
        var changeCount = 0
        buffer.onChanged { changeCount += 1 }
        buffer.text = "first"
        XCTAssertTrue(changeCount > 0, "onChanged should fire when text is set")
    }

    // MARK: - TextView

    @MainActor func test_textViewCreation() {
        ensureAdwInit()
        let tv = TextView()
        XCTAssertTrue(tv.text == "")
    }

    @MainActor func test_textViewTextProperty() {
        ensureAdwInit()
        let tv = TextView()
        tv.text = "Some content"
        XCTAssertTrue(tv.text == "Some content")
    }

    @MainActor func test_textViewEditable() {
        ensureAdwInit()
        let tv = TextView()
        XCTAssertTrue(tv.editable == true)
        tv.editable = false
        XCTAssertTrue(tv.editable == false)
    }

    @MainActor func test_textViewCursorVisible() {
        ensureAdwInit()
        let tv = TextView()
        XCTAssertTrue(tv.cursorVisible == true)
        tv.cursorVisible = false
        XCTAssertTrue(tv.cursorVisible == false)
    }

    @MainActor func test_textViewWrapMode() {
        ensureAdwInit()
        let tv = TextView()
        tv.wrapMode = .word
        XCTAssertTrue(tv.wrapMode == .word)
        tv.wrapMode = .char
        XCTAssertTrue(tv.wrapMode == .char)
        tv.wrapMode = .none
        XCTAssertTrue(tv.wrapMode == .none)
    }

    @MainActor func test_textViewMonospace() {
        ensureAdwInit()
        let tv = TextView()
        XCTAssertTrue(tv.monospace == false)
        tv.monospace = true
        XCTAssertTrue(tv.monospace == true)
    }

    @MainActor func test_textViewIndent() {
        ensureAdwInit()
        let tv = TextView()
        tv.indent = 16
        XCTAssertTrue(tv.indent == 16)
    }

}
#endif
