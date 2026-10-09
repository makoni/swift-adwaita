// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
#if swift(>=6.3)
import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct NavigationAndTabTests {

    // MARK: - TabView Tests

    @Test @MainActor func tabViewCreation() {
        ensureAdwInit()
        let tabView = TabView()
        #expect(tabView.nPages == 0)
        #expect(tabView.nPinnedPages == 0)
        #expect(tabView.selectedPage == nil)
        #expect(tabView.isTransferringPage == false)
    }

    @Test @MainActor func tabViewAppendPage() {
        ensureAdwInit()
        let tabView = TabView()
        let label1 = Label("Page 1")
        let page1 = tabView.append(label1)
        #expect(tabView.nPages == 1)
        page1.title = "First"
        #expect(page1.title == "First")

        let label2 = Label("Page 2")
        let page2 = tabView.append(label2)
        #expect(tabView.nPages == 2)
        page2.title = "Second"
        #expect(page2.title == "Second")
    }

    @Test @MainActor func tabViewPrependPage() {
        ensureAdwInit()
        let tabView = TabView()
        let label1 = Label("Page 1")
        let page1 = tabView.append(label1)
        let label2 = Label("Page 2")
        let page2 = tabView.prepend(label2)
        #expect(tabView.nPages == 2)
        // Prepended page should be at position 0
        let firstPage = tabView.getNthPage(0)
        #expect(tabView.getPagePosition(page2) == 0)
        #expect(tabView.getPagePosition(page1) == 1)
        _ = firstPage
    }

    @Test @MainActor func tabViewSelectedPage() {
        ensureAdwInit()
        let tabView = TabView()
        let label1 = Label("Page 1")
        let page1 = tabView.append(label1)
        let label2 = Label("Page 2")
        let page2 = tabView.append(label2)
        // First appended page should be selected
        #expect(page1.selected == true)
        // Select the second page
        tabView.selectedPage = page2
        #expect(page2.selected == true)
    }

    @Test @MainActor func tabViewGetNthPage() {
        ensureAdwInit()
        let tabView = TabView()
        let label1 = Label("Page 1")
        let page1 = tabView.append(label1)
        let label2 = Label("Page 2")
        _ = tabView.append(label2)
        let retrieved = tabView.getNthPage(0)
        #expect(retrieved.title == page1.title)
    }

    @Test @MainActor func tabViewGetPage() {
        ensureAdwInit()
        let tabView = TabView()
        let label = Label("Content")
        let page = tabView.append(label)
        page.title = "My Tab"
        let retrieved = tabView.getPage(label)
        #expect(retrieved.title == "My Tab")
    }

    @Test @MainActor func tabViewReorderPage() {
        ensureAdwInit()
        let tabView = TabView()
        let label1 = Label("Page 1")
        let page1 = tabView.append(label1)
        let label2 = Label("Page 2")
        let page2 = tabView.append(label2)
        page1.title = "First"
        page2.title = "Second"
        // Move page1 to position 1 (end)
        let moved = tabView.reorderPage(page1, position: 1)
        #expect(moved == true)
        #expect(tabView.getPagePosition(page1) == 1)
    }

    @Test @MainActor func tabViewSelectNextAndPrevious() {
        ensureAdwInit()
        let tabView = TabView()
        let label1 = Label("Page 1")
        _ = tabView.append(label1)
        let label2 = Label("Page 2")
        let page2 = tabView.append(label2)
        // Select next
        let hasNext = tabView.selectNextPage()
        #expect(hasNext == true)
        #expect(page2.selected == true)
        // Select previous
        let hasPrev = tabView.selectPreviousPage()
        #expect(hasPrev == true)
    }

    @Test @MainActor func tabViewPinPage() {
        ensureAdwInit()
        let tabView = TabView()
        let label1 = Label("Pinned Page")
        let page1 = tabView.append(label1)
        #expect(tabView.nPinnedPages == 0)
        tabView.setPagePinned(page1, pinned: true)
        #expect(tabView.nPinnedPages == 1)
        #expect(page1.pinned == true)
    }

    @Test @MainActor func tabViewAppendPinned() {
        ensureAdwInit()
        let tabView = TabView()
        let label = Label("Pinned")
        let page = tabView.appendPinned(label)
        #expect(page.pinned == true)
        #expect(tabView.nPinnedPages == 1)
        #expect(tabView.nPages == 1)
    }

    @Test @MainActor func tabViewInsertPage() {
        ensureAdwInit()
        let tabView = TabView()
        let label1 = Label("Page 1")
        _ = tabView.append(label1)
        let label2 = Label("Page 2")
        _ = tabView.append(label2)
        let label3 = Label("Inserted")
        let insertedPage = tabView.insert(label3, position: 1)
        #expect(tabView.nPages == 3)
        #expect(tabView.getPagePosition(insertedPage) == 1)
    }

    @Test @MainActor func tabViewShortcuts() {
        ensureAdwInit()
        let tabView = TabView()
        let initial = tabView.shortcuts
        // Set and read back
        tabView.shortcuts = initial
        #expect(tabView.shortcuts == initial)
    }

    @Test @MainActor func tabViewOnClosePageSignal() {
        ensureAdwInit()
        let tabView = TabView()
        let conn = tabView.onClosePage { _ in false }
        conn.disconnect()
    }

    @Test @MainActor func tabViewOnClosePageSignalEmitted() {
        ensureAdwInit()
        let tabView = TabView()
        let page = tabView.append(Label("x"))
        var fired = false
        let conn = tabView.onClosePage { p in
            fired = true
            _ = p
            return true
        }
        let ret = cadw_signal_emit_close_page(tabView.pointer, page.pointer)
        #expect(fired, "onClosePage handler should fire")
        #expect(ret != 0, "the handler's return value must reach the signal's return")
        conn.disconnect()
    }

    @Test @MainActor func tabViewOnClosePageCancelKeepsPage() {
        ensureAdwInit()
        let tabView = TabView()
        let page = tabView.append(Label("x"))
        var fired = false
        let conn = tabView.onClosePage { p in
            fired = true
            tabView.closePageFinish(p, confirm: false)
            return true
        }
        tabView.closePage(page)
        #expect(fired, "onClosePage handler should fire")
        #expect(tabView.nPages == 1, "cancelling the close must keep the page")
        conn.disconnect()
    }

    @Test @MainActor func tabViewOnClosePageConfirmClosesPage() {
        ensureAdwInit()
        let tabView = TabView()
        let page = tabView.append(Label("x"))
        var fired = false
        let conn = tabView.onClosePage { p in
            fired = true
            tabView.closePageFinish(p, confirm: true)
            return true
        }
        tabView.closePage(page)
        #expect(fired, "onClosePage handler should fire")
        #expect(tabView.nPages == 0, "confirming the close must remove the page")
        conn.disconnect()
    }

    @Test @MainActor func tabViewOnClosePageReturnFalseClosesPage() {
        ensureAdwInit()
        let tabView = TabView()
        let page = tabView.append(Label("x"))
        var fired = false
        let conn = tabView.onClosePage { p in
            fired = true
            _ = p
            return false
        }
        tabView.closePage(page)
        #expect(fired, "onClosePage handler should fire")
        #expect(tabView.nPages == 0, "returning false must fall through to the default close")
        conn.disconnect()
    }

    @Test @MainActor func tabViewOnCreateWindowSignal() {
        ensureAdwInit()
        let tabView = TabView()
        var fired = false
        let conn = tabView.onCreateWindow {
            fired = true
            return nil
        }
        cadw_signal_emit_no_args(tabView.pointer, "create-window")
        #expect(fired, "onCreateWindow handler should fire (nil result)")
        conn.disconnect()
    }

    @Test @MainActor func tabViewOnCreateWindowSignalReturnsView() {
        ensureAdwInit()
        let tabView = TabView()
        let dest = TabView()
        var fired = false
        let conn = tabView.onCreateWindow {
            fired = true
            return dest
        }
        let raw = cadw_signal_emit_create_window(tabView.gobjectPointer)
        #expect(fired, "onCreateWindow handler should fire and return the destination view")
        #expect(raw != nil, "the signal must hand back the destination view")
        #expect(raw == dest.pointer, "the returned pointer must reach the caller (transfer-none borrow)")
        conn.disconnect()
    }

    @Test @MainActor func navigationViewOnGetNextPageSignal() {
        ensureAdwInit()
        let navView = NavigationView()
        var fired = false
        let conn = navView.onGetNextPage {
            fired = true
            return NavigationPage(child: Label("next"), title: "next")
        }
        let raw = cadw_signal_emit_get_next_page(navView.gobjectPointer)
        #expect(fired, "onGetNextPage handler should fire")
        #expect(raw != nil, "the signal must hand back the created page")
        if let raw {
            g_object_unref(raw.assumingMemoryBound(to: GObject.self))
        }
        conn.disconnect()
    }

    @Test @MainActor func navigationViewOnGetNextPageFinalizesOnce() {
        ensureAdwInit()
        let navView = NavigationView()
        var created = false
        var weakSlot: WeakPointerSlot?
        // The handler keeps NO reference to the page it creates. This is the
        // case that would use-after-free if the return-object trampoline failed
        // to add its `g_object_ref` before the caller's temporary `NavigationPage`
        // was deallocated: the page would finalize early and the weak pointer
        // below would already be cleared. A weak pointer is registered inside the
        // handler so the test can observe the page finalizing exactly once.
        navView.onGetNextPage {
            created = true
            let p = NavigationPage(child: Label("next"), title: "next")
            weakSlot = WeakPointerSlot(watching: p.gobjectPointer)
            return p
        }
        let raw = cadw_signal_emit_get_next_page(navView.gobjectPointer)
        #expect(created, "onGetNextPage handler should fire")
        #expect(raw != nil, "the signal must hand back a live reference to the page")
        #expect(weakSlot != nil, "the handler must have registered the weak pointer")
        let stillAlive = weakSlot?.isCleared == false
        #expect(stillAlive, "the page must still be alive once handed to the caller (transfer-full ref)")
        if let raw {
            g_object_unref(raw.assumingMemoryBound(to: GObject.self))
        }
        spinMainLoop()
        #expect(weakSlot?.isCleared == true, "the page must finalize exactly once after the caller releases it")
    }

    @Test @MainActor func tabViewTransferPage() {
        ensureAdwInit()
        let tabView1 = TabView()
        let tabView2 = TabView()
        let label = Label("Transfer Me")
        let page = tabView1.append(label)
        #expect(tabView1.nPages == 1)
        #expect(tabView2.nPages == 0)
        tabView1.transferPage(page, otherView: tabView2, position: 0)
        #expect(tabView1.nPages == 0)
        #expect(tabView2.nPages == 1)
    }

    @Test @MainActor func tabOverviewCreateTabSignalAddsAndFinalizesPage() {
        ensureAdwInit()
        let tabView = TabView()
        let overview = TabOverview()
        overview.view = tabView
        overview.enableNewTab = true

        var emitted = false
        overview.onCreateTab {
            emitted = true
            let label = Label("New Tab")
            let page = tabView.append(label)
            page.title = "New Tab"
            return page
        }

        // Fire create-tab through the real signal path so the C marshaller
        // (g_value_take_object) runs, exactly as libadwaita's "New Tab" button
        // would. A broken handler leaves the returned page over-released and
        // the view holding a dangling pointer (SIGSEGV here).
        cadw_signal_emit_no_args(overview.pointer, "create-tab")

        #expect(emitted, "onCreateTab handler should fire")
        #expect(tabView.nPages == 1, "The handler must append exactly one page")

        // Watch the underlying C object for finalization, then close the tab.
        // With the refcount balanced the page finalizes exactly once (weak
        // pointer reset to NULL); an over-release crashes and a leak keeps the
        // weak pointer set.
        var weakSlot: WeakPointerSlot?
        if let page = tabView.selectedPage {
            // Watch the underlying C object from a heap slot: on a balanced
            // refcount the page finalizes exactly once (when `page` and the
            // tab view both release it on close) and the slot is cleared; an
            // over-release crashes earlier, a leak leaves it set. The check
            // lives below the `if` so `page`'s own reference is dropped
            // first — otherwise the page cannot reach refcount zero.
            weakSlot = WeakPointerSlot(watching: page.gobjectPointer)
            tabView.onClosePage { p in
                tabView.closePageFinish(p, confirm: true)
                return true
            }
            tabView.closePage(page)
        }
        spinMainLoop()
        #expect(weakSlot?.isCleared == true, "Closed page must finalize exactly once (balanced refcount)")
    }

    // MARK: - TabBar Tests

    @Test @MainActor func tabBarCreation() {
        ensureAdwInit()
        let tabBar = TabBar()
        #expect(tabBar.view == nil)
        #expect(tabBar.isOverflowing == false)
    }

    @Test @MainActor func tabBarViewProperty() {
        ensureAdwInit()
        let tabBar = TabBar()
        let tabView = TabView()
        tabBar.view = tabView
        #expect(tabBar.view != nil)
    }

    @Test @MainActor func tabBarAutohide() {
        ensureAdwInit()
        let tabBar = TabBar()
        tabBar.autohide = true
        #expect(tabBar.autohide == true)
        tabBar.autohide = false
        #expect(tabBar.autohide == false)
    }

    @Test @MainActor func tabBarExpandTabs() {
        ensureAdwInit()
        let tabBar = TabBar()
        tabBar.expandTabs = true
        #expect(tabBar.expandTabs == true)
        tabBar.expandTabs = false
        #expect(tabBar.expandTabs == false)
    }

    @Test @MainActor func tabBarInverted() {
        ensureAdwInit()
        let tabBar = TabBar()
        tabBar.inverted = false
        #expect(tabBar.inverted == false)
        tabBar.inverted = true
        #expect(tabBar.inverted == true)
    }

    // MARK: - TabButton Tests

    @Test @MainActor func tabButtonCreation() {
        ensureAdwInit()
        let tabButton = TabButton()
        #expect(tabButton.view == nil)
    }

    @Test @MainActor func tabButtonViewProperty() {
        ensureAdwInit()
        let tabButton = TabButton()
        let tabView = TabView()
        tabButton.view = tabView
        #expect(tabButton.view != nil)
    }

    @Test @MainActor func tabButtonSignals() {
        ensureAdwInit()
        let tabButton = TabButton()
        let conn = tabButton.onClicked {}
        conn.disconnect()
    }

    // MARK: - TabPage Property Tests

    @Test @MainActor func tabPageTitleAndTooltip() {
        ensureAdwInit()
        let tabView = TabView()
        let label = Label("Content")
        let page = tabView.append(label)
        page.title = "My Title"
        #expect(page.title == "My Title")
        page.tooltip = "Hover text"
        #expect(page.tooltip == "Hover text")
    }

    @Test @MainActor func tabPageLoadingAndAttention() {
        ensureAdwInit()
        let tabView = TabView()
        let label = Label("Content")
        let page = tabView.append(label)
        page.loading = true
        #expect(page.loading == true)
        page.loading = false
        #expect(page.loading == false)
        page.needsAttention = true
        #expect(page.needsAttention == true)
        page.needsAttention = false
        #expect(page.needsAttention == false)
    }

    @Test @MainActor func tabPageIndicatorProperties() {
        ensureAdwInit()
        let tabView = TabView()
        let label = Label("Content")
        let page = tabView.append(label)
        page.indicatorActivatable = true
        #expect(page.indicatorActivatable == true)
        page.indicatorTooltip = "Click to close"
        #expect(page.indicatorTooltip == "Click to close")
    }

    @Test @MainActor func tabPageKeyword() {
        ensureAdwInit()
        let tabView = TabView()
        let label = Label("Content")
        let page = tabView.append(label)
        page.keyword = "search-term"
        #expect(page.keyword == "search-term")
    }

    @Test @MainActor func tabPageLiveThumbnail() {
        ensureAdwInit()
        let tabView = TabView()
        let label = Label("Content")
        let page = tabView.append(label)
        page.liveThumbnail = true
        #expect(page.liveThumbnail == true)
        page.liveThumbnail = false
        #expect(page.liveThumbnail == false)
    }

    @Test @MainActor func tabPageReadOnlyProperties() {
        ensureAdwInit()
        let tabView = TabView()
        let label = Label("Content")
        let page = tabView.append(label)
        // pinned and selected are read-only
        #expect(page.pinned == false)
        #expect(page.selected == true) // first page is auto-selected
        // child is read-only
        #expect(page.child.pointer != nil)
    }
}
#endif
#endif
