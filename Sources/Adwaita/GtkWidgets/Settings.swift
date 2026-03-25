import CAdwaita
import GObjectSupport

/// A wrapper for GSettings -- persistent application settings backed by a schema.
///
/// Wraps `GSettings`. Requires a compiled GSettings schema installed on the
/// system. Create a `.gschema.xml` file and compile with `glib-compile-schemas`.
///
/// ```swift
/// let settings = Settings(schemaId: "com.example.MyApp")
///
/// // Read and write typed values
/// let name = settings.getString("username")
/// settings.setString("username", value: "Alice")
/// settings.setBool("dark-mode", value: true)
/// settings.setInt("window-width", value: 800)
///
/// // React to changes on a specific key
/// settings.onChanged(key: "dark-mode") {
///     let dark = settings.getBool("dark-mode")
///     print("Dark mode is now \(dark)")
/// }
/// ```
@MainActor
public final class Settings: GObjectRef {
    /// Creates a settings object for the given schema ID.
    ///
    /// - Parameter schemaId: The schema identifier (e.g. "com.example.MyApp").
    public init(schemaId: String) {
        let ptr = g_settings_new(schemaId)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Gets a string value for the given key.
    public func getString(_ key: String) -> String {
        let cStr = g_settings_get_string(castedPointer(), key)!
        defer { g_free(gpointer(mutating: cStr)) }
        return String(cString: cStr)
    }

    /// Sets a string value for the given key.
    @discardableResult
    public func setString(_ key: String, value: String) -> Bool {
        g_settings_set_string(castedPointer(), key, value) != 0
    }

    /// Gets an integer value for the given key.
    public func getInt(_ key: String) -> Int {
        Int(g_settings_get_int(castedPointer(), key))
    }

    /// Sets an integer value for the given key.
    @discardableResult
    public func setInt(_ key: String, value: Int) -> Bool {
        g_settings_set_int(castedPointer(), key, Int32(value)) != 0
    }

    /// Gets a boolean value for the given key.
    public func getBool(_ key: String) -> Bool {
        g_settings_get_boolean(castedPointer(), key) != 0
    }

    /// Sets a boolean value for the given key.
    @discardableResult
    public func setBool(_ key: String, value: Bool) -> Bool {
        g_settings_set_boolean(castedPointer(), key, value ? 1 : 0) != 0
    }

    /// Gets a double value for the given key.
    public func getDouble(_ key: String) -> Double {
        g_settings_get_double(castedPointer(), key)
    }

    /// Sets a double value for the given key.
    @discardableResult
    public func setDouble(_ key: String, value: Double) -> Bool {
        g_settings_set_double(castedPointer(), key, value) != 0
    }

    /// Resets a key to its default value.
    public func reset(_ key: String) {
        g_settings_reset(castedPointer(), key)
    }

    /// Emitted when a setting changes.
    ///
    /// - Parameters:
    ///   - key: The settings key to observe.
    ///   - handler: Called when the specified key changes.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onChanged(key: String, handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connectString(self, signal: .changed) { changedKey in
            if changedKey == key {
                handler()
            }
        }
    }
}
