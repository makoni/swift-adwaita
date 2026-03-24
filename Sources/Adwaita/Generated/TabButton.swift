// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A button that displays the number of [class@TabView] pages.
/// - Since: libadwaita 1.3
@MainActor
public final class TabButton: Widget {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `TabButton`.
    public init() {
        let ptr = adw_tab_button_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `view` property.
    /// - Since: libadwaita 1.3
    public var view: TabView? {
        get { (adw_tab_button_get_view(opaquePointer)).map { TabView(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_tab_button_set_view(opaquePointer, newValue?.opaquePointer) }
    }

    /// Connects to the `activate` signal.
    @discardableResult
    public func onActivate(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .activate, handler: handler)
    }

    /// Connects to the `clicked` signal.
    @discardableResult
    public func onClicked(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .clicked, handler: handler)
    }
}
