import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct GtkWidgetTests {

    // MARK: - GMenu and Actions Tests

    @Test @MainActor func gmenuCreationAndAppend() {
        ensureAdwInit()
        let menu = GMenuRef()
        menu.append("Quit", action: "app.quit")
        menu.append("About", action: "app.about")
        // Should not crash
        #expect(menu.pointer != nil)
    }

    @Test @MainActor func gmenuSectionAndSubmenu() {
        ensureAdwInit()
        let menu = GMenuRef()
        let section = GMenuRef()
        section.append("Cut", action: "app.cut")
        section.append("Copy", action: "app.copy")
        menu.appendSection("Edit", section: section)

        let submenu = GMenuRef()
        submenu.append("Zoom In", action: "app.zoom-in")
        menu.appendSubmenu("View", submenu: submenu)
        #expect(menu.pointer != nil)
    }

    @Test @MainActor func gmenuItemWithIcon() {
        ensureAdwInit()
        let item = GMenuItemRef(label: "Open", action: "app.open")
        item.setIconName("document-open-symbolic")
        item.setLabel("Open File")
        #expect(item.pointer != nil)
    }

    @Test @MainActor func simpleActionCreation() {
        ensureAdwInit()
        let action = SimpleAction(name: "test")
        #expect(action.enabled == true)
        action.enabled = false
        #expect(action.enabled == false)
    }

    @Test @MainActor func simpleActionSignal() {
        ensureAdwInit()
        let action = SimpleAction(name: "click")
        let conn = action.onActivate {}
        conn.disconnect()
    }

    @Test @MainActor func menuButtonWithModel() {
        ensureAdwInit()
        let menu = GMenuRef()
        menu.append("Item 1", action: "app.item1")
        let btn = MenuButton()
        btn.setMenuModel(menu)
        #expect(btn.pointer != nil)
    }

    // MARK: - New GTK Widget Tests

    @Test @MainActor func progressBarProperties() {
        ensureAdwInit()
        let pb = ProgressBar()
        pb.fraction = 0.75
        #expect(pb.fraction == 0.75)
        pb.showText = true
        #expect(pb.showText == true)
        pb.text = "75%"
        #expect(pb.text == "75%")
        pb.inverted = true
        #expect(pb.inverted == true)
    }

    @Test @MainActor func progressBarPulse() {
        ensureAdwInit()
        let pb = ProgressBar()
        pb.pulseStep = 0.1
        #expect(pb.pulseStep == 0.1)
        pb.pulse()
        // Should not crash
        #expect(pb.pointer != nil)
    }

    @Test @MainActor func scaleProperties() {
        ensureAdwInit()
        let scale = Scale(orientation: GTK_ORIENTATION_HORIZONTAL, min: 0, max: 100, step: 1)
        scale.value = 50
        #expect(scale.value == 50)
        scale.drawValue = true
        #expect(scale.drawValue == true)
        scale.hasOrigin = true
        #expect(scale.hasOrigin == true)
        scale.digits = 0
        #expect(scale.digits == 0)
    }

    @Test @MainActor func scaleInverted() {
        ensureAdwInit()
        let scale = Scale(orientation: GTK_ORIENTATION_HORIZONTAL, min: 0, max: 10, step: 1)
        scale.inverted = true
        #expect(scale.inverted == true)
    }

    @Test @MainActor func levelBarProperties() {
        ensureAdwInit()
        let lb = LevelBar(min: 0, max: 10)
        lb.value = 7
        #expect(lb.value == 7)
        #expect(lb.minValue == 0)
        #expect(lb.maxValue == 10)
        lb.inverted = true
        #expect(lb.inverted == true)
    }

    @Test @MainActor func textViewProperties() {
        ensureAdwInit()
        let tv = TextView()
        tv.text = "Hello, World!"
        #expect(tv.text == "Hello, World!")
        tv.editable = false
        #expect(tv.editable == false)
        tv.monospace = true
        #expect(tv.monospace == true)
        tv.cursorVisible = false
        #expect(tv.cursorVisible == false)
    }

    @Test @MainActor func textViewMargins() {
        ensureAdwInit()
        let tv = TextView()
        tv.leftMargin = 10
        tv.rightMargin = 10
        tv.topMargin = 5
        tv.bottomMargin = 5
        #expect(tv.leftMargin == 10)
        #expect(tv.rightMargin == 10)
        #expect(tv.topMargin == 5)
        #expect(tv.bottomMargin == 5)
    }

    @Test @MainActor func stringListOperations() {
        ensureAdwInit()
        let sl = StringList(["Alpha", "Beta", "Gamma"])
        #expect(sl.count == 3)
        #expect(sl.getString(0) == "Alpha")
        #expect(sl.getString(1) == "Beta")
        #expect(sl.getString(2) == "Gamma")
        sl.append("Delta")
        #expect(sl.count == 4)
        sl.remove(1)
        #expect(sl.count == 3)
        #expect(sl.getString(1) == "Gamma")
    }

    @Test @MainActor func cssProviderLoadFromString() {
        ensureAdwInit()
        let css = CSSProvider()
        css.loadFromString("button { color: red; }")
        css.addToDefaultDisplay()
        css.removeFromDefaultDisplay()
    }

    @Test @MainActor func gtkEnumsAreAccessible() {
        _ = GTK_ORIENTATION_HORIZONTAL
        _ = GTK_ORIENTATION_VERTICAL
        _ = GTK_ALIGN_START
        _ = GTK_ALIGN_CENTER
        _ = GTK_ALIGN_END
        _ = GTK_ALIGN_FILL
        _ = GTK_SELECTION_NONE
        _ = GTK_SELECTION_SINGLE
        _ = GTK_SELECTION_MULTIPLE
        #expect(Bool(true), "All key GTK enums are accessible")
    }

    // MARK: - Event Controller Tests

    @Test @MainActor func gestureClickCreation() {
        ensureAdwInit()
        let gesture = GestureClick()
        #expect(gesture.pointer != nil)
    }

    @Test @MainActor func gestureClickSignalConnection() {
        ensureAdwInit()
        let gesture = GestureClick()
        let conn1 = gesture.onPressed { _, _, _ in }
        let conn2 = gesture.onReleased { _, _, _ in }
        // Signal handlers should be connected without crashing
        conn1.disconnect()
        conn2.disconnect()
    }

    @Test @MainActor func gestureClickAddToWidget() {
        ensureAdwInit()
        let btn = Button(label: "Test")
        let gesture = GestureClick()
        btn.addController(gesture)
        // Should not crash
        #expect(Bool(true))
    }

    @Test @MainActor func eventControllerKeyCreation() {
        ensureAdwInit()
        let controller = EventControllerKey()
        #expect(controller.pointer != nil)
    }

    @Test @MainActor func eventControllerKeySignalConnection() {
        ensureAdwInit()
        let controller = EventControllerKey()
        let conn1 = controller.onKeyPressed { _, _, _ in false }
        let conn2 = controller.onKeyReleased { _, _, _ in }
        conn1.disconnect()
        conn2.disconnect()
    }

    @Test @MainActor func eventControllerKeyAddToWidget() {
        ensureAdwInit()
        let entry = Entry()
        let controller = EventControllerKey()
        entry.addController(controller)
        #expect(Bool(true))
    }

    @Test @MainActor func eventControllerMotionCreation() {
        ensureAdwInit()
        let controller = EventControllerMotion()
        #expect(controller.pointer != nil)
    }

    @Test @MainActor func eventControllerMotionSignalConnection() {
        ensureAdwInit()
        let controller = EventControllerMotion()
        let conn1 = controller.onMotion { _, _ in }
        let conn2 = controller.onEnter { _, _ in }
        let conn3 = controller.onLeave {}
        conn1.disconnect()
        conn2.disconnect()
        conn3.disconnect()
    }

    @Test @MainActor func eventControllerMotionAddToWidget() {
        ensureAdwInit()
        let label = Label("Hover me")
        let controller = EventControllerMotion()
        label.addController(controller)
        #expect(Bool(true))
    }

    @Test @MainActor func eventControllerScrollCreation() {
        ensureAdwInit()
        let controller = EventControllerScroll()
        #expect(controller.pointer != nil)
    }

    @Test @MainActor func eventControllerScrollWithFlags() {
        ensureAdwInit()
        let controller = EventControllerScroll(flags: GTK_EVENT_CONTROLLER_SCROLL_VERTICAL)
        #expect(controller.pointer != nil)
    }

    @Test @MainActor func eventControllerScrollSignalConnection() {
        ensureAdwInit()
        let controller = EventControllerScroll()
        let conn1 = controller.onScroll { _, _ in false }
        let conn2 = controller.onScrollBegin {}
        let conn3 = controller.onScrollEnd {}
        conn1.disconnect()
        conn2.disconnect()
        conn3.disconnect()
    }

    @Test @MainActor func eventControllerScrollAddToWidget() {
        ensureAdwInit()
        let box = Box()
        let controller = EventControllerScroll()
        box.addController(controller)
        #expect(Bool(true))
    }

    @Test @MainActor func multipleControllersOnOneWidget() {
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
        #expect(Bool(true))
    }

    @Test @MainActor func eventControllerInheritance() {
        #expect(isSubclass(GestureClick.self, of: GObjectRef.self))
        #expect(isSubclass(EventControllerKey.self, of: GObjectRef.self))
        #expect(isSubclass(EventControllerMotion.self, of: GObjectRef.self))
        #expect(isSubclass(EventControllerScroll.self, of: GObjectRef.self))
    }

    // MARK: - Window onCloseRequest Signal

    @Test @MainActor func windowOnCloseRequestSignalConnection() {
        ensureAdwInit()
        let window = Window()
        let conn = window.onCloseRequest { true }
        conn.disconnect()
    }

    // MARK: - Widget Lifecycle Signals

    @Test @MainActor func widgetLifecycleSignalConnections() {
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

    @Test @MainActor func buttonConvenienceInitWithLabel() {
        ensureAdwInit()
        var clicked = false
        let btn = Button(label: "Click", onClicked: { clicked = true })
        #expect(btn.label == "Click")
        // The handler is connected; we cannot easily trigger it without a main loop,
        // but we verify the button was created with the correct label.
    }

    @Test @MainActor func buttonConvenienceInitWithIcon() {
        ensureAdwInit()
        let btn = Button(iconName: "edit-copy-symbolic", onClicked: {})
        #expect(btn.iconName == "edit-copy-symbolic")
    }

    // MARK: - SpringParams Properties

    @Test @MainActor func springParamsProperties() {
        ensureAdwInit()
        let sp = SpringParams(dampingRatio: 0.8, mass: 1.0, stiffness: 100.0)
        #expect(sp.dampingRatio == 0.8)
        #expect(sp.mass == 1.0)
        #expect(sp.stiffness == 100.0)
        #expect(sp.damping > 0)
    }

    @Test @MainActor func springParamsFullInit() {
        ensureAdwInit()
        let sp = SpringParams(damping: 10.0, mass: 2.0, stiffness: 50.0)
        #expect(sp.damping == 10.0)
        #expect(sp.mass == 2.0)
        #expect(sp.stiffness == 50.0)
    }

    // MARK: - BreakpointCondition

    @Test @MainActor func breakpointConditionParseAndToString() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "min-width: 600px")
        let str = cond.toString()
        #expect(str.contains("600"))
    }

    @Test @MainActor func breakpointConditionLength() {
        ensureAdwInit()
        let cond = BreakpointCondition.length(
            type: ADW_BREAKPOINT_CONDITION_MIN_WIDTH,
            value: 400,
            unit: .px
        )
        let str = cond.toString()
        #expect(str.contains("400"))
    }

    @Test @MainActor func breakpointConditionAnd() {
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
        #expect(str.contains("400"))
        #expect(str.contains("800"))
    }

    // MARK: - Enum Extensions

    @Test @MainActor func gtkOrientationEnumExtensions() {
        #expect(GtkOrientation.vertical == GTK_ORIENTATION_VERTICAL)
        #expect(GtkOrientation.horizontal == GTK_ORIENTATION_HORIZONTAL)
    }

    @Test @MainActor func gtkAlignEnumExtensions() {
        #expect(GtkAlign.fill == GTK_ALIGN_FILL)
        #expect(GtkAlign.start == GTK_ALIGN_START)
        #expect(GtkAlign.end == GTK_ALIGN_END)
        #expect(GtkAlign.center == GTK_ALIGN_CENTER)
    }

    @Test @MainActor func gtkSelectionModeEnumExtensions() {
        #expect(GtkSelectionMode.none == GTK_SELECTION_NONE)
        #expect(GtkSelectionMode.single == GTK_SELECTION_SINGLE)
        #expect(GtkSelectionMode.multiple == GTK_SELECTION_MULTIPLE)
    }

    @Test @MainActor func adwColorSchemeEnumExtensions() {
        // Verify the extensions exist and are distinct
        let d = AdwColorScheme.default
        let fd = AdwColorScheme.forceDark
        let fl = AdwColorScheme.forceLight
        #expect(fd != fl)
        #expect(d != fd)
    }

    // MARK: - SignalHelper connectReturnBool

    @Test @MainActor func signalHelperConnectReturnBoolExists() {
        let _: (GObjectRef, SignalName, @escaping @MainActor () -> Bool) -> SignalConnection = SignalHelper
            .connectReturnBool
    }

    @Test @MainActor func buttonGtkTypeNarrowsFromGenericWidget() {
        ensureAdwInit()
        let button: Widget = Button(label: "OK")
        let label: Widget = Label("Plain")
        #expect(button.isInstance(of: Button.self))
        #expect(!label.isInstance(of: Button.self))
        #expect(button.tryCast(Button.self) != nil)
        #expect(label.tryCast(Button.self) == nil)
    }

    @Test @MainActor func boxGtkTypeNarrowsFromGenericWidget() {
        ensureAdwInit()
        let box: Widget = Box(orientation: GTK_ORIENTATION_HORIZONTAL)
        let label: Widget = Label("Plain")
        #expect(box.isInstance(of: Box.self))
        #expect(!label.isInstance(of: Box.self))
        #expect(box.tryCast(Box.self) != nil)
        #expect(label.tryCast(Box.self) == nil)
    }

    @Test @MainActor func boxOrientationReflectsInitOrientation() {
        ensureAdwInit()
        let horizontal = Box(orientation: GTK_ORIENTATION_HORIZONTAL)
        let vertical = Box(orientation: GTK_ORIENTATION_VERTICAL)
        #expect(horizontal.orientation == GTK_ORIENTATION_HORIZONTAL)
        #expect(vertical.orientation == GTK_ORIENTATION_VERTICAL)
    }

    @Test @MainActor func pictureFileURLTracksSetFilename() {
        ensureAdwInit()
        let picture = Picture()
        #expect(picture.fileURL == nil)
        picture.setFilename("/tmp/swift-adwaita-picture-fixture.png")
        #expect(picture.fileURL?.path(percentEncoded: false) == "/tmp/swift-adwaita-picture-fixture.png")
        picture.setFilename(nil)
        #expect(picture.fileURL == nil)
    }

    @Test @MainActor func pictureHasPaintableFlipsWithSetPaintable() {
        ensureAdwInit()
        let picture = Picture()
        #expect(!picture.hasPaintable)
        let rgba: [UInt8] = [255, 0, 0, 255, 0, 255, 0, 255]
        let texture = Texture(rgbaData: rgba, width: 2, height: 1)
        picture.setPaintable(texture)
        #expect(picture.hasPaintable)
        picture.setPaintable(nil)
        #expect(!picture.hasPaintable)
    }

    @Test @MainActor func silenceSpuriousScrollbarWarningsIsIdempotent() {
        // The installer flips a global log writer, so we can't undo it in a
        // test — we just want to confirm the API exists and repeated calls
        // don't crash. The writer itself is exercised by application UI
        // smoke tests in downstream projects.
        MainContext.silenceSpuriousScrollbarWarnings()
        MainContext.silenceSpuriousScrollbarWarnings()
    }

    @Test @MainActor func picturePaintablePointerChangesAcrossTextureSwap() {
        ensureAdwInit()
        let picture = Picture()
        #expect(picture.paintablePointer == nil)
        let first = Texture(rgbaData: [255, 0, 0, 255], width: 1, height: 1)
        picture.setPaintable(first)
        let firstPointer = picture.paintablePointer
        #expect(firstPointer != nil)
        let second = Texture(rgbaData: [0, 0, 255, 255], width: 1, height: 1)
        picture.setPaintable(second)
        let secondPointer = picture.paintablePointer
        #expect(secondPointer != nil)
        #expect(firstPointer != secondPointer)
    }

}
