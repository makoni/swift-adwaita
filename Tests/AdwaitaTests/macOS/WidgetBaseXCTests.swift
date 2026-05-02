#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class WidgetBaseXCTests: XCTestCase {

    // MARK: - Widget: Tooltip

    @MainActor func test_widgetTooltipText() {
        ensureAdwInit()
        let label = Label("Hello")
        XCTAssertNil(label.tooltipText)
        label.tooltipText = "A tooltip"
        XCTAssertTrue(label.tooltipText == "A tooltip")
        label.tooltipText = nil
        XCTAssertNil(label.tooltipText)
    }

    @MainActor func test_widgetTooltipMarkup() {
        ensureAdwInit()
        let label = Label("Hello")
        XCTAssertNil(label.tooltipMarkup)
        label.tooltipMarkup = "<b>Bold</b> tooltip"
        XCTAssertTrue(label.tooltipMarkup == "<b>Bold</b> tooltip")
        label.tooltipMarkup = nil
        XCTAssertNil(label.tooltipMarkup)
    }

    // MARK: - Widget: Visible / Sensitive / CanTarget

    @MainActor func test_widgetShowHide() {
        ensureAdwInit()
        let label = Label("Toggle")
        XCTAssertTrue(label.visible == true)
        label.hide()
        XCTAssertTrue(label.visible == false)
        label.show()
        XCTAssertTrue(label.visible == true)
    }

    @MainActor func test_widgetCanTargetProperty() {
        ensureAdwInit()
        let label = Label("Test")
        label.canTarget = false
        XCTAssertTrue(label.canTarget == false)
        label.canTarget = true
        XCTAssertTrue(label.canTarget == true)
    }

    // MARK: - Widget: Opacity

    @MainActor func test_widgetOpacityRoundTrip() {
        ensureAdwInit()
        let label = Label("Opacity")
        XCTAssertTrue(abs(label.opacity - 1.0) < 0.01)
        label.opacity = 0.3
        XCTAssertTrue(abs(label.opacity - 0.3) < 0.01)
        label.opacity = 0.0
        XCTAssertTrue(abs(label.opacity - 0.0) < 0.01)
        label.opacity = 1.0
        XCTAssertTrue(abs(label.opacity - 1.0) < 0.01)
    }

    // MARK: - Widget: CSS Classes

    @MainActor func test_widgetAddRemoveHasCSSClass() {
        ensureAdwInit()
        let btn = Button(label: "Styled")
        btn.addCSSClass("suggested-action")
        XCTAssertTrue(btn.hasCSSClass("suggested-action") == true)
        btn.removeCSSClass("suggested-action")
        XCTAssertTrue(btn.hasCSSClass("suggested-action") == false)
    }

    @MainActor func test_widgetTypeSafeCSSClass() {
        ensureAdwInit()
        let btn = Button(label: "Typed")
        btn.addCSSClass(.suggestedAction)
        XCTAssertTrue(btn.hasCSSClass(.suggestedAction) == true)
        btn.removeCSSClass(.suggestedAction)
        XCTAssertTrue(btn.hasCSSClass(.suggestedAction) == false)
    }

    // MARK: - Widget: Margins

    @MainActor func test_widgetSetMarginsAll() {
        ensureAdwInit()
        let label = Label("Margins")
        label.setMargins(24)
        XCTAssertTrue(label.marginTop == 24)
        XCTAssertTrue(label.marginBottom == 24)
        XCTAssertTrue(label.marginStart == 24)
        XCTAssertTrue(label.marginEnd == 24)
    }

    // MARK: - Widget: Size Request

    @MainActor func test_widgetSetSizeRequest() {
        ensureAdwInit()
        let label = Label("Sized")
        label.setSizeRequest(width: 200, height: 100)
    }

    @MainActor func test_widgetSetSizeRequestPartial() {
        ensureAdwInit()
        let label = Label("Partial")
        label.setSizeRequest(width: 150)
        label.setSizeRequest(height: 75)
    }

    @MainActor func test_widgetSizeRequestGetter() {
        ensureAdwInit()
        let label = Label("Getter")
        XCTAssertTrue(label.sizeRequest.width == -1)
        XCTAssertTrue(label.sizeRequest.height == -1)
        label.setSizeRequest(width: 120, height: 60)
        XCTAssertTrue(label.sizeRequest.width == 120)
        XCTAssertTrue(label.sizeRequest.height == 60)
    }

    @MainActor func test_widgetQueueResize() {
        ensureAdwInit()
        let label = Label("Resize")
        label.setSizeRequest(width: 100, height: 40)
        label.queueResize()
    }

    @MainActor func test_widgetMeasureHorizontal() {
        ensureAdwInit()
        let label = Label("Hello")
        let result = label.measure(orientation: GTK_ORIENTATION_HORIZONTAL, forSize: -1)
        XCTAssertTrue(result.minimum >= 0)
        XCTAssertTrue(result.natural >= result.minimum)
    }

    @MainActor func test_widgetMeasureVertical() {
        ensureAdwInit()
        let label = Label("Hello")
        let result = label.measure(orientation: GTK_ORIENTATION_VERTICAL, forSize: -1)
        XCTAssertTrue(result.minimum >= 0)
        XCTAssertTrue(result.natural >= result.minimum)
    }

    // MARK: - Widget: Width / Height (unallocated)

    @MainActor func test_widgetWidthHeightDefault() {
        ensureAdwInit()
        let label = Label("Size")
        XCTAssertTrue(label.width >= 0)
        XCTAssertTrue(label.height >= 0)
    }

    // MARK: - Widget: CSS Name

    @MainActor func test_widgetCSSName() {
        ensureAdwInit()
        let label = Label("CSS Name")
        XCTAssertFalse(label.cssName.isEmpty)
        let btn = Button(label: "CSS Name")
        XCTAssertFalse(btn.cssName.isEmpty)
    }

    // MARK: - Widget: Parent / Children Navigation

    @MainActor func test_widgetSiblingNavigation() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_HORIZONTAL)
        let a = Label("A")
        let b = Label("B")
        box.append(a)
        box.append(b)
        XCTAssertNotNil(a.nextSibling)
        XCTAssertNotNil(b.prevSibling)
        XCTAssertNil(a.prevSibling)
        XCTAssertNil(b.nextSibling)
    }

    @MainActor func test_widgetChildrenList() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL)
        box.append(Label("1"))
        box.append(Label("2"))
        box.append(Label("3"))
        let children = box.children()
        XCTAssertTrue(children.count == 3)
    }

    // MARK: - Widget: Root

    @MainActor func test_widgetRootWithoutWindow() {
        ensureAdwInit()
        let label = Label("Orphan")
        XCTAssertNil(label.root)
    }

    @MainActor func test_widgetWindowUsesContainingParentChain() {
        ensureAdwInit()
        let window = Window()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL)
        let button = Button(label: "Anchor")
        let popover = Popover()
        let label = Label("Popover content")

        popover.child = label
        box.append(button)
        window.content = box

        gtk_widget_set_parent(popover.widgetPointer, button.widgetPointer)

        XCTAssertTrue(button.window?.pointer == window.pointer)
        XCTAssertTrue(label.window?.pointer == window.pointer)

        popover.unparent()
    }

    @MainActor func test_widgetWindowIsNilWithoutContainingWindow() {
        ensureAdwInit()
        let button = Button(label: "Anchor")
        let popover = Popover()
        let label = Label("Popover content")

        popover.child = label
        gtk_widget_set_parent(popover.widgetPointer, button.widgetPointer)

        XCTAssertNil(button.window)
        XCTAssertNil(label.window)

        popover.unparent()
    }

    // MARK: - Widget: Configure

    @MainActor func test_widgetConfigure() {
        ensureAdwInit()
        let label = Label("Configure").configure {
            $0.halign = .center
            $0.vexpand = true
            $0.setMargins(8)
        }
        XCTAssertTrue(label.halign == GtkAlign.center)
        XCTAssertTrue(label.vexpand == true)
        XCTAssertTrue(label.marginTop == 8)
    }

    // MARK: - Widget: Activate

    // MARK: - Widget: Cast / TryCast

    @MainActor func test_widgetCast() throws {
        ensureAdwInit()
        let label = Label("Cast me")
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL)
        box.append(label)
        let child = try XCTUnwrap(box.firstChild)
        let asLabel = child.cast(Label.self)
        XCTAssertTrue(asLabel.text == "Cast me")
    }

    @MainActor func test_widgetTryCast() throws {
        ensureAdwInit()
        let label = Label("TryCast")
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL)
        box.append(label)
        let child = try XCTUnwrap(box.firstChild)
        let asLabel = child.tryCast(Label.self)
        XCTAssertNotNil(asLabel)
    }

    @MainActor func test_widgetTryCastWrongTypeReturnsNil() throws {
        ensureAdwInit()
        let label = Label("NotAPicture")
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL)
        box.append(label)
        let child = try XCTUnwrap(box.firstChild)
        XCTAssertNil(child.tryCast(Picture.self))
        XCTAssertNotNil(child.tryCast(Label.self))
    }

    @MainActor func test_widgetIsInstanceOf() {
        ensureAdwInit()
        let label = Label("Test")
        XCTAssertTrue(label.isInstance(of: Label.self) == true)
        XCTAssertTrue(label.isInstance(of: Picture.self) == false)
    }

    // MARK: - Widget: Focus

    @MainActor func test_widgetIsFocusableProperty() {
        ensureAdwInit()
        let label = Label("Focus")
        XCTAssertTrue(label.isFocusable == false)
        label.isFocusable = true
        XCTAssertTrue(label.isFocusable == true)
        label.isFocusable = false
        XCTAssertTrue(label.isFocusable == false)
    }

    @MainActor func test_widgetHasFocusDefault() {
        ensureAdwInit()
        let label = Label("No focus")
        XCTAssertTrue(label.hasFocus == false)
    }

    // MARK: - Widget: Cursor

    @MainActor func test_widgetSetAndResetCursor() {
        ensureAdwInit()
        let btn = Button(label: "Cursor")
        btn.setCursor(name: "pointer")
        btn.setCursor(name: "crosshair")
        btn.setCursor(name: "text")
        btn.resetCursor()
    }

    // MARK: - Widget: Tick Callback

    @MainActor func test_widgetAddAndRemoveTickCallback() {
        ensureAdwInit()
        let label = Label("Tick")
        let id = label.addTickCallback { false }
        XCTAssertTrue(id > 0 || id == 0)
        label.removeTickCallback(id)
    }

    // MARK: - Widget: Accessibility

    @MainActor func test_widgetAccessibleRoleAndLabels() {
        ensureAdwInit()
        let btn = Button(label: "Accessible")
        _ = btn.accessibleRole
        btn.setAccessibleLabel("My Button Label")
        btn.setAccessibleDescription("A description for screen readers")
    }

    // MARK: - Widget: Lifecycle Signals

    @MainActor func test_widgetOnRealizeSignal() {
        ensureAdwInit()
        let label = Label("Realize")
        let conn = label.onRealize {}
        conn.disconnect()
    }

    @MainActor func test_widgetOnUnrealizeSignal() {
        ensureAdwInit()
        let label = Label("Unrealize")
        let conn = label.onUnrealize {}
        conn.disconnect()
    }

    @MainActor func test_widgetOnMapSignal() {
        ensureAdwInit()
        let label = Label("Map")
        let conn = label.onMap {}
        conn.disconnect()
    }

    @MainActor func test_widgetOnUnmapSignal() {
        ensureAdwInit()
        let label = Label("Unmap")
        let conn = label.onUnmap {}
        conn.disconnect()
    }

    @MainActor func test_widgetOnDestroySignal() {
        ensureAdwInit()
        let label = Label("Destroy")
        let conn = label.onDestroy {}
        conn.disconnect()
    }

    @MainActor func test_widgetOnSizeAllocateSignal() {
        ensureAdwInit()
        let label = Label("Size")
        let conn = label.onSizeAllocate { w, h in
            _ = w
            _ = h
        }
        conn.disconnect()
    }

    // MARK: - Widget: Event Controller Add/Remove

    @MainActor func test_widgetAddAndRemoveController() {
        ensureAdwInit()
        let label = Label("Controller")
        let motion = EventControllerMotion()
        label.addController(motion)
        label.removeController(motion)
    }

    // MARK: - Widget: Keyboard Shortcut with Key enum

    @MainActor func test_widgetAddKeyboardShortcutKeyEnum() {
        ensureAdwInit()
        let btn = Button(label: "Shortcut")
        btn.addKeyboardShortcut(key: .s, modifiers: .control) { true }
    }

    // MARK: - Widget: onNotify

    @MainActor func test_widgetOnNotifyProperty() {
        ensureAdwInit()
        let label = Label("Notify")
        var notified = false
        label.onNotify(.label) { notified = true }
        label.text = "Changed"
        XCTAssertTrue(notified, "onNotify should fire when property changes")
    }
}
#endif
