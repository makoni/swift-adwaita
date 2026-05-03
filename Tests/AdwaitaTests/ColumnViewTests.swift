// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct ColumnViewTests {

    // MARK: - ColumnView Tests

    @Test @MainActor func columnViewCreationWithSingleSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let selection = SingleSelection(model: store)
        let columnView = ColumnView(model: selection)
        #expect(columnView.pointer != nil)
    }

    @Test @MainActor func columnViewCreationWithNoSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)
        #expect(columnView.pointer != nil)
    }

    @Test @MainActor func columnViewCreationWithMultiSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let selection = MultiSelection(model: store)
        let columnView = ColumnView(model: selection)
        #expect(columnView.pointer != nil)
    }

    @Test @MainActor func columnViewShowRowSeparators() {
        ensureAdwInit()
        let store = ListStore()
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)
        #expect(columnView.showRowSeparators == false)
        columnView.showRowSeparators = true
        #expect(columnView.showRowSeparators == true)
    }

    @Test @MainActor func columnViewShowColumnSeparators() {
        ensureAdwInit()
        let store = ListStore()
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)
        #expect(columnView.showColumnSeparators == false)
        columnView.showColumnSeparators = true
        #expect(columnView.showColumnSeparators == true)
    }

    @Test @MainActor func columnViewSingleClickActivate() {
        ensureAdwInit()
        let store = ListStore()
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)
        #expect(columnView.singleClickActivate == false)
        columnView.singleClickActivate = true
        #expect(columnView.singleClickActivate == true)
    }

    @Test @MainActor func columnViewReorderable() {
        ensureAdwInit()
        let store = ListStore()
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)
        columnView.reorderable = true
        #expect(columnView.reorderable == true)
        columnView.reorderable = false
        #expect(columnView.reorderable == false)
    }

    @Test @MainActor func columnViewEnableRubberband() {
        ensureAdwInit()
        let store = ListStore()
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)
        #expect(columnView.enableRubberband == false)
        columnView.enableRubberband = true
        #expect(columnView.enableRubberband == true)
    }

    // MARK: - ColumnViewColumn Tests

    @Test @MainActor func columnViewColumnCreation() {
        ensureAdwInit()
        let factory = SignalListItemFactory()
        let column = ColumnViewColumn(title: "Name", factory: factory)
        #expect(column.title == "Name")
    }

    @Test @MainActor func columnViewColumnNilTitle() {
        ensureAdwInit()
        let factory = SignalListItemFactory()
        let column = ColumnViewColumn(title: nil, factory: factory)
        #expect(column.title == nil)
    }

    @Test @MainActor func columnViewColumnTitleSetGet() {
        ensureAdwInit()
        let factory = SignalListItemFactory()
        let column = ColumnViewColumn(title: "Original", factory: factory)
        #expect(column.title == "Original")
        column.title = "Updated"
        #expect(column.title == "Updated")
    }

    @Test @MainActor func columnViewColumnFixedWidth() {
        ensureAdwInit()
        let factory = SignalListItemFactory()
        let column = ColumnViewColumn(title: "Col", factory: factory)
        #expect(column.fixedWidth == -1)
        column.fixedWidth = 200
        #expect(column.fixedWidth == 200)
    }

    @Test @MainActor func columnViewColumnResizable() {
        ensureAdwInit()
        let factory = SignalListItemFactory()
        let column = ColumnViewColumn(title: "Col", factory: factory)
        column.resizable = true
        #expect(column.resizable == true)
        column.resizable = false
        #expect(column.resizable == false)
    }

    @Test @MainActor func columnViewColumnExpand() {
        ensureAdwInit()
        let factory = SignalListItemFactory()
        let column = ColumnViewColumn(title: "Col", factory: factory)
        #expect(column.expand == false)
        column.expand = true
        #expect(column.expand == true)
    }

    @Test @MainActor func columnViewColumnVisible() {
        ensureAdwInit()
        let factory = SignalListItemFactory()
        let column = ColumnViewColumn(title: "Col", factory: factory)
        #expect(column.isVisible == true)
        column.isVisible = false
        #expect(column.isVisible == false)
    }

    @Test @MainActor func columnViewAppendColumn() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)

        let factory1 = SignalListItemFactory()
        let factory2 = SignalListItemFactory()
        let col1 = ColumnViewColumn(title: "A", factory: factory1)
        let col2 = ColumnViewColumn(title: "B", factory: factory2)

        columnView.appendColumn(col1)
        columnView.appendColumn(col2)
        #expect(columnView.pointer != nil)
    }

    @Test @MainActor func columnViewRemoveColumn() {
        ensureAdwInit()
        let store = ListStore()
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)

        let factory = SignalListItemFactory()
        let column = ColumnViewColumn(title: "Temp", factory: factory)
        columnView.appendColumn(column)
        columnView.removeColumn(column)
        #expect(columnView.pointer != nil)
    }

    @Test @MainActor func columnViewInsertColumn() {
        ensureAdwInit()
        let store = ListStore()
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)

        let factory1 = SignalListItemFactory()
        let factory2 = SignalListItemFactory()
        let factory3 = SignalListItemFactory()
        let col1 = ColumnViewColumn(title: "First", factory: factory1)
        let col2 = ColumnViewColumn(title: "Last", factory: factory2)
        let col3 = ColumnViewColumn(title: "Middle", factory: factory3)

        columnView.appendColumn(col1)
        columnView.appendColumn(col2)
        columnView.insertColumn(col3, at: 1)
        #expect(columnView.pointer != nil)
    }

}
#endif
