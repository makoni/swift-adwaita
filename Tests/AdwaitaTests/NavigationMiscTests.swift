import Testing
@testable import Adwaita
import CAdwaita
import Foundation

@Suite(.serialized)
struct NavigationMiscTests {

    // MARK: - NavigationView

    @Test @MainActor func navigationViewAddPage() {
        ensureAdwInit()
        let navView = NavigationView()
        let content = Label("Page")
        let page = NavigationPage(child: content, title: "Test Page")
        navView.add(page)
        #expect(navView.visiblePage != nil)
    }

    @Test @MainActor func navigationViewPushPop() {
        ensureAdwInit()
        let navView = NavigationView()
        let page1 = NavigationPage(child: Label("1"), title: "Page 1")
        navView.add(page1)
        let page2 = NavigationPage(child: Label("2"), title: "Page 2")
        navView.push(page2)
        // Pop should succeed
        let popped = navView.pop()
        #expect(popped == true)
    }

    // MARK: - GtkJustification enum

    @Test @MainActor func justificationEnum() {
        #expect(GtkJustification.left == GTK_JUSTIFY_LEFT)
        #expect(GtkJustification.right == GTK_JUSTIFY_RIGHT)
        #expect(GtkJustification.center == GTK_JUSTIFY_CENTER)
        #expect(GtkJustification.fill == GTK_JUSTIFY_FILL)
    }

    // MARK: - SearchBar

    @Test @MainActor func searchBarCreation() {
        ensureAdwInit()
        let bar = SearchBar()
        #expect(bar.searchModeEnabled == false)
        #expect(bar.showCloseButton == false)
    }

    @Test @MainActor func searchBarProperties() {
        ensureAdwInit()
        let bar = SearchBar()
        bar.searchModeEnabled = true
        #expect(bar.searchModeEnabled == true)
        bar.showCloseButton = true
        #expect(bar.showCloseButton == true)
        let entry = SearchEntry()
        bar.child = entry
        #expect(bar.child != nil)
    }

    // MARK: - EmojiChooser

    @Test @MainActor func emojiChooserCreation() {
        ensureAdwInit()
        let chooser = EmojiChooser()
        // No crash = success
        _ = chooser.widgetPointer
    }

    // MARK: - PopoverMenuBar

    @Test @MainActor func popoverMenuBarCreation() {
        ensureAdwInit()
        let menu = GMenuRef()
        menu.append("Open", action: "app.open")
        menu.append("Quit", action: "app.quit")
        let bar = PopoverMenuBar(model: menu)
        // No crash = success
        _ = bar.widgetPointer
    }

    // MARK: - Fixed

    @Test @MainActor func fixedCreation() {
        ensureAdwInit()
        let fixed = Fixed()
        let label = Label("Hello")
        fixed.put(label, x: 10, y: 20)
        // No crash = success
    }

    @Test @MainActor func fixedMove() {
        ensureAdwInit()
        let fixed = Fixed()
        let btn = Button(label: "Move me")
        fixed.put(btn, x: 0, y: 0)
        fixed.move(btn, x: 50, y: 100)
        // No crash = success
    }

    // MARK: - TextBuffer undo/redo

    @Test @MainActor func textBufferUndoRedo() {
        ensureAdwInit()
        let buf = TextBuffer()
        #expect(buf.enableUndo == true) // enabled by default
        buf.beginUserAction()
        buf.text = "Hello"
        buf.endUserAction()
        #expect(buf.canUndo == true)
        buf.undo()
        #expect(buf.text == "")
        #expect(buf.canRedo == true)
        buf.redo()
        #expect(buf.text == "Hello")
    }

    // MARK: - ListBox enhancements

    @Test @MainActor func listBoxSelectRow() {
        ensureAdwInit()
        let lb = ListBox()
        lb.selectionMode = .single
        let l1 = Label("Row 1")
        let l2 = Label("Row 2")
        lb.append(l1)
        lb.append(l2)
        lb.selectRow(at: 0)
        #expect(lb.selectedRow != nil)
    }

    @Test @MainActor func listBoxRowAt() {
        ensureAdwInit()
        let lb = ListBox()
        let l1 = Label("A")
        lb.append(l1)
        let row = lb.rowAt(0)
        #expect(row != nil)
        let noRow = lb.rowAt(99)
        #expect(noRow == nil)
    }

    @Test @MainActor func listBoxPlaceholder() {
        ensureAdwInit()
        let lb = ListBox()
        let placeholder = Label("No items")
        lb.setPlaceholder(placeholder)
        // No crash = success
    }

    // MARK: - Widget focus

    @Test @MainActor func widgetFocusable() {
        ensureAdwInit()
        let label = Label("Focus test")
        #expect(label.isFocusable == false)
        label.isFocusable = true
        #expect(label.isFocusable == true)
    }

    @Test @MainActor func widgetCanTarget() {
        ensureAdwInit()
        let btn = Button(label: "Target")
        #expect(btn.canTarget == true)
        btn.canTarget = false
        #expect(btn.canTarget == false)
    }

    // MARK: - Overlay enhancements

    @Test @MainActor func overlayClipAndMeasure() {
        ensureAdwInit()
        let overlay = Overlay()
        let main = Label("Main")
        let badge = Label("Badge")
        overlay.child = main
        overlay.addOverlay(badge)
        overlay.setClipOverlay(badge, clip: true)
        #expect(overlay.getClipOverlay(badge) == true)
        overlay.setMeasureOverlay(badge, measure: true)
        #expect(overlay.getMeasureOverlay(badge) == true)
    }

    // MARK: - MenuButton popover property

    @Test @MainActor func menuButtonPopover() {
        ensureAdwInit()
        let btn = MenuButton()
        #expect(btn.popover == nil)
        let popover = Popover()
        btn.popover = popover
        #expect(btn.popover != nil)
    }

    // MARK: - Application signals

    @Test @MainActor func applicationSignals() {
        ensureAdwInit()
        let app = Application(id: "com.test.signals")
        // Just verify signal connection doesn't crash
        app.onStartup {}
        app.onShutdown {}
        app.onOpen { _, _ in }
    }

    @Test @MainActor func applicationOpenDeliversFileURLsAndHint() throws {
        ensureAdwInit()

        let directoryURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        defer { try? FileManager.default.removeItem(at: directoryURL) }
        try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)

        let fileURL = directoryURL.appendingPathComponent("opened.md", isDirectory: false)
        try "# Opened from desktop\n".write(to: fileURL, atomically: true, encoding: .utf8)

        let app = Application(
            id: "com.test.open.signal.x\(UInt32.random(in: 0 ..< UInt32.max))",
            flags: G_APPLICATION_HANDLES_OPEN
        )
        try app.register()

        var capturedURLs: [URL] = []
        var capturedHint: String?
        app.onOpen { urls, hint in
            capturedURLs = urls
            capturedHint = hint
        }

        let file = g_file_new_for_path(fileURL.path())
        defer { g_object_unref(gpointer(file)) }

        var files: [OpaquePointer?] = [file, nil]
        let gApplication = UnsafeMutableRawPointer(app.gtkApplicationPointer)
            .assumingMemoryBound(to: GApplication.self)
        files.withUnsafeMutableBufferPointer { buffer in
            g_application_open(
                gApplication,
                buffer.baseAddress,
                1,
                "open-with-swifty-notes"
            )
        }

        #expect(capturedURLs == [fileURL])
        #expect(capturedHint == "open-with-swifty-notes")
    }

    // MARK: - AspectFrame

    @Test @MainActor func aspectFrameCreation() {
        ensureAdwInit()
        let af = AspectFrame(xalign: 0.5, yalign: 0.5, ratio: 16.0 / 9.0)
        #expect(af.ratio > 1.7 && af.ratio < 1.8)
        #expect(af.obeyChild == false)
    }

    @Test @MainActor func aspectFrameProperties() {
        ensureAdwInit()
        let af = AspectFrame()
        af.xalign = 0.0
        #expect(af.xalign == 0.0)
        af.yalign = 1.0
        #expect(af.yalign == 1.0)
        af.ratio = 2.0
        #expect(af.ratio == 2.0)
        af.obeyChild = true
        #expect(af.obeyChild == true)
        let label = Label("Child")
        af.child = label
        #expect(af.child != nil)
    }

    // MARK: - StackSwitcher

    @Test @MainActor func stackSwitcherCreation() {
        ensureAdwInit()
        let sw = StackSwitcher()
        #expect(sw.stack == nil)
    }

    @Test @MainActor func stackSwitcherWithStack() {
        ensureAdwInit()
        let sw = StackSwitcher()
        let stack = Stack()
        sw.stack = stack
        #expect(sw.stack != nil)
    }

    // MARK: - WindowControls

    @Test @MainActor func windowControlsCreation() {
        ensureAdwInit()
        let wc = WindowControls(side: .end)
        #expect(wc.side == .end)
    }

    @Test @MainActor func windowControlsProperties() {
        ensureAdwInit()
        let wc = WindowControls()
        wc.side = .start
        #expect(wc.side == .start)
        wc.decorationLayout = "close"
        #expect(wc.decorationLayout == "close")
    }

    // MARK: - MediaControls

    @Test @MainActor func mediaControlsCreation() {
        ensureAdwInit()
        let mc = MediaControls()
        #expect(mc.mediaStream == nil)
    }

    // MARK: - Widget cursor

    @Test @MainActor func widgetCursor() {
        ensureAdwInit()
        let btn = Button(label: "Cursor")
        btn.setCursor(name: "pointer")
        btn.resetCursor()
        // No crash = success
    }

    // MARK: - Widget tick callback

    @Test @MainActor func widgetTickCallback() {
        ensureAdwInit()
        let label = Label("Tick")
        let id = label.addTickCallback { false } // immediately removes itself
        // Can also remove manually
        label.removeTickCallback(id)
    }

    // MARK: - Widget accessibility

    @Test @MainActor func widgetAccessibility() {
        ensureAdwInit()
        let btn = Button(label: "Accessible")
        btn.setAccessibleLabel("My Button")
        btn.setAccessibleDescription("A test button")
        _ = btn.accessibleRole
        // No crash = success
    }

    // MARK: - FlowBox enhancements

    @Test @MainActor func flowBoxSignals() {
        ensureAdwInit()
        let fb = FlowBox()
        fb.activateOnSingleClick = true
        #expect(fb.activateOnSingleClick == true)
        fb.onChildActivated {}
        fb.onSelectedChildrenChanged {}
        // No crash = success
    }

    @Test @MainActor func flowBoxSelectAll() {
        ensureAdwInit()
        let fb = FlowBox()
        fb.selectionMode = .multiple
        fb.append(Label("A"))
        fb.append(Label("B"))
        fb.selectAll()
        fb.unselectAll()
        // No crash = success
    }

    // MARK: - CallbackAnimationTarget convenience

    @Test @MainActor func callbackAnimationTargetConvenience() {
        ensureAdwInit()
        var received = false
        let target = CallbackAnimationTarget { _ in
            received = true
        }
        _ = target
        // No crash creating target = success
    }

    // MARK: - CSSProvider convenience

    @Test @MainActor func cssProviderLoadGlobal() {
        ensureAdwInit()
        let provider = CSSProvider.loadGlobal("button { color: red; }")
        provider.removeFromDefaultDisplay()
        // No crash = success
    }

    // MARK: - GtkPackType enum

    @Test @MainActor func packTypeEnum() {
        #expect(GtkPackType.start == GTK_PACK_START)
        #expect(GtkPackType.end == GTK_PACK_END)
    }

    // MARK: - Batch 7: Entry enhancements

    @Test @MainActor func entryHasFrame() {
        ensureAdwInit()
        let entry = Entry()
        #expect(entry.hasFrame == true)
        entry.hasFrame = false
        #expect(entry.hasFrame == false)
    }

    @Test @MainActor func entryAlignment() {
        ensureAdwInit()
        let entry = Entry()
        entry.alignment = 0.5
        #expect(entry.alignment == 0.5)
        entry.alignment = 1.0
        #expect(entry.alignment == 1.0)
    }

    @Test @MainActor func entryActivatesDefault() {
        ensureAdwInit()
        let entry = Entry()
        #expect(entry.activatesDefault == false)
        entry.activatesDefault = true
        #expect(entry.activatesDefault == true)
    }

    @Test @MainActor func entryProgressFraction() {
        ensureAdwInit()
        let entry = Entry()
        #expect(entry.progressFraction == 0.0)
        entry.progressFraction = 0.5
        #expect(entry.progressFraction == 0.5)
    }

    @Test @MainActor func entryProgressPulse() {
        ensureAdwInit()
        let entry = Entry()
        entry.progressPulseStep = 0.2
        #expect(entry.progressPulseStep == 0.2)
        entry.progressPulse()
        // No crash = success
    }

    @Test @MainActor func entryInputPurpose() {
        ensureAdwInit()
        let entry = Entry()
        entry.inputPurpose = .email
        #expect(entry.inputPurpose == GtkInputPurpose.email)
        entry.inputPurpose = .password
        #expect(entry.inputPurpose == GtkInputPurpose.password)
    }

    @Test @MainActor func entryIcons() {
        ensureAdwInit()
        let entry = Entry()
        entry.setIcon(position: .primary, iconName: "edit-find-symbolic")
        #expect(entry.iconName(at: .primary) == "edit-find-symbolic")
        entry.setIcon(position: .secondary, iconName: "edit-clear-symbolic")
        #expect(entry.iconName(at: .secondary) == "edit-clear-symbolic")
    }

    @Test @MainActor func entryIconTooltipAndActivatable() {
        ensureAdwInit()
        let entry = Entry()
        entry.setIcon(position: .primary, iconName: "edit-find-symbolic")
        entry.setIconTooltip(position: .primary, tooltip: "Search")
        entry.setIconActivatable(position: .primary, activatable: true)
        // No crash = success
    }

    @Test @MainActor func entryIconPressSignal() {
        ensureAdwInit()
        let entry = Entry()
        entry.onIconPress { _ in }
        // No crash = success
    }

}
