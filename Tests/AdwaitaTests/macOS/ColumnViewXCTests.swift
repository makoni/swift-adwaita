// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class ColumnViewXCTests: XCTestCase {

    // MARK: - ColumnView Tests

    @MainActor func test_columnViewCreationWithSingleSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let selection = SingleSelection(model: store)
        let columnView = ColumnView(model: selection)
        XCTAssertNotNil(columnView.pointer)
    }

    @MainActor func test_columnViewCreationWithNoSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)
        XCTAssertNotNil(columnView.pointer)
    }

    @MainActor func test_columnViewCreationWithMultiSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let selection = MultiSelection(model: store)
        let columnView = ColumnView(model: selection)
        XCTAssertNotNil(columnView.pointer)
    }

    @MainActor func test_columnViewShowRowSeparators() {
        ensureAdwInit()
        let store = ListStore()
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)
        XCTAssertTrue(columnView.showRowSeparators == false)
        columnView.showRowSeparators = true
        XCTAssertTrue(columnView.showRowSeparators == true)
    }

    @MainActor func test_columnViewShowColumnSeparators() {
        ensureAdwInit()
        let store = ListStore()
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)
        XCTAssertTrue(columnView.showColumnSeparators == false)
        columnView.showColumnSeparators = true
        XCTAssertTrue(columnView.showColumnSeparators == true)
    }

    @MainActor func test_columnViewSingleClickActivate() {
        ensureAdwInit()
        let store = ListStore()
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)
        XCTAssertTrue(columnView.singleClickActivate == false)
        columnView.singleClickActivate = true
        XCTAssertTrue(columnView.singleClickActivate == true)
    }

    @MainActor func test_columnViewReorderable() {
        ensureAdwInit()
        let store = ListStore()
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)
        columnView.reorderable = true
        XCTAssertTrue(columnView.reorderable == true)
        columnView.reorderable = false
        XCTAssertTrue(columnView.reorderable == false)
    }

    @MainActor func test_columnViewEnableRubberband() {
        ensureAdwInit()
        let store = ListStore()
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)
        XCTAssertTrue(columnView.enableRubberband == false)
        columnView.enableRubberband = true
        XCTAssertTrue(columnView.enableRubberband == true)
    }

    // MARK: - ColumnViewColumn Tests

    @MainActor func test_columnViewColumnCreation() {
        ensureAdwInit()
        let factory = SignalListItemFactory()
        let column = ColumnViewColumn(title: "Name", factory: factory)
        XCTAssertTrue(column.title == "Name")
    }

    @MainActor func test_columnViewColumnNilTitle() {
        ensureAdwInit()
        let factory = SignalListItemFactory()
        let column = ColumnViewColumn(title: nil, factory: factory)
        XCTAssertNil(column.title)
    }

    @MainActor func test_columnViewColumnTitleSetGet() {
        ensureAdwInit()
        let factory = SignalListItemFactory()
        let column = ColumnViewColumn(title: "Original", factory: factory)
        XCTAssertTrue(column.title == "Original")
        column.title = "Updated"
        XCTAssertTrue(column.title == "Updated")
    }

    @MainActor func test_columnViewColumnFixedWidth() {
        ensureAdwInit()
        let factory = SignalListItemFactory()
        let column = ColumnViewColumn(title: "Col", factory: factory)
        XCTAssertTrue(column.fixedWidth == -1)
        column.fixedWidth = 200
        XCTAssertTrue(column.fixedWidth == 200)
    }

    @MainActor func test_columnViewColumnResizable() {
        ensureAdwInit()
        let factory = SignalListItemFactory()
        let column = ColumnViewColumn(title: "Col", factory: factory)
        column.resizable = true
        XCTAssertTrue(column.resizable == true)
        column.resizable = false
        XCTAssertTrue(column.resizable == false)
    }

    @MainActor func test_columnViewColumnExpand() {
        ensureAdwInit()
        let factory = SignalListItemFactory()
        let column = ColumnViewColumn(title: "Col", factory: factory)
        XCTAssertTrue(column.expand == false)
        column.expand = true
        XCTAssertTrue(column.expand == true)
    }

    @MainActor func test_columnViewColumnVisible() {
        ensureAdwInit()
        let factory = SignalListItemFactory()
        let column = ColumnViewColumn(title: "Col", factory: factory)
        XCTAssertTrue(column.isVisible == true)
        column.isVisible = false
        XCTAssertTrue(column.isVisible == false)
    }

    @MainActor func test_columnViewAppendColumn() {
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
        XCTAssertNotNil(columnView.pointer)
    }

    @MainActor func test_columnViewRemoveColumn() {
        ensureAdwInit()
        let store = ListStore()
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)

        let factory = SignalListItemFactory()
        let column = ColumnViewColumn(title: "Temp", factory: factory)
        columnView.appendColumn(column)
        columnView.removeColumn(column)
        XCTAssertNotNil(columnView.pointer)
    }

    @MainActor func test_columnViewInsertColumn() {
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
        XCTAssertNotNil(columnView.pointer)
    }

}
#endif
