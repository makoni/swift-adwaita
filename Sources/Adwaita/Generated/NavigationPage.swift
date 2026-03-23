// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// a navigation page
/// - Since: libadwaita 1.4
@MainActor
public class NavigationPage: Widget {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `NavigationPage`.
    public init(child: Widget, title: String) {
        let ptr = adw_navigation_page_new(child.widgetPointer, title)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a new `NavigationPage`.
    public static func newWithTag(child: Widget, title: String, tag: String) -> NavigationPage {
        let ptr = adw_navigation_page_new_with_tag(child.widgetPointer, title, tag)!
        return NavigationPage(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `can-pop` property.
    /// - Since: libadwaita 1.4
    public var canPop: Bool {
        get { adw_navigation_page_get_can_pop(castedPointer() as UnsafeMutablePointer<AdwNavigationPage>) != 0 }
        set { adw_navigation_page_set_can_pop(castedPointer() as UnsafeMutablePointer<AdwNavigationPage>, newValue ? 1 : 0) }
    }

    /// The `child` property.
    /// - Since: libadwaita 1.4
    public var child: Widget? {
        get { (adw_navigation_page_get_child(castedPointer() as UnsafeMutablePointer<AdwNavigationPage>)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_navigation_page_set_child(castedPointer() as UnsafeMutablePointer<AdwNavigationPage>, newValue?.widgetPointer) }
    }

    /// The `tag` property.
    /// - Since: libadwaita 1.4
    public var tag: String? {
        get { (adw_navigation_page_get_tag(castedPointer() as UnsafeMutablePointer<AdwNavigationPage>)).map { String(cString: $0) } }
        set { adw_navigation_page_set_tag(castedPointer() as UnsafeMutablePointer<AdwNavigationPage>, newValue) }
    }

    /// The `title` property.
    /// - Since: libadwaita 1.4
    public var title: String {
        get { String(cString: adw_navigation_page_get_title(castedPointer() as UnsafeMutablePointer<AdwNavigationPage>)) }
        set { adw_navigation_page_set_title(castedPointer() as UnsafeMutablePointer<AdwNavigationPage>, newValue) }
    }

    /// Connects to the `hidden` signal.
    @discardableResult
    public func onHidden(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "hidden", handler: handler)
    }

    /// Connects to the `hiding` signal.
    @discardableResult
    public func onHiding(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "hiding", handler: handler)
    }

    /// Connects to the `showing` signal.
    @discardableResult
    public func onShowing(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "showing", handler: handler)
    }

    /// Connects to the `shown` signal.
    @discardableResult
    public func onShown(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "shown", handler: handler)
    }
}
