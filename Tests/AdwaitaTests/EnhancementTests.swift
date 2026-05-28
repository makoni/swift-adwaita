// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct EnhancementTests {

    // MARK: - Scale marks

    @Test @MainActor func scaleAddMark() {
        ensureAdwInit()
        let scale = Scale(orientation: .horizontal, min: 0, max: 100, step: 1)
        scale.addMark(value: 0, position: .top, markup: "0")
        scale.addMark(value: 50, position: .top, markup: "50")
        scale.addMark(value: 100, position: .top, markup: "100")
        // No crash = success
    }

    @Test @MainActor func scaleClearMarks() {
        ensureAdwInit()
        let scale = Scale(orientation: .horizontal, min: 0, max: 10, step: 1)
        scale.addMark(value: 5, position: .bottom)
        scale.clearMarks()
        // No crash = success
    }

    // MARK: - Label enhancements

    @Test @MainActor func labelYalign() {
        ensureAdwInit()
        let label = Label("Test")
        label.yalign = 0.0
        #expect(label.yalign == 0.0)
        label.yalign = 1.0
        #expect(label.yalign == 1.0)
    }

    @Test @MainActor func labelMaxWidthChars() {
        ensureAdwInit()
        let label = Label("Test")
        label.maxWidthChars = 20
        #expect(label.maxWidthChars == 20)
    }

    @Test @MainActor func labelWidthChars() {
        ensureAdwInit()
        let label = Label("Test")
        label.widthChars = 10
        #expect(label.widthChars == 10)
    }

    @Test @MainActor func labelLines() {
        ensureAdwInit()
        let label = Label("Test")
        label.lines = 3
        #expect(label.lines == 3)
    }

    @Test @MainActor func labelMnemonicWidget() {
        ensureAdwInit()
        let label = Label("_Test")
        label.useUnderline = true
        #expect(label.useUnderline == true)
        let entry = Entry()
        label.mnemonicWidget = entry
        #expect(label.mnemonicWidget != nil)
    }

    @Test @MainActor func labelNaturalWrapMode() {
        ensureAdwInit()
        let label = Label("Test")
        label.naturalWrapMode = .word
        #expect(label.naturalWrapMode == GtkNaturalWrapMode.word)
    }

    @Test @MainActor func labelPangoWrapMode() {
        ensureAdwInit()
        let label = Label("Some long text that might wrap")
        label.wrap = true
        label.pangoWrapMode = PANGO_WRAP_WORD_CHAR
        #expect(label.pangoWrapMode == PANGO_WRAP_WORD_CHAR)
        label.pangoWrapMode = PANGO_WRAP_CHAR
        #expect(label.pangoWrapMode == PANGO_WRAP_CHAR)
        label.pangoWrapMode = PANGO_WRAP_WORD
        #expect(label.pangoWrapMode == PANGO_WRAP_WORD)
    }

    // MARK: - ListBox sort/filter

    @Test @MainActor func listBoxSortFunc() {
        ensureAdwInit()
        let list = ListBox()
        list.append(Label("B"))
        list.append(Label("A"))
        list.setSortFunc { _, _ in 0 }
        list.invalidateSort()
        list.clearSortFunc()
        // No crash = success
    }

    @Test @MainActor func listBoxFilterFunc() {
        ensureAdwInit()
        let list = ListBox()
        list.append(Label("Visible"))
        list.append(Label("Hidden"))
        list.setFilterFunc { _ in true }
        list.invalidateFilter()
        list.clearFilterFunc()
        // No crash = success
    }

    // MARK: - Widget size queries

    @Test @MainActor func widgetWidthHeight() {
        ensureAdwInit()
        let label = Label("Test")
        // Before layout, width/height are 0
        #expect(label.width >= 0)
        #expect(label.height >= 0)
    }

    @Test @MainActor func widgetCssName() {
        ensureAdwInit()
        let label = Label("Test")
        #expect(!label.cssName.isEmpty)
    }

    // MARK: - Box reorder

    @Test @MainActor func boxReorderChildAfter() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let a = Label("A")
        let b = Label("B")
        let c = Label("C")
        box.append(a)
        box.append(b)
        box.append(c)
        // Move A after C
        box.reorderChildAfter(a, sibling: c)
        // No crash = success
    }

    // MARK: - Image enhancements

    @Test @MainActor func imageFromResource() {
        ensureAdwInit()
        let img = Image()
        img.setFromResource(nil)
        // No crash = success
    }

    @Test @MainActor func imageClear() {
        ensureAdwInit()
        let img = Image(iconName: "dialog-information-symbolic")
        img.clear()
        // After clearing, icon should be nil
        #expect(img.iconName == nil)
    }

    // MARK: - ToolbarView edge extension

    @Test @MainActor func toolbarViewExtendContentToEdges() {
        ensureAdwInit()
        let tv = ToolbarView()
        #expect(tv.extendContentToTopEdge == false)
        tv.extendContentToTopEdge = true
        #expect(tv.extendContentToTopEdge == true)
        #expect(tv.extendContentToBottomEdge == false)
        tv.extendContentToBottomEdge = true
        #expect(tv.extendContentToBottomEdge == true)
    }

    // MARK: - MainContext delay

    @Test @MainActor func mainContextDelay() {
        ensureAdwInit()
        // Just verify it compiles and doesn't crash
        // (actual execution requires the main loop)
        var called = false
        MainContext.delay(ms: 1) { called = true }
        _ = called
    }

    @Test @MainActor func mainContextCancelAndSourceID() {
        ensureAdwInit()
        // Schedule a timeout and immediately cancel it
        let id: SourceID = MainContext.timeout(intervalMs: 60000) { true }
        let removed = MainContext.cancel(sourceId: id)
        #expect(removed == true)
    }

    @Test @MainActor func mainContextDrainPendingRunsScheduledIdles() {
        ensureAdwInit()
        // Clear any deferred-release idles or GTK teardown sources left
        // over from earlier suites running in the same process so we
        // measure work scheduled by this test, not noise from another.
        _ = MainContext.drainPending()

        var hits = 0
        MainContext.idle { hits += 1 }
        MainContext.idle { hits += 1 }
        MainContext.idle { hits += 1 }
        let processed = MainContext.drainPending()
        #expect(hits == 3)
        // g_main_context_iteration can dispatch several same-priority idle
        // sources in a single iteration, so `processed` is not guaranteed
        // to equal the number of idles scheduled — we only require that
        // drainPending did at least one iteration of work.
        #expect(processed >= 1)
    }

    @Test @MainActor func mainContextDrainPendingIsNonBlockingWhenIdle() {
        ensureAdwInit()
        // Clear any sources left over from deferred GObject releases or
        // other tests sharing the default context.
        _ = MainContext.drainPending()
        // With nothing freshly scheduled, a second drain must return 0
        // without hanging.
        let processed = MainContext.drainPending()
        #expect(processed == 0)
    }

    @Test @MainActor func mainContextPumpForRunsDelayedTask() {
        ensureAdwInit()
        var called = false
        MainContext.task(after: .milliseconds(5)) { called = true }
        MainContext.pump(for: .milliseconds(120))
        #expect(called)
    }

    @Test @MainActor func mainContextPumpForDispatchesReadyIdle() {
        ensureAdwInit()
        // Drain any leftover idles from earlier suites so the 40ms budget
        // is spent dispatching the idle we schedule below, not whatever
        // noise drifted in from teardown of a previous suite.
        _ = MainContext.drainPending()

        var called = false
        MainContext.idle { called = true }
        MainContext.pump(for: .milliseconds(40))
        #expect(called)
    }

    @Test @MainActor func mainContextTaskRunsOnIdle() {
        ensureAdwInit()
        var called = false

        let task = MainContext.task {
            called = true
        }

        spinMainLoop()

        #expect(called)
        #expect(!task.isScheduled)
    }

    @Test @MainActor func mainContextTaskRunsAfterDurationDelay() {
        ensureAdwInit()
        var called = false

        let task = MainContext.task(after: .milliseconds(5)) {
            called = true
        }

        g_usleep(20_000)
        spinMainLoop()

        #expect(called)
        #expect(!task.isScheduled)
    }

    @Test @MainActor func mainContextTaskCancelPreventsDelayedExecution() {
        ensureAdwInit()
        var called = false

        let task = MainContext.task(after: .milliseconds(20)) {
            called = true
        }

        #expect(task.isScheduled)
        #expect(task.cancel())

        g_usleep(40_000)
        spinMainLoop()

        #expect(!called)
        #expect(!task.isScheduled)
    }

    @Test @MainActor func mainContextRepeatingTaskStopsWhenClosureReturnsFalse() {
        ensureAdwInit()
        var values: [Int] = []

        let task = MainContext.task(every: .milliseconds(5)) {
            values.append(values.count + 1)
            return values.count < 3
        }

        for _ in 0 ..< 6 {
            g_usleep(10_000)
            spinMainLoop()
        }

        #expect(values == [1, 2, 3])
        #expect(!task.isScheduled)
    }

    @Test @MainActor func mainContextRunAsyncReturnsValue() async {
        ensureAdwInit()
        let value = Task { await MainContext.run { 42 } }

        await Task.yield()
        spinMainLoop()

        #expect(await value.value == 42)
    }

    @Test @MainActor func mainContextYieldAsyncResumesOnNextLoopTurn() async {
        ensureAdwInit()
        let recorder = BoolRecorder()

        let wait = Task {
            await MainContext.yield()
            await recorder.mark()
        }

        await Task.yield()
        #expect(await recorder.snapshot() == false)
        spinMainLoop()
        await wait.value
        #expect(await recorder.snapshot())
    }

    @Test @MainActor func mainContextSleepAsyncResumesAfterDelay() async {
        ensureAdwInit()
        let recorder = BoolRecorder()

        let wait = Task {
            await MainContext.sleep(for: .milliseconds(5))
            await recorder.mark()
        }

        await Task.yield()
        #expect(await recorder.snapshot() == false)
        g_usleep(20_000)
        spinMainLoop()
        await wait.value
        #expect(await recorder.snapshot())
    }

    // MARK: - New enum extensions

    @Test @MainActor func inputPurposeEnum() {
        #expect(GtkInputPurpose.freeForm == GTK_INPUT_PURPOSE_FREE_FORM)
        #expect(GtkInputPurpose.digits == GTK_INPUT_PURPOSE_DIGITS)
        #expect(GtkInputPurpose.number == GTK_INPUT_PURPOSE_NUMBER)
        #expect(GtkInputPurpose.phone == GTK_INPUT_PURPOSE_PHONE)
        #expect(GtkInputPurpose.url == GTK_INPUT_PURPOSE_URL)
        #expect(GtkInputPurpose.email == GTK_INPUT_PURPOSE_EMAIL)
        #expect(GtkInputPurpose.password == GTK_INPUT_PURPOSE_PASSWORD)
        #expect(GtkInputPurpose.pin == GTK_INPUT_PURPOSE_PIN)
        #expect(GtkInputPurpose.terminal == GTK_INPUT_PURPOSE_TERMINAL)
    }

    @Test @MainActor func entryIconPositionEnum() {
        #expect(GtkEntryIconPosition.primary == GTK_ENTRY_ICON_PRIMARY)
        #expect(GtkEntryIconPosition.secondary == GTK_ENTRY_ICON_SECONDARY)
    }

    @Test @MainActor func naturalWrapModeEnum() {
        #expect(GtkNaturalWrapMode.inherit == GTK_NATURAL_WRAP_INHERIT)
        #expect(GtkNaturalWrapMode.none == GTK_NATURAL_WRAP_NONE)
        #expect(GtkNaturalWrapMode.word == GTK_NATURAL_WRAP_WORD)
    }

    // MARK: - Batch 8: SplitButton menuModel/popover

    @Test @MainActor func splitButtonMenuModel() {
        ensureAdwInit()
        let btn = SplitButton()
        let menu = GMenuRef()
        menu.append("Test", action: "app.test")
        btn.setMenuModel(menu)
        // No crash = success
    }

    @Test @MainActor func splitButtonPopover() {
        ensureAdwInit()
        let btn = SplitButton()
        let pop = Popover()
        pop.child = Label("Custom")
        btn.setPopover(pop)
        // No crash = success
    }

    @Test @MainActor func splitButtonClickedSignal() {
        ensureAdwInit()
        let btn = SplitButton()
        btn.label = "Test"
        btn.onClicked {}
        btn.onActivate {}
        // No crash = success
    }

    // MARK: - PreferencesDialog add/remove

    @Test @MainActor func preferencesDialogAddRemove() {
        ensureAdwInit()
        let dialog = PreferencesDialog()
        let page = PreferencesPage()
        page.title = "General"
        dialog.add(page)
        dialog.remove(page)
        // No crash = success
    }

    // MARK: - CheckButton enhancements

    @Test @MainActor func checkButtonInconsistent() {
        ensureAdwInit()
        let check = CheckButton(label: "Test")
        #expect(check.inconsistent == false)
        check.inconsistent = true
        #expect(check.inconsistent == true)
    }

    @Test @MainActor func checkButtonChild() {
        ensureAdwInit()
        let check = CheckButton()
        let label = Label("Custom child")
        check.child = label
        #expect(check.child != nil)
    }

    @Test @MainActor func checkButtonUseUnderline() {
        ensureAdwInit()
        let check = CheckButton(label: "_Mnemonic")
        check.useUnderline = true
        #expect(check.useUnderline == true)
    }

    // MARK: - DropDown showArrow

    @Test @MainActor func dropDownShowArrow() {
        ensureAdwInit()
        let dd = DropDown(strings: ["A", "B"])
        #expect(dd.showArrow == true)
        dd.showArrow = false
        #expect(dd.showArrow == false)
    }

}
#endif
