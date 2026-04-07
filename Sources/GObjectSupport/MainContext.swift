import CAdwaita

/// A GLib main loop source identifier returned by timeout/idle functions.
public typealias SourceID = UInt32

/// Helpers for integrating with the GLib main loop.
@MainActor
public enum MainContext {

    /// Cancels a source previously scheduled on the GLib main loop.
    ///
    /// Pass the source ID returned by `timeout(intervalMs:_:)`.
    ///
    /// ```swift
    /// let id = MainContext.timeout(intervalMs: 1000) { true }
    /// // Later:
    /// MainContext.cancel(sourceId: id)
    /// ```
    /// - Returns: `true` if the source was found and removed.
    @discardableResult
    public static func cancel(sourceId: SourceID) -> Bool {
        g_source_remove(sourceId) != 0
    }

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
                return 0 // G_SOURCE_REMOVE — run once
            },
            box,
            { userData in
                scheduleDeferredBoxRelease(userData)
            }
        )
    }

    /// Schedules a one-shot delayed closure on the GLib main loop.
    ///
    /// - Parameters:
    ///   - ms: The delay in milliseconds.
    ///   - closure: The work to perform after the delay.
    public static func delay(ms: UInt32, _ closure: @escaping @MainActor () -> Void) {
        timeout(intervalMs: ms) { closure()
            return false
        }
    }

    /// Schedules a repeating timeout on the GLib main loop.
    ///
    /// - Parameters:
    ///   - intervalMs: The interval in milliseconds.
    ///   - closure: The work to perform. Return `true` to continue, `false` to stop.
    /// - Returns: A `SourceID` that can be passed to `cancel(sourceId:)`.
    @discardableResult
    public static func timeout(intervalMs: UInt32, _ closure: @escaping @MainActor () -> Bool) -> SourceID {
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
                scheduleDeferredBoxRelease(userData)
            }
        )
    }
}
