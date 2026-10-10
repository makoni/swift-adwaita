// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

/// Reference-ownership regressions: objects the wrappers create or receive
/// with a full reference must be released, and handlers must not depend on a
/// Swift wrapper that may already be gone.
final class OwnershipLeakXCTests: XCTestCase {

    @MainActor func test_dragSourceTextContentReleasesReplacedProvider() {
        ensureAdwInit()
        let source = DragSource()
        source.setTextContent("first")
        let first = gtk_drag_source_get_content(source.opaquePointer)
        XCTAssertTrue(first != nil)
        guard let first else { return }
        let slot = WeakPointerSlot(watching: UnsafeMutableRawPointer(first).assumingMemoryBound(to: GObject.self))

        source.setTextContent("second")
        spinMainLoop()
        XCTAssertTrue(slot.isCleared, "replacing the content must free the previous provider")
    }

    @MainActor func test_cssProviderReleasesProviderWithWrapper() {
        ensureAdwInit()
        var slot: WeakPointerSlot?
        do {
            let css = CSSProvider()
            css.loadFromString(".x { color: red; }")
            slot = WeakPointerSlot(
                watching: UnsafeMutableRawPointer(css.provider).assumingMemoryBound(to: GObject.self))
        }
        spinMainLoop()
        XCTAssertTrue(slot?.isCleared == true, "an unused provider must be freed with its wrapper")
    }

    @MainActor func test_cssProviderOnDisplayOutlivesWrapperUntilRemoved() {
        ensureAdwInit()
        var slot: WeakPointerSlot?
        var raw: UnsafeMutablePointer<GtkCssProvider>?
        do {
            let css = CSSProvider.loadGlobal(".x { color: red; }")
            raw = css.provider
            slot = WeakPointerSlot(
                watching: UnsafeMutableRawPointer(css.provider).assumingMemoryBound(to: GObject.self))
        }
        spinMainLoop()
        XCTAssertTrue(slot?.isCleared == false, "the display keeps a provider it applies")
        gtk_style_context_remove_provider_for_display(gdk_display_get_default(), OpaquePointer(raw))
        spinMainLoop()
        XCTAssertTrue(slot?.isCleared == true, "removed from the display, nothing else holds it")
    }

    @MainActor func test_dropTargetEnterPicksActionFromTargetActions() {
        ensureAdwInit()
        // Attach the target and let the creating wrapper go out of scope, as
        // a `buildWidget()`-style function does; the handlers must not depend
        // on that wrapper.
        let widget = Label("drop here")
        var entered = false
        var raw: UnsafeMutableRawPointer?
        do {
            let target = DropTarget.forText(actions: GDK_ACTION_MOVE)
            target.onEnter { _, _ in entered = true }
            target.onMotion { _, _ in }
            widget.addController(target)
            raw = target.pointer
        }
        guard let raw else { return }
        let target = DropTarget(borrowing: raw)

        let result = emitDropTargetPositionForXCTest(target, signal: "enter")
        XCTAssertTrue(entered)
        XCTAssertTrue(result == GDK_ACTION_MOVE.rawValue, "a move-only target must prefer MOVE, not COPY")
        target.actions = GDK_ACTION_LINK
        XCTAssertTrue(emitDropTargetPositionForXCTest(target, signal: "motion") == GDK_ACTION_LINK.rawValue)
    }

    @MainActor func test_mapListModelReturnsRealObjectsAndReleasesSourceItems() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let source = g_list_model_get_item(store.listModelPointer, 0)!
        let sourceSlot = WeakPointerSlot(watching: source.assumingMemoryBound(to: GObject.self))
        g_object_unref(source)

        var mappedSlot: WeakPointerSlot?
        do {
            let mapped = MapListModel(model: store) { _ in
                GObjectRef(raw: cadw_object_new(cadw_type_object())!)
            }
            let item = g_list_model_get_item(mapped.listModelPointer, 0)
            XCTAssertTrue(item != nil)
            if let item {
                let isObject =
                    g_type_check_instance_is_a(
                        item.assumingMemoryBound(to: GTypeInstance.self), cadw_type_object()) != 0
                XCTAssertTrue(isObject, "the mapped item must be a GObject, not a Swift wrapper")
                mappedSlot = WeakPointerSlot(watching: item.assumingMemoryBound(to: GObject.self))
                g_object_unref(item)
            }
        }
        spinMainLoop()
        XCTAssertTrue(mappedSlot?.isCleared == true, "the mapped item must go with the model")
        store.remove(at: 0)
        spinMainLoop()
        XCTAssertTrue(sourceSlot.isCleared, "mapping must not leak a reference to the source item")
    }

    @MainActor func test_navigationViewFreesPoppedPage() {
        ensureAdwInit()
        let view = NavigationView()
        view.add(NavigationPage(child: Label("root"), title: "Root"))
        var slot: WeakPointerSlot?
        do {
            let page = NavigationPage(child: Label("detail"), title: "Detail")
            view.push(page)
            slot = WeakPointerSlot(watching: page.gobjectPointer)
        }
        XCTAssertTrue(slot?.isCleared == false, "the view keeps a pushed page")
        _ = view.pop()
        spinMainLoop()
        XCTAssertTrue(slot?.isCleared == true, "a popped page must be freed")
    }

    @MainActor func test_notebookFreesTabLabelsWithItsPages() {
        ensureAdwInit()
        var slots: [WeakPointerSlot] = []
        do {
            let notebook = Notebook()
            let custom = Label("custom")
            notebook.appendPage(Label("one"), label: "One")
            notebook.prependPage(Label("two"), label: "Two")
            notebook.insertPage(Label("three"), label: "Three", position: 1)
            notebook.appendPage(Label("four"), tabWidget: custom)
            XCTAssertTrue(notebook.nPages == 4)
            XCTAssertTrue(notebook.getTabLabelText(notebook.getNthPage(0)!) == "Two")
            for index in 0 ..< notebook.nPages {
                if let tab = gtk_notebook_get_tab_label(
                    notebook.opaquePointer, notebook.getNthPage(index)!.widgetPointer)
                {
                    slots.append(
                        WeakPointerSlot(watching: UnsafeMutableRawPointer(tab).assumingMemoryBound(to: GObject.self)))
                }
            }
        }
        spinMainLoop()
        XCTAssertTrue(slots.count == 4)
        let survivors = slots.filter { !$0.isCleared }.count
        XCTAssertTrue(survivors == 0, "tab labels must be freed with the notebook")
    }
}

/// Emits `GtkDropTarget::enter`/`::motion` at (1, 1) and returns the handler's
/// preferred action. `g_signal_emit_by_name` is variadic, so use `g_signal_emitv`.
@MainActor
func emitDropTargetPositionForXCTest(_ target: DropTarget, signal: String) -> UInt32 {
    let type = gtk_drop_target_get_type()
    let signalID = g_signal_lookup(signal, type)
    var params = [GValue(), GValue(), GValue()]
    g_value_init(&params[0], type)
    g_value_set_object(&params[0], target.pointer)
    g_value_init(&params[1], cadw_type_double())
    g_value_set_double(&params[1], 1)
    g_value_init(&params[2], cadw_type_double())
    g_value_set_double(&params[2], 1)
    var result = GValue()
    g_value_init(&result, gdk_drag_action_get_type())
    params.withUnsafeMutableBufferPointer { buffer in
        g_signal_emitv(buffer.baseAddress, signalID, 0, &result)
    }
    let action = g_value_get_flags(&result)
    for index in params.indices { g_value_unset(&params[index]) }
    g_value_unset(&result)
    return action
}
#endif
