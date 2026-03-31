import CAdwaita
import GObjectSupport

/// Recognizes single and multiple clicks on a widget.
///
/// Wraps `GtkGestureClick`. Attach to any widget with `addController()` to
/// detect press and release events, including double- and triple-clicks.
///
/// ```swift
/// let click = GestureClick()
/// click.button = 1  // primary button only
/// click.onPressed { nPress, x, y in
///     if nPress == 2 {
///         print("Double-click at (\(x), \(y))")
///     }
/// }
/// click.onReleased { nPress, x, y in
///     print("Released at (\(x), \(y))")
/// }
/// myWidget.addController(click)
/// ```
@MainActor
public final class GestureClick: GObjectRef {
    /// Creates a new click gesture recognizer.
    public init() {
        let ptr = gtk_gesture_click_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Emitted when a button is pressed.
    ///
    /// - Parameter handler: Called when a button press is detected. Receives the number of presses, x coordinate, and y
    /// coordinate.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onPressed(_ handler: @escaping @MainActor (Int, Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectIntDoubleDouble(self, signal: .pressed) { nPress, x, y in
            handler(Int(nPress), x, y)
        }
    }

    /// Emitted when a button is released.
    ///
    /// - Parameter handler: Called when a button release is detected. Receives the number of presses, x coordinate, and
    /// y coordinate.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
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
