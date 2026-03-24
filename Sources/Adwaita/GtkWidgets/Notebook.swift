import CAdwaita
import GObjectSupport

/// A tabbed container widget.
///
/// Wraps `GtkNotebook`. For modern Adwaita apps, consider using `TabView` instead.
@MainActor
public final class Notebook: Widget {
    /// Creates a new notebook.
    public init() {
        let ptr = gtk_notebook_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Appends a page with a text label. Returns the page index.
    @discardableResult
    public func appendPage(_ child: Widget, label: String) -> Int {
        let tabLabel = Label(label)
        return Int(gtk_notebook_append_page(opaquePointer, child.widgetPointer, tabLabel.widgetPointer))
    }

    /// Appends a page with a custom tab widget. Returns the page index.
    @discardableResult
    public func appendPage(_ child: Widget, tabWidget: Widget) -> Int {
        Int(gtk_notebook_append_page(opaquePointer, child.widgetPointer, tabWidget.widgetPointer))
    }

    /// Prepends a page with a text label. Returns the page index.
    @discardableResult
    public func prependPage(_ child: Widget, label: String) -> Int {
        let tabLabel = Label(label)
        return Int(gtk_notebook_prepend_page(opaquePointer, child.widgetPointer, tabLabel.widgetPointer))
    }

    /// Inserts a page at the given position. Returns the page index.
    @discardableResult
    public func insertPage(_ child: Widget, label: String, position: Int) -> Int {
        let tabLabel = Label(label)
        return Int(gtk_notebook_insert_page(opaquePointer, child.widgetPointer, tabLabel.widgetPointer, Int32(position)))
    }

    /// Removes the page at the given index.
    public func removePage(at index: Int) {
        gtk_notebook_remove_page(opaquePointer, Int32(index))
    }

    /// The index of the current page.
    public var currentPage: Int {
        get { Int(gtk_notebook_get_current_page(opaquePointer)) }
        set { gtk_notebook_set_current_page(opaquePointer, Int32(newValue)) }
    }

    /// The total number of pages.
    public var nPages: Int {
        Int(gtk_notebook_get_n_pages(opaquePointer))
    }

    /// Switches to the next page.
    public func nextPage() {
        gtk_notebook_next_page(opaquePointer)
    }

    /// Switches to the previous page.
    public func prevPage() {
        gtk_notebook_prev_page(opaquePointer)
    }

    /// Returns the child widget at the given page index.
    public func getNthPage(_ index: Int) -> Widget? {
        guard let ptr = gtk_notebook_get_nth_page(opaquePointer, Int32(index)) else { return nil }
        return Widget(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Returns the page index of the given child widget.
    public func pageNum(_ child: Widget) -> Int {
        Int(gtk_notebook_page_num(opaquePointer, child.widgetPointer))
    }

    /// Whether to show the page tabs.
    public var showTabs: Bool {
        get { gtk_notebook_get_show_tabs(opaquePointer) != 0 }
        set { gtk_notebook_set_show_tabs(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether to show the border around the notebook.
    public var showBorder: Bool {
        get { gtk_notebook_get_show_border(opaquePointer) != 0 }
        set { gtk_notebook_set_show_border(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the tabs are scrollable when there are too many.
    public var scrollable: Bool {
        get { gtk_notebook_get_scrollable(opaquePointer) != 0 }
        set { gtk_notebook_set_scrollable(opaquePointer, newValue ? 1 : 0) }
    }

    /// The position of the tabs.
    public var tabPos: GtkPositionType {
        get { gtk_notebook_get_tab_pos(opaquePointer) }
        set { gtk_notebook_set_tab_pos(opaquePointer, newValue) }
    }

    /// Sets or gets the tab label text for a child.
    public func setTabLabelText(_ child: Widget, text: String) {
        gtk_notebook_set_tab_label_text(opaquePointer, child.widgetPointer, text)
    }

    /// Gets the tab label text for a child.
    public func getTabLabelText(_ child: Widget) -> String? {
        gtk_notebook_get_tab_label_text(opaquePointer, child.widgetPointer).map { String(cString: $0) }
    }

    /// Whether a page's tab is reorderable by dragging.
    public func setTabReorderable(_ child: Widget, reorderable: Bool) {
        gtk_notebook_set_tab_reorderable(opaquePointer, child.widgetPointer, reorderable ? 1 : 0)
    }

    /// Reorders a child to a new position.
    public func reorderChild(_ child: Widget, position: Int) {
        gtk_notebook_reorder_child(opaquePointer, child.widgetPointer, Int32(position))
    }

    /// Connects to the `switch-page` signal.
    @discardableResult
    public func onSwitchPage(_ handler: @escaping @MainActor (Int) -> Void) -> SignalConnection {
        SignalHelper.connectPointerInt(self, signal: .switchPage) { _, pageNum in
            handler(Int(pageNum))
        }
    }
}
