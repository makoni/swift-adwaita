// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// An individual layout in [class@MultiLayoutView].
/// - Since: libadwaita 1.6
@MainActor
public final class Layout: GObjectRef {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `Layout`.
    public init(content: Widget) {
        let ptr = adw_layout_new(content.widgetPointer)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `content` property (read-only).
    /// - Since: libadwaita 1.6
    public var content: Widget {
        Widget(borrowing: UnsafeMutableRawPointer(adw_layout_get_content(opaquePointer)))
    }

    /// The `name` property.
    /// - Since: libadwaita 1.6
    public var name: String? {
        get { (adw_layout_get_name(opaquePointer)).map { String(cString: $0) } }
        set { adw_layout_set_name(opaquePointer, newValue) }
    }
}
