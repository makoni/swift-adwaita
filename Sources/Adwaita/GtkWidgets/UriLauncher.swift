import CAdwaita
import GObjectSupport

/// Launches URIs (URLs, files) using the system handler.
///
/// Wraps `GtkUriLauncher`. Opens URLs in the default browser,
/// files in their associated application, etc.
@MainActor
public final class UriLauncher: GObjectRef {
    /// Creates a URI launcher for the given URI.
    public init(uri: String) {
        let ptr = gtk_uri_launcher_new(uri)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The URI to launch.
    public var uri: String? {
        get {
            guard let cStr = gtk_uri_launcher_get_uri(opaquePointer) else { return nil }
            return String(cString: cStr)
        }
        set { gtk_uri_launcher_set_uri(opaquePointer, newValue) }
    }

    /// Launches the URI asynchronously.
    ///
    /// - Parameter parent: An optional parent widget for positioning dialogs.
    public func launch(parent: Widget? = nil) {
        let parentPtr = parent?.pointer.assumingMemoryBound(to: CAdwaita.GtkWindow.self)
        gtk_uri_launcher_launch(opaquePointer, parentPtr, nil, nil, nil)
    }
}
