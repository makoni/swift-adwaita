import CAdwaita
import GObjectSupport

/// A CSS provider for loading custom stylesheets.
///
/// Wraps `GtkCssProvider`. Load CSS from a string or file, then add it
/// to the default display so all widgets pick up the styles.
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
}
