// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A page-based navigation container.
/// - Since: libadwaita 1.4
@MainActor
public final class NavigationView: Widget, Swipeable {

    /// The underlying `AdwSwipeable` pointer.
    public var swipeablePointer: OpaquePointer { opaquePointer }

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `NavigationView`.
    public init() {
        let ptr = adw_navigation_view_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `animate-transitions` property.
    /// - Since: libadwaita 1.4
    public var animateTransitions: Bool {
        get { adw_navigation_view_get_animate_transitions(opaquePointer) != 0 }
        set { adw_navigation_view_set_animate_transitions(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `hhomogeneous` property.
    /// - Since: libadwaita 1.7
    public var hhomogeneous: Bool {
        get { adw_navigation_view_get_hhomogeneous(opaquePointer) != 0 }
        set { adw_navigation_view_set_hhomogeneous(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `pop-on-escape` property.
    /// - Since: libadwaita 1.4
    public var popOnEscape: Bool {
        get { adw_navigation_view_get_pop_on_escape(opaquePointer) != 0 }
        set { adw_navigation_view_set_pop_on_escape(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `vhomogeneous` property.
    /// - Since: libadwaita 1.7
    public var vhomogeneous: Bool {
        get { adw_navigation_view_get_vhomogeneous(opaquePointer) != 0 }
        set { adw_navigation_view_set_vhomogeneous(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `visible-page` property (read-only).
    /// - Since: libadwaita 1.4
    public var visiblePage: NavigationPage? {
        (adw_navigation_view_get_visible_page(opaquePointer)).map { NavigationPage(borrowing: UnsafeMutableRawPointer($0)) }
    }

    /// The `visible-page-tag` property (read-only).
    /// - Since: libadwaita 1.7
    public var visiblePageTag: String? {
        (adw_navigation_view_get_visible_page_tag(opaquePointer)).map { String(cString: $0) }
    }

    /// Finds a page by its tag.
    @discardableResult
    public func findPage(_ tag: String) -> NavigationPage? {
        return (adw_navigation_view_find_page(opaquePointer, tag)).map { NavigationPage(borrowing: UnsafeMutableRawPointer($0)) }
    }

    /// Calls `adw_navigation_view_pop`.
    public func pop() -> Bool {
        return adw_navigation_view_pop(opaquePointer) != 0
    }

    /// Calls `adw_navigation_view_pop_to_tag`.
    public func popToTag(_ tag: String) -> Bool {
        return adw_navigation_view_pop_to_tag(opaquePointer, tag) != 0
    }

    /// Calls `adw_navigation_view_push_by_tag`.
    public func pushByTag(_ tag: String) {
        adw_navigation_view_push_by_tag(opaquePointer, tag)
    }

    /// Adds a page to the navigation view.
    public func add(_ page: NavigationPage) {
        adw_navigation_view_add(opaquePointer, page.castedPointer() as UnsafeMutablePointer<AdwNavigationPage>)
    }

    /// Pushes a page onto the navigation stack.
    public func push(_ page: NavigationPage) {
        g_object_ref(page.pointer)
        adw_navigation_view_push(opaquePointer, page.castedPointer() as UnsafeMutablePointer<AdwNavigationPage>)
    }

    /// Connects to the `get-next-page` signal.
    @discardableResult
    public func onGetNextPage(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "get-next-page", handler: handler)
    }

    /// Connects to the `popped` signal.
    @discardableResult
    public func onPopped(_ handler: @escaping @MainActor (NavigationPage) -> Void) -> SignalConnection {
        SignalHelper.connectPointer(self, signal: "popped") { (ptr: OpaquePointer) in
            handler(NavigationPage(borrowing: UnsafeMutableRawPointer(ptr)))
        }
    }

    /// Connects to the `pushed` signal.
    @discardableResult
    public func onPushed(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "pushed", handler: handler)
    }

    /// Connects to the `replaced` signal.
    @discardableResult
    public func onReplaced(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "replaced", handler: handler)
    }
}
