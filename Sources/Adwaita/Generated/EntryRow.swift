// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A [class@Gtk.ListBoxRow] with an embedded text entry.
/// - Since: libadwaita 1.2
@MainActor
public class EntryRow: PreferencesRow {
    override public class var gtkType: GType {
        adw_entry_row_get_type()
    }

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `EntryRow`.
    override public init() {
        let ptr = adw_entry_row_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates an `EntryRow` with a title.
    public convenience init(title: String) {
        self.init()
        self.title = title
    }

    /// Creates an `EntryRow` with a title and initial text.
    public convenience init(title: String, text: String) {
        self.init()
        self.title = title
        self.text = text
    }

    /// Whether pressing Enter activates the default widget of the window.
    /// - Since: libadwaita 1.2
    public var activatesDefault: Bool {
        get { adw_entry_row_get_activates_default(castedPointer() as UnsafeMutablePointer<AdwEntryRow>) != 0 }
        set {
            adw_entry_row_set_activates_default(castedPointer() as UnsafeMutablePointer<AdwEntryRow>, newValue ? 1 : 0)
        }
    }

    /// Text attributes for styling the entry text (bold, italic, color, etc.).
    /// - Since: libadwaita 1.2
    public var textAttributes: TextAttributes? {
        get {
            guard let ptr = adw_entry_row_get_attributes(castedPointer() as UnsafeMutablePointer<AdwEntryRow>) else { return nil }
            return TextAttributes(borrowing: ptr)
        }
        set { adw_entry_row_set_attributes(castedPointer() as UnsafeMutablePointer<AdwEntryRow>, newValue?.pointer) }
    }

    /// Whether the emoji completion popup is shown when typing emoji shortcodes.
    /// - Since: libadwaita 1.2
    public var enableEmojiCompletion: Bool {
        get { adw_entry_row_get_enable_emoji_completion(castedPointer() as UnsafeMutablePointer<AdwEntryRow>) != 0 }
        set { adw_entry_row_set_enable_emoji_completion(
            castedPointer() as UnsafeMutablePointer<AdwEntryRow>,
            newValue ? 1 : 0
        ) }
    }

    /// Hints for the input method about expected content, such as auto-capitalization or no-spellcheck.
    /// - Since: libadwaita 1.2
    public var inputHints: GtkInputHints {
        get { adw_entry_row_get_input_hints(castedPointer() as UnsafeMutablePointer<AdwEntryRow>) }
        set { adw_entry_row_set_input_hints(castedPointer() as UnsafeMutablePointer<AdwEntryRow>, newValue) }
    }

    /// The purpose of the entry (e.g., free-form text, number, email, password), which may affect the on-screen
    /// keyboard layout.
    /// - Since: libadwaita 1.2
    public var inputPurpose: GtkInputPurpose {
        get { adw_entry_row_get_input_purpose(castedPointer() as UnsafeMutablePointer<AdwEntryRow>) }
        set { adw_entry_row_set_input_purpose(castedPointer() as UnsafeMutablePointer<AdwEntryRow>, newValue) }
    }

    /// The maximum number of characters allowed in the entry. Zero means no limit.
    ///
    /// - Note: Requires libadwaita 1.6+. Returns `nil` / does nothing on older versions.
    /// - Since: libadwaita 1.6
    public var maxLength: Int? {
        get {
            guard AdwaitaVersion.isAtLeast(1, 6) else { return nil }
            return Int(cadw_entry_row_get_max_length(pointer))
        }
        set {
            guard AdwaitaVersion.isAtLeast(1, 6), let newValue else { return }
            cadw_entry_row_set_max_length(pointer, Int32(newValue))
        }
    }

    /// Whether to display an apply button that must be clicked to confirm changes.
    /// - Since: libadwaita 1.2
    public var showApplyButton: Bool {
        get { adw_entry_row_get_show_apply_button(castedPointer() as UnsafeMutablePointer<AdwEntryRow>) != 0 }
        set {
            adw_entry_row_set_show_apply_button(castedPointer() as UnsafeMutablePointer<AdwEntryRow>, newValue ? 1 : 0)
        }
    }

    /// The number of characters currently in the entry (read-only).
    /// - Since: libadwaita 1.5
    public var textLength: Int {
        Int(adw_entry_row_get_text_length(castedPointer() as UnsafeMutablePointer<AdwEntryRow>))
    }

    /// Adds a widget to the start (leading side) of the entry row.
    ///
    /// - Parameter widget: The widget to add as a prefix.
    public func addPrefix(_ widget: Widget) {
        adw_entry_row_add_prefix(castedPointer() as UnsafeMutablePointer<AdwEntryRow>, widget.widgetPointer)
    }

    /// Adds a widget to the end (trailing side) of the entry row.
    ///
    /// - Parameter widget: The widget to add as a suffix.
    public func addSuffix(_ widget: Widget) {
        adw_entry_row_add_suffix(castedPointer() as UnsafeMutablePointer<AdwEntryRow>, widget.widgetPointer)
    }

    /// Gives keyboard focus to the entry without selecting its text content.
    ///
    /// - Returns: `true` if focus was successfully transferred to the entry.
    public func grabFocusWithoutSelecting() -> Bool {
        adw_entry_row_grab_focus_without_selecting(castedPointer() as UnsafeMutablePointer<AdwEntryRow>) != 0
    }

    /// Removes a previously added prefix or suffix widget from the entry row.
    ///
    /// - Parameter widget: The widget to remove.
    public func remove(_ widget: Widget) {
        adw_entry_row_remove(castedPointer() as UnsafeMutablePointer<AdwEntryRow>, widget.widgetPointer)
    }

    /// Emitted when the user clicks the apply button or presses Enter while ``showApplyButton`` is enabled.
    ///
    /// - Parameter handler: A closure invoked when the apply action is triggered.
    /// - Returns: A signal connection that can be used to disconnect the handler.
    @discardableResult
    public func onApply(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .apply, handler: handler)
    }

    /// Emitted when the user presses Enter in the entry row.
    ///
    /// - Parameter handler: A closure invoked when the entry is activated.
    /// - Returns: A signal connection that can be used to disconnect the handler.
    @discardableResult
    public func onEntryActivated(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .entryActivated, handler: handler)
    }

    /// The text content of the entry.
    public var text: String {
        get { String(cString: gtk_editable_get_text(opaquePointer)) }
        set { gtk_editable_set_text(opaquePointer, newValue) }
    }

    /// Emitted when the text content of the entry changes.
    ///
    /// - Parameter handler: A closure invoked whenever the text is modified.
    /// - Returns: A signal connection that can be used to disconnect the handler.
    @discardableResult
    public func onChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .changed, handler: handler)
    }
}
