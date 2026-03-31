// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A tab bar widget that displays tabs for a ``TabView``.
///
/// Wraps `AdwTabBar`. Renders a horizontal strip of tabs connected to a
/// ``TabView``. Supports auto-hiding when there is only one tab, action
/// widgets on either end, and extra drag-and-drop handling.
///
/// ```swift
/// let tabView = TabView()
/// let tabBar = TabBar()
/// tabBar.view = tabView
///
/// // Auto-hide when only one tab is open
/// tabBar.autohide = true
///
/// // Expand tabs to fill available width
/// tabBar.expandTabs = true
///
/// // Add a "new tab" button at the end
/// let addButton = Button(iconName: "tab-new-symbolic")
/// tabBar.endActionWidget = addButton
///
/// // Place tab bar above the tab view in a vertical box
/// let box = Box(orientation: .vertical, spacing: 0)
/// box.append(tabBar)
/// box.append(tabView)
/// ```
///
/// Key properties:
/// - ``view``: The ``TabView`` this bar displays tabs for.
/// - ``autohide``: Whether to hide the bar when there is only one tab.
/// - ``expandTabs``: Whether tabs expand to fill the bar width.
/// - ``inverted``: Whether to display the bar upside down (e.g. at the bottom).
/// - ``startActionWidget`` / ``endActionWidget``: Widgets placed at the bar edges.
/// - ``isOverflowing`` / ``tabsRevealed``: Read-only overflow and visibility state.
@MainActor
public final class TabBar: Widget {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `TabBar`.
    public init() {
        let ptr = adw_tab_bar_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Whether the tab bar hides automatically when only one tab is open.
    public var autohide: Bool {
        get { adw_tab_bar_get_autohide(opaquePointer) != 0 }
        set { adw_tab_bar_set_autohide(opaquePointer, newValue ? 1 : 0) }
    }

    /// A widget displayed at the trailing end of the tab bar (e.g. a "new tab" button).
    public var endActionWidget: Widget? {
        get { adw_tab_bar_get_end_action_widget(opaquePointer).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_tab_bar_set_end_action_widget(opaquePointer, newValue?.widgetPointer) }
    }

    /// Whether tabs expand to fill the available width of the bar.
    public var expandTabs: Bool {
        get { adw_tab_bar_get_expand_tabs(opaquePointer) != 0 }
        set { adw_tab_bar_set_expand_tabs(opaquePointer, newValue ? 1 : 0) }
    }

    /// The preferred action for external drag-and-drop operations (read-only).
    /// - Since: libadwaita 1.4
    public var extraDragPreferredAction: GdkDragAction {
        adw_tab_bar_get_extra_drag_preferred_action(opaquePointer)
    }

    /// Whether to preload drop data when an external drag hovers over the tab bar.
    /// - Since: libadwaita 1.3
    public var extraDragPreload: Bool {
        get { adw_tab_bar_get_extra_drag_preload(opaquePointer) != 0 }
        set { adw_tab_bar_set_extra_drag_preload(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether to render the tab bar upside-down, suitable for placing at the bottom of a window.
    public var inverted: Bool {
        get { adw_tab_bar_get_inverted(opaquePointer) != 0 }
        set { adw_tab_bar_set_inverted(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the tab bar has more tabs than it can display at once (read-only).
    public var isOverflowing: Bool {
        adw_tab_bar_get_is_overflowing(opaquePointer) != 0
    }

    /// A widget displayed at the leading start of the tab bar.
    public var startActionWidget: Widget? {
        get { adw_tab_bar_get_start_action_widget(opaquePointer).map { Widget(borrowing: UnsafeMutableRawPointer($0)) }
        }
        set { adw_tab_bar_set_start_action_widget(opaquePointer, newValue?.widgetPointer) }
    }

    /// Whether the tabs are currently visible, accounting for autohide (read-only).
    public var tabsRevealed: Bool {
        adw_tab_bar_get_tabs_revealed(opaquePointer) != 0
    }

    /// The ``TabView`` whose tabs this bar displays.
    public var view: TabView? {
        get { adw_tab_bar_get_view(opaquePointer).map { TabView(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_tab_bar_set_view(opaquePointer, newValue?.opaquePointer) }
    }

    /// Emitted when external data is dropped on a tab.
    ///
    /// - Parameter handler: A closure receiving the target ``TabPage`` and the dropped `GValue`.
    ///   Return `true` to accept the drop.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onExtraDragDrop(_ handler: @escaping @MainActor (TabPage, UnsafePointer<GValue>) -> Bool)
        -> SignalConnection {
        SignalHelper.connectPointerGValueReturnBool(self, signal: .extraDragDrop) { (
            ptr: OpaquePointer,
            val: UnsafePointer<GValue>
        ) in
            handler(TabPage(borrowing: UnsafeMutableRawPointer(ptr)), val)
        }
    }

    /// Emitted when an external drag data value is received over a tab.
    ///
    /// - Parameter handler: A closure receiving the target ``TabPage`` and the drag `GValue`.
    ///   Return the preferred `GdkDragAction`.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onExtraDragValue(_ handler: @escaping @MainActor (TabPage, UnsafePointer<GValue>) -> GdkDragAction)
        -> SignalConnection {
        SignalHelper.connectPointerGValueReturnGdkDragAction(self, signal: .extraDragValue) { (
            ptr: OpaquePointer,
            val: UnsafePointer<GValue>
        ) in
            handler(TabPage(borrowing: UnsafeMutableRawPointer(ptr)), val)
        }
    }
}
