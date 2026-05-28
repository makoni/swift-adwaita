// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A dialog that displays information about the application.
///
/// Wraps `AdwAboutDialog`. Shows the application name, version, icon,
/// credits, license, and links. Commonly presented from a menu item
/// or button in the header bar.
///
/// ```swift
/// let about = AboutDialog(
///     appName: "My App",
///     version: "1.0",
///     developer: "Jane Doe",
///     appIcon: "com.example.MyApp",
///     website: "https://example.com",
///     licenseType: GTK_LICENSE_MIT_X11
/// )
/// about.comments = "A sample application built with libadwaita."
/// about.issueUrl = "https://github.com/example/myapp/issues"
///
/// // Add extra links and legal info
/// about.addLink("Donate", url: "https://example.com/donate")
/// about.addLegalSection("Dependency", copyright: "2024 Dep Author",
///                       licenseType: GTK_LICENSE_MIT_X11, license: nil)
///
/// about.present(window)
/// ```
///
/// - Since: libadwaita 1.5
@MainActor
public final class AboutDialog: Dialog {
    override public class var gtkType: GType {
        adw_about_dialog_get_type()
    }

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `AboutDialog`.
    override public init() {
        let ptr = adw_about_dialog_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates an `AboutDialog` with common fields.
    public convenience init(
        appName: String,
        version: String,
        developer: String,
        appIcon: String? = nil,
        website: String? = nil,
        issueUrl: String? = nil,
        copyright: String? = nil,
        licenseType: GtkLicense? = nil
    ) {
        self.init()
        applicationName = appName
        self.version = version
        developerName = developer
        if let appIcon { applicationIcon = appIcon }
        if let website { self.website = website }
        if let issueUrl { self.issueUrl = issueUrl }
        if let copyright { self.copyright = copyright }
        if let licenseType { self.licenseType = licenseType }
    }

    /// Creates a new `AboutDialog`.
    public static func newFromAppdata(resourcePath: String, releaseNotesVersion: String?) -> AboutDialog {
        let ptr = adw_about_dialog_new_from_appdata(resourcePath, releaseNotesVersion)!
        return AboutDialog(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The icon name for the application.
    /// - Since: libadwaita 1.5
    public var applicationIcon: String {
        get { String(cString: adw_about_dialog_get_application_icon(opaquePointer)) }
        set { adw_about_dialog_set_application_icon(opaquePointer, newValue) }
    }

    /// The display name of the application.
    /// - Since: libadwaita 1.5
    public var applicationName: String {
        get { String(cString: adw_about_dialog_get_application_name(opaquePointer)) }
        set { adw_about_dialog_set_application_name(opaquePointer, newValue) }
    }

    /// A short description of the application.
    /// - Since: libadwaita 1.5
    public var comments: String {
        get { String(cString: adw_about_dialog_get_comments(opaquePointer)) }
        set { adw_about_dialog_set_comments(opaquePointer, newValue) }
    }

    /// The copyright notice (e.g. "2024 Jane Doe").
    /// - Since: libadwaita 1.5
    public var copyright: String {
        get { String(cString: adw_about_dialog_get_copyright(opaquePointer)) }
        set { adw_about_dialog_set_copyright(opaquePointer, newValue) }
    }

    /// Debugging information shown in the "Troubleshooting" section.
    /// - Since: libadwaita 1.5
    public var debugInfo: String {
        get { String(cString: adw_about_dialog_get_debug_info(opaquePointer)) }
        set { adw_about_dialog_set_debug_info(opaquePointer, newValue) }
    }

    /// The suggested filename for saving debug info.
    /// - Since: libadwaita 1.5
    public var debugInfoFilename: String {
        get { String(cString: adw_about_dialog_get_debug_info_filename(opaquePointer)) }
        set { adw_about_dialog_set_debug_info_filename(opaquePointer, newValue) }
    }

    /// The name of the application developer.
    /// - Since: libadwaita 1.5
    public var developerName: String {
        get { String(cString: adw_about_dialog_get_developer_name(opaquePointer)) }
        set { adw_about_dialog_set_developer_name(opaquePointer, newValue) }
    }

    /// The URL for reporting issues or bugs.
    /// - Since: libadwaita 1.5
    public var issueUrl: String {
        get { String(cString: adw_about_dialog_get_issue_url(opaquePointer)) }
        set { adw_about_dialog_set_issue_url(opaquePointer, newValue) }
    }

    /// The full license text, or empty if using ``licenseType`` instead.
    /// - Since: libadwaita 1.5
    public var license: String {
        get { String(cString: adw_about_dialog_get_license(opaquePointer)) }
        set { adw_about_dialog_set_license(opaquePointer, newValue) }
    }

    /// The license type from a predefined set (e.g. `GTK_LICENSE_MIT_X11`).
    /// - Since: libadwaita 1.5
    public var licenseType: GtkLicense {
        get { adw_about_dialog_get_license_type(opaquePointer) }
        set { adw_about_dialog_set_license_type(opaquePointer, newValue) }
    }

    /// Release notes in AppStream XML format.
    /// - Since: libadwaita 1.5
    public var releaseNotes: String {
        get { String(cString: adw_about_dialog_get_release_notes(opaquePointer)) }
        set { adw_about_dialog_set_release_notes(opaquePointer, newValue) }
    }

    /// The version that the release notes correspond to.
    /// - Since: libadwaita 1.5
    public var releaseNotesVersion: String {
        get { String(cString: adw_about_dialog_get_release_notes_version(opaquePointer)) }
        set { adw_about_dialog_set_release_notes_version(opaquePointer, newValue) }
    }

    /// The URL for getting support or help.
    /// - Since: libadwaita 1.5
    public var supportUrl: String {
        get { String(cString: adw_about_dialog_get_support_url(opaquePointer)) }
        set { adw_about_dialog_set_support_url(opaquePointer, newValue) }
    }

    /// Credits for translators, shown in the credits section.
    /// - Since: libadwaita 1.5
    public var translatorCredits: String {
        get { String(cString: adw_about_dialog_get_translator_credits(opaquePointer)) }
        set { adw_about_dialog_set_translator_credits(opaquePointer, newValue) }
    }

    /// The application version string.
    /// - Since: libadwaita 1.5
    public var version: String {
        get { String(cString: adw_about_dialog_get_version(opaquePointer)) }
        set { adw_about_dialog_set_version(opaquePointer, newValue) }
    }

    /// The application's website URL.
    /// - Since: libadwaita 1.5
    public var website: String {
        get { String(cString: adw_about_dialog_get_website(opaquePointer)) }
        set { adw_about_dialog_set_website(opaquePointer, newValue) }
    }

    /// Adds a legal section to the Credits page.
    ///
    /// - Parameter title: The section title.
    /// - Parameter copyright: The copyright holder, or `nil`.
    /// - Parameter licenseType: A predefined license type.
    /// - Parameter license: Custom license text, or `nil` to use the type's default.
    public func addLegalSection(_ title: String, copyright: String?, licenseType: GtkLicense, license: String?) {
        adw_about_dialog_add_legal_section(opaquePointer, title, copyright, licenseType, license)
    }

    /// Adds a custom link to the Details page.
    ///
    /// - Parameter title: The link label.
    /// - Parameter url: The URL to open when clicked.
    public func addLink(_ title: String, url: String) {
        adw_about_dialog_add_link(opaquePointer, title, url)
    }

    /// Adds another application to the "Other Applications" section.
    ///
    /// - Parameter appid: The application ID of the other app.
    /// - Parameter name: The display name of the other app.
    /// - Parameter summary: A one-line description of the other app.
    public func addOtherApp(_ appid: String, name: String, summary: String) {
        adw_about_dialog_add_other_app(opaquePointer, appid, name, summary)
    }

    /// Emitted when a URL link in the dialog is activated.
    ///
    /// - Parameter handler: Called with the URL string that was clicked.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onActivateLink(_ handler: @escaping @MainActor (String) -> Void) -> SignalConnection {
        SignalHelper.connectString(self, signal: .activateLink, handler: handler)
    }
}
