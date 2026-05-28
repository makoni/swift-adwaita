// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A dynamic tabbed container that manages multiple child widgets as tabs.
///
/// Wraps `AdwTabView`. Provides a complete tabbed interface with support for
/// pinned tabs, reordering, drag-and-drop between windows, and tab transfer.
/// Pair with ``TabBar`` or ``TabOverview`` to give users a visible tab strip
/// or overview grid.
///
/// ```swift
/// let tabView = TabView()
///
/// // Append tabs
/// let page1 = tabView.append(Label(text: "Welcome"))
/// page1.title = "Home"
///
/// let page2 = tabView.append(Label(text: "Settings content"))
/// page2.title = "Settings"
///
/// // Pin the first tab
/// tabView.setPagePinned(page1, pinned: true)
///
/// // Select a tab programmatically
/// tabView.selectedPage = page2
///
/// // React to tab close requests
/// tabView.onClosePage { page in
///     tabView.closePageFinish(page, confirm: true)
/// }
/// ```
///
/// Key properties:
/// - ``selectedPage``: The currently selected tab page.
/// - ``nPages`` / ``nPinnedPages``: Total and pinned page counts (read-only).
/// - ``shortcuts``: Keyboard shortcuts enabled for the tab view.
///
/// Key methods:
/// - ``append(_:)`` / ``prepend(_:)``: Add a tab at the end or beginning.
/// - ``closePage(_:)`` / ``closePageFinish(_:confirm:)``: Close a tab (with confirmation).
/// - ``reorderPage(_:position:)``: Move a tab to a new position.
/// - ``getNthPage(_:)``: Retrieve a page by its index.
@MainActor
public final class TabView: Widget {
    override public class var gtkType: GType {
        adw_tab_view_get_type()
    }

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `TabView`.
    public init() {
        let ptr = adw_tab_view_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Whether a page is currently being transferred to or from another tab view.
    ///
    /// This is `true` during drag-and-drop tab transfers between windows.
    public var isTransferringPage: Bool {
        adw_tab_view_get_is_transferring_page(opaquePointer) != 0
    }

    /// The total number of pages in the tab view, including pinned pages.
    public var nPages: Int {
        Int(adw_tab_view_get_n_pages(opaquePointer))
    }

    /// The number of pinned pages in the tab view.
    public var nPinnedPages: Int {
        Int(adw_tab_view_get_n_pinned_pages(opaquePointer))
    }

    /// The currently selected tab page, or `nil` if there are no pages.
    public var selectedPage: TabPage? {
        get { adw_tab_view_get_selected_page(opaquePointer).map { TabPage(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_tab_view_set_selected_page(opaquePointer, newValue?.opaquePointer) }
    }

    /// The keyboard shortcuts enabled for this tab view (e.g. Ctrl+Tab, Ctrl+W).
    /// - Since: libadwaita 1.2
    public var shortcuts: AdwTabViewShortcuts {
        get { adw_tab_view_get_shortcuts(opaquePointer) }
        set { adw_tab_view_set_shortcuts(opaquePointer, newValue) }
    }

    /// Adds a new page to the tab view, optionally as a child of an existing page.
    ///
    /// The page is inserted after the parent's last child, or at the end if
    /// no parent is specified.
    ///
    /// - Parameter child: The widget to display in the new tab.
    /// - Parameter parent: An optional parent page, used to group related tabs.
    /// - Returns: The ``TabPage`` representing the new tab.
    @discardableResult
    public func addPage(_ child: Widget, parent: TabPage?) -> TabPage {
        let ptr = adw_tab_view_add_page(opaquePointer, child.widgetPointer, parent?.opaquePointer)!
        return TabPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Enables additional keyboard shortcuts for the tab view.
    ///
    /// The new shortcuts are combined with any previously enabled shortcuts.
    ///
    /// - Parameter shortcuts: The shortcuts to enable.
    public func addShortcuts(_ shortcuts: AdwTabViewShortcuts) {
        adw_tab_view_add_shortcuts(opaquePointer, shortcuts)
    }

    /// Adds a new page to the tab view at the end of the list.
    ///
    /// - Parameter child: The widget to display in the new tab.
    /// - Returns: The ``TabPage`` representing the new tab.
    @discardableResult
    public func append(_ child: Widget) -> TabPage {
        let ptr = adw_tab_view_append(opaquePointer, child.widgetPointer)!
        return TabPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Adds a new pinned page to the tab view at the end of the pinned pages.
    ///
    /// Pinned pages are grouped before unpinned pages and cannot be reordered
    /// past unpinned ones.
    ///
    /// - Parameter child: The widget to display in the new pinned tab.
    /// - Returns: The ``TabPage`` representing the new pinned tab.
    @discardableResult
    public func appendPinned(_ child: Widget) -> TabPage {
        let ptr = adw_tab_view_append_pinned(opaquePointer, child.widgetPointer)!
        return TabPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Closes all pages except the given one.
    ///
    /// - Parameter page: The page to keep open.
    public func closeOtherPages(_ page: TabPage) {
        adw_tab_view_close_other_pages(opaquePointer, page.opaquePointer)
    }

    /// Requests closing a page.
    ///
    /// Emits the ``onClosePage(_:)`` signal. Call ``closePageFinish(_:confirm:)``
    /// from the signal handler to confirm or cancel the close.
    ///
    /// - Parameter page: The page to close.
    public func closePage(_ page: TabPage) {
        adw_tab_view_close_page(opaquePointer, page.opaquePointer)
    }

    /// Completes a close request initiated by ``closePage(_:)``.
    ///
    /// Must be called from the ``onClosePage(_:)`` handler.
    ///
    /// - Parameter page: The page being closed.
    /// - Parameter confirm: `true` to confirm closing, `false` to cancel.
    public func closePageFinish(_ page: TabPage, confirm: Bool) {
        adw_tab_view_close_page_finish(opaquePointer, page.opaquePointer, confirm ? 1 : 0)
    }

    /// Closes all pages after the given page.
    ///
    /// - Parameter page: The page after which all subsequent pages will be closed.
    public func closePagesAfter(_ page: TabPage) {
        adw_tab_view_close_pages_after(opaquePointer, page.opaquePointer)
    }

    /// Closes all pages before the given page.
    ///
    /// - Parameter page: The page before which all preceding pages will be closed.
    public func closePagesBefore(_ page: TabPage) {
        adw_tab_view_close_pages_before(opaquePointer, page.opaquePointer)
    }

    /// Returns the page at the given position.
    ///
    /// - Parameter position: The zero-based index of the page.
    /// - Returns: The ``TabPage`` at that position.
    @discardableResult
    public func getNthPage(_ position: Int) -> TabPage {
        let ptr = adw_tab_view_get_nth_page(opaquePointer, Int32(position))!
        return TabPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Returns the page for the given child widget.
    ///
    /// - Parameter child: The widget whose page to retrieve.
    /// - Returns: The ``TabPage`` containing the child.
    @discardableResult
    public func getPage(_ child: Widget) -> TabPage {
        let ptr = adw_tab_view_get_page(opaquePointer, child.widgetPointer)!
        return TabPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Returns the position of the given page.
    ///
    /// - Parameter page: The page whose position to retrieve.
    /// - Returns: The zero-based index of the page.
    @discardableResult
    public func getPagePosition(_ page: TabPage) -> Int {
        Int(adw_tab_view_get_page_position(opaquePointer, page.opaquePointer))
    }

    /// Inserts a new page at the given position.
    ///
    /// - Parameter child: The widget to display in the new tab.
    /// - Parameter position: The zero-based position to insert at.
    /// - Returns: The ``TabPage`` representing the new tab.
    @discardableResult
    public func insert(_ child: Widget, position: Int) -> TabPage {
        let ptr = adw_tab_view_insert(opaquePointer, child.widgetPointer, Int32(position))!
        return TabPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Inserts a new pinned page at the given position among pinned pages.
    ///
    /// - Parameter child: The widget to display in the new pinned tab.
    /// - Parameter position: The zero-based position among pinned pages.
    /// - Returns: The ``TabPage`` representing the new pinned tab.
    @discardableResult
    public func insertPinned(_ child: Widget, position: Int) -> TabPage {
        let ptr = adw_tab_view_insert_pinned(opaquePointer, child.widgetPointer, Int32(position))!
        return TabPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Invalidates all tab thumbnails, forcing them to be re-rendered.
    ///
    /// Use this after the content of pages has changed and thumbnails
    /// in ``TabOverview`` need to be refreshed.
    public func invalidateThumbnails() {
        adw_tab_view_invalidate_thumbnails(opaquePointer)
    }

    /// Adds a new page at the beginning of the tab list.
    ///
    /// - Parameter child: The widget to display in the new tab.
    /// - Returns: The ``TabPage`` representing the new tab.
    @discardableResult
    public func prepend(_ child: Widget) -> TabPage {
        let ptr = adw_tab_view_prepend(opaquePointer, child.widgetPointer)!
        return TabPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Adds a new pinned page at the beginning of the pinned pages.
    ///
    /// - Parameter child: The widget to display in the new pinned tab.
    /// - Returns: The ``TabPage`` representing the new pinned tab.
    @discardableResult
    public func prependPinned(_ child: Widget) -> TabPage {
        let ptr = adw_tab_view_prepend_pinned(opaquePointer, child.widgetPointer)!
        return TabPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Disables the specified keyboard shortcuts.
    ///
    /// - Parameter shortcuts: The shortcuts to disable.
    public func removeShortcuts(_ shortcuts: AdwTabViewShortcuts) {
        adw_tab_view_remove_shortcuts(opaquePointer, shortcuts)
    }

    /// Moves the page one position backward (toward the start).
    ///
    /// - Parameter page: The page to move.
    /// - Returns: `true` if the page was moved, `false` if it was already first.
    public func reorderBackward(_ page: TabPage) -> Bool {
        adw_tab_view_reorder_backward(opaquePointer, page.opaquePointer) != 0
    }

    /// Moves the page to the first position.
    ///
    /// - Parameter page: The page to move.
    /// - Returns: `true` if the page was moved, `false` if it was already first.
    public func reorderFirst(_ page: TabPage) -> Bool {
        adw_tab_view_reorder_first(opaquePointer, page.opaquePointer) != 0
    }

    /// Moves the page one position forward (toward the end).
    ///
    /// - Parameter page: The page to move.
    /// - Returns: `true` if the page was moved, `false` if it was already last.
    public func reorderForward(_ page: TabPage) -> Bool {
        adw_tab_view_reorder_forward(opaquePointer, page.opaquePointer) != 0
    }

    /// Moves the page to the last position.
    ///
    /// - Parameter page: The page to move.
    /// - Returns: `true` if the page was moved, `false` if it was already last.
    public func reorderLast(_ page: TabPage) -> Bool {
        adw_tab_view_reorder_last(opaquePointer, page.opaquePointer) != 0
    }

    /// Moves the page to the given position.
    ///
    /// - Parameter page: The page to move.
    /// - Parameter position: The zero-based target position.
    /// - Returns: `true` if the page was moved.
    public func reorderPage(_ page: TabPage, position: Int) -> Bool {
        adw_tab_view_reorder_page(opaquePointer, page.opaquePointer, Int32(position)) != 0
    }

    /// Selects the page after the currently selected one.
    ///
    /// - Returns: `true` if a next page existed and was selected.
    public func selectNextPage() -> Bool {
        adw_tab_view_select_next_page(opaquePointer) != 0
    }

    /// Selects the page before the currently selected one.
    ///
    /// - Returns: `true` if a previous page existed and was selected.
    public func selectPreviousPage() -> Bool {
        adw_tab_view_select_previous_page(opaquePointer) != 0
    }

    /// Pins or unpins a page.
    ///
    /// Pinned pages are grouped at the start of the tab strip and
    /// cannot be reordered past unpinned pages.
    ///
    /// - Parameter page: The page to pin or unpin.
    /// - Parameter pinned: `true` to pin the page, `false` to unpin it.
    public func setPagePinned(_ page: TabPage, pinned: Bool) {
        adw_tab_view_set_page_pinned(opaquePointer, page.opaquePointer, pinned ? 1 : 0)
    }

    /// Transfers a page to another tab view.
    ///
    /// Used for drag-and-drop tab transfers between windows.
    ///
    /// - Parameter page: The page to transfer.
    /// - Parameter otherView: The destination tab view.
    /// - Parameter position: The position in the destination view.
    public func transferPage(_ page: TabPage, otherView: TabView, position: Int) {
        adw_tab_view_transfer_page(opaquePointer, page.opaquePointer, otherView.opaquePointer, Int32(position))
    }

    /// Emitted when a page close is requested.
    ///
    /// Call ``closePageFinish(_:confirm:)`` from the handler to confirm
    /// or cancel the close.
    ///
    /// - Parameter handler: Called with the ``TabPage`` being closed.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onClosePage(_ handler: @escaping @MainActor (TabPage) -> Void) -> SignalConnection {
        SignalHelper.connectPointer(self, signal: .closePage) { (ptr: OpaquePointer) in
            handler(TabPage(borrowing: UnsafeMutableRawPointer(ptr)))
        }
    }

    /// Emitted when a new window should be created for a detached tab.
    ///
    /// - Parameter handler: Called when a tab is dragged out of the window.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onCreateWindow(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .createWindow, handler: handler)
    }

    /// Emitted when a tab's indicator icon is clicked.
    ///
    /// - Parameter handler: Called with the ``TabPage`` whose indicator was activated.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onIndicatorActivated(_ handler: @escaping @MainActor (TabPage) -> Void) -> SignalConnection {
        SignalHelper.connectPointer(self, signal: .indicatorActivated) { (ptr: OpaquePointer) in
            handler(TabPage(borrowing: UnsafeMutableRawPointer(ptr)))
        }
    }

    /// Emitted when a page is added to the tab view.
    ///
    /// - Parameter handler: Called with the attached ``TabPage`` and its position.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onPageAttached(_ handler: @escaping @MainActor (TabPage, Int) -> Void) -> SignalConnection {
        SignalHelper.connectPointerInt(self, signal: .pageAttached) { (ptr: OpaquePointer, pos: Int32) in
            handler(TabPage(borrowing: UnsafeMutableRawPointer(ptr)), Int(pos))
        }
    }

    /// Emitted when a page is removed from the tab view.
    ///
    /// - Parameter handler: Called with the detached ``TabPage`` and its former position.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onPageDetached(_ handler: @escaping @MainActor (TabPage, Int) -> Void) -> SignalConnection {
        SignalHelper.connectPointerInt(self, signal: .pageDetached) { (ptr: OpaquePointer, pos: Int32) in
            handler(TabPage(borrowing: UnsafeMutableRawPointer(ptr)), Int(pos))
        }
    }

    /// Emitted when a page is moved to a new position.
    ///
    /// - Parameter handler: Called with the reordered ``TabPage`` and its new position.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onPageReordered(_ handler: @escaping @MainActor (TabPage, Int) -> Void) -> SignalConnection {
        SignalHelper.connectPointerInt(self, signal: .pageReordered) { (ptr: OpaquePointer, pos: Int32) in
            handler(TabPage(borrowing: UnsafeMutableRawPointer(ptr)), Int(pos))
        }
    }

    /// Emitted before a context menu is shown for a tab.
    ///
    /// Use this to populate a context menu model before it is displayed.
    ///
    /// - Parameter handler: Called with the ``TabPage`` the menu is for.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onSetupMenu(_ handler: @escaping @MainActor (TabPage) -> Void) -> SignalConnection {
        SignalHelper.connectPointer(self, signal: .setupMenu) { (ptr: OpaquePointer) in
            handler(TabPage(borrowing: UnsafeMutableRawPointer(ptr)))
        }
    }
}
