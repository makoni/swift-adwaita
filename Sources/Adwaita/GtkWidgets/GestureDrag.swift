import CAdwaita
import GObjectSupport

/// Recognizes drag gestures on a widget.
///
/// Wraps `GtkGestureDrag`.
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

    /// Connects to the `drag-begin` signal.
    /// Handler receives: start x, start y.
    @discardableResult
    public func onDragBegin(_ handler: @escaping @MainActor (Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectDoubleDouble(self, signal: .dragBegin, handler: handler)
    }

    /// Connects to the `drag-update` signal.
    /// Handler receives: offset x, offset y from start.
    @discardableResult
    public func onDragUpdate(_ handler: @escaping @MainActor (Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectDoubleDouble(self, signal: .dragUpdate, handler: handler)
    }

    /// Connects to the `drag-end` signal.
    /// Handler receives: offset x, offset y from start.
    @discardableResult
    public func onDragEnd(_ handler: @escaping @MainActor (Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectDoubleDouble(self, signal: .dragEnd, handler: handler)
    }
}
