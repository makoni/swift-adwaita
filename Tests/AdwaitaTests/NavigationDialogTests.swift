// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
#if swift(>=6.3)
import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct NavigationDialogTests {

    // MARK: - Notebook Tests

    @Test @MainActor func notebookAppendAndRemovePage() {
        ensureAdwInit()
        let notebook = Notebook()
        let label1 = Label("Page 1")
        let idx1 = notebook.appendPage(label1, label: "First")
        #expect(idx1 == 0)
        #expect(notebook.nPages == 1)

        let label2 = Label("Page 2")
        let idx2 = notebook.appendPage(label2, label: "Second")
        #expect(idx2 == 1)
        #expect(notebook.nPages == 2)

        notebook.removePage(at: 0)
        #expect(notebook.nPages == 1)
    }

    @Test @MainActor func notebookShowTabs() {
        ensureAdwInit()
        let notebook = Notebook()
        notebook.showTabs = false
        #expect(notebook.showTabs == false)
        notebook.showTabs = true
        #expect(notebook.showTabs == true)
    }

    @Test @MainActor func notebookShowBorder() {
        ensureAdwInit()
        let notebook = Notebook()
        notebook.showBorder = false
        #expect(notebook.showBorder == false)
        notebook.showBorder = true
        #expect(notebook.showBorder == true)
    }

    @Test @MainActor func notebookTabPos() {
        ensureAdwInit()
        let notebook = Notebook()
        notebook.tabPos = GTK_POS_BOTTOM
        #expect(notebook.tabPos == GTK_POS_BOTTOM)
        notebook.tabPos = GTK_POS_LEFT
        #expect(notebook.tabPos == GTK_POS_LEFT)
        notebook.tabPos = GTK_POS_TOP
        #expect(notebook.tabPos == GTK_POS_TOP)
    }

    @Test @MainActor func notebookScrollable() {
        ensureAdwInit()
        let notebook = Notebook()
        notebook.scrollable = true
        #expect(notebook.scrollable == true)
        notebook.scrollable = false
        #expect(notebook.scrollable == false)
    }

    @Test @MainActor func notebookGetNthPage() {
        ensureAdwInit()
        let notebook = Notebook()
        let label = Label("Content")
        notebook.appendPage(label, label: "Tab")
        let retrieved = notebook.getNthPage(0)
        #expect(retrieved != nil)
    }

    @Test @MainActor func notebookPrependAndInsert() {
        ensureAdwInit()
        let notebook = Notebook()
        let label1 = Label("First")
        notebook.appendPage(label1, label: "First")
        let label2 = Label("Prepended")
        let prependIdx = notebook.prependPage(label2, label: "Prepended")
        #expect(prependIdx == 0)
        #expect(notebook.nPages == 2)

        let label3 = Label("Inserted")
        let insertIdx = notebook.insertPage(label3, label: "Inserted", position: 1)
        #expect(insertIdx == 1)
        #expect(notebook.nPages == 3)
    }

    @Test @MainActor func notebookNextPrevPage() {
        ensureAdwInit()
        let notebook = Notebook()
        let label1 = Label("Page 1")
        let label2 = Label("Page 2")
        notebook.appendPage(label1, label: "First")
        notebook.appendPage(label2, label: "Second")
        notebook.currentPage = 0
        notebook.nextPage()
        #expect(notebook.currentPage == 1)
        notebook.prevPage()
        #expect(notebook.currentPage == 0)
    }

    @Test @MainActor func notebookTabLabelText() {
        ensureAdwInit()
        let notebook = Notebook()
        let label = Label("Content")
        notebook.appendPage(label, label: "Original")
        let originalText = notebook.getTabLabelText(label)
        #expect(originalText == "Original")
        notebook.setTabLabelText(label, text: "Changed")
        let changedText = notebook.getTabLabelText(label)
        #expect(changedText == "Changed")
    }

    @Test @MainActor func notebookChainingMethods() {
        ensureAdwInit()
        let notebook = Notebook()
            .scrollable(true)
            .tabPos(GTK_POS_BOTTOM)
        #expect(notebook.scrollable == true)
        #expect(notebook.tabPos == GTK_POS_BOTTOM)
    }

    // MARK: - NavigationView Tests

    @Test @MainActor func navigationViewCreation() {
        ensureAdwInit()
        let nav = NavigationView()
        #expect(nav.visiblePage == nil)
        #expect(nav.animateTransitions == true)
        #expect(nav.popOnEscape == true)
    }

    @Test @MainActor func navigationViewPushAndPop() {
        ensureAdwInit()
        let nav = NavigationView()
        let label1 = Label("Page 1")
        let page1 = nav.push(title: "First", child: label1)
        #expect(nav.visiblePage != nil)
        #expect(nav.visiblePage?.title == "First")

        let label2 = Label("Page 2")
        nav.push(title: "Second", child: label2)
        #expect(nav.visiblePage?.title == "Second")

        nav.animateTransitions = false
        let didPop = nav.pop()
        #expect(didPop == true)
        _ = page1
    }

    @Test @MainActor func navigationViewPushWithTag() {
        ensureAdwInit()
        let nav = NavigationView()
        nav.animateTransitions = false
        let label = Label("Content")
        let page = nav.push(title: "Tagged Page", tag: "my-tag", child: label)
        #expect(page.tag == "my-tag")
        // visiblePageTag requires libadwaita 1.7+ and a realized widget
    }

    @Test @MainActor func navigationViewFindPage() {
        ensureAdwInit()
        let nav = NavigationView()
        nav.animateTransitions = false
        let label = Label("Content")
        nav.push(title: "Tagged", tag: "find-me", child: label)
        let found = nav.findPage("find-me")
        #expect(found != nil)
        #expect(found?.title == "Tagged")
        let notFound = nav.findPage("nonexistent")
        #expect(notFound == nil)
    }

    @Test @MainActor func navigationViewOnPoppedSignal() {
        ensureAdwInit()
        let nav = NavigationView()
        let conn = nav.onPopped { _ in }
        conn.disconnect()
    }

    // MARK: - NavigationPage Tests

    @Test @MainActor func navigationPageCreation() {
        ensureAdwInit()
        let label = Label("Content")
        let page = NavigationPage(child: label, title: "My Page")
        #expect(page.title == "My Page")
        #expect(page.child != nil)
        #expect(page.tag == nil)
    }

    @Test @MainActor func navigationPageTitle() {
        ensureAdwInit()
        let label = Label("Content")
        let page = NavigationPage(child: label, title: "Original")
        page.title = "Updated"
        #expect(page.title == "Updated")
    }

    @Test @MainActor func navigationPageTag() {
        ensureAdwInit()
        let label = Label("Content")
        let page = NavigationPage.newWithTag(child: label, title: "Tagged", tag: "settings")
        #expect(page.tag == "settings")
        page.tag = "new-tag"
        #expect(page.tag == "new-tag")
    }

    @Test @MainActor func navigationPageCanPop() {
        ensureAdwInit()
        let label = Label("Content")
        let page = NavigationPage(child: label, title: "Page")
        #expect(page.canPop == true)
        page.canPop = false
        #expect(page.canPop == false)
        page.canPop = true
        #expect(page.canPop == true)
    }

    // MARK: - NavigationSplitView Tests

    @Test @MainActor func navigationSplitViewCreation() {
        ensureAdwInit()
        let splitView = NavigationSplitView()
        #expect(splitView.collapsed == false)
        #expect(splitView.showContent == false)
    }

    @Test @MainActor func navigationSplitViewSidebarAndContent() {
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
        #expect(splitView.showContent == true)
    }

    @Test @MainActor func navigationSplitViewCollapsed() {
        ensureAdwInit()
        let splitView = NavigationSplitView()
        splitView.collapsed = true
        #expect(splitView.collapsed == true)
        splitView.collapsed = false
        #expect(splitView.collapsed == false)
    }

    @Test @MainActor func navigationSplitViewSidebarWidth() {
        ensureAdwInit()
        let splitView = NavigationSplitView()
        splitView.minSidebarWidth = 200
        #expect(splitView.minSidebarWidth == 200)
        splitView.maxSidebarWidth = 400
        #expect(splitView.maxSidebarWidth == 400)
        splitView.sidebarWidthFraction = 0.33
        #expect(abs(splitView.sidebarWidthFraction - 0.33) < 0.01)
    }

    // MARK: - OverlaySplitView Tests

    @Test @MainActor func overlaySplitViewCreation() {
        ensureAdwInit()
        let osv = OverlaySplitView()
        #expect(osv.collapsed == false)
        #expect(osv.showSidebar == true)
    }

    @Test @MainActor func overlaySplitViewSidebarAndContent() {
        ensureAdwInit()
        let sidebar = Label("Sidebar")
        let content = Label("Content")
        let osv = OverlaySplitView(sidebar: sidebar, content: content)
        #expect(osv.sidebar != nil)
        #expect(osv.content != nil)
    }

    @Test @MainActor func overlaySplitViewCollapsedAndShowSidebar() {
        ensureAdwInit()
        let osv = OverlaySplitView()
        osv.collapsed = true
        #expect(osv.collapsed == true)
        osv.showSidebar = false
        #expect(osv.showSidebar == false)
        osv.showSidebar = true
        #expect(osv.showSidebar == true)
    }

    @Test @MainActor func overlaySplitViewPinSidebar() {
        ensureAdwInit()
        let osv = OverlaySplitView()
        osv.pinSidebar = true
        #expect(osv.pinSidebar == true)
        osv.pinSidebar = false
        #expect(osv.pinSidebar == false)
    }

    @Test @MainActor func overlaySplitViewSidebarWidths() {
        ensureAdwInit()
        let osv = OverlaySplitView()
        osv.sidebarWidthFraction = 0.25
        #expect(abs(osv.sidebarWidthFraction - 0.25) < 0.01)
        osv.minSidebarWidth = 180
        #expect(osv.minSidebarWidth == 180)
        osv.maxSidebarWidth = 350
        #expect(osv.maxSidebarWidth == 350)
    }

    // MARK: - Dialog Tests

    @Test @MainActor func dialogCreation() {
        ensureAdwInit()
        let dialog = Dialog()
        #expect(dialog.title == "")
        #expect(dialog.contentWidth == -1)
        #expect(dialog.contentHeight == -1)
        #expect(dialog.canClose == true)
    }

    @Test @MainActor func dialogTitle() {
        ensureAdwInit()
        let dialog = Dialog()
        dialog.title = "Preferences"
        #expect(dialog.title == "Preferences")
    }

    @Test @MainActor func dialogContentDimensions() {
        ensureAdwInit()
        let dialog = Dialog()
        dialog.contentWidth = 400
        dialog.contentHeight = 300
        #expect(dialog.contentWidth == 400)
        #expect(dialog.contentHeight == 300)
    }

    @Test @MainActor func dialogChild() {
        ensureAdwInit()
        let dialog = Dialog()
        let label = Label("Dialog Content")
        dialog.child = label
        #expect(dialog.child != nil)
    }

    @Test @MainActor func dialogCanClose() {
        ensureAdwInit()
        let dialog = Dialog()
        dialog.canClose = false
        #expect(dialog.canClose == false)
        dialog.canClose = true
        #expect(dialog.canClose == true)
    }

    @Test @MainActor func dialogFollowsContentSize() {
        ensureAdwInit()
        let dialog = Dialog()
        dialog.followsContentSize = true
        #expect(dialog.followsContentSize == true)
        dialog.followsContentSize = false
        #expect(dialog.followsContentSize == false)
    }

    // MARK: - AboutDialog Tests

    @Test @MainActor func aboutDialogCreation() {
        ensureAdwInit()
        let about = AboutDialog()
        #expect(about.applicationName == "")
        #expect(about.version == "")
    }

    @Test @MainActor func aboutDialogProperties() {
        ensureAdwInit()
        let about = AboutDialog()
        about.applicationName = "My App"
        #expect(about.applicationName == "My App")
        about.applicationIcon = "my-app-icon"
        #expect(about.applicationIcon == "my-app-icon")
        about.developerName = "Jane Doe"
        #expect(about.developerName == "Jane Doe")
        about.version = "2.0"
        #expect(about.version == "2.0")
        about.website = "https://example.org"
        #expect(about.website == "https://example.org")
        about.issueUrl = "https://github.com/example/issues"
        #expect(about.issueUrl == "https://github.com/example/issues")
        about.copyright = "2025 Jane Doe"
        #expect(about.copyright == "2025 Jane Doe")
        about.license = "MIT License text"
        #expect(about.license == "MIT License text")
    }

    @Test @MainActor func aboutDialogTranslatorCredits() {
        ensureAdwInit()
        let about = AboutDialog()
        about.translatorCredits = "Translator Name <translator@example.com>"
        #expect(about.translatorCredits == "Translator Name <translator@example.com>")
    }

    @Test @MainActor func aboutDialogAddOtherApp() {
        ensureAdwInit()
        let about = AboutDialog()
        // Should not crash
        about.addOtherApp("com.example.OtherApp", name: "Other App", summary: "A companion app")
    }

    @Test @MainActor func aboutDialogAddLink() {
        ensureAdwInit()
        let about = AboutDialog()
        // Should not crash
        about.addLink("Donate", url: "https://example.com/donate")
    }

    @Test @MainActor func aboutDialogComments() {
        ensureAdwInit()
        let about = AboutDialog()
        about.comments = "A great application"
        #expect(about.comments == "A great application")
    }

    @Test @MainActor func aboutDialogInheritsDialogProperties() {
        ensureAdwInit()
        let about = AboutDialog()
        // AboutDialog inherits from Dialog, so Dialog properties should work
        about.contentWidth = 500
        about.contentHeight = 400
        #expect(about.contentWidth == 500)
        #expect(about.contentHeight == 400)
    }
}
#endif
#endif
