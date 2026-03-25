import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized) struct ListViewTests {

    // MARK: - ListView Infrastructure

    @Test @MainActor func listStoreCreation() {
        ensureAdwInit()
        let store = ListStore()
        #expect(store.count == 0)
    }

    @Test @MainActor func listStoreAppendRemove() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        #expect(store.count == 3)

        store.remove(at: 1)
        #expect(store.count == 2)

        store.removeAll()
        #expect(store.count == 0)
    }

    @Test @MainActor func listStoreInsert() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        #expect(store.count == 2)

        store.insertPlaceholder(at: 1)
        #expect(store.count == 3)
    }

    @Test @MainActor func noSelectionCreation() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let selection = NoSelection(model: store)
        #expect(selection.selectionModelPointer != nil)
    }

    @Test @MainActor func singleSelectionCreation() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = SingleSelection(model: store)
        #expect(selection.selected == 0)  // autoselects first
        selection.canUnselect = true
        #expect(selection.canUnselect == true)
    }

    @Test @MainActor func singleSelectionAutoselect() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let selection = SingleSelection(model: store)
        selection.autoselect = false
        #expect(selection.autoselect == false)
        selection.autoselect = true
        #expect(selection.autoselect == true)
    }

    @Test @MainActor func signalListItemFactoryCreation() {
        ensureAdwInit()
        let factory = SignalListItemFactory()
        #expect(factory.pointer != nil)
    }

    @Test @MainActor func listViewCreation() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let factory = SignalListItemFactory()
        let selection = NoSelection(model: store)
        let listView = ListView(model: selection, factory: factory)
        #expect(listView.showSeparators == false)
        listView.showSeparators = true
        #expect(listView.showSeparators == true)
    }

    @Test @MainActor func listViewSingleClickActivate() {
        ensureAdwInit()
        let store = ListStore()
        let factory = SignalListItemFactory()
        let selection = NoSelection(model: store)
        let listView = ListView(model: selection, factory: factory)
        #expect(listView.singleClickActivate == false)
        listView.singleClickActivate = true
        #expect(listView.singleClickActivate == true)
    }

    @Test @MainActor func listViewWithSingleSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let factory = SignalListItemFactory()
        let selection = SingleSelection(model: store)
        let listView = ListView(model: selection, factory: factory)
        #expect(listView.pointer != nil)
        #expect(selection.selected == 0)
    }

    // MARK: - MultiSelection Tests

    @Test @MainActor func multiSelectionCreation() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = MultiSelection(model: store)
        #expect(selection.selectionModelPointer != nil)
    }

    @Test @MainActor func multiSelectionWithStringList() {
        ensureAdwInit()
        let strings = StringList(["a", "b", "c"])
        let selection = MultiSelection(model: strings)
        #expect(selection.selectionModelPointer != nil)
    }

    @Test @MainActor func multiSelectionSelectItem() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = MultiSelection(model: store)

        // Initially nothing is selected
        #expect(selection.isSelected(position: 0) == false)
        #expect(selection.isSelected(position: 1) == false)

        // Select first item
        selection.selectItem(position: 0, unselectRest: false)
        #expect(selection.isSelected(position: 0) == true)

        // Select second item without unselecting first
        selection.selectItem(position: 1, unselectRest: false)
        #expect(selection.isSelected(position: 0) == true)
        #expect(selection.isSelected(position: 1) == true)
    }

    @Test @MainActor func multiSelectionUnselectItem() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = MultiSelection(model: store)

        selection.selectItem(position: 0, unselectRest: false)
        selection.selectItem(position: 1, unselectRest: false)
        #expect(selection.isSelected(position: 0) == true)
        #expect(selection.isSelected(position: 1) == true)

        selection.unselectItem(position: 0)
        #expect(selection.isSelected(position: 0) == false)
        #expect(selection.isSelected(position: 1) == true)
    }

    @Test @MainActor func multiSelectionSelectUnselectAll() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = MultiSelection(model: store)

        selection.selectAll()
        #expect(selection.isSelected(position: 0) == true)
        #expect(selection.isSelected(position: 1) == true)
        #expect(selection.isSelected(position: 2) == true)

        selection.unselectAll()
        #expect(selection.isSelected(position: 0) == false)
        #expect(selection.isSelected(position: 1) == false)
        #expect(selection.isSelected(position: 2) == false)
    }

    @Test @MainActor func multiSelectionSelectItemUnselectRest() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = MultiSelection(model: store)

        selection.selectAll()
        #expect(selection.isSelected(position: 0) == true)
        #expect(selection.isSelected(position: 1) == true)
        #expect(selection.isSelected(position: 2) == true)

        // Select position 1 with unselectRest: true should clear others
        selection.selectItem(position: 1, unselectRest: true)
        #expect(selection.isSelected(position: 0) == false)
        #expect(selection.isSelected(position: 1) == true)
        #expect(selection.isSelected(position: 2) == false)
    }

    @Test @MainActor func listViewWithMultiSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let factory = SignalListItemFactory()
        let selection = MultiSelection(model: store)
        let listView = ListView(model: selection, factory: factory)
        #expect(listView.pointer != nil)
    }

    // MARK: - CustomFilter & FilterListModel Tests

    @Test @MainActor func customFilterCreation() {
        ensureAdwInit()
        let filter = CustomFilter { _ in true }
        #expect(filter.pointer != nil)
    }

    @Test @MainActor func filterListModelCreation() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let filter = CustomFilter { _ in true }
        let filtered = FilterListModel(model: store, filter: filter)
        #expect(filtered.count == 3)
        #expect(filtered.listModelPointer != nil)
    }

    @Test @MainActor func filterListModelRejectsAll() {
        ensureAdwInit()
        let store = ListStore()
        for _ in 0..<5 {
            store.appendPlaceholder()
        }
        #expect(store.count == 5)
        let filter = CustomFilter { _ in false }
        let filtered = FilterListModel(model: store, filter: filter)
        #expect(filtered.count == 0)
    }

    @Test @MainActor func filterListModelWithListModelPointer() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let filter = CustomFilter { _ in true }
        let filtered = FilterListModel(listModel: store.listModelPointer, filter: filter)
        #expect(filtered.count == 2)
    }

    @Test @MainActor func customFilterChanged() {
        ensureAdwInit()
        var showAll = true
        let filter = CustomFilter { _ in showAll }
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let filtered = FilterListModel(model: store, filter: filter)
        #expect(filtered.count == 2)

        showAll = false
        filter.changed()
        #expect(filtered.count == 0)

        showAll = true
        filter.changed()
        #expect(filtered.count == 2)
    }

    @Test @MainActor func filterListModelWithSelectionModel() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let filter = CustomFilter { _ in true }
        let filtered = FilterListModel(model: store, filter: filter)
        let selection = NoSelection(listModel: filtered.listModelPointer)
        #expect(selection.selectionModelPointer != nil)
    }

    // MARK: - CustomSorter & SortListModel Tests

    @Test @MainActor func customSorterCreation() {
        ensureAdwInit()
        let sorter = CustomSorter { _, _ in 0 }
        #expect(sorter.pointer != nil)
    }

    @Test @MainActor func sortListModelCreation() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let sorter = CustomSorter { _, _ in 0 }
        let sorted = SortListModel(model: store, sorter: sorter)
        #expect(sorted.count == 3)
        #expect(sorted.listModelPointer != nil)
    }

    @Test @MainActor func sortListModelPreservesCount() {
        ensureAdwInit()
        let store = ListStore()
        for _ in 0..<10 {
            store.appendPlaceholder()
        }
        let sorter = CustomSorter { _, _ in 0 }
        let sorted = SortListModel(model: store, sorter: sorter)
        #expect(sorted.count == store.count)
    }

    @Test @MainActor func sortListModelWithListModelPointer() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let sorter = CustomSorter { _, _ in 0 }
        let sorted = SortListModel(listModel: store.listModelPointer, sorter: sorter)
        #expect(sorted.count == 2)
    }

    @Test @MainActor func customSorterChanged() {
        ensureAdwInit()
        let sorter = CustomSorter { _, _ in 0 }
        let store = ListStore()
        store.appendPlaceholder()
        let sorted = SortListModel(model: store, sorter: sorter)
        sorter.changed()
        #expect(sorted.count == 1)
    }

    @Test @MainActor func sortListModelWithSelectionModel() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let sorter = CustomSorter { _, _ in 0 }
        let sorted = SortListModel(model: store, sorter: sorter)
        let selection = SingleSelection(listModel: sorted.listModelPointer)
        #expect(selection.selectionModelPointer != nil)
        #expect(selection.selected == 0)
    }

    @Test @MainActor func filterAndSortCombined() {
        ensureAdwInit()
        let store = ListStore()
        for _ in 0..<5 {
            store.appendPlaceholder()
        }
        let filter = CustomFilter { _ in true }
        let filtered = FilterListModel(model: store, filter: filter)
        let sorter = CustomSorter { _, _ in 0 }
        let sorted = SortListModel(listModel: filtered.listModelPointer, sorter: sorter)
        #expect(sorted.count == 5)

        let selection = NoSelection(listModel: sorted.listModelPointer)
        #expect(selection.selectionModelPointer != nil)
    }


}
