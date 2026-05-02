#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class WidgetCoverageXCTests: XCTestCase {

    // MARK: - ListBox: Creation and Basic Operations

    @MainActor func test_listBoxCreation() {
        ensureAdwInit()
        let list = ListBox()
        XCTAssertNil(list.selectedRow)
        XCTAssertNil(list.selectedIndex)
    }

    @MainActor func test_listBoxAppendPrependRemove() {
        ensureAdwInit()
        let list = ListBox()
        let a = ListBoxRow()
        a.child = Label("A")
        let b = ListBoxRow()
        b.child = Label("B")
        let c = ListBoxRow()
        c.child = Label("C")
        list.append(a)
        list.prepend(b)
        list.append(c)
        let firstRow = list.rowAt(0)
        XCTAssertNotNil(firstRow)
        list.remove(a)
    }

    @MainActor func test_listBoxInsert() {
        ensureAdwInit()
        let list = ListBox()
        let a = Label("A")
        let c = Label("C")
        list.append(a)
        list.append(c)
        let b = Label("B")
        list.insert(b, position: 1)
        let row = list.rowAt(1)
        XCTAssertNotNil(row)
    }

    @MainActor func test_listBoxRemoveAll() {
        ensureAdwInit()
        let list = ListBox()
        list.append(Label("1"))
        list.append(Label("2"))
        list.append(Label("3"))
        list.removeAll()
        XCTAssertNil(list.rowAt(0))
    }

    // MARK: - ListBox: Selection

    @MainActor func test_listBoxSelectionMode() {
        ensureAdwInit()
        let list = ListBox()
        list.selectionMode = .single
        XCTAssertTrue(list.selectionMode == .single)
        list.selectionMode = .none
        XCTAssertTrue(list.selectionMode == .none)
        list.selectionMode = .multiple
        XCTAssertTrue(list.selectionMode == .multiple)
    }

    @MainActor func test_listBoxSelectAndUnselectRow() {
        ensureAdwInit()
        let list = ListBox()
        list.selectionMode = .single
        list.append(Label("A"))
        list.append(Label("B"))
        list.selectRow(at: 0)
        XCTAssertNotNil(list.selectedRow)
        XCTAssertTrue(list.selectedIndex == 0)
        list.selectRow(at: 1)
        XCTAssertTrue(list.selectedIndex == 1)
        list.unselectRow(at: 1)
    }

    @MainActor func test_listBoxUnselectAll() {
        ensureAdwInit()
        let list = ListBox()
        list.selectionMode = .multiple
        list.append(Label("A"))
        list.append(Label("B"))
        list.selectAll()
        list.unselectAll()
        XCTAssertNil(list.selectedRow)
    }

    // MARK: - ListBox: Properties

    @MainActor func test_listBoxActivateOnSingleClick() {
        ensureAdwInit()
        let list = ListBox()
        XCTAssertTrue(list.activateOnSingleClick == true)
        list.activateOnSingleClick = false
        XCTAssertTrue(list.activateOnSingleClick == false)
        list.activateOnSingleClick = true
        XCTAssertTrue(list.activateOnSingleClick == true)
    }

    // MARK: - ListBox: Placeholder

    @MainActor func test_listBoxSetPlaceholder() {
        ensureAdwInit()
        let list = ListBox()
        let placeholder = Label("No items")
        list.setPlaceholder(placeholder)
        list.setPlaceholder(nil)
    }

    // MARK: - ListBox: Sort / Filter / Header

    @MainActor func test_listBoxHeaderFunc() {
        ensureAdwInit()
        let list = ListBox()
        list.append(Label("A"))
        list.append(Label("B"))
        list.setHeaderFunc { row, before in
            if before != nil {
                row.header = Separator()
            }
        }
        list.invalidateHeaders()
        list.clearHeaderFunc()
    }

    // MARK: - ListBox: Signals

    @MainActor func test_listBoxOnRowSelectedSignal() {
        ensureAdwInit()
        let list = ListBox()
        list.selectionMode = .single
        let conn = list.onRowSelected { _ in }
        conn.disconnect()
    }

    @MainActor func test_listBoxOnRowActivatedSignal() {
        ensureAdwInit()
        let list = ListBox()
        let conn = list.onRowActivated { _ in }
        conn.disconnect()
    }

    // MARK: - ListBox: Row At / SelectedIndex

    @MainActor func test_listBoxRowAtIndex() {
        ensureAdwInit()
        let list = ListBox()
        list.append(Label("First"))
        list.append(Label("Second"))
        let row0 = list.rowAt(0)
        XCTAssertNotNil(row0)
        let row1 = list.rowAt(1)
        XCTAssertNotNil(row1)
        let rowOut = list.rowAt(99)
        XCTAssertNil(rowOut)
    }

    @MainActor func test_listBoxSelectedIndexNil() {
        ensureAdwInit()
        let list = ListBox()
        list.selectionMode = .single
        list.append(Label("Item"))
        XCTAssertNil(list.selectedIndex)
    }

    // MARK: - ListBoxRow Properties

    @MainActor func test_listBoxRowProperties() {
        ensureAdwInit()
        let row = ListBoxRow()
        let label = Label("Content")
        row.child = label
        XCTAssertNotNil(row.child)
        XCTAssertTrue(row.index == -1)
        row.activatable = false
        XCTAssertTrue(row.activatable == false)
        row.activatable = true
        XCTAssertTrue(row.activatable == true)
        row.selectable = false
        XCTAssertTrue(row.selectable == false)
        row.selectable = true
        XCTAssertTrue(row.selectable == true)
    }

    @MainActor func test_listBoxRowIndexInListBox() {
        ensureAdwInit()
        let list = ListBox()
        let row = ListBoxRow()
        row.child = Label("Item")
        list.append(row)
        XCTAssertTrue(row.index == 0)
    }

    @MainActor func test_listBoxRowHeaderProperty() {
        ensureAdwInit()
        let row = ListBoxRow()
        XCTAssertNil(row.header)
        let header = Label("Header")
        row.header = header
        XCTAssertNotNil(row.header)
        row.header = nil
        XCTAssertNil(row.header)
    }

    // MARK: - Entry: Additional Coverage

    @MainActor func test_entryInputHints() {
        ensureAdwInit()
        let entry = Entry()
        entry.inputHints = GTK_INPUT_HINT_SPELLCHECK
        XCTAssertTrue(entry.inputHints == GTK_INPUT_HINT_SPELLCHECK)
        entry.inputHints = GTK_INPUT_HINT_NO_SPELLCHECK
        XCTAssertTrue(entry.inputHints == GTK_INPUT_HINT_NO_SPELLCHECK)
    }

    @MainActor func test_entrySecondaryIcon() {
        ensureAdwInit()
        let entry = Entry()
        entry.setIcon(position: .secondary, iconName: "edit-clear-symbolic")
        XCTAssertTrue(entry.iconName(at: .secondary) == "edit-clear-symbolic")
        entry.setIcon(position: .secondary, iconName: nil)
        XCTAssertNil(entry.iconName(at: .secondary))
    }

    @MainActor func test_entryIconTooltip() {
        ensureAdwInit()
        let entry = Entry()
        entry.setIcon(position: .primary, iconName: "edit-find-symbolic")
        entry.setIconTooltip(position: .primary, tooltip: "Search")
        entry.setIconActivatable(position: .primary, activatable: true)
    }

    @MainActor func test_entryConvenienceInitWithHandler() {
        ensureAdwInit()
        var changed = false
        let entry = Entry(placeholder: "Type here") {
            changed = true
        }
        XCTAssertTrue(entry.placeholderText == "Type here")
        entry.text = "trigger"
        XCTAssertTrue(changed, "Handler should fire on text change")
    }

    // MARK: - Scale: Additional Coverage

    @MainActor func test_scaleOnValueChangedSignal() {
        ensureAdwInit()
        let scale = Scale(min: 0, max: 100, step: 1)
        var changed = false
        scale.onValueChanged { changed = true }
        scale.value = 42
        XCTAssertTrue(changed, "onValueChanged should fire when value is set")
    }

    @MainActor func test_scaleFluentDrawValue() {
        ensureAdwInit()
        let scale = Scale().drawValue(true)
        XCTAssertTrue(scale.drawValue == true)
    }

    @MainActor func test_scaleFluentDigits() {
        ensureAdwInit()
        let scale = Scale().digits(2)
        XCTAssertTrue(scale.digits == 2)
    }

    // MARK: - Notebook: Additional Coverage

    @MainActor func test_notebookAppendWithTabWidget() {
        ensureAdwInit()
        let notebook = Notebook()
        let content = Label("Content")
        let tabWidget = Box(orientation: GTK_ORIENTATION_HORIZONTAL)
        tabWidget.append(Label("Custom Tab"))
        let idx = notebook.appendPage(content, tabWidget: tabWidget)
        XCTAssertTrue(idx == 0)
        XCTAssertTrue(notebook.nPages == 1)
    }

    @MainActor func test_notebookPageNum() {
        ensureAdwInit()
        let notebook = Notebook()
        let page1 = Label("Page 1")
        let page2 = Label("Page 2")
        notebook.appendPage(page1, label: "First")
        notebook.appendPage(page2, label: "Second")
        XCTAssertTrue(notebook.pageNum(page1) == 0)
        XCTAssertTrue(notebook.pageNum(page2) == 1)
    }

    @MainActor func test_notebookSetTabReorderable() {
        ensureAdwInit()
        let notebook = Notebook()
        let page = Label("Content")
        notebook.appendPage(page, label: "Tab")
        notebook.setTabReorderable(page, reorderable: true)
    }

    @MainActor func test_notebookReorderChild() {
        ensureAdwInit()
        let notebook = Notebook()
        let p1 = Label("Page 1")
        let p2 = Label("Page 2")
        notebook.appendPage(p1, label: "First")
        notebook.appendPage(p2, label: "Second")
        notebook.reorderChild(p1, position: 1)
        XCTAssertTrue(notebook.pageNum(p1) == 1)
    }

    @MainActor func test_notebookOnSwitchPageSignal() {
        ensureAdwInit()
        let notebook = Notebook()
        var switchedTo: Int = -1
        let conn = notebook.onSwitchPage { pageIndex in
            switchedTo = pageIndex
        }
        let p1 = Label("Page 1")
        let p2 = Label("Page 2")
        notebook.appendPage(p1, label: "First")
        notebook.appendPage(p2, label: "Second")
        notebook.currentPage = 1
        _ = switchedTo
        conn.disconnect()
    }

    @MainActor func test_notebookGetNthPageNil() {
        ensureAdwInit()
        let notebook = Notebook()
        let page = notebook.getNthPage(99)
        XCTAssertNil(page)
    }

    @MainActor func test_notebookSetTabLabelText() {
        ensureAdwInit()
        let notebook = Notebook()
        let content = Label("Content")
        notebook.appendPage(content, label: "Original")
        XCTAssertTrue(notebook.getTabLabelText(content) == "Original")
        notebook.setTabLabelText(content, text: "Renamed")
        XCTAssertTrue(notebook.getTabLabelText(content) == "Renamed")
    }
}
#endif
