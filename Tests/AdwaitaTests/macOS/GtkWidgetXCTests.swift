#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class GtkWidgetXCTests: XCTestCase {

    // MARK: - GMenu and Actions Tests

    @MainActor func test_gmenuCreationAndAppend() {
        ensureAdwInit()
        let menu = GMenuRef()
        menu.append("Quit", action: "app.quit")
        menu.append("About", action: "app.about")
        // Should not crash
        XCTAssertNotNil(menu.pointer)
    }

    @MainActor func test_gmenuSectionAndSubmenu() {
        ensureAdwInit()
        let menu = GMenuRef()
        let section = GMenuRef()
        section.append("Cut", action: "app.cut")
        section.append("Copy", action: "app.copy")
        menu.appendSection("Edit", section: section)

        let submenu = GMenuRef()
        submenu.append("Zoom In", action: "app.zoom-in")
        menu.appendSubmenu("View", submenu: submenu)
        XCTAssertNotNil(menu.pointer)
    }

    @MainActor func test_gmenuItemWithIcon() {
        ensureAdwInit()
        let item = GMenuItemRef(label: "Open", action: "app.open")
        item.setIconName("document-open-symbolic")
        item.setLabel("Open File")
        XCTAssertNotNil(item.pointer)
    }

    @MainActor func test_simpleActionCreation() {
        ensureAdwInit()
        let action = SimpleAction(name: "test")
        XCTAssertTrue(action.enabled == true)
        action.enabled = false
        XCTAssertTrue(action.enabled == false)
    }

    @MainActor func test_simpleActionSignal() {
        ensureAdwInit()
        let action = SimpleAction(name: "click")
        let conn = action.onActivate {}
        conn.disconnect()
    }

    @MainActor func test_menuButtonWithModel() {
        ensureAdwInit()
        let menu = GMenuRef()
        menu.append("Item 1", action: "app.item1")
        let btn = MenuButton()
        btn.setMenuModel(menu)
        XCTAssertNotNil(btn.pointer)
    }

    // MARK: - New GTK Widget Tests

    @MainActor func test_progressBarProperties() {
        ensureAdwInit()
        let pb = ProgressBar()
        pb.fraction = 0.75
        XCTAssertTrue(pb.fraction == 0.75)
        pb.showText = true
        XCTAssertTrue(pb.showText == true)
        pb.text = "75%"
        XCTAssertTrue(pb.text == "75%")
        pb.inverted = true
        XCTAssertTrue(pb.inverted == true)
    }

    @MainActor func test_progressBarPulse() {
        ensureAdwInit()
        let pb = ProgressBar()
        pb.pulseStep = 0.1
        XCTAssertTrue(pb.pulseStep == 0.1)
        pb.pulse()
        // Should not crash
        XCTAssertNotNil(pb.pointer)
    }

    @MainActor func test_scaleProperties() {
        ensureAdwInit()
        let scale = Scale(orientation: GTK_ORIENTATION_HORIZONTAL, min: 0, max: 100, step: 1)
        scale.value = 50
        XCTAssertTrue(scale.value == 50)
        scale.drawValue = true
        XCTAssertTrue(scale.drawValue == true)
        scale.hasOrigin = true
        XCTAssertTrue(scale.hasOrigin == true)
        scale.digits = 0
        XCTAssertTrue(scale.digits == 0)
    }

    @MainActor func test_scaleInverted() {
        ensureAdwInit()
        let scale = Scale(orientation: GTK_ORIENTATION_HORIZONTAL, min: 0, max: 10, step: 1)
        scale.inverted = true
        XCTAssertTrue(scale.inverted == true)
    }

    @MainActor func test_levelBarProperties() {
        ensureAdwInit()
        let lb = LevelBar(min: 0, max: 10)
        lb.value = 7
        XCTAssertTrue(lb.value == 7)
        XCTAssertTrue(lb.minValue == 0)
        XCTAssertTrue(lb.maxValue == 10)
        lb.inverted = true
        XCTAssertTrue(lb.inverted == true)
    }

    @MainActor func test_textViewProperties() {
        ensureAdwInit()
        let tv = TextView()
        tv.text = "Hello, World!"
        XCTAssertTrue(tv.text == "Hello, World!")
        tv.editable = false
        XCTAssertTrue(tv.editable == false)
        tv.monospace = true
        XCTAssertTrue(tv.monospace == true)
        tv.cursorVisible = false
        XCTAssertTrue(tv.cursorVisible == false)
    }

    @MainActor func test_textViewMargins() {
        ensureAdwInit()
        let tv = TextView()
        tv.leftMargin = 10
        tv.rightMargin = 10
        tv.topMargin = 5
        tv.bottomMargin = 5
        XCTAssertTrue(tv.leftMargin == 10)
        XCTAssertTrue(tv.rightMargin == 10)
        XCTAssertTrue(tv.topMargin == 5)
        XCTAssertTrue(tv.bottomMargin == 5)
    }

    @MainActor func test_stringListOperations() {
        ensureAdwInit()
        let sl = StringList(["Alpha", "Beta", "Gamma"])
        XCTAssertTrue(sl.count == 3)
        XCTAssertTrue(sl.getString(0) == "Alpha")
        XCTAssertTrue(sl.getString(1) == "Beta")
        XCTAssertTrue(sl.getString(2) == "Gamma")
        sl.append("Delta")
        XCTAssertTrue(sl.count == 4)
        sl.remove(1)
        XCTAssertTrue(sl.count == 3)
        XCTAssertTrue(sl.getString(1) == "Gamma")
    }

    @MainActor func test_cssProviderLoadFromString() {
        ensureAdwInit()
        let css = CSSProvider()
        css.loadFromString("button { color: red; }")
        css.addToDefaultDisplay()
        css.removeFromDefaultDisplay()
    }

    @MainActor func test_gtkEnumsAreAccessible() {
        _ = GTK_ORIENTATION_HORIZONTAL
        _ = GTK_ORIENTATION_VERTICAL
        _ = GTK_ALIGN_START
        _ = GTK_ALIGN_CENTER
        _ = GTK_ALIGN_END
        _ = GTK_ALIGN_FILL
        _ = GTK_SELECTION_NONE
        _ = GTK_SELECTION_SINGLE
        _ = GTK_SELECTION_MULTIPLE
        XCTAssertTrue(Bool(true), "All key GTK enums are accessible")
    }

    // MARK: - Event Controller Tests

    @MainActor func test_gestureClickCreation() {
        ensureAdwInit()
        let gesture = GestureClick()
        XCTAssertNotNil(gesture.pointer)
    }

    @MainActor func test_gestureClickSignalConnection() {
        ensureAdwInit()
        let gesture = GestureClick()
        let conn1 = gesture.onPressed { _, _, _ in }
        let conn2 = gesture.onReleased { _, _, _ in }
        // Signal handlers should be connected without crashing
        conn1.disconnect()
        conn2.disconnect()
    }

    @MainActor func test_gestureClickAddToWidget() {
        ensureAdwInit()
        let btn = Button(label: "Test")
        let gesture = GestureClick()
        btn.addController(gesture)
        // Should not crash
        XCTAssertTrue(Bool(true))
    }

    @MainActor func test_eventControllerKeyCreation() {
        ensureAdwInit()
        let controller = EventControllerKey()
        XCTAssertNotNil(controller.pointer)
    }

    @MainActor func test_eventControllerKeySignalConnection() {
        ensureAdwInit()
        let controller = EventControllerKey()
        let conn1 = controller.onKeyPressed { _, _, _ in false }
        let conn2 = controller.onKeyReleased { _, _, _ in }
        conn1.disconnect()
        conn2.disconnect()
    }

    @MainActor func test_eventControllerKeyAddToWidget() {
        ensureAdwInit()
        let entry = Entry()
        let controller = EventControllerKey()
        entry.addController(controller)
        XCTAssertTrue(Bool(true))
    }

    @MainActor func test_eventControllerMotionCreation() {
        ensureAdwInit()
        let controller = EventControllerMotion()
        XCTAssertNotNil(controller.pointer)
    }

    @MainActor func test_eventControllerMotionSignalConnection() {
        ensureAdwInit()
        let controller = EventControllerMotion()
        let conn1 = controller.onMotion { _, _ in }
        let conn2 = controller.onEnter { _, _ in }
        let conn3 = controller.onLeave {}
        conn1.disconnect()
        conn2.disconnect()
        conn3.disconnect()
    }

    @MainActor func test_eventControllerMotionAddToWidget() {
        ensureAdwInit()
        let label = Label("Hover me")
        let controller = EventControllerMotion()
        label.addController(controller)
        XCTAssertTrue(Bool(true))
    }

    @MainActor func test_eventControllerScrollCreation() {
        ensureAdwInit()
        let controller = EventControllerScroll()
        XCTAssertNotNil(controller.pointer)
    }

    @MainActor func test_eventControllerScrollWithFlags() {
        ensureAdwInit()
        let controller = EventControllerScroll(flags: GTK_EVENT_CONTROLLER_SCROLL_VERTICAL)
        XCTAssertNotNil(controller.pointer)
    }

    @MainActor func test_eventControllerScrollSignalConnection() {
        ensureAdwInit()
        let controller = EventControllerScroll()
        let conn1 = controller.onScroll { _, _ in false }
        let conn2 = controller.onScrollBegin {}
        let conn3 = controller.onScrollEnd {}
        conn1.disconnect()
        conn2.disconnect()
        conn3.disconnect()
    }

    @MainActor func test_eventControllerScrollAddToWidget() {
        ensureAdwInit()
        let box = Box()
        let controller = EventControllerScroll()
        box.addController(controller)
        XCTAssertTrue(Bool(true))
    }

    @MainActor func test_multipleControllersOnOneWidget() {
        ensureAdwInit()
        let btn = Button(label: "Multi")
        let click = GestureClick()
        let key = EventControllerKey()
        let motion = EventControllerMotion()
        let scroll = EventControllerScroll()
        btn.addController(click)
        btn.addController(key)
        btn.addController(motion)
        btn.addController(scroll)
        XCTAssertTrue(Bool(true))
    }

    @MainActor func test_eventControllerInheritance() {
        XCTAssertTrue(isAdwSubclass(GestureClick.self, of: GObjectRef.self))
        XCTAssertTrue(isAdwSubclass(EventControllerKey.self, of: GObjectRef.self))
        XCTAssertTrue(isAdwSubclass(EventControllerMotion.self, of: GObjectRef.self))
        XCTAssertTrue(isAdwSubclass(EventControllerScroll.self, of: GObjectRef.self))
    }

    // MARK: - Window onCloseRequest Signal

    @MainActor func test_windowOnCloseRequestSignalConnection() {
        ensureAdwInit()
        let window = Window()
        let conn = window.onCloseRequest { true }
        conn.disconnect()
    }

    // MARK: - Widget Lifecycle Signals

    @MainActor func test_widgetLifecycleSignalConnections() {
        ensureAdwInit()
        let label = Label("lifecycle")
        let c1 = label.onRealize {}
        let c2 = label.onUnrealize {}
        let c3 = label.onMap {}
        let c4 = label.onUnmap {}
        let c5 = label.onDestroy {}
        c1.disconnect()
        c2.disconnect()
        c3.disconnect()
        c4.disconnect()
        c5.disconnect()
    }

    // MARK: - Button Convenience Initializers

    @MainActor func test_buttonConvenienceInitWithLabel() {
        ensureAdwInit()
        var clicked = false
        let btn = Button(label: "Click", onClicked: { clicked = true })
        XCTAssertTrue(btn.label == "Click")
        // The handler is connected; we cannot easily trigger it without a main loop,
        // but we verify the button was created with the correct label.
    }

    @MainActor func test_buttonConvenienceInitWithIcon() {
        ensureAdwInit()
        let btn = Button(iconName: "edit-copy-symbolic", onClicked: {})
        XCTAssertTrue(btn.iconName == "edit-copy-symbolic")
    }

    // MARK: - SpringParams Properties

    @MainActor func test_springParamsProperties() {
        ensureAdwInit()
        let sp = SpringParams(dampingRatio: 0.8, mass: 1.0, stiffness: 100.0)
        XCTAssertTrue(sp.dampingRatio == 0.8)
        XCTAssertTrue(sp.mass == 1.0)
        XCTAssertTrue(sp.stiffness == 100.0)
        XCTAssertTrue(sp.damping > 0)
    }

    @MainActor func test_springParamsFullInit() {
        ensureAdwInit()
        let sp = SpringParams(damping: 10.0, mass: 2.0, stiffness: 50.0)
        XCTAssertTrue(sp.damping == 10.0)
        XCTAssertTrue(sp.mass == 2.0)
        XCTAssertTrue(sp.stiffness == 50.0)
    }

    // MARK: - BreakpointCondition

    @MainActor func test_breakpointConditionParseAndToString() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "min-width: 600px")
        let str = cond.toString()
        XCTAssertTrue(str.contains("600"))
    }

    @MainActor func test_breakpointConditionLength() {
        ensureAdwInit()
        let cond = BreakpointCondition.length(
            type: ADW_BREAKPOINT_CONDITION_MIN_WIDTH,
            value: 400,
            unit: .px
        )
        let str = cond.toString()
        XCTAssertTrue(str.contains("400"))
    }

    @MainActor func test_breakpointConditionAnd() {
        ensureAdwInit()
        let a = BreakpointCondition.length(
            type: ADW_BREAKPOINT_CONDITION_MIN_WIDTH,
            value: 400,
            unit: .px
        )
        let b = BreakpointCondition.length(
            type: ADW_BREAKPOINT_CONDITION_MAX_WIDTH,
            value: 800,
            unit: .px
        )
        let combined = BreakpointCondition.and(a, b)
        let str = combined.toString()
        XCTAssertTrue(str.contains("400"))
        XCTAssertTrue(str.contains("800"))
    }

    // MARK: - Enum Extensions

    @MainActor func test_gtkOrientationEnumExtensions() {
        XCTAssertTrue(GtkOrientation.vertical == GTK_ORIENTATION_VERTICAL)
        XCTAssertTrue(GtkOrientation.horizontal == GTK_ORIENTATION_HORIZONTAL)
    }

    @MainActor func test_gtkAlignEnumExtensions() {
        XCTAssertTrue(GtkAlign.fill == GTK_ALIGN_FILL)
        XCTAssertTrue(GtkAlign.start == GTK_ALIGN_START)
        XCTAssertTrue(GtkAlign.end == GTK_ALIGN_END)
        XCTAssertTrue(GtkAlign.center == GTK_ALIGN_CENTER)
    }

    @MainActor func test_gtkSelectionModeEnumExtensions() {
        XCTAssertTrue(GtkSelectionMode.none == GTK_SELECTION_NONE)
        XCTAssertTrue(GtkSelectionMode.single == GTK_SELECTION_SINGLE)
        XCTAssertTrue(GtkSelectionMode.multiple == GTK_SELECTION_MULTIPLE)
    }

    @MainActor func test_adwColorSchemeEnumExtensions() {
        // Verify the extensions exist and are distinct
        let d = AdwColorScheme.default
        let fd = AdwColorScheme.forceDark
        let fl = AdwColorScheme.forceLight
        XCTAssertTrue(fd != fl)
        XCTAssertTrue(d != fd)
    }

    // MARK: - SignalHelper connectReturnBool

    @MainActor func test_signalHelperConnectReturnBoolExists() {
        let _: (GObjectRef, SignalName, @escaping @MainActor () -> Bool) -> SignalConnection = SignalHelper
            .connectReturnBool
    }

    @MainActor func test_buttonGtkTypeNarrowsFromGenericWidget() {
        ensureAdwInit()
        let button: Widget = Button(label: "OK")
        let label: Widget = Label("Plain")
        XCTAssertTrue(button.isInstance(of: Button.self))
        XCTAssertTrue(!label.isInstance(of: Button.self))
        XCTAssertNotNil(button.tryCast(Button.self))
        XCTAssertNil(label.tryCast(Button.self))
    }

    @MainActor func test_boxGtkTypeNarrowsFromGenericWidget() {
        ensureAdwInit()
        let box: Widget = Box(orientation: GTK_ORIENTATION_HORIZONTAL)
        let label: Widget = Label("Plain")
        XCTAssertTrue(box.isInstance(of: Box.self))
        XCTAssertTrue(!label.isInstance(of: Box.self))
        XCTAssertNotNil(box.tryCast(Box.self))
        XCTAssertNil(label.tryCast(Box.self))
    }

    @MainActor func test_boxOrientationReflectsInitOrientation() {
        ensureAdwInit()
        let horizontal = Box(orientation: GTK_ORIENTATION_HORIZONTAL)
        let vertical = Box(orientation: GTK_ORIENTATION_VERTICAL)
        XCTAssertTrue(horizontal.orientation == GTK_ORIENTATION_HORIZONTAL)
        XCTAssertTrue(vertical.orientation == GTK_ORIENTATION_VERTICAL)
    }

    @MainActor func test_pictureFileURLTracksSetFilename() {
        ensureAdwInit()
        let picture = Adwaita.Picture()
        XCTAssertNil(picture.fileURL)
        picture.setFilename("/tmp/swift-adwaita-picture-fixture.png")
        XCTAssertTrue(picture.fileURL?.path(percentEncoded: false) == "/tmp/swift-adwaita-picture-fixture.png")
        picture.setFilename(nil)
        XCTAssertNil(picture.fileURL)
    }

    @MainActor func test_pictureHasPaintableFlipsWithSetPaintable() {
        ensureAdwInit()
        let picture = Adwaita.Picture()
        XCTAssertFalse(picture.hasPaintable)
        let rgba: [UInt8] = [255, 0, 0, 255, 0, 255, 0, 255]
        let texture = Texture(rgbaData: rgba, width: 2, height: 1)
        picture.setPaintable(texture)
        XCTAssertTrue(picture.hasPaintable)
        picture.setPaintable(nil)
        XCTAssertFalse(picture.hasPaintable)
    }

    @MainActor func test_silenceSpuriousScrollbarWarningsIsIdempotent() {
        // The installer flips a global log writer, so we can't undo it in a
        // test — we just want to confirm the API exists and repeated calls
        // don't crash. The writer itself is exercised by application UI
        // smoke tests in downstream projects.
        MainContext.silenceSpuriousScrollbarWarnings()
        MainContext.silenceSpuriousScrollbarWarnings()
    }

    @MainActor func test_picturePaintablePointerChangesAcrossTextureSwap() {
        ensureAdwInit()
        let picture = Adwaita.Picture()
        XCTAssertNil(picture.paintablePointer)
        let first = Texture(rgbaData: [255, 0, 0, 255], width: 1, height: 1)
        picture.setPaintable(first)
        let firstPointer = picture.paintablePointer
        XCTAssertNotNil(firstPointer)
        let second = Texture(rgbaData: [0, 0, 255, 255], width: 1, height: 1)
        picture.setPaintable(second)
        let secondPointer = picture.paintablePointer
        XCTAssertNotNil(secondPointer)
        XCTAssertTrue(firstPointer != secondPointer)
    }

    @MainActor func test_picturePaintableIsSameMatchesInstalledTexture() {
        ensureAdwInit()
        let picture = Adwaita.Picture()
        let first = Texture(rgbaData: [255, 0, 0, 255], width: 1, height: 1)
        let second = Texture(rgbaData: [0, 0, 255, 255], width: 1, height: 1)

        XCTAssertTrue(!picture.paintableIsSame(as: first))

        picture.setPaintable(first)
        XCTAssertTrue(picture.paintableIsSame(as: first))
        XCTAssertTrue(!picture.paintableIsSame(as: second))

        picture.setPaintable(second)
        XCTAssertTrue(picture.paintableIsSame(as: second))
        XCTAssertTrue(!picture.paintableIsSame(as: first))

        picture.setPaintable(nil)
        XCTAssertTrue(!picture.paintableIsSame(as: first))
        XCTAssertTrue(!picture.paintableIsSame(as: second))
    }

    @MainActor func test_picturePaintableIdentityTracksSwaps() {
        ensureAdwInit()
        let picture = Adwaita.Picture()
        XCTAssertNil(picture.paintableIdentity)

        let first = Texture(rgbaData: [255, 0, 0, 255], width: 1, height: 1)
        picture.setPaintable(first)
        let firstIdentity = picture.paintableIdentity
        XCTAssertNotNil(firstIdentity)
        // The identity must remain equal while the same paintable is installed.
        XCTAssertTrue(picture.paintableIdentity == firstIdentity)

        let second = Texture(rgbaData: [0, 255, 0, 255], width: 1, height: 1)
        picture.setPaintable(second)
        XCTAssertTrue(picture.paintableIdentity != firstIdentity)

        picture.setPaintable(nil)
        XCTAssertNil(picture.paintableIdentity)
    }

    @MainActor func test_iconThemeForDisplayAcceptsSearchPath() throws {
        ensureAdwInit()
        let display = try XCTUnwrap(Display.default)
        let theme = IconTheme(for: display)
        theme.addSearchPath("/tmp/swift-adwaita-icon-theme-probe-does-not-exist")
        // Smoke test — the add call must not crash and the returned instance
        // should be the shared per-display icon theme.
        _ = theme
    }

    @MainActor func test_displayIconThemeConvenienceMatchesExplicit() throws {
        ensureAdwInit()
        let display = try XCTUnwrap(Display.default)
        // Both paths must produce usable instances pointing at the same
        // underlying GtkIconTheme (GTK returns the shared singleton).
        let viaConvenience = display.iconTheme
        let viaInit = IconTheme(for: display)
        XCTAssertTrue(viaConvenience.pointer == viaInit.pointer)
    }

}
#endif
