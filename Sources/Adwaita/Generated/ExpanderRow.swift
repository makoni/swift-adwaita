// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A [class@Gtk.ListBoxRow] used to reveal widgets.
@MainActor
public class ExpanderRow: PreferencesRow {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ExpanderRow`.
    override public init() {
        let ptr = adw_expander_row_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `enable-expansion` property.
    public var enableExpansion: Bool {
        get { adw_expander_row_get_enable_expansion(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>) != 0 }
        set { adw_expander_row_set_enable_expansion(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>, newValue ? 1 : 0) }
    }

    /// The `expanded` property.
    public var expanded: Bool {
        get { adw_expander_row_get_expanded(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>) != 0 }
        set { adw_expander_row_set_expanded(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>, newValue ? 1 : 0) }
    }

    /// The `show-enable-switch` property.
    public var showEnableSwitch: Bool {
        get { adw_expander_row_get_show_enable_switch(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>) != 0 }
        set { adw_expander_row_set_show_enable_switch(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>, newValue ? 1 : 0) }
    }

    /// The `subtitle` property.
    public var subtitle: String {
        get { String(cString: adw_expander_row_get_subtitle(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>)) }
        set { adw_expander_row_set_subtitle(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>, newValue) }
    }

    /// The `subtitle-lines` property.
    /// - Since: libadwaita 1.3
    public var subtitleLines: Int {
        get { Int(adw_expander_row_get_subtitle_lines(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>)) }
        set { adw_expander_row_set_subtitle_lines(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>, Int32(newValue)) }
    }

    /// The `title-lines` property.
    /// - Since: libadwaita 1.3
    public var titleLines: Int {
        get { Int(adw_expander_row_get_title_lines(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>)) }
        set { adw_expander_row_set_title_lines(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>, Int32(newValue)) }
    }

    /// Calls `adw_expander_row_add_prefix`.
    public func addPrefix(_ widget: Widget) {
        adw_expander_row_add_prefix(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>, widget.widgetPointer)
    }

    /// Calls `adw_expander_row_add_row`.
    public func addRow(_ child: Widget) {
        adw_expander_row_add_row(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>, child.widgetPointer)
    }

    /// Calls `adw_expander_row_add_suffix`.
    public func addSuffix(_ widget: Widget) {
        adw_expander_row_add_suffix(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>, widget.widgetPointer)
    }

    /// Calls `adw_expander_row_remove`.
    public func remove(_ child: Widget) {
        adw_expander_row_remove(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>, child.widgetPointer)
    }
}
