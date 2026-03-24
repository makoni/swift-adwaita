// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A dialog presenting a message or a question.
/// - Since: libadwaita 1.5
@MainActor
public class AlertDialog: Dialog {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `AlertDialog`.
    public init(heading: String?, body: String?) {
        let ptr = adw_alert_dialog_new(heading, body)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `body` property.
    /// - Since: libadwaita 1.5
    public var body: String {
        get { String(cString: adw_alert_dialog_get_body(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>)) }
        set { adw_alert_dialog_set_body(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, newValue) }
    }

    /// The `body-use-markup` property.
    /// - Since: libadwaita 1.5
    public var bodyUseMarkup: Bool {
        get { adw_alert_dialog_get_body_use_markup(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>) != 0 }
        set { adw_alert_dialog_set_body_use_markup(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, newValue ? 1 : 0) }
    }

    /// The `close-response` property.
    /// - Since: libadwaita 1.5
    public var closeResponse: String {
        get { String(cString: adw_alert_dialog_get_close_response(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>)) }
        set { adw_alert_dialog_set_close_response(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, newValue) }
    }

    /// The `default-response` property.
    /// - Since: libadwaita 1.5
    public var defaultResponse: String? {
        get { (adw_alert_dialog_get_default_response(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>)).map { String(cString: $0) } }
        set { adw_alert_dialog_set_default_response(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, newValue) }
    }

    /// The `extra-child` property.
    /// - Since: libadwaita 1.5
    public var extraChild: Widget? {
        get { (adw_alert_dialog_get_extra_child(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_alert_dialog_set_extra_child(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, newValue?.widgetPointer) }
    }

    /// The `heading` property.
    /// - Since: libadwaita 1.5
    public var heading: String? {
        get { (adw_alert_dialog_get_heading(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>)).map { String(cString: $0) } }
        set { adw_alert_dialog_set_heading(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, newValue) }
    }

    /// The `heading-use-markup` property.
    /// - Since: libadwaita 1.5
    public var headingUseMarkup: Bool {
        get { adw_alert_dialog_get_heading_use_markup(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>) != 0 }
        set { adw_alert_dialog_set_heading_use_markup(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, newValue ? 1 : 0) }
    }

    /// The `prefer-wide-layout` property.
    /// - Since: libadwaita 1.6
    public var preferWideLayout: Bool {
        get { adw_alert_dialog_get_prefer_wide_layout(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>) != 0 }
        set { adw_alert_dialog_set_prefer_wide_layout(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, newValue ? 1 : 0) }
    }

    /// Calls `adw_alert_dialog_add_response`.
    public func addResponse(_ id: String, label: String) {
        adw_alert_dialog_add_response(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, id, label)
    }

    /// Calls `adw_alert_dialog_get_response_appearance`.
    @discardableResult
    public func getResponseAppearance(_ response: String) -> AdwResponseAppearance {
        return adw_alert_dialog_get_response_appearance(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, response)
    }

    /// Calls `adw_alert_dialog_get_response_enabled`.
    public func getResponseEnabled(_ response: String) -> Bool {
        return adw_alert_dialog_get_response_enabled(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, response) != 0
    }

    /// Calls `adw_alert_dialog_get_response_label`.
    @discardableResult
    public func getResponseLabel(_ response: String) -> String {
        return String(cString: adw_alert_dialog_get_response_label(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, response))
    }

    /// Calls `adw_alert_dialog_has_response`.
    public func hasResponse(_ response: String) -> Bool {
        return adw_alert_dialog_has_response(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, response) != 0
    }

    /// Calls `adw_alert_dialog_remove_response`.
    public func removeResponse(_ id: String) {
        adw_alert_dialog_remove_response(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, id)
    }

    /// Calls `adw_alert_dialog_set_response_appearance`.
    public func setResponseAppearance(_ response: String, appearance: AdwResponseAppearance) {
        adw_alert_dialog_set_response_appearance(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, response, appearance)
    }

    /// Calls `adw_alert_dialog_set_response_enabled`.
    public func setResponseEnabled(_ response: String, enabled: Bool) {
        adw_alert_dialog_set_response_enabled(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, response, enabled ? 1 : 0)
    }

    /// Calls `adw_alert_dialog_set_response_label`.
    public func setResponseLabel(_ response: String, label: String) {
        adw_alert_dialog_set_response_label(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, response, label)
    }

    /// Connects to the `response` signal.
    @discardableResult
    public func onResponse(_ handler: @escaping @MainActor (String) -> Void) -> SignalConnection {
        SignalHelper.connectString(self, signal: .response, handler: handler)
    }
}
