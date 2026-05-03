// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita
import Foundation

final class NavigationMiscXCTests: XCTestCase {

    // MARK: - NavigationView

    @MainActor func test_navigationViewAddPage() {
        ensureAdwInit()
        let navView = NavigationView()
        let content = Label("Page")
        let page = NavigationPage(child: content, title: "Test Page")
        navView.add(page)
        XCTAssertNotNil(navView.visiblePage)
    }

    @MainActor func test_navigationViewPushPop() {
        ensureAdwInit()
        let navView = NavigationView()
        let page1 = NavigationPage(child: Label("1"), title: "Page 1")
        navView.add(page1)
        let page2 = NavigationPage(child: Label("2"), title: "Page 2")
        navView.push(page2)
        // Pop should succeed
        let popped = navView.pop()
        XCTAssertTrue(popped == true)
    }

    // MARK: - GtkJustification enum

    @MainActor func test_justificationEnum() {
        XCTAssertTrue(GtkJustification.left == GTK_JUSTIFY_LEFT)
        XCTAssertTrue(GtkJustification.right == GTK_JUSTIFY_RIGHT)
        XCTAssertTrue(GtkJustification.center == GTK_JUSTIFY_CENTER)
        XCTAssertTrue(GtkJustification.fill == GTK_JUSTIFY_FILL)
    }

    // MARK: - SearchBar

    @MainActor func test_searchBarCreation() {
        ensureAdwInit()
        let bar = SearchBar()
        XCTAssertTrue(bar.searchModeEnabled == false)
        XCTAssertTrue(bar.showCloseButton == false)
    }

    @MainActor func test_searchBarProperties() {
        ensureAdwInit()
        let bar = SearchBar()
        bar.searchModeEnabled = true
        XCTAssertTrue(bar.searchModeEnabled == true)
        bar.showCloseButton = true
        XCTAssertTrue(bar.showCloseButton == true)
        let entry = SearchEntry()
        bar.child = entry
        XCTAssertNotNil(bar.child)
    }

    // MARK: - EmojiChooser

    @MainActor func test_emojiChooserCreation() {
        ensureAdwInit()
        let chooser = EmojiChooser()
        // No crash = success
        _ = chooser.widgetPointer
    }

    // MARK: - PopoverMenuBar

    @MainActor func test_popoverMenuBarCreation() {
        ensureAdwInit()
        let menu = GMenuRef()
        menu.append("Open", action: "app.open")
        menu.append("Quit", action: "app.quit")
        let bar = PopoverMenuBar(model: menu)
        // No crash = success
        _ = bar.widgetPointer
    }

    // MARK: - Fixed

    @MainActor func test_fixedCreation() {
        ensureAdwInit()
        let fixed = Fixed()
        let label = Label("Hello")
        fixed.put(label, x: 10, y: 20)
        // No crash = success
    }

    @MainActor func test_fixedMove() {
        ensureAdwInit()
        let fixed = Fixed()
        let btn = Button(label: "Move me")
        fixed.put(btn, x: 0, y: 0)
        fixed.move(btn, x: 50, y: 100)
        // No crash = success
    }

    // MARK: - TextBuffer undo/redo

    @MainActor func test_textBufferUndoRedo() {
        ensureAdwInit()
        let buf = TextBuffer()
        XCTAssertTrue(buf.enableUndo == true) // enabled by default
        buf.beginUserAction()
        buf.text = "Hello"
        buf.endUserAction()
        XCTAssertTrue(buf.canUndo == true)
        buf.undo()
        XCTAssertTrue(buf.text == "")
        XCTAssertTrue(buf.canRedo == true)
        buf.redo()
        XCTAssertTrue(buf.text == "Hello")
    }

    // MARK: - ListBox enhancements

    @MainActor func test_listBoxSelectRow() {
        ensureAdwInit()
        let lb = ListBox()
        lb.selectionMode = .single
        let l1 = Label("Row 1")
        let l2 = Label("Row 2")
        lb.append(l1)
        lb.append(l2)
        lb.selectRow(at: 0)
        XCTAssertNotNil(lb.selectedRow)
    }

    @MainActor func test_listBoxRowAt() {
        ensureAdwInit()
        let lb = ListBox()
        let l1 = Label("A")
        lb.append(l1)
        let row = lb.rowAt(0)
        XCTAssertNotNil(row)
        let noRow = lb.rowAt(99)
        XCTAssertNil(noRow)
    }

    @MainActor func test_listBoxPlaceholder() {
        ensureAdwInit()
        let lb = ListBox()
        let placeholder = Label("No items")
        lb.setPlaceholder(placeholder)
        // No crash = success
    }

    // MARK: - Widget focus

    @MainActor func test_widgetFocusable() {
        ensureAdwInit()
        let label = Label("Focus test")
        XCTAssertTrue(label.isFocusable == false)
        label.isFocusable = true
        XCTAssertTrue(label.isFocusable == true)
    }

    @MainActor func test_widgetCanTarget() {
        ensureAdwInit()
        let btn = Button(label: "Target")
        XCTAssertTrue(btn.canTarget == true)
        btn.canTarget = false
        XCTAssertTrue(btn.canTarget == false)
    }

    // MARK: - Overlay enhancements

    @MainActor func test_overlayClipAndMeasure() {
        ensureAdwInit()
        let overlay = Overlay()
        let main = Label("Main")
        let badge = Label("Badge")
        overlay.child = main
        overlay.addOverlay(badge)
        overlay.setClipOverlay(badge, clip: true)
        XCTAssertTrue(overlay.getClipOverlay(badge) == true)
        overlay.setMeasureOverlay(badge, measure: true)
        XCTAssertTrue(overlay.getMeasureOverlay(badge) == true)
    }

    // MARK: - MenuButton popover property

    @MainActor func test_menuButtonPopover() {
        ensureAdwInit()
        let btn = MenuButton()
        XCTAssertNil(btn.popover)
        let popover = Popover()
        btn.popover = popover
        XCTAssertNotNil(btn.popover)
    }

    // MARK: - Application signals

    @MainActor func test_applicationSignals() {
        ensureAdwInit()
        let app = Application(id: "com.test.signals")
        // Just verify signal connection doesn't crash
        app.onStartup {}
        app.onShutdown {}
        app.onOpen { _, _ in }
    }

    // MARK: - ApplicationFlags

    func test_applicationFlagsRawValuesMatchGApplicationFlags() {
        // Each case must mirror the bit positions GLib documents for
        // GApplicationFlags so `flags.rawValue` round-trips through
        // `GApplicationFlags(rawValue:)`.
        XCTAssertTrue(ApplicationFlags.isService.rawValue == 1 << 0)
        XCTAssertTrue(ApplicationFlags.isLauncher.rawValue == 1 << 1)
        XCTAssertTrue(ApplicationFlags.handlesOpen.rawValue == 1 << 2)
        XCTAssertTrue(ApplicationFlags.handlesCommandLine.rawValue == 1 << 3)
        XCTAssertTrue(ApplicationFlags.sendEnvironment.rawValue == 1 << 4)
        XCTAssertTrue(ApplicationFlags.nonUnique.rawValue == 1 << 5)
        XCTAssertTrue(ApplicationFlags.canOverrideAppId.rawValue == 1 << 6)
        XCTAssertTrue(ApplicationFlags.allowReplacement.rawValue == 1 << 7)
        XCTAssertTrue(ApplicationFlags.replace.rawValue == 1 << 8)
    }

    func test_applicationFlagsOptionSetCombines() {
        let combo: ApplicationFlags = [.handlesOpen, .nonUnique]
        XCTAssertTrue(combo.contains(.handlesOpen))
        XCTAssertTrue(combo.contains(.nonUnique))
        XCTAssertFalse(combo.contains(.handlesCommandLine))
        XCTAssertTrue(combo.rawValue == (1 << 2) | (1 << 5))
    }

    @MainActor func test_applicationInitWithFlagsAcceptsApplicationFlags() {
        ensureAdwInit()
        let app = Application(
            id: "com.test.applicationflags.x\(UInt32.random(in: 0 ..< UInt32.max))",
            flags: [.handlesOpen, .nonUnique]
        )
        // If the overload routed the flags correctly, GApplication reflects the
        // same bits on its flags property.
        let gApp: UnsafeMutablePointer<GApplication> = app.gtkApplicationPointer.withMemoryRebound(
            to: GApplication.self,
            capacity: 1
        ) { $0 }
        let mask = g_application_get_flags(gApp).rawValue
        XCTAssertTrue((mask & UInt32(1 << 2)) != 0)
        XCTAssertTrue((mask & UInt32(1 << 5)) != 0)
    }

    @MainActor func test_applicationOpenDeliversFileURLsAndHint() throws {
        ensureAdwInit()

        let directoryURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        defer { try? FileManager.default.removeItem(at: directoryURL) }
        try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)

        let fileURL = directoryURL.appendingPathComponent("opened.md", isDirectory: false)
        try "# Opened from desktop\n".write(to: fileURL, atomically: true, encoding: .utf8)

        let app = Application(
            id: "com.test.open.signal.x\(UInt32.random(in: 0 ..< UInt32.max))",
            flags: .handlesOpen
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

        XCTAssertTrue(capturedURLs == [fileURL])
        XCTAssertTrue(capturedHint == "open-with-swifty-notes")
    }

    // MARK: - AspectFrame

    @MainActor func test_aspectFrameCreation() {
        ensureAdwInit()
        let af = AspectFrame(xalign: 0.5, yalign: 0.5, ratio: 16.0 / 9.0)
        XCTAssertTrue(af.ratio > 1.7 && af.ratio < 1.8)
        XCTAssertTrue(af.obeyChild == false)
    }

    @MainActor func test_aspectFrameProperties() {
        ensureAdwInit()
        let af = AspectFrame()
        af.xalign = 0.0
        XCTAssertTrue(af.xalign == 0.0)
        af.yalign = 1.0
        XCTAssertTrue(af.yalign == 1.0)
        af.ratio = 2.0
        XCTAssertTrue(af.ratio == 2.0)
        af.obeyChild = true
        XCTAssertTrue(af.obeyChild == true)
        let label = Label("Child")
        af.child = label
        XCTAssertNotNil(af.child)
    }

    // MARK: - StackSwitcher

    @MainActor func test_stackSwitcherCreation() {
        ensureAdwInit()
        let sw = StackSwitcher()
        XCTAssertNil(sw.stack)
    }

    @MainActor func test_stackSwitcherWithStack() {
        ensureAdwInit()
        let sw = StackSwitcher()
        let stack = Stack()
        sw.stack = stack
        XCTAssertNotNil(sw.stack)
    }

    // MARK: - WindowControls

    @MainActor func test_windowControlsCreation() {
        ensureAdwInit()
        let wc = WindowControls(side: .end)
        XCTAssertTrue(wc.side == .end)
    }

    @MainActor func test_windowControlsProperties() {
        ensureAdwInit()
        let wc = WindowControls()
        wc.side = .start
        XCTAssertTrue(wc.side == .start)
        wc.decorationLayout = "close"
        XCTAssertTrue(wc.decorationLayout == "close")
    }

    // MARK: - MediaControls

    @MainActor func test_mediaControlsCreation() {
        ensureAdwInit()
        let mc = MediaControls()
        XCTAssertNil(mc.mediaStream)
    }

    // MARK: - Widget cursor

    @MainActor func test_widgetCursor() {
        ensureAdwInit()
        let btn = Button(label: "Cursor")
        btn.setCursor(name: "pointer")
        btn.resetCursor()
        // No crash = success
    }

    // MARK: - Widget tick callback

    @MainActor func test_widgetTickCallback() {
        ensureAdwInit()
        let label = Label("Tick")
        let id = label.addTickCallback { false } // immediately removes itself
        // Can also remove manually
        label.removeTickCallback(id)
    }

    // MARK: - Widget accessibility

    @MainActor func test_widgetAccessibility() {
        ensureAdwInit()
        let btn = Button(label: "Accessible")
        btn.setAccessibleLabel("My Button")
        btn.setAccessibleDescription("A test button")
        _ = btn.accessibleRole
        // No crash = success
    }

    // MARK: - FlowBox enhancements

    @MainActor func test_flowBoxSignals() {
        ensureAdwInit()
        let fb = FlowBox()
        fb.activateOnSingleClick = true
        XCTAssertTrue(fb.activateOnSingleClick == true)
        fb.onChildActivated {}
        fb.onSelectedChildrenChanged {}
        // No crash = success
    }

    @MainActor func test_flowBoxSelectAll() {
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

    @MainActor func test_callbackAnimationTargetConvenience() {
        ensureAdwInit()
        var received = false
        let target = CallbackAnimationTarget { _ in
            received = true
        }
        _ = target
        // No crash creating target = success
    }

    // MARK: - CSSProvider convenience

    @MainActor func test_cssProviderLoadGlobal() {
        ensureAdwInit()
        let provider = CSSProvider.loadGlobal("button { color: red; }")
        provider.removeFromDefaultDisplay()
        // No crash = success
    }

    // MARK: - GtkPackType enum

    @MainActor func test_packTypeEnum() {
        XCTAssertTrue(GtkPackType.start == GTK_PACK_START)
        XCTAssertTrue(GtkPackType.end == GTK_PACK_END)
    }

    // MARK: - Batch 7: Entry enhancements

    @MainActor func test_entryHasFrame() {
        ensureAdwInit()
        let entry = Entry()
        XCTAssertTrue(entry.hasFrame == true)
        entry.hasFrame = false
        XCTAssertTrue(entry.hasFrame == false)
    }

    @MainActor func test_entryAlignment() {
        ensureAdwInit()
        let entry = Entry()
        entry.alignment = 0.5
        XCTAssertTrue(entry.alignment == 0.5)
        entry.alignment = 1.0
        XCTAssertTrue(entry.alignment == 1.0)
    }

    @MainActor func test_entryActivatesDefault() {
        ensureAdwInit()
        let entry = Entry()
        XCTAssertTrue(entry.activatesDefault == false)
        entry.activatesDefault = true
        XCTAssertTrue(entry.activatesDefault == true)
    }

    @MainActor func test_entryProgressFraction() {
        ensureAdwInit()
        let entry = Entry()
        XCTAssertTrue(entry.progressFraction == 0.0)
        entry.progressFraction = 0.5
        XCTAssertTrue(entry.progressFraction == 0.5)
    }

    @MainActor func test_entryProgressPulse() {
        ensureAdwInit()
        let entry = Entry()
        entry.progressPulseStep = 0.2
        XCTAssertTrue(entry.progressPulseStep == 0.2)
        entry.progressPulse()
        // No crash = success
    }

    @MainActor func test_entryInputPurpose() {
        ensureAdwInit()
        let entry = Entry()
        entry.inputPurpose = .email
        XCTAssertTrue(entry.inputPurpose == GtkInputPurpose.email)
        entry.inputPurpose = .password
        XCTAssertTrue(entry.inputPurpose == GtkInputPurpose.password)
    }

    @MainActor func test_entryIcons() {
        ensureAdwInit()
        let entry = Entry()
        entry.setIcon(position: .primary, iconName: "edit-find-symbolic")
        XCTAssertTrue(entry.iconName(at: .primary) == "edit-find-symbolic")
        entry.setIcon(position: .secondary, iconName: "edit-clear-symbolic")
        XCTAssertTrue(entry.iconName(at: .secondary) == "edit-clear-symbolic")
    }

    @MainActor func test_entryIconTooltipAndActivatable() {
        ensureAdwInit()
        let entry = Entry()
        entry.setIcon(position: .primary, iconName: "edit-find-symbolic")
        entry.setIconTooltip(position: .primary, tooltip: "Search")
        entry.setIconActivatable(position: .primary, activatable: true)
        // No crash = success
    }

    @MainActor func test_entryIconPressSignal() {
        ensureAdwInit()
        let entry = Entry()
        entry.onIconPress { _ in }
        // No crash = success
    }

}
#endif
