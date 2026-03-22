import CAdwaita
import GObjectSupport

/// An Adwaita application.
///
/// Wraps `AdwApplication`, which extends `GtkApplication` with Adwaita
/// style management and automatic initialization.
@MainActor
public final class Application: GObjectRef {
    /// Creates a new Adwaita application.
    ///
    /// - Parameters:
    ///   - id: The application identifier (e.g. `"com.example.MyApp"`).
    ///   - flags: Application flags. Defaults to `.flagsNone`.
    public init(id: String, flags: GApplicationFlags = G_APPLICATION_DEFAULT_FLAGS) {
        let ptr = adw_application_new(id, flags)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The underlying `AdwApplication` pointer.
    public var applicationPointer: UnsafeMutablePointer<AdwApplication> {
        castedPointer()
    }

    /// The underlying `GtkApplication` pointer.
    public var gtkApplicationPointer: UnsafeMutablePointer<GtkApplication> {
        castedPointer()
    }

    /// Runs the application. Blocks until the application exits.
    ///
    /// - Returns: The exit status.
    @discardableResult
    public func run() -> Int {
        let gApp: UnsafeMutablePointer<GApplication> = castedPointer()
        return Int(g_application_run(gApp, 0, nil))
    }

    /// Connects a handler to the `activate` signal.
    ///
    /// This is called when the application is launched (e.g. the user opens it).
    @discardableResult
    public func onActivate(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "activate", handler: handler)
    }
}
