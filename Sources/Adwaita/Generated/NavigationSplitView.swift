// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A widget presenting sidebar and content side by side or as a navigation
/// view.
/// - Since: libadwaita 1.4
@MainActor
public final class NavigationSplitView: Widget {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `NavigationSplitView`.
    public init() {
        let ptr = adw_navigation_split_view_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `collapsed` property.
    /// - Since: libadwaita 1.4
    public var collapsed: Bool {
        get { adw_navigation_split_view_get_collapsed(opaquePointer) != 0 }
        set { adw_navigation_split_view_set_collapsed(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `max-sidebar-width` property.
    /// - Since: libadwaita 1.4
    public var maxSidebarWidth: Double {
        get { adw_navigation_split_view_get_max_sidebar_width(opaquePointer) }
        set { adw_navigation_split_view_set_max_sidebar_width(opaquePointer, newValue) }
    }

    /// The `min-sidebar-width` property.
    /// - Since: libadwaita 1.4
    public var minSidebarWidth: Double {
        get { adw_navigation_split_view_get_min_sidebar_width(opaquePointer) }
        set { adw_navigation_split_view_set_min_sidebar_width(opaquePointer, newValue) }
    }

    /// The `show-content` property.
    /// - Since: libadwaita 1.4
    public var showContent: Bool {
        get { adw_navigation_split_view_get_show_content(opaquePointer) != 0 }
        set { adw_navigation_split_view_set_show_content(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `sidebar-position` property.
    /// - Since: libadwaita 1.7
    public var sidebarPosition: GtkPackType {
        get { adw_navigation_split_view_get_sidebar_position(opaquePointer) }
        set { adw_navigation_split_view_set_sidebar_position(opaquePointer, newValue) }
    }

    /// The `sidebar-width-fraction` property.
    /// - Since: libadwaita 1.4
    public var sidebarWidthFraction: Double {
        get { adw_navigation_split_view_get_sidebar_width_fraction(opaquePointer) }
        set { adw_navigation_split_view_set_sidebar_width_fraction(opaquePointer, newValue) }
    }

    /// The `sidebar-width-unit` property.
    /// - Since: libadwaita 1.4
    public var sidebarWidthUnit: AdwLengthUnit {
        get { adw_navigation_split_view_get_sidebar_width_unit(opaquePointer) }
        set { adw_navigation_split_view_set_sidebar_width_unit(opaquePointer, newValue) }
    }

    /// Sets the sidebar navigation page.
    public func setSidebar(_ page: NavigationPage?) {
        let ptr: UnsafeMutablePointer<AdwNavigationPage>? = page.map { $0.castedPointer() }
        adw_navigation_split_view_set_sidebar(opaquePointer, ptr)
    }

    /// Sets the content navigation page.
    public func setContent(_ page: NavigationPage?) {
        let ptr: UnsafeMutablePointer<AdwNavigationPage>? = page.map { $0.castedPointer() }
        adw_navigation_split_view_set_content(opaquePointer, ptr)
    }
}
