// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

/// A centered page with an icon, title, description, and optional child.
///
/// Wraps `AdwStatusPage`. Commonly used for empty states, error pages,
/// welcome screens, or loading states.
///
/// ```swift
/// let page = StatusPage(
///     title: "No Results",
///     description: "Try a different search term",
///     iconName: "system-search-symbolic"
/// )
///
/// // Optionally add an action button
/// let retryButton = Button(label: "Search Again")
///     .cssClass(.suggestedAction)
///     .cssClass(.pill)
///     .halign(.center)
/// page.child = retryButton
/// ```
@MainActor
public final class StatusPage: Widget {
    /// Creates a new status page.
    public init() {
        let ptr = adw_status_page_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a status page with a title and description.
    public convenience init(title: String, description: String) {
        self.init()
        self.title = title
        self.description = description
    }

    /// Creates a status page with a title, description, and icon.
    public convenience init(title: String, description: String, iconName: String) {
        self.init()
        self.title = title
        self.description = description
        self.iconName = iconName
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The icon name displayed on the status page.
    public var iconName: String? {
        get {
            guard let cStr = adw_status_page_get_icon_name(opaquePointer) else {
                return nil
            }
            return String(cString: cStr)
        }
        set {
            adw_status_page_set_icon_name(opaquePointer, newValue)
        }
    }

    /// The title displayed on the status page.
    public var title: String? {
        get {
            guard let cStr = adw_status_page_get_title(opaquePointer) else {
                return nil
            }
            return String(cString: cStr)
        }
        set {
            adw_status_page_set_title(opaquePointer, newValue)
        }
    }

    /// The description displayed below the title.
    public var description: String? {
        get {
            guard let cStr = adw_status_page_get_description(opaquePointer) else {
                return nil
            }
            return String(cString: cStr)
        }
        set {
            adw_status_page_set_description(opaquePointer, newValue)
        }
    }

    /// The child widget displayed below the description.
    public var child: Widget? {
        get {
            guard let ptr = adw_status_page_get_child(opaquePointer) else {
                return nil
            }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set {
            adw_status_page_set_child(opaquePointer, newValue?.widgetPointer)
        }
    }
}
