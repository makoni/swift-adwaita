import CAdwaita
import GObjectSupport

/// The icon theme associated with a ``Display``.
///
/// Wraps `GtkIconTheme`. Use this to register additional icon search
/// paths — for example, a `Resources/icons` directory shipped inside your
/// application bundle — so symbolic and themed icon names resolve to your
/// bundled SVGs alongside the user's system theme.
///
/// ```swift
/// // Inside `Application.onActivate`:
/// let window = ApplicationWindow(application: app)
/// let theme = window.display.iconTheme
/// theme.addSearchPath(Bundle.module.bundlePath + "/Resources/icons")
/// ```
///
/// GTK returns a shared per-display instance; instantiating `IconTheme`
/// for the same `Display` twice gives you the same underlying object, so
/// adding a search path is visible to every widget on that display.
@MainActor
public final class IconTheme: GObjectRef {
    /// Returns the icon theme associated with the given display.
    ///
    /// GTK hands back a shared per-display object; this wraps it through
    /// `GObjectRef.init(borrowing:)` so ref-counting matches the rest of
    /// the framework.
    public convenience init(for display: Display) {
        let ptr = gtk_icon_theme_get_for_display(display.opaquePointer)!
        self.init(borrowing: UnsafeMutableRawPointer(ptr))
    }

    public required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Appends a directory to the list of places the theme searches for
    /// icons.
    ///
    /// Useful for pulling in a bundle-local `icons/hicolor/…` tree without
    /// installing files into the host's system icon theme.
    public func addSearchPath(_ path: String) {
        gtk_icon_theme_add_search_path(opaquePointer, path)
    }
}

public extension Display {
    /// The icon theme associated with this display.
    ///
    /// Equivalent to `IconTheme(for: self)` — provided as a property so
    /// `widget.display.iconTheme.addSearchPath(...)` reads naturally.
    var iconTheme: IconTheme {
        IconTheme(for: self)
    }
}
