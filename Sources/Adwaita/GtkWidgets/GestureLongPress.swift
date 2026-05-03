// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

/// Recognizes long press gestures on a widget.
///
/// Wraps `GtkGestureLongPress`. Fires when the user presses and holds for
/// a threshold duration. Attach to a widget with `addController()`.
///
/// ```swift
/// let longPress = GestureLongPress()
/// longPress.delayFactor = 1.0  // default trigger delay
/// longPress.onPressed { x, y in
///     print("Long press detected at (\(x), \(y))")
/// }
/// longPress.onCancelled {
///     print("Long press cancelled")
/// }
/// myWidget.addController(longPress)
/// ```
@MainActor
public final class GestureLongPress: GObjectRef {
    /// Creates a new long press gesture recognizer.
    public init() {
        let ptr = gtk_gesture_long_press_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The delay factor applied to the long press trigger time.
    public var delayFactor: Double {
        get { gtk_gesture_long_press_get_delay_factor(opaquePointer) }
        set { gtk_gesture_long_press_set_delay_factor(opaquePointer, newValue) }
    }

    /// Emitted when a long press is detected.
    ///
    /// - Parameter handler: Called when the long press fires. Receives the x and y coordinates.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onPressed(_ handler: @escaping @MainActor (Double, Double) -> Void) -> SignalConnection {
        SignalHelper.connectDoubleDouble(self, signal: .pressed, handler: handler)
    }

    /// Emitted when a long press is cancelled.
    ///
    /// - Parameter handler: Called when the long press is cancelled.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onCancelled(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .cancelled, handler: handler)
    }
}
