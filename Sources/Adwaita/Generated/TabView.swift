// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A dynamic tabbed container.
@MainActor
public final class TabView: Widget {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
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
    public var nPages: Int {
        Int(adw_tab_view_get_n_pages(opaquePointer))
    }

    /// The `n-pinned-pages` property (read-only).
    public var nPinnedPages: Int {
        Int(adw_tab_view_get_n_pinned_pages(opaquePointer))
    }

    /// The `selected-page` property.
    public var selectedPage: TabPage? {
        get { adw_tab_view_get_selected_page(opaquePointer).map { TabPage(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_tab_view_set_selected_page(opaquePointer, newValue?.opaquePointer) }
    }

    /// The `shortcuts` property.
    /// - Since: libadwaita 1.2
    public var shortcuts: AdwTabViewShortcuts {
        get { adw_tab_view_get_shortcuts(opaquePointer) }
        set { adw_tab_view_set_shortcuts(opaquePointer, newValue) }
    }

    /// Calls `adw_tab_view_add_page`.
    @discardableResult
    public func addPage(_ child: Widget, parent: TabPage?) -> TabPage {
        let ptr = adw_tab_view_add_page(opaquePointer, child.widgetPointer, parent?.opaquePointer)!
        return TabPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Calls `adw_tab_view_add_shortcuts`.
    public func addShortcuts(_ shortcuts: AdwTabViewShortcuts) {
        adw_tab_view_add_shortcuts(opaquePointer, shortcuts)
    }

    /// Calls `adw_tab_view_append`.
    @discardableResult
    public func append(_ child: Widget) -> TabPage {
        let ptr = adw_tab_view_append(opaquePointer, child.widgetPointer)!
        return TabPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Calls `adw_tab_view_append_pinned`.
    @discardableResult
    public func appendPinned(_ child: Widget) -> TabPage {
        let ptr = adw_tab_view_append_pinned(opaquePointer, child.widgetPointer)!
        return TabPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Calls `adw_tab_view_close_other_pages`.
    public func closeOtherPages(_ page: TabPage) {
        adw_tab_view_close_other_pages(opaquePointer, page.opaquePointer)
    }

    /// Calls `adw_tab_view_close_page`.
    public func closePage(_ page: TabPage) {
        adw_tab_view_close_page(opaquePointer, page.opaquePointer)
    }

    /// Calls `adw_tab_view_close_page_finish`.
    public func closePageFinish(_ page: TabPage, confirm: Bool) {
        adw_tab_view_close_page_finish(opaquePointer, page.opaquePointer, confirm ? 1 : 0)
    }

    /// Calls `adw_tab_view_close_pages_after`.
    public func closePagesAfter(_ page: TabPage) {
        adw_tab_view_close_pages_after(opaquePointer, page.opaquePointer)
    }

    /// Calls `adw_tab_view_close_pages_before`.
    public func closePagesBefore(_ page: TabPage) {
        adw_tab_view_close_pages_before(opaquePointer, page.opaquePointer)
    }

    /// Calls `adw_tab_view_get_nth_page`.
    @discardableResult
    public func getNthPage(_ position: Int) -> TabPage {
        let ptr = adw_tab_view_get_nth_page(opaquePointer, Int32(position))!
        return TabPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Calls `adw_tab_view_get_page`.
    @discardableResult
    public func getPage(_ child: Widget) -> TabPage {
        let ptr = adw_tab_view_get_page(opaquePointer, child.widgetPointer)!
        return TabPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Calls `adw_tab_view_get_page_position`.
    @discardableResult
    public func getPagePosition(_ page: TabPage) -> Int {
        return Int(adw_tab_view_get_page_position(opaquePointer, page.opaquePointer))
    }

    /// Calls `adw_tab_view_insert`.
    @discardableResult
    public func insert(_ child: Widget, position: Int) -> TabPage {
        let ptr = adw_tab_view_insert(opaquePointer, child.widgetPointer, Int32(position))!
        return TabPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Calls `adw_tab_view_insert_pinned`.
    @discardableResult
    public func insertPinned(_ child: Widget, position: Int) -> TabPage {
        let ptr = adw_tab_view_insert_pinned(opaquePointer, child.widgetPointer, Int32(position))!
        return TabPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Calls `adw_tab_view_invalidate_thumbnails`.
    public func invalidateThumbnails() {
        adw_tab_view_invalidate_thumbnails(opaquePointer)
    }

    /// Calls `adw_tab_view_prepend`.
    @discardableResult
    public func prepend(_ child: Widget) -> TabPage {
        let ptr = adw_tab_view_prepend(opaquePointer, child.widgetPointer)!
        return TabPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Calls `adw_tab_view_prepend_pinned`.
    @discardableResult
    public func prependPinned(_ child: Widget) -> TabPage {
        let ptr = adw_tab_view_prepend_pinned(opaquePointer, child.widgetPointer)!
        return TabPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Calls `adw_tab_view_remove_shortcuts`.
    public func removeShortcuts(_ shortcuts: AdwTabViewShortcuts) {
        adw_tab_view_remove_shortcuts(opaquePointer, shortcuts)
    }

    /// Calls `adw_tab_view_reorder_backward`.
    public func reorderBackward(_ page: TabPage) -> Bool {
        return adw_tab_view_reorder_backward(opaquePointer, page.opaquePointer) != 0
    }

    /// Calls `adw_tab_view_reorder_first`.
    public func reorderFirst(_ page: TabPage) -> Bool {
        return adw_tab_view_reorder_first(opaquePointer, page.opaquePointer) != 0
    }

    /// Calls `adw_tab_view_reorder_forward`.
    public func reorderForward(_ page: TabPage) -> Bool {
        return adw_tab_view_reorder_forward(opaquePointer, page.opaquePointer) != 0
    }

    /// Calls `adw_tab_view_reorder_last`.
    public func reorderLast(_ page: TabPage) -> Bool {
        return adw_tab_view_reorder_last(opaquePointer, page.opaquePointer) != 0
    }

    /// Calls `adw_tab_view_reorder_page`.
    public func reorderPage(_ page: TabPage, position: Int) -> Bool {
        return adw_tab_view_reorder_page(opaquePointer, page.opaquePointer, Int32(position)) != 0
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
    public func setPagePinned(_ page: TabPage, pinned: Bool) {
        adw_tab_view_set_page_pinned(opaquePointer, page.opaquePointer, pinned ? 1 : 0)
    }

    /// Calls `adw_tab_view_transfer_page`.
    public func transferPage(_ page: TabPage, otherView: TabView, position: Int) {
        adw_tab_view_transfer_page(opaquePointer, page.opaquePointer, otherView.opaquePointer, Int32(position))
    }

    /// Connects to the `close-page` signal.
    @discardableResult
    public func onClosePage(_ handler: @escaping @MainActor (TabPage) -> Void) -> SignalConnection {
        SignalHelper.connectPointer(self, signal: .closePage) { (ptr: OpaquePointer) in
            handler(TabPage(borrowing: UnsafeMutableRawPointer(ptr)))
        }
    }

    /// Connects to the `create-window` signal.
    @discardableResult
    public func onCreateWindow(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .createWindow, handler: handler)
    }

    /// Connects to the `indicator-activated` signal.
    @discardableResult
    public func onIndicatorActivated(_ handler: @escaping @MainActor (TabPage) -> Void) -> SignalConnection {
        SignalHelper.connectPointer(self, signal: .indicatorActivated) { (ptr: OpaquePointer) in
            handler(TabPage(borrowing: UnsafeMutableRawPointer(ptr)))
        }
    }

    /// Connects to the `page-attached` signal.
    @discardableResult
    public func onPageAttached(_ handler: @escaping @MainActor (TabPage, Int) -> Void) -> SignalConnection {
        SignalHelper.connectPointerInt(self, signal: .pageAttached) { (ptr: OpaquePointer, pos: Int32) in
            handler(TabPage(borrowing: UnsafeMutableRawPointer(ptr)), Int(pos))
        }
    }

    /// Connects to the `page-detached` signal.
    @discardableResult
    public func onPageDetached(_ handler: @escaping @MainActor (TabPage, Int) -> Void) -> SignalConnection {
        SignalHelper.connectPointerInt(self, signal: .pageDetached) { (ptr: OpaquePointer, pos: Int32) in
            handler(TabPage(borrowing: UnsafeMutableRawPointer(ptr)), Int(pos))
        }
    }

    /// Connects to the `page-reordered` signal.
    @discardableResult
    public func onPageReordered(_ handler: @escaping @MainActor (TabPage, Int) -> Void) -> SignalConnection {
        SignalHelper.connectPointerInt(self, signal: .pageReordered) { (ptr: OpaquePointer, pos: Int32) in
            handler(TabPage(borrowing: UnsafeMutableRawPointer(ptr)), Int(pos))
        }
    }

    /// Connects to the `setup-menu` signal.
    @discardableResult
    public func onSetupMenu(_ handler: @escaping @MainActor (TabPage) -> Void) -> SignalConnection {
        SignalHelper.connectPointer(self, signal: .setupMenu) { (ptr: OpaquePointer) in
            handler(TabPage(borrowing: UnsafeMutableRawPointer(ptr)))
        }
    }
}
