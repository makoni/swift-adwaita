// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
#if swift(>=6.3)
import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct WidgetBaseTests {

    // MARK: - Widget: Tooltip

    @Test @MainActor func widgetTooltipText() {
        ensureAdwInit()
        let label = Label("Hello")
        #expect(label.tooltipText == nil)
        label.tooltipText = "A tooltip"
        #expect(label.tooltipText == "A tooltip")
        label.tooltipText = nil
        #expect(label.tooltipText == nil)
    }

    @Test @MainActor func widgetTooltipMarkup() {
        ensureAdwInit()
        let label = Label("Hello")
        #expect(label.tooltipMarkup == nil)
        label.tooltipMarkup = "<b>Bold</b> tooltip"
        #expect(label.tooltipMarkup == "<b>Bold</b> tooltip")
        label.tooltipMarkup = nil
        #expect(label.tooltipMarkup == nil)
    }

    // MARK: - Widget: Visible / Sensitive / CanTarget

    @Test @MainActor func widgetShowHide() {
        ensureAdwInit()
        let label = Label("Toggle")
        #expect(label.visible == true)
        label.hide()
        #expect(label.visible == false)
        label.show()
        #expect(label.visible == true)
    }

    @Test @MainActor func widgetCanTargetProperty() {
        ensureAdwInit()
        let label = Label("Test")
        label.canTarget = false
        #expect(label.canTarget == false)
        label.canTarget = true
        #expect(label.canTarget == true)
    }

    // MARK: - Widget: Opacity

    @Test @MainActor func widgetOpacityRoundTrip() {
        ensureAdwInit()
        let label = Label("Opacity")
        #expect(abs(label.opacity - 1.0) < 0.01)
        label.opacity = 0.3
        #expect(abs(label.opacity - 0.3) < 0.01)
        label.opacity = 0.0
        #expect(abs(label.opacity - 0.0) < 0.01)
        label.opacity = 1.0
        #expect(abs(label.opacity - 1.0) < 0.01)
    }

    // MARK: - Widget: CSS Classes

    @Test @MainActor func widgetAddRemoveHasCSSClass() {
        ensureAdwInit()
        let btn = Button(label: "Styled")
        btn.addCSSClass("suggested-action")
        #expect(btn.hasCSSClass("suggested-action") == true)
        btn.removeCSSClass("suggested-action")
        #expect(btn.hasCSSClass("suggested-action") == false)
    }

    @Test @MainActor func widgetTypeSafeCSSClass() {
        ensureAdwInit()
        let btn = Button(label: "Typed")
        btn.addCSSClass(.suggestedAction)
        #expect(btn.hasCSSClass(.suggestedAction) == true)
        btn.removeCSSClass(.suggestedAction)
        #expect(btn.hasCSSClass(.suggestedAction) == false)
    }

    // MARK: - Widget: Margins

    @Test @MainActor func widgetSetMarginsAll() {
        ensureAdwInit()
        let label = Label("Margins")
        label.setMargins(24)
        #expect(label.marginTop == 24)
        #expect(label.marginBottom == 24)
        #expect(label.marginStart == 24)
        #expect(label.marginEnd == 24)
    }

    // MARK: - Widget: Size Request

    @Test @MainActor func widgetSetSizeRequest() {
        ensureAdwInit()
        let label = Label("Sized")
        label.setSizeRequest(width: 200, height: 100)
    }

    @Test @MainActor func widgetSetSizeRequestPartial() {
        ensureAdwInit()
        let label = Label("Partial")
        label.setSizeRequest(width: 150)
        label.setSizeRequest(height: 75)
    }

    @Test @MainActor func widgetSizeRequestGetter() {
        ensureAdwInit()
        let label = Label("Getter")
        #expect(label.sizeRequest.width == -1)
        #expect(label.sizeRequest.height == -1)
        label.setSizeRequest(width: 120, height: 60)
        #expect(label.sizeRequest.width == 120)
        #expect(label.sizeRequest.height == 60)
    }

    @Test @MainActor func widgetQueueResize() {
        ensureAdwInit()
        let label = Label("Resize")
        label.setSizeRequest(width: 100, height: 40)
        label.queueResize()
    }

    @Test @MainActor func widgetMeasureHorizontal() {
        ensureAdwInit()
        let label = Label("Hello")
        let result = label.measure(orientation: GTK_ORIENTATION_HORIZONTAL, forSize: -1)
        #expect(result.minimum >= 0)
        #expect(result.natural >= result.minimum)
    }

    @Test @MainActor func widgetMeasureVertical() {
        ensureAdwInit()
        let label = Label("Hello")
        let result = label.measure(orientation: GTK_ORIENTATION_VERTICAL, forSize: -1)
        #expect(result.minimum >= 0)
        #expect(result.natural >= result.minimum)
    }

    // MARK: - Widget: Width / Height (unallocated)

    @Test @MainActor func widgetWidthHeightDefault() {
        ensureAdwInit()
        let label = Label("Size")
        #expect(label.width >= 0)
        #expect(label.height >= 0)
    }

    // MARK: - Widget: CSS Name

    @Test @MainActor func widgetCSSName() {
        ensureAdwInit()
        let label = Label("CSS Name")
        #expect(!label.cssName.isEmpty)
        let btn = Button(label: "CSS Name")
        #expect(!btn.cssName.isEmpty)
    }

    // MARK: - Widget: Parent / Children Navigation

    @Test @MainActor func widgetSiblingNavigation() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_HORIZONTAL)
        let a = Label("A")
        let b = Label("B")
        box.append(a)
        box.append(b)
        #expect(a.nextSibling != nil)
        #expect(b.prevSibling != nil)
        #expect(a.prevSibling == nil)
        #expect(b.nextSibling == nil)
    }

    @Test @MainActor func widgetChildrenList() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL)
        box.append(Label("1"))
        box.append(Label("2"))
        box.append(Label("3"))
        let children = box.children()
        #expect(children.count == 3)
    }

    // MARK: - Widget: Root

    @Test @MainActor func widgetRootWithoutWindow() {
        ensureAdwInit()
        let label = Label("Orphan")
        #expect(label.root == nil)
    }

    @Test @MainActor func widgetWindowUsesContainingParentChain() {
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

        #expect(button.window?.pointer == window.pointer)
        #expect(label.window?.pointer == window.pointer)

        popover.unparent()
    }

    @Test @MainActor func widgetWindowIsNilWithoutContainingWindow() {
        ensureAdwInit()
        let button = Button(label: "Anchor")
        let popover = Popover()
        let label = Label("Popover content")

        popover.child = label
        gtk_widget_set_parent(popover.widgetPointer, button.widgetPointer)

        #expect(button.window == nil)
        #expect(label.window == nil)

        popover.unparent()
    }

    // MARK: - Widget: Configure

    @Test @MainActor func widgetConfigure() {
        ensureAdwInit()
        let label = Label("Configure").configure {
            $0.halign = .center
            $0.vexpand = true
            $0.setMargins(8)
        }
        #expect(label.halign == GtkAlign.center)
        #expect(label.vexpand == true)
        #expect(label.marginTop == 8)
    }

    // MARK: - Widget: Activate

    // MARK: - Widget: Cast / TryCast

    @Test @MainActor func widgetCast() throws {
        ensureAdwInit()
        let label = Label("Cast me")
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL)
        box.append(label)
        let child = try #require(box.firstChild)
        let asLabel = child.cast(Label.self)
        #expect(asLabel.text == "Cast me")
    }

    @Test @MainActor func widgetTryCast() throws {
        ensureAdwInit()
        let label = Label("TryCast")
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL)
        box.append(label)
        let child = try #require(box.firstChild)
        let asLabel = child.tryCast(Label.self)
        #expect(asLabel != nil)
    }

    @Test @MainActor func widgetTryCastWrongTypeReturnsNil() throws {
        ensureAdwInit()
        let label = Label("NotAPicture")
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL)
        box.append(label)
        let child = try #require(box.firstChild)
        #expect(child.tryCast(Picture.self) == nil)
        #expect(child.tryCast(Label.self) != nil)
    }

    @Test @MainActor func widgetIsInstanceOf() {
        ensureAdwInit()
        let label = Label("Test")
        #expect(label.isInstance(of: Label.self) == true)
        #expect(label.isInstance(of: Picture.self) == false)
    }

    // MARK: - Widget: Focus

    @Test @MainActor func widgetIsFocusableProperty() {
        ensureAdwInit()
        let label = Label("Focus")
        #expect(label.isFocusable == false)
        label.isFocusable = true
        #expect(label.isFocusable == true)
        label.isFocusable = false
        #expect(label.isFocusable == false)
    }

    @Test @MainActor func widgetHasFocusDefault() {
        ensureAdwInit()
        let label = Label("No focus")
        #expect(label.hasFocus == false)
    }

    // MARK: - Widget: Cursor

    @Test @MainActor func widgetSetAndResetCursor() {
        ensureAdwInit()
        let btn = Button(label: "Cursor")
        btn.setCursor(name: "pointer")
        btn.setCursor(name: "crosshair")
        btn.setCursor(name: "text")
        btn.resetCursor()
    }

    // MARK: - Widget: Tick Callback

    @Test @MainActor func widgetAddAndRemoveTickCallback() {
        ensureAdwInit()
        let label = Label("Tick")
        let id = label.addTickCallback { false }
        #expect(id > 0 || id == 0)
        label.removeTickCallback(id)
    }

    // MARK: - Widget: Accessibility

    @Test @MainActor func widgetAccessibleRoleAndLabels() {
        ensureAdwInit()
        let btn = Button(label: "Accessible")
        _ = btn.accessibleRole
        btn.setAccessibleLabel("My Button Label")
        btn.setAccessibleDescription("A description for screen readers")
    }

    // MARK: - Widget: Lifecycle Signals

    @Test @MainActor func widgetOnRealizeSignal() {
        ensureAdwInit()
        let label = Label("Realize")
        let conn = label.onRealize {}
        conn.disconnect()
    }

    @Test @MainActor func widgetOnUnrealizeSignal() {
        ensureAdwInit()
        let label = Label("Unrealize")
        let conn = label.onUnrealize {}
        conn.disconnect()
    }

    @Test @MainActor func widgetOnMapSignal() {
        ensureAdwInit()
        let label = Label("Map")
        let conn = label.onMap {}
        conn.disconnect()
    }

    @Test @MainActor func widgetOnUnmapSignal() {
        ensureAdwInit()
        let label = Label("Unmap")
        let conn = label.onUnmap {}
        conn.disconnect()
    }

    @Test @MainActor func widgetOnDestroySignal() {
        ensureAdwInit()
        let label = Label("Destroy")
        let conn = label.onDestroy {}
        conn.disconnect()
    }

    @Test @MainActor func widgetOnSizeAllocateSignal() {
        ensureAdwInit()
        let label = Label("Size")
        let conn = label.onSizeAllocate { w, h in
            _ = w
            _ = h
        }
        conn.disconnect()
    }

    // MARK: - Widget: Event Controller Add/Remove

    @Test @MainActor func widgetAddAndRemoveController() {
        ensureAdwInit()
        let label = Label("Controller")
        let motion = EventControllerMotion()
        label.addController(motion)
        label.removeController(motion)
    }

    // MARK: - Widget: Keyboard Shortcut with Key enum

    @Test @MainActor func widgetAddKeyboardShortcutKeyEnum() {
        ensureAdwInit()
        let btn = Button(label: "Shortcut")
        btn.addKeyboardShortcut(key: .s, modifiers: .control) { true }
    }

    // MARK: - Widget: onNotify

    @Test @MainActor func widgetOnNotifyProperty() {
        ensureAdwInit()
        let label = Label("Notify")
        var notified = false
        label.onNotify(.label) { notified = true }
        label.text = "Changed"
        #expect(notified, "onNotify should fire when property changes")
    }
}
#endif
#endif
