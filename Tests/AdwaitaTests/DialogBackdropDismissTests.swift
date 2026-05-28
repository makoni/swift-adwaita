// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Foundation
import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct DialogBackdropDismissTests {
    @MainActor
    private static func waitUntil(
        timeout: Duration = .seconds(2),
        _ condition: @MainActor () -> Bool
    ) {
        let clock = ContinuousClock()
        let deadline = clock.now.advanced(by: timeout)

        while !condition(), clock.now < deadline {
            if MainContext.drainPending() == 0 {
                g_usleep(1_000)
            }
        }
    }

    @Test @MainActor
    func enableBackdropClickDismissClosesPresentedDialog() {
        ensureAdwInit()

        let window = Window()
        window.setDefaultSize(width: 1280, height: 900)
        window.present()

        let dialog = Dialog()
        defer {
            dialog.forceClose()
            window.close()
            MainContext.drainPending()
            MainContext.drainPending()
        }
        dialog.child = Box()
        var didClose = false
        dialog.onClosed {
            didClose = true
        }
        dialog.present(window)
        dialog.enableBackdropClickDismiss()

        Self.waitUntil {
            dialog.debugHasBackdropClickDismissHook
        }

        #expect(dialog.debugHasBackdropClickDismissHook)

        dialog.debugEmitBackdropClickDismiss()
        Self.waitUntil {
            didClose
        }

        #expect(didClose)
    }

    @Test @MainActor
    func enableBackdropClickDismissReinstallsOnNextPresentationWithoutRearming() {
        ensureAdwInit()

        let window = Window()
        window.setDefaultSize(width: 1280, height: 900)
        window.present()

        let dialog = Dialog()
        defer {
            dialog.forceClose()
            window.close()
            MainContext.drainPending()
            MainContext.drainPending()
        }
        dialog.child = Box()
        var closeCount = 0
        dialog.onClosed {
            closeCount += 1
        }

        dialog.present(window)
        dialog.enableBackdropClickDismiss()
        Self.waitUntil {
            dialog.debugHasBackdropClickDismissHook
        }
        #expect(dialog.debugHasBackdropClickDismissHook)
        dialog.debugEmitBackdropClickDismiss()
        Self.waitUntil {
            closeCount == 1
        }
        #expect(closeCount == 1)

        dialog.present(window)
        Self.waitUntil {
            dialog.debugHasBackdropClickDismissHook
        }

        #expect(dialog.debugHasBackdropClickDismissHook)

        dialog.debugEmitBackdropClickDismiss()
        Self.waitUntil {
            closeCount == 2
        }

        #expect(closeCount == 2)
    }

    @Test @MainActor
    func enableBackdropClickDismissGivesUpAfterBoundedRetriesWithoutFloatingBackdrop() throws {
        ensureAdwInit()

        let window = Window()
        window.present()

        let dialog = Dialog()
        defer {
            dialog.forceClose()
            window.close()
            MainContext.drainPending()
            MainContext.drainPending()
        }
        dialog.presentationMode = .bottomSheet
        dialog.child = Box()
        dialog.present(window)
        dialog.enableBackdropClickDismiss(maxRetries: 2)

        Self.waitUntil {
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

        let window = Window()
        window.setDefaultSize(width: 1280, height: 900)
        window.present()

        let dialog = Dialog()
        defer {
            dialog.forceClose()
            window.close()
            MainContext.drainPending()
            MainContext.drainPending()
        }
        dialog.child = Box()
        dialog.present(window)
        Self.waitUntil { dialog.root != nil }

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
