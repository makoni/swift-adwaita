// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A helper object for [class@ToastOverlay].
@MainActor
public final class Toast: GObjectRef {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `Toast`.
    public init(title: String) {
        let ptr = adw_toast_new(title)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `action-name` property.
    public var actionName: String? {
        get { (adw_toast_get_action_name(opaquePointer)).map { String(cString: $0) } }
        set { adw_toast_set_action_name(opaquePointer, newValue) }
    }

    /// The `action-target` property.
    public var actionTarget: OpaquePointer? {
        get { adw_toast_get_action_target_value(opaquePointer) }
        set { adw_toast_set_action_target_value(opaquePointer, newValue) }
    }

    /// The `button-label` property.
    public var buttonLabel: String? {
        get { (adw_toast_get_button_label(opaquePointer)).map { String(cString: $0) } }
        set { adw_toast_set_button_label(opaquePointer, newValue) }
    }

    /// The `custom-title` property.
    /// - Since: libadwaita 1.2
    public var customTitle: Widget? {
        get { (adw_toast_get_custom_title(opaquePointer)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_toast_set_custom_title(opaquePointer, newValue?.widgetPointer) }
    }

    /// The `priority` property.
    public var priority: AdwToastPriority {
        get { adw_toast_get_priority(opaquePointer) }
        set { adw_toast_set_priority(opaquePointer, newValue) }
    }

    /// The `timeout` property.
    public var timeout: Int {
        get { Int(adw_toast_get_timeout(opaquePointer)) }
        set { adw_toast_set_timeout(opaquePointer, UInt32(newValue)) }
    }

    /// The `title` property.
    public var title: String? {
        get { (adw_toast_get_title(opaquePointer)).map { String(cString: $0) } }
        set { adw_toast_set_title(opaquePointer, newValue) }
    }

    /// The `use-markup` property.
    /// - Since: libadwaita 1.4
    public var useMarkup: Bool {
        get { adw_toast_get_use_markup(opaquePointer) != 0 }
        set { adw_toast_set_use_markup(opaquePointer, newValue ? 1 : 0) }
    }

    /// Calls `adw_toast_dismiss`.
    public func dismiss() {
        adw_toast_dismiss(opaquePointer)
    }

    /// Calls `adw_toast_set_detailed_action_name`.
    public func setDetailedActionName(_ detailedActionName: String?) {
        adw_toast_set_detailed_action_name(opaquePointer, detailedActionName)
    }

    /// Connects to the `button-clicked` signal.
    @discardableResult
    public func onButtonClicked(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "button-clicked", handler: handler)
    }

    /// Connects to the `dismissed` signal.
    @discardableResult
    public func onDismissed(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "dismissed", handler: handler)
    }
}
