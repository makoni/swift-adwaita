// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita

/// Keyboard modifier flags for shortcuts.
///
/// Use as an `OptionSet` to combine modifiers:
/// ```swift
/// let modifiers: KeyModifiers = [.control, .shift]
/// ```
public struct KeyModifiers: OptionSet, Sendable {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// The Control (Ctrl) key.
    public static let control = KeyModifiers(rawValue: 1 << 0)
    /// The Shift key.
    public static let shift = KeyModifiers(rawValue: 1 << 1)
    /// The Alt key.
    public static let alt = KeyModifiers(rawValue: 1 << 2)
    /// The Super (Windows/Command) key.
    public static let `super` = KeyModifiers(rawValue: 1 << 3)

    /// Builds the GTK accelerator prefix string (e.g. "\<Control\>\<Shift\>").
    var acceleratorPrefix: String {
        var parts = ""
        if contains(.control) { parts += "<Control>" }
        if contains(.shift) { parts += "<Shift>" }
        if contains(.alt) { parts += "<Alt>" }
        if contains(.super) { parts += "<Super>" }
        return parts
    }
}

/// Common keyboard keys for use with shortcuts.
///
/// ```swift
/// widget.addKeyboardShortcut(key: .s, modifiers: .control) {
///     print("Save!")
///     return true
/// }
/// ```
public enum Key: Sendable {
    // Letters
    case a, b, c, d, e, f, g, h, i, j, k, l, m
    case n, o, p, q, r, s, t, u, v, w, x, y, z

    // Digits
    case digit0, digit1, digit2, digit3, digit4
    case digit5, digit6, digit7, digit8, digit9

    // Function keys
    case f1, f2, f3, f4, f5, f6
    case f7, f8, f9, f10, f11, f12

    // Navigation
    case up, down, left, right
    case home, end, pageUp, pageDown

    // Editing
    case escape, `return`, tab, space
    case backspace, delete, insert

    // Symbols
    case plus, minus, equal
    case bracketLeft, bracketRight
    case slash, backslash
    case comma, period, semicolon, apostrophe
    case grave

    /// The GTK accelerator name for this key.
    var acceleratorName: String {
        switch self {
        case .a: "a" case .b: "b" case .c: "c" case .d: "d"
        case .e: "e" case .f: "f" case .g: "g" case .h: "h"
        case .i: "i" case .j: "j" case .k: "k" case .l: "l"
        case .m: "m" case .n: "n" case .o: "o" case .p: "p"
        case .q: "q" case .r: "r" case .s: "s" case .t: "t"
        case .u: "u" case .v: "v" case .w: "w" case .x: "x"
        case .y: "y" case .z: "z"
        case .digit0: "0" case .digit1: "1" case .digit2: "2"
        case .digit3: "3" case .digit4: "4" case .digit5: "5"
        case .digit6: "6" case .digit7: "7" case .digit8: "8"
        case .digit9: "9"
        case .f1: "F1" case .f2: "F2" case .f3: "F3"
        case .f4: "F4" case .f5: "F5" case .f6: "F6"
        case .f7: "F7" case .f8: "F8" case .f9: "F9"
        case .f10: "F10" case .f11: "F11" case .f12: "F12"
        case .up: "Up" case .down: "Down"
        case .left: "Left" case .right: "Right"
        case .home: "Home" case .end: "End"
        case .pageUp: "Page_Up" case .pageDown: "Page_Down"
        case .escape: "Escape" case .return: "Return"
        case .tab: "Tab" case .space: "space"
        case .backspace: "BackSpace" case .delete: "Delete"
        case .insert: "Insert"
        case .plus: "plus" case .minus: "minus"
        case .equal: "equal" case .bracketLeft: "bracketleft"
        case .bracketRight: "bracketright"
        case .slash: "slash" case .backslash: "backslash"
        case .comma: "comma" case .period: "period"
        case .semicolon: "semicolon" case .apostrophe: "apostrophe"
        case .grave: "grave"
        }
    }
}

/// Builds a GTK accelerator string from a key and modifiers.
///
/// Example: `acceleratorString(key: .s, modifiers: .control)` → `"<Control>s"`
func acceleratorString(key: Key, modifiers: KeyModifiers = []) -> String {
    modifiers.acceleratorPrefix + key.acceleratorName
}
