// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A stack-based navigation container that pushes and pops pages.
///
/// Wraps `AdwNavigationView`. This is the primary navigation pattern for
/// GNOME apps that need hierarchical, drill-down navigation (master-detail).
/// Pages are pushed onto a stack and popped when the user navigates back.
///
/// ```swift
/// let nav = NavigationView()
///
/// let listPage = NavigationPage(child: listBox, title: "Contacts")
/// nav.add(listPage)
///
/// // Push a detail page when a row is selected
/// listBox.onRowActivated { row in
///     let detail = Label(text: "Detail for row \(row.index)")
///     nav.push(title: "Detail", child: detail)
/// }
///
/// // Pop programmatically
/// backButton.onClicked { nav.pop() }
/// ```
///
/// - Since: libadwaita 1.4
@MainActor
public final class NavigationView: Widget, Swipeable {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `NavigationView`.
    public init() {
        let ptr = adw_navigation_view_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Whether page transitions are animated. Defaults to `true`.
    /// - Since: libadwaita 1.4
    public var animateTransitions: Bool {
        get { adw_navigation_view_get_animate_transitions(opaquePointer) != 0 }
        set { adw_navigation_view_set_animate_transitions(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether all pages are the same width. When `true`, the navigation view
    /// allocates the width of the widest page to all pages.
    /// - Since: libadwaita 1.7
    public var hhomogeneous: Bool {
        get { adw_navigation_view_get_hhomogeneous(opaquePointer) != 0 }
        set { adw_navigation_view_set_hhomogeneous(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether pressing Escape pops the current page. Defaults to `true`.
    /// - Since: libadwaita 1.4
    public var popOnEscape: Bool {
        get { adw_navigation_view_get_pop_on_escape(opaquePointer) != 0 }
        set { adw_navigation_view_set_pop_on_escape(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether all pages are the same height. When `true`, the navigation view
    /// allocates the height of the tallest page to all pages.
    /// - Since: libadwaita 1.7
    public var vhomogeneous: Bool {
        get { adw_navigation_view_get_vhomogeneous(opaquePointer) != 0 }
        set { adw_navigation_view_set_vhomogeneous(opaquePointer, newValue ? 1 : 0) }
    }

    /// The currently visible page on top of the navigation stack (read-only).
    /// - Since: libadwaita 1.4
    public var visiblePage: NavigationPage? {
        (adw_navigation_view_get_visible_page(opaquePointer)).map { NavigationPage(borrowing: UnsafeMutableRawPointer($0)) }
    }

    /// The tag of the currently visible page (read-only).
    /// - Since: libadwaita 1.7
    public var visiblePageTag: String? {
        (adw_navigation_view_get_visible_page_tag(opaquePointer)).map { String(cString: $0) }
    }

    /// Finds a page by its tag, or returns `nil` if no page has that tag.
    ///
    /// - Parameter tag: The tag string assigned to the page.
    @discardableResult
    public func findPage(_ tag: String) -> NavigationPage? {
        return (adw_navigation_view_find_page(opaquePointer, tag)).map { NavigationPage(borrowing: UnsafeMutableRawPointer($0)) }
    }

    /// Pops the visible page from the navigation stack. Returns `true` if a
    /// page was popped, `false` if the stack had only one page.
    public func pop() -> Bool {
        return adw_navigation_view_pop(opaquePointer) != 0
    }

    /// Pops pages until the page with the given tag is visible. Returns `true`
    /// if the tag was found and pages were popped.
    ///
    /// - Parameter tag: The tag of the target page to pop back to.
    public func popToTag(_ tag: String) -> Bool {
        return adw_navigation_view_pop_to_tag(opaquePointer, tag) != 0
    }

    /// Pushes a previously added page onto the stack by its tag.
    ///
    /// The page must have been added with ``add(_:)`` beforehand.
    /// - Parameter tag: The tag of the page to push.
    public func pushByTag(_ tag: String) {
        adw_navigation_view_push_by_tag(opaquePointer, tag)
    }

    /// Adds a page to the navigation view without pushing it onto the stack.
    ///
    /// Use this to pre-register pages that can later be pushed by tag with
    /// ``pushByTag(_:)``.
    public func add(_ page: NavigationPage) {
        adw_navigation_view_add(opaquePointer, page.castedPointer() as UnsafeMutablePointer<AdwNavigationPage>)
    }

    /// Pushes a page onto the navigation stack.
    public func push(_ page: NavigationPage) {
        g_object_ref(page.pointer)
        adw_navigation_view_push(opaquePointer, page.castedPointer() as UnsafeMutablePointer<AdwNavigationPage>)
    }

    /// Creates a NavigationPage and pushes it onto the stack.
    @discardableResult
    public func push(title: String, child: Widget) -> NavigationPage {
        let page = NavigationPage(child: child, title: title)
        push(page)
        return page
    }

    /// Creates a tagged NavigationPage and pushes it onto the stack.
    @discardableResult
    public func push(title: String, tag: String, child: Widget) -> NavigationPage {
        let page = NavigationPage.newWithTag(child: child, title: title, tag: tag)
        push(page)
        return page
    }

    /// Emitted when the next page is needed for forward navigation (e.g. swipe gestures).
    ///
    /// - Parameter handler: A closure invoked when forward navigation requires a new page.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onGetNextPage(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .getNextPage, handler: handler)
    }

    /// Emitted when a page has been popped from the navigation stack.
    ///
    /// The handler receives the page that was removed from the stack.
    ///
    /// - Parameter handler: A closure invoked with the popped ``NavigationPage``.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onPopped(_ handler: @escaping @MainActor (NavigationPage) -> Void) -> SignalConnection {
        SignalHelper.connectPointer(self, signal: .popped) { (ptr: OpaquePointer) in
            handler(NavigationPage(borrowing: UnsafeMutableRawPointer(ptr)))
        }
    }

    /// Emitted when a page has been pushed onto the navigation stack.
    ///
    /// - Parameter handler: A closure invoked after the page is pushed.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onPushed(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .pushed, handler: handler)
    }

    /// Emitted when the navigation stack has been replaced (e.g. all pages swapped at once).
    ///
    /// - Parameter handler: A closure invoked after the stack is replaced.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onReplaced(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .replaced, handler: handler)
    }
}
