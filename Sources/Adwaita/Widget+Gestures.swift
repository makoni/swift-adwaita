import CAdwaita
import GObjectSupport

// MARK: - Gesture Convenience Methods

public extension Widget {

    /// Adds a click gesture and connects to its `pressed` signal.
    ///
    /// Creates a `GestureClick`, adds it as a controller, and connects the handler.
    /// Handler receives: number of presses, x coordinate, y coordinate.
    @discardableResult
    func onClick(_ handler: @escaping @MainActor (Int, Double, Double) -> Void) -> SignalConnection {
        let gesture = GestureClick()
        addController(gesture)
        return gesture.onPressed(handler)
    }

    /// Adds a click gesture for simple single-click handling.
    @discardableResult
    func onClick(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        let gesture = GestureClick()
        addController(gesture)
        return gesture.onPressed { _, _, _ in handler() }
    }

    /// Adds a long press gesture and connects to its `pressed` signal.
    ///
    /// Handler receives: x coordinate, y coordinate.
    @discardableResult
    func onLongPress(_ handler: @escaping @MainActor (Double, Double) -> Void) -> SignalConnection {
        let gesture = GestureLongPress()
        addController(gesture)
        return gesture.onPressed(handler)
    }

    /// Adds a swipe gesture and connects to its `swipe` signal.
    ///
    /// Handler receives: velocity x, velocity y (pixels per second).
    @discardableResult
    func onSwipe(_ handler: @escaping @MainActor (Double, Double) -> Void) -> SignalConnection {
        let gesture = GestureSwipe()
        addController(gesture)
        return gesture.onSwipe(handler)
    }

    /// Adds a double-click gesture handler.
    @discardableResult
    func onDoubleClick(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        let gesture = GestureClick()
        addController(gesture)
        return gesture.onPressed { nPress, _, _ in
            if nPress == 2 { handler() }
        }
    }

    /// Adds a right-click (secondary button) gesture handler.
    @discardableResult
    func onRightClick(_ handler: @escaping @MainActor (Double, Double) -> Void) -> SignalConnection {
        let gesture = GestureClick()
        gesture.button = 3 // GDK_BUTTON_SECONDARY
        addController(gesture)
        return gesture.onPressed { _, x, y in handler(x, y) }
    }

    /// Adds a right-click gesture for simple handling.
    @discardableResult
    func onRightClick(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        let gesture = GestureClick()
        gesture.button = 3
        addController(gesture)
        return gesture.onPressed { _, _, _ in handler() }
    }

    /// Recursively searches for a descendant widget of the given type.
    func findChild<T: Widget>(ofType type: T.Type) -> T? {
        var child = gtk_widget_get_first_child(widgetPointer)
        while let ptr = child {
            let widget = Widget(borrowing: UnsafeMutableRawPointer(ptr))
            if let match = widget.tryCast(type) {
                return match
            }
            // Recurse into children
            let childWidget = Widget(borrowing: UnsafeMutableRawPointer(ptr))
            if let found = childWidget.findChild(ofType: type) {
                return found
            }
            child = gtk_widget_get_next_sibling(ptr)
        }
        return nil
    }
}
