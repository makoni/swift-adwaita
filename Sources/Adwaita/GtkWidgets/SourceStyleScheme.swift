// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import CGtkSource
import GObjectSupport

/// A typed identifier for a GtkSource style scheme.
///
/// The full set of available schemes depends on the runtime environment, so
/// use ``SourceStyleSchemeManager/schemes`` to inspect what is available on the
/// current machine. Static convenience values cover common built-in schemes.
public struct SourceStyleSchemeID: RawRepresentable, Hashable, Codable, Sendable, ExpressibleByStringLiteral,
    CustomStringConvertible {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: StringLiteralType) {
        rawValue = value
    }

    public var description: String {
        rawValue
    }
}

public extension SourceStyleSchemeID {
    static let adwaita: Self = "Adwaita"
    static let adwaitaDark: Self = "Adwaita-dark"
    static let yaru: Self = "Yaru"
    static let yaruDark: Self = "Yaru-dark"
    static let classic: Self = "classic"
    static let cobalt: Self = "cobalt"
    static let kate: Self = "kate"
    static let oblivion: Self = "oblivion"
    static let tango: Self = "tango"
}

/// A color/style scheme used by ``SourceBuffer``.
///
/// Wraps `GtkSourceStyleScheme`.
@MainActor
public final class SourceStyleScheme: GObjectRef {
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The stable scheme identifier.
    public var id: String? {
        gtk_source_style_scheme_get_id(opaquePointer).map { String(cString: $0) }
    }

    /// The stable scheme identifier as a typed value.
    public var identifier: SourceStyleSchemeID? {
        id.map { SourceStyleSchemeID(rawValue: $0) }
    }

    /// The user-visible scheme name.
    public var name: String? {
        gtk_source_style_scheme_get_name(opaquePointer).map { String(cString: $0) }
    }
}
