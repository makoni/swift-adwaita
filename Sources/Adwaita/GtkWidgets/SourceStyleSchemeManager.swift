// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import CGtkSource
import GObjectSupport

/// Access to GtkSource style schemes.
///
/// Wraps `GtkSourceStyleSchemeManager`.
@MainActor
public final class SourceStyleSchemeManager: GObjectRef {
    /// The process-wide default manager.
    public static var `default`: SourceStyleSchemeManager {
        let ptr = gtk_source_style_scheme_manager_get_default()!
        return SourceStyleSchemeManager(borrowing: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// All known style-scheme identifiers.
    public var schemeIDs: [String] {
        guard let ids = gtk_source_style_scheme_manager_get_scheme_ids(opaquePointer) else { return [] }
        var result: [String] = []
        var index = 0
        while let current = ids[index] {
            result.append(String(cString: current))
            index += 1
        }
        return result
    }

    /// All known style-scheme identifiers as typed values.
    public var schemes: [SourceStyleSchemeID] {
        schemeIDs.map { SourceStyleSchemeID(rawValue: $0) }
    }

    /// Chooses a preferred style-scheme identifier from a list of available schemes.
    ///
    /// This prefers common GNOME/Ubuntu pairs (`Yaru`, `Adwaita`) and then falls
    /// back to other well-known light/dark schemes before using a generic
    /// darkness-based heuristic.
    public static func preferredSchemeID(
        available schemes: [SourceStyleSchemeID],
        dark: Bool
    ) -> SourceStyleSchemeID? {
        guard !schemes.isEmpty else { return nil }

        let available = Set(schemes)
        let preferredDark: [SourceStyleSchemeID] = [.yaruDark, .adwaitaDark, .oblivion, .cobalt]
        let preferredLight: [SourceStyleSchemeID] = [.yaru, .adwaita, .classic, .kate, .tango]
        let preferred = dark ? preferredDark : preferredLight

        if let exact = preferred.first(where: { available.contains($0) }) {
            return exact
        }

        if dark, let firstDark = schemes.first(where: { $0.rawValue.localizedCaseInsensitiveContains("dark") }) {
            return firstDark
        }
        if !dark, let firstLight = schemes.first(where: { !$0.rawValue.localizedCaseInsensitiveContains("dark") }) {
            return firstLight
        }
        return schemes.first
    }

    /// Chooses a preferred style-scheme identifier for the current environment.
    public func preferredSchemeID(dark: Bool = StyleManager.default.dark) -> SourceStyleSchemeID? {
        Self.preferredSchemeID(available: schemes, dark: dark)
    }

    /// Looks up a style scheme by identifier.
    public func scheme(id: String) -> SourceStyleScheme? {
        guard let ptr = gtk_source_style_scheme_manager_get_scheme(opaquePointer, id) else { return nil }
        return SourceStyleScheme(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Looks up a style scheme by typed identifier.
    public func scheme(id: SourceStyleSchemeID) -> SourceStyleScheme? {
        scheme(id: id.rawValue)
    }

    /// Chooses a preferred style scheme for the current environment.
    public func preferredScheme(dark: Bool = StyleManager.default.dark) -> SourceStyleScheme? {
        guard let id = preferredSchemeID(dark: dark) else { return nil }
        return scheme(id: id)
    }
}
