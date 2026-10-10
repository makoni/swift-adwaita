// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

/// The first Swift wrapper of a GObject holds a toggle reference: it stays
/// alive while anything else references the object, and goes back to being
/// owned by Swift alone once nothing else does.
final class WrapperLifetimeXCTests: XCTestCase {

    @MainActor func test_wrapperStaysAliveWhileParented() {
        ensureAdwInit()
        let box = Box()
        weak var weakLabel: Label?
        do {
            let label = Label("child")
            box.append(label)
            weakLabel = label
        }
        XCTAssertTrue(weakLabel != nil, "the parent keeps the label, so its wrapper must stay alive")
        XCTAssertTrue(weakLabel?.text == "child")
    }

    @MainActor func test_unparentingFreesWrapperAndObject() {
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
        XCTAssertTrue(weakLabel == nil, "nothing references the label any more, so its wrapper must go")
        XCTAssertTrue(slot?.isCleared == true, "and the GObject must finalize with it")
    }

    @MainActor func test_unparentedObjectFreesWithItsWrapper() {
        ensureAdwInit()
        var slot: WeakPointerSlot?
        do {
            let label = Label("alone")
            slot = WeakPointerSlot(watching: label.gobjectPointer)
        }
        spinMainLoop()
        XCTAssertTrue(slot?.isCleared == true)
    }

    @MainActor func test_weakCaptureInOwnHandlerFiresAndDoesNotLeak() {
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
        XCTAssertTrue(clickedWithButton, "a [weak] capture must still see the button while it is on screen")
        if let child = box.firstChild { box.remove(child) }
        spinMainLoop()
        XCTAssertTrue(slot?.isCleared == true, "a [weak] self-capture must not keep the button alive")
    }

    @MainActor func test_extraWrappersDoNotKeepObjectAlive() {
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
        XCTAssertTrue(slot?.isCleared == true, "dropped extra wrappers must not keep the label alive")
    }

    @MainActor func test_objectFinalizesAfterAllWrappersAreGone() {
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
        XCTAssertTrue(slot?.isCleared == true, "no wrapper and no parent left, so the label must finalize")
    }

    @MainActor func test_firstBorrowedWrapperOfACObjectStaysAlive() {
        ensureAdwInit()
        let box = Box()
        gtk_box_append(box.castedPointer(), gtk_label_new("from C"))
        weak var weakChild: Widget?
        do {
            weakChild = box.firstChild
        }
        XCTAssertTrue(weakChild != nil, "the first wrapper of a parented C-created widget must stay alive")
    }
}
#endif
