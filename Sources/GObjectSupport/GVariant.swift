import CAdwaita

/// A wrapper around GVariant for type-safe value passing.
///
/// GVariant is GLib's immutable, reference-counted value container used
/// throughout GIO for action parameters, menu attributes, D-Bus messages,
/// and GSettings. Unlike GObject, GVariant uses its own reference counting
/// via `g_variant_ref` / `g_variant_unref` and has a "floating reference"
/// mechanism similar to `GInitiallyUnowned`.
///
/// This wrapper sinks any floating reference on construction and provides
/// typed constructors and accessors for common types.
///
/// ```swift
/// let v = Variant.string("hello")
/// print(v.stringValue ?? "nil")  // "hello"
///
/// let n = Variant.int32(42)
/// print(n.int32Value)  // 42
/// ```
@MainActor
public final class Variant {
    /// The underlying GVariant pointer.
    ///
    /// This wrapper owns exactly one strong reference to this pointer.
    public nonisolated(unsafe) let pointer: OpaquePointer

    /// Takes ownership of a GVariant pointer by sinking any floating reference.
    private init(sinking ptr: OpaquePointer) {
        // g_variant_ref_sink: if floating, sinks it (consumes the floating ref
        // and gives us a real ref); if not floating, adds a ref.
        pointer = g_variant_ref_sink(ptr)
    }

    /// Borrows a reference to an existing GVariant by adding a new strong ref.
    ///
    /// Use this when receiving a GVariant pointer that you do not own (e.g.
    /// from a signal parameter) and need to keep it alive.
    public init(borrowing ptr: OpaquePointer) {
        pointer = g_variant_ref(ptr)
    }

    isolated deinit {
        g_variant_unref(pointer)
    }

    // MARK: - Constructors

    /// Creates a Variant holding a string value.
    public static func string(_ value: String) -> Variant {
        Variant(sinking: g_variant_new_string(value))
    }

    /// Creates a Variant holding a 32-bit signed integer.
    public static func int32(_ value: Int32) -> Variant {
        Variant(sinking: g_variant_new_int32(value))
    }

    /// Creates a Variant holding a 64-bit signed integer.
    public static func int64(_ value: Int64) -> Variant {
        Variant(sinking: g_variant_new_int64(gint64(value)))
    }

    /// Creates a Variant holding a double-precision floating point value.
    public static func double(_ value: Double) -> Variant {
        Variant(sinking: g_variant_new_double(value))
    }

    /// Creates a Variant holding a boolean value.
    public static func boolean(_ value: Bool) -> Variant {
        Variant(sinking: g_variant_new_boolean(value ? 1 : 0))
    }

    // MARK: - Type checking

    /// Returns `true` if this variant has the given type string.
    ///
    /// Common type strings: `"s"` (string), `"i"` (int32), `"x"` (int64),
    /// `"d"` (double), `"b"` (boolean).
    public func isOfType(_ typeString: String) -> Bool {
        guard let vtype = g_variant_type_new(typeString) else { return false }
        let result = g_variant_is_of_type(pointer, vtype)
        g_variant_type_free(vtype)
        return result != 0
    }

    // MARK: - Accessors

    /// The string value, or `nil` if this variant does not hold a string.
    public var stringValue: String? {
        guard g_variant_is_of_type(pointer, g_variant_type_checked_("s")) != 0 else {
            return nil
        }
        guard let cStr = g_variant_get_string(pointer, nil) else { return nil }
        return String(cString: cStr)
    }

    /// The 32-bit signed integer value.
    ///
    /// The caller is responsible for ensuring the variant holds an `int32`.
    public var int32Value: Int32 {
        g_variant_get_int32(pointer)
    }

    /// The 64-bit signed integer value.
    ///
    /// The caller is responsible for ensuring the variant holds an `int64`.
    public var int64Value: Int64 {
        Int64(g_variant_get_int64(pointer))
    }

    /// The double-precision floating point value.
    ///
    /// The caller is responsible for ensuring the variant holds a `double`.
    public var doubleValue: Double {
        g_variant_get_double(pointer)
    }

    /// The boolean value.
    ///
    /// The caller is responsible for ensuring the variant holds a `boolean`.
    public var boolValue: Bool {
        g_variant_get_boolean(pointer) != 0
    }

    /// The GVariant type string (e.g. `"s"`, `"i"`, `"b"`, `"d"`).
    public var typeString: String {
        String(cString: g_variant_get_type_string(pointer))
    }
}
