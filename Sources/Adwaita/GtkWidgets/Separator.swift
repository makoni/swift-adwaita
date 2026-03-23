import CAdwaita
import GObjectSupport

/// A separator widget — draws a line between content.
///
/// Wraps `GtkSeparator`.
@MainActor
public final class Separator: Widget {
    /// Creates a new separator.
    ///
    /// - Parameter orientation: The direction of the separator line.
    public init(orientation: GtkOrientation = GTK_ORIENTATION_HORIZONTAL) {
        let ptr = gtk_separator_new(orientation)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }
}
