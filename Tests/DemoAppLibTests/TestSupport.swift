// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Foundation
import Adwaita

// Shared helpers for the demo-app smoke and interaction tests (both live in
// this module and drive the real `buildWidget()` output).

/// One-time GTK/Adw init for tests that instantiate widgets. Mirrors the
/// library test harness: keep GStreamer out of the process so media-backed
/// widgets use the do-nothing backend instead of racing GStreamer teardown.
@MainActor
func ensureDemoAdwInit() {
    struct Once { nonisolated(unsafe) static var done = false }
    guard !Once.done else { return }

    if ProcessInfo.processInfo.environment["GTK_MEDIA"] == nil {
        setenv("GTK_MEDIA", "none", 1)
    }
    adw_init()
    Once.done = true
}

/// Pump the GLib main loop a bounded number of times so realize/measure/allocate
/// and idle/destroy work for a freshly presented window completes. Each
/// `drainPending()` already drains the queue to quiescence, so this just runs a
/// few passes to let queued work cascade.
@MainActor
func drainMainLoop(_ passes: Int = 4) {
    for _ in 0 ..< passes {
        _ = MainContext.drainPending()
    }
}

/// Depth-first, pre-order collection of `root` and every descendant widget,
/// visiting siblings in GTK child order (first child first).
@MainActor
func allWidgets(_ root: Widget) -> [Widget] {
    var stack = [root]
    var out: [Widget] = []
    while let widget = stack.popLast() {
        out.append(widget)
        for child in widget.children().reversed() {
            stack.append(child)
        }
    }
    return out
}

/// The first descendant of `root` that is an instance of `T` (depth-first, in
/// GTK child order). Callers must ensure `T` is unique in the tree; otherwise
/// the first match wins silently (e.g. a tree with two `Switch`es would always
/// return the first).
///
/// `children()` re-wraps descendants as the base `Widget`, so a Swift `as?`
/// cast can never see the concrete type; `tryCast` re-wraps via the GObject
/// type instead.
@MainActor
func widgetOfType<T: Widget>(_ root: Widget, _ type: T.Type) -> T? {
    for widget in allWidgets(root) {
        if let hit = widget.tryCast(type) { return hit }
    }
    return nil
}

/// The first button in `root` whose label matches exactly.
@MainActor
func buttonLabeled(_ root: Widget, _ label: String) -> Button? {
    for widget in allWidgets(root) {
        if let button = widget.tryCast(Button.self), button.label == label {
            return button
        }
    }
    return nil
}
#endif
