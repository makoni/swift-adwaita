// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// a `GdkDisplay`
@MainActor
public final class StyleManager: GObjectRef {

    /// The `accent-color` property (read-only).
    /// - Since: libadwaita 1.6
    public var accentColor: AdwAccentColor {
        adw_style_manager_get_accent_color(opaquePointer)
    }

    /// The `color-scheme` property.
    public var colorScheme: AdwColorScheme {
        get { adw_style_manager_get_color_scheme(opaquePointer) }
        set { adw_style_manager_set_color_scheme(opaquePointer, newValue) }
    }

    /// The `dark` property (read-only).
    public var dark: Bool {
        adw_style_manager_get_dark(opaquePointer) != 0
    }

    /// The `document-font-name` property (read-only).
    /// - Since: libadwaita 1.7
    public var documentFontName: String {
        String(cString: adw_style_manager_get_document_font_name(opaquePointer))
    }

    /// The `high-contrast` property (read-only).
    public var highContrast: Bool {
        adw_style_manager_get_high_contrast(opaquePointer) != 0
    }

    /// The `monospace-font-name` property (read-only).
    /// - Since: libadwaita 1.7
    public var monospaceFontName: String {
        String(cString: adw_style_manager_get_monospace_font_name(opaquePointer))
    }

    /// The `system-supports-accent-colors` property (read-only).
    /// - Since: libadwaita 1.6
    public var systemSupportsAccentColors: Bool {
        adw_style_manager_get_system_supports_accent_colors(opaquePointer) != 0
    }

    /// The `system-supports-color-schemes` property (read-only).
    public var systemSupportsColorSchemes: Bool {
        adw_style_manager_get_system_supports_color_schemes(opaquePointer) != 0
    }

    // MARK: - Convenience

    /// Returns the default `StyleManager` instance.
    public static var `default`: StyleManager {
        StyleManager(borrowing: UnsafeMutableRawPointer(adw_style_manager_get_default()!))
    }

    /// Sets the application to force dark theme.
    public func forceDark() {
        colorScheme = .forceDark
    }

    /// Sets the application to force light theme.
    public func forceLight() {
        colorScheme = .forceLight
    }

    /// Sets the application to prefer dark theme (follows system when possible).
    public func preferDark() {
        colorScheme = .preferDark
    }

    /// Sets the application to prefer light theme (follows system when possible).
    public func preferLight() {
        colorScheme = .preferLight
    }

    /// Resets to the default color scheme (follows system).
    public func resetColorScheme() {
        colorScheme = .default
    }

    /// Connects to the `notify::dark` signal to be notified of theme changes.
    @discardableResult
    public func onDarkChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .notify("dark"), handler: handler)
    }

    /// Connects to the `notify::accent-color` signal.
    @discardableResult
    public func onAccentColorChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .notify("accent-color"), handler: handler)
    }

    /// Connects to the `notify::high-contrast` signal.
    @discardableResult
    public func onHighContrastChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .notify("high-contrast"), handler: handler)
    }
}
