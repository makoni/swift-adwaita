// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Foundation
import Testing
import Adwaita
@testable import DemoAppLib

/// Interaction tests for the composite examples from Navigation Split View to
/// View Switcher (alphabetically): drive the real control out of the
/// `buildWidget()` tree and assert the observable effect.
///
/// Deliberately not covered here:
/// - `Notebook`, `Paned` — no example logic: tab switching and handle dragging
///   are plain GTK behavior (the handle also needs real pointer drags).
/// - `PreferencesExample` — a static form; every row only uses built-in
///   widget behavior.
/// - `ShortcutsDialog` — covered by `shortcutsDialogButtonEmitsWithoutCrashing`
///   in `DemoExampleInteractionTests` (the dialog content is static).
/// - The OverlaySplitView edge swipe — needs real touchscreen input; the test
///   only checks the collapse that enables it.
@Suite(.serialized)
struct CompositeNVInteractionTests {
    @MainActor
    static func setUp(
        _ example: any DemoExample, width: Int = 900, height: Int = 700
    ) -> (root: Widget, window: Window) {
        let root = example.buildWidget()
        let window = Window()
        window.setDefaultSize(width: width, height: height)
        window.content = root
        window.present()
        drainMainLoop()
        return (root, window)
    }

    @MainActor
    static func tearDown(_ window: Window) {
        window.destroy()
        drainMainLoop()
    }

    /// Every descendant of `root` that is an instance of `T`, in tree order.
    @MainActor
    static func widgets<T: Widget>(_ root: Widget, _ type: T.Type) -> [T] {
        allWidgets(root).compactMap { $0.tryCast(type) }
    }

    /// The first label in `root` whose text starts with `prefix`.
    @MainActor
    static func labelWithPrefix(_ root: Widget, _ prefix: String) -> Label? {
        widgets(root, Label.self).first { $0.text.hasPrefix(prefix) }
    }

    // MARK: - Navigation Split View

    @Test @MainActor
    func navigationSplitViewSelectionUpdatesContentPage() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(NavigationSplitViewExample())
        defer { Self.tearDown(window) }

        let list = widgetOfType(root, ListBox.self)
        let status = widgetOfType(root, StatusPage.self)
        // The sidebar page is titled "Mail"; the other one is the content page.
        let contentPage = Self.widgets(root, NavigationPage.self).first { $0.title != "Mail" }
        #expect(list != nil)
        #expect(status != nil)
        #expect(contentPage != nil, "content NavigationPage not found in tree")

        // The content starts on Inbox, so the sidebar should start there too.
        #expect(list?.selectedIndex == 0, "Inbox row should start selected")
        #expect(status?.title == "Inbox")
        #expect(contentPage?.title == "Inbox")

        _ = list?.rowAt(2)?.activate()
        #expect(status?.title == "Sent")
        #expect(status?.description == "Showing Sent items")
        // The content header shows the page title, which must follow too.
        #expect(contentPage?.title == "Sent", "content header title should follow the selection")

        _ = list?.rowAt(4)?.activate()
        #expect(status?.title == "Trash")
        #expect(contentPage?.title == "Trash")
    }

    // MARK: - Navigation View

    @Test @MainActor
    func navigationViewPushesAndPops() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(NavigationViewExample())
        defer { Self.tearDown(window) }

        let navView = widgetOfType(root, NavigationView.self)
        #expect(navView != nil)
        #expect(navView?.visiblePage?.title == "Home")

        buttonLabeled(root, "Go to Detail")?.emitClicked()
        #expect(navView?.visiblePage?.title == "Detail")
        _ = navView?.pop()
        #expect(navView?.visiblePage?.title == "Home")

        buttonLabeled(root, "Go to Settings")?.emitClicked()
        #expect(navView?.visiblePage?.title == "Settings")
        _ = navView?.pop()
        #expect(navView?.visiblePage?.title == "Home")
    }

    // MARK: - Overlay Split View

    @Test @MainActor
    func overlaySplitViewToggleButton() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(OverlaySplitViewExample())
        defer { Self.tearDown(window) }

        let splitView = widgetOfType(root, OverlaySplitView.self)
        let toggle = Self.widgets(root, Button.self).first { $0.iconName == "sidebar-show-symbolic" }
        #expect(splitView != nil)
        #expect(toggle != nil, "sidebar toggle button not found in tree")
        #expect(splitView?.showSidebar == true)

        toggle?.emitClicked()
        #expect(splitView?.showSidebar == false)
        toggle?.emitClicked()
        #expect(splitView?.showSidebar == true)
    }

    @Test @MainActor
    func overlaySplitViewCollapsesWhenNarrow() {
        ensureDemoAdwInit()
        // Below the 500sp breakpoint the sidebar becomes an overlay: that is
        // what enables the edge-swipe gestures and the auto-close on selection.
        let (root, window) = Self.setUp(OverlaySplitViewExample(), width: 400, height: 600)
        defer { Self.tearDown(window) }

        let splitView = widgetOfType(root, OverlaySplitView.self)
        let list = widgetOfType(root, ListBox.self)
        let status = widgetOfType(root, StatusPage.self)
        let toggle = Self.widgets(root, Button.self).first { $0.iconName == "sidebar-show-symbolic" }
        #expect(splitView != nil)
        #expect(list != nil)
        #expect(splitView?.collapsed == true, "a narrow window should collapse the split view")
        // Collapsing hides an unpinned sidebar; the button brings it back as an overlay.
        #expect(splitView?.showSidebar == false)
        toggle?.emitClicked()
        #expect(splitView?.showSidebar == true)

        _ = list?.rowAt(1)?.activate()
        #expect(status?.title == "Search")
        #expect(splitView?.showSidebar == false, "selecting a row should close the overlay sidebar")
    }

    @Test @MainActor
    func overlaySplitViewStaysOpenWhenWide() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(OverlaySplitViewExample())
        defer { Self.tearDown(window) }

        let splitView = widgetOfType(root, OverlaySplitView.self)
        let list = widgetOfType(root, ListBox.self)
        let status = widgetOfType(root, StatusPage.self)
        #expect(splitView?.collapsed == false, "a wide window should not collapse the split view")

        _ = list?.rowAt(2)?.activate()
        #expect(status?.title == "Library")
        #expect(splitView?.showSidebar == true, "a side-by-side sidebar should stay open")
    }

    // MARK: - Preferences Dialog

    @Test @MainActor
    func preferencesDialogDarkModeDrivesStyleManager() {
        ensureDemoAdwInit()
        let styleManager = StyleManager.default
        let savedScheme = styleManager.colorScheme
        let (root, window) = Self.setUp(PreferencesDialogExample())
        defer {
            Self.tearDown(window)
            styleManager.colorScheme = savedScheme
            drainMainLoop()
        }

        buttonLabeled(root, "Open Preferences")?.emitClicked()
        drainMainLoop()
        let dialog = window.visibleDialog
        #expect(dialog != nil, "the preferences dialog should be presented on the window")
        guard let dialog else { return }

        let darkRow = Self.widgets(dialog, SwitchRow.self).first { $0.title == "Dark Mode" }
        #expect(darkRow != nil, "Dark Mode row not found in the dialog")
        guard let darkRow else { return }
        #expect(darkRow.active == styleManager.dark, "the row should show the current darkness")

        darkRow.active = true
        #expect(styleManager.dark == true, "turning Dark Mode on should make the app dark")
        darkRow.active = false
        #expect(styleManager.dark == false, "turning Dark Mode off should make the app light")

        // Changes made elsewhere are reflected by the row.
        styleManager.forceDark()
        #expect(darkRow.active == true)
        styleManager.forceLight()
        #expect(darkRow.active == false)
    }

    // MARK: - Spring Animation

    @Test @MainActor
    func springAnimationPlayMovesBall() {
        ensureDemoAdwInit()
        // Not presented on purpose: AdwAnimation skips straight to its end
        // value for an unmapped widget, which makes the outcome deterministic
        // (no frame clock needed) while still going through the real target.
        let root = SpringAnimationExample().buildWidget()

        let ball = Self.widgets(root, Box.self).first { $0.hasCSSClass("card") }
        let play = buttonLabeled(root, "Play Animation")
        #expect(ball != nil, "animated ball not found in tree")
        #expect(play != nil)
        #expect(ball?.marginTop == 0)

        play?.emitClicked()
        #expect(ball?.marginTop == 120, "the spring should settle the ball at its target offset")
    }

    // MARK: - Status Page

    @Test @MainActor
    func statusPageGetStartedUpdatesTitle() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(StatusPageExample())
        defer { Self.tearDown(window) }

        let status = widgetOfType(root, StatusPage.self)
        #expect(status?.title == "Welcome to swift-adwaita")
        buttonLabeled(root, "Get Started")?.emitClicked()
        #expect(status?.title == "Let's Go!")
    }

    // MARK: - Style Manager

    @Test @MainActor
    func styleManagerButtonsAndStatusLabel() {
        ensureDemoAdwInit()
        let styleManager = StyleManager.default
        let savedScheme = styleManager.colorScheme
        let (root, window) = Self.setUp(StyleManagerExample())
        defer {
            Self.tearDown(window)
            styleManager.colorScheme = savedScheme
            drainMainLoop()
        }

        let status = Self.labelWithPrefix(root, "Scheme:")
        #expect(status != nil, "status label not found in tree")
        func expectStatus(_ scheme: String, _ comment: Comment? = nil) {
            let dark = styleManager.dark ? "Yes" : "No"
            #expect(status?.text.hasPrefix("Scheme: \(scheme) | Dark: \(dark) |") == true, comment)
        }

        buttonLabeled(root, "Dark")?.emitClicked()
        #expect(styleManager.colorScheme == .forceDark)
        #expect(styleManager.dark == true)
        expectStatus("Force Dark")

        buttonLabeled(root, "Light")?.emitClicked()
        #expect(styleManager.colorScheme == .forceLight)
        #expect(styleManager.dark == false)
        expectStatus("Force Light")

        buttonLabeled(root, "Prefer Dark")?.emitClicked()
        #expect(styleManager.colorScheme == .preferDark)
        expectStatus("Prefer Dark")

        buttonLabeled(root, "System")?.emitClicked()
        #expect(styleManager.colorScheme == .default)
        expectStatus("Default (System)")

        // A scheme change made outside this page that keeps the same darkness
        // (force dark -> prefer dark on a system without a light preference,
        // or the reverse) must still update the label.
        styleManager.forceDark()
        expectStatus("Force Dark")
        styleManager.preferDark()
        expectStatus("Prefer Dark", "external scheme change should update the label")
    }

    // MARK: - Tab Overview

    @Test @MainActor
    func tabOverviewNewTabButtonCreatesTab() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(TabOverviewExample())
        defer { Self.tearDown(window) }

        let overview = widgetOfType(root, TabOverview.self)
        let tabView = widgetOfType(root, TabView.self)
        #expect(tabView?.nPages == 3)

        overview?.open = true
        drainMainLoop()
        // The overview's own "New Tab" button runs the example's create-tab handler.
        let newTab = Self.widgets(root, Button.self).first { $0.hasCSSClass("new-tab-button") }
        #expect(newTab != nil, "the overview's New Tab button not found in tree")
        newTab?.emitClicked()
        drainMainLoop()

        #expect(tabView?.nPages == 4)
        #expect(tabView?.selectedPage?.title == "New Tab", "the created tab should be selected")
        #expect(overview?.open == false, "creating a tab should close the overview")
    }

    // MARK: - Tab View

    @Test @MainActor
    func tabViewNewTabButtonAppendsPage() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(TabViewExample())
        defer { Self.tearDown(window) }

        let tabView = widgetOfType(root, TabView.self)
        let addBtn = widgetOfType(root, TabBar.self)?.endActionWidget?.tryCast(Button.self)
        #expect(tabView?.nPages == 3)
        #expect(addBtn != nil, "new-tab button not found as the tab bar's end action")

        addBtn?.emitClicked()
        #expect(tabView?.nPages == 4)
        #expect(tabView?.getNthPage(3).title == "Tab 4")
    }

    // MARK: - Toolbar View

    @Test @MainActor
    func toolbarSearchButtonRevealsSearchBar() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(ToolbarExample())
        defer { Self.tearDown(window) }

        // Not `widgetOfType`: the MenuButton next to it has an internal toggle.
        let searchBtn = Self.widgets(root, ToggleButton.self).first { $0.tooltipText == "Search" }
        let searchBar = widgetOfType(root, SearchBar.self)
        let entry = widgetOfType(root, SearchEntry.self)
        let content = widgetOfType(root, StatusPage.self)
        #expect(searchBtn != nil, "search toggle not found in tree")
        #expect(searchBar != nil, "search bar not found in tree")
        #expect(searchBar?.searchModeEnabled == false)

        searchBtn?.active = true
        #expect(searchBar?.searchModeEnabled == true, "the search button should reveal the search bar")

        entry?.text = "report"
        entry?.emitSearchChanged()
        #expect(content?.description == "Searching for “report”")
        entry?.text = ""
        entry?.emitSearchChanged()
        #expect(content?.description == "This is the main content between top and bottom toolbars")

        // Closing the bar by other means (close button, Escape) releases the toggle.
        searchBar?.searchModeEnabled = false
        #expect(searchBtn?.active == false)
    }

    @Test @MainActor
    func toolbarMenuTogglesBottomBar() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(ToolbarExample())
        defer { Self.tearDown(window) }

        let toolbarView = widgetOfType(root, ToolbarView.self)
        let menuBtn = widgetOfType(root, MenuButton.self)
        let check = widgetOfType(root, CheckButton.self)
        #expect(menuBtn?.popover != nil, "the menu button should have a menu")
        #expect(check != nil, "Show Bottom Bar check not found in the menu")
        #expect(toolbarView?.revealBottomBars == true)
        #expect(check?.active == true)

        check?.active = false
        #expect(toolbarView?.revealBottomBars == false)
        toolbarView?.revealBottomBars = true
        #expect(check?.active == true)
    }

    // MARK: - View Switcher

    @Test @MainActor
    func viewSwitcherMovesToBottomBarWhenNarrow() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(ViewSwitcherExample(), width: 400, height: 600)
        defer { Self.tearDown(window) }

        let switcher = widgetOfType(root, ViewSwitcher.self)
        let switcherBar = widgetOfType(root, ViewSwitcherBar.self)
        #expect(switcher != nil)
        #expect(switcherBar != nil)
        #expect(switcherBar?.reveal == true, "a narrow window should reveal the bottom switcher bar")
        #expect(switcher?.visible == false, "a narrow window should hide the header switcher")
    }

    @Test @MainActor
    func viewSwitcherStaysInHeaderWhenWide() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(ViewSwitcherExample())
        defer { Self.tearDown(window) }

        let switcher = widgetOfType(root, ViewSwitcher.self)
        let switcherBar = widgetOfType(root, ViewSwitcherBar.self)
        #expect(switcherBar?.reveal == false)
        #expect(switcher?.visible == true)
    }
}
#endif
