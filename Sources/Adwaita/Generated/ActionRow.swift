// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A list box row with a title, subtitle, and optional prefix/suffix widgets.
///
/// Wraps `AdwActionRow`. The standard row type for GNOME preference panels and
/// list-based UIs. Add prefix widgets (typically icons) and suffix widgets
/// (switches, buttons) to build settings-style layouts.
///
/// ```swift
/// let row = ActionRow(title: "Notifications", subtitle: "Enable push alerts")
///
/// let toggle = Switch()
/// row.addSuffix(toggle)
/// row.activatableWidget = toggle
///
/// listBox.append(row)
/// ```
@MainActor
public class ActionRow: PreferencesRow {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new empty `ActionRow`.
    override public init() {
        let ptr = adw_action_row_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates an `ActionRow` with a title.
    public convenience init(title: String) {
        self.init()
        self.title = title
    }

    /// Creates an `ActionRow` with a title and subtitle.
    public convenience init(title: String, subtitle: String) {
        self.init()
        self.title = title
        self.subtitle = subtitle
    }

    /// The widget activated when the row is tapped (e.g. a switch or button).
    public var activatableWidget: Widget? {
        get {
            adw_action_row_get_activatable_widget(castedPointer() as UnsafeMutablePointer<AdwActionRow>)
                .map { Widget(borrowing: UnsafeMutableRawPointer($0)) }
        }
        set { adw_action_row_set_activatable_widget(
            castedPointer() as UnsafeMutablePointer<AdwActionRow>,
            newValue?.widgetPointer
        ) }
    }

    /// The secondary text displayed below the title.
    public var subtitle: String? {
        get {
            adw_action_row_get_subtitle(castedPointer() as UnsafeMutablePointer<AdwActionRow>)
                .map { String(cString: $0) }
        }
        set { adw_action_row_set_subtitle(castedPointer() as UnsafeMutablePointer<AdwActionRow>, newValue) }
    }

    /// The maximum number of lines for the subtitle (0 for unlimited).
    public var subtitleLines: Int {
        get { Int(adw_action_row_get_subtitle_lines(castedPointer() as UnsafeMutablePointer<AdwActionRow>)) }
        set { adw_action_row_set_subtitle_lines(castedPointer() as UnsafeMutablePointer<AdwActionRow>, Int32(newValue))
        }
    }

    /// Whether the subtitle text can be selected and copied by the user.
    /// - Since: libadwaita 1.3
    public var subtitleSelectable: Bool {
        get { adw_action_row_get_subtitle_selectable(castedPointer() as UnsafeMutablePointer<AdwActionRow>) != 0 }
        set { adw_action_row_set_subtitle_selectable(
            castedPointer() as UnsafeMutablePointer<AdwActionRow>,
            newValue ? 1 : 0
        ) }
    }

    /// The maximum number of lines for the title (0 for unlimited).
    public var titleLines: Int {
        get { Int(adw_action_row_get_title_lines(castedPointer() as UnsafeMutablePointer<AdwActionRow>)) }
        set { adw_action_row_set_title_lines(castedPointer() as UnsafeMutablePointer<AdwActionRow>, Int32(newValue)) }
    }

    /// Activates the row, triggering its activatable widget if set.
    public func activate() {
        adw_action_row_activate(castedPointer() as UnsafeMutablePointer<AdwActionRow>)
    }

    /// Adds a widget to the start of the row (e.g. an icon or image).
    public func addPrefix(_ widget: Widget) {
        adw_action_row_add_prefix(castedPointer() as UnsafeMutablePointer<AdwActionRow>, widget.widgetPointer)
    }

    /// Adds a widget to the end of the row (e.g. a switch or button).
    public func addSuffix(_ widget: Widget) {
        adw_action_row_add_suffix(castedPointer() as UnsafeMutablePointer<AdwActionRow>, widget.widgetPointer)
    }

    /// Removes a prefix or suffix widget from the row.
    public func remove(_ widget: Widget) {
        adw_action_row_remove(castedPointer() as UnsafeMutablePointer<AdwActionRow>, widget.widgetPointer)
    }

    /// Called when the row is activated (tapped or keyboard-triggered).
    @discardableResult
    public func onActivated(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .activated, handler: handler)
    }
}
