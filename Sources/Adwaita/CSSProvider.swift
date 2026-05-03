// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

/// A CSS provider for loading custom stylesheets.
///
/// Wraps `GtkCssProvider`. Load CSS from a string or file, then add it
/// to the default display so all widgets pick up the styles.
///
/// ```swift
/// // Apply global CSS from a string
/// let css = CSSProvider.loadGlobal("""
///     .accent-label { color: @accent_color; font-weight: bold; }
///     .rounded-box  { border-radius: 12px; padding: 8px; }
///     """)
///
/// // Or load CSS from a file
/// let provider = CSSProvider()
/// provider.loadFromPath("/usr/share/myapp/style.css")
/// provider.addToDefaultDisplay()
/// ```
@MainActor
public final class CSSProvider {
    private let provider: UnsafeMutablePointer<GtkCssProvider>

    /// Creates a new CSS provider.
    public init() {
        provider = gtk_css_provider_new()
    }

    /// Loads CSS from a string.
    public func loadFromString(_ css: String) {
        gtk_css_provider_load_from_string(provider, css)
    }

    /// Loads CSS from a file path.
    public func loadFromPath(_ path: String) {
        gtk_css_provider_load_from_path(provider, path)
    }

    /// Adds this provider to the default display so its styles apply globally.
    public func addToDefaultDisplay(priority: Int = Int(GTK_STYLE_PROVIDER_PRIORITY_APPLICATION)) {
        let display = gdk_display_get_default()
        gtk_style_context_add_provider_for_display(
            display,
            OpaquePointer(provider),
            UInt32(priority)
        )
    }

    /// Removes this provider from the default display.
    public func removeFromDefaultDisplay() {
        let display = gdk_display_get_default()
        gtk_style_context_remove_provider_for_display(
            display,
            OpaquePointer(provider)
        )
    }

    /// Convenience: loads CSS from a string and adds to the default display in one call.
    @discardableResult
    public static func loadGlobal(_ css: String,
                                  priority: Int = Int(GTK_STYLE_PROVIDER_PRIORITY_APPLICATION)) -> CSSProvider {
        let provider = CSSProvider()
        provider.loadFromString(css)
        provider.addToDefaultDisplay(priority: priority)
        return provider
    }
}
