// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A widget displaying an image, with a generated fallback.
@MainActor
public final class Avatar: Widget {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `Avatar`.
    public init(size: Int32, text: String?, showInitials: Bool) {
        let ptr = adw_avatar_new(size, text, showInitials ? 1 : 0)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `icon-name` property.
    public var iconName: String? {
        get { (adw_avatar_get_icon_name(opaquePointer)).map { String(cString: $0) } }
        set { adw_avatar_set_icon_name(opaquePointer, newValue) }
    }

    /// The `show-initials` property.
    public var showInitials: Bool {
        get { adw_avatar_get_show_initials(opaquePointer) != 0 }
        set { adw_avatar_set_show_initials(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `size` property.
    public var size: Int32 {
        get { adw_avatar_get_size(opaquePointer) }
        set { adw_avatar_set_size(opaquePointer, newValue) }
    }

    /// The `text` property.
    public var text: String? {
        get { (adw_avatar_get_text(opaquePointer)).map { String(cString: $0) } }
        set { adw_avatar_set_text(opaquePointer, newValue) }
    }
}
