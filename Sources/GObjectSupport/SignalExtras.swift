import CAdwaita

// MARK: - Public access to connectRaw for downstream modules

/// Additional signal utilities for advanced and downstream use.
///
/// Provides ``SignalHelper/connectCustom(_:signal:trampoline:box:)``
/// for connecting signals whose parameter signature is not covered by the
/// built-in overloads, and ``PublicClosureBox`` for boxing closures that
/// pass through C callback user data.
///
/// ```swift
/// // Connect a signal with a custom C trampoline
/// let box = PublicClosureBox<@MainActor (Int32) -> Void>({ value in
///     print("Got value: \(value)")
/// })
/// let trampoline: GCallback = unsafeBitCast(
///     myCustomTrampoline, to: GCallback.self
/// )
/// SignalHelper.connectCustom(widget, signal: .custom("my-signal"),
///                            trampoline: trampoline, box: box)
/// ```

extension SignalHelper {

    /// Connects a signal with a custom trampoline and boxed closure.
    ///
    /// This is the public variant of `connectRaw` for use by downstream modules
    /// that need to connect signals with custom parameter signatures.
    @discardableResult
    public static func connectCustom(
        _ instance: GObjectRef,
        signal: SignalName,
        trampoline: GCallback?,
        box: AnyObject
    ) -> SignalConnection {
        connectRaw(instance, signal: signal, trampoline: trampoline, box: box)
    }
}

// MARK: - Public ClosureBox for downstream modules

/// A box to capture a Swift closure and pass it through C callback user data.
/// Public variant for use by downstream modules.
public final class PublicClosureBox<T>: @unchecked Sendable {
    public let closure: T
    public init(_ closure: T) { self.closure = closure }
}
