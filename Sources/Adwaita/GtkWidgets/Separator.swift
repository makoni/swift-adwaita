import CAdwaita
import GObjectSupport

/// A visual separator that draws a line between content areas.
///
/// Wraps `GtkSeparator`. Use a horizontal separator to divide stacked content
/// or a vertical separator to divide side-by-side content.
///
/// ```swift
/// let vbox = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 6)
/// vbox.append(Label("Section 1"))
/// vbox.append(Separator())  // horizontal line
/// vbox.append(Label("Section 2"))
///
/// // Vertical separator in a horizontal layout
/// let hbox = Box(orientation: GTK_ORIENTATION_HORIZONTAL, spacing: 6)
/// hbox.append(Label("Left"))
/// hbox.append(Separator(orientation: GTK_ORIENTATION_VERTICAL))
/// hbox.append(Label("Right"))
/// ```
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
