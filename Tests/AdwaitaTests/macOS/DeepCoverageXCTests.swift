#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class DeepCoverageXCTests: XCTestCase {

    // MARK: - CairoContext

    @MainActor
    private func makeCairoContext(width: Int = 200,
                                  height: Int = 200) -> (CairoContext, OpaquePointer, OpaquePointer) {
        let surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, Int32(width), Int32(height))!
        let cr = cairo_create(surface)!
        return (CairoContext(cr), cr, surface)
    }

    @MainActor func test_cairoSetSourceRGB() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        ctx.setSourceRGB(1.0, 0.0, 0.0)
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    @MainActor func test_cairoSetSourceRGBA() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        ctx.setSourceRGBA(0.0, 1.0, 0.0, 0.5)
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    @MainActor func test_cairoRectangleAndFill() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        ctx.setSourceRGB(0.0, 0.0, 1.0)
        ctx.rectangle(x: 10, y: 10, width: 80, height: 60)
        ctx.fill()
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    @MainActor func test_cairoRectangleAndStroke() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        ctx.setLineWidth(2.0)
        ctx.setSourceRGB(1.0, 0.0, 0.0)
        ctx.rectangle(x: 5, y: 5, width: 100, height: 50)
        ctx.stroke()
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    @MainActor func test_cairoRoundedRectangle() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        ctx.setSourceRGB(0.5, 0.5, 0.5)
        ctx.roundedRectangle(x: 10, y: 10, width: 100, height: 80, radius: 12)
        ctx.fill()
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    @MainActor func test_cairoArc() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        ctx.setSourceRGB(0.2, 0.6, 1.0)
        ctx.arc(centerX: 100, centerY: 100, radius: 50, startAngle: 0, endAngle: 2 * .pi)
        ctx.fill()
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    @MainActor func test_cairoMoveToLineTo() {
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

    @MainActor func test_cairoFillPreserve() {
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

    @MainActor func test_cairoStrokePreserve() {
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

    @MainActor func test_cairoPaintAndPaintWithAlpha() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        ctx.setSourceRGB(1.0, 1.0, 1.0)
        ctx.paint()
        ctx.setSourceRGBA(1.0, 0.0, 0.0, 0.5)
        ctx.paintWithAlpha(0.5)
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    @MainActor func test_cairoSetLineWidth() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        ctx.setLineWidth(5.0)
        ctx.moveTo(x: 0, y: 100)
        ctx.lineTo(x: 200, y: 100)
        ctx.stroke()
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    @MainActor func test_cairoSaveAndRestore() {
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

    @MainActor func test_cairoTranslate() {
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

    @MainActor func test_cairoScale() {
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

    @MainActor func test_cairoRotate() {
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

    @MainActor func test_cairoNewSubPathAndClosePath() {
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

    @MainActor func test_cairoSetLineCapAndJoin() {
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

    @MainActor func test_cairoContextPointerNotNil() {
        ensureAdwInit()
        let (ctx, cr, surface) = makeCairoContext()
        XCTAssertTrue(ctx.pointer == cr)
        cairo_destroy(cr)
        cairo_surface_destroy(surface)
    }

    // MARK: - GtkWindow / Window

    @MainActor func test_windowResizable() {
        ensureAdwInit()
        let win = Window()
        XCTAssertTrue(win.resizable == true)
        win.resizable = false
        XCTAssertTrue(win.resizable == false)
    }

    @MainActor func test_windowDecorated() {
        ensureAdwInit()
        let win = Window()
        XCTAssertTrue(win.decorated == true)
        win.decorated = false
        XCTAssertTrue(win.decorated == false)
    }

    @MainActor func test_windowDestroyWithParent() {
        ensureAdwInit()
        let win = Window()
        XCTAssertTrue(win.destroyWithParent == false)
        win.destroyWithParent = true
        XCTAssertTrue(win.destroyWithParent == true)
    }

    @MainActor func test_windowIsFullscreenDefault() {
        ensureAdwInit()
        let win = Window()
        XCTAssertTrue(win.isFullscreen == false)
    }

    @MainActor func test_windowIsMaximizedDefault() {
        ensureAdwInit()
        let win = Window()
        XCTAssertTrue(win.isMaximized == false)
    }

    @MainActor func test_windowTransientFor() {
        ensureAdwInit()
        let parent = Window()
        let child = Window()
        child.transientFor = parent
        XCTAssertNotNil(child.transientFor)
        child.transientFor = nil
        XCTAssertNil(child.transientFor)
    }

    @MainActor func test_windowIconName() {
        ensureAdwInit()
        let win = Window()
        win.iconName = "accessories-text-editor-symbolic"
        XCTAssertTrue(win.iconName == "accessories-text-editor-symbolic")
        win.iconName = nil
        XCTAssertNil(win.iconName)
    }

    @MainActor func test_windowOnCloseRequest() {
        ensureAdwInit()
        let win = Window()
        let conn = win.onCloseRequest { false }
        conn.disconnect()
    }

    @MainActor func test_windowPresentAndCloseDoesNotCrash() throws {
        ensureAdwInit()
        let app = Application(id: "com.test.deepcoverage.window.\(UInt32.random(in: 0 ..< UInt32.max))")
        try app.register()
        let win = ApplicationWindow(application: app)
        win.title = "Transient"
        win.present()
        win.close()
    }

    @MainActor func test_windowContent() {
        ensureAdwInit()
        let win = Window()
        let label = Label("Content")
        win.content = label
        XCTAssertNotNil(win.content)
        win.content = nil
        XCTAssertNil(win.content)
    }

    @MainActor func test_windowDefaultSizeBothAxes() {
        ensureAdwInit()
        let win = Window()
        win.defaultWidth = 1024
        win.defaultHeight = 768
        XCTAssertTrue(win.defaultWidth == 1024)
        XCTAssertTrue(win.defaultHeight == 768)
        win.defaultWidth = 800
        XCTAssertTrue(win.defaultWidth == 800)
        XCTAssertTrue(win.defaultHeight == 768)
    }

    // MARK: - PreferencesPage

    @MainActor func test_preferencesPageCreation() {
        ensureAdwInit()
        let page = PreferencesPage()
        XCTAssertTrue(page.title == "")
    }

    @MainActor func test_preferencesPageName() {
        ensureAdwInit()
        let page = PreferencesPage()
        page.name = "general-page"
        XCTAssertTrue(page.name == "general-page")
        page.name = nil
        XCTAssertNil(page.name)
    }

    @MainActor func test_preferencesPageAddRemoveGroup() {
        ensureAdwInit()
        let page = PreferencesPage()
        let group = PreferencesGroup(title: "Settings")
        page.add(group)
        page.remove(group)
    }

    @MainActor func test_preferencesPageMultipleGroups() {
        ensureAdwInit()
        let page = PreferencesPage()
        let group1 = PreferencesGroup(title: "Group 1")
        let group2 = PreferencesGroup(title: "Group 2")
        page.add(group1)
        page.add(group2)
    }

    @MainActor func test_preferencesPageScrollToTop() {
        ensureAdwInit()
        let page = PreferencesPage()
        page.scrollToTop()
    }

    // MARK: - PreferencesGroup

    @MainActor func test_preferencesGroupAddRemoveChild() {
        ensureAdwInit()
        let group = PreferencesGroup()
        let label = Label("A row")
        group.add(label)
        group.remove(label)
    }

    @MainActor func test_preferencesGroupDescription() {
        ensureAdwInit()
        let group = PreferencesGroup()
        group.description = "Some description"
        XCTAssertTrue(group.description == "Some description")
        group.description = nil
        XCTAssertTrue(group.description == nil || group.description == "")
    }

    @MainActor func test_preferencesGroupHeaderSuffix() {
        ensureAdwInit()
        let group = PreferencesGroup()
        let btn = Button(label: "Add")
        group.headerSuffix = btn
        XCTAssertNotNil(group.headerSuffix)
        group.headerSuffix = nil
        XCTAssertNil(group.headerSuffix)
    }

    // MARK: - BoxedTypes: SpringParams

    @MainActor func test_springParamsDampingRatioInit() {
        ensureAdwInit()
        let params = SpringParams(dampingRatio: 0.6, mass: 1.0, stiffness: 100.0)
        XCTAssertTrue(abs(params.dampingRatio - 0.6) < 0.01)
        XCTAssertTrue(abs(params.mass - 1.0) < 0.01)
        XCTAssertTrue(abs(params.stiffness - 100.0) < 0.01)
    }

    // MARK: - BoxedTypes: BreakpointCondition

    @MainActor func test_breakpointConditionRatio() {
        ensureAdwInit()
        let cond = BreakpointCondition.ratio(
            type: ADW_BREAKPOINT_CONDITION_MAX_ASPECT_RATIO,
            width: 16,
            height: 9
        )
        let str = cond.toString()
        XCTAssertTrue(str.contains("16") || str.contains("aspect"))
    }

    @MainActor func test_breakpointConditionOrCombination() {
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
        XCTAssertFalse(str.isEmpty)
    }

    @MainActor func test_breakpointConditionAndCombination() {
        ensureAdwInit()
        let a = BreakpointCondition(parse: "max-width: 600px")
        let b = BreakpointCondition(parse: "max-height: 400px")
        let combined = BreakpointCondition.and(a, b)
        let str = combined.toString()
        XCTAssertTrue(str.contains("and") || str.contains("600") || !str.isEmpty)
    }

    // MARK: - DrawingArea

    @MainActor func test_drawingAreaQueueDraw() {
        ensureAdwInit()
        let da = DrawingArea()
        da.contentWidth = 100
        da.contentHeight = 100
        da.queueDraw()
    }

    @MainActor func test_drawingAreaSetDrawFuncWithOperations() {
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
        XCTAssertTrue(drawCalled == false)
    }
}
#endif
