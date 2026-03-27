// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A widget that displays an animated loading spinner.
///
/// Wraps `AdwSpinner`. Use this to indicate that a long-running
/// operation is in progress. The spinner animates automatically
/// while it is visible.
///
/// ```swift
/// let spinner = Spinner()
///
/// // Place inside a status page for a loading screen
/// let page = StatusPage(title: "Loading...", description: "Please wait")
/// page.child = spinner
///
/// // Or add directly to a container
/// let box = Box(orientation: .vertical, spacing: 12)
/// box.append(spinner)
/// ```
///
/// - Since: libadwaita 1.6
@MainActor
public final class Spinner: Widget {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `Spinner`.
    ///
    /// - Note: Requires libadwaita 1.6+. Returns `nil` on older versions.
    public init?() {
        guard AdwaitaVersion.isAtLeast(1, 6) else { return nil }
        let ptr = adw_spinner_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }
}
