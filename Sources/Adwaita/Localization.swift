import CAdwaita

/// The app's gettext domain, set via ``setTextDomain(_:)``.
private nonisolated(unsafe) var _textDomain: String?

/// Looks up a translated string in the app's gettext domain.
///
/// Set the domain first with ``setTextDomain(_:)``, then
/// use this function (or ``String/localized``) to look up translations.
///
/// ```swift
/// setTextDomain("myapp", localeDir: "/usr/share/locale")
/// let greeting = localized("Hello")
/// ```
///
/// - Parameter msgid: The source string (message ID) to translate.
/// - Returns: The translated string, or `msgid` if no translation is found.
public func localized(_ msgid: String) -> String {
    guard let result = g_dgettext(_textDomain, msgid) else { return msgid }
    return String(cString: result)
}

/// Looks up a translated string with context disambiguation.
///
/// Use when the same English string has different meanings in different
/// contexts (e.g., "Open" as a verb vs. adjective).
///
/// ```swift
/// let action = localizedWithContext("verb", "Open")
/// let state = localizedWithContext("adjective", "Open")
/// ```
public func localizedWithContext(_ context: String, _ msgid: String) -> String {
    let combined = "\(context)\u{04}\(msgid)"
    guard let result = g_dgettext(_textDomain, combined) else { return msgid }
    let translated = String(cString: result)
    return translated == combined ? msgid : translated
}

/// Looks up a pluralized translated string.
///
/// ```swift
/// let msg = nlocalized("%d file", "%d files", count: fileCount)
/// ```
public func nlocalized(_ msgid: String, _ msgidPlural: String, count: UInt) -> String {
    guard let result = g_dngettext(_textDomain, msgid, msgidPlural, count) else { return msgid }
    return String(cString: result)
}

/// Sets the gettext text domain for the application.
///
/// Call this early in your app (e.g., before `app.run()`) to enable
/// translations via ``localized(_:)`` and ``String/localized``.
///
/// - Parameter domain: The gettext domain (typically your app ID, e.g. "com.example.MyApp").
public func setTextDomain(_ domain: String) {
    _textDomain = domain
}

public extension String {
    /// Returns the translated version of this string via gettext.
    ///
    /// ```swift
    /// let label = Label("Hello".localized)
    /// ```
    var localized: String {
        guard let result = g_dgettext(_textDomain, self) else { return self }
        return String(cString: result)
    }
}
