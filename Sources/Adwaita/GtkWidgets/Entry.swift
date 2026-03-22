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
    public var maxLength: Int {
        get { Int(gtk_entry_get_max_length(castedPointer())) }
        set { gtk_entry_set_max_length(castedPointer(), Int32(newValue)) }
    }

    /// Connects to the `activate` signal (user pressed Enter).
    @discardableResult
    public func onActivate(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "activate", handler: handler)
    }

    /// Whether the entry has a visible frame.
    public var hasFrame: Bool {
        get { gtk_entry_get_has_frame(castedPointer()) != 0 }
        set { gtk_entry_set_has_frame(castedPointer(), newValue ? 1 : 0) }
    }

    /// The horizontal alignment of the entry text (0.0 left, 0.5 center, 1.0 right).
    public var alignment: Float {
        get { gtk_entry_get_alignment(castedPointer()) }
        set { gtk_entry_set_alignment(castedPointer(), newValue) }
    }

    /// Whether pressing Enter activates the default widget.
    public var activatesDefault: Bool {
        get { gtk_entry_get_activates_default(castedPointer()) != 0 }
        set { gtk_entry_set_activates_default(castedPointer(), newValue ? 1 : 0) }
    }

    /// The progress fraction shown in the entry (0.0 to 1.0).
    public var progressFraction: Double {
        get { gtk_entry_get_progress_fraction(castedPointer()) }
        set { gtk_entry_set_progress_fraction(castedPointer(), newValue) }
    }

    /// The fraction of total entry width to move the progress bar on each pulse.
    public var progressPulseStep: Double {
        get { gtk_entry_get_progress_pulse_step(castedPointer()) }
        set { gtk_entry_set_progress_pulse_step(castedPointer(), newValue) }
    }

    /// Causes the entry's progress indicator to pulse.
    public func progressPulse() {
        gtk_entry_progress_pulse(castedPointer())
    }

    /// The input purpose hint for on-screen keyboards.
    public var inputPurpose: GtkInputPurpose {
        get { gtk_entry_get_input_purpose(castedPointer()) }
        set { gtk_entry_set_input_purpose(castedPointer(), newValue) }
    }

    /// The input hints for on-screen keyboards.
    public var inputHints: GtkInputHints {
        get { gtk_entry_get_input_hints(castedPointer()) }
        set { gtk_entry_set_input_hints(castedPointer(), newValue) }
    }

    /// Sets the icon for the given position from an icon name.
    public func setIcon(position: GtkEntryIconPosition, iconName: String?) {
        gtk_entry_set_icon_from_icon_name(castedPointer(), position, iconName)
    }

    /// Returns the icon name at the given position.
    public func iconName(at position: GtkEntryIconPosition) -> String? {
        gtk_entry_get_icon_name(castedPointer(), position).map { String(cString: $0) }
    }

    /// Sets the tooltip for the icon at the given position.
    public func setIconTooltip(position: GtkEntryIconPosition, tooltip: String?) {
        gtk_entry_set_icon_tooltip_text(castedPointer(), position, tooltip)
    }

    /// Whether the icon at the given position is activatable.
    public func setIconActivatable(position: GtkEntryIconPosition, activatable: Bool) {
        gtk_entry_set_icon_activatable(castedPointer(), position, activatable ? 1 : 0)
    }

    /// Connects to the `icon-press` signal.
    @discardableResult
    public func onIconPress(_ handler: @escaping @MainActor (GtkEntryIconPosition) -> Void) -> SignalConnection {
        SignalHelper.connectInt(self, signal: "icon-press") { pos in
            handler(GtkEntryIconPosition(UInt32(pos)))
        }
    }

    /// Connects to the `changed` signal on the entry buffer.
    @discardableResult
    public func onChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.onNotify(self, property: "text", handler: handler)
    }
}
