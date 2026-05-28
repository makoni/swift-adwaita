// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct EventControllerAPITests {

    // MARK: - PropagationPhase

    @Test @MainActor func gestureClickHasBubblePropagationPhaseByDefault() {
        ensureAdwInit()
        let click = GestureClick()
        #expect(click.propagationPhase == .bubble)
    }

    @Test @MainActor func propagationPhaseRoundTripsCapture() {
        ensureAdwInit()
        let click = GestureClick()
        click.propagationPhase = .capture
        #expect(click.propagationPhase == .capture)
    }

    @Test @MainActor func propagationPhaseRoundTripsTarget() {
        ensureAdwInit()
        let click = GestureClick()
        click.propagationPhase = .target
        #expect(click.propagationPhase == .target)
    }

    @Test @MainActor func propagationPhaseRoundTripsNone() {
        ensureAdwInit()
        let click = GestureClick()
        click.propagationPhase = .none
        #expect(click.propagationPhase == .none)
    }

    @Test @MainActor func eventControllerKeyHasBubblePropagationPhaseByDefault() {
        ensureAdwInit()
        let key = EventControllerKey()
        #expect(key.propagationPhase == .bubble)
    }

    // MARK: - EventSequenceState

    @Test @MainActor func gestureSetStateDeniedDoesNotCrash() {
        ensureAdwInit()
        let window = Window()
        window.setDefaultSize(width: 400, height: 300)
        window.present()
        defer {
            window.close()
            MainContext.drainPending()
            MainContext.drainPending()
        }
        let gesture = GestureClick()
        window.addController(gesture)
        // setState on a gesture with no active sequence is a no-op in GTK — must not crash
        gesture.setState(.denied)
    }

    @Test @MainActor func gestureSetStateClaimedDoesNotCrash() {
        ensureAdwInit()
        let window = Window()
        window.present()
        defer {
            window.close()
            MainContext.drainPending()
            MainContext.drainPending()
        }
        let gesture = GestureClick()
        window.addController(gesture)
        gesture.setState(.claimed)
    }

    // MARK: - Widget.allocation

    @Test @MainActor func widgetAllocationIsZeroWhenNotMapped() {
        ensureAdwInit()
        let label = Label("Hello")
        let alloc = label.allocation
        #expect(alloc.x == 0)
        #expect(alloc.y == 0)
        #expect(alloc.width == 0)
        #expect(alloc.height == 0)
    }

    @Test @MainActor func widgetAllocationIsNonZeroWhenMapped() {
        ensureAdwInit()
        let window = Window()
        window.setDefaultSize(width: 400, height: 300)
        let label = Label("Hello World")
        window.content = label
        window.present()
        defer {
            window.close()
            MainContext.drainPending()
            MainContext.drainPending()
        }
        // Drain until allocation is non-zero (map completes)
        let clock = ContinuousClock()
        let deadline = clock.now.advanced(by: .seconds(2))
        while label.allocation.width == 0, clock.now < deadline {
            if MainContext.drainPending() == 0 { g_usleep(1_000) }
        }
        let alloc = label.allocation
        #expect(alloc.width > 0)
        #expect(alloc.height > 0)
    }

    // MARK: - Application.setAccelerators

    @Test @MainActor func applicationSetAcceleratorsRegistersShortcut() throws {
        ensureAdwInit()
        // GLib requires each app-ID segment to start with a letter.
        let app = Application(id: "me.test.EventControllerAPITests.Accels.t\(UInt32.random(in: 0 ..< UInt32.max))")
        try app.register()
        defer { app.quit() }
        app.setAccelerators(["<Primary>k"], for: "app.my-action")
        let result = gtk_application_get_accels_for_action(app.gtkApplicationPointer, "app.my-action")
        defer { g_strfreev(result) }
        // GTK normalises "<Primary>" → "<Control>" on Linux, so verify the
        // array is non-empty rather than matching the exact canonical string.
        #expect(result?[0] != nil)
    }

    @Test @MainActor func applicationSetAcceleratorsClearsWithEmptyArray() throws {
        ensureAdwInit()
        let app = Application(id: "me.test.EventControllerAPITests.AccelsClear.t\(UInt32.random(in: 0 ..< UInt32.max))")
        try app.register()
        defer { app.quit() }
        app.setAccelerators(["<Primary>j"], for: "app.tmp-action")
        app.setAccelerators([], for: "app.tmp-action")
        let result = gtk_application_get_accels_for_action(app.gtkApplicationPointer, "app.tmp-action")
        defer { g_strfreev(result) }
        #expect(result?[0] == nil)
    }

    // MARK: - ApplicationWindow.visibleDialog

    @Test @MainActor func applicationWindowVisibleDialogIsNilInitially() throws {
        ensureAdwInit()
        let app = Application(id: "me.test.EventControllerAPITests.VisDlg.t\(UInt32.random(in: 0 ..< UInt32.max))")
        try app.register()
        let window = ApplicationWindow(application: app)
        window.setDefaultSize(width: 400, height: 300)
        window.present()
        defer {
            window.close()
            MainContext.drainPending()
            MainContext.drainPending()
        }
        #expect(window.visibleDialog == nil)
    }

    @Test @MainActor func applicationWindowVisibleDialogIsNonNilWhenDialogPresented() throws {
        ensureAdwInit()
        let app = Application(id: "me.test.EventControllerAPITests.VisDlg2.t\(UInt32.random(in: 0 ..< UInt32.max))")
        try app.register()
        let window = ApplicationWindow(application: app)
        window.setDefaultSize(width: 800, height: 600)
        window.present()
        let dialog = Dialog()
        dialog.child = Box()
        dialog.present(window)
        defer {
            dialog.forceClose()
            window.close()
            MainContext.drainPending()
            MainContext.drainPending()
        }
        let clock = ContinuousClock()
        let deadline = clock.now.advanced(by: .seconds(2))
        while window.visibleDialog == nil, clock.now < deadline {
            if MainContext.drainPending() == 0 { g_usleep(1_000) }
        }
        #expect(window.visibleDialog != nil)
    }
}
#endif
