// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class InputDialogXCTests: XCTestCase {

    // MARK: - Clipboard

    @MainActor func test_clipboardFromWidget() {
        ensureAdwInit()
        let button = Button(label: "test")
        // Clipboard can only be obtained after the widget has a display.
        // In headless tests this may not work, but the type should exist.
        let _: (Widget) -> Clipboard = { $0.clipboard }
        _ = button
    }

    @MainActor func test_clipboardSetTextureExists() {
        ensureAdwInit()
        // Verify the setTexture method compiles and exists on Clipboard.
        let _: (Clipboard, Texture) -> Void = { clipboard, texture in
            clipboard.setTexture(texture)
        }
    }

    // MARK: - DragSource

    @MainActor func test_dragSourceCreation() {
        ensureAdwInit()
        let source = DragSource()
        XCTAssertNotNil(source.pointer)
    }

    @MainActor func test_dragSourceActions() {
        ensureAdwInit()
        let source = DragSource()
        source.actions = GDK_ACTION_COPY
        XCTAssertTrue(source.actions == GDK_ACTION_COPY)
    }

    @MainActor func test_dragSourceSetIcon() {
        ensureAdwInit()
        let source = DragSource()
        // Create a 1x1 RGBA texture for testing
        let pixels: [UInt8] = [255, 0, 0, 255]
        let texture = Texture(rgbaData: pixels, width: 1, height: 1)
        // Should not crash; icon is set for future drag operations
        source.setIcon(texture, hotX: 0, hotY: 0)
    }

    @MainActor func test_dragSourceIsDraggingProperty() {
        ensureAdwInit()
        let source = DragSource()
        // No drag is active
        XCTAssertTrue(source.isDragging == false)
    }

    // MARK: - DropTarget

    @MainActor func test_dropTargetCreation() {
        ensureAdwInit()
        let target = DropTarget.forText()
        XCTAssertNotNil(target.pointer)
    }

    @MainActor func test_dropTargetProperties() {
        ensureAdwInit()
        let target = DropTarget.forText()
        target.preload = true
        XCTAssertTrue(target.preload)
    }

    // MARK: - FileFilter

    @MainActor func test_fileFilterCreation() {
        ensureAdwInit()
        let filter = FileFilter()
        filter.name = "Swift Files"
        XCTAssertTrue(filter.name == "Swift Files")
    }

    @MainActor func test_fileFilterConvenienceInit() {
        ensureAdwInit()
        let filter = FileFilter(name: "Images", mimeTypes: ["image/png", "image/jpeg"])
        XCTAssertTrue(filter.name == "Images")
    }

    @MainActor func test_fileFilterSuffix() {
        ensureAdwInit()
        let filter = FileFilter(name: "Code", suffixes: ["swift", "c", "h"])
        XCTAssertTrue(filter.name == "Code")
    }

    @MainActor func test_fileDialogSetFilters() {
        ensureAdwInit()
        let dialog = FileDialog()
        let filter1 = FileFilter(name: "Swift", suffixes: ["swift"])
        let filter2 = FileFilter(name: "All", suffixes: ["*"])
        dialog.setFilters([filter1, filter2])
        dialog.setDefaultFilter(filter1)
        // No crash = success
    }

    // MARK: - Frame

    @MainActor func test_frameCreation() {
        ensureAdwInit()
        let frame = Frame(label: "Test")
        XCTAssertNotNil(frame.pointer)
        XCTAssertTrue(frame.label == "Test")
    }

    @MainActor func test_frameChild() {
        ensureAdwInit()
        let frame = Frame(label: "Container")
        let label = Label("Content")
        frame.child = label
        XCTAssertNotNil(frame.child)
        XCTAssertTrue(frame.child?.pointer == label.pointer)
    }

    @MainActor func test_frameLabelAlign() {
        ensureAdwInit()
        let frame = Frame(label: "Aligned")
        frame.labelXAlign = 0.5
        XCTAssertTrue(frame.labelXAlign == 0.5)
    }

    // MARK: - CenterBox

    @MainActor func test_centerBoxCreation() {
        ensureAdwInit()
        let cb = CenterBox()
        XCTAssertNotNil(cb.pointer)
    }

    @MainActor func test_centerBoxChildren() {
        ensureAdwInit()
        let cb = CenterBox()
        let start = Label("Start")
        let center = Label("Center")
        let end = Label("End")
        cb.startWidget = start
        cb.centerWidget = center
        cb.endWidget = end
        XCTAssertTrue(cb.startWidget?.pointer == start.pointer)
        XCTAssertTrue(cb.centerWidget?.pointer == center.pointer)
        XCTAssertTrue(cb.endWidget?.pointer == end.pointer)
    }

    // MARK: - ColorDialogButton

    @MainActor func test_colorDialogButtonCreation() {
        ensureAdwInit()
        let btn = ColorDialogButton()
        XCTAssertNotNil(btn.pointer)
    }

    @MainActor func test_colorDialogButtonRGBA() {
        ensureAdwInit()
        let btn = ColorDialogButton()
        btn.rgba = RGBA(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        let c = btn.rgba
        XCTAssertTrue(c.red == 1.0)
        XCTAssertTrue(c.green == 0.0)
        XCTAssertTrue(c.blue == 0.0)
    }

    // MARK: - FontDialogButton

    @MainActor func test_fontDialogButtonCreation() {
        ensureAdwInit()
        let btn = FontDialogButton()
        XCTAssertNotNil(btn.pointer)
    }

    // MARK: - Per-side margins

    @MainActor func test_widgetPerSideMargins() {
        ensureAdwInit()
        let label = Label("test")
        label.marginTop = 10
        label.marginBottom = 20
        label.marginStart = 5
        label.marginEnd = 15
        XCTAssertTrue(label.marginTop == 10)
        XCTAssertTrue(label.marginBottom == 20)
        XCTAssertTrue(label.marginStart == 5)
        XCTAssertTrue(label.marginEnd == 15)
    }

    // MARK: - Keyboard shortcuts

    @MainActor func test_widgetAddKeyboardShortcut() {
        ensureAdwInit()
        let button = Button(label: "test")
        button.addKeyboardShortcut("<Control>s") { true }
        // No crash = success
    }

    // MARK: - DrawingArea

    @MainActor func test_drawingAreaCreation() {
        ensureAdwInit()
        let da = DrawingArea()
        XCTAssertTrue(da.contentWidth == 0)
        XCTAssertTrue(da.contentHeight == 0)
    }

    @MainActor func test_drawingAreaContentSize() {
        ensureAdwInit()
        let da = DrawingArea()
        da.contentWidth = 300
        da.contentHeight = 200
        XCTAssertTrue(da.contentWidth == 300)
        XCTAssertTrue(da.contentHeight == 200)
    }

    @MainActor func test_drawingAreaSetDrawFunc() {
        ensureAdwInit()
        let da = DrawingArea()
        da.contentWidth = 100
        da.contentHeight = 100
        da.setDrawFunc { _, _, _ in }
        // No crash = success
    }

    // MARK: - Calendar

    @MainActor func test_calendarCreation() {
        ensureAdwInit()
        let cal = Calendar()
        XCTAssertTrue(cal.year > 2000)
        XCTAssertTrue(cal.month >= 1 && cal.month <= 12)
        XCTAssertTrue(cal.day >= 1 && cal.day <= 31)
    }

    @MainActor func test_calendarShowProperties() {
        ensureAdwInit()
        let cal = Calendar()
        cal.showWeekNumbers = true
        XCTAssertTrue(cal.showWeekNumbers == true)
        cal.showDayNames = false
        XCTAssertTrue(cal.showDayNames == false)
        cal.showHeading = false
        XCTAssertTrue(cal.showHeading == false)
    }

    @MainActor func test_calendarMarking() {
        ensureAdwInit()
        let cal = Calendar()
        cal.markDay(15)
        XCTAssertTrue(cal.dayIsMarked(15) == true)
        cal.unmarkDay(15)
        XCTAssertTrue(cal.dayIsMarked(15) == false)
        cal.markDay(10)
        cal.markDay(20)
        cal.clearMarks()
        XCTAssertTrue(cal.dayIsMarked(10) == false)
        XCTAssertTrue(cal.dayIsMarked(20) == false)
    }

    // MARK: - TextBuffer

    @MainActor func test_textBufferCreation() {
        ensureAdwInit()
        let buf = TextBuffer()
        XCTAssertTrue(buf.text == "")
        XCTAssertTrue(buf.charCount == 0)
        XCTAssertTrue(buf.lineCount == 1)
    }

    @MainActor func test_textBufferSetText() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Hello, World!"
        XCTAssertTrue(buf.text == "Hello, World!")
        XCTAssertTrue(buf.charCount == 13)
    }

    @MainActor func test_textBufferMultiLine() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Line 1\nLine 2\nLine 3"
        XCTAssertTrue(buf.lineCount == 3)
    }

    @MainActor func test_textBufferModified() {
        ensureAdwInit()
        let buf = TextBuffer()
        XCTAssertTrue(buf.modified == false)
        buf.text = "changed"
        XCTAssertTrue(buf.modified == true)
        buf.modified = false
        XCTAssertTrue(buf.modified == false)
    }

    @MainActor func test_textBufferInsertAtCursor() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.insertAtCursor("Hello")
        buf.insertAtCursor(" World")
        XCTAssertTrue(buf.text == "Hello World")
    }

    @MainActor func test_textBufferSelectAll() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Select me"
        buf.selectAll()
        XCTAssertTrue(buf.hasSelection == true)
        XCTAssertTrue(buf.selectedText == "Select me")
    }

    @MainActor func test_textBufferPlaceCursor() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Cursor test"
        buf.placeCursorAtStart()
        buf.placeCursorAtEnd()
        // No crash = success
    }

    // MARK: - TextView enhancements

    @MainActor func test_textViewBuffer() {
        ensureAdwInit()
        let tv = TextView()
        let buf = tv.buffer
        buf.text = "Via buffer"
        XCTAssertTrue(tv.text == "Via buffer")
    }

    @MainActor func test_textViewJustification() {
        ensureAdwInit()
        let tv = TextView()
        tv.justification = .center
        XCTAssertTrue(tv.justification == .center)
    }

    @MainActor func test_textViewAcceptsTab() {
        ensureAdwInit()
        let tv = TextView()
        XCTAssertTrue(tv.acceptsTab == true)
        tv.acceptsTab = false
        XCTAssertTrue(tv.acceptsTab == false)
    }

    @MainActor func test_textViewOverwrite() {
        ensureAdwInit()
        let tv = TextView()
        XCTAssertTrue(tv.overwrite == false)
        tv.overwrite = true
        XCTAssertTrue(tv.overwrite == true)
    }

    // MARK: - Video

    @MainActor func test_videoCreation() {
        ensureAdwInit()
        let video = Video()
        XCTAssertTrue(video.autoplay == false)
        XCTAssertTrue(video.loop == false)
    }

    @MainActor func test_videoProperties() {
        ensureAdwInit()
        let video = Video()
        video.autoplay = true
        XCTAssertTrue(video.autoplay == true)
        video.loop = true
        XCTAssertTrue(video.loop == true)
    }

    @MainActor func test_videoMediaStreamConvenience() {
        ensureAdwInit()
        let video = Video()
        // No media stream set yet, so convenience properties return defaults
        XCTAssertTrue(video.isPlaying == false)
        XCTAssertTrue(video.ended == false)
        XCTAssertTrue(video.timestamp == 0)
        XCTAssertTrue(video.duration == 0)
        XCTAssertTrue(video.isMuted == false)
        XCTAssertTrue(video.volume == 0.0)
        // mediaStream should be nil for an empty video
        XCTAssertNil(video.mediaStream)
    }

    // MARK: - ApplicationWindow enhancements

    @MainActor func test_windowModalProperty() throws {
        ensureAdwInit()
        let app = Application(id: "com.test.windowmodal")
        try app.register()
        let win = ApplicationWindow(application: app)
        XCTAssertTrue(win.modal == false)
        win.modal = true
        XCTAssertTrue(win.modal == true)
    }

    @MainActor func test_windowResizableProperty() throws {
        ensureAdwInit()
        let app = Application(id: "com.test.windowresizable")
        try app.register()
        let win = ApplicationWindow(application: app)
        XCTAssertTrue(win.resizable == true)
        win.resizable = false
        XCTAssertTrue(win.resizable == false)
    }

    @MainActor func test_windowDecoratedProperty() throws {
        ensureAdwInit()
        let app = Application(id: "com.test.windowdecorated")
        try app.register()
        let win = ApplicationWindow(application: app)
        XCTAssertTrue(win.decorated == true)
        win.decorated = false
        XCTAssertTrue(win.decorated == false)
    }

    // MARK: - StyleManager

    @MainActor func test_styleManagerDefault() {
        ensureAdwInit()
        let sm = StyleManager.default
        // Should not crash and should be usable
        _ = sm.dark
        _ = sm.highContrast
        _ = sm.systemSupportsColorSchemes
    }

    @MainActor func test_styleManagerColorScheme() {
        ensureAdwInit()
        let sm = StyleManager.default
        sm.forceDark()
        XCTAssertTrue(sm.colorScheme == .forceDark)
        sm.forceLight()
        XCTAssertTrue(sm.colorScheme == .forceLight)
        sm.preferDark()
        XCTAssertTrue(sm.colorScheme == .preferDark)
        sm.preferLight()
        XCTAssertTrue(sm.colorScheme == .preferLight)
        sm.resetColorScheme()
        XCTAssertTrue(sm.colorScheme == .default)
    }

}
#endif
