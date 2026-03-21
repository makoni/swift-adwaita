// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A dynamic tabbed container.
@MainActor
public final class TabView: Widget {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `TabView`.
    public init() {
        let ptr = adw_tab_view_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `is-transferring-page` property (read-only).
    public var isTransferringPage: Bool {
        adw_tab_view_get_is_transferring_page(opaquePointer) != 0
    }

    /// The `n-pages` property (read-only).
    public var nPages: Int32 {
        adw_tab_view_get_n_pages(opaquePointer)
    }

    /// The `n-pinned-pages` property (read-only).
    public var nPinnedPages: Int32 {
        adw_tab_view_get_n_pinned_pages(opaquePointer)
    }

    /// The `selected-page` property.
    public var selectedPage: OpaquePointer? {
        get { adw_tab_view_get_selected_page(opaquePointer) }
        set { adw_tab_view_set_selected_page(opaquePointer, newValue) }
    }

    /// The `shortcuts` property.
    /// - Since: libadwaita 1.2
    public var shortcuts: AdwTabViewShortcuts {
        get { adw_tab_view_get_shortcuts(opaquePointer) }
        set { adw_tab_view_set_shortcuts(opaquePointer, newValue) }
    }

    /// Calls `adw_tab_view_add_page`.
    @discardableResult
    public func addPage(_ child: Widget, parent: OpaquePointer?) -> OpaquePointer {
        return adw_tab_view_add_page(opaquePointer, child.widgetPointer, parent)
    }

    /// Calls `adw_tab_view_add_shortcuts`.
    public func addShortcuts(_ shortcuts: AdwTabViewShortcuts) {
        adw_tab_view_add_shortcuts(opaquePointer, shortcuts)
    }

    /// Calls `adw_tab_view_append`.
    @discardableResult
    public func append(_ child: Widget) -> OpaquePointer {
        return adw_tab_view_append(opaquePointer, child.widgetPointer)
    }

    /// Calls `adw_tab_view_append_pinned`.
    @discardableResult
    public func appendPinned(_ child: Widget) -> OpaquePointer {
        return adw_tab_view_append_pinned(opaquePointer, child.widgetPointer)
    }

    /// Calls `adw_tab_view_close_other_pages`.
    public func closeOtherPages(_ page: OpaquePointer) {
        adw_tab_view_close_other_pages(opaquePointer, page)
    }

    /// Calls `adw_tab_view_close_page`.
    public func closePage(_ page: OpaquePointer) {
        adw_tab_view_close_page(opaquePointer, page)
    }

    /// Calls `adw_tab_view_close_page_finish`.
    public func closePageFinish(_ page: OpaquePointer, confirm: Bool) {
        adw_tab_view_close_page_finish(opaquePointer, page, confirm ? 1 : 0)
    }

    /// Calls `adw_tab_view_close_pages_after`.
    public func closePagesAfter(_ page: OpaquePointer) {
        adw_tab_view_close_pages_after(opaquePointer, page)
    }

    /// Calls `adw_tab_view_close_pages_before`.
    public func closePagesBefore(_ page: OpaquePointer) {
        adw_tab_view_close_pages_before(opaquePointer, page)
    }

    /// Calls `adw_tab_view_get_nth_page`.
    @discardableResult
    public func getNthPage(_ position: Int32) -> OpaquePointer {
        return adw_tab_view_get_nth_page(opaquePointer, position)
    }

    /// Calls `adw_tab_view_get_page`.
    @discardableResult
    public func getPage(_ child: Widget) -> OpaquePointer {
        return adw_tab_view_get_page(opaquePointer, child.widgetPointer)
    }

    /// Calls `adw_tab_view_get_page_position`.
    @discardableResult
    public func getPagePosition(_ page: OpaquePointer) -> Int32 {
        return adw_tab_view_get_page_position(opaquePointer, page)
    }

    /// Calls `adw_tab_view_insert`.
    @discardableResult
    public func insert(_ child: Widget, position: Int32) -> OpaquePointer {
        return adw_tab_view_insert(opaquePointer, child.widgetPointer, position)
    }

    /// Calls `adw_tab_view_insert_pinned`.
    @discardableResult
    public func insertPinned(_ child: Widget, position: Int32) -> OpaquePointer {
        return adw_tab_view_insert_pinned(opaquePointer, child.widgetPointer, position)
    }

    /// Calls `adw_tab_view_invalidate_thumbnails`.
    public func invalidateThumbnails() {
        adw_tab_view_invalidate_thumbnails(opaquePointer)
    }

    /// Calls `adw_tab_view_prepend`.
    @discardableResult
    public func prepend(_ child: Widget) -> OpaquePointer {
        return adw_tab_view_prepend(opaquePointer, child.widgetPointer)
    }

    /// Calls `adw_tab_view_prepend_pinned`.
    @discardableResult
    public func prependPinned(_ child: Widget) -> OpaquePointer {
        return adw_tab_view_prepend_pinned(opaquePointer, child.widgetPointer)
    }

    /// Calls `adw_tab_view_remove_shortcuts`.
    public func removeShortcuts(_ shortcuts: AdwTabViewShortcuts) {
        adw_tab_view_remove_shortcuts(opaquePointer, shortcuts)
    }

    /// Calls `adw_tab_view_reorder_backward`.
    public func reorderBackward(_ page: OpaquePointer) -> Bool {
        return adw_tab_view_reorder_backward(opaquePointer, page) != 0
    }

    /// Calls `adw_tab_view_reorder_first`.
    public func reorderFirst(_ page: OpaquePointer) -> Bool {
        return adw_tab_view_reorder_first(opaquePointer, page) != 0
    }

    /// Calls `adw_tab_view_reorder_forward`.
    public func reorderForward(_ page: OpaquePointer) -> Bool {
        return adw_tab_view_reorder_forward(opaquePointer, page) != 0
    }

    /// Calls `adw_tab_view_reorder_last`.
    public func reorderLast(_ page: OpaquePointer) -> Bool {
        return adw_tab_view_reorder_last(opaquePointer, page) != 0
    }

    /// Calls `adw_tab_view_reorder_page`.
    public func reorderPage(_ page: OpaquePointer, position: Int32) -> Bool {
        return adw_tab_view_reorder_page(opaquePointer, page, position) != 0
    }

    /// Calls `adw_tab_view_select_next_page`.
    public func selectNextPage() -> Bool {
        return adw_tab_view_select_next_page(opaquePointer) != 0
    }

    /// Calls `adw_tab_view_select_previous_page`.
    public func selectPreviousPage() -> Bool {
        return adw_tab_view_select_previous_page(opaquePointer) != 0
    }

    /// Calls `adw_tab_view_set_page_pinned`.
    public func setPagePinned(_ page: OpaquePointer, pinned: Bool) {
        adw_tab_view_set_page_pinned(opaquePointer, page, pinned ? 1 : 0)
    }

    /// Calls `adw_tab_view_transfer_page`.
    public func transferPage(_ page: OpaquePointer, otherView: OpaquePointer, position: Int32) {
        adw_tab_view_transfer_page(opaquePointer, page, otherView, position)
    }

    /// Connects to the `close-page` signal.
    @discardableResult
    public func onClosePage(_ handler: @escaping @MainActor (OpaquePointer) -> Void) -> SignalConnection {
        SignalHelper.connectPointer(self, signal: "close-page", handler: handler)
    }

    /// Connects to the `create-window` signal.
    @discardableResult
    public func onCreateWindow(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "create-window", handler: handler)
    }

    /// Connects to the `indicator-activated` signal.
    @discardableResult
    public func onIndicatorActivated(_ handler: @escaping @MainActor (OpaquePointer) -> Void) -> SignalConnection {
        SignalHelper.connectPointer(self, signal: "indicator-activated", handler: handler)
    }

    /// Connects to the `page-attached` signal.
    @discardableResult
    public func onPageAttached(_ handler: @escaping @MainActor (OpaquePointer, Int32) -> Void) -> SignalConnection {
        SignalHelper.connectPointerInt(self, signal: "page-attached", handler: handler)
    }

    /// Connects to the `page-detached` signal.
    @discardableResult
    public func onPageDetached(_ handler: @escaping @MainActor (OpaquePointer, Int32) -> Void) -> SignalConnection {
        SignalHelper.connectPointerInt(self, signal: "page-detached", handler: handler)
    }

    /// Connects to the `page-reordered` signal.
    @discardableResult
    public func onPageReordered(_ handler: @escaping @MainActor (OpaquePointer, Int32) -> Void) -> SignalConnection {
        SignalHelper.connectPointerInt(self, signal: "page-reordered", handler: handler)
    }

    /// Connects to the `setup-menu` signal.
    @discardableResult
    public func onSetupMenu(_ handler: @escaping @MainActor (OpaquePointer) -> Void) -> SignalConnection {
        SignalHelper.connectPointer(self, signal: "setup-menu", handler: handler)
    }
}
