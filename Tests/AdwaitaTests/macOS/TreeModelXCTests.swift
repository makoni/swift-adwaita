#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class TreeModelXCTests: XCTestCase {

    // MARK: - TreeListModel Tests

    @MainActor func test_treeListModelCreation() {
        ensureAdwInit()
        let rootStore = ListStore()
        rootStore.appendPlaceholder()
        rootStore.appendPlaceholder()

        let treeModel = TreeListModel(root: rootStore) { _ in
            nil
        }
        XCTAssertNotNil(treeModel.listModelPointer)
    }

    @MainActor func test_treeListModelAutoexpand() {
        ensureAdwInit()
        let rootStore = ListStore()
        rootStore.appendPlaceholder()

        let treeModel = TreeListModel(root: rootStore, autoexpand: true) { _ in
            nil
        }
        XCTAssertTrue(treeModel.autoexpand == true)
        treeModel.autoexpand = false
        XCTAssertTrue(treeModel.autoexpand == false)
    }

    @MainActor func test_treeListModelPassthrough() {
        ensureAdwInit()
        let rootStore = ListStore()
        rootStore.appendPlaceholder()

        let treeModel = TreeListModel(root: rootStore, passthrough: true) { _ in
            nil
        }
        XCTAssertTrue(treeModel.passthrough == true)

        let treeModel2 = TreeListModel(root: ListStore(), passthrough: false) { _ in
            nil
        }
        XCTAssertTrue(treeModel2.passthrough == false)
    }

    @MainActor func test_treeListModelWithChildren() {
        ensureAdwInit()
        let rootStore = ListStore()
        rootStore.appendPlaceholder()

        // Use autoexpand: false to avoid infinite recursion when the
        // callback always returns children.
        let treeModel = TreeListModel(root: rootStore, autoexpand: false) { _ in
            let childStore = ListStore()
            childStore.appendPlaceholder()
            return childStore
        }
        XCTAssertNotNil(treeModel.listModelPointer)
    }

    @MainActor func test_treeListModelRowAccess() {
        ensureAdwInit()
        let rootStore = ListStore()
        rootStore.appendPlaceholder()
        rootStore.appendPlaceholder()

        let treeModel = TreeListModel(root: rootStore, passthrough: false) { _ in
            nil
        }

        let row = treeModel.row(at: 0)
        XCTAssertNotNil(row)
        XCTAssertTrue(row?.depth == 0)
    }

    @MainActor func test_treeListModelWithSelectionModel() {
        ensureAdwInit()
        let rootStore = ListStore()
        rootStore.appendPlaceholder()
        rootStore.appendPlaceholder()

        let treeModel = TreeListModel(root: rootStore) { _ in
            nil
        }

        let selection = SingleSelection(listModel: treeModel.listModelPointer)
        XCTAssertNotNil(selection.selectionModelPointer)
    }

    // MARK: - TreeExpander Tests

    @MainActor func test_treeExpanderCreation() {
        ensureAdwInit()
        let expander = TreeExpander()
        XCTAssertNotNil(expander.pointer)
    }

    @MainActor func test_treeExpanderChild() {
        ensureAdwInit()
        let expander = TreeExpander()
        XCTAssertNil(expander.child)

        let label = Label("")
        expander.child = label
        XCTAssertNotNil(expander.child)
    }

    @MainActor func test_treeExpanderIndentForDepth() {
        ensureAdwInit()
        let expander = TreeExpander()
        XCTAssertTrue(expander.indentForDepth == true)
        expander.indentForDepth = false
        XCTAssertTrue(expander.indentForDepth == false)
    }

    @MainActor func test_treeExpanderIndentForIcon() {
        ensureAdwInit()
        let expander = TreeExpander()
        XCTAssertTrue(expander.indentForIcon == true)
        expander.indentForIcon = false
        XCTAssertTrue(expander.indentForIcon == false)
    }

    @MainActor func test_treeExpanderHideExpander() {
        ensureAdwInit()
        let expander = TreeExpander()
        XCTAssertTrue(expander.hideExpander == false)
        expander.hideExpander = true
        XCTAssertTrue(expander.hideExpander == true)
    }

    @MainActor func test_treeExpanderInheritsFromWidget() {
        XCTAssertTrue(isAdwSubclass(TreeExpander.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(TreeExpander.self, of: GObjectRef.self))
    }

    @MainActor func test_columnViewInheritsFromWidget() {
        XCTAssertTrue(isAdwSubclass(ColumnView.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(ColumnView.self, of: GObjectRef.self))
    }

    @MainActor func test_columnViewColumnInheritsFromGObjectRef() {
        XCTAssertTrue(isAdwSubclass(ColumnViewColumn.self, of: GObjectRef.self))
    }

    @MainActor func test_treeListModelInheritsFromGObjectRef() {
        XCTAssertTrue(isAdwSubclass(TreeListModel.self, of: GObjectRef.self))
    }

    @MainActor func test_treeListRowInheritsFromGObjectRef() {
        XCTAssertTrue(isAdwSubclass(TreeListRow.self, of: GObjectRef.self))
    }

    // MARK: - GridView Tests

    @MainActor func test_gridViewCreation() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let factory = SignalListItemFactory()
        let selection = NoSelection(model: store)
        let gridView = GridView(model: selection, factory: factory)
        XCTAssertNotNil(gridView.pointer)
    }

    @MainActor func test_gridViewMinColumns() {
        ensureAdwInit()
        let store = ListStore()
        let factory = SignalListItemFactory()
        let selection = NoSelection(model: store)
        let gridView = GridView(model: selection, factory: factory)
        XCTAssertTrue(gridView.minColumns == 1)
        gridView.minColumns = 3
        XCTAssertTrue(gridView.minColumns == 3)
    }

    @MainActor func test_gridViewMaxColumns() {
        ensureAdwInit()
        let store = ListStore()
        let factory = SignalListItemFactory()
        let selection = NoSelection(model: store)
        let gridView = GridView(model: selection, factory: factory)
        XCTAssertTrue(gridView.maxColumns == 7)
        gridView.maxColumns = 4
        XCTAssertTrue(gridView.maxColumns == 4)
    }

    @MainActor func test_gridViewSingleClickActivate() {
        ensureAdwInit()
        let store = ListStore()
        let factory = SignalListItemFactory()
        let selection = NoSelection(model: store)
        let gridView = GridView(model: selection, factory: factory)
        XCTAssertTrue(gridView.singleClickActivate == false)
        gridView.singleClickActivate = true
        XCTAssertTrue(gridView.singleClickActivate == true)
    }

    @MainActor func test_gridViewWithSingleSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let factory = SignalListItemFactory()
        let selection = SingleSelection(model: store)
        let gridView = GridView(model: selection, factory: factory)
        XCTAssertNotNil(gridView.pointer)
        XCTAssertTrue(selection.selected == 0)
    }

    @MainActor func test_gridViewWithMultiSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let factory = SignalListItemFactory()
        let selection = MultiSelection(model: store)
        let gridView = GridView(model: selection, factory: factory)
        XCTAssertNotNil(gridView.pointer)
    }

    @MainActor func test_gridViewInheritsFromWidget() {
        XCTAssertTrue(isAdwSubclass(GridView.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(GridView.self, of: GObjectRef.self))
    }

    // MARK: - MapListModel Tests

    @MainActor func test_mapListModelCreation() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()

        let mapped = MapListModel(model: store) { _ in
            GObjectRef(raw: cadw_object_new(cadw_type_object())!)
        }
        XCTAssertNotNil(mapped.pointer)
        XCTAssertTrue(mapped.count == 3)
    }

    @MainActor func test_mapListModelEmptyStore() {
        ensureAdwInit()
        let store = ListStore()
        let mapped = MapListModel(model: store) { _ in
            GObjectRef(raw: cadw_object_new(cadw_type_object())!)
        }
        XCTAssertTrue(mapped.count == 0)
    }

    @MainActor func test_mapListModelListModelPointer() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let mapped = MapListModel(model: store) { _ in
            GObjectRef(raw: cadw_object_new(cadw_type_object())!)
        }
        XCTAssertNotNil(mapped.listModelPointer)
    }

    @MainActor func test_mapListModelFromListModelPointer() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let mapped = MapListModel(listModel: store.listModelPointer) { _ in
            GObjectRef(raw: cadw_object_new(cadw_type_object())!)
        }
        XCTAssertTrue(mapped.count == 2)
    }

    @MainActor func test_mapListModelReflectsStoreChanges() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let mapped = MapListModel(model: store) { _ in
            GObjectRef(raw: cadw_object_new(cadw_type_object())!)
        }
        XCTAssertTrue(mapped.count == 1)
        store.appendPlaceholder()
        XCTAssertTrue(mapped.count == 2)
        store.remove(at: 0)
        XCTAssertTrue(mapped.count == 1)
    }

    @MainActor func test_mapListModelWithSelectionModel() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let mapped = MapListModel(model: store) { _ in
            GObjectRef(raw: cadw_object_new(cadw_type_object())!)
        }
        let selection = NoSelection(listModel: mapped.listModelPointer)
        XCTAssertNotNil(selection.pointer)
    }

    @MainActor func test_mapListModelInheritsFromGObjectRef() {
        XCTAssertTrue(isAdwSubclass(MapListModel.self, of: GObjectRef.self))
    }

    // MARK: - FlattenListModel Tests

    @MainActor func test_flattenListModelCreation() {
        ensureAdwInit()
        let store = ListStore()
        let flattened = FlattenListModel(model: store)
        XCTAssertNotNil(flattened.pointer)
    }

    @MainActor func test_flattenListModelEmptyStore() {
        ensureAdwInit()
        let store = ListStore()
        let flattened = FlattenListModel(model: store)
        XCTAssertTrue(flattened.count == 0)
    }

    @MainActor func test_flattenListModelListModelPointer() {
        ensureAdwInit()
        let store = ListStore()
        let flattened = FlattenListModel(model: store)
        XCTAssertNotNil(flattened.listModelPointer)
    }

    @MainActor func test_flattenListModelFromOpaquePointer() {
        ensureAdwInit()
        let store = ListStore()
        let flattened = FlattenListModel(listModel: store.listModelPointer)
        XCTAssertNotNil(flattened.pointer)
        XCTAssertTrue(flattened.count == 0)
    }

    @MainActor func test_flattenListModelWithSelectionModel() {
        ensureAdwInit()
        let store = ListStore()
        let flattened = FlattenListModel(model: store)
        let selection = NoSelection(listModel: flattened.listModelPointer)
        XCTAssertNotNil(selection.pointer)
    }

    @MainActor func test_flattenListModelInheritsFromGObjectRef() {
        XCTAssertTrue(isAdwSubclass(FlattenListModel.self, of: GObjectRef.self))
    }

}
#endif
