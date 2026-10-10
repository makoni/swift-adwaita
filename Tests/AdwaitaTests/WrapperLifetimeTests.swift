// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Testing
@testable import Adwaita
import CAdwaita

/// The first Swift wrapper of a GObject holds a toggle reference: it stays
/// alive while anything else references the object, and goes back to being
/// owned by Swift alone once nothing else does.
@Suite(.serialized)
struct WrapperLifetimeTests {

    @Test @MainActor func wrapperStaysAliveWhileParented() {
        ensureAdwInit()
        let box = Box()
        weak var weakLabel: Label?
        do {
            let label = Label("child")
            box.append(label)
            weakLabel = label
        }
        #expect(weakLabel != nil, "the parent keeps the label, so its wrapper must stay alive")
        #expect(weakLabel?.text == "child")
    }

    @Test @MainActor func unparentingFreesWrapperAndObject() {
        ensureAdwInit()
        let box = Box()
        weak var weakLabel: Label?
        var slot: WeakPointerSlot?
        do {
            let label = Label("child")
            box.append(label)
            weakLabel = label
            slot = WeakPointerSlot(watching: label.gobjectPointer)
        }
        if let label = weakLabel { box.remove(label) }
        spinMainLoop()
        #expect(weakLabel == nil, "nothing references the label any more, so its wrapper must go")
        #expect(slot?.isCleared == true, "and the GObject must finalize with it")
    }

    @Test @MainActor func unparentedObjectFreesWithItsWrapper() {
        ensureAdwInit()
        var slot: WeakPointerSlot?
        do {
            let label = Label("alone")
            slot = WeakPointerSlot(watching: label.gobjectPointer)
        }
        spinMainLoop()
        #expect(slot?.isCleared == true)
    }

    @Test @MainActor func weakCaptureInOwnHandlerFiresAndDoesNotLeak() {
        ensureAdwInit()
        let box = Box()
        var clickedWithButton = false
        var slot: WeakPointerSlot?
        do {
            let button = Button(label: "Tap")
            button.onClicked { [weak button] in
                clickedWithButton = button != nil
            }
            box.append(button)
            slot = WeakPointerSlot(watching: button.gobjectPointer)
        }
        box.firstChild?.cast(Button.self).emitClicked()
        #expect(clickedWithButton, "a [weak] capture must still see the button while it is on screen")

        if let child = box.firstChild { box.remove(child) }
        spinMainLoop()
        #expect(slot?.isCleared == true, "a [weak] self-capture must not keep the button alive")
    }

    @Test @MainActor func extraWrappersDoNotKeepObjectAlive() {
        ensureAdwInit()
        let box = Box()
        var slot: WeakPointerSlot?
        do {
            let label = Label("child")
            box.append(label)
            slot = WeakPointerSlot(watching: label.gobjectPointer)
        }
        // Secondary wrappers of the same object, created and dropped.
        for _ in 0 ..< 10 {
            _ = box.firstChild?.cast(Label.self).text
        }
        if let child = box.firstChild { box.remove(child) }
        spinMainLoop()
        #expect(slot?.isCleared == true, "dropped extra wrappers must not keep the label alive")
    }

    @Test @MainActor func objectFinalizesAfterAllWrappersAreGone() {
        ensureAdwInit()
        let box = Box()
        var slot: WeakPointerSlot?
        do {
            let label = Label("child")
            box.append(label)
            slot = WeakPointerSlot(watching: label.gobjectPointer)
            let second = box.firstChild
            box.remove(label)
            _ = second
        }
        spinMainLoop()
        #expect(slot?.isCleared == true, "no wrapper and no parent left, so the label must finalize")
    }

    @Test @MainActor func firstBorrowedWrapperOfACObjectStaysAlive() {
        ensureAdwInit()
        let box = Box()
        gtk_box_append(box.castedPointer(), gtk_label_new("from C"))
        weak var weakChild: Widget?
        do {
            weakChild = box.firstChild
        }
        #expect(weakChild != nil, "the first wrapper of a parented C-created widget must stay alive")
    }
}
#endif
