import CAdwaita

/// The app's gettext domain, set via ``setTextDomain(_:)``.
private nonisolated(unsafe) var _textDomain: String?

/// Looks up a translated string in the app's gettext domain.
///
/// Set the domain first with ``setTextDomain(_:)``, then
/// use this function (or `String.localized`) to look up translations.
///
/// ```swift
/// setTextDomain("myapp", localeDir: "/usr/share/locale")
/// let greeting = localized("Hello")
/// ```
///
/// - Parameter msgid: The source string (message ID) to translate.
/// - Returns: The translated string, or `msgid` if no translation is found.
public func localized(_ msgid: String) -> String {
    msgid.withCString { msgidC in
        guard let result = g_dgettext(_textDomain, msgidC) else { return msgid }
        // gettext returns the input pointer untouched when no translation is
        // available. Reading from msgidC after withCString returns is UB on
        // Apple platforms — the bridged C-string buffer may already be freed.
        if result == msgidC { return msgid }
        return String(cString: result)
    }
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
    return combined.withCString { combinedC in
        guard let result = g_dgettext(_textDomain, combinedC) else { return msgid }
        if result == combinedC { return msgid }
        let translated = String(cString: result)
        return translated == combined ? msgid : translated
    }
}

/// Looks up a pluralized translated string.
///
/// ```swift
/// let msg = nlocalized("%d file", "%d files", count: fileCount)
/// ```
public func nlocalized(_ msgid: String, _ msgidPlural: String, count: UInt) -> String {
    msgid.withCString { msgidC in
        msgidPlural.withCString { pluralC in
            guard let result = g_dngettext(_textDomain, msgidC, pluralC, count) else { return msgid }
            // gettext returns msgid (count==1, no translation) or msgidPlural
            // (count!=1, no translation) by pointer identity — those C-strings
            // belong to the withCString scope, so we have to materialise our
            // Swift values rather than read the dangling pointer.
            if result == msgidC { return msgid }
            if result == pluralC { return msgidPlural }
            return String(cString: result)
        }
    }
}

/// Sets the gettext text domain for the application.
///
/// Call this early in your app (e.g., before `app.run()`) to enable
/// translations via `localized(_:)` and `String.localized`.
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
        let original = self
        return withCString { msgidC in
            guard let result = g_dgettext(_textDomain, msgidC) else { return original }
            if result == msgidC { return original }
            return String(cString: result)
        }
    }
}
