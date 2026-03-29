import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct WidgetCoverageTests {

    // MARK: - ListBox: Creation and Basic Operations

    @Test @MainActor func listBoxCreation() {
        ensureAdwInit()
        let list = ListBox()
        #expect(list.selectedRow == nil)
        #expect(list.selectedIndex == nil)
    }

    @Test @MainActor func listBoxAppendPrependRemove() {
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
        #expect(firstRow != nil)
        list.remove(a)
    }

    @Test @MainActor func listBoxInsert() {
        ensureAdwInit()
        let list = ListBox()
        let a = Label("A")
        let c = Label("C")
        list.append(a)
        list.append(c)
        let b = Label("B")
        list.insert(b, position: 1)
        let row = list.rowAt(1)
        #expect(row != nil)
    }

    @Test @MainActor func listBoxRemoveAll() {
        ensureAdwInit()
        let list = ListBox()
        list.append(Label("1"))
        list.append(Label("2"))
        list.append(Label("3"))
        list.removeAll()
        #expect(list.rowAt(0) == nil)
    }

    // MARK: - ListBox: Selection

    @Test @MainActor func listBoxSelectionMode() {
        ensureAdwInit()
        let list = ListBox()
        list.selectionMode = .single
        #expect(list.selectionMode == .single)
        list.selectionMode = .none
        #expect(list.selectionMode == .none)
        list.selectionMode = .multiple
        #expect(list.selectionMode == .multiple)
    }

    @Test @MainActor func listBoxSelectAndUnselectRow() {
        ensureAdwInit()
        let list = ListBox()
        list.selectionMode = .single
        list.append(Label("A"))
        list.append(Label("B"))
        list.selectRow(at: 0)
        #expect(list.selectedRow != nil)
        #expect(list.selectedIndex == 0)
        list.selectRow(at: 1)
        #expect(list.selectedIndex == 1)
        list.unselectRow(at: 1)
    }

    @Test @MainActor func listBoxUnselectAll() {
        ensureAdwInit()
        let list = ListBox()
        list.selectionMode = .multiple
        list.append(Label("A"))
        list.append(Label("B"))
        list.selectAll()
        list.unselectAll()
        #expect(list.selectedRow == nil)
    }

    // MARK: - ListBox: Properties

    @Test @MainActor func listBoxShowSeparators() {
        ensureAdwInit()
        let list = ListBox()
        #expect(list.showSeparators == false)
        list.showSeparators = true
        #expect(list.showSeparators == true)
        list.showSeparators = false
        #expect(list.showSeparators == false)
    }

    @Test @MainActor func listBoxActivateOnSingleClick() {
        ensureAdwInit()
        let list = ListBox()
        #expect(list.activateOnSingleClick == true)
        list.activateOnSingleClick = false
        #expect(list.activateOnSingleClick == false)
        list.activateOnSingleClick = true
        #expect(list.activateOnSingleClick == true)
    }

    // MARK: - ListBox: Placeholder

    @Test @MainActor func listBoxSetPlaceholder() {
        ensureAdwInit()
        let list = ListBox()
        let placeholder = Label("No items")
        list.setPlaceholder(placeholder)
        list.setPlaceholder(nil)
    }

    // MARK: - ListBox: Sort / Filter / Header

    @Test @MainActor func listBoxSortFunc() {
        ensureAdwInit()
        let list = ListBox()
        list.append(Label("C"))
        list.append(Label("A"))
        list.append(Label("B"))
        list.setSortFunc { _, _ in 0 }
        list.invalidateSort()
        list.clearSortFunc()
    }

    @Test @MainActor func listBoxFilterFunc() {
        ensureAdwInit()
        let list = ListBox()
        list.append(Label("Show"))
        list.append(Label("Hide"))
        list.setFilterFunc { _ in true }
        list.invalidateFilter()
        list.clearFilterFunc()
    }

    @Test @MainActor func listBoxHeaderFunc() {
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

    @Test @MainActor func listBoxOnRowSelectedSignal() {
        ensureAdwInit()
        let list = ListBox()
        list.selectionMode = .single
        let conn = list.onRowSelected { _ in }
        conn.disconnect()
    }

    @Test @MainActor func listBoxOnRowActivatedSignal() {
        ensureAdwInit()
        let list = ListBox()
        let conn = list.onRowActivated { _ in }
        conn.disconnect()
    }

    // MARK: - ListBox: Row At / SelectedIndex

    @Test @MainActor func listBoxRowAtIndex() {
        ensureAdwInit()
        let list = ListBox()
        list.append(Label("First"))
        list.append(Label("Second"))
        let row0 = list.rowAt(0)
        #expect(row0 != nil)
        let row1 = list.rowAt(1)
        #expect(row1 != nil)
        let rowOut = list.rowAt(99)
        #expect(rowOut == nil)
    }

    @Test @MainActor func listBoxSelectedIndexNil() {
        ensureAdwInit()
        let list = ListBox()
        list.selectionMode = .single
        list.append(Label("Item"))
        #expect(list.selectedIndex == nil)
    }

    // MARK: - ListBoxRow Properties

    @Test @MainActor func listBoxRowProperties() {
        ensureAdwInit()
        let row = ListBoxRow()
        let label = Label("Content")
        row.child = label
        #expect(row.child != nil)
        #expect(row.index == -1)
        row.activatable = false
        #expect(row.activatable == false)
        row.activatable = true
        #expect(row.activatable == true)
        row.selectable = false
        #expect(row.selectable == false)
        row.selectable = true
        #expect(row.selectable == true)
    }

    @Test @MainActor func listBoxRowIndexInListBox() {
        ensureAdwInit()
        let list = ListBox()
        let row = ListBoxRow()
        row.child = Label("Item")
        list.append(row)
        #expect(row.index == 0)
    }

    @Test @MainActor func listBoxRowHeaderProperty() {
        ensureAdwInit()
        let row = ListBoxRow()
        #expect(row.header == nil)
        let header = Label("Header")
        row.header = header
        #expect(row.header != nil)
        row.header = nil
        #expect(row.header == nil)
    }

    @Test @MainActor func listBoxRowChanged() {
        ensureAdwInit()
        let list = ListBox()
        let row = ListBoxRow()
        row.child = Label("Item")
        list.append(row)
        row.changed()
    }

    // MARK: - Entry: Additional Coverage

    @Test @MainActor func entryActivatesDefault() {
        ensureAdwInit()
        let entry = Entry()
        #expect(entry.activatesDefault == false)
        entry.activatesDefault = true
        #expect(entry.activatesDefault == true)
    }

    @Test @MainActor func entryInputHints() {
        ensureAdwInit()
        let entry = Entry()
        entry.inputHints = GTK_INPUT_HINT_SPELLCHECK
        #expect(entry.inputHints == GTK_INPUT_HINT_SPELLCHECK)
        entry.inputHints = GTK_INPUT_HINT_NO_SPELLCHECK
        #expect(entry.inputHints == GTK_INPUT_HINT_NO_SPELLCHECK)
    }

    @Test @MainActor func entrySecondaryIcon() {
        ensureAdwInit()
        let entry = Entry()
        entry.setIcon(position: .secondary, iconName: "edit-clear-symbolic")
        #expect(entry.iconName(at: .secondary) == "edit-clear-symbolic")
        entry.setIcon(position: .secondary, iconName: nil)
        #expect(entry.iconName(at: .secondary) == nil)
    }

    @Test @MainActor func entryIconTooltip() {
        ensureAdwInit()
        let entry = Entry()
        entry.setIcon(position: .primary, iconName: "edit-find-symbolic")
        entry.setIconTooltip(position: .primary, tooltip: "Search")
        entry.setIconActivatable(position: .primary, activatable: true)
    }

    @Test @MainActor func entryProgressPulse() {
        ensureAdwInit()
        let entry = Entry()
        entry.progressPulseStep = 0.1
        entry.progressPulse()
    }

    @Test @MainActor func entryConvenienceInitWithHandler() {
        ensureAdwInit()
        var changed = false
        let entry = Entry(placeholder: "Type here") {
            changed = true
        }
        #expect(entry.placeholderText == "Type here")
        entry.text = "trigger"
        #expect(changed, "Handler should fire on text change")
    }

    // MARK: - Scale: Additional Coverage

    @Test @MainActor func scaleValuePos() {
        ensureAdwInit()
        let scale = Scale()
        scale.drawValue = true
        scale.valuePos = .top
        #expect(scale.valuePos == .top)
        scale.valuePos = .bottom
        #expect(scale.valuePos == .bottom)
    }

    @Test @MainActor func scaleFormatValueFunc() {
        ensureAdwInit()
        let scale = Scale(min: 0, max: 100, step: 1)
        scale.drawValue = true
        scale.setFormatValueFunc { value in "\(Int(value))%" }
        scale.value = 50
        scale.setFormatValueFunc(nil)
    }

    @Test @MainActor func scaleOnValueChangedSignal() {
        ensureAdwInit()
        let scale = Scale(min: 0, max: 100, step: 1)
        var changed = false
        scale.onValueChanged { changed = true }
        scale.value = 42
        #expect(changed, "onValueChanged should fire when value is set")
    }

    @Test @MainActor func scaleAddAndClearMarks() {
        ensureAdwInit()
        let scale = Scale(min: 0, max: 100, step: 1)
        scale.addMark(value: 0, position: .top, markup: "0%")
        scale.addMark(value: 50, position: .bottom, markup: "50%")
        scale.addMark(value: 100, position: .top, markup: "100%")
        scale.clearMarks()
    }

    @Test @MainActor func scaleFluentDrawValue() {
        ensureAdwInit()
        let scale = Scale().drawValue(true)
        #expect(scale.drawValue == true)
    }

    @Test @MainActor func scaleFluentDigits() {
        ensureAdwInit()
        let scale = Scale().digits(2)
        #expect(scale.digits == 2)
    }

    // MARK: - Notebook: Additional Coverage

    @Test @MainActor func notebookAppendWithTabWidget() {
        ensureAdwInit()
        let notebook = Notebook()
        let content = Label("Content")
        let tabWidget = Box(orientation: GTK_ORIENTATION_HORIZONTAL)
        tabWidget.append(Label("Custom Tab"))
        let idx = notebook.appendPage(content, tabWidget: tabWidget)
        #expect(idx == 0)
        #expect(notebook.nPages == 1)
    }

    @Test @MainActor func notebookPageNum() {
        ensureAdwInit()
        let notebook = Notebook()
        let page1 = Label("Page 1")
        let page2 = Label("Page 2")
        notebook.appendPage(page1, label: "First")
        notebook.appendPage(page2, label: "Second")
        #expect(notebook.pageNum(page1) == 0)
        #expect(notebook.pageNum(page2) == 1)
    }

    @Test @MainActor func notebookSetTabReorderable() {
        ensureAdwInit()
        let notebook = Notebook()
        let page = Label("Content")
        notebook.appendPage(page, label: "Tab")
        notebook.setTabReorderable(page, reorderable: true)
    }

    @Test @MainActor func notebookReorderChild() {
        ensureAdwInit()
        let notebook = Notebook()
        let p1 = Label("Page 1")
        let p2 = Label("Page 2")
        notebook.appendPage(p1, label: "First")
        notebook.appendPage(p2, label: "Second")
        notebook.reorderChild(p1, position: 1)
        #expect(notebook.pageNum(p1) == 1)
    }

    @Test @MainActor func notebookOnSwitchPageSignal() {
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

    @Test @MainActor func notebookGetNthPageNil() {
        ensureAdwInit()
        let notebook = Notebook()
        let page = notebook.getNthPage(99)
        #expect(page == nil)
    }

    @Test @MainActor func notebookSetTabLabelText() {
        ensureAdwInit()
        let notebook = Notebook()
        let content = Label("Content")
        notebook.appendPage(content, label: "Original")
        #expect(notebook.getTabLabelText(content) == "Original")
        notebook.setTabLabelText(content, text: "Renamed")
        #expect(notebook.getTabLabelText(content) == "Renamed")
    }
}
