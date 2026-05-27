// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct DialogBackdropDismissTests {
    @MainActor
    private static func visibleDialog(of window: ApplicationWindow) -> Dialog? {
        adw_application_window_get_visible_dialog(window.adwWindowPointer)
            .map { Dialog(borrowing: UnsafeMutableRawPointer($0)) }
    }

    @MainActor
    private static func waitUntil(
        timeout: Duration = .milliseconds(300),
        step: Duration = .milliseconds(10),
        _ condition: @MainActor () -> Bool
    ) {
        let clock = ContinuousClock()
        let deadline = clock.now.advanced(by: timeout)

        while !condition(), clock.now < deadline {
            MainContext.pump(for: step)
        }
    }

    @Test @MainActor
    func enableBackdropClickDismissClosesPresentedDialog() throws {
        ensureAdwInit()

        let app = Application(id: "me.spaceinbox.adwaita.tests.dialog.backdrop")
        try app.register()

        let window = ApplicationWindow(application: app)
        window.setDefaultSize(width: 1280, height: 900)
        window.present()

        let dialog = Dialog()
        dialog.child = Box()
        dialog.present(window)
        dialog.enableBackdropClickDismiss()

        Self.waitUntil {
            dialog.debugHasBackdropClickDismissHook
        }

        #expect(dialog.debugHasBackdropClickDismissHook)
        #expect(Self.visibleDialog(of: window) != nil)

        dialog.debugEmitBackdropClickDismiss()
        Self.waitUntil {
            Self.visibleDialog(of: window) == nil && !dialog.debugHasBackdropClickDismissHook
        }

        #expect(Self.visibleDialog(of: window) == nil)
        #expect(!dialog.debugHasBackdropClickDismissHook)
    }

    @Test @MainActor
    func enableBackdropClickDismissReinstallsOnNextPresentationWithoutRearming() throws {
        ensureAdwInit()

        let app = Application(id: "me.spaceinbox.adwaita.tests.dialog.backdrop.represent")
        try app.register()

        let window = ApplicationWindow(application: app)
        window.setDefaultSize(width: 1280, height: 900)
        window.present()

        let dialog = Dialog()
        dialog.child = Box()

        dialog.present(window)
        dialog.enableBackdropClickDismiss()
        Self.waitUntil {
            dialog.debugHasBackdropClickDismissHook
        }
        #expect(dialog.debugHasBackdropClickDismissHook)

        dialog.debugEmitBackdropClickDismiss()
        Self.waitUntil {
            Self.visibleDialog(of: window) == nil && !dialog.debugHasBackdropClickDismissHook
        }
        #expect(Self.visibleDialog(of: window) == nil)
        #expect(!dialog.debugHasBackdropClickDismissHook)

        dialog.present(window)
        Self.waitUntil {
            dialog.debugHasBackdropClickDismissHook
        }

        #expect(Self.visibleDialog(of: window) != nil)
        #expect(dialog.debugHasBackdropClickDismissHook)

        dialog.debugEmitBackdropClickDismiss()
        Self.waitUntil {
            Self.visibleDialog(of: window) == nil
        }

        #expect(Self.visibleDialog(of: window) == nil)
    }

    @Test @MainActor
    func enableBackdropClickDismissGivesUpAfterBoundedRetriesWithoutFloatingBackdrop() throws {
        ensureAdwInit()

        let app = Application(id: "me.spaceinbox.adwaita.tests.dialog.backdrop.exhaust")
        try app.register()

        let window = ApplicationWindow(application: app)
        window.present()

        let dialog = Dialog()
        dialog.presentationMode = .bottomSheet
        dialog.child = Box()
        dialog.present(window)
        dialog.enableBackdropClickDismiss(maxRetries: 2)

        Self.waitUntil(timeout: .milliseconds(500)) {
            guard let state = dialog.debugBackdropClickDismissState else { return false }
            return !state.isInstalled && state.remainingRetries == 0 && !state.retryScheduled
        }

        let state = try #require(dialog.debugBackdropClickDismissState)
        #expect(!state.isInstalled)
        #expect(state.remainingRetries == 0)
        #expect(!state.retryScheduled)
        #expect(state.isEnabled)
    }

    @Test @MainActor
    func enableBackdropClickDismissWithZeroRetriesStillHooksImmediateBackdrop() throws {
        ensureAdwInit()

        let app = Application(id: "me.spaceinbox.adwaita.tests.dialog.backdrop.zero")
        try app.register()

        let window = ApplicationWindow(application: app)
        window.setDefaultSize(width: 1280, height: 900)
        window.present()

        let dialog = Dialog()
        dialog.child = Box()
        dialog.present(window)
        Self.waitUntil { Self.visibleDialog(of: window) != nil }

        dialog.enableBackdropClickDismiss(maxRetries: 0)
        Self.waitUntil {
            dialog.debugHasBackdropClickDismissHook
        }

        let state = try #require(dialog.debugBackdropClickDismissState)
        #expect(state.isInstalled)
        #expect(state.remainingRetries == 0)
        #expect(!state.retryScheduled)
    }
}
#endif
