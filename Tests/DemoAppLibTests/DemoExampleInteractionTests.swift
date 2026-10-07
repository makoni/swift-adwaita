// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Foundation
import Testing
import Adwaita
@testable import DemoAppLib

/// Interaction tests for the demo examples whose behavior is defined by a user
/// action: drive the real control out of the `buildWidget()` tree (by button
/// label, or the unique `Switch`/affected widget) and assert the observable
/// effect on a sibling widget.
///
/// Deliberately not fully covered here, because it isn't meaningfully drivable
/// or observable in-process:
/// - `UriLauncher` — only the Launch button is a side effect (opens the system
///   browser); the preset buttons are covered by
///   `uriLauncherPresetButtonsSetEntry`.
/// - `MediaControls` / `AnimatedImagePlayer` — load through a modal
///   `FileDialog` and need real media files.
/// - `Gesture*` — need real pointer press/move/release sequences, which no
///   in-process signal can synthesize.
@Suite(.serialized)
struct DemoExampleInteractionTests {
    @MainActor
    static func setUp(_ example: any DemoExample) -> (root: Widget, window: Window) {
        let root = example.buildWidget()
        let window = Window()
        window.setDefaultSize(width: 900, height: 700)
        window.content = root
        window.present()
        drainMainLoop()
        return (root, window)
    }

    @MainActor
    static func tearDown(_ window: Window) {
        window.destroy()
        drainMainLoop()
    }

    @Test @MainActor
    func centerBoxClearAndRestoreCenter() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(CenterBoxExample())
        defer { Self.tearDown(window) }

        let centerBox = widgetOfType(root, CenterBox.self)
        let clearBtn = buttonLabeled(root, "Clear")
        let restoreBtn = buttonLabeled(root, "Restore")
        #expect(centerBox != nil, "CenterBox not found in tree")
        #expect(clearBtn != nil)
        #expect(restoreBtn != nil)
        #expect(centerBox?.centerWidget != nil, "expected an initial centre widget")

        clearBtn?.emitClicked()
        #expect(centerBox?.centerWidget == nil, "Clear should remove the centre widget")
        #expect(centerBox?.startWidget != nil, "Clear should not touch the start widget")
        #expect(centerBox?.endWidget != nil, "Clear should not touch the end widget")

        restoreBtn?.emitClicked()
        #expect(centerBox?.centerWidget != nil, "Restore should set the centre widget back")
    }

    @Test @MainActor
    func centerBoxShrinkCenterLast() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(CenterBoxExample())
        defer { Self.tearDown(window) }

        let centerBox = widgetOfType(root, CenterBox.self)
        let switch_ = widgetOfType(root, Switch.self)
        #expect(centerBox != nil)
        #expect(switch_ != nil)

        switch_?.active = false
        #expect(centerBox?.shrinkCenterLast == false)
        switch_?.active = true
        #expect(centerBox?.shrinkCenterLast == true)
    }

    @Test @MainActor
    func aspectFrameRatioPresets() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(AspectFrameExample())
        defer { Self.tearDown(window) }

        let frame = widgetOfType(root, AspectFrame.self)
        #expect(frame != nil)

        buttonLabeled(root, "1:1")?.emitClicked()
        #expect(abs((frame?.ratio ?? 0) - 1.0) < 0.0001)
        #expect(frame?.obeyChild == false, "ratio presets reset obeyChild")

        buttonLabeled(root, "4:3")?.emitClicked()
        #expect(abs((frame?.ratio ?? 0) - Float(4.0 / 3.0)) < 0.0001)
    }

    @Test @MainActor
    func aspectFrameObeyChild() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(AspectFrameExample())
        defer { Self.tearDown(window) }

        let frame = widgetOfType(root, AspectFrame.self)
        let switch_ = widgetOfType(root, Switch.self)
        #expect(frame != nil)
        #expect(switch_ != nil)

        switch_?.active = true
        #expect(frame?.obeyChild == true)
    }

    @Test @MainActor
    func inlineViewSwitcherDisplayMode() {
        ensureDemoAdwInit()
        // InlineViewSwitcher needs libadwaita 1.7+; older runtimes render the
        // example's fallback, so there is nothing to drive. Skip gracefully.
        guard AdwaitaVersion.isAtLeast(1, 7) else { return }
        let (root, window) = Self.setUp(InlineViewSwitcherExample())
        defer { Self.tearDown(window) }

        let switcher = widgetOfType(root, InlineViewSwitcher.self)
        #expect(switcher != nil, "InlineViewSwitcher should exist on a 1.7+ runtime")

        buttonLabeled(root, "Icons")?.emitClicked()
        #expect(switcher?.displayMode == .icons)

        buttonLabeled(root, "Labels")?.emitClicked()
        #expect(switcher?.displayMode == .labels)

        buttonLabeled(root, "Both")?.emitClicked()
        #expect(switcher?.displayMode == .both)
    }

    @Test @MainActor
    func carouselIndicatorLinesToggle() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(CarouselExample())
        defer { Self.tearDown(window) }

        let dots = widgetOfType(root, CarouselIndicatorDots.self)
        let lines = widgetOfType(root, CarouselIndicatorLines.self)
        let switch_ = widgetOfType(root, Switch.self)
        #expect(dots != nil, "dots indicator not found in tree")
        #expect(lines != nil, "lines indicator not found in tree")
        #expect(switch_ != nil, "indicator-style switch not found in tree")

        // Dots are the default; lines exist but start hidden (the regression
        // the line-toggle guards against is "both visible at once").
        #expect(dots?.visible == true, "dots should start visible")
        #expect(lines?.visible == false, "lines should start hidden")

        switch_?.active = true
        #expect(dots?.visible == false, "lines mode should hide the dots")
        #expect(lines?.visible == true, "lines mode should show the lines")

        switch_?.active = false
        #expect(dots?.visible == true)
        #expect(lines?.visible == false)
    }

    @Test @MainActor
    func tabOverviewToggleOpen() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(TabOverviewExample())
        defer { Self.tearDown(window) }

        let overview = widgetOfType(root, TabOverview.self)
        let toggle = buttonLabeled(root, "Toggle Tab Overview")
        #expect(overview != nil)
        #expect(toggle != nil)
        #expect(overview?.open == false, "overview should start closed")

        toggle?.emitClicked()
        #expect(overview?.open == true)

        toggle?.emitClicked()
        #expect(overview?.open == false)
    }

    @Test @MainActor
    func uriLauncherPresetButtonsSetEntry() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(UriLauncherExample())
        defer { Self.tearDown(window) }

        let entry = widgetOfType(root, Entry.self)
        #expect(entry != nil, "URI entry not found in tree")

        buttonLabeled(root, "GTK")?.emitClicked()
        #expect(entry?.text == "https://gtk.org", "GTK preset should set the entry")

        buttonLabeled(root, "GitHub")?.emitClicked()
        #expect(entry?.text == "https://github.com", "GitHub preset should set the entry")
    }

    @Test @MainActor
    func shortcutsDialogPresentOnDemand() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(ShortcutsDialogExample())
        defer { Self.tearDown(window) }

        let button = buttonLabeled(root, "Show Shortcuts…")
        #expect(button != nil)
        // Presenting an AdwShortcutsDialog (libadwaita 1.8+) must not crash.
        // The example builds the dialog inside the button closure and keeps no
        // handle, so the presented dialog outlives this window's destroy() —
        // a separate top-level, harmless here but flagged for any future test
        // that enumerates top-levels.
        button?.emitClicked()
        drainMainLoop()
    }
}
#endif
