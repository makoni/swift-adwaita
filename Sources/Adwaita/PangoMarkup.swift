// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

/// Helpers for building safe Pango markup strings.
///
/// Use ``escape(_:)`` when interpolating user-controlled text into
/// ``Label/markup``. If you do not need markup tags, prefer ``Label/text``.
public enum PangoMarkup {
    /// Escapes the five special characters recognized by Pango markup.
    ///
    /// This makes plain text safe to interpolate inside markup attributes and
    /// text nodes.
    ///
    /// ```swift
    /// let userTitle = #"Fish & "Chips""#
    /// label.markup = "<b>\(PangoMarkup.escape(userTitle))</b>"
    /// ```
    public static func escape(_ text: String) -> String {
        var escaped = String()
        escaped.reserveCapacity(text.count)
        for character in text {
            switch character {
            case "&":
                escaped.append("&amp;")
            case "<":
                escaped.append("&lt;")
            case ">":
                escaped.append("&gt;")
            case "\"":
                escaped.append("&quot;")
            case "'":
                escaped.append("&apos;")
            default:
                escaped.append(character)
            }
        }
        return escaped
    }
}
