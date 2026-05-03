// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class EnhancementXCTests: XCTestCase {

    // MARK: - Scale marks

    @MainActor func test_scaleAddMark() {
        ensureAdwInit()
        let scale = Scale(orientation: .horizontal, min: 0, max: 100, step: 1)
        scale.addMark(value: 0, position: .top, markup: "0")
        scale.addMark(value: 50, position: .top, markup: "50")
        scale.addMark(value: 100, position: .top, markup: "100")
        // No crash = success
    }

    @MainActor func test_scaleClearMarks() {
        ensureAdwInit()
        let scale = Scale(orientation: .horizontal, min: 0, max: 10, step: 1)
        scale.addMark(value: 5, position: .bottom)
        scale.clearMarks()
        // No crash = success
    }

    // MARK: - Label enhancements

    @MainActor func test_labelYalign() {
        ensureAdwInit()
        let label = Label("Test")
        label.yalign = 0.0
        XCTAssertTrue(label.yalign == 0.0)
        label.yalign = 1.0
        XCTAssertTrue(label.yalign == 1.0)
    }

    @MainActor func test_labelMaxWidthChars() {
        ensureAdwInit()
        let label = Label("Test")
        label.maxWidthChars = 20
        XCTAssertTrue(label.maxWidthChars == 20)
    }

    @MainActor func test_labelWidthChars() {
        ensureAdwInit()
        let label = Label("Test")
        label.widthChars = 10
        XCTAssertTrue(label.widthChars == 10)
    }

    @MainActor func test_labelLines() {
        ensureAdwInit()
        let label = Label("Test")
        label.lines = 3
        XCTAssertTrue(label.lines == 3)
    }

    @MainActor func test_labelMnemonicWidget() {
        ensureAdwInit()
        let label = Label("_Test")
        label.useUnderline = true
        XCTAssertTrue(label.useUnderline == true)
        let entry = Entry()
        label.mnemonicWidget = entry
        XCTAssertNotNil(label.mnemonicWidget)
    }

    @MainActor func test_labelNaturalWrapMode() {
        ensureAdwInit()
        let label = Label("Test")
        label.naturalWrapMode = .word
        XCTAssertTrue(label.naturalWrapMode == GtkNaturalWrapMode.word)
    }

    @MainActor func test_labelPangoWrapMode() {
        ensureAdwInit()
        let label = Label("Some long text that might wrap")
        label.wrap = true
        label.pangoWrapMode = PANGO_WRAP_WORD_CHAR
        XCTAssertTrue(label.pangoWrapMode == PANGO_WRAP_WORD_CHAR)
        label.pangoWrapMode = PANGO_WRAP_CHAR
        XCTAssertTrue(label.pangoWrapMode == PANGO_WRAP_CHAR)
        label.pangoWrapMode = PANGO_WRAP_WORD
        XCTAssertTrue(label.pangoWrapMode == PANGO_WRAP_WORD)
    }

    // MARK: - ListBox sort/filter

    @MainActor func test_listBoxSortFunc() {
        ensureAdwInit()
        let list = ListBox()
        list.append(Label("B"))
        list.append(Label("A"))
        list.setSortFunc { _, _ in 0 }
        list.invalidateSort()
        list.clearSortFunc()
        // No crash = success
    }

    @MainActor func test_listBoxFilterFunc() {
        ensureAdwInit()
        let list = ListBox()
        list.append(Label("Visible"))
        list.append(Label("Hidden"))
        list.setFilterFunc { _ in true }
        list.invalidateFilter()
        list.clearFilterFunc()
        // No crash = success
    }

    // MARK: - Widget size queries

    @MainActor func test_widgetWidthHeight() {
        ensureAdwInit()
        let label = Label("Test")
        // Before layout, width/height are 0
        XCTAssertTrue(label.width >= 0)
        XCTAssertTrue(label.height >= 0)
    }

    @MainActor func test_widgetCssName() {
        ensureAdwInit()
        let label = Label("Test")
        XCTAssertFalse(label.cssName.isEmpty)
    }

    // MARK: - Box reorder

    @MainActor func test_boxReorderChildAfter() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let a = Label("A")
        let b = Label("B")
        let c = Label("C")
        box.append(a)
        box.append(b)
        box.append(c)
        // Move A after C
        box.reorderChildAfter(a, sibling: c)
        // No crash = success
    }

    // MARK: - Image enhancements

    @MainActor func test_imageFromResource() {
        ensureAdwInit()
        let img = Image()
        img.setFromResource(nil)
        // No crash = success
    }

    @MainActor func test_imageClear() {
        ensureAdwInit()
        let img = Image(iconName: "dialog-information-symbolic")
        img.clear()
        // After clearing, icon should be nil
        XCTAssertNil(img.iconName)
    }

    // MARK: - ToolbarView edge extension

    @MainActor func test_toolbarViewExtendContentToEdges() {
        ensureAdwInit()
        let tv = ToolbarView()
        XCTAssertTrue(tv.extendContentToTopEdge == false)
        tv.extendContentToTopEdge = true
        XCTAssertTrue(tv.extendContentToTopEdge == true)
        XCTAssertTrue(tv.extendContentToBottomEdge == false)
        tv.extendContentToBottomEdge = true
        XCTAssertTrue(tv.extendContentToBottomEdge == true)
    }

    // MARK: - MainContext delay

    //
    // GLib main-loop tests removed on macOS: iterating the loop interleaves
    // with Cocoa CFRunLoop autorelease pool management and corrupts the pool.
    // These tests still run on Linux from EnhancementTests.swift.

    // MARK: - New enum extensions

    @MainActor func test_inputPurposeEnum() {
        XCTAssertTrue(GtkInputPurpose.freeForm == GTK_INPUT_PURPOSE_FREE_FORM)
        XCTAssertTrue(GtkInputPurpose.digits == GTK_INPUT_PURPOSE_DIGITS)
        XCTAssertTrue(GtkInputPurpose.number == GTK_INPUT_PURPOSE_NUMBER)
        XCTAssertTrue(GtkInputPurpose.phone == GTK_INPUT_PURPOSE_PHONE)
        XCTAssertTrue(GtkInputPurpose.url == GTK_INPUT_PURPOSE_URL)
        XCTAssertTrue(GtkInputPurpose.email == GTK_INPUT_PURPOSE_EMAIL)
        XCTAssertTrue(GtkInputPurpose.password == GTK_INPUT_PURPOSE_PASSWORD)
        XCTAssertTrue(GtkInputPurpose.pin == GTK_INPUT_PURPOSE_PIN)
        XCTAssertTrue(GtkInputPurpose.terminal == GTK_INPUT_PURPOSE_TERMINAL)
    }

    @MainActor func test_entryIconPositionEnum() {
        XCTAssertTrue(GtkEntryIconPosition.primary == GTK_ENTRY_ICON_PRIMARY)
        XCTAssertTrue(GtkEntryIconPosition.secondary == GTK_ENTRY_ICON_SECONDARY)
    }

    @MainActor func test_naturalWrapModeEnum() {
        XCTAssertTrue(GtkNaturalWrapMode.inherit == GTK_NATURAL_WRAP_INHERIT)
        XCTAssertTrue(GtkNaturalWrapMode.none == GTK_NATURAL_WRAP_NONE)
        XCTAssertTrue(GtkNaturalWrapMode.word == GTK_NATURAL_WRAP_WORD)
    }

    // MARK: - Batch 8: SplitButton menuModel/popover

    @MainActor func test_splitButtonMenuModel() {
        ensureAdwInit()
        let btn = SplitButton()
        let menu = GMenuRef()
        menu.append("Test", action: "app.test")
        btn.setMenuModel(menu)
        // No crash = success
    }

    @MainActor func test_splitButtonPopover() {
        ensureAdwInit()
        let btn = SplitButton()
        let pop = Popover()
        pop.child = Label("Custom")
        btn.setPopover(pop)
        // No crash = success
    }

    @MainActor func test_splitButtonClickedSignal() {
        ensureAdwInit()
        let btn = SplitButton()
        btn.label = "Test"
        btn.onClicked {}
        btn.onActivate {}
        // No crash = success
    }

    // MARK: - PreferencesDialog add/remove

    @MainActor func test_preferencesDialogAddRemove() {
        ensureAdwInit()
        let dialog = PreferencesDialog()
        let page = PreferencesPage()
        page.title = "General"
        dialog.add(page)
        dialog.remove(page)
        // No crash = success
    }

    // MARK: - CheckButton enhancements

    @MainActor func test_checkButtonInconsistent() {
        ensureAdwInit()
        let check = CheckButton(label: "Test")
        XCTAssertTrue(check.inconsistent == false)
        check.inconsistent = true
        XCTAssertTrue(check.inconsistent == true)
    }

    @MainActor func test_checkButtonChild() {
        ensureAdwInit()
        let check = CheckButton()
        let label = Label("Custom child")
        check.child = label
        XCTAssertNotNil(check.child)
    }

    @MainActor func test_checkButtonUseUnderline() {
        ensureAdwInit()
        let check = CheckButton(label: "_Mnemonic")
        check.useUnderline = true
        XCTAssertTrue(check.useUnderline == true)
    }

    // MARK: - DropDown showArrow

    @MainActor func test_dropDownShowArrow() {
        ensureAdwInit()
        let dd = DropDown(strings: ["A", "B"])
        XCTAssertTrue(dd.showArrow == true)
        dd.showArrow = false
        XCTAssertTrue(dd.showArrow == false)
    }

}
#endif
