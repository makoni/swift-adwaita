// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A two-column or three-column adaptive navigation layout.
///
/// Wraps `AdwNavigationSplitView`. Presents a sidebar and content side by side
/// on wide screens, and collapses into a single-column ``NavigationView`` on
/// narrow screens. Use it for master-detail patterns such as a mail client
/// or settings panel.
///
/// ```swift
/// let split = NavigationSplitView()
///
/// let sidebar = NavigationPage(child: sidebarList, title: "Mailboxes")
/// let content = NavigationPage(child: messageView, title: "Inbox")
/// split.setSidebar(sidebar)
/// split.setContent(content)
///
/// // Adjust sidebar proportions
/// split.sidebarWidthFraction = 0.33
/// split.minSidebarWidth = 200
/// split.maxSidebarWidth = 400
///
/// // In collapsed mode, show content pane
/// split.showContent = true
/// ```
///
/// Key properties:
/// - ``collapsed``: Whether the split view is in single-column mode.
/// - ``sidebarWidthFraction``: Fraction of total width allocated to the sidebar.
/// - ``minSidebarWidth`` / ``maxSidebarWidth``: Sidebar width constraints.
/// - ``showContent``: Which pane is visible when collapsed.
/// - ``sidebarPosition``: Whether the sidebar is at the start or end.
///
/// Key methods:
/// - ``setSidebar(_:)``: Sets the sidebar navigation page.
/// - ``setContent(_:)``: Sets the content navigation page.
///
/// - Since: libadwaita 1.4
@MainActor
public final class NavigationSplitView: Widget {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `NavigationSplitView`.
    public init() {
        let ptr = adw_navigation_split_view_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Whether the split view is in single-column (collapsed) mode.
    /// - Since: libadwaita 1.4
    public var collapsed: Bool {
        get { adw_navigation_split_view_get_collapsed(opaquePointer) != 0 }
        set { adw_navigation_split_view_set_collapsed(opaquePointer, newValue ? 1 : 0) }
    }

    /// The maximum width of the sidebar in pixels.
    /// - Since: libadwaita 1.4
    public var maxSidebarWidth: Double {
        get { adw_navigation_split_view_get_max_sidebar_width(opaquePointer) }
        set { adw_navigation_split_view_set_max_sidebar_width(opaquePointer, newValue) }
    }

    /// The minimum width of the sidebar in pixels.
    /// - Since: libadwaita 1.4
    public var minSidebarWidth: Double {
        get { adw_navigation_split_view_get_min_sidebar_width(opaquePointer) }
        set { adw_navigation_split_view_set_min_sidebar_width(opaquePointer, newValue) }
    }

    /// Whether to show the content pane when collapsed (otherwise shows sidebar).
    /// - Since: libadwaita 1.4
    public var showContent: Bool {
        get { adw_navigation_split_view_get_show_content(opaquePointer) != 0 }
        set { adw_navigation_split_view_set_show_content(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the sidebar is at the start or end of the layout.
    ///
    /// - Note: Requires libadwaita 1.7+. Returns `nil` / does nothing on older versions.
    /// - Since: libadwaita 1.7
    public var sidebarPosition: GtkPackType? {
        get {
            guard AdwaitaVersion.isAtLeast(1, 7) else { return nil }
            return cadw_navigation_split_view_get_sidebar_position(pointer)
        }
        set {
            guard AdwaitaVersion.isAtLeast(1, 7), let newValue else { return }
            cadw_navigation_split_view_set_sidebar_position(pointer, newValue)
        }
    }

    /// The fraction of total width allocated to the sidebar (0.0 to 1.0).
    /// - Since: libadwaita 1.4
    public var sidebarWidthFraction: Double {
        get { adw_navigation_split_view_get_sidebar_width_fraction(opaquePointer) }
        set { adw_navigation_split_view_set_sidebar_width_fraction(opaquePointer, newValue) }
    }

    /// The unit used for sidebar width calculations.
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
