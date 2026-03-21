// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A tab bar for [class@TabView].
@MainActor
public final class TabBar: Widget {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `TabBar`.
    public init() {
        let ptr = adw_tab_bar_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `autohide` property.
    public var autohide: Bool {
        get { adw_tab_bar_get_autohide(opaquePointer) != 0 }
        set { adw_tab_bar_set_autohide(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `end-action-widget` property.
    public var endActionWidget: Widget? {
        get { (adw_tab_bar_get_end_action_widget(opaquePointer)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_tab_bar_set_end_action_widget(opaquePointer, newValue?.widgetPointer) }
    }

    /// The `expand-tabs` property.
    public var expandTabs: Bool {
        get { adw_tab_bar_get_expand_tabs(opaquePointer) != 0 }
        set { adw_tab_bar_set_expand_tabs(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `extra-drag-preferred-action` property (read-only).
    /// - Since: libadwaita 1.4
    public var extraDragPreferredAction: GdkDragAction {
        adw_tab_bar_get_extra_drag_preferred_action(opaquePointer)
    }

    /// The `extra-drag-preload` property.
    /// - Since: libadwaita 1.3
    public var extraDragPreload: Bool {
        get { adw_tab_bar_get_extra_drag_preload(opaquePointer) != 0 }
        set { adw_tab_bar_set_extra_drag_preload(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `inverted` property.
    public var inverted: Bool {
        get { adw_tab_bar_get_inverted(opaquePointer) != 0 }
        set { adw_tab_bar_set_inverted(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `is-overflowing` property (read-only).
    public var isOverflowing: Bool {
        adw_tab_bar_get_is_overflowing(opaquePointer) != 0
    }

    /// The `start-action-widget` property.
    public var startActionWidget: Widget? {
        get { (adw_tab_bar_get_start_action_widget(opaquePointer)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_tab_bar_set_start_action_widget(opaquePointer, newValue?.widgetPointer) }
    }

    /// The `tabs-revealed` property (read-only).
    public var tabsRevealed: Bool {
        adw_tab_bar_get_tabs_revealed(opaquePointer) != 0
    }

    /// The `view` property.
    public var view: OpaquePointer? {
        get { adw_tab_bar_get_view(opaquePointer) }
        set { adw_tab_bar_set_view(opaquePointer, newValue) }
    }

    /// Connects to the `extra-drag-drop` signal.
    @discardableResult
    public func onExtraDragDrop(_ handler: @escaping @MainActor (OpaquePointer, UnsafePointer<GValue>) -> Bool) -> SignalConnection {
        SignalHelper.connectPointerGValueReturnBool(self, signal: "extra-drag-drop", handler: handler)
    }

    /// Connects to the `extra-drag-value` signal.
    @discardableResult
    public func onExtraDragValue(_ handler: @escaping @MainActor (OpaquePointer, UnsafePointer<GValue>) -> GdkDragAction) -> SignalConnection {
        SignalHelper.connectPointerGValueReturnGdkDragAction(self, signal: "extra-drag-value", handler: handler)
    }
}
