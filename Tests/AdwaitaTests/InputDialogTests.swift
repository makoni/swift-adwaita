import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct InputDialogTests {

    // MARK: - Clipboard

    @Test @MainActor func clipboardFromWidget() {
        ensureAdwInit()
        let button = Button(label: "test")
        // Clipboard can only be obtained after the widget has a display.
        // In headless tests this may not work, but the type should exist.
        let _: (Widget) -> Clipboard = { $0.clipboard }
        _ = button
    }

    @Test @MainActor func clipboardSetTextureExists() {
        ensureAdwInit()
        // Verify the setTexture method compiles and exists on Clipboard.
        let _: (Clipboard, Texture) -> Void = { clipboard, texture in
            clipboard.setTexture(texture)
        }
    }

    // MARK: - DragSource

    @Test @MainActor func dragSourceCreation() {
        ensureAdwInit()
        let source = DragSource()
        #expect(source.pointer != nil)
    }

    @Test @MainActor func dragSourceActions() {
        ensureAdwInit()
        let source = DragSource()
        source.actions = GDK_ACTION_COPY
        #expect(source.actions == GDK_ACTION_COPY)
    }

    @Test @MainActor func dragSourceSetIcon() {
        ensureAdwInit()
        let source = DragSource()
        // Create a 1x1 RGBA texture for testing
        let pixels: [UInt8] = [255, 0, 0, 255]
        let texture = Texture(rgbaData: pixels, width: 1, height: 1)
        // Should not crash; icon is set for future drag operations
        source.setIcon(texture, hotX: 0, hotY: 0)
    }

    @Test @MainActor func dragSourceIsDraggingProperty() {
        ensureAdwInit()
        let source = DragSource()
        // No drag is active
        #expect(source.isDragging == false)
    }

    // MARK: - DropTarget

    @Test @MainActor func dropTargetCreation() {
        ensureAdwInit()
        let target = DropTarget.forText()
        #expect(target.pointer != nil)
    }

    @Test @MainActor func dropTargetProperties() {
        ensureAdwInit()
        let target = DropTarget.forText()
        target.preload = true
        #expect(target.preload)
    }

    // MARK: - FileFilter

    @Test @MainActor func fileFilterCreation() {
        ensureAdwInit()
        let filter = FileFilter()
        filter.name = "Swift Files"
        #expect(filter.name == "Swift Files")
    }

    @Test @MainActor func fileFilterConvenienceInit() {
        ensureAdwInit()
        let filter = FileFilter(name: "Images", mimeTypes: ["image/png", "image/jpeg"])
        #expect(filter.name == "Images")
    }

    @Test @MainActor func fileFilterSuffix() {
        ensureAdwInit()
        let filter = FileFilter(name: "Code", suffixes: ["swift", "c", "h"])
        #expect(filter.name == "Code")
    }

    @Test @MainActor func fileDialogSetFilters() {
        ensureAdwInit()
        let dialog = FileDialog()
        let filter1 = FileFilter(name: "Swift", suffixes: ["swift"])
        let filter2 = FileFilter(name: "All", suffixes: ["*"])
        dialog.setFilters([filter1, filter2])
        dialog.setDefaultFilter(filter1)
        // No crash = success
    }

    // MARK: - Frame

    @Test @MainActor func frameCreation() {
        ensureAdwInit()
        let frame = Frame(label: "Test")
        #expect(frame.pointer != nil)
        #expect(frame.label == "Test")
    }

    @Test @MainActor func frameChild() {
        ensureAdwInit()
        let frame = Frame(label: "Container")
        let label = Label("Content")
        frame.child = label
        #expect(frame.child != nil)
        #expect(frame.child?.pointer == label.pointer)
    }

    @Test @MainActor func frameLabelAlign() {
        ensureAdwInit()
        let frame = Frame(label: "Aligned")
        frame.labelXAlign = 0.5
        #expect(frame.labelXAlign == 0.5)
    }

    // MARK: - CenterBox

    @Test @MainActor func centerBoxCreation() {
        ensureAdwInit()
        let cb = CenterBox()
        #expect(cb.pointer != nil)
    }

    @Test @MainActor func centerBoxChildren() {
        ensureAdwInit()
        let cb = CenterBox()
        let start = Label("Start")
        let center = Label("Center")
        let end = Label("End")
        cb.startWidget = start
        cb.centerWidget = center
        cb.endWidget = end
        #expect(cb.startWidget?.pointer == start.pointer)
        #expect(cb.centerWidget?.pointer == center.pointer)
        #expect(cb.endWidget?.pointer == end.pointer)
    }

    // MARK: - ColorDialogButton

    @Test @MainActor func colorDialogButtonCreation() {
        ensureAdwInit()
        let btn = ColorDialogButton()
        #expect(btn.pointer != nil)
    }

    @Test @MainActor func colorDialogButtonRGBA() {
        ensureAdwInit()
        let btn = ColorDialogButton()
        btn.rgba = RGBA(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        let c = btn.rgba
        #expect(c.red == 1.0)
        #expect(c.green == 0.0)
        #expect(c.blue == 0.0)
    }

    // MARK: - FontDialogButton

    @Test @MainActor func fontDialogButtonCreation() {
        ensureAdwInit()
        let btn = FontDialogButton()
        #expect(btn.pointer != nil)
    }

    // MARK: - Per-side margins

    @Test @MainActor func widgetPerSideMargins() {
        ensureAdwInit()
        let label = Label("test")
        label.marginTop = 10
        label.marginBottom = 20
        label.marginStart = 5
        label.marginEnd = 15
        #expect(label.marginTop == 10)
        #expect(label.marginBottom == 20)
        #expect(label.marginStart == 5)
        #expect(label.marginEnd == 15)
    }

    // MARK: - Keyboard shortcuts

    @Test @MainActor func widgetAddKeyboardShortcut() {
        ensureAdwInit()
        let button = Button(label: "test")
        button.addKeyboardShortcut("<Control>s") { true }
        // No crash = success
    }

    // MARK: - DrawingArea

    @Test @MainActor func drawingAreaCreation() {
        ensureAdwInit()
        let da = DrawingArea()
        #expect(da.contentWidth == 0)
        #expect(da.contentHeight == 0)
    }

    @Test @MainActor func drawingAreaContentSize() {
        ensureAdwInit()
        let da = DrawingArea()
        da.contentWidth = 300
        da.contentHeight = 200
        #expect(da.contentWidth == 300)
        #expect(da.contentHeight == 200)
    }

    @Test @MainActor func drawingAreaSetDrawFunc() {
        ensureAdwInit()
        let da = DrawingArea()
        da.contentWidth = 100
        da.contentHeight = 100
        da.setDrawFunc { _, _, _ in }
        // No crash = success
    }

    // MARK: - Calendar

    @Test @MainActor func calendarCreation() {
        ensureAdwInit()
        let cal = Calendar()
        #expect(cal.year > 2000)
        #expect(cal.month >= 1 && cal.month <= 12)
        #expect(cal.day >= 1 && cal.day <= 31)
    }

    @Test @MainActor func calendarShowProperties() {
        ensureAdwInit()
        let cal = Calendar()
        cal.showWeekNumbers = true
        #expect(cal.showWeekNumbers == true)
        cal.showDayNames = false
        #expect(cal.showDayNames == false)
        cal.showHeading = false
        #expect(cal.showHeading == false)
    }

    @Test @MainActor func calendarMarking() {
        ensureAdwInit()
        let cal = Calendar()
        cal.markDay(15)
        #expect(cal.dayIsMarked(15) == true)
        cal.unmarkDay(15)
        #expect(cal.dayIsMarked(15) == false)
        cal.markDay(10)
        cal.markDay(20)
        cal.clearMarks()
        #expect(cal.dayIsMarked(10) == false)
        #expect(cal.dayIsMarked(20) == false)
    }

    // MARK: - TextBuffer

    @Test @MainActor func textBufferCreation() {
        ensureAdwInit()
        let buf = TextBuffer()
        #expect(buf.text == "")
        #expect(buf.charCount == 0)
        #expect(buf.lineCount == 1)
    }

    @Test @MainActor func textBufferSetText() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Hello, World!"
        #expect(buf.text == "Hello, World!")
        #expect(buf.charCount == 13)
    }

    @Test @MainActor func textBufferMultiLine() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Line 1\nLine 2\nLine 3"
        #expect(buf.lineCount == 3)
    }

    @Test @MainActor func textBufferModified() {
        ensureAdwInit()
        let buf = TextBuffer()
        #expect(buf.modified == false)
        buf.text = "changed"
        #expect(buf.modified == true)
        buf.modified = false
        #expect(buf.modified == false)
    }

    @Test @MainActor func textBufferInsertAtCursor() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.insertAtCursor("Hello")
        buf.insertAtCursor(" World")
        #expect(buf.text == "Hello World")
    }

    @Test @MainActor func textBufferSelectAll() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Select me"
        buf.selectAll()
        #expect(buf.hasSelection == true)
        #expect(buf.selectedText == "Select me")
    }

    @Test @MainActor func textBufferPlaceCursor() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Cursor test"
        buf.placeCursorAtStart()
        buf.placeCursorAtEnd()
        // No crash = success
    }

    // MARK: - TextView enhancements

    @Test @MainActor func textViewBuffer() {
        ensureAdwInit()
        let tv = TextView()
        let buf = tv.buffer
        buf.text = "Via buffer"
        #expect(tv.text == "Via buffer")
    }

    @Test @MainActor func textViewJustification() {
        ensureAdwInit()
        let tv = TextView()
        tv.justification = .center
        #expect(tv.justification == .center)
    }

    @Test @MainActor func textViewAcceptsTab() {
        ensureAdwInit()
        let tv = TextView()
        #expect(tv.acceptsTab == true)
        tv.acceptsTab = false
        #expect(tv.acceptsTab == false)
    }

    @Test @MainActor func textViewOverwrite() {
        ensureAdwInit()
        let tv = TextView()
        #expect(tv.overwrite == false)
        tv.overwrite = true
        #expect(tv.overwrite == true)
    }

    // MARK: - Video

    @Test @MainActor func videoCreation() {
        ensureAdwInit()
        let video = Video()
        #expect(video.autoplay == false)
        #expect(video.loop == false)
    }

    @Test @MainActor func videoProperties() {
        ensureAdwInit()
        let video = Video()
        video.autoplay = true
        #expect(video.autoplay == true)
        video.loop = true
        #expect(video.loop == true)
    }

    @Test @MainActor func videoMediaStreamConvenience() {
        ensureAdwInit()
        let video = Video()
        // No media stream set yet, so convenience properties return defaults
        #expect(video.isPlaying == false)
        #expect(video.ended == false)
        #expect(video.timestamp == 0)
        #expect(video.duration == 0)
        #expect(video.isMuted == false)
        #expect(video.volume == 0.0)
        // mediaStream should be nil for an empty video
        #expect(video.mediaStream == nil)
    }

    // MARK: - ApplicationWindow enhancements

    @Test @MainActor func windowModalProperty() {
        ensureAdwInit()
        let app = Application(id: "com.test.windowmodal")
        let win = ApplicationWindow(application: app)
        #expect(win.modal == false)
        win.modal = true
        #expect(win.modal == true)
    }

    @Test @MainActor func windowResizableProperty() {
        ensureAdwInit()
        let app = Application(id: "com.test.windowresizable")
        let win = ApplicationWindow(application: app)
        #expect(win.resizable == true)
        win.resizable = false
        #expect(win.resizable == false)
    }

    @Test @MainActor func windowDecoratedProperty() {
        ensureAdwInit()
        let app = Application(id: "com.test.windowdecorated")
        let win = ApplicationWindow(application: app)
        #expect(win.decorated == true)
        win.decorated = false
        #expect(win.decorated == false)
    }

    // MARK: - StyleManager

    @Test @MainActor func styleManagerDefault() {
        ensureAdwInit()
        let sm = StyleManager.default
        // Should not crash and should be usable
        _ = sm.dark
        _ = sm.highContrast
        _ = sm.systemSupportsColorSchemes
    }

    @Test @MainActor func styleManagerColorScheme() {
        ensureAdwInit()
        let sm = StyleManager.default
        sm.forceDark()
        #expect(sm.colorScheme == .forceDark)
        sm.forceLight()
        #expect(sm.colorScheme == .forceLight)
        sm.preferDark()
        #expect(sm.colorScheme == .preferDark)
        sm.preferLight()
        #expect(sm.colorScheme == .preferLight)
        sm.resetColorScheme()
        #expect(sm.colorScheme == .default)
    }

}
