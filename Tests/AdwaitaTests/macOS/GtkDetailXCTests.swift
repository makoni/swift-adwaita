// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class GtkDetailXCTests: XCTestCase {

    // MARK: - Grid

    @MainActor func test_gridCreation() {
        ensureAdwInit()
        let grid = Grid()
        XCTAssertNotNil(grid.pointer)
    }

    @MainActor func test_gridProperties() {
        ensureAdwInit()
        let grid = Grid()
        grid.columnSpacing = 10
        XCTAssertTrue(grid.columnSpacing == 10)
        grid.rowSpacing = 8
        XCTAssertTrue(grid.rowSpacing == 8)
        grid.columnHomogeneous = true
        XCTAssertTrue(grid.columnHomogeneous)
        grid.rowHomogeneous = true
        XCTAssertTrue(grid.rowHomogeneous)
    }

    @MainActor func test_gridAttachAndRetrieve() {
        ensureAdwInit()
        let grid = Grid()
        let label = Label("test")
        grid.attach(label, column: 0, row: 0)
        let child = grid.childAt(column: 0, row: 0)
        XCTAssertNotNil(child)
        XCTAssertTrue(child?.pointer == label.pointer)
    }

    @MainActor func test_gridMultiColumnSpan() {
        ensureAdwInit()
        let grid = Grid()
        let label = Label("wide")
        grid.attach(label, column: 0, row: 0, width: 3, height: 2)
        // The widget should be found at column 0, row 0
        XCTAssertNotNil(grid.childAt(column: 0, row: 0))
    }

    @MainActor func test_gridInsertRemoveRow() {
        ensureAdwInit()
        let grid = Grid()
        let label = Label("r1")
        grid.attach(label, column: 0, row: 0)
        grid.insertRow(at: 0)
        // After inserting row 0, the label moves to row 1
        XCTAssertNotNil(grid.childAt(column: 0, row: 1))
    }

    // MARK: - Popover

    @MainActor func test_popoverCreation() {
        ensureAdwInit()
        let popover = Popover()
        XCTAssertNotNil(popover.pointer)
    }

    @MainActor func test_popoverProperties() {
        ensureAdwInit()
        let popover = Popover()
        popover.hasArrow = false
        XCTAssertFalse(popover.hasArrow)
        popover.hasArrow = true
        XCTAssertTrue(popover.hasArrow)
        popover.autohide = false
        XCTAssertFalse(popover.autohide)
        popover.position = .bottom
        XCTAssertTrue(popover.position == .bottom)
    }

    @MainActor func test_popoverChild() {
        ensureAdwInit()
        let popover = Popover()
        let label = Label("popup content")
        popover.child = label
        XCTAssertNotNil(popover.child)
        XCTAssertTrue(popover.child?.pointer == label.pointer)
    }

    // MARK: - PopoverMenu

    @MainActor func test_popoverMenuCreation() {
        ensureAdwInit()
        let menuModel = GMenuRef()
        let menu = PopoverMenu(model: menuModel)
        XCTAssertNotNil(menu.pointer)
    }

    // MARK: - Picture

    @MainActor func test_pictureCreation() {
        ensureAdwInit()
        let picture = Adwaita.Picture()
        XCTAssertNotNil(picture.pointer)
    }

    @MainActor func test_pictureCanShrink() {
        ensureAdwInit()
        let picture = Adwaita.Picture()
        picture.canShrink = false
        XCTAssertFalse(picture.canShrink)
        picture.canShrink = true
        XCTAssertTrue(picture.canShrink)
    }

    @MainActor func test_pictureAlternativeText() {
        ensureAdwInit()
        let picture = Adwaita.Picture()
        picture.alternativeText = "A photo"
        XCTAssertTrue(picture.alternativeText == "A photo")
    }

    // MARK: - DropDown

    @MainActor func test_dropDownFromStrings() {
        ensureAdwInit()
        let dd = DropDown(strings: ["One", "Two", "Three"])
        XCTAssertNotNil(dd.pointer)
        XCTAssertTrue(dd.selected == 0)
    }

    @MainActor func test_dropDownSelection() {
        ensureAdwInit()
        let dd = DropDown(strings: ["A", "B", "C"])
        dd.selected = 2
        XCTAssertTrue(dd.selected == 2)
    }

    @MainActor func test_dropDownEnableSearch() {
        ensureAdwInit()
        let dd = DropDown(strings: ["X"])
        dd.enableSearch = true
        XCTAssertTrue(dd.enableSearch)
        dd.enableSearch = false
        XCTAssertFalse(dd.enableSearch)
    }

    // MARK: - Adjustment

    @MainActor func test_adjustmentCreation() {
        ensureAdwInit()
        let adj = Adjustment(value: 50, lower: 0, upper: 100, stepIncrement: 1, pageIncrement: 10, pageSize: 0)
        XCTAssertTrue(adj.value == 50)
        XCTAssertTrue(adj.lower == 0)
        XCTAssertTrue(adj.upper == 100)
        XCTAssertTrue(adj.stepIncrement == 1)
        XCTAssertTrue(adj.pageIncrement == 10)
    }

    @MainActor func test_adjustmentSetValue() {
        ensureAdwInit()
        let adj = Adjustment(value: 0, lower: 0, upper: 100)
        adj.value = 75
        XCTAssertTrue(adj.value == 75)
    }

    @MainActor func test_adjustmentConfigure() {
        ensureAdwInit()
        let adj = Adjustment()
        adj.configure(value: 25, lower: 10, upper: 50, stepIncrement: 2, pageIncrement: 5, pageSize: 0)
        XCTAssertTrue(adj.value == 25)
        XCTAssertTrue(adj.lower == 10)
        XCTAssertTrue(adj.upper == 50)
        XCTAssertTrue(adj.stepIncrement == 2)
    }

    // MARK: - Paned

    @MainActor func test_panedCreation() {
        ensureAdwInit()
        let paned = Paned()
        XCTAssertNotNil(paned.pointer)
    }

    @MainActor func test_panedProperties() {
        ensureAdwInit()
        let paned = Paned()
        paned.position = 200
        XCTAssertTrue(paned.position == 200)
        paned.wideHandle = true
        XCTAssertTrue(paned.wideHandle)
        paned.resizeStartChild = false
        XCTAssertFalse(paned.resizeStartChild)
        paned.shrinkEndChild = false
        XCTAssertFalse(paned.shrinkEndChild)
    }

    @MainActor func test_panedChildren() {
        ensureAdwInit()
        let paned = Paned()
        let left = Label("Left")
        let right = Label("Right")
        paned.startChild = left
        paned.endChild = right
        XCTAssertNotNil(paned.startChild)
        XCTAssertNotNil(paned.endChild)
        XCTAssertTrue(paned.startChild?.pointer == left.pointer)
    }

    // MARK: - Expander

    @MainActor func test_expanderCreation() {
        ensureAdwInit()
        let exp = Expander(label: "Details")
        XCTAssertNotNil(exp.pointer)
    }

    @MainActor func test_expanderProperties() {
        ensureAdwInit()
        let exp = Expander(label: "Details")
        XCTAssertTrue(exp.label == "Details")
        exp.expanded = true
        XCTAssertTrue(exp.expanded)
        exp.expanded = false
        XCTAssertFalse(exp.expanded)
        exp.useMarkup = true
        XCTAssertTrue(exp.useMarkup)
    }

    @MainActor func test_expanderChild() {
        ensureAdwInit()
        let exp = Expander(label: "More")
        let content = Label("Hidden content")
        exp.child = content
        XCTAssertNotNil(exp.child)
        XCTAssertTrue(exp.child?.pointer == content.pointer)
    }

    // MARK: - Notebook

    @MainActor func test_notebookCreation() {
        ensureAdwInit()
        let nb = Notebook()
        XCTAssertNotNil(nb.pointer)
        XCTAssertTrue(nb.nPages == 0)
    }

    @MainActor func test_notebookAddPages() {
        ensureAdwInit()
        let nb = Notebook()
        let page1 = Label("Page 1 content")
        let page2 = Label("Page 2 content")
        let idx1 = nb.appendPage(page1, label: "Tab 1")
        let idx2 = nb.appendPage(page2, label: "Tab 2")
        XCTAssertTrue(idx1 == 0)
        XCTAssertTrue(idx2 == 1)
        XCTAssertTrue(nb.nPages == 2)
    }

    @MainActor func test_notebookCurrentPage() {
        ensureAdwInit()
        let nb = Notebook()
        nb.appendPage(Label("A"), label: "A")
        nb.appendPage(Label("B"), label: "B")
        nb.appendPage(Label("C"), label: "C")
        nb.currentPage = 2
        XCTAssertTrue(nb.currentPage == 2)
    }

    @MainActor func test_notebookProperties() {
        ensureAdwInit()
        let nb = Notebook()
        nb.showTabs = false
        XCTAssertFalse(nb.showTabs)
        nb.scrollable = true
        XCTAssertTrue(nb.scrollable)
        nb.tabPos = .left
        XCTAssertTrue(nb.tabPos == .left)
    }

    @MainActor func test_notebookTabLabel() {
        ensureAdwInit()
        let nb = Notebook()
        let page = Label("Content")
        nb.appendPage(page, label: "Original")
        XCTAssertTrue(nb.getTabLabelText(page) == "Original")
        nb.setTabLabelText(page, text: "Renamed")
        XCTAssertTrue(nb.getTabLabelText(page) == "Renamed")
    }

    // MARK: - GestureLongPress

    @MainActor func test_gestureLongPressCreation() {
        ensureAdwInit()
        let gesture = GestureLongPress()
        XCTAssertNotNil(gesture.pointer)
    }

    @MainActor func test_gestureLongPressDelayFactor() {
        ensureAdwInit()
        let gesture = GestureLongPress()
        gesture.delayFactor = 2.0
        XCTAssertTrue(gesture.delayFactor == 2.0)
    }

    @MainActor func test_gestureLongPressSignals() {
        ensureAdwInit()
        let gesture = GestureLongPress()
        let c1 = gesture.onPressed { _, _ in }
        let c2 = gesture.onCancelled {}
        c1.disconnect()
        c2.disconnect()
    }

    // MARK: - GestureDrag

    @MainActor func test_gestureDragCreation() {
        ensureAdwInit()
        let gesture = GestureDrag()
        XCTAssertNotNil(gesture.pointer)
    }

    @MainActor func test_gestureDragSignals() {
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

    @MainActor func test_eventControllerFocusCreation() {
        ensureAdwInit()
        let focus = EventControllerFocus()
        XCTAssertNotNil(focus.pointer)
        XCTAssertFalse(focus.isFocus)
        XCTAssertFalse(focus.containsFocus)
    }

    @MainActor func test_eventControllerFocusSignals() {
        ensureAdwInit()
        let focus = EventControllerFocus()
        let c1 = focus.onEnter {}
        let c2 = focus.onLeave {}
        c1.disconnect()
        c2.disconnect()
    }

    // MARK: - FileDialog

    @MainActor func test_fileDialogCreation() {
        ensureAdwInit()
        let dialog = FileDialog()
        XCTAssertNotNil(dialog.pointer)
    }

    @MainActor func test_fileDialogProperties() {
        ensureAdwInit()
        let dialog = FileDialog()
        dialog.title = "Open File"
        XCTAssertTrue(dialog.title == "Open File")
        dialog.modal = false
        XCTAssertFalse(dialog.modal)
        dialog.initialName = "document.txt"
        XCTAssertTrue(dialog.initialName == "document.txt")
        dialog.acceptLabel = "Choose"
        XCTAssertTrue(dialog.acceptLabel == "Choose")
    }

    // MARK: - ColorDialog

    @MainActor func test_colorDialogCreation() {
        ensureAdwInit()
        let dialog = ColorDialog()
        XCTAssertNotNil(dialog.pointer)
    }

    @MainActor func test_colorDialogProperties() {
        ensureAdwInit()
        let dialog = ColorDialog()
        dialog.title = "Pick Color"
        XCTAssertTrue(dialog.title == "Pick Color")
        dialog.withAlpha = false
        XCTAssertFalse(dialog.withAlpha)
    }

    @MainActor func test_rgbaStruct() {
        let color = RGBA(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.8)
        XCTAssertTrue(color.red == 1.0)
        XCTAssertTrue(color.green == 0.5)
        XCTAssertTrue(color.blue == 0.0)
        XCTAssertTrue(color.alpha == 0.8)
    }

    func test_rgbaHexParsesSixDigitFormOpaque() throws {
        let color = try XCTUnwrap(RGBA(hex: "#FF8000"))
        XCTAssertTrue(color.red == 1.0)
        XCTAssertTrue(abs(color.green - 128.0 / 255.0) < 1e-9)
        XCTAssertTrue(color.blue == 0.0)
        XCTAssertTrue(color.alpha == 1.0)
    }

    func test_rgbaHexParsesEightDigitFormWithAlpha() throws {
        let color = try XCTUnwrap(RGBA(hex: "#FF8000CC"))
        XCTAssertTrue(abs(color.alpha - 204.0 / 255.0) < 1e-9)
    }

    func test_rgbaHexParsesThreeDigitShorthand() throws {
        // #F80 -> #FF8800
        let short = try XCTUnwrap(RGBA(hex: "#F80"))
        let long = try XCTUnwrap(RGBA(hex: "#FF8800"))
        XCTAssertTrue(short == long)
    }

    func test_rgbaHexParsesFourDigitShorthandWithAlpha() throws {
        // #F80C -> #FF8800CC
        let short = try XCTUnwrap(RGBA(hex: "#F80C"))
        let long = try XCTUnwrap(RGBA(hex: "#FF8800CC"))
        XCTAssertTrue(short == long)
    }

    func test_rgbaHexAcceptsNoLeadingHash() throws {
        let withHash = try XCTUnwrap(RGBA(hex: "#10203040"))
        let withoutHash = try XCTUnwrap(RGBA(hex: "10203040"))
        XCTAssertTrue(withHash == withoutHash)
    }

    func test_rgbaHexIsCaseInsensitive() throws {
        let lower = try XCTUnwrap(RGBA(hex: "#abcdef"))
        let upper = try XCTUnwrap(RGBA(hex: "#ABCDEF"))
        XCTAssertTrue(lower == upper)
    }

    func test_rgbaHexRejectsInvalidInput() {
        XCTAssertNil(RGBA(hex: ""))
        XCTAssertNil(RGBA(hex: "#12345"))
        XCTAssertNil(RGBA(hex: "#1234567"))
        XCTAssertNil(RGBA(hex: "#XYZXYZ"))
        XCTAssertNil(RGBA(hex: "not-a-color"))
    }

    // MARK: - FontDialog

    @MainActor func test_fontDialogCreation() {
        ensureAdwInit()
        let dialog = FontDialog()
        XCTAssertNotNil(dialog.pointer)
    }

    @MainActor func test_fontDialogProperties() {
        ensureAdwInit()
        let dialog = FontDialog()
        dialog.title = "Choose Font"
        XCTAssertTrue(dialog.title == "Choose Font")
        dialog.modal = false
        XCTAssertFalse(dialog.modal)
    }

}
#endif
