// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Testing
@testable import Adwaita

@Suite(.serialized)
struct ScrolledWindowScrollChildIntoViewTests {
    @Test func scrollTargetMovesDownToRevealLowerEdge() {
        let target = ScrolledWindow.targetVerticalOffset(
            visibleTop: 0,
            pageSize: 120,
            childTop: 420,
            childHeight: 40,
            lower: 0,
            upper: 600
        )

        #expect(target == 340)
    }

    @Test func scrollTargetMovesUpToRevealUpperEdge() {
        let target = ScrolledWindow.targetVerticalOffset(
            visibleTop: 200,
            pageSize: 120,
            childTop: 40,
            childHeight: 32,
            lower: 0,
            upper: 600
        )

        #expect(target == 40)
    }

    @Test func scrollTargetReturnsNilWhenChildIsAlreadyVisible() {
        let target = ScrolledWindow.targetVerticalOffset(
            visibleTop: 100,
            pageSize: 120,
            childTop: 120,
            childHeight: 40,
            lower: 0,
            upper: 600
        )

        #expect(target == nil)
    }

    @Test func scrollTargetMovesUpForPartialAboveCase() {
        let target = ScrolledWindow.targetVerticalOffset(
            visibleTop: 100,
            pageSize: 120,
            childTop: 90,
            childHeight: 20,
            lower: 0,
            upper: 600
        )

        #expect(target == 90)
    }

    @Test func scrollTargetReturnsTargetForPartialBelowCase() {
        let target = ScrolledWindow.targetVerticalOffset(
            visibleTop: 100,
            pageSize: 120,
            childTop: 210,
            childHeight: 30,
            lower: 0,
            upper: 600
        )

        #expect(target == 120)
    }

    @Test func scrollTargetClampsToLowerBound() {
        let target = ScrolledWindow.targetVerticalOffset(
            visibleTop: 80,
            pageSize: 120,
            childTop: -40,
            childHeight: 32,
            lower: 0,
            upper: 600
        )

        #expect(target == 0)
    }

    @Test func scrollTargetClampsToUpperBoundMinusPageSize() {
        let target = ScrolledWindow.targetVerticalOffset(
            visibleTop: 300,
            pageSize: 120,
            childTop: 590,
            childHeight: 40,
            lower: 0,
            upper: 600
        )

        #expect(target == 480)
    }

    @Test @MainActor func revealVerticalBoundsUpdatesAdjustmentForSuccessPath() {
        ensureAdwInit()
        let scrolled = ScrolledWindow(child: Box())
        let target = Button(label: "Focus")
        scrolled.verticalAdjustment.configure(
            value: 0,
            lower: 0,
            upper: 600,
            stepIncrement: 1,
            pageIncrement: 10,
            pageSize: 120
        )

        scrolled.revealVerticalBounds(
            childTop: 420,
            childHeight: 40,
            preserveFocus: true,
            animate: false,
            focusTarget: target
        )

        #expect(scrolled.verticalAdjustment.value == 340)
    }

    @Test @MainActor func revealVerticalBoundsAnimateTrueUsesSynchronousBranchForTinyDelta() {
        ensureAdwInit()
        let scrolled = ScrolledWindow(child: Box())
        let target = Button(label: "Focus")
        scrolled.verticalAdjustment.configure(
            value: 100.3,
            lower: 0,
            upper: 600,
            stepIncrement: 1,
            pageIncrement: 10,
            pageSize: 120
        )

        scrolled.revealVerticalBounds(
            childTop: 220,
            childHeight: 0.8,
            preserveFocus: true,
            animate: true,
            focusTarget: target
        )

        #expect(abs(scrolled.verticalAdjustment.value - 100.8) < 0.001)
    }

    @Test @MainActor func revealVerticalBoundsAnimateTrueQueuesAnimationForLargerDelta() {
        ensureAdwInit()
        let scrolled = ScrolledWindow(child: Box())
        let target = Button(label: "Focus")
        scrolled.verticalAdjustment.configure(
            value: 0,
            lower: 0,
            upper: 600,
            stepIncrement: 1,
            pageIncrement: 10,
            pageSize: 120
        )
        var queuedAnimations = 0

        scrolled.revealVerticalBounds(
            childTop: 420,
            childHeight: 40,
            preserveFocus: true,
            animate: true,
            focusTarget: target,
            didQueueAnimation: {
                queuedAnimations += 1
            }
        )

        #expect(queuedAnimations == 1)
    }

    @Test @MainActor func revealVerticalBoundsCallsFocusActionWhenPreserveFocusIsFalse() {
        ensureAdwInit()
        let scrolled = ScrolledWindow(child: Box())
        let target = Button(label: "Focus")
        scrolled.verticalAdjustment.configure(
            value: 0,
            lower: 0,
            upper: 600,
            stepIncrement: 1,
            pageIncrement: 10,
            pageSize: 120
        )
        var focusCalls = 0

        scrolled.revealVerticalBounds(
            childTop: 420,
            childHeight: 40,
            preserveFocus: false,
            animate: false,
            focusTarget: target,
            focusAction: {
                focusCalls += 1
                return true
            }
        )

        #expect(focusCalls == 1)
    }

    @Test @MainActor func revealVerticalBoundsSkipsFocusActionWhenPreserveFocusIsTrue() {
        ensureAdwInit()
        let scrolled = ScrolledWindow(child: Box())
        let target = Button(label: "Focus")
        scrolled.verticalAdjustment.configure(
            value: 0,
            lower: 0,
            upper: 600,
            stepIncrement: 1,
            pageIncrement: 10,
            pageSize: 120
        )
        var focusCalls = 0

        scrolled.revealVerticalBounds(
            childTop: 420,
            childHeight: 40,
            preserveFocus: true,
            animate: false,
            focusTarget: target,
            focusAction: {
                focusCalls += 1
                return true
            }
        )

        #expect(focusCalls == 0)
    }

    @Test @MainActor func revealVerticalBoundsWithZeroHeightChildIsNoOp() {
        ensureAdwInit()
        let scrolled = ScrolledWindow(child: Box())
        let target = Button(label: "Focus")
        scrolled.verticalAdjustment.configure(
            value: 42,
            lower: 0,
            upper: 400,
            stepIncrement: 1,
            pageIncrement: 10,
            pageSize: 100
        )

        scrolled.revealVerticalBounds(
            childTop: 120,
            childHeight: 0,
            preserveFocus: true,
            animate: false,
            focusTarget: target
        )

        #expect(scrolled.verticalAdjustment.value == 42)
    }

    @Test @MainActor func scrollChildIntoViewIgnoresWidgetsOutsideContentTree() {
        ensureAdwInit()
        let container = Box()
        let child = Label("inside")
        container.append(child)

        let scrolled = ScrolledWindow(child: container)
        scrolled.verticalAdjustment.configure(
            value: 42,
            lower: 0,
            upper: 400,
            stepIncrement: 1,
            pageIncrement: 10,
            pageSize: 100
        )

        scrolled.scrollChildIntoView(Label("outside"), animate: true)
        #expect(scrolled.verticalAdjustment.value == 42)
    }
}
#endif
