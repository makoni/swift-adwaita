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
/// - Returns: `false` when no catalogue for `domain` is reachable, meaning
///   every lookup will return its msgid. Worth acting on rather than
///   discarding: the usual cause is a resource-bundling rule that flattened
///   `<lang>/LC_MESSAGES/` away, which otherwise ships a silently English-only
///   app that looked fine in development.
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
@discardableResult
public func configureLocalization(
    domain: String,
    localeDirectory: String? = nil,
    codeset: String = "UTF-8"
) -> Bool {
    _ = cadw_activate_locale_from_environment()
    LocalizationState.captureSessionLanguage()
    // Before anything can look a string up, and whether or not a language is
    // ever pinned. GLib decides once per process whether the program is
    // translated at all, and decides "no" when the first `g_dgettext` runs
    // under a locale that neither equals `C` nor begins with `en_` while no
    // catalogue is loaded — `C.UTF-8` exactly. GTK makes that first lookup
    // itself while initializing, so a session on `C.UTF-8` that had not
    // pinned a language could never translate afterwards, no matter what the
    // user then picked. Escaping here covers the default configuration; on a
    // session that already has a real locale this changes nothing.
    _ = ensureMessagesLocaleIsNotC(
        candidates: defaultLocaleCandidates(for: LocalizationState.sessionLanguage ?? "en")
    )
    if let localeDirectory {
        bindTextDomain(domain, to: localeDirectory)
    }
    bindTextDomainCodeset(domain, to: codeset)
    setDefaultTextDomain(domain)
    setTextDomain(domain)
    return !catalogueLanguages(in: localeDirectory ?? systemLocaleDirectory, domain: domain).isEmpty
}

/// Languages with a compiled catalogue for `domain` under `directory`.
///
/// Looks for exactly what gettext resolves —
/// `<directory>/<lang>/LC_MESSAGES/<domain>.mo` — so it answers the question
/// that matters rather than "is there a directory here". Use it to build a
/// language picker from what the build actually installed, or to check a
/// packaging change before shipping it.
public func catalogueLanguages(in directory: String, domain: String) -> Set<String> {
    let fileManager = FileManager.default
    guard let entries = try? fileManager.contentsOfDirectory(
        at: URL(fileURLWithPath: directory, isDirectory: true),
        includingPropertiesForKeys: nil
    ) else {
        return []
    }

    return Set(
        entries.filter { entry in
            fileManager.fileExists(
                atPath: entry
                    .appendingPathComponent("LC_MESSAGES", isDirectory: true)
                    .appendingPathComponent("\(domain).mo", isDirectory: false)
                    .path
            )
        }.map(\.lastPathComponent)
    )
}

/// Where gettext looks when a domain has not been bound to a directory.
public let systemLocaleDirectory = "/usr/share/locale"

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
/// one installed first. Any generated locale *other than those* lifts the
/// block, and it does not have to belong to `language` — so pass
/// `localeCandidates` if the default guesses are wrong for your deployment.
/// `C.UTF-8` is not a usable candidate however widely it is generated: it is
/// the C locale as far as gettext is concerned, and such candidates are
/// skipped rather than tried.
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
        // The escape is deliberately left in place. Putting `LC_MESSAGES`
        // back to a session value of `C` would return the process to the
        // locale where GLib latches it as untranslated — so "follow the
        // system language" would break translation for the rest of the
        // session, including for the language the session itself asks for.
        // What `.system` means is decided from the values captured before
        // the escape, not from the environment as it now reads.
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

/// Moves `LC_MESSAGES` off the C locale, and makes the move stick.
///
/// Installing the locale with `setlocale` is not enough on its own, because
/// `gtk_init` calls `setlocale(LC_ALL, "")` while it starts up and that reads
/// the *environment* — so a locale this function only installed is reverted
/// to whatever `LANG` says, and in a container or the Flatpak sandbox that is
/// `C.UTF-8`. The chosen locale is therefore exported as well.
///
/// The consequence of not exporting it is worse than an untranslated moment,
/// and it is why this is done here rather than left to the caller: GLib
/// decides **once per process** whether the program is translated at all
/// (`_g_dgettext_should_translate`), and it decides "no" when the first
/// `g_dgettext` runs under a locale that neither equals `C` nor begins with
/// `en_` while no catalogue is loaded. `C.UTF-8` is exactly that gap. GTK
/// itself looks up its own strings during initialization, so the decision is
/// latched before an app gets to make its first lookup — and once latched,
/// every later `g_dgettext` returns its msgid however correct the locale,
/// the language and the binding have since become. Measured: with the locale
/// exported, an Arabic or Russian interface comes up translated under
/// `LANG=C.UTF-8`; without, it comes up English while its dates, which
/// Foundation formats, come up translated.
private func ensureMessagesLocaleIsNotC(candidates: [String]) -> Bool {
    if let current = cadw_current_messages_locale(),
       !isCLocaleName(String(cString: current)) {
        return true
    }
    // Skip candidates that are themselves C-locale names. `C.UTF-8` is
    // generated on nearly every system and looks like a safe fallback, but
    // gettext treats it exactly as bare `C`, so it can never satisfy this —
    // and trying it would still leave the process on a useless LC_MESSAGES
    // before the rejection.
    for candidate in candidates where !isCLocaleName(candidate) {
        if let applied = candidate.withCString({ cadw_set_messages_locale($0) }),
           !isCLocaleName(String(cString: applied)) {
            exportMessagesLocale(String(cString: applied))
            return true
        }
    }
    return false
}

/// Whether the process's `LC_MESSAGES` allows any translation at all.
///
/// `false` means the process sits on the `C` locale — `C.UTF-8` counts — where
/// gettext ignores `LANGUAGE` and every lookup returns its msgid. That happens
/// when no locale beyond `C` is generated on the machine, which a minimal
/// container image is, and it is worth saying out loud: the interface comes up
/// in English with no other sign of why.
public var messagesLocaleSupportsTranslation: Bool {
    guard let current = cadw_current_messages_locale() else { return false }
    return !isCLocaleName(String(cString: current))
}

/// Exports `locale` for `LC_MESSAGES` so `setlocale(LC_ALL, "")` keeps it.
///
/// `LC_ALL` is cleared when it names a C locale, because `setlocale(LC_ALL, "")`
/// gives `LC_ALL` precedence over the per-category variable — so exporting
/// `LC_MESSAGES` alone changes nothing on a session that sets
/// `LC_ALL=C.UTF-8`, which Debian and Python container images and plenty of
/// build shells do. Measured: without clearing it, `gtk_init` puts the
/// process back on `C.UTF-8` and GLib latches it untranslated.
///
/// The name written is the one `setlocale` reported rather than the candidate
/// asked for, so the environment and the process cannot disagree about an
/// aliased or non-canonical name.
private func exportMessagesLocale(_ locale: String) {
    setEnvironmentVariable("LC_MESSAGES", locale)
    if let all = ProcessInfo.processInfo.environment["LC_ALL"], isCLocaleName(all) {
        unsetEnvironmentVariable("LC_ALL")
    }
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

/// The locale currently selected for `LC_MESSAGES`, as the C library reports
/// it.
///
/// ``setLanguage(_:localeCandidates:)`` may change this — installing a real
/// locale is how it escapes the `C` locale — so a caller that needs the
/// process put back the way it found it, a test suite most of all, should read
/// this first and hand it to ``setMessagesLocale(_:)`` afterwards.
public func currentMessagesLocale() -> String? {
    cadw_current_messages_locale().map { String(cString: $0) }
}

/// Selects the locale used for `LC_MESSAGES`.
///
/// - Returns: `true` when the locale was installed. `false` means the system
///   has not generated it, and `LC_MESSAGES` is left as it was.
@discardableResult
public func setMessagesLocale(_ locale: String) -> Bool {
    locale.withCString { cadw_set_messages_locale($0) } != nil
}

/// Session-scoped localization state.
///
/// The session's own `LANGUAGE` has to be captured before anything overrides
/// it: restoring "follow the session" is otherwise impossible.
enum LocalizationState {
    fileprivate(set) nonisolated(unsafe) static var sessionLanguage: String?
    nonisolated(unsafe) static var selectedLanguage: String?
    private nonisolated(unsafe) static var didCapture = false

    /// The locale variables as the session set them, before any escape from
    /// the C locale rewrote them.
    ///
    /// Escaping exports `LC_MESSAGES`, which means the environment no longer
    /// answers "what did the session ask for" — and that question has two
    /// consumers that would otherwise read the app's own escape back as the
    /// user's intent: ``sessionLanguageIdentifier()``, which decides the
    /// reading direction for a system-language interface, and
    /// ``setLanguage(nil)``, which has to put the environment back.
    fileprivate(set) nonisolated(unsafe) static var sessionLocaleEnvironment: [String: String?] = [:]

    static func captureSessionLanguage() {
        guard !didCapture else { return }
        recaptureSessionLanguage()
    }

    static func recaptureSessionLanguage() {
        didCapture = true
        let environment = ProcessInfo.processInfo.environment
        sessionLanguage = environment["LANGUAGE"]
        sessionLocaleEnvironment = [
            "LC_ALL": environment["LC_ALL"],
            "LC_MESSAGES": environment["LC_MESSAGES"],
            "LANG": environment["LANG"]
        ]
        selectedLanguage = nil
    }

    /// What the session set for `name`, whatever the app has since exported.
    static func sessionValue(_ name: String) -> String? {
        guard didCapture else { return ProcessInfo.processInfo.environment[name] }
        return sessionLocaleEnvironment[name] ?? nil
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
