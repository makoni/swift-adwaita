// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// Manages the application color scheme and high-contrast preferences.
///
/// Wraps `AdwStyleManager`. Provides access to the system's preferred color
/// scheme, accent color, and high-contrast settings. Use the shared
/// ``default`` instance to read or override these values at the application
/// level.
///
/// ```swift
/// let style = StyleManager.default
///
/// // Force dark mode
/// style.forceDark()
///
/// // Or follow the system preference
/// style.resetColorScheme()
///
/// // React to theme changes
/// style.onDarkChanged {
///     print("Dark mode is now: \(style.dark)")
/// }
/// ```
///
/// - Key properties:
///   - ``colorScheme``: The requested color scheme (force dark, prefer light, etc.).
///   - ``dark``: Whether the application is currently using a dark theme (read-only).
///   - ``highContrast``: Whether high-contrast mode is active (read-only).
///   - ``accentColor``: The system accent color (read-only, since libadwaita 1.6).
///   - ``systemSupportsColorSchemes``: Whether the OS supports color scheme preferences (read-only).
/// - Key methods:
///   - ``forceDark()``, ``forceLight()``: Override the color scheme.
///   - ``preferDark()``, ``preferLight()``: Prefer a scheme but follow the system when possible.
///   - ``resetColorScheme()``: Follow the system color scheme.
///   - ``onDarkChanged(_:)``: Observe dark/light theme transitions.
@MainActor
public final class StyleManager: GObjectRef {

    /// The system accent color chosen by the user in desktop settings (read-only).
    /// - Since: libadwaita 1.6
    public var accentColor: AdwAccentColor {
        adw_style_manager_get_accent_color(opaquePointer)
    }

    /// The requested color scheme for the application (e.g. force dark, prefer light, or follow system).
    public var colorScheme: AdwColorScheme {
        get { adw_style_manager_get_color_scheme(opaquePointer) }
        set { adw_style_manager_set_color_scheme(opaquePointer, newValue) }
    }

    /// Whether the application is currently using a dark theme (read-only).
    public var dark: Bool {
        adw_style_manager_get_dark(opaquePointer) != 0
    }

    /// The system default document font name, e.g. `"Sans 11"` (read-only).
    /// - Since: libadwaita 1.7
    public var documentFontName: String {
        String(cString: adw_style_manager_get_document_font_name(opaquePointer))
    }

    /// Whether the system high-contrast mode is active (read-only).
    public var highContrast: Bool {
        adw_style_manager_get_high_contrast(opaquePointer) != 0
    }

    /// The system default monospace font name, e.g. `"Monospace 11"` (read-only).
    /// - Since: libadwaita 1.7
    public var monospaceFontName: String {
        String(cString: adw_style_manager_get_monospace_font_name(opaquePointer))
    }

    /// Whether the operating system supports user-configurable accent colors (read-only).
    /// - Since: libadwaita 1.6
    public var systemSupportsAccentColors: Bool {
        adw_style_manager_get_system_supports_accent_colors(opaquePointer) != 0
    }

    /// Whether the operating system supports color scheme preferences such as dark mode (read-only).
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

    /// Emitted when the dark mode setting has changed.
    ///
    /// - Parameter handler: A closure invoked when the dark/light theme changes.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onDarkChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .notify("dark"), handler: handler)
    }

    /// Emitted when the system accent color has changed.
    ///
    /// - Parameter handler: A closure invoked when the accent color changes.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onAccentColorChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .notify("accent-color"), handler: handler)
    }

    /// Emitted when the high contrast setting has changed.
    ///
    /// - Parameter handler: A closure invoked when high contrast mode changes.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onHighContrastChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .notify("high-contrast"), handler: handler)
    }
}
