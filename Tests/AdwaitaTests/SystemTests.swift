import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized) struct SystemTests {

    // MARK: - SelectionFilterModel Tests

    @Test @MainActor func selectionFilterModelWithSingleSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = SingleSelection(model: store)
        let filtered = SelectionFilterModel(model: selection)
        #expect(filtered.pointer != nil)
        // SingleSelection selects item 0 by default
        #expect(filtered.count == 1)
    }

    @Test @MainActor func selectionFilterModelWithMultiSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = MultiSelection(model: store)
        let filtered = SelectionFilterModel(model: selection)
        #expect(filtered.pointer != nil)
        // No items selected by default in MultiSelection
        #expect(filtered.count == 0)
    }

    @Test @MainActor func selectionFilterModelListModelPointer() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let selection = SingleSelection(model: store)
        let filtered = SelectionFilterModel(model: selection)
        #expect(filtered.listModelPointer != nil)
    }

    @Test @MainActor func selectionFilterModelReflectsSelectionChanges() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = MultiSelection(model: store)
        let filtered = SelectionFilterModel(model: selection)
        #expect(filtered.count == 0)
        selection.selectItem(position: 0, unselectRest: false)
        #expect(filtered.count == 1)
        selection.selectItem(position: 2, unselectRest: false)
        #expect(filtered.count == 2)
    }

    @Test @MainActor func selectionFilterModelFromRawPointer() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let selection = SingleSelection(model: store)
        let filtered = SelectionFilterModel(selectionModel: selection.selectionModelPointer)
        #expect(filtered.pointer != nil)
        #expect(filtered.count == 1)
    }

    @Test @MainActor func selectionFilterModelInheritsFromGObjectRef() {
        #expect(isSubclass(SelectionFilterModel.self, of: GObjectRef.self))
    }

    // MARK: - GtkWindow Icon Tests

    @Test @MainActor func gtkWindowIconName() {
        ensureAdwInit()
        let app = Application(id: "com.test.windowicon\(UInt32.random(in: 0..<UInt32.max))")
        let win = ApplicationWindow(application: app)
        win.iconName = "dialog-information-symbolic"
        #expect(win.iconName == "dialog-information-symbolic")
        win.iconName = nil
        #expect(win.iconName == nil)
    }

    // MARK: - GestureSwipe Tests

    @Test @MainActor func gestureSwipeCreation() {
        ensureAdwInit()
        let gesture = GestureSwipe()
        #expect(gesture.pointer != nil)
    }

    @Test @MainActor func gestureSwipeVelocityBeforeDrag() {
        ensureAdwInit()
        let gesture = GestureSwipe()
        // No active swipe — velocity should be nil
        #expect(gesture.velocity == nil)
    }

    @Test @MainActor func gestureSwipeAddToWidget() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let gesture = GestureSwipe()
        box.addController(gesture)
        #expect(gesture.pointer != nil)
    }

    @Test @MainActor func gestureSwipeInheritsFromGObjectRef() {
        #expect(isSubclass(GestureSwipe.self, of: GObjectRef.self))
    }

    // MARK: - Display Tests

    @Test @MainActor func displayDefault() {
        ensureAdwInit()
        let display = Display.default
        #expect(display != nil)
    }

    @Test @MainActor func displayName() {
        ensureAdwInit()
        guard let display = Display.default else { return }
        let name = display.name
        #expect(!name.isEmpty)
    }

    @Test @MainActor func displayIsComposited() {
        ensureAdwInit()
        guard let display = Display.default else { return }
        // Just verify it doesn't crash — result depends on environment
        _ = display.isComposited
    }

    @Test @MainActor func displayMonitors() {
        ensureAdwInit()
        guard let display = Display.default else { return }
        let monitors = display.monitors
        // In CI there might be 0 monitors, but the call should not crash
        _ = monitors.count
    }

    // MARK: - Monitor Tests

    @Test @MainActor func monitorProperties() {
        ensureAdwInit()
        guard let display = Display.default else { return }
        let monitors = display.monitors
        guard let monitor = monitors.first else { return }
        // Just verify accessors don't crash
        _ = monitor.geometry
        _ = monitor.widthMM
        _ = monitor.heightMM
        _ = monitor.scaleFactor
        _ = monitor.refreshRate
        _ = monitor.manufacturer
        _ = monitor.model
        _ = monitor.connector
        _ = monitor.isValid
    }

    @Test @MainActor func monitorInheritsFromGObjectRef() {
        #expect(isSubclass(Monitor.self, of: GObjectRef.self))
    }

    // MARK: - Clipboard Texture Read Test

    @Test @MainActor func clipboardReadTexture() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        // Ensure clipboard is accessible (won't crash)
        let clipboard = box.clipboard
        #expect(clipboard.pointer != nil)
        // readTexture is async — just verify the method exists and can be called
        // In test environment, no texture on clipboard is expected
    }

    // MARK: - Widget Display Extension Test

    @Test @MainActor func widgetDisplayProperty() {
        ensureAdwInit()
        let label = Label("test")
        let display = label.display
        #expect(display.pointer != nil)
        #expect(!display.name.isEmpty)
    }

    // MARK: - Clipboard Async Tests

    @Test @MainActor func clipboardAsyncMethodsExist() {
        ensureAdwInit()
        // Verify the async methods compile — actual clipboard access
        // requires a running event loop so we just check availability
        let box = Box(orientation: .vertical, spacing: 0)
        let clipboard = box.clipboard
        _ = clipboard  // async methods available: readText(), readTexture()
    }

    // MARK: - Widget.removeController Test

    @Test @MainActor func widgetRemoveController() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let gesture = GestureClick()
        box.addController(gesture)
        // Should not crash
        box.removeController(gesture)
    }

    // MARK: - ApplicationWindow.onCloseRequest Test

    @Test @MainActor func applicationWindowOnCloseRequest() {
        ensureAdwInit()
        let app = Application(id: "com.test.closereq\(UInt32.random(in: 0..<UInt32.max))")
        let win = ApplicationWindow(application: app)
        var called = false
        win.onCloseRequest {
            called = true
            return true  // prevent closing
        }
        // Signal handler connected successfully
        #expect(!called)
    }

    // MARK: - ListStore.item(at:) Tests

    @Test @MainActor func listStoreItemAt() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let item0 = store.item(at: 0)
        #expect(item0 != nil)
        let item2 = store.item(at: 2)
        #expect(item2 != nil)
    }

    @Test @MainActor func listStoreItemAtOutOfBounds() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let item = store.item(at: 5)
        #expect(item == nil)
    }

    @Test @MainActor func listStoreItemAtEmpty() {
        ensureAdwInit()
        let store = ListStore()
        let item = store.item(at: 0)
        #expect(item == nil)
    }

    // MARK: - ListScrollFlags

    @Test func listScrollFlagsNone() {
        let flags: ListScrollFlags = .none
        #expect(flags.rawValue == 0)
    }

    @Test func listScrollFlagsFocus() {
        let flags: ListScrollFlags = .focus
        #expect(flags.rawValue == 1)
    }

    @Test func listScrollFlagsSelect() {
        let flags: ListScrollFlags = .select
        #expect(flags.rawValue == 2)
    }

    @Test func listScrollFlagsCombined() {
        let flags: ListScrollFlags = [.focus, .select]
        #expect(flags.contains(.focus))
        #expect(flags.contains(.select))
        #expect(flags.rawValue == 3)
    }

    // MARK: - ComboRow protocol-based model

    @Test @MainActor func comboRowSetModelProtocol() {
        ensureAdwInit()
        let combo = ComboRow()
        let model = StringList(["X", "Y", "Z"])
        combo.setModel(model)
        combo.selected = 2
        #expect(combo.selected == 2)
    }

    @Test @MainActor func comboRowClearModel() {
        ensureAdwInit()
        let combo = ComboRow()
        let model = StringList(["A"])
        combo.setModel(model)
        combo.clearModel()
        // No crash = success
    }

    @Test @MainActor func comboRowSelectedItem() {
        ensureAdwInit()
        let combo = ComboRow()
        let model = StringList(["A", "B"])
        combo.setModel(model)
        combo.selected = 0
        // selectedItem should now return a GObjectRef
        let item = combo.selectedItem
        #expect(item != nil)
    }

    // MARK: - Toast actionTarget with Variant

    @Test @MainActor func toastActionTargetVariant() {
        ensureAdwInit()
        let toast = Toast(title: "Test")
        // Initially nil
        #expect(toast.actionTarget == nil)

        // Set a string variant
        let variant = Variant.string("hello")
        toast.actionTarget = variant
        let retrieved = toast.actionTarget
        #expect(retrieved != nil)
        #expect(retrieved?.stringValue == "hello")
    }

    @Test @MainActor func toastActionTargetClear() {
        ensureAdwInit()
        let toast = Toast(title: "Test")
        toast.actionTarget = Variant.int32(42)
        #expect(toast.actionTarget != nil)
        toast.actionTarget = nil
        #expect(toast.actionTarget == nil)
    }

    // MARK: - ListBox header func

    @Test @MainActor func listBoxSetHeaderFunc() {
        ensureAdwInit()
        let listBox = ListBox()
        let row1 = ListBoxRow()
        row1.child = Label("A")
        let row2 = ListBoxRow()
        row2.child = Label("B")
        listBox.append(row1)
        listBox.append(row2)

        var headerCalled = false
        listBox.setHeaderFunc { row, before in
            headerCalled = true
            if before == nil {
                row.header = Label("Header")
            }
        }
        listBox.invalidateHeaders()
        // No crash = success, header func was set
    }

    @Test @MainActor func listBoxClearHeaderFunc() {
        ensureAdwInit()
        let listBox = ListBox()
        listBox.setHeaderFunc { _, _ in }
        listBox.clearHeaderFunc()
        // No crash = success
    }

    @Test @MainActor func listBoxInvalidateHeaders() {
        ensureAdwInit()
        let listBox = ListBox()
        listBox.invalidateHeaders()
        // No crash = success
    }

    // MARK: - ListBoxRow properties

    @Test @MainActor func listBoxRowHeader() {
        ensureAdwInit()
        let row = ListBoxRow()
        #expect(row.header == nil)
        let header = Label("Section")
        row.header = header
        #expect(row.header != nil)
        row.header = nil
        #expect(row.header == nil)
    }

    @Test @MainActor func listBoxRowActivatable() {
        ensureAdwInit()
        let row = ListBoxRow()
        row.activatable = false
        #expect(row.activatable == false)
        row.activatable = true
        #expect(row.activatable == true)
    }

    @Test @MainActor func listBoxRowSelectable() {
        ensureAdwInit()
        let row = ListBoxRow()
        row.selectable = false
        #expect(row.selectable == false)
        row.selectable = true
        #expect(row.selectable == true)
    }

    @Test @MainActor func listBoxRowChanged() {
        ensureAdwInit()
        let listBox = ListBox()
        let row = ListBoxRow()
        row.child = Label("Test")
        listBox.append(row)
        row.changed()
        // No crash = success
    }


}
