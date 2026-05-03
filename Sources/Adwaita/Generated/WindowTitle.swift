// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A widget that displays a title and an optional subtitle in a header bar.
///
/// Wraps `AdwWindowTitle`. Typically used as the ``HeaderBar/titleWidget``
/// to show a two-line title area. The title is displayed in bold and the
/// subtitle in a smaller, dimmed style below it.
///
/// ```swift
/// let windowTitle = WindowTitle(title: "My App", subtitle: "Settings")
///
/// let header = HeaderBar()
/// header.titleWidget = windowTitle
///
/// // Update the subtitle dynamically
/// windowTitle.subtitle = "Account"
/// ```
@MainActor
public final class WindowTitle: Widget {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `WindowTitle`.
    public init(title: String, subtitle: String) {
        let ptr = adw_window_title_new(title, subtitle)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The subtitle text displayed below the title in a smaller, dimmed style.
    public var subtitle: String {
        get { String(cString: adw_window_title_get_subtitle(opaquePointer)) }
        set { adw_window_title_set_subtitle(opaquePointer, newValue) }
    }

    /// The main title text displayed in bold in the header bar.
    public var title: String {
        get { String(cString: adw_window_title_get_title(opaquePointer)) }
        set { adw_window_title_set_title(opaquePointer, newValue) }
    }
}
