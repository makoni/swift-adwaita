// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// An adaptive view switcher widget for navigating a ``ViewStack``.
///
/// Wraps `AdwViewSwitcher`. Displays toggle buttons for each page in a
/// connected ``ViewStack``, using titles and icons from the page metadata.
/// Adapts its layout based on available width -- showing wide or narrow
/// button styles controlled by ``policy``. Typically placed in a header bar.
///
/// ```swift
/// let stack = ViewStack()
/// stack.addTitledWithIcon(homeView, name: "home",
///                         title: "Home", iconName: "go-home-symbolic")
/// stack.addTitledWithIcon(searchView, name: "search",
///                         title: "Search", iconName: "edit-find-symbolic")
///
/// let switcher = ViewSwitcher()
/// switcher.stack = stack
/// switcher.policy = ADW_VIEW_SWITCHER_POLICY_WIDE
///
/// // Place in a header bar as the title widget
/// headerBar.setTitleWidget(switcher)
/// ```
///
/// Key properties:
/// - ``stack``: The ``ViewStack`` whose pages are displayed as buttons.
/// - ``policy``: The layout policy (wide or narrow) for the switcher buttons.
@MainActor
public final class ViewSwitcher: Widget {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ViewSwitcher`.
    public init() {
        let ptr = adw_view_switcher_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The layout policy controlling whether buttons use a wide or narrow style.
    public var policy: AdwViewSwitcherPolicy {
        get { adw_view_switcher_get_policy(opaquePointer) }
        set { adw_view_switcher_set_policy(opaquePointer, newValue) }
    }

    /// The ``ViewStack`` whose pages are displayed as toggle buttons.
    public var stack: ViewStack? {
        get { adw_view_switcher_get_stack(opaquePointer).map { ViewStack(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_view_switcher_set_stack(opaquePointer, newValue?.opaquePointer) }
    }
}
