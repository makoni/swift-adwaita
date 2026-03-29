import CAdwaita

/// A property wrapper that syncs a value with GSettings.
///
/// Provides automatic read/write to a GSettings key with type safety.
/// Requires a compiled GSettings schema on the system.
///
/// ```swift
/// class AppState {
///     let settings = Settings(schemaId: "com.example.MyApp")
///
///     @Setting(key: "window-width")
///     var windowWidth: Int = 800
///
///     @Setting(key: "dark-mode")
///     var darkMode: Bool = false
///
///     @Setting(key: "username")
///     var username: String = ""
///
///     init() {
///         _windowWidth.bind(to: settings)
///         _darkMode.bind(to: settings)
///         _username.bind(to: settings)
///     }
/// }
/// ```
@MainActor
@propertyWrapper
public struct Setting<Value: SettingValue> {
    private let key: String
    private let defaultValue: Value
    private var settings: Settings?

    /// Creates a setting property wrapper.
    ///
    /// - Parameters:
    ///   - key: The GSettings key name.
    ///   - wrappedValue: The default value (used before `bind(to:)` is called).
    public init(wrappedValue: Value, key: String) {
        self.key = key
        defaultValue = wrappedValue
    }

    /// Binds this setting to a GSettings instance.
    ///
    /// Call this in your initializer after creating the Settings object.
    public mutating func bind(to settings: Settings) {
        self.settings = settings
    }

    public var wrappedValue: Value {
        get {
            guard let settings else { return defaultValue }
            return Value.get(from: settings, key: key)
        }
        nonmutating set {
            guard let settings else { return }
            Value.set(newValue, in: settings, key: key)
        }
    }
}

/// A type that can be stored in and retrieved from GSettings.
@MainActor
public protocol SettingValue {
    static func get(from settings: Settings, key: String) -> Self
    static func set(_ value: Self, in settings: Settings, key: String)
}

extension String: SettingValue {
    @MainActor public static func get(from settings: Settings, key: String) -> String {
        settings.getString(key)
    }

    @MainActor public static func set(_ value: String, in settings: Settings, key: String) {
        settings.setString(key, value: value)
    }
}

extension Int: SettingValue {
    @MainActor public static func get(from settings: Settings, key: String) -> Int {
        settings.getInt(key)
    }

    @MainActor public static func set(_ value: Int, in settings: Settings, key: String) {
        settings.setInt(key, value: value)
    }
}

extension Bool: SettingValue {
    @MainActor public static func get(from settings: Settings, key: String) -> Bool {
        settings.getBool(key)
    }

    @MainActor public static func set(_ value: Bool, in settings: Settings, key: String) {
        settings.setBool(key, value: value)
    }
}

extension Double: SettingValue {
    @MainActor public static func get(from settings: Settings, key: String) -> Double {
        settings.getDouble(key)
    }

    @MainActor public static func set(_ value: Double, in settings: Settings, key: String) {
        settings.setDouble(key, value: value)
    }
}
