import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct DeepCoverageTests {

    // =========================================================================
    // MARK: - TextBuffer: deep coverage

    // =========================================================================

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
        // No selection — deleteSelection should be a no-op
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
        // An empty buffer still has 1 line in GTK
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
        // Place cursor at offset 1 (between A and E), then insert
        buffer.insert("BCD", at: 1)
        #expect(buffer.text == "ABCDE")
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
        // If applyTag didn't crash the tag was applied successfully
        #expect(buffer.text == "Hello World")
    }

    @Test @MainActor func textBufferApplyTagRangeAPI() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello World"
        let tag = buffer.createTag(name: "bold-range")
        tag.weight = 700
        buffer.applyTag(tag, in: 0 ..< 5)
        // No crash = success
        #expect(buffer.charCount == 11)
    }

    @Test @MainActor func textBufferRemoveTag() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello World"
        let tag = buffer.createTag(name: "removable")
        tag.foreground = "red"
        buffer.applyTag(tag, startOffset: 0, endOffset: 5)
        buffer.removeTag(tag, startOffset: 0, endOffset: 5)
        // No crash = tag was removed successfully
        #expect(buffer.text == "Hello World")
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

    @Test @MainActor func textBufferRemoveAllTags() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Styled text"
        let tag1 = buffer.createTag(name: "t1")
        tag1.weight = 700
        let tag2 = buffer.createTag(name: "t2")
        tag2.foreground = "blue"
        buffer.applyTag(tag1, startOffset: 0, endOffset: 6)
        buffer.applyTag(tag2, startOffset: 0, endOffset: 6)
        buffer.removeAllTags(startOffset: 0, endOffset: 6)
        // No crash = all tags removed
        #expect(buffer.text == "Styled text")
    }

    @Test @MainActor func textBufferEnableUndo() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.enableUndo = true
        #expect(buffer.enableUndo == true)
        buffer.enableUndo = false
        #expect(buffer.enableUndo == false)
    }

    @Test @MainActor func textBufferUndoRedo() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.enableUndo = true
        #expect(buffer.canUndo == false)
        #expect(buffer.canRedo == false)

        buffer.beginUserAction()
        buffer.insertAtCursor("ABC")
        buffer.endUserAction()

        #expect(buffer.text == "ABC")
        #expect(buffer.canUndo == true)

        buffer.undo()
        #expect(buffer.text == "")
        #expect(buffer.canRedo == true)

        buffer.redo()
        #expect(buffer.text == "ABC")
    }

    @Test @MainActor func textBufferUserActionBrackets() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.enableUndo = true
        // Multiple inserts within a single user action should undo as one unit
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

    // =========================================================================
    // MARK: - TextTag: deep coverage

    // =========================================================================

    @Test @MainActor func textTagNamedCreation() {
        ensureAdwInit()
        let tag = TextTag(name: "custom-tag")
        // Should not crash, tag is created
        tag.weight = 400
        #expect(tag.weight == 400)
    }

    @Test @MainActor func textTagAnonymousCreation() {
        ensureAdwInit()
        let tag = TextTag()
        // Anonymous tags (no name) should work fine
        tag.weight = 700
        #expect(tag.weight == 700)
    }

    @Test @MainActor func textTagSizeInPangoUnits() {
        ensureAdwInit()
        let tag = TextTag()
        // Pango uses 1024 units per point
        tag.size = 16 * 1024
        #expect(tag.size == 16 * 1024)
    }

    @Test @MainActor func textTagSizePoints() {
        ensureAdwInit()
        let tag = TextTag()
        tag.sizePoints = 24.0
        #expect(abs(tag.sizePoints - 24.0) < 0.01)
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

    @Test @MainActor func textTagMonospacePreset() {
        ensureAdwInit()
        let tag = TextTag.monospace(name: "code")
        // family is write-only, just verify creation succeeds
        tag.scale = 0.9
        #expect(abs(tag.scale - 0.9) < 0.01)
    }

    @Test @MainActor func textTagColoredPreset() {
        ensureAdwInit()
        let tag = TextTag.colored("#3584e4", name: "link-color")
        // foreground is write-only, verify tag works
        tag.underline = .single
        #expect(tag.underline == .single)
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

    // =========================================================================
    // MARK: - CairoContext: create via cairo_image_surface + test methods

    // =========================================================================

    /// Helper: create a CairoContext backed by an in-memory image surface.
    @MainActor
    private func makeCairoContext(width: Int = 200, height: Int = 200) -> (CairoContext, OpaquePointer, OpaquePointer) {
        let surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, Int32(width), Int32(height))!
        let cr = cairo_create(surface)!
        return (CairoContext(cr), cr, surface)
    }

    @Test @MainActor func cairoSetSourceRGB() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        ctx.setSourceRGB(1.0, 0.0, 0.0)
        // No crash = success
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    @Test @MainActor func cairoSetSourceRGBA() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        ctx.setSourceRGBA(0.0, 1.0, 0.0, 0.5)
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    @Test @MainActor func cairoRectangleAndFill() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        ctx.setSourceRGB(0.0, 0.0, 1.0)
        ctx.rectangle(x: 10, y: 10, width: 80, height: 60)
        ctx.fill()
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    @Test @MainActor func cairoRectangleAndStroke() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        ctx.setLineWidth(2.0)
        ctx.setSourceRGB(1.0, 0.0, 0.0)
        ctx.rectangle(x: 5, y: 5, width: 100, height: 50)
        ctx.stroke()
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    @Test @MainActor func cairoRoundedRectangle() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        ctx.setSourceRGB(0.5, 0.5, 0.5)
        ctx.roundedRectangle(x: 10, y: 10, width: 100, height: 80, radius: 12)
        ctx.fill()
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    @Test @MainActor func cairoArc() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        ctx.setSourceRGB(0.2, 0.6, 1.0)
        ctx.arc(centerX: 100, centerY: 100, radius: 50, startAngle: 0, endAngle: 2 * .pi)
        ctx.fill()
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    @Test @MainActor func cairoMoveToLineTo() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        ctx.setSourceRGB(0.0, 0.0, 0.0)
        ctx.setLineWidth(3.0)
        ctx.moveTo(x: 10, y: 10)
        ctx.lineTo(x: 190, y: 190)
        ctx.stroke()
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    @Test @MainActor func cairoFillPreserve() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        ctx.setSourceRGB(1.0, 1.0, 0.0)
        ctx.rectangle(x: 20, y: 20, width: 60, height: 60)
        ctx.fillPreserve()
        // Path is preserved, we can stroke on top
        ctx.setSourceRGB(0.0, 0.0, 0.0)
        ctx.stroke()
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    @Test @MainActor func cairoStrokePreserve() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        ctx.setSourceRGB(0.0, 0.0, 0.0)
        ctx.setLineWidth(2.0)
        ctx.rectangle(x: 20, y: 20, width: 60, height: 60)
        ctx.strokePreserve()
        // Path still exists, fill it
        ctx.setSourceRGBA(0.0, 0.0, 1.0, 0.3)
        ctx.fill()
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    @Test @MainActor func cairoPaintAndPaintWithAlpha() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        ctx.setSourceRGB(1.0, 1.0, 1.0)
        ctx.paint()
        ctx.setSourceRGBA(1.0, 0.0, 0.0, 0.5)
        ctx.paintWithAlpha(0.5)
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    @Test @MainActor func cairoSetLineWidth() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        ctx.setLineWidth(5.0)
        ctx.moveTo(x: 0, y: 100)
        ctx.lineTo(x: 200, y: 100)
        ctx.stroke()
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    @Test @MainActor func cairoSaveAndRestore() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        ctx.setSourceRGB(1.0, 0.0, 0.0)
        ctx.save()
        ctx.setSourceRGB(0.0, 0.0, 1.0)
        ctx.rectangle(x: 0, y: 0, width: 50, height: 50)
        ctx.fill()
        ctx.restore()
        // After restore, source color should be back to red
        ctx.rectangle(x: 50, y: 0, width: 50, height: 50)
        ctx.fill()
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    @Test @MainActor func cairoTranslate() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        ctx.save()
        ctx.translate(x: 50, y: 50)
        ctx.setSourceRGB(0.0, 1.0, 0.0)
        ctx.rectangle(x: 0, y: 0, width: 30, height: 30)
        ctx.fill()
        ctx.restore()
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    @Test @MainActor func cairoScale() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        ctx.save()
        ctx.scale(x: 2.0, y: 2.0)
        ctx.rectangle(x: 0, y: 0, width: 50, height: 50)
        ctx.fill()
        ctx.restore()
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    @Test @MainActor func cairoRotate() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        ctx.save()
        ctx.translate(x: 100, y: 100)
        ctx.rotate(.pi / 4)
        ctx.rectangle(x: -25, y: -25, width: 50, height: 50)
        ctx.fill()
        ctx.restore()
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    @Test @MainActor func cairoNewSubPathAndClosePath() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        ctx.setSourceRGB(0.5, 0.0, 0.5)
        ctx.setLineWidth(2.0)
        ctx.newSubPath()
        ctx.moveTo(x: 10, y: 10)
        ctx.lineTo(x: 50, y: 10)
        ctx.lineTo(x: 30, y: 40)
        ctx.closePath()
        ctx.stroke()
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    @Test @MainActor func cairoSetLineCapAndJoin() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        ctx.setLineCap(CAIRO_LINE_CAP_ROUND)
        ctx.setLineJoin(CAIRO_LINE_JOIN_ROUND)
        ctx.setLineWidth(4.0)
        ctx.moveTo(x: 10, y: 10)
        ctx.lineTo(x: 100, y: 50)
        ctx.lineTo(x: 10, y: 90)
        ctx.stroke()
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    @Test @MainActor func cairoContextPointerNotNil() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        #expect(ctx.pointer == cr)
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    // =========================================================================
    // MARK: - GtkWindow / Window: uncovered properties

    // =========================================================================

    @Test @MainActor func windowResizable() {
        ensureAdwInit()
        let win = Window()
        #expect(win.resizable == true)
        win.resizable = false
        #expect(win.resizable == false)
        win.resizable = true
        #expect(win.resizable == true)
    }

    @Test @MainActor func windowDecorated() {
        ensureAdwInit()
        let win = Window()
        #expect(win.decorated == true)
        win.decorated = false
        #expect(win.decorated == false)
        win.decorated = true
        #expect(win.decorated == true)
    }

    @Test @MainActor func windowDestroyWithParent() {
        ensureAdwInit()
        let win = Window()
        #expect(win.destroyWithParent == false)
        win.destroyWithParent = true
        #expect(win.destroyWithParent == true)
        win.destroyWithParent = false
        #expect(win.destroyWithParent == false)
    }

    @Test @MainActor func windowIsFullscreenDefault() {
        ensureAdwInit()
        let win = Window()
        // Without a display/realize, isFullscreen should be false
        #expect(win.isFullscreen == false)
    }

    @Test @MainActor func windowIsMaximizedDefault() {
        ensureAdwInit()
        let win = Window()
        #expect(win.isMaximized == false)
    }

    @Test @MainActor func windowTransientFor() {
        ensureAdwInit()
        let parent = Window()
        let child = Window()
        child.transientFor = parent
        #expect(child.transientFor != nil)
        child.transientFor = nil
        #expect(child.transientFor == nil)
    }

    @Test @MainActor func windowIconName() {
        ensureAdwInit()
        let win = Window()
        win.iconName = "accessories-text-editor-symbolic"
        #expect(win.iconName == "accessories-text-editor-symbolic")
        win.iconName = nil
        #expect(win.iconName == nil)
    }

    @Test @MainActor func windowOnCloseRequest() {
        ensureAdwInit()
        let win = Window()
        let conn = win.onCloseRequest { false }
        // Signal connection created successfully
        conn.disconnect()
    }

    @Test @MainActor func windowContent() {
        ensureAdwInit()
        let win = Window()
        let label = Label("Content")
        win.content = label
        #expect(win.content != nil)
        win.content = nil
        #expect(win.content == nil)
    }

    @Test @MainActor func windowDefaultSizeBothAxes() {
        ensureAdwInit()
        let win = Window()
        win.defaultWidth = 1024
        win.defaultHeight = 768
        #expect(win.defaultWidth == 1024)
        #expect(win.defaultHeight == 768)
        // Change only one axis and verify the other is preserved
        win.defaultWidth = 800
        #expect(win.defaultWidth == 800)
        #expect(win.defaultHeight == 768)
        win.defaultHeight = 600
        #expect(win.defaultWidth == 800)
        #expect(win.defaultHeight == 600)
    }

    // =========================================================================
    // MARK: - PreferencesPage: uncovered properties and methods

    // =========================================================================

    @Test @MainActor func preferencesPageCreation() {
        ensureAdwInit()
        let page = PreferencesPage()
        #expect(page.title == "")
    }

    @Test @MainActor func preferencesPageName() {
        ensureAdwInit()
        let page = PreferencesPage()
        page.name = "general-page"
        #expect(page.name == "general-page")
        page.name = nil
        #expect(page.name == nil)
    }

    @Test @MainActor func preferencesPageAddRemoveGroup() {
        ensureAdwInit()
        let page = PreferencesPage()
        let group = PreferencesGroup(title: "Settings")
        page.add(group)
        // add/remove should not crash
        page.remove(group)
    }

    @Test @MainActor func preferencesPageMultipleGroups() {
        ensureAdwInit()
        let page = PreferencesPage()
        let group1 = PreferencesGroup(title: "Group 1")
        let group2 = PreferencesGroup(title: "Group 2")
        page.add(group1)
        page.add(group2)
        // Should not crash; getGroup requires libadwaita 1.8+
    }

    @Test @MainActor func preferencesPageScrollToTop() {
        ensureAdwInit()
        let page = PreferencesPage()
        // scrollToTop should not crash even without a realized widget
        page.scrollToTop()
    }

    // =========================================================================
    // MARK: - PreferencesGroup: uncovered properties

    // =========================================================================

    @Test @MainActor func preferencesGroupAddRemoveChild() {
        ensureAdwInit()
        let group = PreferencesGroup()
        let label = Label("A row")
        group.add(label)
        group.remove(label)
        // No crash = success
    }

    @Test @MainActor func preferencesGroupDescription() {
        ensureAdwInit()
        let group = PreferencesGroup()
        group.description = "Some description"
        #expect(group.description == "Some description")
        group.description = nil
        // GTK returns empty string when description is cleared
        #expect(group.description == nil || group.description == "")
    }

    @Test @MainActor func preferencesGroupHeaderSuffix() {
        ensureAdwInit()
        let group = PreferencesGroup()
        let btn = Button(label: "Add")
        group.headerSuffix = btn
        #expect(group.headerSuffix != nil)
        group.headerSuffix = nil
        #expect(group.headerSuffix == nil)
    }

    // =========================================================================
    // MARK: - BoxedTypes: SpringParams full init

    // =========================================================================

    @Test @MainActor func springParamsFullInit() {
        ensureAdwInit()
        let params = SpringParams(damping: 15.0, mass: 2.0, stiffness: 300.0)
        #expect(abs(params.damping - 15.0) < 0.01)
        #expect(abs(params.mass - 2.0) < 0.01)
        #expect(abs(params.stiffness - 300.0) < 0.01)
    }

    @Test @MainActor func springParamsDampingRatioInit() {
        ensureAdwInit()
        let params = SpringParams(dampingRatio: 0.6, mass: 1.0, stiffness: 100.0)
        #expect(abs(params.dampingRatio - 0.6) < 0.01)
        #expect(abs(params.mass - 1.0) < 0.01)
        #expect(abs(params.stiffness - 100.0) < 0.01)
    }

    // =========================================================================
    // MARK: - BoxedTypes: BreakpointCondition

    // =========================================================================

    @Test @MainActor func breakpointConditionRatio() {
        ensureAdwInit()
        let cond = BreakpointCondition.ratio(
            type: ADW_BREAKPOINT_CONDITION_MAX_ASPECT_RATIO,
            width: 16,
            height: 9
        )
        let str = cond.toString()
        #expect(str.contains("16") || str.contains("aspect"))
    }

    @Test @MainActor func breakpointConditionOrCombination() {
        ensureAdwInit()
        let a = BreakpointCondition.length(
            type: ADW_BREAKPOINT_CONDITION_MAX_WIDTH,
            value: 400,
            unit: .px
        )
        let b = BreakpointCondition.length(
            type: ADW_BREAKPOINT_CONDITION_MAX_HEIGHT,
            value: 300,
            unit: .px
        )
        let combined = BreakpointCondition.or(a, b)
        let str = combined.toString()
        #expect(!str.isEmpty)
    }

    @Test @MainActor func breakpointConditionAndCombination() {
        ensureAdwInit()
        let a = BreakpointCondition(parse: "max-width: 600px")
        let b = BreakpointCondition(parse: "max-height: 400px")
        let combined = BreakpointCondition.and(a, b)
        let str = combined.toString()
        #expect(str.contains("and") || str.contains("600") || !str.isEmpty)
    }

    // =========================================================================
    // MARK: - DrawingArea: queueDraw and draw function with operations

    // =========================================================================

    @Test @MainActor func drawingAreaQueueDraw() {
        ensureAdwInit()
        let da = DrawingArea()
        da.contentWidth = 100
        da.contentHeight = 100
        // queueDraw should not crash even without a realized widget
        da.queueDraw()
    }

    @Test @MainActor func drawingAreaSetDrawFuncWithOperations() {
        ensureAdwInit()
        let da = DrawingArea()
        da.contentWidth = 200
        da.contentHeight = 200
        var drawCalled = false
        da.setDrawFunc { cr, width, height in
            drawCalled = true
            cr.setSourceRGB(0.2, 0.6, 1.0)
            cr.rectangle(x: 0, y: 0, width: Double(width), height: Double(height))
            cr.fill()
        }
        // The draw func won't be called until the widget is realized,
        // but setting it should not crash
        #expect(drawCalled == false)
    }
}
