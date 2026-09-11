// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Testing
@testable import Adwaita
import CAdwaita

/// `GtkSpinner` is the always-available counterpart to the libadwaita 1.6+
/// ``Spinner``: apps that support the 1.5 baseline cannot rely on the latter,
/// whose initialiser is failable.
@Suite(.serialized)
struct GtkSpinnerTests {

    @Test @MainActor func spinnerIsNotSpinningUntilStarted() {
        ensureAdwInit()
        let spinner = GtkSpinner()
        #expect(spinner.spinning == false)
    }

    @Test @MainActor func spinningPropertyRoundTrips() {
        ensureAdwInit()
        let spinner = GtkSpinner()
        spinner.spinning = true
        #expect(spinner.spinning == true)
        spinner.spinning = false
        #expect(spinner.spinning == false)
    }

    @Test @MainActor func startAndStopMatchTheProperty() {
        ensureAdwInit()
        let spinner = GtkSpinner()
        spinner.start()
        #expect(spinner.spinning == true)
        spinner.stop()
        #expect(spinner.spinning == false)
    }

    /// Unlike `AdwSpinner`, this type is available on the 1.5 baseline, so its
    /// GType must resolve without any version check.
    @Test @MainActor func gtkTypeResolves() {
        ensureAdwInit()
        #expect(GtkSpinner.gtkType != 0)
    }

    @Test @MainActor func packsIntoAContainerLikeAnyWidget() {
        ensureAdwInit()
        let box = Box(orientation: .horizontal, spacing: 8)
        let spinner = GtkSpinner()
        spinner.spinning = true
        box.append(spinner)
        box.append(Label("Loading…"))
        #expect(spinner.spinning == true)
    }
}
#endif
