import CAdwaita
import GObjectSupport

/// A single-line text input widget.
///
/// Wraps `GtkEntry`. For Adwaita-styled text entries, prefer `EntryRow`.
@MainActor
public final class Entry: Widget {
    /// Creates a new entry.
    public init() {
        let ptr = gtk_entry_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The entry's text contents.
    public var text: String {
        get {
            let buf = gtk_entry_get_buffer(castedPointer())
            return String(cString: gtk_entry_buffer_get_text(buf))
        }
        set {
            let buf = gtk_entry_get_buffer(castedPointer())
            gtk_entry_buffer_set_text(buf, newValue, Int32(newValue.utf8.count))
        }
    }

    /// The placeholder text shown when the entry is empty.
    public var placeholderText: String? {
        get {
            guard let cStr = gtk_entry_get_placeholder_text(castedPointer()) else { return nil }
            return String(cString: cStr)
        }
        set { gtk_entry_set_placeholder_text(castedPointer(), newValue) }
    }

    /// Whether the entry text is visible (set to false for passwords).
    public var visibility: Bool {
        get { gtk_entry_get_visibility(castedPointer()) != 0 }
        set { gtk_entry_set_visibility(castedPointer(), newValue ? 1 : 0) }
    }

    /// The maximum length of the entry text (0 for no limit).
    public var maxLength: Int32 {
        get { gtk_entry_get_max_length(castedPointer()) }
        set { gtk_entry_set_max_length(castedPointer(), newValue) }
    }

    /// Connects to the `activate` signal (user pressed Enter).
    @discardableResult
    public func onActivate(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "activate", handler: handler)
    }

    /// Connects to the `changed` signal on the entry buffer.
    @discardableResult
    public func onChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.onNotify(self, property: "text", handler: handler)
    }
}
