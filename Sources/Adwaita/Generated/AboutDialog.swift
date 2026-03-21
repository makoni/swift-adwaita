// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A dialog showing information about the application.
/// - Since: libadwaita 1.5
@MainActor
public final class AboutDialog: Dialog {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `AboutDialog`.
    override public init() {
        let ptr = adw_about_dialog_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a new `AboutDialog`.
    public static func newFromAppdata(resourcePath: String, releaseNotesVersion: String?) -> AboutDialog {
        let ptr = adw_about_dialog_new_from_appdata(resourcePath, releaseNotesVersion)!
        return AboutDialog(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `application-icon` property.
    /// - Since: libadwaita 1.5
    public var applicationIcon: String {
        get { String(cString: adw_about_dialog_get_application_icon(opaquePointer)) }
        set { adw_about_dialog_set_application_icon(opaquePointer, newValue) }
    }

    /// The `application-name` property.
    /// - Since: libadwaita 1.5
    public var applicationName: String {
        get { String(cString: adw_about_dialog_get_application_name(opaquePointer)) }
        set { adw_about_dialog_set_application_name(opaquePointer, newValue) }
    }

    /// The `comments` property.
    /// - Since: libadwaita 1.5
    public var comments: String {
        get { String(cString: adw_about_dialog_get_comments(opaquePointer)) }
        set { adw_about_dialog_set_comments(opaquePointer, newValue) }
    }

    /// The `copyright` property.
    /// - Since: libadwaita 1.5
    public var copyright: String {
        get { String(cString: adw_about_dialog_get_copyright(opaquePointer)) }
        set { adw_about_dialog_set_copyright(opaquePointer, newValue) }
    }

    /// The `debug-info` property.
    /// - Since: libadwaita 1.5
    public var debugInfo: String {
        get { String(cString: adw_about_dialog_get_debug_info(opaquePointer)) }
        set { adw_about_dialog_set_debug_info(opaquePointer, newValue) }
    }

    /// The `debug-info-filename` property.
    /// - Since: libadwaita 1.5
    public var debugInfoFilename: String {
        get { String(cString: adw_about_dialog_get_debug_info_filename(opaquePointer)) }
        set { adw_about_dialog_set_debug_info_filename(opaquePointer, newValue) }
    }

    /// The `developer-name` property.
    /// - Since: libadwaita 1.5
    public var developerName: String {
        get { String(cString: adw_about_dialog_get_developer_name(opaquePointer)) }
        set { adw_about_dialog_set_developer_name(opaquePointer, newValue) }
    }

    /// The `issue-url` property.
    /// - Since: libadwaita 1.5
    public var issueUrl: String {
        get { String(cString: adw_about_dialog_get_issue_url(opaquePointer)) }
        set { adw_about_dialog_set_issue_url(opaquePointer, newValue) }
    }

    /// The `license` property.
    /// - Since: libadwaita 1.5
    public var license: String {
        get { String(cString: adw_about_dialog_get_license(opaquePointer)) }
        set { adw_about_dialog_set_license(opaquePointer, newValue) }
    }

    /// The `license-type` property.
    /// - Since: libadwaita 1.5
    public var licenseType: GtkLicense {
        get { adw_about_dialog_get_license_type(opaquePointer) }
        set { adw_about_dialog_set_license_type(opaquePointer, newValue) }
    }

    /// The `release-notes` property.
    /// - Since: libadwaita 1.5
    public var releaseNotes: String {
        get { String(cString: adw_about_dialog_get_release_notes(opaquePointer)) }
        set { adw_about_dialog_set_release_notes(opaquePointer, newValue) }
    }

    /// The `release-notes-version` property.
    /// - Since: libadwaita 1.5
    public var releaseNotesVersion: String {
        get { String(cString: adw_about_dialog_get_release_notes_version(opaquePointer)) }
        set { adw_about_dialog_set_release_notes_version(opaquePointer, newValue) }
    }

    /// The `support-url` property.
    /// - Since: libadwaita 1.5
    public var supportUrl: String {
        get { String(cString: adw_about_dialog_get_support_url(opaquePointer)) }
        set { adw_about_dialog_set_support_url(opaquePointer, newValue) }
    }

    /// The `translator-credits` property.
    /// - Since: libadwaita 1.5
    public var translatorCredits: String {
        get { String(cString: adw_about_dialog_get_translator_credits(opaquePointer)) }
        set { adw_about_dialog_set_translator_credits(opaquePointer, newValue) }
    }

    /// The `version` property.
    /// - Since: libadwaita 1.5
    public var version: String {
        get { String(cString: adw_about_dialog_get_version(opaquePointer)) }
        set { adw_about_dialog_set_version(opaquePointer, newValue) }
    }

    /// The `website` property.
    /// - Since: libadwaita 1.5
    public var website: String {
        get { String(cString: adw_about_dialog_get_website(opaquePointer)) }
        set { adw_about_dialog_set_website(opaquePointer, newValue) }
    }

    /// Calls `adw_about_dialog_add_legal_section`.
    public func addLegalSection(_ title: String, copyright: String?, licenseType: GtkLicense, license: String?) {
        adw_about_dialog_add_legal_section(opaquePointer, title, copyright, licenseType, license)
    }

    /// Calls `adw_about_dialog_add_link`.
    public func addLink(_ title: String, url: String) {
        adw_about_dialog_add_link(opaquePointer, title, url)
    }

    /// Calls `adw_about_dialog_add_other_app`.
    public func addOtherApp(_ appid: String, name: String, summary: String) {
        adw_about_dialog_add_other_app(opaquePointer, appid, name, summary)
    }

    /// Connects to the `activate-link` signal.
    @discardableResult
    public func onActivateLink(_ handler: @escaping @MainActor (String) -> Void) -> SignalConnection {
        SignalHelper.connectString(self, signal: "activate-link", handler: handler)
    }
}
