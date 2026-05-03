// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A banner bar displayed at the top of a window to show contextual messages.
///
/// Wraps `AdwBanner`. Useful for informational messages such as "No internet
/// connection" or "New version available". The banner can be revealed or
/// hidden with an animation, and it optionally shows an action button.
///
/// ```swift
/// let banner = Banner(title: "No Internet Connection")
/// banner.buttonLabel = "Retry"
/// banner.onButtonClicked {
///     // attempt reconnection
/// }
///
/// // Place the banner at the top of your layout
/// let box = Box(orientation: .vertical, spacing: 0)
/// box.append(banner)
/// box.append(mainContent)
///
/// // Show or hide the banner
/// banner.revealed = true
/// ```
///
/// - Since: libadwaita 1.3
@MainActor
public final class Banner: Widget {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `Banner` with the given title text.
    ///
    /// - Parameter title: The message text displayed in the banner.
    public init(title: String) {
        let ptr = adw_banner_new(title)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The label displayed on the optional action button.
    ///
    /// Set to a non-`nil` string to show the button, or `nil` to hide it.
    /// - Since: libadwaita 1.3
    public var buttonLabel: String? {
        get { adw_banner_get_button_label(opaquePointer).map { String(cString: $0) } }
        set { adw_banner_set_button_label(opaquePointer, newValue) }
    }

    /// The visual style of the action button (e.g. flat, raised, suggested).
    /// - Since: libadwaita 1.7
    public var buttonStyle: AdwBannerButtonStyle {
        get { adw_banner_get_button_style(opaquePointer) }
        set { adw_banner_set_button_style(opaquePointer, newValue) }
    }

    /// Whether the banner is currently visible.
    ///
    /// Set to `true` to show the banner with a slide-down animation,
    /// or `false` to hide it.
    /// - Since: libadwaita 1.3
    public var revealed: Bool {
        get { adw_banner_get_revealed(opaquePointer) != 0 }
        set { adw_banner_set_revealed(opaquePointer, newValue ? 1 : 0) }
    }

    /// The message text displayed inside the banner.
    /// - Since: libadwaita 1.3
    public var title: String {
        get { String(cString: adw_banner_get_title(opaquePointer)) }
        set { adw_banner_set_title(opaquePointer, newValue) }
    }

    /// Whether the title text is interpreted as Pango markup.
    /// - Since: libadwaita 1.3
    public var useMarkup: Bool {
        get { adw_banner_get_use_markup(opaquePointer) != 0 }
        set { adw_banner_set_use_markup(opaquePointer, newValue ? 1 : 0) }
    }

    /// Connects a handler that is called when the user clicks the banner's action button.
    ///
    /// - Parameter handler: A closure invoked on button click.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onButtonClicked(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .buttonClicked, handler: handler)
    }
}
