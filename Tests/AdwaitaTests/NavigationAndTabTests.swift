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
        let conn = tabView.onClosePage { _ in }
        conn.disconnect()
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
