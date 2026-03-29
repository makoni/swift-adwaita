// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A page within a ``NavigationView`` or ``NavigationSplitView``.
///
/// Wraps `AdwNavigationPage`. Each page has a title (shown in the header bar)
/// and an optional tag for programmatic lookup. Lifecycle signals let you
/// react when a page is shown, hidden, or about to appear.
///
/// ```swift
/// let page = NavigationPage(child: myWidget, title: "Settings")
///
/// // Create a tagged page for push-by-tag navigation
/// let tagged = NavigationPage.newWithTag(
///     child: detailView, title: "Profile", tag: "profile"
/// )
///
/// // React to page visibility
/// page.onShowing { print("Page is about to appear") }
/// page.onHidden  { print("Page is now hidden") }
/// ```
///
/// - Since: libadwaita 1.4
@MainActor
public class NavigationPage: Widget {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new navigation page wrapping a child widget.
    ///
    /// - Parameters:
    ///   - child: The widget to display as the page content.
    ///   - title: The page title, shown in the header bar back button.
    public init(child: Widget, title: String) {
        let ptr = adw_navigation_page_new(child.widgetPointer, title)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a new navigation page with a tag for programmatic lookup.
    ///
    /// - Parameters:
    ///   - child: The widget to display as the page content.
    ///   - title: The page title, shown in the header bar back button.
    ///   - tag: A unique string identifier for ``NavigationView/findPage(_:)``
    ///     and ``NavigationView/pushByTag(_:)``.
    public static func newWithTag(child: Widget, title: String, tag: String) -> NavigationPage {
        let ptr = adw_navigation_page_new_with_tag(child.widgetPointer, title, tag)!
        return NavigationPage(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Whether the user can navigate back from this page. Set to `false` to
    /// prevent the page from being popped (disables back button and gestures).
    /// - Since: libadwaita 1.4
    public var canPop: Bool {
        get { adw_navigation_page_get_can_pop(castedPointer() as UnsafeMutablePointer<AdwNavigationPage>) != 0 }
        set { adw_navigation_page_set_can_pop(
            castedPointer() as UnsafeMutablePointer<AdwNavigationPage>,
            newValue ? 1 : 0
        ) }
    }

    /// The content widget displayed inside this page.
    /// - Since: libadwaita 1.4
    public var child: Widget? {
        get {
            adw_navigation_page_get_child(castedPointer() as UnsafeMutablePointer<AdwNavigationPage>)
                .map { Widget(borrowing: UnsafeMutableRawPointer($0)) }
        }
        set { adw_navigation_page_set_child(
            castedPointer() as UnsafeMutablePointer<AdwNavigationPage>,
            newValue?.widgetPointer
        ) }
    }

    /// A unique string identifier for this page, used with
    /// ``NavigationView/pushByTag(_:)`` and ``NavigationView/findPage(_:)``.
    /// - Since: libadwaita 1.4
    public var tag: String? {
        get {
            adw_navigation_page_get_tag(castedPointer() as UnsafeMutablePointer<AdwNavigationPage>)
                .map { String(cString: $0) }
        }
        set { adw_navigation_page_set_tag(castedPointer() as UnsafeMutablePointer<AdwNavigationPage>, newValue) }
    }

    /// The page title displayed in the header bar and back button of the navigation view.
    /// - Since: libadwaita 1.4
    public var title: String {
        get {
            String(cString: adw_navigation_page_get_title(castedPointer() as UnsafeMutablePointer<AdwNavigationPage>))
        }
        set { adw_navigation_page_set_title(castedPointer() as UnsafeMutablePointer<AdwNavigationPage>, newValue) }
    }

    /// Emitted when the page is fully hidden.
    ///
    /// - Parameter handler: A closure invoked when the page is no longer visible.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onHidden(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .hidden, handler: handler)
    }

    /// Emitted when the page is starting to hide.
    ///
    /// - Parameter handler: A closure invoked when the hiding transition begins.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onHiding(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .hiding, handler: handler)
    }

    /// Emitted when the page is starting to show.
    ///
    /// - Parameter handler: A closure invoked when the showing transition begins.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onShowing(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .showing, handler: handler)
    }

    /// Emitted when the page is fully shown.
    ///
    /// - Parameter handler: A closure invoked when the page is fully visible.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onShown(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .shown, handler: handler)
    }
}
