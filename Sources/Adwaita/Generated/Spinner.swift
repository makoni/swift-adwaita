// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A widget showing a loading spinner.
/// - Since: libadwaita 1.6
@MainActor
public final class Spinner: Widget {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `Spinner`.
    public init() {
        let ptr = adw_spinner_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }
}
