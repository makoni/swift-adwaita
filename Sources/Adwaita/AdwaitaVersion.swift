// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita

/// Runtime version information for the installed libadwaita library.
///
/// Use this to check whether specific API versions are available before
/// calling them. This is important when building on a system with a newer
/// libadwaita but deploying to a system with an older version.
///
/// ```swift
/// if AdwaitaVersion.isAtLeast(1, 6) {
///     // Use 1.6+ APIs safely
/// }
/// ```
public enum AdwaitaVersion {
    /// The major version of the installed libadwaita.
    public static var major: Int {
        Int(cadw_adw_major_version())
    }

    /// The minor version of the installed libadwaita.
    public static var minor: Int {
        Int(cadw_adw_minor_version())
    }

    /// The micro version of the installed libadwaita.
    public static var micro: Int {
        Int(cadw_adw_micro_version())
    }

    /// Returns `true` if the installed libadwaita is at least the given version.
    public static func isAtLeast(_ major: Int, _ minor: Int, _ micro: Int = 0) -> Bool {
        let m = self.major
        let n = self.minor
        let p = self.micro
        return m > major || (m == major && (n > minor || (n == minor && p >= micro)))
    }

}
