// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A bar with contextual information.
/// - Since: libadwaita 1.3
@MainActor
public final class Banner: Widget {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `Banner`.
    public init(title: String) {
        let ptr = adw_banner_new(title)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `button-label` property.
    /// - Since: libadwaita 1.3
    public var buttonLabel: String? {
        get { (adw_banner_get_button_label(opaquePointer)).map { String(cString: $0) } }
        set { adw_banner_set_button_label(opaquePointer, newValue) }
    }

    /// The `button-style` property.
    /// - Since: libadwaita 1.7
    public var buttonStyle: AdwBannerButtonStyle {
        get { adw_banner_get_button_style(opaquePointer) }
        set { adw_banner_set_button_style(opaquePointer, newValue) }
    }

    /// The `revealed` property.
    /// - Since: libadwaita 1.3
    public var revealed: Bool {
        get { adw_banner_get_revealed(opaquePointer) != 0 }
        set { adw_banner_set_revealed(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `title` property.
    /// - Since: libadwaita 1.3
    public var title: String {
        get { String(cString: adw_banner_get_title(opaquePointer)) }
        set { adw_banner_set_title(opaquePointer, newValue) }
    }

    /// The `use-markup` property.
    /// - Since: libadwaita 1.3
    public var useMarkup: Bool {
        get { adw_banner_get_use_markup(opaquePointer) != 0 }
        set { adw_banner_set_use_markup(opaquePointer, newValue ? 1 : 0) }
    }

    /// Connects to the `button-clicked` signal.
    @discardableResult
    public func onButtonClicked(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "button-clicked", handler: handler)
    }
}
