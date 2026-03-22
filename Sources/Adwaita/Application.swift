import CAdwaita
import GObjectSupport

/// An Adwaita application.
///
/// Wraps `AdwApplication`, which extends `GtkApplication` with Adwaita
/// style management and automatic initialization.
@MainActor
public final class Application: GObjectRef {
    /// Creates a new Adwaita application.
    ///
    /// - Parameters:
    ///   - id: The application identifier (e.g. `"com.example.MyApp"`).
    ///   - flags: Application flags. Defaults to `.flagsNone`.
    public init(id: String, flags: GApplicationFlags = G_APPLICATION_DEFAULT_FLAGS) {
        let ptr = adw_application_new(id, flags)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The underlying `AdwApplication` pointer.
    public var applicationPointer: UnsafeMutablePointer<AdwApplication> {
        castedPointer()
    }

    /// The underlying `GtkApplication` pointer.
    public var gtkApplicationPointer: UnsafeMutablePointer<GtkApplication> {
        castedPointer()
    }

    /// Runs the application. Blocks until the application exits.
    ///
    /// - Returns: The exit status.
    @discardableResult
    public func run() -> Int {
        let gApp: UnsafeMutablePointer<GApplication> = castedPointer()
        return Int(g_application_run(gApp, 0, nil))
    }

    /// Connects a handler to the `activate` signal.
    ///
    /// This is called when the application is launched (e.g. the user opens it).
    @discardableResult
    public func onActivate(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "activate", handler: handler)
    }

    // MARK: - Notifications

    /// Sends a desktop notification.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for the notification. Can be used to withdraw it later.
    ///   - title: The notification title.
    ///   - body: The notification body text.
    ///   - icon: An optional icon name (e.g. "dialog-information-symbolic").
    public func sendNotification(id: String, title: String, body: String? = nil, icon: String? = nil) {
        let gApp: UnsafeMutablePointer<GApplication> = castedPointer()
        guard let notification = g_notification_new(title) else { return }
        if let body {
            g_notification_set_body(notification, body)
        }
        if let icon, let gIcon = g_themed_icon_new(icon) {
            g_notification_set_icon(notification, gIcon)
            g_object_unref(gpointer(gIcon))
        }
        g_application_send_notification(gApp, id, notification)
        g_object_unref(gpointer(notification))
    }

    /// Withdraws a notification previously sent with `sendNotification`.
    public func withdrawNotification(id: String) {
        let gApp: UnsafeMutablePointer<GApplication> = castedPointer()
        g_application_withdraw_notification(gApp, id)
    }

    // MARK: - About Dialog Helper

    /// Shows an About dialog for this application.
    ///
    /// - Parameters:
    ///   - parent: The parent widget to present the dialog from.
    ///   - name: The application name.
    ///   - version: The application version string.
    ///   - icon: The application icon name.
    ///   - developer: The developer name.
    ///   - website: The application website URL.
    ///   - copyright: A copyright string.
    ///   - license: The license type.
    ///   - issueUrl: URL for reporting issues.
    ///   - comments: A description of the application.
    public func showAboutDialog(
        parent: Widget,
        name: String,
        version: String = "",
        icon: String = "",
        developer: String = "",
        website: String = "",
        copyright: String = "",
        license: GtkLicense = .mit,
        issueUrl: String = "",
        comments: String = ""
    ) {
        let dialog = AboutDialog()
        dialog.applicationName = name
        if !version.isEmpty { dialog.version = version }
        if !icon.isEmpty { dialog.applicationIcon = icon }
        if !developer.isEmpty { dialog.developerName = developer }
        if !website.isEmpty { dialog.website = website }
        if !copyright.isEmpty { dialog.copyright = copyright }
        dialog.licenseType = license
        if !issueUrl.isEmpty { dialog.issueUrl = issueUrl }
        if !comments.isEmpty { dialog.comments = comments }
        dialog.present(parent)
    }
}
