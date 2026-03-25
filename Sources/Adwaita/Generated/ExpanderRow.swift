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

    /// Creates an `ExpanderRow` with a title.
    public convenience init(title: String) {
        self.init()
        self.title = title
    }

    /// Creates an `ExpanderRow` with a title and subtitle.
    public convenience init(title: String, subtitle: String) {
        self.init()
        self.title = title
        self.subtitle = subtitle
    }

    /// Creates an `ExpanderRow` with a title, subtitle, and expansion state.
    public convenience init(title: String, subtitle: String, expanded: Bool) {
        self.init()
        self.title = title
        self.subtitle = subtitle
        self.expanded = expanded
    }

    /// Whether the row can be expanded by the user.
    public var enableExpansion: Bool {
        get { adw_expander_row_get_enable_expansion(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>) != 0 }
        set { adw_expander_row_set_enable_expansion(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>, newValue ? 1 : 0) }
    }

    /// Whether the row is currently expanded, revealing its child rows.
    public var expanded: Bool {
        get { adw_expander_row_get_expanded(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>) != 0 }
        set { adw_expander_row_set_expanded(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>, newValue ? 1 : 0) }
    }

    /// Whether to show a switch that allows the user to enable or disable the expansion.
    public var showEnableSwitch: Bool {
        get { adw_expander_row_get_show_enable_switch(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>) != 0 }
        set { adw_expander_row_set_show_enable_switch(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>, newValue ? 1 : 0) }
    }

    /// The secondary text displayed below the title.
    public var subtitle: String {
        get { String(cString: adw_expander_row_get_subtitle(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>)) }
        set { adw_expander_row_set_subtitle(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>, newValue) }
    }

    /// The maximum number of lines for the subtitle (0 for unlimited).
    /// - Since: libadwaita 1.3
    public var subtitleLines: Int {
        get { Int(adw_expander_row_get_subtitle_lines(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>)) }
        set { adw_expander_row_set_subtitle_lines(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>, Int32(newValue)) }
    }

    /// The maximum number of lines for the title (0 for unlimited).
    /// - Since: libadwaita 1.3
    public var titleLines: Int {
        get { Int(adw_expander_row_get_title_lines(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>)) }
        set { adw_expander_row_set_title_lines(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>, Int32(newValue)) }
    }

    /// Adds a widget before the title in the row (e.g. an icon or image).
    ///
    /// - Parameter widget: The widget to add as a prefix.
    public func addPrefix(_ widget: Widget) {
        adw_expander_row_add_prefix(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>, widget.widgetPointer)
    }

    /// Adds a child row that is revealed when the expander row is expanded.
    ///
    /// - Parameter child: The widget to add as a nested row.
    public func addRow(_ child: Widget) {
        adw_expander_row_add_row(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>, child.widgetPointer)
    }

    /// Adds a widget after the title in the row (e.g. a switch or button).
    ///
    /// - Parameter widget: The widget to add as a suffix.
    public func addSuffix(_ widget: Widget) {
        adw_expander_row_add_suffix(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>, widget.widgetPointer)
    }

    /// Removes a previously added child, prefix, or suffix widget from the row.
    ///
    /// - Parameter child: The widget to remove.
    public func remove(_ child: Widget) {
        adw_expander_row_remove(castedPointer() as UnsafeMutablePointer<AdwExpanderRow>, child.widgetPointer)
    }
}
