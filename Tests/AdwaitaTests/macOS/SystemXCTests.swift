#if os(macOS)
import Foundation
import XCTest
@testable import Adwaita
import CAdwaita

final class SystemXCTests: XCTestCase {

    // MARK: - SelectionFilterModel Tests

    @MainActor func test_selectionFilterModelWithSingleSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = SingleSelection(model: store)
        let filtered = SelectionFilterModel(model: selection)
        XCTAssertNotNil(filtered.pointer)
        // SingleSelection selects item 0 by default
        XCTAssertTrue(filtered.count == 1)
    }

    @MainActor func test_selectionFilterModelWithMultiSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = MultiSelection(model: store)
        let filtered = SelectionFilterModel(model: selection)
        XCTAssertNotNil(filtered.pointer)
        // No items selected by default in MultiSelection
        XCTAssertTrue(filtered.count == 0)
    }

    @MainActor func test_selectionFilterModelListModelPointer() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let selection = SingleSelection(model: store)
        let filtered = SelectionFilterModel(model: selection)
        XCTAssertNotNil(filtered.listModelPointer)
    }

    @MainActor func test_selectionFilterModelReflectsSelectionChanges() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = MultiSelection(model: store)
        let filtered = SelectionFilterModel(model: selection)
        XCTAssertTrue(filtered.count == 0)
        selection.selectItem(position: 0, unselectRest: false)
        XCTAssertTrue(filtered.count == 1)
        selection.selectItem(position: 2, unselectRest: false)
        XCTAssertTrue(filtered.count == 2)
    }

    @MainActor func test_selectionFilterModelFromRawPointer() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let selection = SingleSelection(model: store)
        let filtered = SelectionFilterModel(selectionModel: selection.selectionModelPointer)
        XCTAssertNotNil(filtered.pointer)
        XCTAssertTrue(filtered.count == 1)
    }

    @MainActor func test_selectionFilterModelInheritsFromGObjectRef() {
        XCTAssertTrue(isAdwSubclass(SelectionFilterModel.self, of: GObjectRef.self))
    }

    // MARK: - GtkWindow Icon Tests

    @MainActor func test_gtkWindowIconName() throws {
        ensureAdwInit()
        let app = Application(id: "com.test.windowicon\(UInt32.random(in: 0 ..< UInt32.max))")
        try app.register()
        let win = ApplicationWindow(application: app)
        win.iconName = "dialog-information-symbolic"
        XCTAssertTrue(win.iconName == "dialog-information-symbolic")
        win.iconName = nil
        XCTAssertNil(win.iconName)
    }

    // MARK: - GestureSwipe Tests

    @MainActor func test_gestureSwipeCreation() {
        ensureAdwInit()
        let gesture = GestureSwipe()
        XCTAssertNotNil(gesture.pointer)
    }

    @MainActor func test_gestureSwipeVelocityBeforeDrag() {
        ensureAdwInit()
        let gesture = GestureSwipe()
        // No active swipe — velocity should be nil
        XCTAssertNil(gesture.velocity)
    }

    @MainActor func test_gestureSwipeAddToWidget() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let gesture = GestureSwipe()
        box.addController(gesture)
        XCTAssertNotNil(gesture.pointer)
    }

    @MainActor func test_gestureSwipeInheritsFromGObjectRef() {
        XCTAssertTrue(isAdwSubclass(GestureSwipe.self, of: GObjectRef.self))
    }

    // MARK: - Display Tests

    @MainActor func test_displayDefault() {
        ensureAdwInit()
        let display = Display.default
        XCTAssertNotNil(display)
    }

    @MainActor func test_displayName() {
        ensureAdwInit()
        guard let display = Display.default else { return }
        // GTK4's Quartz backend does not expose a display identifier; on
        // X11/Wayland this would be ":0" or similar. Just verify the getter
        // does not crash.
        _ = display.name
    }

    @MainActor func test_displayIsComposited() {
        ensureAdwInit()
        guard let display = Display.default else { return }
        // Just verify it doesn't crash — result depends on environment
        _ = display.isComposited
    }

    @MainActor func test_displayMonitors() {
        ensureAdwInit()
        guard let display = Display.default else { return }
        let monitors = display.monitors
        // In CI there might be 0 monitors, but the call should not crash
        _ = monitors.count
    }

    // MARK: - Monitor Tests

    @MainActor func test_monitorProperties() {
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

    @MainActor func test_monitorInheritsFromGObjectRef() {
        XCTAssertTrue(isAdwSubclass(Monitor.self, of: GObjectRef.self))
    }

    // MARK: - Clipboard Texture Read Test

    @MainActor func test_clipboardReadTexture() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        // Ensure clipboard is accessible (won't crash)
        let clipboard = box.clipboard
        XCTAssertNotNil(clipboard.pointer)
        // readTexture is async — just verify the method exists and can be called
        // In test environment, no texture on clipboard is expected
    }

    // MARK: - Widget Display Extension Test

    @MainActor func test_widgetDisplayProperty() {
        ensureAdwInit()
        let label = Label("test")
        let display = label.display
        XCTAssertNotNil(display.pointer)
        // See test_displayName: Quartz does not expose a display identifier.
        _ = display.name
    }

    // MARK: - Clipboard Async Tests

    @MainActor func test_clipboardAsyncMethodsExist() {
        ensureAdwInit()
        // Verify the async methods compile — actual clipboard access
        // requires a running event loop so we just check availability
        let box = Box(orientation: .vertical, spacing: 0)
        let clipboard = box.clipboard
        _ = clipboard // async methods available: readText(), readTexture()
    }

    // MARK: - Paste-clipboard hook

    @MainActor func test_widgetExposesPasteClipboardHookAndStopEmission() {
        ensureAdwInit()
        // Both helpers exist on Widget so a `paste-clipboard` signal
        // handler on a TextView / SourceView can synchronously decide
        // whether to short-circuit GTK's default text-paste behaviour
        // and run a custom (e.g. image) paste path instead.
        let view = TextView()
        let connection: SignalConnection = view.onPasteClipboard {}
        connection.disconnect()

        // No-op when called outside an active signal emission, but the
        // method must exist on every Widget so the handler can call
        // it without dropping into raw GObject C.
        view.stopSignalEmission(named: "paste-clipboard")
    }

    // MARK: - Texture PNG Encoding

    @MainActor func test_textureEncodesToPNGData() {
        ensureAdwInit()
        // Build a tiny RGBA texture and round-trip it through the new
        // PNG-encoder. The output should be non-empty and start with
        // the PNG signature so callers can hand the bytes off to any
        // PNG-aware decoder (e.g. saving paste-from-clipboard images
        // to disk).
        let pixels: [UInt8] = [
            255, 0, 0, 255, /* */ 0, 255, 0, 255,
            0, 0, 255, 255, /* */ 255, 255, 0, 255
        ]
        let texture = Texture(rgbaData: pixels, width: 2, height: 2)

        guard let data = texture.encodedPNGData() else {
            XCTFail("Expected encodedPNGData to return Data")
            return
        }

        XCTAssertTrue(data.count > 8)
        let signature: [UInt8] = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]
        XCTAssertTrue(Array(data.prefix(8)) == signature)
    }

    // MARK: - Clipboard File List Probe

    @MainActor func test_clipboardContainsFilesIsFalseForTextOnlyClipboard() {
        ensureAdwInit()
        // Symmetric to `containsImage`: a synchronous probe the paste
        // handler can use to decide whether to intercept the
        // `paste-clipboard` signal for file-manager copies. With only
        // text on the clipboard the probe must be false so the
        // default text-paste path runs unchanged.
        let box = Box(orientation: .vertical, spacing: 0)
        let clipboard = box.clipboard
        clipboard.setText("just text — not a file list")
        XCTAssertTrue(clipboard.containsFiles == false)
    }

    @MainActor func test_clipboardReadFilesMethodIsAvailable() {
        ensureAdwInit()
        // Setting a file list on the clipboard requires `gdk_clipboard_set_value`
        // with `GDK_TYPE_FILE_LIST`, which isn't exposed yet. The
        // round-trip behaviour is exercised manually (copying a file
        // in Nautilus and pasting); here we just pin the read method
        // signature so callers can rely on its shape.
        let box = Box(orientation: .vertical, spacing: 0)
        let clipboard = box.clipboard
        let _: (Clipboard, @escaping @MainActor ([URL]) -> Void) -> Void = { clipboard, completion in
            clipboard.readFiles(completion: completion)
        }
        _ = clipboard
    }

    // MARK: - Clipboard Image Probe

    @MainActor func test_clipboardContainsImageReflectsLastSetContent() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let clipboard = box.clipboard

        // Plain text on the clipboard must NOT register as an image.
        clipboard.setText("just text, no image")
        XCTAssertTrue(clipboard.containsImage == false)

        // Setting a Texture flips the probe to true so the paste
        // handler can synchronously decide whether to intercept the
        // signal before kicking off an async texture read.
        let pixels: [UInt8] = [255, 0, 0, 255]
        let texture = Texture(rgbaData: pixels, width: 1, height: 1)
        clipboard.setTexture(texture)
        XCTAssertTrue(clipboard.containsImage == true)
    }

    // MARK: - Widget.removeController Test

    @MainActor func test_widgetRemoveController() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let gesture = GestureClick()
        box.addController(gesture)
        // Should not crash
        box.removeController(gesture)
    }

    // MARK: - ApplicationWindow.onCloseRequest Test

    @MainActor func test_applicationWindowOnCloseRequest() throws {
        ensureAdwInit()
        let app = Application(id: "com.test.closereq\(UInt32.random(in: 0 ..< UInt32.max))")
        try app.register()
        let win = ApplicationWindow(application: app)
        var called = false
        win.onCloseRequest {
            called = true
            return true // prevent closing
        }
        // Signal handler connected successfully
        XCTAssertFalse(called)
    }

    // MARK: - ListStore.item(at:) Tests

    @MainActor func test_listStoreItemAt() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let item0 = store.item(at: 0)
        XCTAssertNotNil(item0)
        let item2 = store.item(at: 2)
        XCTAssertNotNil(item2)
    }

    @MainActor func test_listStoreItemAtOutOfBounds() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let item = store.item(at: 5)
        XCTAssertNil(item)
    }

    @MainActor func test_listStoreItemAtEmpty() {
        ensureAdwInit()
        let store = ListStore()
        let item = store.item(at: 0)
        XCTAssertNil(item)
    }

    // MARK: - ListScrollFlags

    func test_listScrollFlagsNone() {
        let flags: ListScrollFlags = .none
        XCTAssertTrue(flags.rawValue == 0)
    }

    func test_listScrollFlagsFocus() {
        let flags: ListScrollFlags = .focus
        XCTAssertTrue(flags.rawValue == 1)
    }

    func test_listScrollFlagsSelect() {
        let flags: ListScrollFlags = .select
        XCTAssertTrue(flags.rawValue == 2)
    }

    func test_listScrollFlagsCombined() {
        let flags: ListScrollFlags = [.focus, .select]
        XCTAssertTrue(flags.contains(.focus))
        XCTAssertTrue(flags.contains(.select))
        XCTAssertTrue(flags.rawValue == 3)
    }

    // MARK: - ComboRow protocol-based model

    @MainActor func test_comboRowSetModelProtocol() {
        ensureAdwInit()
        let combo = ComboRow()
        let model = StringList(["X", "Y", "Z"])
        combo.setModel(model)
        combo.selected = 2
        XCTAssertTrue(combo.selected == 2)
    }

    @MainActor func test_comboRowClearModel() {
        ensureAdwInit()
        let combo = ComboRow()
        let model = StringList(["A"])
        combo.setModel(model)
        combo.clearModel()
        // No crash = success
    }

    @MainActor func test_comboRowSelectedItem() {
        ensureAdwInit()
        let combo = ComboRow()
        let model = StringList(["A", "B"])
        combo.setModel(model)
        combo.selected = 0
        // selectedItem should now return a GObjectRef
        let item = combo.selectedItem
        XCTAssertNotNil(item)
    }

    // MARK: - Toast actionTarget with Variant

    @MainActor func test_toastActionTargetVariant() {
        ensureAdwInit()
        let toast = Toast(title: "Test")
        // Initially nil
        XCTAssertNil(toast.actionTarget)

        // Set a string variant
        let variant = Variant.string("hello")
        toast.actionTarget = variant
        let retrieved = toast.actionTarget
        XCTAssertNotNil(retrieved)
        XCTAssertTrue(retrieved?.stringValue == "hello")
    }

    @MainActor func test_toastActionTargetClear() {
        ensureAdwInit()
        let toast = Toast(title: "Test")
        toast.actionTarget = Variant.int32(42)
        XCTAssertNotNil(toast.actionTarget)
        toast.actionTarget = nil
        XCTAssertNil(toast.actionTarget)
    }

    // MARK: - ListBox header func

    @MainActor func test_listBoxSetHeaderFunc() {
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

    @MainActor func test_listBoxClearHeaderFunc() {
        ensureAdwInit()
        let listBox = ListBox()
        listBox.setHeaderFunc { _, _ in }
        listBox.clearHeaderFunc()
        // No crash = success
    }

    @MainActor func test_listBoxInvalidateHeaders() {
        ensureAdwInit()
        let listBox = ListBox()
        listBox.invalidateHeaders()
        // No crash = success
    }

    // MARK: - ListBoxRow properties

    @MainActor func test_listBoxRowHeader() {
        ensureAdwInit()
        let row = ListBoxRow()
        XCTAssertNil(row.header)
        let header = Label("Section")
        row.header = header
        XCTAssertNotNil(row.header)
        row.header = nil
        XCTAssertNil(row.header)
    }

    @MainActor func test_listBoxRowActivatable() {
        ensureAdwInit()
        let row = ListBoxRow()
        row.activatable = false
        XCTAssertTrue(row.activatable == false)
        row.activatable = true
        XCTAssertTrue(row.activatable == true)
    }

    @MainActor func test_listBoxRowSelectable() {
        ensureAdwInit()
        let row = ListBoxRow()
        row.selectable = false
        XCTAssertTrue(row.selectable == false)
        row.selectable = true
        XCTAssertTrue(row.selectable == true)
    }

    @MainActor func test_listBoxRowChanged() {
        ensureAdwInit()
        let listBox = ListBox()
        let row = ListBoxRow()
        row.child = Label("Test")
        listBox.append(row)
        row.changed()
        // No crash = success
    }

}
#endif
