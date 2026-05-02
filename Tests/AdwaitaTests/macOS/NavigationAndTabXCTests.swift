#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class NavigationAndTabXCTests: XCTestCase {

    // MARK: - TabView Tests

    @MainActor func test_tabViewCreation() {
        ensureAdwInit()
        let tabView = TabView()
        XCTAssertTrue(tabView.nPages == 0)
        XCTAssertTrue(tabView.nPinnedPages == 0)
        XCTAssertNil(tabView.selectedPage)
        XCTAssertTrue(tabView.isTransferringPage == false)
    }

    @MainActor func test_tabViewAppendPage() {
        ensureAdwInit()
        let tabView = TabView()
        let label1 = Label("Page 1")
        let page1 = tabView.append(label1)
        XCTAssertTrue(tabView.nPages == 1)
        page1.title = "First"
        XCTAssertTrue(page1.title == "First")

        let label2 = Label("Page 2")
        let page2 = tabView.append(label2)
        XCTAssertTrue(tabView.nPages == 2)
        page2.title = "Second"
        XCTAssertTrue(page2.title == "Second")
    }

    @MainActor func test_tabViewPrependPage() {
        ensureAdwInit()
        let tabView = TabView()
        let label1 = Label("Page 1")
        let page1 = tabView.append(label1)
        let label2 = Label("Page 2")
        let page2 = tabView.prepend(label2)
        XCTAssertTrue(tabView.nPages == 2)
        // Prepended page should be at position 0
        let firstPage = tabView.getNthPage(0)
        XCTAssertTrue(tabView.getPagePosition(page2) == 0)
        XCTAssertTrue(tabView.getPagePosition(page1) == 1)
        _ = firstPage
    }

    @MainActor func test_tabViewSelectedPage() {
        ensureAdwInit()
        let tabView = TabView()
        let label1 = Label("Page 1")
        let page1 = tabView.append(label1)
        let label2 = Label("Page 2")
        let page2 = tabView.append(label2)
        // First appended page should be selected
        XCTAssertTrue(page1.selected == true)
        // Select the second page
        tabView.selectedPage = page2
        XCTAssertTrue(page2.selected == true)
    }

    @MainActor func test_tabViewGetNthPage() {
        ensureAdwInit()
        let tabView = TabView()
        let label1 = Label("Page 1")
        let page1 = tabView.append(label1)
        let label2 = Label("Page 2")
        _ = tabView.append(label2)
        let retrieved = tabView.getNthPage(0)
        XCTAssertTrue(retrieved.title == page1.title)
    }

    @MainActor func test_tabViewGetPage() {
        ensureAdwInit()
        let tabView = TabView()
        let label = Label("Content")
        let page = tabView.append(label)
        page.title = "My Tab"
        let retrieved = tabView.getPage(label)
        XCTAssertTrue(retrieved.title == "My Tab")
    }

    @MainActor func test_tabViewReorderPage() {
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
        XCTAssertTrue(moved == true)
        XCTAssertTrue(tabView.getPagePosition(page1) == 1)
    }

    @MainActor func test_tabViewSelectNextAndPrevious() {
        ensureAdwInit()
        let tabView = TabView()
        let label1 = Label("Page 1")
        _ = tabView.append(label1)
        let label2 = Label("Page 2")
        let page2 = tabView.append(label2)
        // Select next
        let hasNext = tabView.selectNextPage()
        XCTAssertTrue(hasNext == true)
        XCTAssertTrue(page2.selected == true)
        // Select previous
        let hasPrev = tabView.selectPreviousPage()
        XCTAssertTrue(hasPrev == true)
    }

    @MainActor func test_tabViewPinPage() {
        ensureAdwInit()
        let tabView = TabView()
        let label1 = Label("Pinned Page")
        let page1 = tabView.append(label1)
        XCTAssertTrue(tabView.nPinnedPages == 0)
        tabView.setPagePinned(page1, pinned: true)
        XCTAssertTrue(tabView.nPinnedPages == 1)
        XCTAssertTrue(page1.pinned == true)
    }

    @MainActor func test_tabViewAppendPinned() {
        ensureAdwInit()
        let tabView = TabView()
        let label = Label("Pinned")
        let page = tabView.appendPinned(label)
        XCTAssertTrue(page.pinned == true)
        XCTAssertTrue(tabView.nPinnedPages == 1)
        XCTAssertTrue(tabView.nPages == 1)
    }

    @MainActor func test_tabViewInsertPage() {
        ensureAdwInit()
        let tabView = TabView()
        let label1 = Label("Page 1")
        _ = tabView.append(label1)
        let label2 = Label("Page 2")
        _ = tabView.append(label2)
        let label3 = Label("Inserted")
        let insertedPage = tabView.insert(label3, position: 1)
        XCTAssertTrue(tabView.nPages == 3)
        XCTAssertTrue(tabView.getPagePosition(insertedPage) == 1)
    }

    @MainActor func test_tabViewShortcuts() {
        ensureAdwInit()
        let tabView = TabView()
        let initial = tabView.shortcuts
        // Set and read back
        tabView.shortcuts = initial
        XCTAssertTrue(tabView.shortcuts == initial)
    }

    @MainActor func test_tabViewOnClosePageSignal() {
        ensureAdwInit()
        let tabView = TabView()
        let conn = tabView.onClosePage { _ in }
        conn.disconnect()
    }

    @MainActor func test_tabViewTransferPage() {
        ensureAdwInit()
        let tabView1 = TabView()
        let tabView2 = TabView()
        let label = Label("Transfer Me")
        let page = tabView1.append(label)
        XCTAssertTrue(tabView1.nPages == 1)
        XCTAssertTrue(tabView2.nPages == 0)
        tabView1.transferPage(page, otherView: tabView2, position: 0)
        XCTAssertTrue(tabView1.nPages == 0)
        XCTAssertTrue(tabView2.nPages == 1)
    }

    // MARK: - TabBar Tests

    @MainActor func test_tabBarCreation() {
        ensureAdwInit()
        let tabBar = TabBar()
        XCTAssertNil(tabBar.view)
        XCTAssertTrue(tabBar.isOverflowing == false)
    }

    @MainActor func test_tabBarViewProperty() {
        ensureAdwInit()
        let tabBar = TabBar()
        let tabView = TabView()
        tabBar.view = tabView
        XCTAssertNotNil(tabBar.view)
    }

    @MainActor func test_tabBarAutohide() {
        ensureAdwInit()
        let tabBar = TabBar()
        tabBar.autohide = true
        XCTAssertTrue(tabBar.autohide == true)
        tabBar.autohide = false
        XCTAssertTrue(tabBar.autohide == false)
    }

    @MainActor func test_tabBarExpandTabs() {
        ensureAdwInit()
        let tabBar = TabBar()
        tabBar.expandTabs = true
        XCTAssertTrue(tabBar.expandTabs == true)
        tabBar.expandTabs = false
        XCTAssertTrue(tabBar.expandTabs == false)
    }

    @MainActor func test_tabBarInverted() {
        ensureAdwInit()
        let tabBar = TabBar()
        tabBar.inverted = false
        XCTAssertTrue(tabBar.inverted == false)
        tabBar.inverted = true
        XCTAssertTrue(tabBar.inverted == true)
    }

    // MARK: - TabButton Tests

    @MainActor func test_tabButtonCreation() {
        ensureAdwInit()
        let tabButton = TabButton()
        XCTAssertNil(tabButton.view)
    }

    @MainActor func test_tabButtonViewProperty() {
        ensureAdwInit()
        let tabButton = TabButton()
        let tabView = TabView()
        tabButton.view = tabView
        XCTAssertNotNil(tabButton.view)
    }

    @MainActor func test_tabButtonSignals() {
        ensureAdwInit()
        let tabButton = TabButton()
        let conn = tabButton.onClicked {}
        conn.disconnect()
    }

    // MARK: - TabPage Property Tests

    @MainActor func test_tabPageTitleAndTooltip() {
        ensureAdwInit()
        let tabView = TabView()
        let label = Label("Content")
        let page = tabView.append(label)
        page.title = "My Title"
        XCTAssertTrue(page.title == "My Title")
        page.tooltip = "Hover text"
        XCTAssertTrue(page.tooltip == "Hover text")
    }

    @MainActor func test_tabPageLoadingAndAttention() {
        ensureAdwInit()
        let tabView = TabView()
        let label = Label("Content")
        let page = tabView.append(label)
        page.loading = true
        XCTAssertTrue(page.loading == true)
        page.loading = false
        XCTAssertTrue(page.loading == false)
        page.needsAttention = true
        XCTAssertTrue(page.needsAttention == true)
        page.needsAttention = false
        XCTAssertTrue(page.needsAttention == false)
    }

    @MainActor func test_tabPageIndicatorProperties() {
        ensureAdwInit()
        let tabView = TabView()
        let label = Label("Content")
        let page = tabView.append(label)
        page.indicatorActivatable = true
        XCTAssertTrue(page.indicatorActivatable == true)
        page.indicatorTooltip = "Click to close"
        XCTAssertTrue(page.indicatorTooltip == "Click to close")
    }

    @MainActor func test_tabPageKeyword() {
        ensureAdwInit()
        let tabView = TabView()
        let label = Label("Content")
        let page = tabView.append(label)
        page.keyword = "search-term"
        XCTAssertTrue(page.keyword == "search-term")
    }

    @MainActor func test_tabPageLiveThumbnail() {
        ensureAdwInit()
        let tabView = TabView()
        let label = Label("Content")
        let page = tabView.append(label)
        page.liveThumbnail = true
        XCTAssertTrue(page.liveThumbnail == true)
        page.liveThumbnail = false
        XCTAssertTrue(page.liveThumbnail == false)
    }

    @MainActor func test_tabPageReadOnlyProperties() {
        ensureAdwInit()
        let tabView = TabView()
        let label = Label("Content")
        let page = tabView.append(label)
        // pinned and selected are read-only
        XCTAssertTrue(page.pinned == false)
        XCTAssertTrue(page.selected == true) // first page is auto-selected
        // child is read-only
        XCTAssertNotNil(page.child.pointer)
    }
}
#endif
