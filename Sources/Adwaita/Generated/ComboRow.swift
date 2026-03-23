// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A [class@Gtk.ListBoxRow] used to choose from a list of items.
@MainActor
public class ComboRow: ActionRow {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ComboRow`.
    override public init() {
        let ptr = adw_combo_row_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `enable-search` property.
    /// - Since: libadwaita 1.4
    public var enableSearch: Bool {
        get { adw_combo_row_get_enable_search(castedPointer() as UnsafeMutablePointer<AdwComboRow>) != 0 }
        set { adw_combo_row_set_enable_search(castedPointer() as UnsafeMutablePointer<AdwComboRow>, newValue ? 1 : 0) }
    }

    /// The `search-match-mode` property.
    /// - Since: libadwaita 1.6
    public var searchMatchMode: GtkStringFilterMatchMode {
        get { adw_combo_row_get_search_match_mode(castedPointer() as UnsafeMutablePointer<AdwComboRow>) }
        set { adw_combo_row_set_search_match_mode(castedPointer() as UnsafeMutablePointer<AdwComboRow>, newValue) }
    }

    /// The `selected` property.
    public var selected: Int {
        get { Int(adw_combo_row_get_selected(castedPointer() as UnsafeMutablePointer<AdwComboRow>)) }
        set { adw_combo_row_set_selected(castedPointer() as UnsafeMutablePointer<AdwComboRow>, UInt32(newValue)) }
    }

    /// The `selected-item` property (read-only).
    public var selectedItem: gpointer {
        adw_combo_row_get_selected_item(castedPointer() as UnsafeMutablePointer<AdwComboRow>)
    }

    /// The `use-subtitle` property.
    public var useSubtitle: Bool {
        get { adw_combo_row_get_use_subtitle(castedPointer() as UnsafeMutablePointer<AdwComboRow>) != 0 }
        set { adw_combo_row_set_use_subtitle(castedPointer() as UnsafeMutablePointer<AdwComboRow>, newValue ? 1 : 0) }
    }

    /// The `model` property.
    public var model: OpaquePointer? {
        get { adw_combo_row_get_model(castedPointer() as UnsafeMutablePointer<AdwComboRow>) }
        set { adw_combo_row_set_model(castedPointer() as UnsafeMutablePointer<AdwComboRow>, newValue) }
    }

    /// Sets a `StringList` as the model for this combo row.
    public func setModel(_ stringList: StringList) {
        adw_combo_row_set_model(castedPointer() as UnsafeMutablePointer<AdwComboRow>, stringList.listModelPointer)
    }
}
