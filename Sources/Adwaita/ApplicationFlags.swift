import CAdwaita

/// Flags that control how an ``Application`` is registered and how it
/// interacts with GLib's application machinery.
///
/// Mirrors `GApplicationFlags` as a Swift-native `OptionSet`, so callers
/// can write `[.handlesOpen, .nonUnique]` instead of bit-twiddling raw
/// `GApplicationFlags` values. Pass an instance to
/// ``Application/init(id:flags:)-swift.init``.
///
/// ```swift
/// let app = Application(id: "com.example.MyApp", flags: .handlesOpen)
/// app.onOpen { urls, hint in ... }
/// ```
public struct ApplicationFlags: OptionSet, Sendable {
    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    /// The application is a service — it stays alive between activations.
    public static let isService = ApplicationFlags(rawValue: 1 << 0)

    /// The application is a launcher for subordinate processes.
    public static let isLauncher = ApplicationFlags(rawValue: 1 << 1)

    /// The application handles `open` activations; it can be started with
    /// file arguments and receives them through ``Application/onOpen(_:)``.
    public static let handlesOpen = ApplicationFlags(rawValue: 1 << 2)

    /// The application handles command-line arguments through
    /// `command-line` activations.
    public static let handlesCommandLine = ApplicationFlags(rawValue: 1 << 3)

    /// Forwards the environment to the primary instance of a unique
    /// application.
    public static let sendEnvironment = ApplicationFlags(rawValue: 1 << 4)

    /// The application is not unique — each invocation creates a new
    /// process rather than activating the existing primary instance.
    public static let nonUnique = ApplicationFlags(rawValue: 1 << 5)

    /// The application ID can be overridden on the command line.
    public static let canOverrideAppId = ApplicationFlags(rawValue: 1 << 6)

    /// The application is willing to have another instance replace it.
    public static let allowReplacement = ApplicationFlags(rawValue: 1 << 7)

    /// This invocation should replace the currently running instance.
    public static let replace = ApplicationFlags(rawValue: 1 << 8)

    /// Bridges to the C type GTK/GIO expect.
    var asGApplicationFlags: GApplicationFlags {
        GApplicationFlags(rawValue: rawValue)
    }
}
