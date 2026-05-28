// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

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
    override public class var gtkType: GType {
        gtk_search_entry_get_type()
    }

    /// Creates a new search entry.
    public init() {
        let ptr = gtk_search_entry_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
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

    /// Emitted when the search text changes (fired after typing stops).
    ///
    /// - Parameter handler: Called when the search text changes.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onSearchChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .searchChanged, handler: handler)
    }

    /// Emitted when the user presses Enter.
    ///
    /// - Parameter handler: Called when the search entry is activated.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onActivate(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .activate, handler: handler)
    }

    /// Emitted when the user presses Escape with the search entry focused.
    ///
    /// `GtkSearchEntry` emits `stop-search` and returns `GDK_EVENT_STOP` when
    /// Escape is pressed, consuming the event before any shortcut controllers on
    /// ancestor widgets (such as a parent `Dialog`) can see it.  Connect here to
    /// dismiss a palette or search overlay when the user presses Escape.
    ///
    /// - Parameter handler: Called when the stop-search signal fires.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onStopSearch(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .stopSearch, handler: handler)
    }

    /// Programmatically emits the `search-changed` signal.
    ///
    /// Useful for driving UI from debug helpers or tests without actually
    /// typing into the entry.
    public func emitSearchChanged() {
        g_signal_emit_by_name_no_args(UnsafeMutableRawPointer(opaquePointer), "search-changed")
    }

    /// Programmatically emits the `stop-search` signal.
    ///
    /// Mimics what `GtkSearchEntry` does internally when the user presses
    /// Escape with the entry focused.  Useful in tests to verify that the
    /// owning container (e.g. a command palette) handles this signal to
    /// dismiss itself.
    public func emitStopSearch() {
        g_signal_emit_by_name_no_args(UnsafeMutableRawPointer(opaquePointer), "stop-search")
    }
}
