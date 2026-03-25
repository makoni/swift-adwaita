import CAdwaita
import GObjectSupport

/// A search entry widget with a search icon and clear button.
///
/// Wraps `GtkSearchEntry`. Includes a built-in search icon, a clear button,
/// and a debounced ``onSearchChanged(_:)`` signal that fires after the user
/// stops typing.
///
/// ```swift
/// let search = SearchEntry()
/// search.placeholderText = "Search items..."
/// search.searchDelay = 300  // milliseconds
///
/// search.onSearchChanged {
///     print("Searching for: \(search.text)")
/// }
///
/// search.onActivate {
///     print("User pressed Enter with: \(search.text)")
/// }
/// ```
@MainActor
public final class SearchEntry: Widget {
    /// Creates a new search entry.
    public init() {
        let ptr = gtk_search_entry_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The search text.
    public var text: String {
        get { String(cString: gtk_editable_get_text(opaquePointer)) }
        set { gtk_editable_set_text(opaquePointer, newValue) }
    }

    /// The placeholder text.
    public var placeholderText: String? {
        get {
            guard let cStr = gtk_search_entry_get_placeholder_text(opaquePointer) else { return nil }
            return String(cString: cStr)
        }
        set { gtk_search_entry_set_placeholder_text(opaquePointer, newValue) }
    }

    /// The delay in milliseconds between the last keystroke and the search-changed signal.
    public var searchDelay: Int {
        get { Int(gtk_search_entry_get_search_delay(opaquePointer)) }
        set { gtk_search_entry_set_search_delay(opaquePointer, UInt32(newValue)) }
    }

    /// Connects to the `search-changed` signal (fired after typing stops).
    @discardableResult
    public func onSearchChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .searchChanged, handler: handler)
    }

    /// Connects to the `activate` signal (user pressed Enter).
    @discardableResult
    public func onActivate(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .activate, handler: handler)
    }
}
