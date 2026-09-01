// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import Foundation

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

/// Looks up a pluralized translated string with context disambiguation.
///
/// The plural counterpart of ``localizedWithContext(_:_:)``, for the case
/// where the same counted phrase means different things in different places.
///
/// ```swift
/// // "%d match" as in search results, not as in a sports fixture.
/// let label = nlocalizedWithContext("search", "%d match", "%d matches", count: hits)
/// ```
public func nlocalizedWithContext(
    _ context: String,
    _ msgid: String,
    _ msgidPlural: String,
    count: UInt
) -> String {
    let combinedSingular = "\(context)\u{04}\(msgid)"
    let combinedPlural = "\(context)\u{04}\(msgidPlural)"
    return combinedSingular.withCString { singularC in
        combinedPlural.withCString { pluralC in
            guard let result = g_dngettext(_textDomain, singularC, pluralC, count) else {
                return count == 1 ? msgid : msgidPlural
            }
            // No translation: gettext hands back one of the pointers we passed
            // in, which still carry the context prefix, so fall back to the
            // bare msgid rather than showing the reader "search\u{04}%d match".
            if result == singularC { return msgid }
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

// MARK: - Setup

/// Prepares gettext so ``localized(_:)`` and friends can find translations.
///
/// One call replaces the four steps every app otherwise repeats — and, because
/// `<libintl.h>` is not in the Glibc/Darwin module, otherwise repeats through a
/// C shim of its own:
///
/// 1. activates the process locale from the environment (`LC_ALL` / `LANG`),
/// 2. binds `domain` to `localeDirectory`, where gettext expects
///    `<localeDirectory>/<lang>/LC_MESSAGES/<domain>.mo`,
/// 3. pins the catalogue encoding to `codeset`,
/// 4. makes `domain` the process default and the domain this module looks up.
///
/// ```swift
/// configureLocalization(
///     domain: "com.example.MyApp",
///     localeDirectory: "/app/share/locale",
/// )
/// ```
///
/// Call it before any lookup, and before `Application.run()` — GTK decides the
/// default text direction from its own catalogue during initialization, so the
/// language has to be settled first for an RTL interface to come up mirrored.
///
/// - Parameters:
///   - domain: The gettext domain, conventionally the app ID.
///   - localeDirectory: Directory holding `<lang>/LC_MESSAGES/<domain>.mo`.
///     Pass `nil` to leave the domain bound to the system default.
///   - codeset: Catalogue encoding. Leave at `"UTF-8"` unless you know better.
public func configureLocalization(
    domain: String,
    localeDirectory: String? = nil,
    codeset: String = "UTF-8"
) {
    _ = cadw_activate_locale_from_environment()
    LocalizationState.captureSessionLanguage()
    if let localeDirectory {
        bindTextDomain(domain, to: localeDirectory)
    }
    bindTextDomainCodeset(domain, to: codeset)
    setDefaultTextDomain(domain)
    setTextDomain(domain)
}

/// Binds a gettext domain to the directory holding its catalogues.
///
/// gettext resolves `<directory>/<lang>/LC_MESSAGES/<domain>.mo`; a `.mo`
/// sitting directly in `directory` is never found.
public func bindTextDomain(_ domain: String, to directory: String) {
    domain.withCString { domainC in
        directory.withCString { directoryC in
            cadw_bindtextdomain(domainC, directoryC)
        }
    }
}

/// Pins the encoding gettext reports translations in.
public func bindTextDomainCodeset(_ domain: String, to codeset: String) {
    domain.withCString { domainC in
        codeset.withCString { codesetC in
            cadw_bind_textdomain_codeset(domainC, codesetC)
        }
    }
}

/// Makes `domain` the process-wide default for bare `gettext` lookups.
///
/// Distinct from ``setTextDomain(_:)``, which only tells *this module* which
/// domain to pass to `g_dgettext`. Both are set by ``configureLocalization``.
public func setDefaultTextDomain(_ domain: String) {
    domain.withCString { domainC in
        cadw_textdomain(domainC)
    }
}

// MARK: - Changing language at runtime

/// Whether this build can change the interface language without a restart.
///
/// `false` only where libintl does not export the catalogue-cache counter, in
/// which case ``setLanguage(_:)`` has no effect until the next launch.
public var canChangeLanguageAtRuntime: Bool {
    cadw_can_change_language_at_runtime() != 0
}

/// The language this module last selected, or `nil` while following the
/// session.
public var currentLanguage: String? {
    LocalizationState.selectedLanguage
}

/// Selects the language gettext looks translations up in, taking effect
/// immediately.
///
/// `LANGUAGE` is the only lever that picks a catalogue independently of the
/// locale, and gettext reads it once per catalogue load — hence the cache
/// invalidation. Widgets already on screen keep the strings they were built
/// with: re-read them, or see ``applyTextDirection(forLanguage:)`` for the
/// layout half of the same change.
///
/// The catch is that gettext ignores `LANGUAGE` completely while `LC_MESSAGES`
/// is `C`, `POSIX` or `C.UTF-8`, so a session started without a locale needs
/// one installed first. Any generated locale lifts the block — it does not
/// have to belong to `language` — so pass `localeCandidates` if the default
/// guesses are wrong for your deployment.
///
/// - Parameters:
///   - language: A language code such as `"ru"` or `"pt_BR"`, or `nil` to
///     follow the session's own `LANGUAGE` again.
///   - localeCandidates: Locales to try when the session runs under `C`.
/// - Returns: `true` when subsequent lookups will use `language`. `false`
///   means the session locale is `C` and none of `localeCandidates` is
///   generated on this machine — where nothing is translated at all, with or
///   without a language selection.
@discardableResult
public func setLanguage(
    _ language: String?,
    localeCandidates: [String]? = nil
) -> Bool {
    guard let language, !language.isEmpty else {
        LocalizationState.selectedLanguage = nil
        if let sessionLanguage = LocalizationState.sessionLanguage {
            setEnvironmentVariable("LANGUAGE", sessionLanguage)
        } else {
            unsetEnvironmentVariable("LANGUAGE")
        }
        cadw_invalidate_translation_cache()
        return true
    }

    let candidates = localeCandidates ?? defaultLocaleCandidates(for: language)
    let escapedCLocale = ensureMessagesLocaleIsNotC(candidates: candidates)
    setEnvironmentVariable("LANGUAGE", language)
    LocalizationState.selectedLanguage = language
    cadw_invalidate_translation_cache()
    return escapedCLocale
}

/// Locales worth trying to escape the `C` locale for `language`: the
/// language's own conventional locale first, then widely generated fallbacks.
private func defaultLocaleCandidates(for language: String) -> [String] {
    let base = language.split(separator: "_").first.map(String.init) ?? language
    var candidates = ["\(language).UTF-8"]
    if base != language {
        candidates.append("\(base).UTF-8")
    }
    candidates.append(contentsOf: ["en_US.UTF-8", "en_GB.UTF-8"])
    return candidates
}

private func ensureMessagesLocaleIsNotC(candidates: [String]) -> Bool {
    if let current = cadw_current_messages_locale(),
       !isCLocaleName(String(cString: current)) {
        return true
    }
    for candidate in candidates {
        if let applied = candidate.withCString({ cadw_set_messages_locale($0) }),
           !isCLocaleName(String(cString: applied)) {
            return true
        }
    }
    return false
}

/// `C.UTF-8` suppresses `LANGUAGE` exactly as bare `C` does, so the encoding
/// suffix is stripped before the comparison.
private func isCLocaleName(_ locale: String) -> Bool {
    let name = locale.split(separator: ".").first.map(String.init) ?? locale
    return name == "C" || name == "POSIX"
}

/// The `LANGUAGE` the session was started with, as captured by
/// ``configureLocalization(domain:localeDirectory:codeset:)``.
///
/// `nil` when the session asked for no particular language. This is what
/// ``setLanguage(_:)`` puts back when handed `nil`.
public var sessionLanguage: String? {
    LocalizationState.sessionLanguage
}

/// Re-reads `LANGUAGE` from the environment as the session's own value.
///
/// The capture during ``configureLocalization(domain:localeDirectory:codeset:)``
/// is one-shot, so that a later selection cannot be mistaken for what the
/// session asked for. Call this when the app has changed `LANGUAGE` itself and
/// wants the new value treated as the baseline that "follow the session"
/// returns to.
public func recaptureSessionLanguage() {
    LocalizationState.recaptureSessionLanguage()
}

/// Session-scoped localization state.
///
/// The session's own `LANGUAGE` has to be captured before anything overrides
/// it: restoring "follow the session" is otherwise impossible.
enum LocalizationState {
    fileprivate(set) nonisolated(unsafe) static var sessionLanguage: String?
    nonisolated(unsafe) static var selectedLanguage: String?
    private nonisolated(unsafe) static var didCapture = false

    static func captureSessionLanguage() {
        guard !didCapture else { return }
        recaptureSessionLanguage()
    }

    static func recaptureSessionLanguage() {
        didCapture = true
        sessionLanguage = ProcessInfo.processInfo.environment["LANGUAGE"]
        selectedLanguage = nil
    }
}

private func setEnvironmentVariable(_ name: String, _ value: String) {
    name.withCString { nameC in
        value.withCString { valueC in
            _ = setenv(nameC, valueC, 1)
        }
    }
}

private func unsetEnvironmentVariable(_ name: String) {
    name.withCString { nameC in
        _ = unsetenv(nameC)
    }
}
