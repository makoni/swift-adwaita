// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A circular avatar widget that shows initials, an icon, or a custom image.
///
/// Wraps `AdwAvatar`. Displays a round avatar with a coloured background
/// derived from the ``text`` property. When ``showInitials`` is `true` the
/// initials of the text are drawn; otherwise a fallback icon is used.
///
/// ```swift
/// // Avatar showing initials
/// let avatar = Avatar(size: 48, text: "Jane Doe", showInitials: true)
///
/// // Avatar with a custom icon instead of initials
/// let iconAvatar = Avatar(size: 48, text: "Jane Doe", showInitials: false)
/// iconAvatar.iconName = "avatar-default-symbolic"
///
/// // Resize later
/// avatar.size = 64
/// ```
@MainActor
public final class Avatar: Widget {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `Avatar`.
    public init(size: Int, text: String?, showInitials: Bool) {
        let ptr = adw_avatar_new(Int32(size), text, showInitials ? 1 : 0)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The fallback icon name shown when ``showInitials`` is `false`.
    public var iconName: String? {
        get { adw_avatar_get_icon_name(opaquePointer).map { String(cString: $0) } }
        set { adw_avatar_set_icon_name(opaquePointer, newValue) }
    }

    /// Whether to show initials derived from ``text`` instead of an icon.
    public var showInitials: Bool {
        get { adw_avatar_get_show_initials(opaquePointer) != 0 }
        set { adw_avatar_set_show_initials(opaquePointer, newValue ? 1 : 0) }
    }

    /// The diameter of the avatar in pixels.
    public var size: Int {
        get { Int(adw_avatar_get_size(opaquePointer)) }
        set { adw_avatar_set_size(opaquePointer, Int32(newValue)) }
    }

    /// The text used to generate initials and the background color.
    public var text: String? {
        get { adw_avatar_get_text(opaquePointer).map { String(cString: $0) } }
        set { adw_avatar_set_text(opaquePointer, newValue) }
    }
}
