// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// an action row
@MainActor
public class ActionRow: PreferencesRow {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ActionRow`.
    override public init() {
        let ptr = adw_action_row_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `activatable-widget` property.
    public var activatableWidget: Widget? {
        get { (adw_action_row_get_activatable_widget(castedPointer() as UnsafeMutablePointer<AdwActionRow>)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_action_row_set_activatable_widget(castedPointer() as UnsafeMutablePointer<AdwActionRow>, newValue?.widgetPointer) }
    }

    /// The `subtitle` property.
    public var subtitle: String? {
        get { (adw_action_row_get_subtitle(castedPointer() as UnsafeMutablePointer<AdwActionRow>)).map { String(cString: $0) } }
        set { adw_action_row_set_subtitle(castedPointer() as UnsafeMutablePointer<AdwActionRow>, newValue) }
    }

    /// The `subtitle-lines` property.
    public var subtitleLines: Int {
        get { Int(adw_action_row_get_subtitle_lines(castedPointer() as UnsafeMutablePointer<AdwActionRow>)) }
        set { adw_action_row_set_subtitle_lines(castedPointer() as UnsafeMutablePointer<AdwActionRow>, Int32(newValue)) }
    }

    /// The `subtitle-selectable` property.
    /// - Since: libadwaita 1.3
    public var subtitleSelectable: Bool {
        get { adw_action_row_get_subtitle_selectable(castedPointer() as UnsafeMutablePointer<AdwActionRow>) != 0 }
        set { adw_action_row_set_subtitle_selectable(castedPointer() as UnsafeMutablePointer<AdwActionRow>, newValue ? 1 : 0) }
    }

    /// The `title-lines` property.
    public var titleLines: Int {
        get { Int(adw_action_row_get_title_lines(castedPointer() as UnsafeMutablePointer<AdwActionRow>)) }
        set { adw_action_row_set_title_lines(castedPointer() as UnsafeMutablePointer<AdwActionRow>, Int32(newValue)) }
    }

    /// Calls `adw_action_row_activate`.
    public func activate() {
        adw_action_row_activate(castedPointer() as UnsafeMutablePointer<AdwActionRow>)
    }

    /// Calls `adw_action_row_add_prefix`.
    public func addPrefix(_ widget: Widget) {
        adw_action_row_add_prefix(castedPointer() as UnsafeMutablePointer<AdwActionRow>, widget.widgetPointer)
    }

    /// Calls `adw_action_row_add_suffix`.
    public func addSuffix(_ widget: Widget) {
        adw_action_row_add_suffix(castedPointer() as UnsafeMutablePointer<AdwActionRow>, widget.widgetPointer)
    }

    /// Calls `adw_action_row_remove`.
    public func remove(_ widget: Widget) {
        adw_action_row_remove(castedPointer() as UnsafeMutablePointer<AdwActionRow>, widget.widgetPointer)
    }

    /// Connects to the `activated` signal.
    @discardableResult
    public func onActivated(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "activated", handler: handler)
    }
}
