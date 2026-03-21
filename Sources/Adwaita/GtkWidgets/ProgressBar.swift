import CAdwaita
import GObjectSupport

/// A widget that shows progress.
///
/// Wraps `GtkProgressBar`.
@MainActor
public final class ProgressBar: Widget {
    /// Creates a new progress bar.
    public init() {
        let ptr = gtk_progress_bar_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The fraction of work completed (0.0 to 1.0).
    public var fraction: Double {
        get { gtk_progress_bar_get_fraction(opaquePointer) }
        set { gtk_progress_bar_set_fraction(opaquePointer, newValue) }
    }

    /// Whether to pulse the progress bar.
    public func pulse() {
        gtk_progress_bar_pulse(opaquePointer)
    }

    /// The fraction for each pulse step.
    public var pulseStep: Double {
        get { gtk_progress_bar_get_pulse_step(opaquePointer) }
        set { gtk_progress_bar_set_pulse_step(opaquePointer, newValue) }
    }

    /// Whether to show text on the progress bar.
    public var showText: Bool {
        get { gtk_progress_bar_get_show_text(opaquePointer) != 0 }
        set { gtk_progress_bar_set_show_text(opaquePointer, newValue ? 1 : 0) }
    }

    /// The text displayed on the progress bar.
    public var text: String? {
        get {
            guard let cStr = gtk_progress_bar_get_text(opaquePointer) else { return nil }
            return String(cString: cStr)
        }
        set { gtk_progress_bar_set_text(opaquePointer, newValue) }
    }

    /// Whether the progress bar is inverted.
    public var inverted: Bool {
        get { gtk_progress_bar_get_inverted(opaquePointer) != 0 }
        set { gtk_progress_bar_set_inverted(opaquePointer, newValue ? 1 : 0) }
    }

    /// The ellipsize mode.
    public var ellipsize: PangoEllipsizeMode {
        get { gtk_progress_bar_get_ellipsize(opaquePointer) }
        set { gtk_progress_bar_set_ellipsize(opaquePointer, newValue) }
    }
}
