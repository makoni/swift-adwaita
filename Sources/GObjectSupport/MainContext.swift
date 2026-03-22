import CAdwaita

/// Helpers for integrating with the GLib main loop.
@MainActor
public enum MainContext {

    /// Schedules a closure to run on the next iteration of the GLib main loop.
    ///
    /// This is the primary way to dispatch work to the GTK main thread
    /// from asynchronous Swift code. The closure runs on the main thread
    /// during `g_main_context_iteration`.
    ///
    /// - Parameter closure: The work to perform on the main thread.
    public static func idle(_ closure: @escaping @MainActor () -> Void) {
        let box = Unmanaged.passRetained(ClosureBox(closure)).toOpaque()
        g_idle_add_full(
            G_PRIORITY_DEFAULT_IDLE,
            { userData -> gboolean in
                guard let userData else { return 0 }
                let box = Unmanaged<ClosureBox<@MainActor () -> Void>>
                    .fromOpaque(userData).takeUnretainedValue()
                MainActor.assumeIsolated {
                    box.closure()
                }
                return 0  // G_SOURCE_REMOVE — run once
            },
            box,
            { userData in
                guard let userData else { return }
                Unmanaged<AnyObject>.fromOpaque(userData).release()
            }
        )
    }

    /// Schedules a one-shot delayed closure on the GLib main loop.
    ///
    /// - Parameters:
    ///   - ms: The delay in milliseconds.
    ///   - closure: The work to perform after the delay.
    public static func delay(ms: UInt32, _ closure: @escaping @MainActor () -> Void) {
        timeout(intervalMs: ms) { closure(); return false }
    }

    /// Schedules a repeating timeout on the GLib main loop.
    ///
    /// - Parameters:
    ///   - intervalMs: The interval in milliseconds.
    ///   - closure: The work to perform. Return `true` to continue, `false` to stop.
    /// - Returns: The source ID (can be used with `g_source_remove` to cancel).
    @discardableResult
    public static func timeout(intervalMs: UInt32, _ closure: @escaping @MainActor () -> Bool) -> UInt32 {
        let box = Unmanaged.passRetained(ClosureBox(closure)).toOpaque()
        return g_timeout_add_full(
            G_PRIORITY_DEFAULT,
            intervalMs,
            { userData -> gboolean in
                guard let userData else { return 0 }
                let box = Unmanaged<ClosureBox<@MainActor () -> Bool>>
                    .fromOpaque(userData).takeUnretainedValue()
                return MainActor.assumeIsolated {
                    box.closure() ? 1 : 0
                }
            },
            box,
            { userData in
                guard let userData else { return }
                Unmanaged<AnyObject>.fromOpaque(userData).release()
            }
        )
    }
}
