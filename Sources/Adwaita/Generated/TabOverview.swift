// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A full-screen grid overview of all tabs in a ``TabView``.
///
/// Wraps `AdwTabOverview`. Displays thumbnail previews of every open tab in a
/// grid layout, letting users search, select, or create tabs visually. Pair it
/// with a ``TabButton`` to provide a standard tab-overview flow.
///
/// ```swift
/// let tabView = TabView()
/// let tabOverview = TabOverview()
/// tabOverview.view = tabView
///
/// // Wrap your content so the overview can overlay it
/// tabOverview.child = mainContentBox
///
/// // Enable the "New Tab" button in the overview
/// tabOverview.enableNewTab = true
/// tabOverview.onCreateTab {
///     let page = tabView.append(Label(text: "New Tab"))
///     page.title = "New Tab"
/// }
///
/// // Enable search within the overview
/// tabOverview.enableSearch = true
///
/// // Open or close the overview programmatically
/// tabOverview.open = true
/// ```
///
/// Key properties:
/// - ``view``: The ``TabView`` whose tabs are shown.
/// - ``child``: The main content widget displayed behind the overview.
/// - ``open``: Whether the overview is currently visible.
/// - ``enableNewTab``: Whether a "New Tab" button appears in the overview.
/// - ``enableSearch``: Whether the search bar is available.
/// - ``searchActive``: Whether search is currently active (read-only).
/// - ``inverted``: Whether thumbnails are displayed upside down.
///
/// Key signals:
/// - ``onCreateTab(_:)``: Emitted when the "New Tab" button is pressed.
///
/// - Since: libadwaita 1.3
@MainActor
public final class TabOverview: Widget {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `TabOverview`.
    public init() {
        let ptr = adw_tab_overview_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The main content widget displayed behind the tab overview grid.
    /// - Since: libadwaita 1.3
    public var child: Widget? {
        get { (adw_tab_overview_get_child(opaquePointer)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_tab_overview_set_child(opaquePointer, newValue?.widgetPointer) }
    }

    /// Whether a "New Tab" button is shown in the overview.
    /// - Since: libadwaita 1.3
    public var enableNewTab: Bool {
        get { adw_tab_overview_get_enable_new_tab(opaquePointer) != 0 }
        set { adw_tab_overview_set_enable_new_tab(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the search bar is available in the overview for filtering tabs.
    /// - Since: libadwaita 1.3
    public var enableSearch: Bool {
        get { adw_tab_overview_get_enable_search(opaquePointer) != 0 }
        set { adw_tab_overview_set_enable_search(opaquePointer, newValue ? 1 : 0) }
    }

    /// The preferred action for extra drag data dropped onto tab thumbnails (read-only).
    /// - Since: libadwaita 1.4
    public var extraDragPreferredAction: GdkDragAction {
        adw_tab_overview_get_extra_drag_preferred_action(opaquePointer)
    }

    /// Whether to preload drop data when a drag enters tab thumbnails, for faster drop handling.
    /// - Since: libadwaita 1.3
    public var extraDragPreload: Bool {
        get { adw_tab_overview_get_extra_drag_preload(opaquePointer) != 0 }
        set { adw_tab_overview_set_extra_drag_preload(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether tab thumbnails are displayed upside down, useful for bottom-to-top layouts.
    /// - Since: libadwaita 1.3
    public var inverted: Bool {
        get { adw_tab_overview_get_inverted(opaquePointer) != 0 }
        set { adw_tab_overview_set_inverted(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the tab overview grid is currently visible.
    /// - Since: libadwaita 1.3
    public var open: Bool {
        get { adw_tab_overview_get_open(opaquePointer) != 0 }
        set { adw_tab_overview_set_open(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the search bar in the overview is currently active and filtering tabs (read-only).
    /// - Since: libadwaita 1.3
    public var searchActive: Bool {
        adw_tab_overview_get_search_active(opaquePointer) != 0
    }

    /// Whether window title buttons (close, minimize, etc.) are shown at the end of the overview header.
    /// - Since: libadwaita 1.3
    public var showEndTitleButtons: Bool {
        get { adw_tab_overview_get_show_end_title_buttons(opaquePointer) != 0 }
        set { adw_tab_overview_set_show_end_title_buttons(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether window title buttons (close, minimize, etc.) are shown at the start of the overview header.
    /// - Since: libadwaita 1.3
    public var showStartTitleButtons: Bool {
        get { adw_tab_overview_get_show_start_title_buttons(opaquePointer) != 0 }
        set { adw_tab_overview_set_show_start_title_buttons(opaquePointer, newValue ? 1 : 0) }
    }

    /// The ``TabView`` whose tabs are displayed in this overview.
    /// - Since: libadwaita 1.3
    public var view: TabView? {
        get { (adw_tab_overview_get_view(opaquePointer)).map { TabView(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_tab_overview_set_view(opaquePointer, newValue?.opaquePointer) }
    }

    /// Connects to the `create-tab` signal.
    @discardableResult
    public func onCreateTab(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .createTab, handler: handler)
    }

    /// Connects to the `extra-drag-drop` signal.
    @discardableResult
    public func onExtraDragDrop(_ handler: @escaping @MainActor (TabPage, UnsafePointer<GValue>) -> Bool) -> SignalConnection {
        SignalHelper.connectPointerGValueReturnBool(self, signal: .extraDragDrop) { (ptr: OpaquePointer, val: UnsafePointer<GValue>) in
            handler(TabPage(borrowing: UnsafeMutableRawPointer(ptr)), val)
        }
    }

    /// Connects to the `extra-drag-value` signal.
    @discardableResult
    public func onExtraDragValue(_ handler: @escaping @MainActor (TabPage, UnsafePointer<GValue>) -> GdkDragAction) -> SignalConnection {
        SignalHelper.connectPointerGValueReturnGdkDragAction(self, signal: .extraDragValue) { (ptr: OpaquePointer, val: UnsafePointer<GValue>) in
            handler(TabPage(borrowing: UnsafeMutableRawPointer(ptr)), val)
        }
    }
}
