import CAdwaita
import GObjectSupport

/// A helper for the async callback pattern.
private final class UriAsyncBox<T>: @unchecked Sendable {
    let value: T
    init(_ value: T) {
        self.value = value
    }
}

/// Launches URIs (URLs, files) using the default system handler.
///
/// Wraps `GtkUriLauncher`. Opens URLs in the default browser,
/// files in their associated application, etc. Supports both
/// fire-and-forget and async completion-based launching.
///
/// ```swift
/// // Open a URL in the default browser
/// let launcher = UriLauncher(uri: "https://gnome.org")
/// launcher.launch()
///
/// // Open with async result
/// let success = await launcher.launch()
/// print("Launched: \(success)")
///
/// // Change URI and launch again
/// launcher.uri = "https://gtk.org"
/// launcher.launch()
/// ```
@MainActor
public final class UriLauncher: GObjectRef {
    /// Creates a URI launcher for the given URI.
    public init(uri: String) {
        let ptr = gtk_uri_launcher_new(uri)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
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

    /// Launches the URI asynchronously (fire and forget).
    ///
    /// - Parameter parent: An optional parent widget for positioning dialogs.
    public func launch(parent: Widget? = nil) {
        let parentPtr = parent?.pointer.assumingMemoryBound(to: CAdwaita.GtkWindow.self)
        gtk_uri_launcher_launch(opaquePointer, parentPtr, nil, nil, nil)
    }

    /// Launches the URI and reports success through a completion handler.
    ///
    /// Callback-based counterpart to ``launch(parent:)-async``. Prefer this
    /// form inside GTK applications: Swift's default main actor executor
    /// is `DispatchQueue.main`, which the GLib main loop does not drain,
    /// so `Task { @MainActor in await launch(parent:) }` bodies never
    /// execute.
    ///
    /// - Parameters:
    ///   - parent: An optional parent widget for positioning dialogs.
    ///   - completion: Called on the main actor with `true` on success.
    public func launch(
        parent: Widget? = nil,
        completion: @escaping @MainActor (Bool) -> Void
    ) {
        let box = Unmanaged.passRetained(UriAsyncBox(completion)).toOpaque()
        let parentPtr = parent?.pointer.assumingMemoryBound(to: CAdwaita.GtkWindow.self)
        gtk_uri_launcher_launch(
            opaquePointer,
            parentPtr,
            nil,
            { source, result, userData in
                guard let userData, let source, let result else { return }
                var error: UnsafeMutablePointer<GError>?
                let success = gtk_uri_launcher_launch_finish(
                    OpaquePointer(source),
                    result,
                    &error
                )
                if let error { g_error_free(error) }
                let box = Unmanaged<UriAsyncBox<@MainActor (Bool) -> Void>>.fromOpaque(userData)
                    .takeRetainedValue()
                MainActor.assumeIsolated {
                    box.value(success != 0)
                }
            },
            box
        )
    }

    /// Launches the URI and returns whether it was successful.
    ///
    /// - Parameter parent: An optional parent widget for positioning dialogs.
    /// - Returns: `true` if the URI was launched successfully.
    public func launch(parent: Widget? = nil) async -> Bool {
        await withCheckedContinuation { continuation in
            let box = Unmanaged.passRetained(UriAsyncBox(continuation)).toOpaque()
            let parentPtr = parent?.pointer.assumingMemoryBound(to: CAdwaita.GtkWindow.self)
            gtk_uri_launcher_launch(
                opaquePointer,
                parentPtr,
                nil,
                { source, result, userData in
                    guard let userData, let source, let result else { return }
                    var error: UnsafeMutablePointer<GError>?
                    let success = gtk_uri_launcher_launch_finish(
                        OpaquePointer(source),
                        result,
                        &error
                    )
                    if let error { g_error_free(error) }
                    let box = Unmanaged<UriAsyncBox<CheckedContinuation<Bool, Never>>>.fromOpaque(userData)
                        .takeRetainedValue()
                    MainActor.assumeIsolated {
                        box.value.resume(returning: success != 0)
                    }
                },
                box
            )
        }
    }
}
