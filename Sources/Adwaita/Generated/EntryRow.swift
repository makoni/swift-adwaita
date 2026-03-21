// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A [class@Gtk.ListBoxRow] with an embedded text entry.
/// - Since: libadwaita 1.2
@MainActor
open class EntryRow: PreferencesRow {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `EntryRow`.
    override public init() {
        let ptr = adw_entry_row_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `activates-default` property.
    /// - Since: libadwaita 1.2
    public var activatesDefault: Bool {
        get { adw_entry_row_get_activates_default(castedPointer() as UnsafeMutablePointer<AdwEntryRow>) != 0 }
        set { adw_entry_row_set_activates_default(castedPointer() as UnsafeMutablePointer<AdwEntryRow>, newValue ? 1 : 0) }
    }

    /// The `attributes` property.
    /// - Since: libadwaita 1.2
    public var attributes: OpaquePointer? {
        get { adw_entry_row_get_attributes(castedPointer() as UnsafeMutablePointer<AdwEntryRow>) }
        set { adw_entry_row_set_attributes(castedPointer() as UnsafeMutablePointer<AdwEntryRow>, newValue) }
    }

    /// The `enable-emoji-completion` property.
    /// - Since: libadwaita 1.2
    public var enableEmojiCompletion: Bool {
        get { adw_entry_row_get_enable_emoji_completion(castedPointer() as UnsafeMutablePointer<AdwEntryRow>) != 0 }
        set { adw_entry_row_set_enable_emoji_completion(castedPointer() as UnsafeMutablePointer<AdwEntryRow>, newValue ? 1 : 0) }
    }

    /// The `input-hints` property.
    /// - Since: libadwaita 1.2
    public var inputHints: GtkInputHints {
        get { adw_entry_row_get_input_hints(castedPointer() as UnsafeMutablePointer<AdwEntryRow>) }
        set { adw_entry_row_set_input_hints(castedPointer() as UnsafeMutablePointer<AdwEntryRow>, newValue) }
    }

    /// The `input-purpose` property.
    /// - Since: libadwaita 1.2
    public var inputPurpose: GtkInputPurpose {
        get { adw_entry_row_get_input_purpose(castedPointer() as UnsafeMutablePointer<AdwEntryRow>) }
        set { adw_entry_row_set_input_purpose(castedPointer() as UnsafeMutablePointer<AdwEntryRow>, newValue) }
    }

    /// The `max-length` property.
    /// - Since: libadwaita 1.6
    public var maxLength: Int32 {
        get { adw_entry_row_get_max_length(castedPointer() as UnsafeMutablePointer<AdwEntryRow>) }
        set { adw_entry_row_set_max_length(castedPointer() as UnsafeMutablePointer<AdwEntryRow>, newValue) }
    }

    /// The `show-apply-button` property.
    /// - Since: libadwaita 1.2
    public var showApplyButton: Bool {
        get { adw_entry_row_get_show_apply_button(castedPointer() as UnsafeMutablePointer<AdwEntryRow>) != 0 }
        set { adw_entry_row_set_show_apply_button(castedPointer() as UnsafeMutablePointer<AdwEntryRow>, newValue ? 1 : 0) }
    }

    /// The `text-length` property (read-only).
    /// - Since: libadwaita 1.5
    public var textLength: UInt32 {
        adw_entry_row_get_text_length(castedPointer() as UnsafeMutablePointer<AdwEntryRow>)
    }

    /// Calls `adw_entry_row_add_prefix`.
    public func addPrefix(_ widget: Widget) {
        adw_entry_row_add_prefix(castedPointer() as UnsafeMutablePointer<AdwEntryRow>, widget.widgetPointer)
    }

    /// Calls `adw_entry_row_add_suffix`.
    public func addSuffix(_ widget: Widget) {
        adw_entry_row_add_suffix(castedPointer() as UnsafeMutablePointer<AdwEntryRow>, widget.widgetPointer)
    }

    /// Calls `adw_entry_row_grab_focus_without_selecting`.
    public func grabFocusWithoutSelecting() -> Bool {
        return adw_entry_row_grab_focus_without_selecting(castedPointer() as UnsafeMutablePointer<AdwEntryRow>) != 0
    }

    /// Calls `adw_entry_row_remove`.
    public func remove(_ widget: Widget) {
        adw_entry_row_remove(castedPointer() as UnsafeMutablePointer<AdwEntryRow>, widget.widgetPointer)
    }

    /// Connects to the `apply` signal.
    @discardableResult
    public func onApply(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "apply", handler: handler)
    }

    /// Connects to the `entry-activated` signal.
    @discardableResult
    public func onEntryActivated(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "entry-activated", handler: handler)
    }
}
