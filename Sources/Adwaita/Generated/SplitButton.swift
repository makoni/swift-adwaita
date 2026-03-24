// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A combined button and dropdown widget.
@MainActor
public final class SplitButton: Widget {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `SplitButton`.
    public init() {
        let ptr = adw_split_button_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `can-shrink` property.
    /// - Since: libadwaita 1.4
    public var canShrink: Bool {
        get { adw_split_button_get_can_shrink(opaquePointer) != 0 }
        set { adw_split_button_set_can_shrink(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `child` property.
    public var child: Widget? {
        get { (adw_split_button_get_child(opaquePointer)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_split_button_set_child(opaquePointer, newValue?.widgetPointer) }
    }

    /// The `direction` property.
    public var direction: GtkArrowType {
        get { adw_split_button_get_direction(opaquePointer) }
        set { adw_split_button_set_direction(opaquePointer, newValue) }
    }

    /// The `dropdown-tooltip` property.
    /// - Since: libadwaita 1.2
    public var dropdownTooltip: String {
        get { String(cString: adw_split_button_get_dropdown_tooltip(opaquePointer)) }
        set { adw_split_button_set_dropdown_tooltip(opaquePointer, newValue) }
    }

    /// The `icon-name` property.
    public var iconName: String? {
        get { (adw_split_button_get_icon_name(opaquePointer)).map { String(cString: $0) } }
        set { adw_split_button_set_icon_name(opaquePointer, newValue) }
    }

    /// The `label` property.
    public var label: String? {
        get { (adw_split_button_get_label(opaquePointer)).map { String(cString: $0) } }
        set { adw_split_button_set_label(opaquePointer, newValue) }
    }

    /// The `use-underline` property.
    public var useUnderline: Bool {
        get { adw_split_button_get_use_underline(opaquePointer) != 0 }
        set { adw_split_button_set_use_underline(opaquePointer, newValue ? 1 : 0) }
    }

    /// Sets the menu model for the dropdown.
    public func setMenuModel(_ menu: GMenuRef?) {
        adw_split_button_set_menu_model(opaquePointer, menu?.menuModelPointer)
    }

    /// Sets the popover for the dropdown.
    public func setPopover(_ popover: Widget?) {
        if let popover {
            adw_split_button_set_popover(opaquePointer, popover.castedPointer() as UnsafeMutablePointer<GtkPopover>)
        } else {
            adw_split_button_set_popover(opaquePointer, nil)
        }
    }

    /// Calls `adw_split_button_popdown`.
    public func popdown() {
        adw_split_button_popdown(opaquePointer)
    }

    /// Calls `adw_split_button_popup`.
    public func popup() {
        adw_split_button_popup(opaquePointer)
    }

    /// Connects to the `activate` signal.
    @discardableResult
    public func onActivate(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .activate, handler: handler)
    }

    /// Connects to the `clicked` signal.
    @discardableResult
    public func onClicked(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .clicked, handler: handler)
    }
}
