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

    @Test @MainActor func applyingDirectionForALanguageSetsTheProcessDefault() {
        ensureAdwInit()
        let original = defaultTextDirection
        defer { defaultTextDirection = original }

        // Assigning the default direction makes GTK walk its list of live
        // toplevels. A window finalized while still on that list makes the walk
        // read freed memory and takes the whole run down with a SIGSEGV, which
        // is a miserable way to learn that some earlier test leaked a window.
        // Fail legibly instead.
        #expect(
            Self.danglingToplevelCount() == 0,
            """
            GTK's toplevel list holds finalized windows, so changing the \
            default direction would crash. Some test created a window and let \
            its wrapper go without calling destroy().
            """
        )

        #expect(applyTextDirection(forLanguage: "ar") == GTK_TEXT_DIR_RTL)
        #expect(defaultTextDirection == GTK_TEXT_DIR_RTL)

        #expect(applyTextDirection(forLanguage: "ru") == GTK_TEXT_DIR_LTR)
        #expect(defaultTextDirection == GTK_TEXT_DIR_LTR)
    }

    /// The property that makes a live language switch possible: GTK re-reads
    /// the direction for widgets that already exist, so an RTL interface does
    /// not require rebuilding the window.
    @Test @MainActor func changingTheDefaultDirectionReachesExistingWidgets() {
        ensureAdwInit()
        let original = defaultTextDirection
        defer { defaultTextDirection = original }
        #expect(Self.danglingToplevelCount() == 0, "a leaked window would make this crash, not fail")

        defaultTextDirection = GTK_TEXT_DIR_LTR
        let label = Label("abc")
        #expect(label.isRightToLeft == false)

        defaultTextDirection = GTK_TEXT_DIR_RTL
        #expect(label.isRightToLeft, "a widget with no explicit direction follows the default")
    }

    /// An explicit direction is what keeps a subtree — a code view, a path —
    /// left-to-right inside a mirrored window.
    @Test @MainActor func anExplicitWidgetDirectionOverridesTheDefault() {
        ensureAdwInit()
        let original = defaultTextDirection
        defer { defaultTextDirection = original }

        defaultTextDirection = GTK_TEXT_DIR_RTL
        let label = Label("/usr/share/locale")
        label.forceLeftToRight()
        #expect(label.textDirection == GTK_TEXT_DIR_LTR)
        #expect(label.isRightToLeft == false, "an explicit direction wins over the process default")

        label.followDefaultTextDirection()
        #expect(label.isRightToLeft, "back to inheriting the mirrored default")

        label.forceRightToLeft()
        defaultTextDirection = GTK_TEXT_DIR_LTR
        #expect(label.isRightToLeft, "an explicit direction survives a default that disagrees")
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
            "no usable locale on this host — gettext ignores LANGUAGE under C"
        )
        #expect(
            localized("Notes") == "IZINTO",
            "configureLocalization must leave the domain bound so lookups resolve"
        )

        setLanguage(nil)
        #expect(localized("Notes") == "Notes")
    }

    /// Entries in GTK's toplevel list that are no longer valid objects.
    ///
    /// Cheap canary: `gtk_window_destroy` unregisters a window, dropping its
    /// Swift wrapper alone does not reliably do so.
    private static func danglingToplevelCount() -> Int {
        var dangling = 0
        var node = gtk_window_list_toplevels()
        while let current = node {
            if let raw = current.pointee.data,
               g_type_check_instance_is_a(
                   raw.assumingMemoryBound(to: GTypeInstance.self),
                   gtk_widget_get_type()
               ) == 0 {
                dangling += 1
            }
            node = current.pointee.next
        }
        return dangling
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
