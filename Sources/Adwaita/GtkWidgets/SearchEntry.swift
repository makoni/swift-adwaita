import CAdwaita
import GObjectSupport

/// A search entry widget with a search icon and clear button.
///
/// Wraps `GtkSearchEntry`.
@MainActor
public final class SearchEntry: Widget {
    /// Creates a new search entry.
    public init() {
        let ptr = gtk_search_entry_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    override internal init(raw pointer: UnsafeMutableRawPointer) {
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

    /// Connects to the `search-changed` signal (fired after typing stops).
    @discardableResult
    public func onSearchChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "search-changed", handler: handler)
    }

    /// Connects to the `activate` signal (user pressed Enter).
    @discardableResult
    public func onActivate(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "activate", handler: handler)
    }
}
