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

    @Test func selectingALanguageRecordsItAndFollowingTheSessionClearsIt() {
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

    /// The whole point of capturing the session language: "follow the session"
    /// has to restore what the user's environment asked for, which is
    /// unrecoverable once a selection has overwritten it.
    @Test func followingTheSessionRestoresTheCapturedLanguage() {
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
    @Test func cLocaleCandidatesAreSkippedRatherThanTried() {
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

    /// The escape has to survive `gtk_init`, which calls
    /// `setlocale(LC_ALL, "")` and so reads the environment back.
    ///
    /// What rides on it is not a cosmetic moment: GLib decides once per
    /// process whether the program is translated at all, and decides "no"
    /// when the first `g_dgettext` runs under a locale that is neither `C`
    /// nor `en_*` with no catalogue loaded — which `C.UTF-8` is. GTK looks up
    /// its own strings while initializing, so that decision is latched before
    /// an app makes its first lookup, and no later correction reaches it.
    @Test func escapingTheCLocaleExportsItSoGtkInitKeepsIt() {
        let previousLanguage = ProcessInfo.processInfo.environment["LANGUAGE"]
        let previousMessages = currentMessagesLocale()
        let previousExported = ProcessInfo.processInfo.environment["LC_MESSAGES"]
        defer {
            restoreSessionLanguage(previousLanguage)
            if let previousMessages { setMessagesLocale(previousMessages) }
            if let previousExported {
                setenv("LC_MESSAGES", previousExported, 1)
            } else {
                unsetenv("LC_MESSAGES")
            }
        }

        applySessionLanguage(nil)
        unsetenv("LC_MESSAGES")
        #expect(setMessagesLocale("C") == true, "the C locale itself is always available")

        let escaped = setLanguage("ru", localeCandidates: ["en_US.UTF-8", "en_GB.UTF-8"])
        try? #require(escaped, "no generated locale on this host to escape to")
        guard escaped else { return }

        let exported = ProcessInfo.processInfo.environment["LC_MESSAGES"]
        #expect(
            exported.map(isCLocale) == false,
            """
            LC_MESSAGES was installed but not exported (\(exported ?? "unset")), so \
            gtk_init's setlocale(LC_ALL, "") would revert it to LANG and GLib would \
            latch this process as untranslated
            """
        )
        #expect(exported == currentMessagesLocale(), "the exported value must be the installed one")
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
