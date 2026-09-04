// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import Foundation

// Reading direction — the layout half of localization.
//
// GTK mirrors a great deal on its own once the direction is right: box and
// header-bar child order, `halign`/`margin` start and end, `GtkLabel.xalign`,
// and directional icons like `pan-end-symbolic` (looked up with an `-rtl`
// variant). What it does *not* do is decide the direction from the language
// your app chose. GTK reads its own translation of the string `default:LTR`
// during initialization, which means:
//
//   * the direction is fixed when GTK starts and never follows a language the
//     app selects later, and
//   * it depends on GTK's own catalogue being installed for that language —
//     present in the GNOME Flatpak runtime, frequently absent on a bare
//     system, where an Arabic session then comes up left-to-right.
//
// So an app that offers its own language selection has to set the direction
// itself. Doing that at runtime works: GTK re-lays-out widgets that are
// already realized, so an RTL interface does not need the window rebuilt.

/// The process-wide reading direction for widgets that have not been given one
/// explicitly.
///
/// Assigning this re-lays-out widgets that are already on screen, so it is
/// usable as a live response to a language change and not only at startup.
///
/// ```swift
/// defaultTextDirection = .rtl
/// ```
public var defaultTextDirection: GtkTextDirection {
    get { gtk_widget_get_default_direction() }
    set { gtk_widget_set_default_direction(newValue) }
}

/// Sets the process-wide reading direction to the one `language` is written
/// in, and reports which direction that was.
///
/// Pair it with ``setLanguage(_:)`` — one moves the text, the other moves the
/// layout, and a language change needs both:
///
/// ```swift
/// setLanguage("ar")
/// applyTextDirection(forLanguage: "ar")   // → .rtl
/// ```
///
/// - Important: GTK sets the default direction from its own catalogue during
///   initialization and **overwrites whatever was set before**, so a call made
///   ahead of `Application.run()` is discarded. Apply the direction once the
///   application is running — from the activation handler, before the first
///   window is built — and again whenever the language changes.
///
/// - Parameter language: A language code such as `"ar"`, `"he"` or `"en"`, or
///   `nil` to follow the session locale's own language.
/// - Returns: The direction that was applied.
@discardableResult
public func applyTextDirection(forLanguage language: String?) -> GtkTextDirection {
    let direction: GtkTextDirection = isRightToLeft(language: language) ? .rtl : .ltr
    defaultTextDirection = direction
    return direction
}

/// Whether `language` is written right-to-left.
///
/// Matching is on the language subtag, so `"ar"`, `"ar_EG"` and `"ar-EG.UTF-8"`
/// all answer the same. `nil` falls back to the session locale's language, and
/// an unrecognised language is treated as left-to-right.
///
/// The set is curated rather than derived. Pango can be talked into answering
/// this — take `pango_language_get_sample_string` and read the direction of its
/// first strong character — but the sample strings are incomplete: Pashto,
/// Uyghur and Sorani Kurdish have none and fall back to an English pangram,
/// which reports them as left-to-right. A short explicit list is both correct
/// and auditable; the languages here are those whose scripts are right-to-left
/// in CLDR.
public func isRightToLeft(language: String?) -> Bool {
    guard let subtag = languageSubtag(from: language) else { return false }
    return rightToLeftLanguages.contains(subtag)
}

/// Language subtags written in a right-to-left script.
///
/// Grouped by script so the list can be checked against CLDR rather than
/// trusted: Arabic (and the languages that adopted it), Hebrew, Thaana,
/// Syriac, N'Ko, Adlam.
private let rightToLeftLanguages: Set<String> = [
    // Arabic script
    "ar", "arc", "ckb", "fa", "glk", "ha", "kk_arab", "khw", "ks", "ku", "lrc",
    "mzn", "pnb", "ps", "sd", "skr", "ug", "ur", "uz_arab",
    // Hebrew script
    "he", "iw", "jrb", "jpr", "yi",
    // Thaana
    "dv",
    // Syriac
    "syr", "aii", "cld",
    // N'Ko
    "nqo",
    // Adlam
    "ff_adlm"
]

/// Extracts the part of a locale or language identifier that names the
/// language, keeping a script suffix where one distinguishes direction
/// (`uz_arab` is right-to-left, plain `uz` is not).
private func languageSubtag(from language: String?) -> String? {
    let raw = language ?? sessionLanguageIdentifier()
    guard let raw, !raw.isEmpty else { return nil }

    // One normaliser, shared with `sessionLocaleIdentifier(for:)`: it strips
    // the codeset, keeps a script the modifier names, and rejects the C
    // locale. A second copy here meant a fix to either — the script mapping,
    // say — silently missed the other path.
    guard let normalized = normalizedLocaleName(raw)?.lowercased() else { return nil }

    let parts = normalized.split(separator: "_").map(String.init)
    guard let base = parts.first else { return nil }
    // A four-letter second subtag is a script (uz_Arab), not a region (uz_UZ).
    if parts.count > 1, parts[1].count == 4 {
        return "\(base)_\(parts[1])"
    }
    return base
}

/// The language the session asks for, preferring `LANGUAGE` (which is what
/// gettext honours, and what ``setLanguage(_:)`` writes) over the locale.
private func sessionLanguageIdentifier() -> String? {
    // LANGUAGE first and read live, because that is the one this module sets
    // when a language is pinned — and a pinned language decides the
    // direction. The locale categories come from `sessionLocaleIdentifier`,
    // which reads what the session asked for rather than what the C-locale
    // escape has since exported: reading the escape back would decide an
    // Arabic session's direction from the `en_US` locale the app installed
    // for itself, and lay the window out left-to-right.
    if let language = ProcessInfo.processInfo.environment["LANGUAGE"], !language.isEmpty {
        // LANGUAGE is a colon-separated priority list.
        return language.split(separator: ":").first.map(String.init)
    }
    return sessionLocaleIdentifier(for: .messages)
}

public extension Widget {
    /// This widget's reading direction.
    ///
    /// Assign ``GtkTextDirection/none`` to inherit ``defaultTextDirection``,
    /// which is how widgets start. Set an explicit direction only for a subtree
    /// that must not mirror: a code view, a file path, an LTR-only diagram.
    ///
    /// Note the asymmetry — reading never returns `none`. GTK resolves an
    /// inherited direction before handing it back, so the getter always names
    /// a real direction and cannot be used to ask whether one was set.
    var textDirection: GtkTextDirection {
        get { gtk_widget_get_direction(castedPointer()) }
        set { gtk_widget_set_direction(castedPointer(), newValue) }
    }

    /// Whether this widget currently lays out right-to-left.
    ///
    /// Reflects the effective direction: `gtk_widget_get_direction` resolves an
    /// inherited direction to whatever ``defaultTextDirection`` is, so this
    /// never has to consult the default itself.
    var isRightToLeft: Bool {
        textDirection == GTK_TEXT_DIR_RTL
    }

    /// Pins this subtree left-to-right whatever the interface direction is.
    ///
    /// For content that is not prose in the user's language: a code view, a
    /// file path, a URL, a diagram whose axes have a fixed order.
    ///
    /// Prefer these over assigning ``textDirection`` directly. An app that
    /// imports a second C module pulling in `gtk/gtk.h` — GtkSourceView and
    /// libspelling both do — sees two distinct Swift types named
    /// `GtkTextDirection` and cannot name the enum case at all, so a method
    /// that takes no argument is the only form it can call.
    func forceLeftToRight() {
        textDirection = GTK_TEXT_DIR_LTR
    }

    /// Pins this subtree right-to-left whatever the interface direction is.
    func forceRightToLeft() {
        textDirection = GTK_TEXT_DIR_RTL
    }

    /// Returns this subtree to inheriting ``defaultTextDirection``.
    func followDefaultTextDirection() {
        textDirection = GTK_TEXT_DIR_NONE
    }
}
