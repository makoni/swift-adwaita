// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// Metadata and state for a single page within a ``ViewStack``.
///
/// Wraps `AdwViewStackPage`. You do not create `ViewStackPage` instances
/// directly; they are returned by ``ViewStack`` methods such as
/// ``ViewStack/add(_:)`` and ``ViewStack/addTitled(_:name:title:)``.
/// Use the page object to configure the title, icon, badge, and visibility
/// that a ``ViewSwitcher`` displays.
///
/// ```swift
/// let stack = ViewStack()
/// let page = stack.addTitled(inboxView, name: "inbox", title: "Inbox")
///
/// // Set an icon for the view switcher
/// page.iconName = "mail-inbox-symbolic"
///
/// // Show a badge count (e.g. unread messages)
/// page.badgeNumber = 5
///
/// // Mark as needing attention
/// page.needsAttention = true
///
/// // Hide the page from the switcher without removing it
/// page.visible = false
/// ```
///
/// Key properties:
/// - ``title``: Label shown in the view switcher.
/// - ``iconName``: Icon shown alongside the title.
/// - ``badgeNumber``: Numeric badge displayed on the switcher button.
/// - ``needsAttention``: Whether an attention indicator is shown.
/// - ``name``: Programmatic identifier for the page.
/// - ``visible``: Whether the page appears in the switcher.
/// - ``child``: The widget displayed when the page is active (read-only).
/// - ``useUnderline``: Whether underlines in the title act as mnemonic markers.
@MainActor
public final class ViewStackPage: GObjectRef {

    /// The numeric badge displayed on the page's view-switcher button.
    public var badgeNumber: Int {
        get { Int(adw_view_stack_page_get_badge_number(opaquePointer)) }
        set { adw_view_stack_page_set_badge_number(opaquePointer, UInt32(newValue)) }
    }

    /// The widget displayed when this page is active (read-only).
    public var child: Widget {
        Widget(borrowing: UnsafeMutableRawPointer(adw_view_stack_page_get_child(opaquePointer)))
    }

    /// The icon name shown alongside the title in the view switcher.
    public var iconName: String? {
        get { adw_view_stack_page_get_icon_name(opaquePointer).map { String(cString: $0) } }
        set { adw_view_stack_page_set_icon_name(opaquePointer, newValue) }
    }

    /// The programmatic identifier used to look up this page in the stack.
    public var name: String? {
        get { adw_view_stack_page_get_name(opaquePointer).map { String(cString: $0) } }
        set { adw_view_stack_page_set_name(opaquePointer, newValue) }
    }

    /// Whether an attention indicator (dot) is shown on the page's switcher button.
    public var needsAttention: Bool {
        get { adw_view_stack_page_get_needs_attention(opaquePointer) != 0 }
        set { adw_view_stack_page_set_needs_attention(opaquePointer, newValue ? 1 : 0) }
    }

    /// The label shown for this page in the view switcher.
    public var title: String? {
        get { adw_view_stack_page_get_title(opaquePointer).map { String(cString: $0) } }
        set { adw_view_stack_page_set_title(opaquePointer, newValue) }
    }

    /// Whether underscores in the title indicate mnemonic accelerators.
    public var useUnderline: Bool {
        get { adw_view_stack_page_get_use_underline(opaquePointer) != 0 }
        set { adw_view_stack_page_set_use_underline(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether this page appears in the view switcher.
    public var visible: Bool {
        get { adw_view_stack_page_get_visible(opaquePointer) != 0 }
        set { adw_view_stack_page_set_visible(opaquePointer, newValue ? 1 : 0) }
    }
}
