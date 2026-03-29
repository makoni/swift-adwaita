// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A temporary in-app notification message shown inside a ``ToastOverlay``.
///
/// Wraps `AdwToast`. A toast slides in from the bottom of the overlay,
/// displays a brief message, and automatically dismisses after a timeout.
/// It can optionally include an action button.
///
/// ```swift
/// let toast = Toast(title: "File saved")
/// toast.timeout = 3
///
/// // Optionally add an action button
/// toast.buttonLabel = "Undo"
/// toast.onButtonClicked {
///     // undo the save
/// }
///
/// toast.onDismissed {
///     print("Toast gone")
/// }
///
/// overlay.addToast(toast)
/// ```
///
/// You typically do not show a toast directly; instead, pass it to
/// ``ToastOverlay/addToast(_:)`` or use the convenience method
/// ``ToastOverlay/showToast(_:)``.
@MainActor
public final class Toast: GObjectRef {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `Toast`.
    public init(title: String) {
        let ptr = adw_toast_new(title)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The GAction name activated when the toast's button is clicked.
    public var actionName: String? {
        get { adw_toast_get_action_name(opaquePointer).map { String(cString: $0) } }
        set { adw_toast_set_action_name(opaquePointer, newValue) }
    }

    /// The action target value, used to activate the action with a parameter.
    public var actionTarget: Variant? {
        get {
            guard let ptr = adw_toast_get_action_target_value(opaquePointer) else { return nil }
            return Variant(borrowing: ptr)
        }
        set { adw_toast_set_action_target_value(opaquePointer, newValue?.pointer) }
    }

    /// The label displayed on the toast's action button, or `nil` for no button.
    public var buttonLabel: String? {
        get { adw_toast_get_button_label(opaquePointer).map { String(cString: $0) } }
        set { adw_toast_set_button_label(opaquePointer, newValue) }
    }

    /// A custom widget to use as the toast's title instead of a text label.
    /// - Since: libadwaita 1.2
    public var customTitle: Widget? {
        get { adw_toast_get_custom_title(opaquePointer).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_toast_set_custom_title(opaquePointer, newValue?.widgetPointer) }
    }

    /// The priority of the toast. High-priority toasts are shown immediately.
    public var priority: AdwToastPriority {
        get { adw_toast_get_priority(opaquePointer) }
        set { adw_toast_set_priority(opaquePointer, newValue) }
    }

    /// The time in seconds before the toast auto-dismisses. Use `0` to keep it indefinitely.
    public var timeout: Int {
        get { Int(adw_toast_get_timeout(opaquePointer)) }
        set { adw_toast_set_timeout(opaquePointer, UInt32(newValue)) }
    }

    /// The text message displayed in the toast.
    public var title: String? {
        get { adw_toast_get_title(opaquePointer).map { String(cString: $0) } }
        set { adw_toast_set_title(opaquePointer, newValue) }
    }

    /// Whether the title text is interpreted as Pango markup.
    /// - Since: libadwaita 1.4
    public var useMarkup: Bool {
        get { adw_toast_get_use_markup(opaquePointer) != 0 }
        set { adw_toast_set_use_markup(opaquePointer, newValue ? 1 : 0) }
    }

    /// Dismisses the toast immediately without waiting for the timeout.
    public func dismiss() {
        adw_toast_dismiss(opaquePointer)
    }

    /// Sets the action name and target from a detailed action string.
    ///
    /// - Parameter detailedActionName: A detailed action name (e.g. `"app.save"` or `"win.page::about"`).
    public func setDetailedActionName(_ detailedActionName: String?) {
        adw_toast_set_detailed_action_name(opaquePointer, detailedActionName)
    }

    /// Emitted when the toast's action button is clicked.
    ///
    /// - Parameter handler: Called when the button is clicked.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onButtonClicked(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .buttonClicked, handler: handler)
    }

    /// Emitted when the toast is dismissed (either by timeout or manually).
    ///
    /// - Parameter handler: Called when the toast disappears.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onDismissed(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .dismissed, handler: handler)
    }
}
