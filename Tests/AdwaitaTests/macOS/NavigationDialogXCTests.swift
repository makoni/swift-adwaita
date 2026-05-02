#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class NavigationDialogXCTests: XCTestCase {

    // MARK: - Notebook Tests

    @MainActor func test_notebookAppendAndRemovePage() {
        ensureAdwInit()
        let notebook = Notebook()
        let label1 = Label("Page 1")
        let idx1 = notebook.appendPage(label1, label: "First")
        XCTAssertTrue(idx1 == 0)
        XCTAssertTrue(notebook.nPages == 1)

        let label2 = Label("Page 2")
        let idx2 = notebook.appendPage(label2, label: "Second")
        XCTAssertTrue(idx2 == 1)
        XCTAssertTrue(notebook.nPages == 2)

        notebook.removePage(at: 0)
        XCTAssertTrue(notebook.nPages == 1)
    }

    @MainActor func test_notebookShowTabs() {
        ensureAdwInit()
        let notebook = Notebook()
        notebook.showTabs = false
        XCTAssertTrue(notebook.showTabs == false)
        notebook.showTabs = true
        XCTAssertTrue(notebook.showTabs == true)
    }

    @MainActor func test_notebookShowBorder() {
        ensureAdwInit()
        let notebook = Notebook()
        notebook.showBorder = false
        XCTAssertTrue(notebook.showBorder == false)
        notebook.showBorder = true
        XCTAssertTrue(notebook.showBorder == true)
    }

    @MainActor func test_notebookTabPos() {
        ensureAdwInit()
        let notebook = Notebook()
        notebook.tabPos = GTK_POS_BOTTOM
        XCTAssertTrue(notebook.tabPos == GTK_POS_BOTTOM)
        notebook.tabPos = GTK_POS_LEFT
        XCTAssertTrue(notebook.tabPos == GTK_POS_LEFT)
        notebook.tabPos = GTK_POS_TOP
        XCTAssertTrue(notebook.tabPos == GTK_POS_TOP)
    }

    @MainActor func test_notebookScrollable() {
        ensureAdwInit()
        let notebook = Notebook()
        notebook.scrollable = true
        XCTAssertTrue(notebook.scrollable == true)
        notebook.scrollable = false
        XCTAssertTrue(notebook.scrollable == false)
    }

    @MainActor func test_notebookGetNthPage() {
        ensureAdwInit()
        let notebook = Notebook()
        let label = Label("Content")
        notebook.appendPage(label, label: "Tab")
        let retrieved = notebook.getNthPage(0)
        XCTAssertNotNil(retrieved)
    }

    @MainActor func test_notebookPrependAndInsert() {
        ensureAdwInit()
        let notebook = Notebook()
        let label1 = Label("First")
        notebook.appendPage(label1, label: "First")
        let label2 = Label("Prepended")
        let prependIdx = notebook.prependPage(label2, label: "Prepended")
        XCTAssertTrue(prependIdx == 0)
        XCTAssertTrue(notebook.nPages == 2)

        let label3 = Label("Inserted")
        let insertIdx = notebook.insertPage(label3, label: "Inserted", position: 1)
        XCTAssertTrue(insertIdx == 1)
        XCTAssertTrue(notebook.nPages == 3)
    }

    @MainActor func test_notebookNextPrevPage() {
        ensureAdwInit()
        let notebook = Notebook()
        let label1 = Label("Page 1")
        let label2 = Label("Page 2")
        notebook.appendPage(label1, label: "First")
        notebook.appendPage(label2, label: "Second")
        notebook.currentPage = 0
        notebook.nextPage()
        XCTAssertTrue(notebook.currentPage == 1)
        notebook.prevPage()
        XCTAssertTrue(notebook.currentPage == 0)
    }

    @MainActor func test_notebookTabLabelText() {
        ensureAdwInit()
        let notebook = Notebook()
        let label = Label("Content")
        notebook.appendPage(label, label: "Original")
        let originalText = notebook.getTabLabelText(label)
        XCTAssertTrue(originalText == "Original")
        notebook.setTabLabelText(label, text: "Changed")
        let changedText = notebook.getTabLabelText(label)
        XCTAssertTrue(changedText == "Changed")
    }

    @MainActor func test_notebookChainingMethods() {
        ensureAdwInit()
        let notebook = Notebook()
            .scrollable(true)
            .tabPos(GTK_POS_BOTTOM)
        XCTAssertTrue(notebook.scrollable == true)
        XCTAssertTrue(notebook.tabPos == GTK_POS_BOTTOM)
    }

    // MARK: - NavigationView Tests

    @MainActor func test_navigationViewCreation() {
        ensureAdwInit()
        let nav = NavigationView()
        XCTAssertNil(nav.visiblePage)
        XCTAssertTrue(nav.animateTransitions == true)
        XCTAssertTrue(nav.popOnEscape == true)
    }

    @MainActor func test_navigationViewPushAndPop() {
        ensureAdwInit()
        let nav = NavigationView()
        let label1 = Label("Page 1")
        let page1 = nav.push(title: "First", child: label1)
        XCTAssertNotNil(nav.visiblePage)
        XCTAssertTrue(nav.visiblePage?.title == "First")

        let label2 = Label("Page 2")
        nav.push(title: "Second", child: label2)
        XCTAssertTrue(nav.visiblePage?.title == "Second")

        nav.animateTransitions = false
        let didPop = nav.pop()
        XCTAssertTrue(didPop == true)
        _ = page1
    }

    @MainActor func test_navigationViewPushWithTag() {
        ensureAdwInit()
        let nav = NavigationView()
        nav.animateTransitions = false
        let label = Label("Content")
        let page = nav.push(title: "Tagged Page", tag: "my-tag", child: label)
        XCTAssertTrue(page.tag == "my-tag")
        // visiblePageTag requires libadwaita 1.7+ and a realized widget
    }

    @MainActor func test_navigationViewFindPage() {
        ensureAdwInit()
        let nav = NavigationView()
        nav.animateTransitions = false
        let label = Label("Content")
        nav.push(title: "Tagged", tag: "find-me", child: label)
        let found = nav.findPage("find-me")
        XCTAssertNotNil(found)
        XCTAssertTrue(found?.title == "Tagged")
        let notFound = nav.findPage("nonexistent")
        XCTAssertNil(notFound)
    }

    @MainActor func test_navigationViewOnPoppedSignal() {
        ensureAdwInit()
        let nav = NavigationView()
        let conn = nav.onPopped { _ in }
        conn.disconnect()
    }

    // MARK: - NavigationPage Tests

    @MainActor func test_navigationPageCreation() {
        ensureAdwInit()
        let label = Label("Content")
        let page = NavigationPage(child: label, title: "My Page")
        XCTAssertTrue(page.title == "My Page")
        XCTAssertNotNil(page.child)
        XCTAssertNil(page.tag)
    }

    @MainActor func test_navigationPageTitle() {
        ensureAdwInit()
        let label = Label("Content")
        let page = NavigationPage(child: label, title: "Original")
        page.title = "Updated"
        XCTAssertTrue(page.title == "Updated")
    }

    @MainActor func test_navigationPageTag() {
        ensureAdwInit()
        let label = Label("Content")
        let page = NavigationPage.newWithTag(child: label, title: "Tagged", tag: "settings")
        XCTAssertTrue(page.tag == "settings")
        page.tag = "new-tag"
        XCTAssertTrue(page.tag == "new-tag")
    }

    @MainActor func test_navigationPageCanPop() {
        ensureAdwInit()
        let label = Label("Content")
        let page = NavigationPage(child: label, title: "Page")
        XCTAssertTrue(page.canPop == true)
        page.canPop = false
        XCTAssertTrue(page.canPop == false)
        page.canPop = true
        XCTAssertTrue(page.canPop == true)
    }

    // MARK: - NavigationSplitView Tests

    @MainActor func test_navigationSplitViewCreation() {
        ensureAdwInit()
        let splitView = NavigationSplitView()
        XCTAssertTrue(splitView.collapsed == false)
        XCTAssertTrue(splitView.showContent == false)
    }

    @MainActor func test_navigationSplitViewSidebarAndContent() {
        ensureAdwInit()
        let splitView = NavigationSplitView()
        let sidebarLabel = Label("Sidebar")
        let contentLabel = Label("Content")
        let sidebar = NavigationPage(child: sidebarLabel, title: "Sidebar")
        let content = NavigationPage(child: contentLabel, title: "Content")
        splitView.setSidebar(sidebar)
        splitView.setContent(content)
        // Should not crash
        splitView.showContent = true
        XCTAssertTrue(splitView.showContent == true)
    }

    @MainActor func test_navigationSplitViewCollapsed() {
        ensureAdwInit()
        let splitView = NavigationSplitView()
        splitView.collapsed = true
        XCTAssertTrue(splitView.collapsed == true)
        splitView.collapsed = false
        XCTAssertTrue(splitView.collapsed == false)
    }

    @MainActor func test_navigationSplitViewSidebarWidth() {
        ensureAdwInit()
        let splitView = NavigationSplitView()
        splitView.minSidebarWidth = 200
        XCTAssertTrue(splitView.minSidebarWidth == 200)
        splitView.maxSidebarWidth = 400
        XCTAssertTrue(splitView.maxSidebarWidth == 400)
        splitView.sidebarWidthFraction = 0.33
        XCTAssertTrue(abs(splitView.sidebarWidthFraction - 0.33) < 0.01)
    }

    // MARK: - OverlaySplitView Tests

    @MainActor func test_overlaySplitViewCreation() {
        ensureAdwInit()
        let osv = OverlaySplitView()
        XCTAssertTrue(osv.collapsed == false)
        XCTAssertTrue(osv.showSidebar == true)
    }

    @MainActor func test_overlaySplitViewSidebarAndContent() {
        ensureAdwInit()
        let sidebar = Label("Sidebar")
        let content = Label("Content")
        let osv = OverlaySplitView(sidebar: sidebar, content: content)
        XCTAssertNotNil(osv.sidebar)
        XCTAssertNotNil(osv.content)
    }

    @MainActor func test_overlaySplitViewCollapsedAndShowSidebar() {
        ensureAdwInit()
        let osv = OverlaySplitView()
        osv.collapsed = true
        XCTAssertTrue(osv.collapsed == true)
        osv.showSidebar = false
        XCTAssertTrue(osv.showSidebar == false)
        osv.showSidebar = true
        XCTAssertTrue(osv.showSidebar == true)
    }

    @MainActor func test_overlaySplitViewPinSidebar() {
        ensureAdwInit()
        let osv = OverlaySplitView()
        osv.pinSidebar = true
        XCTAssertTrue(osv.pinSidebar == true)
        osv.pinSidebar = false
        XCTAssertTrue(osv.pinSidebar == false)
    }

    @MainActor func test_overlaySplitViewSidebarWidths() {
        ensureAdwInit()
        let osv = OverlaySplitView()
        osv.sidebarWidthFraction = 0.25
        XCTAssertTrue(abs(osv.sidebarWidthFraction - 0.25) < 0.01)
        osv.minSidebarWidth = 180
        XCTAssertTrue(osv.minSidebarWidth == 180)
        osv.maxSidebarWidth = 350
        XCTAssertTrue(osv.maxSidebarWidth == 350)
    }

    // MARK: - Dialog Tests

    @MainActor func test_dialogCreation() {
        ensureAdwInit()
        let dialog = Dialog()
        XCTAssertTrue(dialog.title == "")
        XCTAssertTrue(dialog.contentWidth == -1)
        XCTAssertTrue(dialog.contentHeight == -1)
        XCTAssertTrue(dialog.canClose == true)
    }

    @MainActor func test_dialogTitle() {
        ensureAdwInit()
        let dialog = Dialog()
        dialog.title = "Preferences"
        XCTAssertTrue(dialog.title == "Preferences")
    }

    @MainActor func test_dialogContentDimensions() {
        ensureAdwInit()
        let dialog = Dialog()
        dialog.contentWidth = 400
        dialog.contentHeight = 300
        XCTAssertTrue(dialog.contentWidth == 400)
        XCTAssertTrue(dialog.contentHeight == 300)
    }

    @MainActor func test_dialogChild() {
        ensureAdwInit()
        let dialog = Dialog()
        let label = Label("Dialog Content")
        dialog.child = label
        XCTAssertNotNil(dialog.child)
    }

    @MainActor func test_dialogCanClose() {
        ensureAdwInit()
        let dialog = Dialog()
        dialog.canClose = false
        XCTAssertTrue(dialog.canClose == false)
        dialog.canClose = true
        XCTAssertTrue(dialog.canClose == true)
    }

    @MainActor func test_dialogFollowsContentSize() {
        ensureAdwInit()
        let dialog = Dialog()
        dialog.followsContentSize = true
        XCTAssertTrue(dialog.followsContentSize == true)
        dialog.followsContentSize = false
        XCTAssertTrue(dialog.followsContentSize == false)
    }

    // MARK: - AboutDialog Tests

    @MainActor func test_aboutDialogCreation() {
        ensureAdwInit()
        let about = AboutDialog()
        XCTAssertTrue(about.applicationName == "")
        XCTAssertTrue(about.version == "")
    }

    @MainActor func test_aboutDialogProperties() {
        ensureAdwInit()
        let about = AboutDialog()
        about.applicationName = "My App"
        XCTAssertTrue(about.applicationName == "My App")
        about.applicationIcon = "my-app-icon"
        XCTAssertTrue(about.applicationIcon == "my-app-icon")
        about.developerName = "Jane Doe"
        XCTAssertTrue(about.developerName == "Jane Doe")
        about.version = "2.0"
        XCTAssertTrue(about.version == "2.0")
        about.website = "https://example.org"
        XCTAssertTrue(about.website == "https://example.org")
        about.issueUrl = "https://github.com/example/issues"
        XCTAssertTrue(about.issueUrl == "https://github.com/example/issues")
        about.copyright = "2025 Jane Doe"
        XCTAssertTrue(about.copyright == "2025 Jane Doe")
        about.license = "MIT License text"
        XCTAssertTrue(about.license == "MIT License text")
    }

    @MainActor func test_aboutDialogTranslatorCredits() {
        ensureAdwInit()
        let about = AboutDialog()
        about.translatorCredits = "Translator Name <translator@example.com>"
        XCTAssertTrue(about.translatorCredits == "Translator Name <translator@example.com>")
    }

    @MainActor func test_aboutDialogAddOtherApp() {
        ensureAdwInit()
        let about = AboutDialog()
        // Should not crash
        about.addOtherApp("com.example.OtherApp", name: "Other App", summary: "A companion app")
    }

    @MainActor func test_aboutDialogAddLink() {
        ensureAdwInit()
        let about = AboutDialog()
        // Should not crash
        about.addLink("Donate", url: "https://example.com/donate")
    }

    @MainActor func test_aboutDialogComments() {
        ensureAdwInit()
        let about = AboutDialog()
        about.comments = "A great application"
        XCTAssertTrue(about.comments == "A great application")
    }

    @MainActor func test_aboutDialogInheritsDialogProperties() {
        ensureAdwInit()
        let about = AboutDialog()
        // AboutDialog inherits from Dialog, so Dialog properties should work
        about.contentWidth = 500
        about.contentHeight = 400
        XCTAssertTrue(about.contentWidth == 500)
        XCTAssertTrue(about.contentHeight == 400)
    }
}
#endif
