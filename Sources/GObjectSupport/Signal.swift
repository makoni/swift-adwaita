import CAdwaita

/// Represents a connected signal that can be disconnected later.
///
/// ```swift
/// let conn = SignalHelper.connect(button, signal: .clicked) {
///     print("Button was clicked")
/// }
/// // Later, disconnect:
/// conn.disconnect()
/// ```
public final class SignalConnection: @unchecked Sendable {
    private let handlerID: gulong
    private weak var source: GObjectRef?

    init(handlerID: gulong, source: GObjectRef) {
        self.handlerID = handlerID
        self.source = source
    }

    /// Disconnects this signal handler.
    @MainActor
    public func disconnect() {
        guard let source else { return }
        g_signal_handler_disconnect(source.pointer, handlerID)
    }
}

/// Internal box to capture a Swift closure and pass it through C callback user data.
final class ClosureBox<T>: @unchecked Sendable {
    let closure: T
    init(_ closure: T) { self.closure = closure }
}

/// Helpers for connecting GObject signals to Swift closures.
///
/// Provides type-safe overloads for the most common signal parameter
/// signatures. Each method boxes the Swift closure, connects it to
/// the GObject signal system, and returns a ``SignalConnection`` for
/// later disconnection.
///
/// ```swift
/// // No-parameter signal
/// SignalHelper.connect(button, signal: .clicked) {
///     print("Clicked!")
/// }
///
/// // Signal with a String parameter
/// SignalHelper.connectString(entry, signal: .changed) { text in
///     print("Text is now: \(text)")
/// }
///
/// // Observe property changes
/// SignalHelper.onNotify(spinRow, property: .value) {
///     print("Value changed")
/// }
/// ```
@MainActor
public enum SignalHelper {

    // MARK: - Internal connect helper

    /// Core helper that connects a signal with a given trampoline and boxed closure.
    @discardableResult
    static func connectRaw(
        _ instance: GObjectRef,
        signal: SignalName,
        trampoline: GCallback?,
        box: AnyObject
    ) -> SignalConnection {
        let boxPtr = Unmanaged.passRetained(box).toOpaque()

        let handlerID = g_signal_connect_data(
            instance.pointer,
            signal.name,
            trampoline,
            boxPtr,
            { userData, _ in
                guard let userData else { return }
                Unmanaged<AnyObject>.fromOpaque(userData).release()
            },
            GConnectFlags(rawValue: 0)
        )

        return SignalConnection(handlerID: handlerID, source: instance)
    }

    // MARK: - No parameters

    /// Connects a signal that takes no parameters.
    ///
    /// Automatically detects `notify` signals and uses the correct
    /// trampoline signature (which includes a `GParamSpec` parameter).
    @discardableResult
    public static func connect(
        _ instance: GObjectRef,
        signal: SignalName,
        handler: @escaping @MainActor () -> Void
    ) -> SignalConnection {
        let trampoline: GCallback
        if signal.isNotify {
            // notify signals pass (instance, GParamSpec*, userData)
            trampoline = unsafeBitCast(
                signalTrampolineNotify as @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void,
                to: GCallback.self
            )
        } else {
            trampoline = unsafeBitCast(
                signalTrampoline0 as @convention(c) (UnsafeMutableRawPointer, UnsafeMutableRawPointer) -> Void,
                to: GCallback.self
            )
        }
        return connectRaw(
            instance, signal: signal,
            trampoline: trampoline,
            box: ClosureBox(handler)
        )
    }

    // MARK: - Single parameter

    /// Connects a signal with a single `String` parameter.
    @discardableResult
    public static func connectString(
        _ instance: GObjectRef,
        signal: SignalName,
        handler: @escaping @MainActor (String) -> Void
    ) -> SignalConnection {
        connectRaw(
            instance, signal: signal,
            trampoline: unsafeBitCast(
                signalTrampolineString as @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CChar>, UnsafeMutableRawPointer) -> Void,
                to: GCallback.self
            ),
            box: ClosureBox(handler)
        )
    }

    /// Connects a signal with a single `UInt32` parameter.
    @discardableResult
    public static func connectUInt(
        _ instance: GObjectRef,
        signal: SignalName,
        handler: @escaping @MainActor (UInt32) -> Void
    ) -> SignalConnection {
        connectRaw(
            instance, signal: signal,
            trampoline: unsafeBitCast(
                signalTrampolineUInt as @convention(c) (UnsafeMutableRawPointer, UInt32, UnsafeMutableRawPointer) -> Void,
                to: GCallback.self
            ),
            box: ClosureBox(handler)
        )
    }

    /// Connects a signal with a single `Int32` parameter.
    @discardableResult
    public static func connectInt(
        _ instance: GObjectRef,
        signal: SignalName,
        handler: @escaping @MainActor (Int32) -> Void
    ) -> SignalConnection {
        connectRaw(
            instance, signal: signal,
            trampoline: unsafeBitCast(
                signalTrampolineInt as @convention(c) (UnsafeMutableRawPointer, Int32, UnsafeMutableRawPointer) -> Void,
                to: GCallback.self
            ),
            box: ClosureBox(handler)
        )
    }

    /// Connects a signal with a single `Double` parameter.
    @discardableResult
    public static func connectDouble(
        _ instance: GObjectRef,
        signal: SignalName,
        handler: @escaping @MainActor (Double) -> Void
    ) -> SignalConnection {
        connectRaw(
            instance, signal: signal,
            trampoline: unsafeBitCast(
                signalTrampolineDouble as @convention(c) (UnsafeMutableRawPointer, Double, UnsafeMutableRawPointer) -> Void,
                to: GCallback.self
            ),
            box: ClosureBox(handler)
        )
    }

    /// Connects a signal with a single `Bool` parameter.
    @discardableResult
    public static func connectBool(
        _ instance: GObjectRef,
        signal: SignalName,
        handler: @escaping @MainActor (Bool) -> Void
    ) -> SignalConnection {
        connectRaw(
            instance, signal: signal,
            trampoline: unsafeBitCast(
                signalTrampolineBool as @convention(c) (UnsafeMutableRawPointer, gboolean, UnsafeMutableRawPointer) -> Void,
                to: GCallback.self
            ),
            box: ClosureBox(handler)
        )
    }

    /// Connects a signal with a single C enum parameter (UInt32 raw value).
    @discardableResult
    public static func connectEnum<E: RawRepresentable>(
        _ instance: GObjectRef,
        signal: SignalName,
        handler: @escaping @MainActor (E) -> Void
    ) -> SignalConnection where E.RawValue == UInt32 {
        connectRaw(
            instance, signal: signal,
            trampoline: unsafeBitCast(
                signalTrampolineUInt as @convention(c) (UnsafeMutableRawPointer, UInt32, UnsafeMutableRawPointer) -> Void,
                to: GCallback.self
            ),
            box: ClosureBox<@MainActor (UInt32) -> Void>({ raw in
                if let value = E(rawValue: raw) {
                    handler(value)
                }
            })
        )
    }

    /// Connects a signal with a single C enum parameter (Int32 raw value).
    @discardableResult
    public static func connectEnum<E: RawRepresentable>(
        _ instance: GObjectRef,
        signal: SignalName,
        handler: @escaping @MainActor (E) -> Void
    ) -> SignalConnection where E.RawValue == Int32 {
        connectRaw(
            instance, signal: signal,
            trampoline: unsafeBitCast(
                signalTrampolineInt as @convention(c) (UnsafeMutableRawPointer, Int32, UnsafeMutableRawPointer) -> Void,
                to: GCallback.self
            ),
            box: ClosureBox<@MainActor (Int32) -> Void>({ raw in
                if let value = E(rawValue: raw) {
                    handler(value)
                }
            })
        )
    }

    /// Connects a signal with a single `OpaquePointer` parameter (opaque GObject types).
    @discardableResult
    public static func connectPointer(
        _ instance: GObjectRef,
        signal: SignalName,
        handler: @escaping @MainActor (OpaquePointer) -> Void
    ) -> SignalConnection {
        connectRaw(
            instance, signal: signal,
            trampoline: unsafeBitCast(
                signalTrampolinePointer as @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void,
                to: GCallback.self
            ),
            box: ClosureBox(handler)
        )
    }

    // MARK: - Two parameters

    /// Connects a signal with two `Double` parameters.
    @discardableResult
    public static func connectDoubleDouble(
        _ instance: GObjectRef,
        signal: SignalName,
        handler: @escaping @MainActor (Double, Double) -> Void
    ) -> SignalConnection {
        connectRaw(
            instance, signal: signal,
            trampoline: unsafeBitCast(
                signalTrampolineDoubleDouble as @convention(c) (UnsafeMutableRawPointer, Double, Double, UnsafeMutableRawPointer) -> Void,
                to: GCallback.self
            ),
            box: ClosureBox(handler)
        )
    }

    /// Connects a signal with two `UInt32` parameters.
    @discardableResult
    public static func connectUIntUInt(
        _ instance: GObjectRef,
        signal: SignalName,
        handler: @escaping @MainActor (UInt32, UInt32) -> Void
    ) -> SignalConnection {
        connectRaw(
            instance, signal: signal,
            trampoline: unsafeBitCast(
                signalTrampolineUIntUInt as @convention(c) (UnsafeMutableRawPointer, UInt32, UInt32, UnsafeMutableRawPointer) -> Void,
                to: GCallback.self
            ),
            box: ClosureBox(handler)
        )
    }

    /// Connects a signal with `OpaquePointer` + `Int32` parameters.
    @discardableResult
    public static func connectPointerInt(
        _ instance: GObjectRef,
        signal: SignalName,
        handler: @escaping @MainActor (OpaquePointer, Int32) -> Void
    ) -> SignalConnection {
        connectRaw(
            instance, signal: signal,
            trampoline: unsafeBitCast(
                signalTrampolinePointerInt as @convention(c) (UnsafeMutableRawPointer, OpaquePointer, Int32, UnsafeMutableRawPointer) -> Void,
                to: GCallback.self
            ),
            box: ClosureBox(handler)
        )
    }

    // MARK: - Three parameters

    /// Connects a signal with `Int32`, `Double`, `Double` parameters.
    /// Used for gesture pressed/released signals (n_press, x, y).
    @discardableResult
    public static func connectIntDoubleDouble(
        _ instance: GObjectRef,
        signal: SignalName,
        handler: @escaping @MainActor (Int32, Double, Double) -> Void
    ) -> SignalConnection {
        connectRaw(
            instance, signal: signal,
            trampoline: unsafeBitCast(
                signalTrampolineIntDoubleDouble as @convention(c) (UnsafeMutableRawPointer, Int32, Double, Double, UnsafeMutableRawPointer) -> Void,
                to: GCallback.self
            ),
            box: ClosureBox(handler)
        )
    }

    /// Connects a signal with `UInt32`, `UInt32`, `UInt32` parameters returning `Bool`.
    /// Used for key-pressed signals (keyval, keycode, state).
    @discardableResult
    public static func connectUIntUIntUIntReturnBool(
        _ instance: GObjectRef,
        signal: SignalName,
        handler: @escaping @MainActor (UInt32, UInt32, UInt32) -> Bool
    ) -> SignalConnection {
        connectRaw(
            instance, signal: signal,
            trampoline: unsafeBitCast(
                signalTrampolineUIntUIntUIntBool as @convention(c) (UnsafeMutableRawPointer, UInt32, UInt32, UInt32, UnsafeMutableRawPointer) -> gboolean,
                to: GCallback.self
            ),
            box: ClosureBox(handler)
        )
    }

    /// Connects a signal with `UInt32`, `UInt32`, `UInt32` parameters.
    /// Used for key-released signals (keyval, keycode, state).
    @discardableResult
    public static func connectUIntUIntUInt(
        _ instance: GObjectRef,
        signal: SignalName,
        handler: @escaping @MainActor (UInt32, UInt32, UInt32) -> Void
    ) -> SignalConnection {
        connectRaw(
            instance, signal: signal,
            trampoline: unsafeBitCast(
                signalTrampolineUIntUIntUInt as @convention(c) (UnsafeMutableRawPointer, UInt32, UInt32, UInt32, UnsafeMutableRawPointer) -> Void,
                to: GCallback.self
            ),
            box: ClosureBox(handler)
        )
    }

    // MARK: - No-parameter signal returning Bool

    /// Connects a signal that takes no parameters and returns a Bool (gboolean).
    /// Useful for signals like `close-request` where returning `true` prevents the default behavior.
    @discardableResult
    public static func connectReturnBool(
        _ instance: GObjectRef,
        signal: SignalName,
        handler: @escaping @MainActor () -> Bool
    ) -> SignalConnection {
        connectRaw(
            instance, signal: signal,
            trampoline: unsafeBitCast(
                signalTrampolineReturnBool as @convention(c) (UnsafeMutableRawPointer, UnsafeMutableRawPointer) -> gboolean,
                to: GCallback.self
            ),
            box: ClosureBox(handler)
        )
    }

    // MARK: - Signals returning Bool

    /// Connects a signal with two `Double` parameters returning `Bool`.
    /// Used for scroll signals (dx, dy).
    @discardableResult
    public static func connectDoubleDoubleReturnBool(
        _ instance: GObjectRef,
        signal: SignalName,
        handler: @escaping @MainActor (Double, Double) -> Bool
    ) -> SignalConnection {
        connectRaw(
            instance, signal: signal,
            trampoline: unsafeBitCast(
                signalTrampolineDoubleDoubleBool as @convention(c) (UnsafeMutableRawPointer, Double, Double, UnsafeMutableRawPointer) -> gboolean,
                to: GCallback.self
            ),
            box: ClosureBox(handler)
        )
    }

    // MARK: - Signals with GValue parameter and return value

    /// Connects a signal with `(OpaquePointer, GValue)` params returning `Bool`.
    /// Used for `extra-drag-drop` signals.
    @discardableResult
    public static func connectPointerGValueReturnBool(
        _ instance: GObjectRef,
        signal: SignalName,
        handler: @escaping @MainActor (OpaquePointer, UnsafePointer<GValue>) -> Bool
    ) -> SignalConnection {
        connectRaw(
            instance, signal: signal,
            trampoline: unsafeBitCast(
                signalTrampolinePointerGValueBool as @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafePointer<GValue>, UnsafeMutableRawPointer) -> gboolean,
                to: GCallback.self
            ),
            box: ClosureBox(handler)
        )
    }

    /// Connects a signal with `(OpaquePointer, GValue)` params returning `GdkDragAction`.
    /// Used for `extra-drag-value` signals.
    @discardableResult
    public static func connectPointerGValueReturnGdkDragAction(
        _ instance: GObjectRef,
        signal: SignalName,
        handler: @escaping @MainActor (OpaquePointer, UnsafePointer<GValue>) -> GdkDragAction
    ) -> SignalConnection {
        connectRaw(
            instance, signal: signal,
            trampoline: unsafeBitCast(
                signalTrampolinePointerGValueDragAction as @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafePointer<GValue>, UnsafeMutableRawPointer) -> GdkDragAction,
                to: GCallback.self
            ),
            box: ClosureBox(handler)
        )
    }

    // MARK: - Property notification

    /// Connects to `notify::property-name` to observe property changes.
    ///
    /// The `notify` signal has the C signature `(GObject*, GParamSpec*, gpointer)`.
    /// This uses a dedicated 3-arg trampoline that ignores the GParamSpec.
    @discardableResult
    public static func onNotify(
        _ instance: GObjectRef,
        property: PropertyName,
        handler: @escaping @MainActor () -> Void
    ) -> SignalConnection {
        connectRaw(
            instance, signal: .notify(property.name),
            trampoline: unsafeBitCast(
                signalTrampolineNotify as @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void,
                to: GCallback.self
            ),
            box: ClosureBox(handler)
        )
    }
}
