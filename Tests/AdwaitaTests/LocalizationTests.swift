// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Testing
@testable import Adwaita
import CAdwaita
import Foundation

/// Localization setup, runtime language changes and reading direction.
///
/// `LANGUAGE`, the gettext catalogue cache and the default text direction are
/// all process-global, so this suite is serialized and every test puts back
/// what it changed.
@Suite(.serialized)
struct LocalizationTests {

    // MARK: - Lookup fallbacks

    /// Context-qualified lookups have to hide the context from the reader when
    /// no translation exists: gettext hands back the string it was given,
    /// which still carries the `\u{04}` separator and the context prefix.
    @Test func contextQualifiedLookupsFallBackToTheBareMsgid() {
        #expect(localizedWithContext("verb", "Open") == "Open")
        #expect(nlocalizedWithContext("search", "%d match", "%d matches", count: 1) == "%d match")
        #expect(nlocalizedWithContext("search", "%d match", "%d matches", count: 5) == "%d matches")
    }

    // MARK: - Reading direction

    @Test func rightToLeftLanguagesAreRecognisedByTheirSubtag() {
        for language in ["ar", "ar_EG", "ar-EG.UTF-8", "he", "fa", "ur", "ps", "sd", "dv", "yi", "ug", "ckb"] {
            #expect(isRightToLeft(language: language), "\(language) is written right-to-left")
        }
        for language in ["en", "en_US.UTF-8", "ru", "de", "ja", "zh_CN", "tr", "hi", "uz"] {
            #expect(!isRightToLeft(language: language), "\(language) is written left-to-right")
        }
    }

    /// A four-letter second subtag names a script, not a region, and the
    /// script is what decides direction: Uzbek in Arabic script is RTL while
    /// plain Uzbek is not.
    @Test func scriptSubtagsOutrankTheBaseLanguage() {
        #expect(isRightToLeft(language: "uz_Arab"))
        #expect(!isRightToLeft(language: "uz_UZ"))
        #expect(isRightToLeft(language: "ff_Adlm"))
    }

    @Test func unknownLanguagesDefaultToLeftToRight() {
        #expect(!isRightToLeft(language: "xx"))
        #expect(!isRightToLeft(language: ""))
    }

    // Assigning ``defaultTextDirection`` is deliberately not exercised here,
    // and the omission is the point rather than an oversight.
    //
    // GTK implements it by walking its list of live toplevels and ref/unref-ing
    // each one. In a shared test process that list accumulates windows from
    // every suite that ran before, and any one of them finalized while still
    // registered turns the walk into a read of freed memory — a SIGSEGV that
    // kills the whole run, so every later suite reports nothing. A test whose
    // blast radius is the entire suite, and whose trigger is some unrelated
    // test's hygiene, buys less than it costs. Detecting the corruption first
    // does not rescue it either: the entries are freed memory, so no type check
    // on them is sound.
    //
    // What is left untested is GTK's behaviour, not this module's. The mapping
    // from language to direction is covered above, the per-widget overrides
    // below. That assigning the default re-lays-out widgets already realized —
    // the property live RTL switching depends on — was measured directly
    // against GTK instead: in a 400px box a button moved from x=0 to x=329 and
    // a label with `xalign = 0` right-aligned itself, with no window rebuilt.

    /// An explicit direction is what keeps a subtree — a code view, a path —
    /// left-to-right inside a mirrored window.
    @Test @MainActor func anExplicitWidgetDirectionOverridesTheDefault() {
        ensureAdwInit()
        // Per-widget direction only touches the widget, so unlike the process
        // default it is safe to set in a shared test process.
        let label = Label("/usr/share/locale")
        // Reading resolves an inherited direction, so a fresh widget already
        // reports the process default rather than `none`.
        #expect(label.textDirection == defaultTextDirection, "a fresh widget inherits")

        label.forceLeftToRight()
        #expect(label.textDirection == GTK_TEXT_DIR_LTR)
        #expect(label.isRightToLeft == false)

        label.forceRightToLeft()
        #expect(label.textDirection == GTK_TEXT_DIR_RTL)
        #expect(label.isRightToLeft, "an explicit direction wins over the process default")

        label.followDefaultTextDirection()
        #expect(
            label.textDirection == defaultTextDirection,
            "back to inheriting whatever the process default is"
        )
    }

    // MARK: - Runtime language changes

    @Test func theRuntimeLanguageSwitchReportsWhetherItIsSupported() {
        // Both answers are legitimate — the point is that the capability is
        // knowable, so an app can say "restart required" instead of silently
        // doing nothing.
        let supported = canChangeLanguageAtRuntime
        #expect(supported == true || supported == false)
    }

    @Test func selectingALanguageRecordsItAndFollowingTheSessionClearsIt() throws {
        try withRestoredLocaleEnvironment {
            let previous = ProcessInfo.processInfo.environment["LANGUAGE"]
            defer {
                restoreSessionLanguage(previous)
            }
            applySessionLanguage(previous)

            setLanguage("ru")
            #expect(currentLanguage == "ru")
            #expect(ProcessInfo.processInfo.environment["LANGUAGE"] == "ru")

            setLanguage(nil)
            #expect(currentLanguage == nil)
            #expect(ProcessInfo.processInfo.environment["LANGUAGE"] == previous)
        }
    }

    /// The whole point of capturing the session language: "follow the session"
    /// has to restore what the user's environment asked for, which is
    /// unrecoverable once a selection has overwritten it.
    @Test func followingTheSessionRestoresTheCapturedLanguage() throws {
        try withRestoredLocaleEnvironment {
            let previous = ProcessInfo.processInfo.environment["LANGUAGE"]
            defer {
                restoreSessionLanguage(previous)
            }

            applySessionLanguage("de")
            setLanguage("ru")
            #expect(ProcessInfo.processInfo.environment["LANGUAGE"] == "ru")
            setLanguage(nil)
            #expect(ProcessInfo.processInfo.environment["LANGUAGE"] == "de")
        }
    }

    /// An empty language string means "no selection", not a language named "".
    @Test func anEmptyLanguageIsTreatedAsFollowingTheSession() {
        let previous = ProcessInfo.processInfo.environment["LANGUAGE"]
        defer {
            restoreSessionLanguage(previous)
        }
        applySessionLanguage(nil)

        setLanguage("")
        #expect(currentLanguage == nil)
    }

    // MARK: - Accessible labels

    /// A write-only label is untestable, and that is what GTK4 gives you: an
    /// app retranslating its interface has no way to assert it re-applied the
    /// labels a screen-reader user depends on. Keeping a copy makes the gap
    /// visible to a test instead of only to somebody running a screen reader
    /// in another language.
    @Test @MainActor func theAccessibleLabelCanBeReadBack() {
        ensureAdwInit()
        let label = Label("body text")
        #expect(label.accessibleLabel == nil, "nothing set yet")

        label.setAccessibleLabel("Note body")
        #expect(label.accessibleLabel == "Note body")

        label.setAccessibleLabel("Тело заметки")
        #expect(label.accessibleLabel == "Тело заметки", "a retranslation is observable")
    }

    // MARK: - Process locale

    /// `setLanguage` mutates LC_MESSAGES to escape the C locale, so a caller
    /// needs a way to put the process back — a test suite most of all.
    @Test func theMessagesLocaleCanBeReadBackAndRestored() {
        let original = currentMessagesLocale()
        defer { if let original { setMessagesLocale(original) } }

        #expect(original != nil, "the C library always reports some LC_MESSAGES")
        // A locale nobody generates: the call must fail and leave LC_MESSAGES alone.
        #expect(setMessagesLocale("zz_ZZ.UTF-8") == false)
        #expect(currentMessagesLocale() == original, "a failed selection changes nothing")
    }

    /// `C.UTF-8` looks like a safe fallback and is generated nearly everywhere,
    /// but gettext treats it as the C locale, so offering it as an escape from
    /// the C locale can only fail — and trying it would still move the process
    /// off whatever it was on.
    @Test func cLocaleCandidatesAreSkippedRatherThanTried() throws {
        try withRestoredLocaleEnvironment {
            let previousLanguage = ProcessInfo.processInfo.environment["LANGUAGE"]
            let previousMessages = currentMessagesLocale()
            defer {
                restoreSessionLanguage(previousLanguage)
                if let previousMessages { setMessagesLocale(previousMessages) }
            }

            applySessionLanguage(nil)
            #expect(setMessagesLocale("C") == true, "the C locale itself is always available")
            #expect(setLanguage("xh", localeCandidates: ["C.UTF-8", "C", "POSIX"]) == false)
            #expect(
                currentMessagesLocale().map(isCLocale) == true,
                "a rejected candidate must not have been installed on the way to failing"
            )
        }
    }

    /// The escape has to survive `gtk_init`, which calls
    /// `setlocale(LC_ALL, "")` and so reads the environment back.
    ///
    /// What rides on it is not a cosmetic moment: GLib decides once per
    /// process whether the program is translated at all, and decides "no"
    /// when the first `g_dgettext` runs under a locale that is neither `C`
    /// nor `en_*` with no catalogue loaded — which `C.UTF-8` is. GTK looks up
    /// its own strings while initializing, so that decision is latched before
    /// an app makes its first lookup, and no later correction reaches it.
    @Test func escapingTheCLocaleSurvivesReadingTheEnvironmentBack() throws {
        try withRestoredLocaleEnvironment {
            unsetenv("LC_ALL")
            unsetenv("LC_MESSAGES")
            setenv("LANG", "C.UTF-8", 1)
            applySessionLanguage(nil)
            recaptureSessionLanguage()
            #expect(setMessagesLocale("C.UTF-8") == true, "C.UTF-8 is generated everywhere")

            let escaped = setLanguage("ru", localeCandidates: ["en_US.UTF-8", "en_GB.UTF-8"])
            guard escaped else { return } // no generated locale to escape to

            _ = cadw_activate_locale_from_environment() // what gtk_init does
            #expect(
                messagesLocaleSupportsTranslation,
                """
                the escape did not survive setlocale(LC_ALL, "") — LC_MESSAGES came back \
                as \(currentMessagesLocale() ?? "nil"), so GLib would latch this process \
                as untranslated on GTK's own first lookup
                """
            )
        }
    }

    /// `setlocale(LC_ALL, "")` gives `LC_ALL` precedence over the
    /// per-category variable, so exporting `LC_MESSAGES` alone changes
    /// nothing on a session that sets `LC_ALL` — which Debian and Python
    /// container images and plenty of build shells do.
    @Test func escapingTheCLocaleAlsoClearsACValuedLCALL() throws {
        try withRestoredLocaleEnvironment {
            setenv("LC_ALL", "C.UTF-8", 1)
            setenv("LANG", "C.UTF-8", 1)
            unsetenv("LC_MESSAGES")
            applySessionLanguage(nil)
            recaptureSessionLanguage()
            _ = cadw_activate_locale_from_environment()

            let escaped = setLanguage("ru", localeCandidates: ["en_US.UTF-8", "en_GB.UTF-8"])
            guard escaped else { return }

            _ = cadw_activate_locale_from_environment() // what gtk_init does
            #expect(
                messagesLocaleSupportsTranslation,
                "LC_ALL=C.UTF-8 outranked the exported LC_MESSAGES: \(currentMessagesLocale() ?? "nil")"
            )
        }
    }

    /// A process that never pins a language still has to escape, or GTK's own
    /// first lookup latches it and a language picked later cannot take
    /// effect at all.
    @Test func configuringLocalizationEscapesTheCLocaleWithoutPinningALanguage() throws {
        try withRestoredLocaleEnvironment {
            unsetenv("LC_ALL")
            unsetenv("LC_MESSAGES")
            unsetenv("LANGUAGE")
            setenv("LANG", "C.UTF-8", 1)
            recaptureSessionLanguage()

            // Whether this host has anything to escape *to*, established
            // before the assertion so "nothing generated here" cannot be
            // mistaken for "the escape was not attempted" — which is what
            // made the first version of this test unable to fail.
            let hasEscapeLocale = setMessagesLocale("en_US.UTF-8") || setMessagesLocale("en_GB.UTF-8")
            guard hasEscapeLocale else { return }
            #expect(setMessagesLocale("C.UTF-8") == true)

            _ = configureLocalization(domain: "adwaita.tests.clocale")
            _ = cadw_activate_locale_from_environment() // what gtk_init does
            #expect(
                messagesLocaleSupportsTranslation,
                """
                configureLocalization left the process on \(currentMessagesLocale() ?? "nil") \
                even though a locale was available, so a language picked later could never \
                take effect
                """
            )
        }
    }

    /// Following the session again keeps the escape, because undoing it would
    /// put the process back where GLib latches it as untranslated — and then
    /// even the session's own language would stop being translated.
    @Test func followingTheSessionAgainKeepsTheEscape() throws {
        try withRestoredLocaleEnvironment {
            setenv("LANG", "C.UTF-8", 1)
            unsetenv("LC_ALL")
            unsetenv("LC_MESSAGES")
            applySessionLanguage(nil)
            recaptureSessionLanguage()
            #expect(setMessagesLocale("C.UTF-8") == true)

            guard setLanguage("ru", localeCandidates: ["en_US.UTF-8", "en_GB.UTF-8"]) else { return }
            _ = setLanguage(nil)

            _ = cadw_activate_locale_from_environment() // what gtk_init does
            #expect(
                messagesLocaleSupportsTranslation,
                """
                returning to the session language put the process back on \
                \(currentMessagesLocale() ?? "nil"), where nothing can be translated at all
                """
            )
            #expect(
                ProcessInfo.processInfo.environment["LANGUAGE"] == nil,
                "the language itself must follow the session again"
            )
        }
    }

    // MARK: - What the session asked for

    /// POSIX precedence, and the category actually asked about.
    @Test func theSessionLocaleFollowsPosixPrecedence() throws {
        try withRestoredLocaleEnvironment {
            unsetenv("LC_ALL")
            setenv("LANG", "de_DE.UTF-8", 1)
            setenv("LC_TIME", "en_GB.UTF-8", 1)
            recaptureSessionLanguage()

            #expect(sessionLocaleIdentifier(for: .time) == "en_GB", "the category's own variable beats LANG")
            #expect(sessionLocaleIdentifier(for: .numeric) == "de_DE", "a category with no variable falls back to LANG")

            setenv("LC_ALL", "fr_FR.UTF-8", 1)
            recaptureSessionLanguage()
            #expect(sessionLocaleIdentifier(for: .time) == "fr_FR", "LC_ALL overrides every category")
        }
    }

    /// The codeset and modifier are not part of a locale identifier.
    @Test func theSessionLocaleStripsCodesetAndModifier() throws {
        try withRestoredLocaleEnvironment {
            unsetenv("LC_ALL")
            unsetenv("LC_TIME")
            setenv("LANG", "de_DE.UTF-8@euro", 1)
            recaptureSessionLanguage()
            #expect(sessionLocaleIdentifier(for: .time) == "de_DE")

            setenv("LANG", "pt-BR", 1)
            recaptureSessionLanguage()
            #expect(sessionLocaleIdentifier(for: .time) == "pt_BR", "a hyphen is normalised")
        }
    }

    /// A C locale is not a language, and answering with one would format like
    /// a language — which is exactly the mistake this exists to avoid.
    @Test func theCLocaleIsNotASessionLanguage() throws {
        try withRestoredLocaleEnvironment {
            unsetenv("LC_ALL")
            unsetenv("LC_TIME")
            setenv("LANG", "C.UTF-8", 1)
            recaptureSessionLanguage()
            #expect(sessionLocaleIdentifier(for: .time) == nil)

            setenv("LANG", "POSIX", 1)
            recaptureSessionLanguage()
            #expect(sessionLocaleIdentifier(for: .time) == nil)
        }
    }

    /// A variable that is set decides, even when what it says is the C
    /// locale — falling through would read `LC_ALL=C` beside a leftover
    /// `LANG=ar_EG.UTF-8` as a request for Arabic.
    @Test func aCValuedHigherPriorityVariableDecidesRatherThanFallingThrough() throws {
        try withRestoredLocaleEnvironment {
            setenv("LC_ALL", "C", 1)
            setenv("LANG", "ar_EG.UTF-8", 1)
            unsetenv("LC_TIME")
            recaptureSessionLanguage()

            #expect(sessionLocaleIdentifier(for: .time) == nil, "LC_ALL=C is an answer, not a gap")
            #expect(sessionLocaleIdentifier(for: .messages) == nil)
            // Which is what keeps the window from being mirrored around an
            // English interface.
            #expect(isRightToLeft(language: nil) == false)

            // The category's own variable behaves the same way.
            unsetenv("LC_ALL")
            setenv("LC_TIME", "POSIX", 1)
            recaptureSessionLanguage()
            #expect(sessionLocaleIdentifier(for: .time) == nil)
            #expect(sessionLocaleIdentifier(for: .numeric) == "ar_EG", "another category still reads LANG")
        }
    }

    /// An empty value is unset, which POSIX says and the app's smoke tests
    /// rely on: they empty `LC_ALL` and `LC_MESSAGES` rather than unsetting
    /// them, because the harness can override a variable but not remove it.
    @Test func anEmptyValueIsTreatedAsUnsetRatherThanAsAnAnswer() throws {
        try withRestoredLocaleEnvironment {
            setenv("LC_ALL", "", 1)
            setenv("LC_TIME", "", 1)
            setenv("LANG", "de_DE.UTF-8", 1)
            recaptureSessionLanguage()
            #expect(sessionLocaleIdentifier(for: .time) == "de_DE")
        }
    }

    /// The script subtag has to survive the direction matcher, which
    /// lowercases and looks for a four-letter second subtag.
    @Test func aScriptSubtagReachesTheDirectionMatcher() throws {
        try withRestoredLocaleEnvironment {
            unsetenv("LC_ALL")
            unsetenv("LC_TIME")
            unsetenv("LANGUAGE")
            recaptureSessionLanguage()

            // Kashmiri is right-to-left in Arabic script — its default — and
            // left-to-right in Devanagari. Both have to come out right, and
            // the difference is only in the modifier.
            for (name, expected) in [
                ("ks_IN.UTF-8", true),
                ("ks_IN@devanagari", false),
                ("uz_UZ@arabic", true),
                ("uz_UZ", false),
                ("sr_RS@latin", false)
            ] {
                setenv("LANG", name, 1)
                recaptureSessionLanguage()
                #expect(isRightToLeft(language: nil) == expected, "\(name)")
            }
        }
    }

    /// A modifier that names a script is not decoration.
    @Test func aScriptModifierBecomesAScriptSubtag() throws {
        try withRestoredLocaleEnvironment {
            unsetenv("LC_ALL")
            unsetenv("LC_TIME")
            recaptureSessionLanguage()

            for (name, expected) in [
                ("sr_RS@latin", "sr_Latn_RS"),
                ("uz_UZ@cyrillic", "uz_Cyrl_UZ"),
                ("ks_IN@devanagari", "ks_Deva_IN"),
                // Not a script: a currency, and an orthography.
                ("de_DE.UTF-8@euro", "de_DE"),
                ("ca_ES@valencia", "ca_ES")
            ] {
                setenv("LANG", name, 1)
                recaptureSessionLanguage()
                #expect(sessionLocaleIdentifier(for: .time) == expected, "\(name)")
            }

            // Stripping the script would resolve `sr_RS` to Cyrillic and
            // `ks_IN` to Arabic — the latter also reading as right-to-left.
            setenv("LANG", "sr_RS@latin", 1)
            recaptureSessionLanguage()
            #expect(Locale(identifier: "sr_Latn_RS").language.script?.identifier == "Latn")
            setenv("LANG", "ks_IN@devanagari", 1)
            recaptureSessionLanguage()
            #expect(isRightToLeft(language: nil) == false, "a Devanagari session is not right-to-left")
        }
    }

    /// A value that is nothing but a codeset or a modifier names no language.
    @Test func aValueWithNoLanguagePartIsRejected() throws {
        try withRestoredLocaleEnvironment {
            unsetenv("LC_ALL")
            unsetenv("LC_TIME")
            recaptureSessionLanguage()
            for name in ["@euro", ".UTF-8", "", "@latin"] {
                setenv("LANG", name, 1)
                recaptureSessionLanguage()
                #expect(
                    sessionLocaleIdentifier(for: .time) == nil,
                    "\(name.debugDescription) parsed as a language"
                )
            }
        }
    }

    /// The values are the session's, not the ones the C-locale escape wrote.
    ///
    /// The escape exports `LC_MESSAGES` and clears a C-valued `LC_ALL`, so a
    /// live read answers "what did this module do" instead of "what did the
    /// user ask for" — and anything deciding how to format wants the latter.
    @Test func theSessionLocaleIgnoresWhatTheEscapeExported() throws {
        try withRestoredLocaleEnvironment {
            setenv("LANG", "de_DE.UTF-8", 1)
            unsetenv("LC_ALL")
            unsetenv("LC_MESSAGES")
            unsetenv("LC_TIME")
            applySessionLanguage(nil)
            recaptureSessionLanguage()
            #expect(setMessagesLocale("C.UTF-8") == true)

            try #require(
                setLanguage("ru", localeCandidates: ["en_US.UTF-8", "en_GB.UTF-8"]),
                """
                no generated locale to escape to on this host, so the invariant this test \
                exists for cannot be exercised — CI generates one for exactly this reason
                """
            )
            #expect(
                ProcessInfo.processInfo.environment["LC_MESSAGES"] != nil,
                "precondition: the escape exports the locale it installed"
            )
            #expect(
                sessionLocaleIdentifier(for: .messages) == "de_DE",
                """
                the session locale came back as \
                \(sessionLocaleIdentifier(for: .messages) ?? "nil") — the escape's own \
                export was read back as the user's intent
                """
            )
        }
    }

    /// Runs `body` and puts every locale variable back, whatever it did.
    private func withRestoredLocaleEnvironment(_ body: () throws -> Void) throws {
        let names = ["LANGUAGE", "LC_ALL", "LC_MESSAGES", "LC_TIME", "LC_NUMERIC", "LANG"]
        let previous = names.map { ($0, ProcessInfo.processInfo.environment[$0]) }
        let previousLocale = currentMessagesLocale()
        defer {
            for (name, value) in previous {
                if let value { setenv(name, value, 1) } else { unsetenv(name) }
            }
            recaptureSessionLanguage()
            if let previousLocale { setMessagesLocale(previousLocale) }
            cadw_invalidate_translation_cache()
        }
        try body()
    }

    private func isCLocale(_ locale: String) -> Bool {
        let name = locale.split(separator: ".").first.map(String.init) ?? locale
        return name == "C" || name == "POSIX"
    }

    // MARK: - Catalogue discovery

    /// The failure this catches is silent: a resource rule that flattens
    /// `<lang>/LC_MESSAGES/` away leaves every lookup returning its msgid, and
    /// the app looks fine until someone runs it in another language.
    @Test func catalogueDiscoveryLooksForWhatGettextResolves() throws {
        let root = FileManager.default.temporaryDirectory
            .appendingPathComponent("adwaita-catalogues-\(UUID().uuidString)", isDirectory: true)
        defer { try? FileManager.default.removeItem(at: root) }

        let domain = "com.example.discovery"
        let proper = root
            .appendingPathComponent("xh", isDirectory: true)
            .appendingPathComponent("LC_MESSAGES", isDirectory: true)
        try FileManager.default.createDirectory(at: proper, withIntermediateDirectories: true)
        try Data().write(to: proper.appendingPathComponent("\(domain).mo", isDirectory: false))

        // A catalogue sitting directly in the bound directory — the flattened
        // layout — must not count.
        try Data().write(to: root.appendingPathComponent("zu.mo", isDirectory: false))
        // Nor one for a different domain.
        let otherDomain = root
            .appendingPathComponent("ts", isDirectory: true)
            .appendingPathComponent("LC_MESSAGES", isDirectory: true)
        try FileManager.default.createDirectory(at: otherDomain, withIntermediateDirectories: true)
        try Data().write(to: otherDomain.appendingPathComponent("com.example.other.mo", isDirectory: false))

        #expect(catalogueLanguages(in: root.path, domain: domain) == ["xh"])
        #expect(catalogueLanguages(in: "/nonexistent-\(UUID().uuidString)", domain: domain).isEmpty)
    }

    @Test func configureLocalizationReportsAnUnreachableCatalogue() {
        defer { setTextDomain("") }
        let missing = "/nonexistent-\(UUID().uuidString)"
        #expect(
            configureLocalization(domain: "com.example.missing", localeDirectory: missing) == false,
            "binding a directory with no catalogue has to be detectable"
        )
    }

    // MARK: - Setup

    /// `configureLocalization` has to leave a real catalogue reachable, which
    /// is the one thing a passthrough test of `localized(_:)` cannot show.
    @Test func configureLocalizationBindsACatalogueThatLookupsCanFind() throws {
        try withRestoredLocaleEnvironment {
            let previousLanguage = ProcessInfo.processInfo.environment["LANGUAGE"]
            defer {
                restoreSessionLanguage(previousLanguage)
                setTextDomain("")
            }

            let msgfmt = try #require(
                Self.toolURL(named: "msgfmt"),
                "msgfmt not found — install gettext"
            )
            let root = FileManager.default.temporaryDirectory
                .appendingPathComponent("adwaita-l10n-\(UUID().uuidString)", isDirectory: true)
            defer { try? FileManager.default.removeItem(at: root) }

            let domain = "com.example.localizationtest"
            let messages = root
                .appendingPathComponent("xh", isDirectory: true)
                .appendingPathComponent("LC_MESSAGES", isDirectory: true)
            try FileManager.default.createDirectory(at: messages, withIntermediateDirectories: true)

            let po = root.appendingPathComponent("xh.po", isDirectory: false)
            try """
            msgid ""
            msgstr "Content-Type: text/plain; charset=UTF-8\\nLanguage: xh\\n"

            msgid "Notes"
            msgstr "IZINTO"
            """.write(to: po, atomically: true, encoding: .utf8)

            let compile = Process()
            compile.executableURL = msgfmt
            compile.arguments = [
                "-o", messages.appendingPathComponent("\(domain).mo", isDirectory: false).path,
                po.path
            ]
            try compile.run()
            compile.waitUntilExit()
            try #require(compile.terminationStatus == 0, "msgfmt failed")

            configureLocalization(domain: domain, localeDirectory: root.path)
            applySessionLanguage(previousLanguage)

            // A real base locale first: gettext ignores LANGUAGE under C.
            try #require(
                setLanguage("xh", localeCandidates: ["en_US.UTF-8", "en_GB.UTF-8"]),
                """
                no generated locale on this host, so gettext ignores LANGUAGE and \
                no catalogue can be selected. Generate one — `locale-gen \
                en_US.UTF-8` on Debian — or pass one that exists here as \
                localeCandidates.
                """
            )
            #expect(
                localized("Notes") == "IZINTO",
                "configureLocalization must leave the domain bound so lookups resolve"
            )

            setLanguage(nil)
            #expect(localized("Notes") == "Notes")
        }
    }

    /// Installs `language` as the session's own LANGUAGE, through the public
    /// API rather than a testing back door.
    private func applySessionLanguage(_ language: String?) {
        if let language {
            setenv("LANGUAGE", language, 1)
        } else {
            unsetenv("LANGUAGE")
        }
        recaptureSessionLanguage()
    }

    private func restoreSessionLanguage(_ language: String?) {
        applySessionLanguage(language)
        setLanguage(nil)
    }

    private static func toolURL(named name: String) -> URL? {
        for directory in ["/usr/bin", "/bin", "/usr/local/bin", "/opt/homebrew/bin"] {
            let candidate = URL(fileURLWithPath: directory, isDirectory: true)
                .appendingPathComponent(name, isDirectory: false)
            if FileManager.default.isExecutableFile(atPath: candidate.path) {
                return candidate
            }
        }
        return nil
    }
}
#endif
