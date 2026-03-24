import CAdwaita
import GObjectSupport

/// Recognizes single and multiple clicks on a widget.
///
/// Wraps `GtkGestureClick`.
@MainActor
public final class GestureClick: GObjectRef {
    /// Creates a new click gesture recognizer.
    public init() {
        let ptr = gtk_gesture_click_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Connects to the `pressed` signal.
    /// Handler receives: number of presses, x coordinate, y coordinate.
    @discardableResult
    public func onPressed(_ handler: @escaping @MainActor (Int, Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectIntDoubleDouble(self, signal: .pressed) { nPress, x, y in
            handler(Int(nPress), x, y)
        }
    }

    /// Connects to the `released` signal.
    /// Handler receives: number of presses, x coordinate, y coordinate.
    @discardableResult
    public func onReleased(_ handler: @escaping @MainActor (Int, Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectIntDoubleDouble(self, signal: .released) { nPress, x, y in
            handler(Int(nPress), x, y)
        }
    }

    /// The mouse button this gesture responds to.
    ///
    /// 0 means any button, 1 = primary (left), 2 = middle, 3 = secondary (right).
    public var button: UInt32 {
        get { gtk_gesture_single_get_button(opaquePointer) }
        set { gtk_gesture_single_set_button(opaquePointer, newValue) }
    }
}
