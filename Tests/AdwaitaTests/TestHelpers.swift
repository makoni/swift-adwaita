// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Foundation
import Testing
@testable import Adwaita
import CAdwaita

/// Helper to verify subclass relationships at runtime.
///
/// Named `isAdwSubclass` rather than the obvious `isSubclass` to avoid
/// shadowing `NSObject.isSubclass(of:)` inside `XCTestCase` subclasses.
@MainActor
func isAdwSubclass<Sub: AnyObject, Super: AnyObject>(_: Sub.Type, of _: Super.Type) -> Bool {
    Sub.self is Super.Type
}

/// One-time GTK/Adw init for tests that instantiate widgets.
@MainActor
func ensureAdwInit() {
    struct Once { nonisolated(unsafe) static var done = false }
    guard !Once.done else { return }

    // Keep GStreamer out of the test process.
    //
    // `GtkMediaFile` is backed by GStreamer on Linux, and `GstPlay` runs its
    // pipeline on a thread of its own with its own main loop. Creating and
    // dropping several short-lived media files — which the media tests do,
    // against a path that does not exist — races that thread's teardown: it
    // aborts inside `g_mutex_clear`, reached from `gst_bus_post` →
    // `g_object_unref`, while posting to a bus whose owner is already being
    // finalized. The whole test binary dies with it, taking unrelated suites
    // down at whatever point they had reached.
    //
    // `GTK_MEDIA=none` selects GTK's do-nothing media backend, which honours
    // the `GtkMediaStream` properties the wrapper tests assert (playing,
    // ended, muted, volume, loop, duration) without starting a pipeline.
    // Nothing here tests decoding; the file is deliberately missing.
    //
    // Set before `adw_init()`, and only when the environment has no opinion,
    // so a run that genuinely wants a backend can still ask for one.
    if ProcessInfo.processInfo.environment["GTK_MEDIA"] == nil {
        setenv("GTK_MEDIA", "none", 1)
    }

    adw_init()
    Once.done = true
}

/// Runs a few iterations of the GLib main loop to flush idle/destroy work.
@MainActor
func spinMainLoop(iterations: Int = 10) {
    guard iterations > 0 else { return }
    let context = g_main_context_default()
    for _ in 0 ..< iterations {
        while g_main_context_pending(context) != 0 {
            g_main_context_iteration(context, 0)
        }
        g_main_context_iteration(context, 0)
    }
}

/// Runs a test body and then drains the GLib main loop after local GTK objects
/// have gone out of scope, which helps async destroy/finalize work complete.
@MainActor
func withMainLoopDrain<T>(iterations: Int = 20, _ body: () throws -> T) rethrows -> T {
    let result = try body()
    spinMainLoop(iterations: iterations)
    return result
}

actor BoolRecorder {
    private var value = false

    func mark() {
        value = true
    }

    func snapshot() -> Bool {
        value
    }
}

struct CapturedAttribute {
    let type: PangoAttrType
    let start: Int
    let end: Int
}

private final class CapturedAttributeBox {
    var values: [CapturedAttribute] = []
}

@MainActor
func capturedAttributes(in attrs: TextAttributes?) -> [CapturedAttribute] {
    guard let attrs else { return [] }

    let box = Unmanaged.passRetained(CapturedAttributeBox()).toOpaque()
    let removed = pango_attr_list_filter(
        attrs.pointer,
        { attribute, userData in
            guard let attribute, let userData else { return 0 }
            let box = Unmanaged<CapturedAttributeBox>.fromOpaque(userData).takeUnretainedValue()
            let type = attribute.pointee.klass.pointee.type
            box.values.append(
                CapturedAttribute(
                    type: type,
                    start: Int(attribute.pointee.start_index),
                    end: Int(attribute.pointee.end_index)
                )
            )
            return 0
        },
        box
    )
    if let removed {
        pango_attr_list_unref(removed)
    }
    return Unmanaged<CapturedAttributeBox>.fromOpaque(box).takeRetainedValue().values
}
