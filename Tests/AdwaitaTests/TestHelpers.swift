import Testing
@testable import Adwaita
import CAdwaita

/// Helper to verify subclass relationships at runtime.
@MainActor
func isSubclass<Sub: AnyObject, Super: AnyObject>(_: Sub.Type, of _: Super.Type) -> Bool {
    Sub.self is Super.Type
}

/// One-time GTK/Adw init for tests that instantiate widgets.
@MainActor
func ensureAdwInit() {
    struct Once { nonisolated(unsafe) static var done = false }
    guard !Once.done else { return }
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
