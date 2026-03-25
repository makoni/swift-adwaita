import CAdwaita
import GObjectSupport

/// A list model backed by an array of strings.
///
/// Wraps `GtkStringList`. Useful for populating `ComboRow` and other
/// widgets that need a `GListModel` of strings.
///
/// ```swift
/// let model = StringList(["Apple", "Banana", "Cherry"])
/// model.append("Date")
/// model.remove(1)  // removes "Banana"
///
/// print(model.count)            // 3
/// print(model.getString(0)!)    // "Apple"
/// print(model.allStrings)       // ["Apple", "Cherry", "Date"]
/// ```
@MainActor
public final class StringList: GObjectRef, ListModelConvertible {
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

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Appends a string to the list.
    public func append(_ string: String) {
        gtk_string_list_append(opaquePointer, string)
    }

    /// Removes the string at the given position.
    public func remove(_ position: Int) {
        gtk_string_list_remove(opaquePointer, UInt32(position))
    }

    /// Returns the string at the given position.
    public func getString(_ position: Int) -> String? {
        guard let cStr = gtk_string_list_get_string(opaquePointer, UInt32(position)) else {
            return nil
        }
        return String(cString: cStr)
    }

    /// The number of items in the list.
    public var count: Int {
        Int(g_list_model_get_n_items(OpaquePointer(pointer)))
    }

    /// Removes all strings from the list.
    public func removeAll() {
        let n = UInt32(count)
        if n > 0 {
            gtk_string_list_splice(opaquePointer, 0, n, nil)
        }
    }

    /// Whether the list contains the given string.
    public func contains(_ string: String) -> Bool {
        for i in 0..<count {
            if getString(i) == string { return true }
        }
        return false
    }

    /// Returns the index of the first occurrence of the given string, or nil.
    public func indexOf(_ string: String) -> Int? {
        for i in 0..<count {
            if getString(i) == string { return i }
        }
        return nil
    }

    /// Replaces all strings in the list.
    public func replaceAll(_ strings: [String]) {
        removeAll()
        for s in strings { append(s) }
    }

    /// Returns all strings as an array.
    public var allStrings: [String] {
        (0..<count).compactMap { getString($0) }
    }
}
