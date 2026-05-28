// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A dialog that presents a message or confirmation prompt with response buttons.
///
/// Wraps `AdwAlertDialog`. Use this to ask the user a question, show a
/// warning, or request confirmation before a destructive action. Each
/// response is identified by a string ID and can be styled with an
/// appearance (e.g. destructive or suggested).
///
/// ```swift
/// let dialog = AlertDialog(heading: "Delete File?",
///                          body: "This action cannot be undone.")
/// dialog.addResponse("cancel", label: "Cancel")
/// dialog.addResponse("delete", label: "Delete")
/// dialog.setResponseAppearance("delete", appearance: ADW_RESPONSE_DESTRUCTIVE)
/// dialog.defaultResponse = "cancel"
/// dialog.closeResponse = "cancel"
///
/// dialog.onResponse { response in
///     if response == "delete" {
///         // perform deletion
///     }
/// }
///
/// dialog.present(window)
/// ```
///
/// - Since: libadwaita 1.5
@MainActor
public class AlertDialog: Dialog {
    override public class var gtkType: GType {
        adw_alert_dialog_get_type()
    }


    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `AlertDialog`.
    public init(heading: String?, body: String?) {
        let ptr = adw_alert_dialog_new(heading, body)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The body text displayed below the heading.
    /// - Since: libadwaita 1.5
    public var body: String {
        get { String(cString: adw_alert_dialog_get_body(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>)) }
        set { adw_alert_dialog_set_body(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, newValue) }
    }

    /// Whether the body text is interpreted as Pango markup.
    /// - Since: libadwaita 1.5
    public var bodyUseMarkup: Bool {
        get { adw_alert_dialog_get_body_use_markup(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>) != 0 }
        set { adw_alert_dialog_set_body_use_markup(
            castedPointer() as UnsafeMutablePointer<AdwAlertDialog>,
            newValue ? 1 : 0
        ) }
    }

    /// The response ID used when the dialog is closed (e.g. by pressing Escape).
    /// - Since: libadwaita 1.5
    public var closeResponse: String {
        get {
            String(
                cString: adw_alert_dialog_get_close_response(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>)
            )
        }
        set { adw_alert_dialog_set_close_response(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, newValue) }
    }

    /// The response ID activated when the user presses Enter.
    /// - Since: libadwaita 1.5
    public var defaultResponse: String? {
        get {
            adw_alert_dialog_get_default_response(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>)
                .map { String(cString: $0) }
        }
        set { adw_alert_dialog_set_default_response(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, newValue) }
    }

    /// An optional custom widget displayed below the body text.
    /// - Since: libadwaita 1.5
    public var extraChild: Widget? {
        get {
            adw_alert_dialog_get_extra_child(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>)
                .map { Widget(borrowing: UnsafeMutableRawPointer($0)) }
        }
        set { adw_alert_dialog_set_extra_child(
            castedPointer() as UnsafeMutablePointer<AdwAlertDialog>,
            newValue?.widgetPointer
        ) }
    }

    /// The heading text displayed at the top of the dialog.
    /// - Since: libadwaita 1.5
    public var heading: String? {
        get {
            adw_alert_dialog_get_heading(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>)
                .map { String(cString: $0) }
        }
        set { adw_alert_dialog_set_heading(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, newValue) }
    }

    /// Whether the heading text is interpreted as Pango markup.
    /// - Since: libadwaita 1.5
    public var headingUseMarkup: Bool {
        get { adw_alert_dialog_get_heading_use_markup(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>) != 0 }
        set { adw_alert_dialog_set_heading_use_markup(
            castedPointer() as UnsafeMutablePointer<AdwAlertDialog>,
            newValue ? 1 : 0
        ) }
    }

    /// Whether to use a wider layout with the heading and body side by side.
    /// - Since: libadwaita 1.6
    public var preferWideLayout: Bool {
        get { adw_alert_dialog_get_prefer_wide_layout(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>) != 0 }
        set { adw_alert_dialog_set_prefer_wide_layout(
            castedPointer() as UnsafeMutablePointer<AdwAlertDialog>,
            newValue ? 1 : 0
        ) }
    }

    /// Adds a response button to the dialog.
    ///
    /// - Parameter id: A unique string identifier for the response (e.g. `"cancel"`).
    /// - Parameter label: The label displayed on the button.
    public func addResponse(_ id: String, label: String) {
        adw_alert_dialog_add_response(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, id, label)
    }

    /// Returns the visual appearance of a response button.
    ///
    /// - Parameter response: The response ID to query.
    /// - Returns: The appearance style (e.g. `ADW_RESPONSE_DESTRUCTIVE`).
    @discardableResult
    public func getResponseAppearance(_ response: String) -> AdwResponseAppearance {
        adw_alert_dialog_get_response_appearance(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, response)
    }

    /// Returns whether a response button is enabled.
    ///
    /// - Parameter response: The response ID to query.
    /// - Returns: `true` if the response button is enabled.
    public func getResponseEnabled(_ response: String) -> Bool {
        adw_alert_dialog_get_response_enabled(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, response) != 0
    }

    /// Returns the label of a response button.
    ///
    /// - Parameter response: The response ID to query.
    /// - Returns: The label text displayed on the button.
    @discardableResult
    public func getResponseLabel(_ response: String) -> String {
        String(cString: adw_alert_dialog_get_response_label(
            castedPointer() as UnsafeMutablePointer<AdwAlertDialog>,
            response
        ))
    }

    /// Checks whether a response with the given ID exists.
    ///
    /// - Parameter response: The response ID to check.
    /// - Returns: `true` if a response with this ID has been added.
    public func hasResponse(_ response: String) -> Bool {
        adw_alert_dialog_has_response(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, response) != 0
    }

    /// Removes a response button from the dialog.
    ///
    /// - Parameter id: The response ID to remove.
    public func removeResponse(_ id: String) {
        adw_alert_dialog_remove_response(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, id)
    }

    /// Sets the visual appearance of a response button.
    ///
    /// Use `ADW_RESPONSE_DESTRUCTIVE` for dangerous actions or
    /// `ADW_RESPONSE_SUGGESTED` for the recommended action.
    ///
    /// - Parameter response: The response ID to style.
    /// - Parameter appearance: The appearance to apply.
    public func setResponseAppearance(_ response: String, appearance: AdwResponseAppearance) {
        adw_alert_dialog_set_response_appearance(
            castedPointer() as UnsafeMutablePointer<AdwAlertDialog>,
            response,
            appearance
        )
    }

    /// Enables or disables a response button.
    ///
    /// - Parameter response: The response ID to modify.
    /// - Parameter enabled: `true` to enable the button, `false` to disable it.
    public func setResponseEnabled(_ response: String, enabled: Bool) {
        adw_alert_dialog_set_response_enabled(
            castedPointer() as UnsafeMutablePointer<AdwAlertDialog>,
            response,
            enabled ? 1 : 0
        )
    }

    /// Changes the label of a response button.
    ///
    /// - Parameter response: The response ID to modify.
    /// - Parameter label: The new label text.
    public func setResponseLabel(_ response: String, label: String) {
        adw_alert_dialog_set_response_label(castedPointer() as UnsafeMutablePointer<AdwAlertDialog>, response, label)
    }

    /// Emitted when the user activates a response button.
    ///
    /// - Parameter handler: Called with the response ID string (e.g. `"cancel"`, `"delete"`).
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onResponse(_ handler: @escaping @MainActor (String) -> Void) -> SignalConnection {
        SignalHelper.connectString(self, signal: .response, handler: handler)
    }
}
