import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized) struct SignalLifecycleTests {

    // MARK: - Signal Triggering via Property Changes
    // Note: gtk_widget_activate() requires widgets to be realized (in a window).
    // In headless tests, we verify signals via property changes which trigger
    // GObject notify signals even without a visible window.

    @Test @MainActor func switchActiveChangeTriggersNotify() {
        ensureAdwInit()
        var notified = false
        let sw = Switch()
        sw.onActiveChanged { notified = true }
        sw.active = true
        #expect(notified, "onActiveChanged should fire when active property changes")
    }

    @Test @MainActor func switchMultipleNotifications() {
        ensureAdwInit()
        var count = 0
        let sw = Switch()
        sw.onActiveChanged { count += 1 }
        sw.active = true
        sw.active = false
        sw.active = true
        #expect(count == 3, "Notify should fire for each change")
    }

    @Test @MainActor func entryTextChangeTriggersNotify() {
        ensureAdwInit()
        var notified = false
        let entry = Entry()
        entry.onChanged { notified = true }
        entry.text = "hello"
        #expect(notified, "onChanged should fire when text property changes")
    }

    @Test @MainActor func entryMultipleTextChanges() {
        ensureAdwInit()
        var count = 0
        let entry = Entry()
        entry.onChanged { count += 1 }
        entry.text = "a"
        entry.text = "ab"
        entry.text = "abc"
        #expect(count == 3, "onChanged should fire for each text change")
    }

    @Test @MainActor func checkButtonActivateToggles() {
        ensureAdwInit()
        let cb = CheckButton()
        cb.active = false
        cb.active = true
        #expect(cb.active == true, "Setting active to true should toggle it")
    }

    @Test @MainActor func buttonClickedSignalViaEmit() {
        ensureAdwInit()
        var clicked = false
        let button = Button(label: "Test")
        button.onClicked { clicked = true }
        // Emit the "clicked" signal directly via GObject
        g_signal_emit_by_name_no_args(UnsafeMutableRawPointer(button.opaquePointer), "clicked")
        #expect(clicked, "onClicked handler should fire when clicked signal is emitted")
    }

    @Test @MainActor func buttonMultipleClickEmit() {
        ensureAdwInit()
        var count = 0
        let button = Button(label: "Test")
        button.onClicked { count += 1 }
        g_signal_emit_by_name_no_args(UnsafeMutableRawPointer(button.opaquePointer), "clicked")
        g_signal_emit_by_name_no_args(UnsafeMutableRawPointer(button.opaquePointer), "clicked")
        #expect(count == 2, "Handler should fire for each emit")
    }

    // MARK: - Signal Connection / Disconnection

    @Test @MainActor func signalConnectionDisconnect() {
        ensureAdwInit()
        var count = 0
        let sw = Switch()
        let conn = sw.onActiveChanged { count += 1 }
        sw.active = true
        #expect(count == 1)
        conn.disconnect()
        sw.active = false
        #expect(count == 1, "Handler should not fire after disconnect")
    }

    @Test @MainActor func signalDoubleDisconnectIsSafe() {
        ensureAdwInit()
        let button = Button(label: "Test")
        let conn = button.onClicked { }
        conn.disconnect()
        conn.disconnect() // Should not crash
    }

    @Test @MainActor func multipleSignalConnectionsIndependent() {
        ensureAdwInit()
        var a = 0, b = 0
        let sw = Switch()
        let connA = sw.onActiveChanged { a += 1 }
        sw.onActiveChanged { b += 1 }
        sw.active = true
        #expect(a == 1 && b == 1)
        connA.disconnect()
        sw.active = false
        #expect(a == 1, "Disconnected handler A should not fire")
        #expect(b == 2, "Handler B should still fire")
    }

    @Test @MainActor func notifySignalOnLabelPropertyChange() {
        ensureAdwInit()
        var notified = false
        let label = Label("initial")
        // GtkLabel's GObject property for text is "label"
        label.onNotify(.label) { notified = true }
        label.text = "changed"
        #expect(notified, "onNotify(.label) should fire when label text changes")
    }

    @Test @MainActor func notifySignalNotFiredForSameValue() {
        ensureAdwInit()
        var count = 0
        let sw = Switch()
        sw.active = false
        sw.onActiveChanged { count += 1 }
        sw.active = false // Same value
        #expect(count == 0, "Notify should not fire when value doesn't change")
    }

    @Test @MainActor func buttonClickedDisconnectStopsSignal() {
        ensureAdwInit()
        var count = 0
        let button = Button(label: "Test")
        let conn = button.onClicked { count += 1 }
        g_signal_emit_by_name_no_args(UnsafeMutableRawPointer(button.opaquePointer), "clicked")
        #expect(count == 1)
        conn.disconnect()
        g_signal_emit_by_name_no_args(UnsafeMutableRawPointer(button.opaquePointer), "clicked")
        #expect(count == 1, "Handler should not fire after disconnect")
    }

    // MARK: - Container Lifecycle

    @Test @MainActor func boxAppendRemoveChildren() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let label1 = Label("A")
        let label2 = Label("B")
        box.append(label1)
        box.append(label2)
        box.remove(label1)
        box.remove(label2)
    }

    @Test @MainActor func boxRemoveAllChildren() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        for i in 0..<10 {
            box.append(Label("\(i)"))
        }
        while let child = box.firstChild {
            box.remove(child)
        }
        #expect(box.firstChild == nil, "Box should have no children after removing all")
    }

    @Test @MainActor func listBoxAppendRemove() {
        ensureAdwInit()
        let list = ListBox()
        let label = Label("Item")
        list.append(label)
        list.remove(label)
    }

    @Test @MainActor func overlayAddRemoveOverlays() {
        ensureAdwInit()
        let overlay = Overlay()
        let base = Label("Base")
        overlay.child = base
        let badge = Label("Badge")
        overlay.addOverlay(badge)
        overlay.removeOverlay(badge)
    }

    @Test @MainActor func stackAddRemovePages() {
        ensureAdwInit()
        let stack = Stack()
        let page1 = Label("Page 1")
        let page2 = Label("Page 2")
        stack.addNamed(page1, name: "p1")
        stack.addNamed(page2, name: "p2")
        stack.visibleChildName = "p1"
        #expect(stack.visibleChildName == "p1")
        stack.visibleChildName = "p2"
        #expect(stack.visibleChildName == "p2")
        stack.remove(page1)
        stack.remove(page2)
    }

    @Test @MainActor func scrolledWindowSetAndClearChild() {
        ensureAdwInit()
        let scroll = ScrolledWindow()
        let label = Label("Content")
        scroll.child = label
        #expect(scroll.child != nil)
        scroll.child = nil
        #expect(scroll.child == nil)
    }

    // MARK: - Widget Tree Navigation

    @Test @MainActor func widgetParentAfterAppend() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let label = Label("Child")
        #expect(label.parent == nil, "Label should have no parent before append")
        box.append(label)
        #expect(label.parent != nil, "Label should have a parent after append")
    }

    @Test @MainActor func widgetParentNilAfterRemove() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let label = Label("Child")
        box.append(label)
        box.remove(label)
        #expect(label.parent == nil, "Label should have no parent after removal")
    }

    @Test @MainActor func widgetSiblingTraversal() {
        ensureAdwInit()
        let box = Box(orientation: .horizontal, spacing: 0)
        let a = Label("A")
        let b = Label("B")
        let c = Label("C")
        box.append(a)
        box.append(b)
        box.append(c)
        #expect(box.firstChild != nil)
        #expect(box.lastChild != nil)
        #expect(a.nextSibling != nil)
        #expect(c.prevSibling != nil)
    }

    // MARK: - CSS Class Management

    @Test @MainActor func addAndRemoveCSSClass() {
        ensureAdwInit()
        let label = Label("Test")
        label.addCSSClass("my-class")
        #expect(label.hasCSSClass("my-class"))
        label.removeCSSClass("my-class")
        #expect(!label.hasCSSClass("my-class"))
    }

    @Test @MainActor func typeSafeCSSClassAddRemove() {
        ensureAdwInit()
        let button = Button(label: "Test")
        button.addCSSClass(.suggestedAction)
        #expect(button.hasCSSClass(.suggestedAction))
        button.removeCSSClass(.suggestedAction)
        #expect(!button.hasCSSClass(.suggestedAction))
    }

    @Test @MainActor func multipleCSSClassesCoexist() {
        ensureAdwInit()
        let button = Button(label: "Test")
        button.addCSSClass(.pill)
        button.addCSSClass(.suggestedAction)
        #expect(button.hasCSSClass(.pill))
        #expect(button.hasCSSClass(.suggestedAction))
        button.removeCSSClass(.pill)
        #expect(!button.hasCSSClass(.pill))
        #expect(button.hasCSSClass(.suggestedAction))
    }
}
