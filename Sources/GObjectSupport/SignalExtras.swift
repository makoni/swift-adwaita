import CAdwaita

// MARK: - Public access to connectRaw for downstream modules

extension SignalHelper {

    /// Connects a signal with a custom trampoline and boxed closure.
    ///
    /// This is the public variant of `connectRaw` for use by downstream modules
    /// that need to connect signals with custom parameter signatures.
    @discardableResult
    public static func connectCustom(
        _ instance: GObjectRef,
        signal: String,
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
