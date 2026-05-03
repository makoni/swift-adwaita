// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct GtkDetailTests {

    // MARK: - Grid

    @Test @MainActor func gridCreation() {
        ensureAdwInit()
        let grid = Grid()
        #expect(grid.pointer != nil)
    }

    @Test @MainActor func gridProperties() {
        ensureAdwInit()
        let grid = Grid()
        grid.columnSpacing = 10
        #expect(grid.columnSpacing == 10)
        grid.rowSpacing = 8
        #expect(grid.rowSpacing == 8)
        grid.columnHomogeneous = true
        #expect(grid.columnHomogeneous)
        grid.rowHomogeneous = true
        #expect(grid.rowHomogeneous)
    }

    @Test @MainActor func gridAttachAndRetrieve() {
        ensureAdwInit()
        let grid = Grid()
        let label = Label("test")
        grid.attach(label, column: 0, row: 0)
        let child = grid.childAt(column: 0, row: 0)
        #expect(child != nil)
        #expect(child?.pointer == label.pointer)
    }

    @Test @MainActor func gridMultiColumnSpan() {
        ensureAdwInit()
        let grid = Grid()
        let label = Label("wide")
        grid.attach(label, column: 0, row: 0, width: 3, height: 2)
        // The widget should be found at column 0, row 0
        #expect(grid.childAt(column: 0, row: 0) != nil)
    }

    @Test @MainActor func gridInsertRemoveRow() {
        ensureAdwInit()
        let grid = Grid()
        let label = Label("r1")
        grid.attach(label, column: 0, row: 0)
        grid.insertRow(at: 0)
        // After inserting row 0, the label moves to row 1
        #expect(grid.childAt(column: 0, row: 1) != nil)
    }

    // MARK: - Popover

    @Test @MainActor func popoverCreation() {
        ensureAdwInit()
        let popover = Popover()
        #expect(popover.pointer != nil)
    }

    @Test @MainActor func popoverProperties() {
        ensureAdwInit()
        let popover = Popover()
        popover.hasArrow = false
        #expect(!popover.hasArrow)
        popover.hasArrow = true
        #expect(popover.hasArrow)
        popover.autohide = false
        #expect(!popover.autohide)
        popover.position = .bottom
        #expect(popover.position == .bottom)
    }

    @Test @MainActor func popoverChild() {
        ensureAdwInit()
        let popover = Popover()
        let label = Label("popup content")
        popover.child = label
        #expect(popover.child != nil)
        #expect(popover.child?.pointer == label.pointer)
    }

    // MARK: - PopoverMenu

    @Test @MainActor func popoverMenuCreation() {
        ensureAdwInit()
        let menuModel = GMenuRef()
        let menu = PopoverMenu(model: menuModel)
        #expect(menu.pointer != nil)
    }

    // MARK: - Picture

    @Test @MainActor func pictureCreation() {
        ensureAdwInit()
        let picture = Picture()
        #expect(picture.pointer != nil)
    }

    @Test @MainActor func pictureCanShrink() {
        ensureAdwInit()
        let picture = Picture()
        picture.canShrink = false
        #expect(!picture.canShrink)
        picture.canShrink = true
        #expect(picture.canShrink)
    }

    @Test @MainActor func pictureAlternativeText() {
        ensureAdwInit()
        let picture = Picture()
        picture.alternativeText = "A photo"
        #expect(picture.alternativeText == "A photo")
    }

    // MARK: - DropDown

    @Test @MainActor func dropDownFromStrings() {
        ensureAdwInit()
        let dd = DropDown(strings: ["One", "Two", "Three"])
        #expect(dd.pointer != nil)
        #expect(dd.selected == 0)
    }

    @Test @MainActor func dropDownSelection() {
        ensureAdwInit()
        let dd = DropDown(strings: ["A", "B", "C"])
        dd.selected = 2
        #expect(dd.selected == 2)
    }

    @Test @MainActor func dropDownEnableSearch() {
        ensureAdwInit()
        let dd = DropDown(strings: ["X"])
        dd.enableSearch = true
        #expect(dd.enableSearch)
        dd.enableSearch = false
        #expect(!dd.enableSearch)
    }

    // MARK: - Adjustment

    @Test @MainActor func adjustmentCreation() {
        ensureAdwInit()
        let adj = Adjustment(value: 50, lower: 0, upper: 100, stepIncrement: 1, pageIncrement: 10, pageSize: 0)
        #expect(adj.value == 50)
        #expect(adj.lower == 0)
        #expect(adj.upper == 100)
        #expect(adj.stepIncrement == 1)
        #expect(adj.pageIncrement == 10)
    }

    @Test @MainActor func adjustmentSetValue() {
        ensureAdwInit()
        let adj = Adjustment(value: 0, lower: 0, upper: 100)
        adj.value = 75
        #expect(adj.value == 75)
    }

    @Test @MainActor func adjustmentConfigure() {
        ensureAdwInit()
        let adj = Adjustment()
        adj.configure(value: 25, lower: 10, upper: 50, stepIncrement: 2, pageIncrement: 5, pageSize: 0)
        #expect(adj.value == 25)
        #expect(adj.lower == 10)
        #expect(adj.upper == 50)
        #expect(adj.stepIncrement == 2)
    }

    // MARK: - Paned

    @Test @MainActor func panedCreation() {
        ensureAdwInit()
        let paned = Paned()
        #expect(paned.pointer != nil)
    }

    @Test @MainActor func panedProperties() {
        ensureAdwInit()
        let paned = Paned()
        paned.position = 200
        #expect(paned.position == 200)
        paned.wideHandle = true
        #expect(paned.wideHandle)
        paned.resizeStartChild = false
        #expect(!paned.resizeStartChild)
        paned.shrinkEndChild = false
        #expect(!paned.shrinkEndChild)
    }

    @Test @MainActor func panedChildren() {
        ensureAdwInit()
        let paned = Paned()
        let left = Label("Left")
        let right = Label("Right")
        paned.startChild = left
        paned.endChild = right
        #expect(paned.startChild != nil)
        #expect(paned.endChild != nil)
        #expect(paned.startChild?.pointer == left.pointer)
    }

    // MARK: - Expander

    @Test @MainActor func expanderCreation() {
        ensureAdwInit()
        let exp = Expander(label: "Details")
        #expect(exp.pointer != nil)
    }

    @Test @MainActor func expanderProperties() {
        ensureAdwInit()
        let exp = Expander(label: "Details")
        #expect(exp.label == "Details")
        exp.expanded = true
        #expect(exp.expanded)
        exp.expanded = false
        #expect(!exp.expanded)
        exp.useMarkup = true
        #expect(exp.useMarkup)
    }

    @Test @MainActor func expanderChild() {
        ensureAdwInit()
        let exp = Expander(label: "More")
        let content = Label("Hidden content")
        exp.child = content
        #expect(exp.child != nil)
        #expect(exp.child?.pointer == content.pointer)
    }

    // MARK: - Notebook

    @Test @MainActor func notebookCreation() {
        ensureAdwInit()
        let nb = Notebook()
        #expect(nb.pointer != nil)
        #expect(nb.nPages == 0)
    }

    @Test @MainActor func notebookAddPages() {
        ensureAdwInit()
        let nb = Notebook()
        let page1 = Label("Page 1 content")
        let page2 = Label("Page 2 content")
        let idx1 = nb.appendPage(page1, label: "Tab 1")
        let idx2 = nb.appendPage(page2, label: "Tab 2")
        #expect(idx1 == 0)
        #expect(idx2 == 1)
        #expect(nb.nPages == 2)
    }

    @Test @MainActor func notebookCurrentPage() {
        ensureAdwInit()
        let nb = Notebook()
        nb.appendPage(Label("A"), label: "A")
        nb.appendPage(Label("B"), label: "B")
        nb.appendPage(Label("C"), label: "C")
        nb.currentPage = 2
        #expect(nb.currentPage == 2)
    }

    @Test @MainActor func notebookProperties() {
        ensureAdwInit()
        let nb = Notebook()
        nb.showTabs = false
        #expect(!nb.showTabs)
        nb.scrollable = true
        #expect(nb.scrollable)
        nb.tabPos = .left
        #expect(nb.tabPos == .left)
    }

    @Test @MainActor func notebookTabLabel() {
        ensureAdwInit()
        let nb = Notebook()
        let page = Label("Content")
        nb.appendPage(page, label: "Original")
        #expect(nb.getTabLabelText(page) == "Original")
        nb.setTabLabelText(page, text: "Renamed")
        #expect(nb.getTabLabelText(page) == "Renamed")
    }

    // MARK: - GestureLongPress

    @Test @MainActor func gestureLongPressCreation() {
        ensureAdwInit()
        let gesture = GestureLongPress()
        #expect(gesture.pointer != nil)
    }

    @Test @MainActor func gestureLongPressDelayFactor() {
        ensureAdwInit()
        let gesture = GestureLongPress()
        gesture.delayFactor = 2.0
        #expect(gesture.delayFactor == 2.0)
    }

    @Test @MainActor func gestureLongPressSignals() {
        ensureAdwInit()
        let gesture = GestureLongPress()
        let c1 = gesture.onPressed { _, _ in }
        let c2 = gesture.onCancelled {}
        c1.disconnect()
        c2.disconnect()
    }

    // MARK: - GestureDrag

    @Test @MainActor func gestureDragCreation() {
        ensureAdwInit()
        let gesture = GestureDrag()
        #expect(gesture.pointer != nil)
    }

    @Test @MainActor func gestureDragSignals() {
        ensureAdwInit()
        let gesture = GestureDrag()
        let c1 = gesture.onDragBegin { _, _ in }
        let c2 = gesture.onDragUpdate { _, _ in }
        let c3 = gesture.onDragEnd { _, _ in }
        c1.disconnect()
        c2.disconnect()
        c3.disconnect()
    }

    // MARK: - EventControllerFocus

    @Test @MainActor func eventControllerFocusCreation() {
        ensureAdwInit()
        let focus = EventControllerFocus()
        #expect(focus.pointer != nil)
        #expect(!focus.isFocus)
        #expect(!focus.containsFocus)
    }

    @Test @MainActor func eventControllerFocusSignals() {
        ensureAdwInit()
        let focus = EventControllerFocus()
        let c1 = focus.onEnter {}
        let c2 = focus.onLeave {}
        c1.disconnect()
        c2.disconnect()
    }

    // MARK: - FileDialog

    @Test @MainActor func fileDialogCreation() {
        ensureAdwInit()
        let dialog = FileDialog()
        #expect(dialog.pointer != nil)
    }

    @Test @MainActor func fileDialogProperties() {
        ensureAdwInit()
        let dialog = FileDialog()
        dialog.title = "Open File"
        #expect(dialog.title == "Open File")
        dialog.modal = false
        #expect(!dialog.modal)
        dialog.initialName = "document.txt"
        #expect(dialog.initialName == "document.txt")
        dialog.acceptLabel = "Choose"
        #expect(dialog.acceptLabel == "Choose")
    }

    // MARK: - ColorDialog

    @Test @MainActor func colorDialogCreation() {
        ensureAdwInit()
        let dialog = ColorDialog()
        #expect(dialog.pointer != nil)
    }

    @Test @MainActor func colorDialogProperties() {
        ensureAdwInit()
        let dialog = ColorDialog()
        dialog.title = "Pick Color"
        #expect(dialog.title == "Pick Color")
        dialog.withAlpha = false
        #expect(!dialog.withAlpha)
    }

    @Test @MainActor func rgbaStruct() {
        let color = RGBA(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.8)
        #expect(color.red == 1.0)
        #expect(color.green == 0.5)
        #expect(color.blue == 0.0)
        #expect(color.alpha == 0.8)
    }

    @Test func rgbaHexParsesSixDigitFormOpaque() throws {
        let color = try #require(RGBA(hex: "#FF8000"))
        #expect(color.red == 1.0)
        #expect(abs(color.green - 128.0 / 255.0) < 1e-9)
        #expect(color.blue == 0.0)
        #expect(color.alpha == 1.0)
    }

    @Test func rgbaHexParsesEightDigitFormWithAlpha() throws {
        let color = try #require(RGBA(hex: "#FF8000CC"))
        #expect(abs(color.alpha - 204.0 / 255.0) < 1e-9)
    }

    @Test func rgbaHexParsesThreeDigitShorthand() throws {
        // #F80 -> #FF8800
        let short = try #require(RGBA(hex: "#F80"))
        let long = try #require(RGBA(hex: "#FF8800"))
        #expect(short == long)
    }

    @Test func rgbaHexParsesFourDigitShorthandWithAlpha() throws {
        // #F80C -> #FF8800CC
        let short = try #require(RGBA(hex: "#F80C"))
        let long = try #require(RGBA(hex: "#FF8800CC"))
        #expect(short == long)
    }

    @Test func rgbaHexAcceptsNoLeadingHash() throws {
        let withHash = try #require(RGBA(hex: "#10203040"))
        let withoutHash = try #require(RGBA(hex: "10203040"))
        #expect(withHash == withoutHash)
    }

    @Test func rgbaHexIsCaseInsensitive() throws {
        let lower = try #require(RGBA(hex: "#abcdef"))
        let upper = try #require(RGBA(hex: "#ABCDEF"))
        #expect(lower == upper)
    }

    @Test func rgbaHexRejectsInvalidInput() {
        #expect(RGBA(hex: "") == nil)
        #expect(RGBA(hex: "#12345") == nil)
        #expect(RGBA(hex: "#1234567") == nil)
        #expect(RGBA(hex: "#XYZXYZ") == nil)
        #expect(RGBA(hex: "not-a-color") == nil)
    }

    // MARK: - FontDialog

    @Test @MainActor func fontDialogCreation() {
        ensureAdwInit()
        let dialog = FontDialog()
        #expect(dialog.pointer != nil)
    }

    @Test @MainActor func fontDialogProperties() {
        ensureAdwInit()
        let dialog = FontDialog()
        dialog.title = "Choose Font"
        #expect(dialog.title == "Choose Font")
        dialog.modal = false
        #expect(!dialog.modal)
    }

}
#endif
