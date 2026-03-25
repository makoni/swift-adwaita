import CAdwaita
import GObjectSupport

/// A container that positions children at fixed coordinates.
///
/// Wraps `GtkFixed`. Children are placed at absolute (x, y) positions.
/// Use sparingly -- prefer layout containers like ``Box`` for most cases.
///
/// ```swift
/// let canvas = Fixed()
/// let label1 = Label("Hello")
/// let label2 = Label("World")
///
/// canvas.put(label1, x: 10, y: 20)
/// canvas.put(label2, x: 100, y: 50)
///
/// // Move a child later
/// canvas.move(label1, x: 50, y: 80)
/// ```
@MainActor
public final class Fixed: Widget {
    /// Creates a new fixed container.
    public init() {
        let ptr = gtk_fixed_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    private var fixedPointer: UnsafeMutablePointer<GtkFixed> { castedPointer() }

    /// Adds a child widget at the given position.
    public func put(_ child: Widget, x: Double, y: Double) {
        gtk_fixed_put(fixedPointer, child.widgetPointer, x, y)
    }

    /// Moves a child widget to a new position.
    public func move(_ child: Widget, x: Double, y: Double) {
        gtk_fixed_move(fixedPointer, child.widgetPointer, x, y)
    }

    /// Removes a child widget.
    public func remove(_ child: Widget) {
        gtk_fixed_remove(fixedPointer, child.widgetPointer)
    }
}
