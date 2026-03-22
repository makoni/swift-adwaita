import CAdwaita
import GObjectSupport

/// A container that positions children at fixed coordinates.
///
/// Wraps `GtkFixed`. Children are placed at absolute (x, y) positions.
/// Use sparingly — prefer layout containers for most cases.
@MainActor
public final class Fixed: Widget {
    /// Creates a new fixed container.
    public init() {
        let ptr = gtk_fixed_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    override internal init(raw pointer: UnsafeMutableRawPointer) {
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
