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

    /// Connects to the `pressed` signal.
    /// Handler receives: number of presses, x coordinate, y coordinate.
    @discardableResult
    public func onPressed(_ handler: @escaping @MainActor (Int, Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectIntDoubleDouble(self, signal: "pressed") { nPress, x, y in
            handler(Int(nPress), x, y)
        }
    }

    /// Connects to the `released` signal.
    /// Handler receives: number of presses, x coordinate, y coordinate.
    @discardableResult
    public func onReleased(_ handler: @escaping @MainActor (Int, Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectIntDoubleDouble(self, signal: "released") { nPress, x, y in
            handler(Int(nPress), x, y)
        }
    }
}
