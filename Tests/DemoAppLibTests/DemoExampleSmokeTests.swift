// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Foundation
import Testing
import Adwaita
@testable import DemoAppLib

/// The demo app (`DemoApp`) is a standalone executable and is not exercised by
/// the library test suite. This smoke test iterates every registered demo
/// example, constructs it and realizes it in a live window, so a broken
/// example (a bad initializer, a force-unwrap of a nil optional, a bad API
/// call, a measure/allocate crash) fails the build instead of only crashing
/// when someone opens the example by hand.
///
/// `allExamples` is a `@MainActor` global, so the examples can't be fed to
/// `@Test(arguments:)` (which is evaluated off the main actor); instead one
/// serialized test drives them all on the main actor.
@Suite(.serialized)
struct DemoExampleSmokeTests {
    @Test @MainActor
    func everyRegisteredDemoExampleBuildsAndRealizesWithoutCrashing() {
        ensureDemoAdwInit()

        // The gallery navigates by id (DemoAppRunner looks examples up by id),
        // so a duplicate id would silently break navigation while every build
        // still passes. Guard the registry invariant explicitly.
        #expect(
            Set(allExamples.map(\.id)).count == allExamples.count,
            "demo example ids must be unique")

        for example in allExamples {
            // Name the example before doing anything with it: a hard crash
            // (nil-unwrap, bad API, measure/allocate) aborts the process, so
            // this is the last line in the log identifying the failing id.
            // Written to stderr (unbuffered) so it survives that abort, where a
            // buffered stdout `print` would be dropped.
            FileHandle.standardError.write(Data("building example \(example.id)\n".utf8))

            // Construction (catches init / bad-API / nil-unwrap crashes).
            let widget = example.buildWidget()

            // Realize in a live window (catches measure/allocate/size crashes
            // and a content widget that's set but never attached/realized).
            var realized = false
            _ = widget.onRealize { realized = true }
            let window = Window()
            window.setDefaultSize(width: 900, height: 700)
            window.content = widget
            window.present()
            drainMainLoop()
            #expect(realized, "example \(example.id) did not realize in its window")
            window.destroy()
            drainMainLoop()
        }
    }
}
#endif
