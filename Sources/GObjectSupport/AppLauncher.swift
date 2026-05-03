// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita

/// Synchronous GIO helpers for launching URIs with the system's default handler.
///
/// These wrap `g_app_info_launch_default_for_uri` — the GIO equivalent of
/// `xdg-open` — and are safe to call from any actor context. They block the
/// calling thread until the launch completes or fails.
///
/// For the async, UX-friendly GTK variant with dialog support see ``UriLauncher``.
///
/// ```swift
/// // Fire-and-forget: open a folder or URL in the default application
/// try AppLauncher.launchDefault(forURI: "file:///home/user/notes")
/// ```
public enum AppLauncher {
    /// Launches the default application for `uri`, blocking until the GIO
    /// call returns.
    ///
    /// - Parameter uri: A URI such as `https://example.com` or `file:///…`.
    /// - Throws: ``GLibError`` when GIO reports a failure.
    public nonisolated static func launchDefault(forURI uri: String) throws {
        var error: UnsafeMutablePointer<GError>?
        let ok = g_app_info_launch_default_for_uri(uri, nil, &error)
        if ok == 0 {
            if let error {
                throw GLibError(consuming: error)
            }
            let synthetic = g_error_new_literal(0, 0, "No application could open \(uri).")!
            throw GLibError(consuming: synthetic)
        }
    }
}
