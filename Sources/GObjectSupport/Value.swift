import CAdwaita

/// Swift-friendly wrapper around `GValue` for type-safe property access.
///
/// `GValue` is GLib's generic value container. This helper provides
/// ergonomic initializers and accessors for the most common types.
///
/// ```swift
/// // Create typed values
/// var strVal = GValueRef("Hello")
/// var intVal = GValueRef(Int32(42))
/// var boolVal = GValueRef(true)
///
/// // Read values back
/// print(strVal.stringValue ?? "nil")  // "Hello"
/// print(intVal.intValue)              // 42
/// print(boolVal.boolValue)            // true
///
/// // Pass to GObject property APIs
/// let propValue = widget.getProperty("label")
/// print(propValue.stringValue ?? "")
/// ```
@MainActor
public struct GValueRef {
    private var gvalue: GValue

    /// Creates a GValue holding a `String`.
    public init(_ value: String) {
        gvalue = GValue()
        g_value_init(&gvalue, cadw_type_string())
        g_value_set_string(&gvalue, value)
    }

    /// Creates a GValue holding an `Int32`.
    public init(_ value: Int32) {
        gvalue = GValue()
        g_value_init(&gvalue, cadw_type_int())
        g_value_set_int(&gvalue, value)
    }

    /// Creates a GValue holding a `UInt32`.
    public init(_ value: UInt32) {
        gvalue = GValue()
        g_value_init(&gvalue, cadw_type_uint())
        g_value_set_uint(&gvalue, value)
    }

    /// Creates a GValue holding a `Bool`.
    public init(_ value: Bool) {
        gvalue = GValue()
        g_value_init(&gvalue, cadw_type_boolean())
        g_value_set_boolean(&gvalue, value ? 1 : 0)
    }

    /// Creates a GValue holding a `Double`.
    public init(_ value: Double) {
        gvalue = GValue()
        g_value_init(&gvalue, cadw_type_double())
        g_value_set_double(&gvalue, value)
    }

    /// Creates a GValue holding a `Float`.
    public init(_ value: Float) {
        gvalue = GValue()
        g_value_init(&gvalue, cadw_type_float())
        g_value_set_float(&gvalue, value)
    }

    /// Creates a GValue holding a `Int64`.
    public init(_ value: Int64) {
        gvalue = GValue()
        g_value_init(&gvalue, cadw_type_int64())
        g_value_set_int64(&gvalue, gint64(value))
    }

    /// Calls a closure with a pointer to the underlying `GValue`.
    public mutating func withUnsafePointer<R>(_ body: (UnsafePointer<GValue>) -> R) -> R {
        Swift.withUnsafePointer(to: &gvalue, body)
    }

    /// Calls a closure with a mutable pointer to the underlying `GValue`.
    public mutating func withUnsafeMutablePointer<R>(_ body: (UnsafeMutablePointer<GValue>) -> R) -> R {
        Swift.withUnsafeMutablePointer(to: &gvalue, body)
    }

    // MARK: - Getters

    /// Gets the stored `String` value, or `nil` if not a string.
    public var stringValue: String? {
        mutating get {
            guard cadw_value_holds_string(&gvalue) != 0 else { return nil }
            return g_value_get_string(&gvalue).map { String(cString: $0) }
        }
    }

    /// Gets the stored `Int32` value.
    public var intValue: Int32 {
        mutating get { g_value_get_int(&gvalue) }
    }

    /// Gets the stored `UInt32` value.
    public var uintValue: UInt32 {
        mutating get { g_value_get_uint(&gvalue) }
    }

    /// Gets the stored `Bool` value.
    public var boolValue: Bool {
        mutating get { g_value_get_boolean(&gvalue) != 0 }
    }

    /// Gets the stored `Double` value.
    public var doubleValue: Double {
        mutating get { g_value_get_double(&gvalue) }
    }

    /// Gets the stored `Float` value.
    public var floatValue: Float {
        mutating get { g_value_get_float(&gvalue) }
    }
}

// MARK: - GObject property access

extension GObjectRef {
    /// Gets a GObject property by name.
    public func getProperty(_ name: String) -> GValueRef {
        var gvalue = GValueRef(Int32(0))
        gvalue.withUnsafeMutablePointer { ptr in
            g_object_get_property(gobjectPointer, name, ptr)
        }
        return gvalue
    }

    /// Sets a GObject property by name.
    public func setProperty(_ name: String, value: inout GValueRef) {
        value.withUnsafePointer { ptr in
            g_object_set_property(gobjectPointer, name, ptr)
        }
    }
}
