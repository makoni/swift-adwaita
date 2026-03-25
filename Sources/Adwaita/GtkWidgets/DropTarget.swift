import CAdwaita
import GObjectSupport

/// A controller for accepting drop operations on a widget.
///
/// Wraps `GtkDropTarget`. Attach to a widget with `addController()` to make
/// it a drop destination for drag-and-drop. Use the convenience factory
/// ``forText(actions:)`` for simple text drops.
///
/// ```swift
/// let dropTarget = DropTarget.forText()
/// dropTarget.onDrop { text in
///     if let text {
///         print("Dropped text: \(text)")
///     }
///     return true  // accept the drop
/// }
/// dropTarget.onEnter { x, y in
///     print("Drag entered at (\(x), \(y))")
/// }
/// dropTarget.onLeave {
///     print("Drag left the widget")
/// }
/// label.addController(dropTarget)
/// ```
@MainActor
public final class DropTarget: GObjectRef {
    /// Creates a new drop target that accepts the given GType with the given actions.
    ///
    /// For text drops, use `cadw_type_string()` as the type and `GDK_ACTION_COPY` as actions.
    public init(type: GType, actions: GdkDragAction) {
        let ptr = gtk_drop_target_new(type, actions)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a drop target that accepts text.
    public static func forText(actions: GdkDragAction = GDK_ACTION_COPY) -> DropTarget {
        DropTarget(type: cadw_type_string(), actions: actions)
    }

    /// The allowed drop actions.
    public var actions: GdkDragAction {
        get { gtk_drop_target_get_actions(opaquePointer) }
        set { gtk_drop_target_set_actions(opaquePointer, newValue) }
    }

    /// Whether to preload the drop data.
    public var preload: Bool {
        get { gtk_drop_target_get_preload(opaquePointer) != 0 }
        set { gtk_drop_target_set_preload(opaquePointer, newValue ? 1 : 0) }
    }

    /// Returns the dropped value as a string, if available.
    public var droppedText: String? {
        guard let value = gtk_drop_target_get_value(opaquePointer) else { return nil }
        guard cadw_value_holds_string(value) != 0 else { return nil }
        return g_value_get_string(value).map { String(cString: $0) }
    }

    /// Rejects the current drop.
    public func reject() {
        gtk_drop_target_reject(opaquePointer)
    }

    /// Emitted when data is dropped on the widget.
    ///
    /// - Parameter handler: Called when a drop occurs. Receives the dropped text (or nil). Return `true` to accept the drop.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onDrop(_ handler: @escaping @MainActor (String?) -> Bool) -> SignalConnection {
        // The "drop" signal has signature (GtkDropTarget, GValue, double, double) -> gboolean
        SignalHelper.connectCustom(
            self,
            signal: .drop,
            trampoline: unsafeBitCast(
                dropTrampoline as @convention(c) (UnsafeMutableRawPointer, UnsafePointer<GValue>, Double, Double, UnsafeMutableRawPointer) -> gboolean,
                to: GCallback.self
            ),
            box: PublicClosureBox(handler)
        )
    }

    /// Emitted when the pointer enters the widget during a drag.
    ///
    /// - Parameter handler: Called when the pointer enters. Receives the x and y coordinates.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onEnter(_ handler: @escaping @MainActor (Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectDoubleDouble(self, signal: .enter) { x, y in handler(x, y) }
    }

    /// Emitted when the pointer leaves the widget during a drag.
    ///
    /// - Parameter handler: Called when the pointer leaves.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onLeave(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .leave, handler: handler)
    }

    /// Emitted when the pointer moves over the widget during a drag.
    ///
    /// - Parameter handler: Called when the pointer moves. Receives the x and y coordinates.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onMotion(_ handler: @escaping @MainActor (Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectDoubleDouble(self, signal: .motion) { x, y in handler(x, y) }
    }
}

// MARK: - Trampoline for the drop signal

private func dropTrampoline(
    _ instance: UnsafeMutableRawPointer,
    _ value: UnsafePointer<GValue>,
    _ x: Double,
    _ y: Double,
    _ userData: UnsafeMutableRawPointer
) -> gboolean {
    let box = Unmanaged<PublicClosureBox<@MainActor (String?) -> Bool>>.fromOpaque(userData)
        .takeUnretainedValue()
    nonisolated(unsafe) let capturedValue = value
    return MainActor.assumeIsolated {
        let text: String?
        if cadw_value_holds_string(capturedValue) != 0 {
            text = g_value_get_string(capturedValue).map { String(cString: $0) }
        } else {
            text = nil
        }
        return box.closure(text) ? 1 : 0
    }
}
