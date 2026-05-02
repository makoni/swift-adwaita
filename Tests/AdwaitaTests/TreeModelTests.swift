#if !os(macOS)
import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct TreeModelTests {

    // MARK: - TreeListModel Tests

    @Test @MainActor func treeListModelCreation() {
        ensureAdwInit()
        let rootStore = ListStore()
        rootStore.appendPlaceholder()
        rootStore.appendPlaceholder()

        let treeModel = TreeListModel(root: rootStore) { _ in
            nil
        }
        #expect(treeModel.listModelPointer != nil)
    }

    @Test @MainActor func treeListModelAutoexpand() {
        ensureAdwInit()
        let rootStore = ListStore()
        rootStore.appendPlaceholder()

        let treeModel = TreeListModel(root: rootStore, autoexpand: true) { _ in
            nil
        }
        #expect(treeModel.autoexpand == true)
        treeModel.autoexpand = false
        #expect(treeModel.autoexpand == false)
    }

    @Test @MainActor func treeListModelPassthrough() {
        ensureAdwInit()
        let rootStore = ListStore()
        rootStore.appendPlaceholder()

        let treeModel = TreeListModel(root: rootStore, passthrough: true) { _ in
            nil
        }
        #expect(treeModel.passthrough == true)

        let treeModel2 = TreeListModel(root: ListStore(), passthrough: false) { _ in
            nil
        }
        #expect(treeModel2.passthrough == false)
    }

    @Test @MainActor func treeListModelWithChildren() {
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
        #expect(treeModel.listModelPointer != nil)
    }

    @Test @MainActor func treeListModelRowAccess() {
        ensureAdwInit()
        let rootStore = ListStore()
        rootStore.appendPlaceholder()
        rootStore.appendPlaceholder()

        let treeModel = TreeListModel(root: rootStore, passthrough: false) { _ in
            nil
        }

        let row = treeModel.row(at: 0)
        #expect(row != nil)
        #expect(row?.depth == 0)
    }

    @Test @MainActor func treeListModelWithSelectionModel() {
        ensureAdwInit()
        let rootStore = ListStore()
        rootStore.appendPlaceholder()
        rootStore.appendPlaceholder()

        let treeModel = TreeListModel(root: rootStore) { _ in
            nil
        }

        let selection = SingleSelection(listModel: treeModel.listModelPointer)
        #expect(selection.selectionModelPointer != nil)
    }

    // MARK: - TreeExpander Tests

    @Test @MainActor func treeExpanderCreation() {
        ensureAdwInit()
        let expander = TreeExpander()
        #expect(expander.pointer != nil)
    }

    @Test @MainActor func treeExpanderChild() {
        ensureAdwInit()
        let expander = TreeExpander()
        #expect(expander.child == nil)

        let label = Label("")
        expander.child = label
        #expect(expander.child != nil)
    }

    @Test @MainActor func treeExpanderIndentForDepth() {
        ensureAdwInit()
        let expander = TreeExpander()
        #expect(expander.indentForDepth == true)
        expander.indentForDepth = false
        #expect(expander.indentForDepth == false)
    }

    @Test @MainActor func treeExpanderIndentForIcon() {
        ensureAdwInit()
        let expander = TreeExpander()
        #expect(expander.indentForIcon == true)
        expander.indentForIcon = false
        #expect(expander.indentForIcon == false)
    }

    @Test @MainActor func treeExpanderHideExpander() {
        ensureAdwInit()
        let expander = TreeExpander()
        #expect(expander.hideExpander == false)
        expander.hideExpander = true
        #expect(expander.hideExpander == true)
    }

    @Test @MainActor func treeExpanderInheritsFromWidget() {
        #expect(isAdwSubclass(TreeExpander.self, of: Widget.self))
        #expect(isAdwSubclass(TreeExpander.self, of: GObjectRef.self))
    }

    @Test @MainActor func columnViewInheritsFromWidget() {
        #expect(isAdwSubclass(ColumnView.self, of: Widget.self))
        #expect(isAdwSubclass(ColumnView.self, of: GObjectRef.self))
    }

    @Test @MainActor func columnViewColumnInheritsFromGObjectRef() {
        #expect(isAdwSubclass(ColumnViewColumn.self, of: GObjectRef.self))
    }

    @Test @MainActor func treeListModelInheritsFromGObjectRef() {
        #expect(isAdwSubclass(TreeListModel.self, of: GObjectRef.self))
    }

    @Test @MainActor func treeListRowInheritsFromGObjectRef() {
        #expect(isAdwSubclass(TreeListRow.self, of: GObjectRef.self))
    }

    // MARK: - GridView Tests

    @Test @MainActor func gridViewCreation() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let factory = SignalListItemFactory()
        let selection = NoSelection(model: store)
        let gridView = GridView(model: selection, factory: factory)
        #expect(gridView.pointer != nil)
    }

    @Test @MainActor func gridViewMinColumns() {
        ensureAdwInit()
        let store = ListStore()
        let factory = SignalListItemFactory()
        let selection = NoSelection(model: store)
        let gridView = GridView(model: selection, factory: factory)
        #expect(gridView.minColumns == 1)
        gridView.minColumns = 3
        #expect(gridView.minColumns == 3)
    }

    @Test @MainActor func gridViewMaxColumns() {
        ensureAdwInit()
        let store = ListStore()
        let factory = SignalListItemFactory()
        let selection = NoSelection(model: store)
        let gridView = GridView(model: selection, factory: factory)
        #expect(gridView.maxColumns == 7)
        gridView.maxColumns = 4
        #expect(gridView.maxColumns == 4)
    }

    @Test @MainActor func gridViewSingleClickActivate() {
        ensureAdwInit()
        let store = ListStore()
        let factory = SignalListItemFactory()
        let selection = NoSelection(model: store)
        let gridView = GridView(model: selection, factory: factory)
        #expect(gridView.singleClickActivate == false)
        gridView.singleClickActivate = true
        #expect(gridView.singleClickActivate == true)
    }

    @Test @MainActor func gridViewWithSingleSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let factory = SignalListItemFactory()
        let selection = SingleSelection(model: store)
        let gridView = GridView(model: selection, factory: factory)
        #expect(gridView.pointer != nil)
        #expect(selection.selected == 0)
    }

    @Test @MainActor func gridViewWithMultiSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let factory = SignalListItemFactory()
        let selection = MultiSelection(model: store)
        let gridView = GridView(model: selection, factory: factory)
        #expect(gridView.pointer != nil)
    }

    @Test @MainActor func gridViewInheritsFromWidget() {
        #expect(isAdwSubclass(GridView.self, of: Widget.self))
        #expect(isAdwSubclass(GridView.self, of: GObjectRef.self))
    }

    // MARK: - MapListModel Tests

    @Test @MainActor func mapListModelCreation() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()

        let mapped = MapListModel(model: store) { _ in
            GObjectRef(raw: cadw_object_new(cadw_type_object())!)
        }
        #expect(mapped.pointer != nil)
        #expect(mapped.count == 3)
    }

    @Test @MainActor func mapListModelEmptyStore() {
        ensureAdwInit()
        let store = ListStore()
        let mapped = MapListModel(model: store) { _ in
            GObjectRef(raw: cadw_object_new(cadw_type_object())!)
        }
        #expect(mapped.count == 0)
    }

    @Test @MainActor func mapListModelListModelPointer() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let mapped = MapListModel(model: store) { _ in
            GObjectRef(raw: cadw_object_new(cadw_type_object())!)
        }
        #expect(mapped.listModelPointer != nil)
    }

    @Test @MainActor func mapListModelFromListModelPointer() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let mapped = MapListModel(listModel: store.listModelPointer) { _ in
            GObjectRef(raw: cadw_object_new(cadw_type_object())!)
        }
        #expect(mapped.count == 2)
    }

    @Test @MainActor func mapListModelReflectsStoreChanges() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let mapped = MapListModel(model: store) { _ in
            GObjectRef(raw: cadw_object_new(cadw_type_object())!)
        }
        #expect(mapped.count == 1)
        store.appendPlaceholder()
        #expect(mapped.count == 2)
        store.remove(at: 0)
        #expect(mapped.count == 1)
    }

    @Test @MainActor func mapListModelWithSelectionModel() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let mapped = MapListModel(model: store) { _ in
            GObjectRef(raw: cadw_object_new(cadw_type_object())!)
        }
        let selection = NoSelection(listModel: mapped.listModelPointer)
        #expect(selection.pointer != nil)
    }

    @Test @MainActor func mapListModelInheritsFromGObjectRef() {
        #expect(isAdwSubclass(MapListModel.self, of: GObjectRef.self))
    }

    // MARK: - FlattenListModel Tests

    @Test @MainActor func flattenListModelCreation() {
        ensureAdwInit()
        let store = ListStore()
        let flattened = FlattenListModel(model: store)
        #expect(flattened.pointer != nil)
    }

    @Test @MainActor func flattenListModelEmptyStore() {
        ensureAdwInit()
        let store = ListStore()
        let flattened = FlattenListModel(model: store)
        #expect(flattened.count == 0)
    }

    @Test @MainActor func flattenListModelListModelPointer() {
        ensureAdwInit()
        let store = ListStore()
        let flattened = FlattenListModel(model: store)
        #expect(flattened.listModelPointer != nil)
    }

    @Test @MainActor func flattenListModelFromOpaquePointer() {
        ensureAdwInit()
        let store = ListStore()
        let flattened = FlattenListModel(listModel: store.listModelPointer)
        #expect(flattened.pointer != nil)
        #expect(flattened.count == 0)
    }

    @Test @MainActor func flattenListModelWithSelectionModel() {
        ensureAdwInit()
        let store = ListStore()
        let flattened = FlattenListModel(model: store)
        let selection = NoSelection(listModel: flattened.listModelPointer)
        #expect(selection.pointer != nil)
    }

    @Test @MainActor func flattenListModelInheritsFromGObjectRef() {
        #expect(isAdwSubclass(FlattenListModel.self, of: GObjectRef.self))
    }

}
#endif
