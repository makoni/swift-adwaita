import CAdwaita
import GObjectSupport

/// Recognizes drag gestures on a widget.
///
/// Wraps `GtkGestureDrag`. Reports the start point and ongoing offset as
/// the user drags the pointer. Attach to a widget with `addController()`.
///
/// ```swift
/// let drag = GestureDrag()
/// drag.onDragBegin { startX, startY in
///     print("Drag started at (\(startX), \(startY))")
/// }
/// drag.onDragUpdate { offsetX, offsetY in
///     print("Dragged by (\(offsetX), \(offsetY))")
/// }
/// drag.onDragEnd { offsetX, offsetY in
///     print("Drag ended, total offset: (\(offsetX), \(offsetY))")
/// }
/// canvas.addController(drag)
/// ```
@MainActor
public final class GestureDrag: GObjectRef {
    /// Creates a new drag gesture recognizer.
    public init() {
        let ptr = gtk_gesture_drag_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Returns the start point of the current drag, or nil if no drag is active.
    public var startPoint: (x: Double, y: Double)? {
        var x: Double = 0
        var y: Double = 0
        guard gtk_gesture_drag_get_start_point(opaquePointer, &x, &y) != 0 else { return nil }
        return (x, y)
    }

    /// Returns the offset from the start point, or nil if no drag is active.
    public var offset: (x: Double, y: Double)? {
        var x: Double = 0
        var y: Double = 0
        guard gtk_gesture_drag_get_offset(opaquePointer, &x, &y) != 0 else { return nil }
        return (x, y)
    }

    /// Emitted when a drag is started.
    ///
    /// - Parameter handler: Called when the drag begins. Receives the start x and start y coordinates.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onDragBegin(_ handler: @escaping @MainActor (Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectDoubleDouble(self, signal: .dragBegin, handler: handler)
    }

    /// Emitted when the drag moves.
    ///
    /// - Parameter handler: Called as the drag moves. Receives the offset x and offset y from the start point.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onDragUpdate(_ handler: @escaping @MainActor (Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectDoubleDouble(self, signal: .dragUpdate, handler: handler)
    }

    /// Emitted when the drag finishes.
    ///
    /// - Parameter handler: Called when the drag ends. Receives the offset x and offset y from the start point.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onDragEnd(_ handler: @escaping @MainActor (Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectDoubleDouble(self, signal: .dragEnd, handler: handler)
    }
}
