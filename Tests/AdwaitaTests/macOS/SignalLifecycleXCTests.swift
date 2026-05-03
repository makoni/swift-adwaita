// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class SignalLifecycleXCTests: XCTestCase {

    // MARK: - Signal Triggering via Property Changes

    // Note: gtk_widget_activate() requires widgets to be realized (in a window).
    // In headless tests, we verify signals via property changes which trigger
    // GObject notify signals even without a visible window.

    @MainActor func test_switchActiveChangeTriggersNotify() {
        ensureAdwInit()
        var notified = false
        let sw = Switch()
        sw.onActiveChanged { notified = true }
        sw.active = true
        XCTAssertTrue(notified, "onActiveChanged should fire when active property changes")
    }

    @MainActor func test_switchMultipleNotifications() {
        ensureAdwInit()
        var count = 0
        let sw = Switch()
        sw.onActiveChanged { count += 1 }
        sw.active = true
        sw.active = false
        sw.active = true
        XCTAssertTrue(count == 3, "Notify should fire for each change")
    }

    @MainActor func test_entryTextChangeTriggersNotify() {
        ensureAdwInit()
        var notified = false
        let entry = Entry()
        entry.onChanged { notified = true }
        entry.text = "hello"
        XCTAssertTrue(notified, "onChanged should fire when text property changes")
    }

    @MainActor func test_entryMultipleTextChanges() {
        ensureAdwInit()
        var count = 0
        let entry = Entry()
        entry.onChanged { count += 1 }
        entry.text = "a"
        entry.text = "ab"
        entry.text = "abc"
        XCTAssertTrue(count == 3, "onChanged should fire for each text change")
    }

    @MainActor func test_checkButtonActivateToggles() {
        ensureAdwInit()
        let cb = CheckButton()
        cb.active = false
        cb.active = true
        XCTAssertTrue(cb.active == true, "Setting active to true should toggle it")
    }

    @MainActor func test_buttonClickedSignalViaEmit() {
        ensureAdwInit()
        var clicked = false
        let button = Button(label: "Test")
        button.onClicked { clicked = true }
        // Emit the "clicked" signal directly via GObject
        g_signal_emit_by_name_no_args(UnsafeMutableRawPointer(button.opaquePointer), "clicked")
        XCTAssertTrue(clicked, "onClicked handler should fire when clicked signal is emitted")
    }

    @MainActor func test_buttonMultipleClickEmit() {
        ensureAdwInit()
        var count = 0
        let button = Button(label: "Test")
        button.onClicked { count += 1 }
        g_signal_emit_by_name_no_args(UnsafeMutableRawPointer(button.opaquePointer), "clicked")
        g_signal_emit_by_name_no_args(UnsafeMutableRawPointer(button.opaquePointer), "clicked")
        XCTAssertTrue(count == 2, "Handler should fire for each emit")
    }

    // MARK: - Signal Connection / Disconnection

    @MainActor func test_signalConnectionDisconnect() {
        ensureAdwInit()
        var count = 0
        let sw = Switch()
        let conn = sw.onActiveChanged { count += 1 }
        sw.active = true
        XCTAssertTrue(count == 1)
        conn.disconnect()
        sw.active = false
        XCTAssertTrue(count == 1, "Handler should not fire after disconnect")
    }

    @MainActor func test_signalDoubleDisconnectIsSafe() {
        ensureAdwInit()
        let button = Button(label: "Test")
        let conn = button.onClicked {}
        conn.disconnect()
        conn.disconnect() // Should not crash
    }

    @MainActor func test_multipleSignalConnectionsIndependent() {
        ensureAdwInit()
        var a = 0, b = 0
        let sw = Switch()
        let connA = sw.onActiveChanged { a += 1 }
        sw.onActiveChanged { b += 1 }
        sw.active = true
        XCTAssertTrue(a == 1 && b == 1)
        connA.disconnect()
        sw.active = false
        XCTAssertTrue(a == 1, "Disconnected handler A should not fire")
        XCTAssertTrue(b == 2, "Handler B should still fire")
    }

    @MainActor func test_notifySignalOnLabelPropertyChange() {
        ensureAdwInit()
        var notified = false
        let label = Label("initial")
        // GtkLabel's GObject property for text is "label"
        label.onNotify(.label) { notified = true }
        label.text = "changed"
        XCTAssertTrue(notified, "onNotify(.label) should fire when label text changes")
    }

    @MainActor func test_notifySignalNotFiredForSameValue() {
        ensureAdwInit()
        var count = 0
        let sw = Switch()
        sw.active = false
        sw.onActiveChanged { count += 1 }
        sw.active = false // Same value
        XCTAssertTrue(count == 0, "Notify should not fire when value doesn't change")
    }

    @MainActor func test_buttonClickedDisconnectStopsSignal() {
        ensureAdwInit()
        var count = 0
        let button = Button(label: "Test")
        let conn = button.onClicked { count += 1 }
        g_signal_emit_by_name_no_args(UnsafeMutableRawPointer(button.opaquePointer), "clicked")
        XCTAssertTrue(count == 1)
        conn.disconnect()
        g_signal_emit_by_name_no_args(UnsafeMutableRawPointer(button.opaquePointer), "clicked")
        XCTAssertTrue(count == 1, "Handler should not fire after disconnect")
    }

    // MARK: - Container Lifecycle

    @MainActor func test_boxAppendRemoveChildren() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let label1 = Label("A")
        let label2 = Label("B")
        box.append(label1)
        box.append(label2)
        box.remove(label1)
        box.remove(label2)
    }

    @MainActor func test_boxRemoveAllChildren() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        for i in 0 ..< 10 {
            box.append(Label("\(i)"))
        }
        while let child = box.firstChild {
            box.remove(child)
        }
        XCTAssertNil(box.firstChild, "Box should have no children after removing all")
    }

    @MainActor func test_listBoxAppendRemove() {
        ensureAdwInit()
        let list = ListBox()
        let label = Label("Item")
        list.append(label)
        list.remove(label)
    }

    @MainActor func test_overlayAddRemoveOverlays() {
        ensureAdwInit()
        let overlay = Overlay()
        let base = Label("Base")
        overlay.child = base
        let badge = Label("Badge")
        overlay.addOverlay(badge)
        overlay.removeOverlay(badge)
    }

    @MainActor func test_stackAddRemovePages() {
        ensureAdwInit()
        let stack = Stack()
        let page1 = Label("Page 1")
        let page2 = Label("Page 2")
        stack.addNamed(page1, name: "p1")
        stack.addNamed(page2, name: "p2")
        stack.visibleChildName = "p1"
        XCTAssertTrue(stack.visibleChildName == "p1")
        stack.visibleChildName = "p2"
        XCTAssertTrue(stack.visibleChildName == "p2")
        stack.remove(page1)
        stack.remove(page2)
    }

    @MainActor func test_scrolledWindowSetAndClearChild() {
        ensureAdwInit()
        let scroll = ScrolledWindow()
        let label = Label("Content")
        scroll.child = label
        XCTAssertNotNil(scroll.child)
        scroll.child = nil
        XCTAssertNil(scroll.child)
    }

    // MARK: - Widget Tree Navigation

    @MainActor func test_widgetParentAfterAppend() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let label = Label("Child")
        XCTAssertNil(label.parent, "Label should have no parent before append")
        box.append(label)
        XCTAssertNotNil(label.parent, "Label should have a parent after append")
    }

    @MainActor func test_widgetParentNilAfterRemove() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let label = Label("Child")
        box.append(label)
        box.remove(label)
        XCTAssertNil(label.parent, "Label should have no parent after removal")
    }

    @MainActor func test_widgetSiblingTraversal() {
        ensureAdwInit()
        let box = Box(orientation: .horizontal, spacing: 0)
        let a = Label("A")
        let b = Label("B")
        let c = Label("C")
        box.append(a)
        box.append(b)
        box.append(c)
        XCTAssertNotNil(box.firstChild)
        XCTAssertNotNil(box.lastChild)
        XCTAssertNotNil(a.nextSibling)
        XCTAssertNotNil(c.prevSibling)
    }

    // MARK: - CSS Class Management

    @MainActor func test_addAndRemoveCSSClass() {
        ensureAdwInit()
        let label = Label("Test")
        label.addCSSClass("my-class")
        XCTAssertTrue(label.hasCSSClass("my-class"))
        label.removeCSSClass("my-class")
        XCTAssertTrue(!label.hasCSSClass("my-class"))
    }

    @MainActor func test_typeSafeCSSClassAddRemove() {
        ensureAdwInit()
        let button = Button(label: "Test")
        button.addCSSClass(.suggestedAction)
        XCTAssertTrue(button.hasCSSClass(.suggestedAction))
        button.removeCSSClass(.suggestedAction)
        XCTAssertFalse(button.hasCSSClass(.suggestedAction))
    }

    @MainActor func test_multipleCSSClassesCoexist() {
        ensureAdwInit()
        let button = Button(label: "Test")
        button.addCSSClass(.pill)
        button.addCSSClass(.suggestedAction)
        XCTAssertTrue(button.hasCSSClass(.pill))
        XCTAssertTrue(button.hasCSSClass(.suggestedAction))
        button.removeCSSClass(.pill)
        XCTAssertFalse(button.hasCSSClass(.pill))
        XCTAssertTrue(button.hasCSSClass(.suggestedAction))
    }
}
#endif
