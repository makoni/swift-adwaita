// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A widget presenting sidebar and content side by side or as an overlay.
/// - Since: libadwaita 1.4
@MainActor
public final class OverlaySplitView: Widget, Swipeable {

    /// The underlying `AdwSwipeable` pointer.
    public var swipeablePointer: OpaquePointer { opaquePointer }

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `OverlaySplitView`.
    public init() {
        let ptr = adw_overlay_split_view_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `collapsed` property.
    /// - Since: libadwaita 1.4
    public var collapsed: Bool {
        get { adw_overlay_split_view_get_collapsed(opaquePointer) != 0 }
        set { adw_overlay_split_view_set_collapsed(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `content` property.
    /// - Since: libadwaita 1.4
    public var content: Widget? {
        get { (adw_overlay_split_view_get_content(opaquePointer)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_overlay_split_view_set_content(opaquePointer, newValue?.widgetPointer) }
    }

    /// The `enable-hide-gesture` property.
    /// - Since: libadwaita 1.4
    public var enableHideGesture: Bool {
        get { adw_overlay_split_view_get_enable_hide_gesture(opaquePointer) != 0 }
        set { adw_overlay_split_view_set_enable_hide_gesture(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `enable-show-gesture` property.
    /// - Since: libadwaita 1.4
    public var enableShowGesture: Bool {
        get { adw_overlay_split_view_get_enable_show_gesture(opaquePointer) != 0 }
        set { adw_overlay_split_view_set_enable_show_gesture(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `max-sidebar-width` property.
    /// - Since: libadwaita 1.4
    public var maxSidebarWidth: Double {
        get { adw_overlay_split_view_get_max_sidebar_width(opaquePointer) }
        set { adw_overlay_split_view_set_max_sidebar_width(opaquePointer, newValue) }
    }

    /// The `min-sidebar-width` property.
    /// - Since: libadwaita 1.4
    public var minSidebarWidth: Double {
        get { adw_overlay_split_view_get_min_sidebar_width(opaquePointer) }
        set { adw_overlay_split_view_set_min_sidebar_width(opaquePointer, newValue) }
    }

    /// The `pin-sidebar` property.
    /// - Since: libadwaita 1.4
    public var pinSidebar: Bool {
        get { adw_overlay_split_view_get_pin_sidebar(opaquePointer) != 0 }
        set { adw_overlay_split_view_set_pin_sidebar(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `show-sidebar` property.
    /// - Since: libadwaita 1.4
    public var showSidebar: Bool {
        get { adw_overlay_split_view_get_show_sidebar(opaquePointer) != 0 }
        set { adw_overlay_split_view_set_show_sidebar(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `sidebar` property.
    /// - Since: libadwaita 1.4
    public var sidebar: Widget? {
        get { (adw_overlay_split_view_get_sidebar(opaquePointer)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_overlay_split_view_set_sidebar(opaquePointer, newValue?.widgetPointer) }
    }

    /// The `sidebar-position` property.
    /// - Since: libadwaita 1.4
    public var sidebarPosition: GtkPackType {
        get { adw_overlay_split_view_get_sidebar_position(opaquePointer) }
        set { adw_overlay_split_view_set_sidebar_position(opaquePointer, newValue) }
    }

    /// The `sidebar-width-fraction` property.
    /// - Since: libadwaita 1.4
    public var sidebarWidthFraction: Double {
        get { adw_overlay_split_view_get_sidebar_width_fraction(opaquePointer) }
        set { adw_overlay_split_view_set_sidebar_width_fraction(opaquePointer, newValue) }
    }

    /// The `sidebar-width-unit` property.
    /// - Since: libadwaita 1.4
    public var sidebarWidthUnit: AdwLengthUnit {
        get { adw_overlay_split_view_get_sidebar_width_unit(opaquePointer) }
        set { adw_overlay_split_view_set_sidebar_width_unit(opaquePointer, newValue) }
    }
}
