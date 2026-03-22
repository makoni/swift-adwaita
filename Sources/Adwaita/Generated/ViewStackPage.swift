// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// An auxiliary class used by [class@ViewStack].
@MainActor
public final class ViewStackPage: GObjectRef {

    /// The `badge-number` property.
    public var badgeNumber: Int {
        get { Int(adw_view_stack_page_get_badge_number(opaquePointer)) }
        set { adw_view_stack_page_set_badge_number(opaquePointer, UInt32(newValue)) }
    }

    /// The `child` property (read-only).
    public var child: Widget {
        Widget(borrowing: UnsafeMutableRawPointer(adw_view_stack_page_get_child(opaquePointer)))
    }

    /// The `icon-name` property.
    public var iconName: String? {
        get { (adw_view_stack_page_get_icon_name(opaquePointer)).map { String(cString: $0) } }
        set { adw_view_stack_page_set_icon_name(opaquePointer, newValue) }
    }

    /// The `name` property.
    public var name: String? {
        get { (adw_view_stack_page_get_name(opaquePointer)).map { String(cString: $0) } }
        set { adw_view_stack_page_set_name(opaquePointer, newValue) }
    }

    /// The `needs-attention` property.
    public var needsAttention: Bool {
        get { adw_view_stack_page_get_needs_attention(opaquePointer) != 0 }
        set { adw_view_stack_page_set_needs_attention(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `title` property.
    public var title: String? {
        get { (adw_view_stack_page_get_title(opaquePointer)).map { String(cString: $0) } }
        set { adw_view_stack_page_set_title(opaquePointer, newValue) }
    }

    /// The `use-underline` property.
    public var useUnderline: Bool {
        get { adw_view_stack_page_get_use_underline(opaquePointer) != 0 }
        set { adw_view_stack_page_set_use_underline(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `visible` property.
    public var visible: Bool {
        get { adw_view_stack_page_get_visible(opaquePointer) != 0 }
        set { adw_view_stack_page_set_visible(opaquePointer, newValue ? 1 : 0) }
    }
}
