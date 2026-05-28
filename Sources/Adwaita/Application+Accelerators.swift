// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita

public extension Application {
    /// Registers keyboard accelerators for a named GAction.
    ///
    /// Wraps `gtk_application_set_accels_for_action`. Unlike
    /// `Widget.addKeyboardShortcut`, which creates a `GtkShortcut` scoped to
    /// one widget, this method binds accelerators at the application level so
    /// they work even when no widget with the shortcut has focus — and they
    /// appear in menu-bar items that reference the same action name.
    ///
    /// Pass an empty array to clear all accelerators for the action.
    ///
    /// ```swift
    /// app.setAccelerators(["<Primary>f"], for: "win.find")
    /// app.setAccelerators(["<Primary>q"], for: "app.quit")
    /// app.setAccelerators([], for: "win.find")   // clear
    /// ```
    ///
    /// - Parameters:
    ///   - accels: Accelerator strings in GTK format (e.g. `"<Primary>k"`).
    ///   - actionName: The detailed action name (e.g. `"app.quit"`, `"win.find"`).
    func setAccelerators(_ accels: [String], for actionName: String) {
        withCStringArray(accels) { ptr in
            gtk_application_set_accels_for_action(gtkApplicationPointer, actionName, ptr)
        }
    }
}

// MARK: - Private helpers

/// Calls `body` with a null-terminated C array of the given Swift strings.
///
/// Each string is valid only within the lifetime of `body`. The recursive
/// implementation is intentional: each `withCString` frame must stay alive
/// for the duration of the call, so an iterative approach using a plain
/// array of `UnsafePointer<CChar>?` would hold dangling pointers once the
/// `withCString` frame returns. Recursion keeps each frame alive until
/// `body` completes. For GTK accelerator lists (≤ 3 entries) the call
/// depth is negligible.
private func withCStringArray<T>(
    _ strings: [String],
    _ body: (UnsafePointer<UnsafePointer<CChar>?>?) -> T
) -> T {
    func recurse(
        _ remaining: ArraySlice<String>,
        _ accumulated: [UnsafePointer<CChar>?]
    ) -> T {
        guard let first = remaining.first else {
            // Null-terminated
            var arr = accumulated + [nil]
            return arr.withUnsafeMutableBufferPointer { buf in
                body(UnsafePointer(buf.baseAddress))
            }
        }
        return first.withCString { ptr in
            recurse(remaining.dropFirst(), accumulated + [UnsafePointer(ptr)])
        }
    }
    return recurse(strings[...], [])
}
