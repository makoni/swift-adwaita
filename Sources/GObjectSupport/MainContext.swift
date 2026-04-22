import CAdwaita

/// A GLib main loop source identifier returned by timeout/idle functions.
public typealias SourceID = UInt32

/// Helpers for scheduling work on the GLib main loop.
///
/// GTK applications run GLib's event loop (`g_application_run`), **not**
/// Swift's dispatch main queue.  `Task { @MainActor in … }` schedules on
/// `DispatchQueue.main`, which is never drained inside the GLib loop —
/// the task body simply never executes.
///
/// Use the methods on this enum instead:
///
/// | Instead of                         | Use                              |
/// |------------------------------------|----------------------------------|
/// | `Task { @MainActor in work() }`    | `MainContext.task { work() }`    |
/// | `Task.sleep(for: .seconds(1))`     | `await MainContext.sleep(for: .seconds(1))` |
/// | recurring `Task` + `Task.sleep`    | `MainContext.task(every: ...)`   |
///
/// All closures are `@MainActor`-isolated and run on the GLib main thread.
@MainActor
public enum MainContext {

    /// A cancellable scheduled unit of work running on the GLib main loop.
    ///
    /// This provides a Task-like API surface for GTK applications, but schedules
    /// through GLib instead of `DispatchQueue.main`.
    @MainActor
    public final class Task {
        private var sourceId: SourceID?

        /// Whether the task is still scheduled.
        public var isScheduled: Bool {
            sourceId != nil
        }

        /// Schedules a one-shot task on the next GLib main loop iteration.
        public init(
            priority: Int32 = G_PRIORITY_DEFAULT_IDLE,
            _ operation: @escaping @MainActor () -> Void
        ) {
            sourceId = MainContext.idleSource(priority: priority) { [weak self] in
                self?.sourceId = nil
                operation()
            }
        }

        /// Schedules a one-shot delayed task on the GLib main loop.
        public init(
            after delay: Duration,
            priority: Int32 = G_PRIORITY_DEFAULT,
            _ operation: @escaping @MainActor () -> Void
        ) {
            sourceId = MainContext.timeoutSource(
                intervalMs: MainContext.milliseconds(from: delay),
                priority: priority
            ) { [weak self] in
                self?.sourceId = nil
                operation()
                return false
            }
        }

        /// Schedules a repeating task on the GLib main loop.
        public init(
            every interval: Duration,
            priority: Int32 = G_PRIORITY_DEFAULT,
            _ operation: @escaping @MainActor () -> Bool
        ) {
            sourceId = MainContext.timeoutSource(
                intervalMs: MainContext.milliseconds(from: interval),
                priority: priority
            ) { [weak self] in
                let shouldContinue = operation()
                if !shouldContinue {
                    self?.sourceId = nil
                }
                return shouldContinue
            }
        }

        /// Cancels the scheduled task if it has not run yet.
        @discardableResult
        public func cancel() -> Bool {
            guard let sourceId else { return false }
            let cancelled = MainContext.cancel(sourceId: sourceId)
            self.sourceId = nil
            return cancelled
        }
    }

    /// Creates a one-shot task for the next GLib main loop iteration.
    @discardableResult
    public static func task(
        priority: Int32 = G_PRIORITY_DEFAULT_IDLE,
        _ operation: @escaping @MainActor () -> Void
    ) -> Task {
        Task(priority: priority, operation)
    }

    /// Creates a one-shot delayed task on the GLib main loop.
    @discardableResult
    public static func task(
        after delay: Duration,
        priority: Int32 = G_PRIORITY_DEFAULT,
        _ operation: @escaping @MainActor () -> Void
    ) -> Task {
        Task(after: delay, priority: priority, operation)
    }

    /// Creates a repeating task on the GLib main loop.
    @discardableResult
    public static func task(
        every interval: Duration,
        priority: Int32 = G_PRIORITY_DEFAULT,
        _ operation: @escaping @MainActor () -> Bool
    ) -> Task {
        Task(every: interval, priority: priority, operation)
    }

    /// Runs a closure on the next GLib main loop iteration and waits for the result.
    ///
    /// This is the async counterpart to `MainContext.task { ... }`.
    public static func run<T>(
        _ operation: @escaping @MainActor () -> T
    ) async -> T {
        await withCheckedContinuation { continuation in
            task {
                continuation.resume(returning: operation())
            }
        }
    }

    /// Suspends until the next GLib main loop iteration.
    public static func yield() async {
        await withCheckedContinuation { continuation in
            task {
                continuation.resume()
            }
        }
    }

    /// Suspends for the given GLib main loop delay.
    ///
    /// This is the async counterpart to `MainContext.delay(for:_:)`.
    public static func sleep(for delay: Duration) async {
        await withCheckedContinuation { continuation in
            task(after: delay) {
                continuation.resume()
            }
        }
    }

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
    /// Callable from any context (including background threads) because
    /// `g_idle_add_full` is thread-safe; only the closure body is
    /// `@MainActor`-isolated.
    ///
    /// - Parameter closure: The work to perform on the main thread.
    public nonisolated static func idle(_ closure: @escaping @MainActor () -> Void) {
        _ = idleSource(priority: G_PRIORITY_DEFAULT_IDLE, closure)
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

    /// Schedules a one-shot delayed closure on the GLib main loop using `Duration`.
    ///
    /// - Parameters:
    ///   - delay: The delay before the closure runs.
    ///   - closure: The work to perform after the delay.
    public static func delay(for delay: Duration, _ closure: @escaping @MainActor () -> Void) {
        self.delay(ms: milliseconds(from: delay), closure)
    }

    /// Schedules a repeating timeout on the GLib main loop.
    ///
    /// - Parameters:
    ///   - intervalMs: The interval in milliseconds.
    ///   - closure: The work to perform. Return `true` to continue, `false` to stop.
    /// - Returns: A `SourceID` that can be passed to `cancel(sourceId:)`.
    @discardableResult
    public static func timeout(intervalMs: UInt32, _ closure: @escaping @MainActor () -> Bool) -> SourceID {
        timeoutSource(intervalMs: intervalMs, priority: G_PRIORITY_DEFAULT, closure)
    }

    /// Schedules a repeating timeout on the GLib main loop using `Duration`.
    ///
    /// - Parameters:
    ///   - interval: The interval between runs.
    ///   - closure: The work to perform. Return `true` to continue, `false` to stop.
    /// - Returns: A `SourceID` that can be passed to `cancel(sourceId:)`.
    @discardableResult
    public static func timeout(every interval: Duration, _ closure: @escaping @MainActor () -> Bool) -> SourceID {
        timeout(intervalMs: milliseconds(from: interval), closure)
    }

    /// Drains every source that is currently ready on the GLib main loop
    /// and returns immediately.
    ///
    /// Equivalent to repeatedly calling `g_main_context_iteration` with
    /// `may_block = false` until `g_main_context_pending` returns zero.
    /// Non-blocking: if the queue is empty, this returns `0` without
    /// waiting. Intended for tests and other synchronous call sites that
    /// need pending idles/timeouts (including those scheduled by
    /// ``task(_:)``, ``idle(_:)``, and GTK's own destroy machinery) to
    /// run before the next assertion.
    ///
    /// - Returns: The number of iterations that dispatched a source.
    @discardableResult
    public static func drainPending() -> Int {
        let context = g_main_context_default()
        var processed = 0
        while g_main_context_pending(context) != 0 {
            if g_main_context_iteration(context, 0) != 0 {
                processed += 1
            }
        }
        return processed
    }

    /// Drains ready sources, blocking up to `duration` for timeouts that
    /// become ready in the meantime.
    ///
    /// Unlike ``drainPending()``, this waits for newly-armed timeouts — so
    /// `MainContext.task(after: .milliseconds(5)) { ... }` will fire if
    /// `duration` is at least 5 milliseconds. Returns early once at least
    /// one source has fired and the queue is empty again; otherwise runs
    /// for the full `duration`.
    ///
    /// - Parameter duration: The maximum wall-clock time to spend pumping.
    public static func pump(for duration: Duration) {
        guard duration > .zero else {
            drainPending()
            return
        }
        let context = g_main_context_default()
        let clock = ContinuousClock()
        let deadline = clock.now.advanced(by: duration)
        var ranAny = false
        while clock.now < deadline {
            if g_main_context_pending(context) != 0 {
                g_main_context_iteration(context, 0)
                ranAny = true
                continue
            }
            if ranAny { break }
            // Nothing is ready yet — sleep for a short tick and re-check.
            let remaining = deadline - clock.now
            guard remaining > .zero else { break }
            let stepMs = min(UInt32(10), milliseconds(from: remaining))
            if stepMs == 0 { break }
            g_usleep(gulong(stepMs) * 1_000)
        }
    }

    @discardableResult
    private nonisolated static func idleSource(
        priority: Int32,
        _ closure: @escaping @MainActor () -> Void
    ) -> SourceID {
        let box = Unmanaged.passRetained(ClosureBox(closure)).toOpaque()
        return g_idle_add_full(
            priority,
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

    @discardableResult
    private static func timeoutSource(
        intervalMs: UInt32,
        priority: Int32,
        _ closure: @escaping @MainActor () -> Bool
    ) -> SourceID {
        let box = Unmanaged.passRetained(ClosureBox(closure)).toOpaque()
        return g_timeout_add_full(
            priority,
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

    private static func milliseconds(from duration: Duration) -> UInt32 {
        let components = duration.components
        let secondsMilliseconds = components.seconds * 1_000
        let attosecondsMilliseconds = components.attoseconds / 1_000_000_000_000_000
        let totalMilliseconds = max(0, secondsMilliseconds + attosecondsMilliseconds)
        return UInt32(clamping: totalMilliseconds)
    }

    /// Installs a GLib log writer that drops the noisy GTK 4 warning
    /// `Trying to snapshot … without a current allocation` coming from
    /// internal `GtkScrolledWindow` / `GtkScrollbar` children.
    ///
    /// This is a known GTK quirk (not caused by application code): at certain
    /// allocation boundaries the scrollbar gizmo temporarily reports itself
    /// as un-allocated and emits a CRITICAL. Apps can't fix it — they can only
    /// stop propagating it to users' terminals. Call this once at app startup
    /// if that noise is bothering you; subsequent calls are no-ops.
    ///
    /// Only the specific snapshot-without-allocation warning whose origin
    /// traces back to a `GtkScrolledWindow` ancestor is suppressed. Everything
    /// else falls through to `g_log_writer_default`.
    public nonisolated static func silenceSpuriousScrollbarWarnings() {
        ScrollbarWarningFilter.installIfNeeded()
    }
}

// MARK: - Scrollbar snapshot warning filter

private enum ScrollbarWarningFilter {
    private static let snapshotFragment = "Trying to snapshot"
    private static let allocationFragment = "without a current allocation"

    private nonisolated(unsafe) static var installed = false

    static func installIfNeeded() {
        guard !installed else { return }
        installed = true
        g_log_set_writer_func(logWriter, nil, nil)
    }

    fileprivate static func isScrolledWindowInternal(message: String) -> Bool {
        guard let pointerString = extractPointer(from: message),
              let address = UInt(pointerString.dropFirst(2), radix: 16),
              let widget = UnsafeMutableRawPointer(bitPattern: address) else {
            return false
        }
        var current: UnsafeMutableRawPointer? = widget
        var depth = 0
        while let ptr = current, depth < 8 {
            let typeName = g_type_name_from_instance(ptr.assumingMemoryBound(to: GTypeInstance.self))
                .map { String(cString: $0) } ?? ""
            if typeName == "GtkScrolledWindow" || typeName == "GtkScrollbar" {
                return true
            }
            let widgetPtr = ptr.assumingMemoryBound(to: GtkWidget.self)
            if let parent = gtk_widget_get_parent(widgetPtr) {
                current = UnsafeMutableRawPointer(parent)
            } else {
                current = nil
            }
            depth += 1
        }
        return false
    }

    private static func extractPointer(from message: String) -> String? {
        guard let range = message.range(of: "0x") else { return nil }
        let tail = message[range.lowerBound...]
        let endIndex = tail.firstIndex(where: { !$0.isHexDigit && $0 != "x" }) ?? tail.endIndex
        return String(tail[..<endIndex])
    }

    fileprivate static func matches(message: String) -> Bool {
        message.contains(snapshotFragment)
            && message.contains(allocationFragment)
            && isScrolledWindowInternal(message: message)
    }
}

private let logWriter: GLogWriterFunc = { level, fields, nFields, _ in
    var messagePointer: UnsafePointer<CChar>? = nil
    for i in 0 ..< Int(nFields) {
        let field = fields!.advanced(by: i).pointee
        if let key = field.key, String(cString: key) == "MESSAGE" {
            messagePointer = field.value?.assumingMemoryBound(to: CChar.self)
            break
        }
    }
    if let messagePointer {
        let message = String(cString: messagePointer)
        if ScrollbarWarningFilter.matches(message: message) {
            return G_LOG_WRITER_HANDLED
        }
    }
    return g_log_writer_default(level, fields, nFields, nil)
}

private extension Character {
    var isHexDigit: Bool {
        isASCII && (isNumber || ("a" ... "f").contains(lowercased().first ?? " "))
    }
}
