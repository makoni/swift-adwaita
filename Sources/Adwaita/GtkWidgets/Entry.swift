import CAdwaita
import GObjectSupport

/// A single-line text input widget.
///
/// `Entry` provides a text field where the user can type a single line
/// of text. It supports placeholder text, password masking, icons, and
/// input validation hints for on-screen keyboards.
///
/// For Adwaita-styled text entries inside lists, prefer ``EntryRow``.
///
/// Wraps [GtkEntry](https://docs.gtk.org/gtk4/class.Entry.html).
///
/// ## Examples
///
/// A text field with placeholder text:
/// ```swift
/// let nameField = Entry(placeholder: "Enter your name")
/// nameField.onActivate {
///     print("Submitted: \(nameField.text)")
/// }
/// ```
///
/// A password field:
/// ```swift
/// let passwordField = Entry(placeholder: "Password")
/// passwordField.visibility = false
/// passwordField.inputPurpose = GTK_INPUT_PURPOSE_PASSWORD
/// ```
///
/// An entry with a search icon and change handler:
/// ```swift
/// let search = Entry(placeholder: "Search...") {
///     print("Text changed")
/// }
/// search.setIcon(position: GTK_ENTRY_ICON_PRIMARY, iconName: "edit-find-symbolic")
/// ```
@MainActor
public final class Entry: Widget {
    /// Creates a new entry.
    public init() {
        let ptr = gtk_entry_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates an entry with placeholder text and an optional change handler.
    public convenience init(placeholder: String, onChanged handler: (@MainActor () -> Void)? = nil) {
        self.init()
        placeholderText = placeholder
        if let handler { onChanged(handler) }
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The text contents of the entry.
    ///
    /// Read this property to get the current user input. Set it to
    /// programmatically change the displayed text.
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

    /// Whether the entry text is visible.
    ///
    /// Set to `false` to mask the text with dots, suitable for password fields.
    public var visibility: Bool {
        get { gtk_entry_get_visibility(castedPointer()) != 0 }
        set { gtk_entry_set_visibility(castedPointer(), newValue ? 1 : 0) }
    }

    /// The maximum length of the entry text (0 for no limit).
    public var maxLength: Int {
        get { Int(gtk_entry_get_max_length(castedPointer())) }
        set { gtk_entry_set_max_length(castedPointer(), Int32(newValue)) }
    }

    /// Emitted when the user presses Enter.
    ///
    /// Use this to submit a form or trigger an action when the user confirms input.
    ///
    /// - Parameter handler: Called when the entry is activated.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onActivate(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .activate, handler: handler)
    }

    /// Whether the entry has a visible frame.
    public var hasFrame: Bool {
        get { gtk_entry_get_has_frame(castedPointer()) != 0 }
        set { gtk_entry_set_has_frame(castedPointer(), newValue ? 1 : 0) }
    }

    /// The horizontal alignment of the text within the entry.
    ///
    /// `0.0` is left-aligned, `0.5` is centered, `1.0` is right-aligned.
    /// Useful for numeric fields where right-alignment is conventional.
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

    /// Emitted when an icon in the entry is clicked.
    ///
    /// - Parameter handler: Called when an icon is pressed. Receives the icon position.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onIconPress(_ handler: @escaping @MainActor (GtkEntryIconPosition) -> Void) -> SignalConnection {
        SignalHelper.connectInt(self, signal: .iconPress) { pos in
            handler(GtkEntryIconPosition(UInt32(pos)))
        }
    }

    /// Emitted when the text changes.
    ///
    /// - Parameter handler: Called when the entry text changes.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.onNotify(self, property: .text, handler: handler)
    }

    // MARK: - Text Selection & Cursor

    /// Selects all text in the entry.
    public func selectAll() {
        gtk_editable_select_region(opaquePointer, 0, -1)
    }

    /// Clears the text selection.
    public func clearSelection() {
        let pos = gtk_editable_get_position(opaquePointer)
        gtk_editable_select_region(opaquePointer, pos, pos)
    }

    /// The cursor position (character offset).
    public var cursorPosition: Int {
        get { Int(gtk_editable_get_position(opaquePointer)) }
        set { gtk_editable_set_position(opaquePointer, Int32(newValue)) }
    }

    /// Whether the entry currently has a text selection.
    public var hasSelection: Bool {
        var start: Int32 = 0
        var end: Int32 = 0
        return gtk_editable_get_selection_bounds(opaquePointer, &start, &end) != 0
    }
}
