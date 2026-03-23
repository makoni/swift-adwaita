// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A child slot within [class@Layout].
/// - Since: libadwaita 1.6
@MainActor
public final class LayoutSlot: Widget {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `LayoutSlot`.
    public init(id: String) {
        let ptr = adw_layout_slot_new(id)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `id` property (read-only).
    /// - Since: libadwaita 1.6
    public var id: String {
        String(cString: adw_layout_slot_get_slot_id(opaquePointer))
    }
}
