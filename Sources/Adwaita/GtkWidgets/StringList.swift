import CAdwaita
import GObjectSupport

/// A list model backed by an array of strings.
///
/// Wraps `GtkStringList`. Useful for populating `ComboRow` and other
/// widgets that need a `GListModel` of strings.
@MainActor
public final class StringList: GObjectRef {
    /// Creates a new string list from the given strings.
    public init(_ strings: [String]) {
        let list = gtk_string_list_new(nil)!
        let ptr = UnsafeMutableRawPointer(list)
        let opaque = OpaquePointer(ptr)
        for s in strings {
            gtk_string_list_append(opaque, s)
        }
        super.init(raw: ptr)
    }

    /// Creates an empty string list.
    public init() {
        let ptr = gtk_string_list_new(nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Appends a string to the list.
    public func append(_ string: String) {
        gtk_string_list_append(opaquePointer, string)
    }

    /// Removes the string at the given position.
    public func remove(_ position: UInt32) {
        gtk_string_list_remove(opaquePointer, position)
    }

    /// Returns the string at the given position.
    public func getString(_ position: UInt32) -> String? {
        guard let cStr = gtk_string_list_get_string(opaquePointer, position) else {
            return nil
        }
        return String(cString: cStr)
    }

    /// The number of items in the list.
    public var count: UInt32 {
        g_list_model_get_n_items(OpaquePointer(pointer))
    }

    /// The underlying GListModel pointer for use with ComboRow etc.
    public var listModelPointer: OpaquePointer {
        OpaquePointer(pointer)
    }
}
