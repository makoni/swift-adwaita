// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Testing
@testable import Adwaita
import CAdwaita

/// GTK owns toplevel windows: `gtk_window_new`, `gtk_application_window_new`,
/// `adw_window_new` and `adw_application_window_new` are
/// `transfer-ownership="none"` in the GIR, and GTK keeps every window in its
/// toplevel list until `gtk_window_destroy`. These tests check that the Swift
/// wrappers do not steal the reference GTK's toplevel list holds: a window
/// must survive the release of its wrapper while it stays in the list, and
/// must only finalize once it is destroyed.
///
/// Toplevel-list membership is asserted directly via
/// `gtk_window_get_toplevels` (marked `GDK_AVAILABLE_IN_ALL` in
/// `gtkwindow.h`, so available since GTK 4.0). The use-after-free half is
/// covered by the "walk" tests: they toggle the default text direction (which
/// forces GTK to walk every toplevel) while a released wrapper's window is
/// still in the list, and assert that no CRITICALs fire.
@Suite(.serialized)
struct ToplevelWindowOwnershipTests {

    // MARK: - ApplicationWindow

    @Test("releasing the ApplicationWindow wrapper keeps the window alive until destroy") @MainActor
    func applicationWindowReleasedBeforeDestroyStaysAliveUntilDestroyed() throws {
        ensureAdwInit()
        let app = Application(id: "com.test.toplevelwindowownership.appw.t\(UInt32.random(in: 0 ..< UInt32.max))")
        try app.register()
        defer { app.quit() }
        var slot: WeakPointerSlot?
        var raw: UnsafeMutableRawPointer?
        do {
            let window = ApplicationWindow(application: app)
            raw = window.pointer
            slot = WeakPointerSlot(watching: window.gobjectPointer)
        }
        spinMainLoop()
        #expect(
            slot?.isCleared == false,
            "the toplevel list still references the window, so releasing the wrapper must not finalize it")
        #expect(toplevelListContains(raw), "a live window must stay in the toplevel list")
        if let raw {
            gtk_window_destroy(raw.assumingMemoryBound(to: CAdwaita.GtkWindow.self))
        }
        spinMainLoop()
        #expect(slot?.isCleared == true, "destroying the window must finalize it")
        #expect(toplevelListContains(raw) == false, "a destroyed window must leave the toplevel list")
    }

    @Test("walking the toplevels after releasing the ApplicationWindow wrapper fires no criticals") @MainActor
    func applicationWindowToplevelWalkAfterReleaseFiresNoCriticals() throws {
        ensureAdwInit()
        let app = Application(id: "com.test.toplevelwindowownership.appw2.t\(UInt32.random(in: 0 ..< UInt32.max))")
        try app.register()
        defer { app.quit() }
        var slot: WeakPointerSlot?
        var raw: UnsafeMutableRawPointer?
        do {
            let window = ApplicationWindow(application: app)
            raw = window.pointer
            slot = WeakPointerSlot(watching: window.gobjectPointer)
        }
        spinMainLoop()
        let criticals = CriticalCounter()
        defer { criticals.uninstall() }
        gtk_widget_set_default_direction(.rtl)
        gtk_widget_set_default_direction(.ltr)
        spinMainLoop()
        #expect(
            criticals.count == 0,
            "walking a toplevel list that still contains a released window must not touch freed memory")
        if let raw {
            gtk_window_destroy(raw.assumingMemoryBound(to: CAdwaita.GtkWindow.self))
        }
        spinMainLoop()
        #expect(slot?.isCleared == true, "destroying the window must finalize it once the wrapper is gone")
    }

    @Test("destroying the ApplicationWindow while its wrapper is alive leaves no dangling reference") @MainActor
    func applicationWindowDestroyedWhileWrapperAliveLeavesNoDanglingReference() throws {
        ensureAdwInit()
        let app = Application(id: "com.test.toplevelwindowownership.appw3.t\(UInt32.random(in: 0 ..< UInt32.max))")
        try app.register()
        defer { app.quit() }
        var slot: WeakPointerSlot?
        var raw: UnsafeMutableRawPointer?
        var window: ApplicationWindow?
        do {
            window = ApplicationWindow(application: app)
            raw = window!.pointer
            slot = WeakPointerSlot(watching: window!.gobjectPointer)
        }
        spinMainLoop()
        let criticals = CriticalCounter()
        defer { criticals.uninstall() }
        // Destroy the window while the wrapper is still alive: GTK drops the
        // toplevel-list reference, but the wrapper's own reference keeps the
        // window alive until the wrapper is dropped too.
        if let raw {
            gtk_window_destroy(raw.assumingMemoryBound(to: CAdwaita.GtkWindow.self))
        }
        spinMainLoop()
        #expect(
            slot?.isCleared == false,
            "the wrapper's own reference must keep a destroyed window alive until the wrapper goes too")
        // Now drop the wrapper: once both GTK and Swift have let go the window
        // finalizes, and the wrapper's deinit must not touch freed memory.
        window = nil
        spinMainLoop()
        #expect(
            slot?.isCleared == true,
            "once both GTK and the wrapper let go the window must finalize")
        #expect(
            criticals.count == 0,
            "dropping a wrapper whose window GTK already destroyed must fire no criticals")
    }

    // MARK: - Window

    @Test("releasing the Window wrapper keeps the window alive until destroy") @MainActor
    func windowReleasedBeforeDestroyStaysAliveUntilDestroyed() {
        ensureAdwInit()
        var slot: WeakPointerSlot?
        var raw: UnsafeMutableRawPointer?
        do {
            let window = Window()
            raw = window.pointer
            slot = WeakPointerSlot(watching: window.gobjectPointer)
        }
        spinMainLoop()
        #expect(
            slot?.isCleared == false,
            "the toplevel list still references the window, so releasing the wrapper must not finalize it")
        #expect(toplevelListContains(raw), "a live window must stay in the toplevel list")
        if let raw {
            gtk_window_destroy(raw.assumingMemoryBound(to: CAdwaita.GtkWindow.self))
        }
        spinMainLoop()
        #expect(slot?.isCleared == true, "destroying the window must finalize it")
        #expect(toplevelListContains(raw) == false, "a destroyed window must leave the toplevel list")
    }

    @Test("walking the toplevels after releasing the Window wrapper fires no criticals") @MainActor
    func windowToplevelWalkAfterReleaseFiresNoCriticals() {
        ensureAdwInit()
        var slot: WeakPointerSlot?
        var raw: UnsafeMutableRawPointer?
        do {
            let window = Window()
            raw = window.pointer
            slot = WeakPointerSlot(watching: window.gobjectPointer)
        }
        spinMainLoop()
        let criticals = CriticalCounter()
        defer { criticals.uninstall() }
        gtk_widget_set_default_direction(.rtl)
        gtk_widget_set_default_direction(.ltr)
        spinMainLoop()
        #expect(
            criticals.count == 0,
            "walking a toplevel list that still contains a released window must not touch freed memory")
        if let raw {
            gtk_window_destroy(raw.assumingMemoryBound(to: CAdwaita.GtkWindow.self))
        }
        spinMainLoop()
        #expect(slot?.isCleared == true, "destroying the window must finalize it once the wrapper is gone")
    }

    @Test("destroying the Window while its wrapper is alive leaves no dangling reference") @MainActor
    func windowDestroyedWhileWrapperAliveLeavesNoDanglingReference() {
        ensureAdwInit()
        var slot: WeakPointerSlot?
        var raw: UnsafeMutableRawPointer?
        var window: Window?
        do {
            window = Window()
            raw = window!.pointer
            slot = WeakPointerSlot(watching: window!.gobjectPointer)
        }
        spinMainLoop()
        let criticals = CriticalCounter()
        defer { criticals.uninstall() }
        // Destroy the window while the wrapper is still alive: GTK drops the
        // toplevel-list reference, but the wrapper's own reference keeps the
        // window alive until the wrapper is dropped too.
        if let raw {
            gtk_window_destroy(raw.assumingMemoryBound(to: CAdwaita.GtkWindow.self))
        }
        spinMainLoop()
        #expect(
            slot?.isCleared == false,
            "the wrapper's own reference must keep a destroyed window alive until the wrapper goes too")
        // Now drop the wrapper: once both GTK and Swift have let go the window
        // finalizes, and the wrapper's deinit must not touch freed memory.
        window = nil
        spinMainLoop()
        #expect(
            slot?.isCleared == true,
            "once both GTK and the wrapper let go the window must finalize")
        #expect(
            criticals.count == 0,
            "dropping a wrapper whose window GTK already destroyed must fire no criticals")
    }

    // MARK: - Presented windows

    @Test("a presented window outlives its wrapper until it is destroyed") @MainActor
    func presentedWindowOutlivesItsWrapperUntilDestroyed() {
        ensureAdwInit()
        var slot: WeakPointerSlot?
        var raw: UnsafeMutableRawPointer?
        do {
            let window = Window()
            raw = window.pointer
            slot = WeakPointerSlot(watching: window.gobjectPointer)
            window.present()
        }
        spinMainLoop()
        #expect(
            slot?.isCleared == false,
            "a presented window must stay alive after the wrapper goes: GTK keeps its own reference until destroy")
        #expect(toplevelListContains(raw), "a live window must stay in the toplevel list")
        let criticals = CriticalCounter()
        defer { criticals.uninstall() }
        if let raw {
            gtk_window_destroy(raw.assumingMemoryBound(to: CAdwaita.GtkWindow.self))
        }
        spinMainLoop()
        #expect(slot?.isCleared == true, "destroying the window must finalize it once the wrapper is gone")
        #expect(toplevelListContains(raw) == false, "a destroyed window must leave the toplevel list")
        gtk_widget_set_default_direction(.rtl)
        gtk_widget_set_default_direction(.ltr)
        spinMainLoop()
        #expect(criticals.count == 0, "walking the toplevel list after destroy must fire no criticals")
    }

    @Test("destroying a presented window frees it once its wrapper is gone") @MainActor
    func presentedWindowIsFreedOnceItsWrapperGoes() {
        ensureAdwInit()
        var slot: WeakPointerSlot?
        var window: Window?
        do {
            window = Window()
            slot = WeakPointerSlot(watching: window!.gobjectPointer)
            window!.present()
        }
        spinMainLoop()
        let criticals = CriticalCounter()
        defer { criticals.uninstall() }
        window!.destroy()
        spinMainLoop()
        #expect(
            slot?.isCleared == false,
            "the wrapper's own reference keeps a destroyed window alive until the wrapper goes too")
        window = nil
        spinMainLoop()
        #expect(slot?.isCleared == true, "once both GTK and the wrapper let go the window must finalize")
        #expect(criticals.count == 0, "dropping a wrapper whose window was destroyed must fire no criticals")
    }

    @Test("calling retainUntilClose on a window does not keep it alive after destroy") @MainActor
    func retainUntilCloseOnPresentedWindowDoesNotKeepItAlive() {
        ensureAdwInit()
        var slot: WeakPointerSlot?
        var window: Window?
        do {
            window = Window()
            slot = WeakPointerSlot(watching: window!.gobjectPointer)
            window!.retainUntilClose()
            window!.present()
        }
        spinMainLoop()
        let criticals = CriticalCounter()
        defer { criticals.uninstall() }
        window!.destroy()
        spinMainLoop()
        window = nil
        spinMainLoop()
        #expect(
            slot?.isCleared == true,
            "retainUntilClose is a no-op on windows: the window must still finalize")
        #expect(criticals.count == 0, "dropping the wrapper must fire no criticals")
    }

    @Test("a presented ApplicationWindow outlives its wrapper until it is destroyed") @MainActor
    func presentedApplicationWindowOutlivesItsWrapperUntilDestroyed() throws {
        ensureAdwInit()
        let app = Application(id: "com.test.toplevelwindowownership.appw4.t\(UInt32.random(in: 0 ..< UInt32.max))")
        try app.register()
        defer { app.quit() }
        var slot: WeakPointerSlot?
        var raw: UnsafeMutableRawPointer?
        do {
            let window = ApplicationWindow(application: app)
            raw = window.pointer
            slot = WeakPointerSlot(watching: window.gobjectPointer)
            window.present()
        }
        spinMainLoop()
        #expect(
            slot?.isCleared == false,
            "a presented window must stay alive after the wrapper goes: GTK keeps its own reference until destroy")
        #expect(toplevelListContains(raw), "a live window must stay in the toplevel list")
        let criticals = CriticalCounter()
        defer { criticals.uninstall() }
        if let raw {
            gtk_window_destroy(raw.assumingMemoryBound(to: CAdwaita.GtkWindow.self))
        }
        spinMainLoop()
        #expect(slot?.isCleared == true, "destroying the window must finalize it once the wrapper is gone")
        #expect(toplevelListContains(raw) == false, "a destroyed window must leave the toplevel list")
        gtk_widget_set_default_direction(.rtl)
        gtk_widget_set_default_direction(.ltr)
        spinMainLoop()
        #expect(criticals.count == 0, "walking the toplevel list after destroy must fire no criticals")
    }

    @Test("destroying a presented ApplicationWindow frees it once its wrapper is gone") @MainActor
    func presentedApplicationWindowIsFreedOnceItsWrapperGoes() throws {
        ensureAdwInit()
        let app = Application(id: "com.test.toplevelwindowownership.appw5.t\(UInt32.random(in: 0 ..< UInt32.max))")
        try app.register()
        defer { app.quit() }
        var slot: WeakPointerSlot?
        var window: ApplicationWindow?
        do {
            window = ApplicationWindow(application: app)
            slot = WeakPointerSlot(watching: window!.gobjectPointer)
            window!.present()
        }
        spinMainLoop()
        let criticals = CriticalCounter()
        defer { criticals.uninstall() }
        window!.destroy()
        spinMainLoop()
        #expect(
            slot?.isCleared == false,
            "the wrapper's own reference keeps a destroyed window alive until the wrapper goes too")
        window = nil
        spinMainLoop()
        #expect(slot?.isCleared == true, "once both GTK and the wrapper let go the window must finalize")
        #expect(criticals.count == 0, "dropping a wrapper whose window was destroyed must fire no criticals")
    }

    @Test("calling retainUntilClose on an ApplicationWindow does not keep it alive after destroy") @MainActor
    func retainUntilCloseOnPresentedApplicationWindowDoesNotKeepItAlive() throws {
        ensureAdwInit()
        let app = Application(id: "com.test.toplevelwindowownership.appw6.t\(UInt32.random(in: 0 ..< UInt32.max))")
        try app.register()
        defer { app.quit() }
        var slot: WeakPointerSlot?
        var window: ApplicationWindow?
        do {
            window = ApplicationWindow(application: app)
            slot = WeakPointerSlot(watching: window!.gobjectPointer)
            window!.retainUntilClose()
            window!.present()
        }
        spinMainLoop()
        let criticals = CriticalCounter()
        defer { criticals.uninstall() }
        window!.destroy()
        spinMainLoop()
        window = nil
        spinMainLoop()
        #expect(
            slot?.isCleared == true,
            "retainUntilClose is a no-op on windows: the window must still finalize")
        #expect(criticals.count == 0, "dropping the wrapper must fire no criticals")
    }
}

/// Whether the display's toplevel list (`gtk_window_get_toplevels`) still
/// contains `pointer`, inspecting it through the `GListModel` interface.
@MainActor
func toplevelListContains(_ pointer: UnsafeMutableRawPointer?) -> Bool {
    guard let pointer, let toplevels = gtk_window_get_toplevels() else { return false }
    // transfer-ownership="none": the display's toplevel list, not a reference for us.
    let model = OpaquePointer(UnsafeMutableRawPointer(toplevels))
    let count = g_list_model_get_n_items(model)
    for index in 0 ..< count {
        if let item = g_list_model_get_item(model, UInt32(index)) {
            let matches = item == pointer
            g_object_unref(item)
            if matches { return true }
        }
    }
    return false
}

private let toplevelTestLogHandler:
    @convention(c) (
        UnsafePointer<CChar>?,
        GLogLevelFlags,
        UnsafePointer<CChar>?,
        UnsafeMutableRawPointer?
    ) -> Void = { _, _, _, data in
        if let data {
            Unmanaged<CriticalCounter>.fromOpaque(data).takeUnretainedValue().record()
        }
    }

/// Counts GLib CRITICALs for the domains a toplevel walk would log from,
/// via `g_log_set_handler` for `G_LOG_LEVEL_CRITICAL` (1 << 3).
private final class CriticalCounter {
    private static let domains = ["GLib-GObject", "Gtk", "GLib"]
    private static let criticalLevel = GLogLevelFlags(rawValue: 1 << 3)

    private var state: Int32 = 0
    private var handlerIDs: [(domain: String, id: guint)] = []

    init() {
        let token = Unmanaged.passUnretained(self).toOpaque()
        for domain in Self.domains {
            let id = g_log_set_handler(domain, Self.criticalLevel, toplevelTestLogHandler, token)
            handlerIDs.append((domain, id))
        }
    }

    func record() {
        g_atomic_int_inc(&state)
    }

    var count: Int32 {
        g_atomic_int_get(&state)
    }

    func uninstall() {
        for handler in handlerIDs {
            g_log_remove_handler(handler.domain, handler.id)
        }
        handlerIDs.removeAll()
    }
}
#endif
