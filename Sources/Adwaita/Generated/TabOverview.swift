// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A tab overview for [class@TabView].
/// - Since: libadwaita 1.3
@MainActor
public final class TabOverview: Widget {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `TabOverview`.
    public init() {
        let ptr = adw_tab_overview_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `child` property.
    /// - Since: libadwaita 1.3
    public var child: Widget? {
        get { (adw_tab_overview_get_child(opaquePointer)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_tab_overview_set_child(opaquePointer, newValue?.widgetPointer) }
    }

    /// The `enable-new-tab` property.
    /// - Since: libadwaita 1.3
    public var enableNewTab: Bool {
        get { adw_tab_overview_get_enable_new_tab(opaquePointer) != 0 }
        set { adw_tab_overview_set_enable_new_tab(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `enable-search` property.
    /// - Since: libadwaita 1.3
    public var enableSearch: Bool {
        get { adw_tab_overview_get_enable_search(opaquePointer) != 0 }
        set { adw_tab_overview_set_enable_search(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `extra-drag-preferred-action` property (read-only).
    /// - Since: libadwaita 1.4
    public var extraDragPreferredAction: GdkDragAction {
        adw_tab_overview_get_extra_drag_preferred_action(opaquePointer)
    }

    /// The `extra-drag-preload` property.
    /// - Since: libadwaita 1.3
    public var extraDragPreload: Bool {
        get { adw_tab_overview_get_extra_drag_preload(opaquePointer) != 0 }
        set { adw_tab_overview_set_extra_drag_preload(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `inverted` property.
    /// - Since: libadwaita 1.3
    public var inverted: Bool {
        get { adw_tab_overview_get_inverted(opaquePointer) != 0 }
        set { adw_tab_overview_set_inverted(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `open` property.
    /// - Since: libadwaita 1.3
    public var open: Bool {
        get { adw_tab_overview_get_open(opaquePointer) != 0 }
        set { adw_tab_overview_set_open(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `search-active` property (read-only).
    /// - Since: libadwaita 1.3
    public var searchActive: Bool {
        adw_tab_overview_get_search_active(opaquePointer) != 0
    }

    /// The `show-end-title-buttons` property.
    /// - Since: libadwaita 1.3
    public var showEndTitleButtons: Bool {
        get { adw_tab_overview_get_show_end_title_buttons(opaquePointer) != 0 }
        set { adw_tab_overview_set_show_end_title_buttons(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `show-start-title-buttons` property.
    /// - Since: libadwaita 1.3
    public var showStartTitleButtons: Bool {
        get { adw_tab_overview_get_show_start_title_buttons(opaquePointer) != 0 }
        set { adw_tab_overview_set_show_start_title_buttons(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `view` property.
    /// - Since: libadwaita 1.3
    public var view: TabView? {
        get { (adw_tab_overview_get_view(opaquePointer)).map { TabView(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_tab_overview_set_view(opaquePointer, newValue?.opaquePointer) }
    }

    /// Connects to the `create-tab` signal.
    @discardableResult
    public func onCreateTab(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "create-tab", handler: handler)
    }

    /// Connects to the `extra-drag-drop` signal.
    @discardableResult
    public func onExtraDragDrop(_ handler: @escaping @MainActor (TabPage, UnsafePointer<GValue>) -> Bool) -> SignalConnection {
        SignalHelper.connectPointerGValueReturnBool(self, signal: "extra-drag-drop") { (ptr: OpaquePointer, val: UnsafePointer<GValue>) in
            handler(TabPage(borrowing: UnsafeMutableRawPointer(ptr)), val)
        }
    }

    /// Connects to the `extra-drag-value` signal.
    @discardableResult
    public func onExtraDragValue(_ handler: @escaping @MainActor (TabPage, UnsafePointer<GValue>) -> GdkDragAction) -> SignalConnection {
        SignalHelper.connectPointerGValueReturnGdkDragAction(self, signal: "extra-drag-value") { (ptr: OpaquePointer, val: UnsafePointer<GValue>) in
            handler(TabPage(borrowing: UnsafeMutableRawPointer(ptr)), val)
        }
    }
}
