import CAdwaita
import Foundation
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

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a drop target that accepts text.
    public static func forText(actions: GdkDragAction = GDK_ACTION_COPY) -> DropTarget {
        DropTarget(type: cadw_type_string(), actions: actions)
    }

    /// Creates a drop target that accepts one or more dropped files.
    public static func forFiles(actions: GdkDragAction = GDK_ACTION_COPY) -> DropTarget {
        DropTarget(type: gdk_file_list_get_type(), actions: actions)
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

    /// Returns the dropped files as local file URLs, if available.
    public var droppedFiles: [URL] {
        guard let value = gtk_drop_target_get_value(opaquePointer) else { return [] }
        return droppedFileURLs(from: value)
    }

    /// Rejects the current drop.
    public func reject() {
        gtk_drop_target_reject(opaquePointer)
    }

    /// Emitted when data is dropped on the widget.
    ///
    /// - Parameter handler: Called when a drop occurs. Receives the dropped text (or nil). Return `true` to accept the
    /// drop.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onDrop(_ handler: @escaping @MainActor (String?) -> Bool) -> SignalConnection {
        // The "drop" signal has signature (GtkDropTarget, GValue, double, double) -> gboolean
        SignalHelper.connectCustom(
            self,
            signal: .drop,
            trampoline: unsafeBitCast(
                dropTrampoline as @convention(c) (
                    UnsafeMutableRawPointer,
                    UnsafePointer<GValue>,
                    Double,
                    Double,
                    UnsafeMutableRawPointer
                ) -> gboolean,
                to: GCallback.self
            ),
            box: PublicClosureBox(handler)
        )
    }

    /// Emitted when file URLs are dropped on the widget.
    ///
    /// - Parameter handler: Called when a drop occurs. Receives local file URLs. Return `true` to accept the drop.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onDropFiles(_ handler: @escaping @MainActor ([URL]) -> Bool) -> SignalConnection {
        SignalHelper.connectCustom(
            self,
            signal: .drop,
            trampoline: unsafeBitCast(
                fileDropTrampoline as @convention(c) (
                    UnsafeMutableRawPointer,
                    UnsafePointer<GValue>,
                    Double,
                    Double,
                    UnsafeMutableRawPointer
                ) -> gboolean,
                to: GCallback.self
            ),
            box: PublicClosureBox(handler)
        )
    }

    /// Emitted when the pointer enters the widget during a drag.
    ///
    /// GTK expects the handler for `GtkDropTarget::enter` to return a single
    /// preferred `GdkDragAction` (not a mask). The void-returning overload
    /// installs a handler that tries to pick one bit from the target's
    /// ``actions`` mask automatically, so existing callers just get the drop
    /// accepted without a `did not return a unique preferred action`
    /// critical. If you need to reject the drop or choose a specific action
    /// based on the pointer position, use ``onEnter(preferredAction:)``.
    ///
    /// - Parameter handler: Called when the pointer enters. Receives the x and y coordinates.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onEnter(_ handler: @escaping @MainActor (Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectDoubleDoubleReturnGdkDragAction(self, signal: .enter) { [weak self] x, y in
            handler(x, y)
            return self?.preferredAction ?? GDK_ACTION_COPY
        }
    }

    /// Same as ``onEnter(_:)`` but the handler decides which single action
    /// to prefer for the incoming drop.
    ///
    /// Return `GDK_ACTION_COPY`, `GDK_ACTION_MOVE`, or `GDK_ACTION_LINK` to
    /// accept with that action; return a value with no bits set to reject.
    @discardableResult
    public func onEnter(preferredAction handler: @escaping @MainActor (Double, Double) -> GdkDragAction)
        -> SignalConnection {
        SignalHelper.connectDoubleDoubleReturnGdkDragAction(self, signal: .enter, handler: handler)
    }

    /// Emitted when the pointer leaves the widget during a drag.
    ///
    /// - Parameter handler: Called when the pointer leaves.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onLeave(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .leave, handler: handler)
    }

    /// Emitted when the pointer moves over the widget during a drag.
    ///
    /// Like ``onEnter(_:)``, GTK expects the handler for
    /// `GtkDropTarget::motion` to return a single preferred `GdkDragAction`.
    /// The void-returning overload auto-picks one from the target's
    /// ``actions`` mask.
    ///
    /// - Parameter handler: Called when the pointer moves. Receives the x and y coordinates.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onMotion(_ handler: @escaping @MainActor (Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectDoubleDoubleReturnGdkDragAction(self, signal: .motion) { [weak self] x, y in
            handler(x, y)
            return self?.preferredAction ?? GDK_ACTION_COPY
        }
    }

    /// Same as ``onMotion(_:)`` but the handler decides which single action
    /// to prefer as the pointer moves.
    @discardableResult
    public func onMotion(preferredAction handler: @escaping @MainActor (Double, Double) -> GdkDragAction)
        -> SignalConnection {
        SignalHelper.connectDoubleDoubleReturnGdkDragAction(self, signal: .motion, handler: handler)
    }

    /// First action bit set in ``actions`` (COPY → MOVE → LINK). Used as the
    /// default return value for the void-returning `onEnter`/`onMotion`
    /// overloads when the handler doesn't express a choice itself.
    private var preferredAction: GdkDragAction {
        let mask = actions.rawValue
        if mask & GDK_ACTION_COPY.rawValue != 0 { return GDK_ACTION_COPY }
        if mask & GDK_ACTION_MOVE.rawValue != 0 { return GDK_ACTION_MOVE }
        if mask & GDK_ACTION_LINK.rawValue != 0 { return GDK_ACTION_LINK }
        return GDK_ACTION_COPY
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
    struct WrappedGValue: @unchecked Sendable { let ptr: UnsafePointer<GValue> }
    let wrapped = WrappedGValue(ptr: value)
    return MainActor.assumeIsolated {
        let text: String? = if cadw_value_holds_string(wrapped.ptr) != 0 {
            g_value_get_string(wrapped.ptr).map { String(cString: $0) }
        } else {
            nil
        }
        return box.closure(text) ? 1 : 0
    }
}

private func fileDropTrampoline(
    _ instance: UnsafeMutableRawPointer,
    _ value: UnsafePointer<GValue>,
    _ x: Double,
    _ y: Double,
    _ userData: UnsafeMutableRawPointer
) -> gboolean {
    let box = Unmanaged<PublicClosureBox<@MainActor ([URL]) -> Bool>>.fromOpaque(userData)
        .takeUnretainedValue()
    struct WrappedGValue: @unchecked Sendable { let ptr: UnsafePointer<GValue> }
    let wrapped = WrappedGValue(ptr: value)
    return MainActor.assumeIsolated {
        let files = droppedFileURLs(from: wrapped.ptr)
        return box.closure(files) ? 1 : 0
    }
}

private func droppedFileURLs(from value: UnsafePointer<GValue>) -> [URL] {
    guard let fileList = cadw_value_get_file_list(value) else { return [] }
    guard let files = gdk_file_list_get_files(fileList) else { return [] }
    defer { g_slist_free(files) }

    var urls: [URL] = []
    var node: UnsafeMutablePointer<GSList>? = files
    while let current = node {
        if let data = current.pointee.data {
            let file = OpaquePointer(data)
            if let path = g_file_get_path(file) {
                urls.append(URL(fileURLWithPath: String(cString: path)))
                g_free(path)
            }
        }
        node = current.pointee.next
    }
    return urls
}
