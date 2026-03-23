import CAdwaita
import GObjectSupport

/// A toolbar to integrate a search entry with.
///
/// Wraps `GtkSearchBar`. Provides a reveal animation and connects
/// to a `SearchEntry` for keyboard-driven search activation.
@MainActor
public final class SearchBar: Widget {
    /// Creates a new search bar.
    public init() {
        let ptr = gtk_search_bar_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The child widget of the search bar (typically a SearchEntry).
    public var child: Widget? {
        get {
            guard let ptr = gtk_search_bar_get_child(opaquePointer) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set { gtk_search_bar_set_child(opaquePointer, newValue?.widgetPointer) }
    }

    /// Whether the search bar is currently revealed (search mode is on).
    public var searchModeEnabled: Bool {
        get { gtk_search_bar_get_search_mode(opaquePointer) != 0 }
        set { gtk_search_bar_set_search_mode(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the close button is shown.
    public var showCloseButton: Bool {
        get { gtk_search_bar_get_show_close_button(opaquePointer) != 0 }
        set { gtk_search_bar_set_show_close_button(opaquePointer, newValue ? 1 : 0) }
    }

    /// Connects the search bar to an editable widget (typically a SearchEntry).
    /// Key presses on the connected widget will activate the search bar.
    public func connectEntry(_ entry: Widget) {
        gtk_search_bar_connect_entry(opaquePointer, OpaquePointer(entry.pointer))
    }

    /// Sets the key capture widget. Key events on this widget will be
    /// forwarded to the search bar to activate search.
    public func setKeyCaptureWidget(_ widget: Widget?) {
        gtk_search_bar_set_key_capture_widget(opaquePointer, widget?.widgetPointer)
    }
}
