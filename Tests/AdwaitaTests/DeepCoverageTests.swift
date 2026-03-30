#if swift(>=6.3)
import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct DeepCoverageTests {

    // MARK: - CairoContext

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

    // MARK: - GtkWindow / Window

    @Test @MainActor func windowResizable() {
        ensureAdwInit()
        let win = Window()
        #expect(win.resizable == true)
        win.resizable = false
        #expect(win.resizable == false)
    }

    @Test @MainActor func windowDecorated() {
        ensureAdwInit()
        let win = Window()
        #expect(win.decorated == true)
        win.decorated = false
        #expect(win.decorated == false)
    }

    @Test @MainActor func windowDestroyWithParent() {
        ensureAdwInit()
        let win = Window()
        #expect(win.destroyWithParent == false)
        win.destroyWithParent = true
        #expect(win.destroyWithParent == true)
    }

    @Test @MainActor func windowIsFullscreenDefault() {
        ensureAdwInit()
        let win = Window()
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
        win.defaultWidth = 800
        #expect(win.defaultWidth == 800)
        #expect(win.defaultHeight == 768)
    }

    // MARK: - PreferencesPage

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
        page.remove(group)
    }

    @Test @MainActor func preferencesPageMultipleGroups() {
        ensureAdwInit()
        let page = PreferencesPage()
        let group1 = PreferencesGroup(title: "Group 1")
        let group2 = PreferencesGroup(title: "Group 2")
        page.add(group1)
        page.add(group2)
    }

    @Test @MainActor func preferencesPageScrollToTop() {
        ensureAdwInit()
        let page = PreferencesPage()
        page.scrollToTop()
    }

    // MARK: - PreferencesGroup

    @Test @MainActor func preferencesGroupAddRemoveChild() {
        ensureAdwInit()
        let group = PreferencesGroup()
        let label = Label("A row")
        group.add(label)
        group.remove(label)
    }

    @Test @MainActor func preferencesGroupDescription() {
        ensureAdwInit()
        let group = PreferencesGroup()
        group.description = "Some description"
        #expect(group.description == "Some description")
        group.description = nil
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

    // MARK: - BoxedTypes: SpringParams

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

    // MARK: - BoxedTypes: BreakpointCondition

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

    // MARK: - DrawingArea

    @Test @MainActor func drawingAreaQueueDraw() {
        ensureAdwInit()
        let da = DrawingArea()
        da.contentWidth = 100
        da.contentHeight = 100
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
        #expect(drawCalled == false)
    }
}
#endif
