#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class ListViewXCTests: XCTestCase {

    // MARK: - ListView Infrastructure

    @MainActor func test_listStoreCreation() {
        ensureAdwInit()
        let store = ListStore()
        XCTAssertTrue(store.count == 0)
    }

    @MainActor func test_listStoreAppendRemove() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        XCTAssertTrue(store.count == 3)

        store.remove(at: 1)
        XCTAssertTrue(store.count == 2)

        store.removeAll()
        XCTAssertTrue(store.count == 0)
    }

    @MainActor func test_listStoreInsert() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        XCTAssertTrue(store.count == 2)

        store.insertPlaceholder(at: 1)
        XCTAssertTrue(store.count == 3)
    }

    @MainActor func test_noSelectionCreation() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let selection = NoSelection(model: store)
        XCTAssertNotNil(selection.selectionModelPointer)
    }

    @MainActor func test_singleSelectionCreation() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = SingleSelection(model: store)
        XCTAssertTrue(selection.selected == 0) // autoselects first
        selection.canUnselect = true
        XCTAssertTrue(selection.canUnselect == true)
    }

    @MainActor func test_singleSelectionAutoselect() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let selection = SingleSelection(model: store)
        selection.autoselect = false
        XCTAssertTrue(selection.autoselect == false)
        selection.autoselect = true
        XCTAssertTrue(selection.autoselect == true)
    }

    @MainActor func test_signalListItemFactoryCreation() {
        ensureAdwInit()
        let factory = SignalListItemFactory()
        XCTAssertNotNil(factory.pointer)
    }

    @MainActor func test_listViewCreation() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let factory = SignalListItemFactory()
        let selection = NoSelection(model: store)
        let listView = ListView(model: selection, factory: factory)
        XCTAssertTrue(listView.showSeparators == false)
        listView.showSeparators = true
        XCTAssertTrue(listView.showSeparators == true)
    }

    @MainActor func test_listViewSingleClickActivate() {
        ensureAdwInit()
        let store = ListStore()
        let factory = SignalListItemFactory()
        let selection = NoSelection(model: store)
        let listView = ListView(model: selection, factory: factory)
        XCTAssertTrue(listView.singleClickActivate == false)
        listView.singleClickActivate = true
        XCTAssertTrue(listView.singleClickActivate == true)
    }

    @MainActor func test_listViewWithSingleSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let factory = SignalListItemFactory()
        let selection = SingleSelection(model: store)
        let listView = ListView(model: selection, factory: factory)
        XCTAssertNotNil(listView.pointer)
        XCTAssertTrue(selection.selected == 0)
    }

    // MARK: - MultiSelection Tests

    @MainActor func test_multiSelectionCreation() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = MultiSelection(model: store)
        XCTAssertNotNil(selection.selectionModelPointer)
    }

    @MainActor func test_multiSelectionWithStringList() {
        ensureAdwInit()
        let strings = StringList(["a", "b", "c"])
        let selection = MultiSelection(model: strings)
        XCTAssertNotNil(selection.selectionModelPointer)
    }

    @MainActor func test_multiSelectionSelectItem() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = MultiSelection(model: store)

        // Initially nothing is selected
        XCTAssertTrue(selection.isSelected(position: 0) == false)
        XCTAssertTrue(selection.isSelected(position: 1) == false)

        // Select first item
        selection.selectItem(position: 0, unselectRest: false)
        XCTAssertTrue(selection.isSelected(position: 0) == true)

        // Select second item without unselecting first
        selection.selectItem(position: 1, unselectRest: false)
        XCTAssertTrue(selection.isSelected(position: 0) == true)
        XCTAssertTrue(selection.isSelected(position: 1) == true)
    }

    @MainActor func test_multiSelectionUnselectItem() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = MultiSelection(model: store)

        selection.selectItem(position: 0, unselectRest: false)
        selection.selectItem(position: 1, unselectRest: false)
        XCTAssertTrue(selection.isSelected(position: 0) == true)
        XCTAssertTrue(selection.isSelected(position: 1) == true)

        selection.unselectItem(position: 0)
        XCTAssertTrue(selection.isSelected(position: 0) == false)
        XCTAssertTrue(selection.isSelected(position: 1) == true)
    }

    @MainActor func test_multiSelectionSelectUnselectAll() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = MultiSelection(model: store)

        selection.selectAll()
        XCTAssertTrue(selection.isSelected(position: 0) == true)
        XCTAssertTrue(selection.isSelected(position: 1) == true)
        XCTAssertTrue(selection.isSelected(position: 2) == true)

        selection.unselectAll()
        XCTAssertTrue(selection.isSelected(position: 0) == false)
        XCTAssertTrue(selection.isSelected(position: 1) == false)
        XCTAssertTrue(selection.isSelected(position: 2) == false)
    }

    @MainActor func test_multiSelectionSelectItemUnselectRest() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = MultiSelection(model: store)

        selection.selectAll()
        XCTAssertTrue(selection.isSelected(position: 0) == true)
        XCTAssertTrue(selection.isSelected(position: 1) == true)
        XCTAssertTrue(selection.isSelected(position: 2) == true)

        // Select position 1 with unselectRest: true should clear others
        selection.selectItem(position: 1, unselectRest: true)
        XCTAssertTrue(selection.isSelected(position: 0) == false)
        XCTAssertTrue(selection.isSelected(position: 1) == true)
        XCTAssertTrue(selection.isSelected(position: 2) == false)
    }

    @MainActor func test_listViewWithMultiSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let factory = SignalListItemFactory()
        let selection = MultiSelection(model: store)
        let listView = ListView(model: selection, factory: factory)
        XCTAssertNotNil(listView.pointer)
    }

    // MARK: - CustomFilter & FilterListModel Tests

    @MainActor func test_customFilterCreation() {
        ensureAdwInit()
        let filter = CustomFilter { _ in true }
        XCTAssertNotNil(filter.pointer)
    }

    @MainActor func test_filterListModelCreation() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let filter = CustomFilter { _ in true }
        let filtered = FilterListModel(model: store, filter: filter)
        XCTAssertTrue(filtered.count == 3)
        XCTAssertNotNil(filtered.listModelPointer)
    }

    @MainActor func test_filterListModelRejectsAll() {
        ensureAdwInit()
        let store = ListStore()
        for _ in 0 ..< 5 {
            store.appendPlaceholder()
        }
        XCTAssertTrue(store.count == 5)
        let filter = CustomFilter { _ in false }
        let filtered = FilterListModel(model: store, filter: filter)
        XCTAssertTrue(filtered.count == 0)
    }

    @MainActor func test_filterListModelWithListModelPointer() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let filter = CustomFilter { _ in true }
        let filtered = FilterListModel(listModel: store.listModelPointer, filter: filter)
        XCTAssertTrue(filtered.count == 2)
    }

    @MainActor func test_customFilterChanged() {
        ensureAdwInit()
        var showAll = true
        let filter = CustomFilter { _ in showAll }
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let filtered = FilterListModel(model: store, filter: filter)
        XCTAssertTrue(filtered.count == 2)

        showAll = false
        filter.changed()
        XCTAssertTrue(filtered.count == 0)

        showAll = true
        filter.changed()
        XCTAssertTrue(filtered.count == 2)
    }

    @MainActor func test_filterListModelWithSelectionModel() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let filter = CustomFilter { _ in true }
        let filtered = FilterListModel(model: store, filter: filter)
        let selection = NoSelection(listModel: filtered.listModelPointer)
        XCTAssertNotNil(selection.selectionModelPointer)
    }

    // MARK: - CustomSorter & SortListModel Tests

    @MainActor func test_customSorterCreation() {
        ensureAdwInit()
        let sorter = CustomSorter { _, _ in 0 }
        XCTAssertNotNil(sorter.pointer)
    }

    @MainActor func test_sortListModelCreation() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let sorter = CustomSorter { _, _ in 0 }
        let sorted = SortListModel(model: store, sorter: sorter)
        XCTAssertTrue(sorted.count == 3)
        XCTAssertNotNil(sorted.listModelPointer)
    }

    @MainActor func test_sortListModelPreservesCount() {
        ensureAdwInit()
        let store = ListStore()
        for _ in 0 ..< 10 {
            store.appendPlaceholder()
        }
        let sorter = CustomSorter { _, _ in 0 }
        let sorted = SortListModel(model: store, sorter: sorter)
        XCTAssertTrue(sorted.count == store.count)
    }

    @MainActor func test_sortListModelWithListModelPointer() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let sorter = CustomSorter { _, _ in 0 }
        let sorted = SortListModel(listModel: store.listModelPointer, sorter: sorter)
        XCTAssertTrue(sorted.count == 2)
    }

    @MainActor func test_customSorterChanged() {
        ensureAdwInit()
        let sorter = CustomSorter { _, _ in 0 }
        let store = ListStore()
        store.appendPlaceholder()
        let sorted = SortListModel(model: store, sorter: sorter)
        sorter.changed()
        XCTAssertTrue(sorted.count == 1)
    }

    @MainActor func test_sortListModelWithSelectionModel() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let sorter = CustomSorter { _, _ in 0 }
        let sorted = SortListModel(model: store, sorter: sorter)
        let selection = SingleSelection(listModel: sorted.listModelPointer)
        XCTAssertNotNil(selection.selectionModelPointer)
        XCTAssertTrue(selection.selected == 0)
    }

    @MainActor func test_filterAndSortCombined() {
        ensureAdwInit()
        let store = ListStore()
        for _ in 0 ..< 5 {
            store.appendPlaceholder()
        }
        let filter = CustomFilter { _ in true }
        let filtered = FilterListModel(model: store, filter: filter)
        let sorter = CustomSorter { _, _ in 0 }
        let sorted = SortListModel(listModel: filtered.listModelPointer, sorter: sorter)
        XCTAssertTrue(sorted.count == 5)

        let selection = NoSelection(listModel: sorted.listModelPointer)
        XCTAssertNotNil(selection.selectionModelPointer)
    }

}
#endif
