// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A button split into a main action and a dropdown menu.
///
/// Wraps `AdwSplitButton`. The primary area triggers the main action, while
/// the arrow area opens a dropdown menu or popover with additional options.
/// Common in toolbars for actions like "Save" with a "Save As..." dropdown.
///
/// ```swift
/// let splitButton = SplitButton()
/// splitButton.label = "Open"
/// splitButton.iconName = "document-open-symbolic"
///
/// // Attach a menu model for the dropdown
/// splitButton.setMenuModel(menuModel)
///
/// splitButton.onClicked {
///     print("Primary action triggered")
/// }
///
/// headerBar.packStart(splitButton)
/// ```
///
/// - Key properties:
///   - ``label``: The text label on the primary button.
///   - ``iconName``: The icon displayed on the primary button.
///   - ``direction``: The arrow direction for the dropdown indicator.
///   - ``dropdownTooltip``: Tooltip text for the dropdown arrow (since libadwaita 1.2).
///   - ``child``: A custom child widget replacing the default label/icon.
/// - Key methods:
///   - ``setMenuModel(_:)``: Sets the `GMenuModel` for the dropdown.
///   - ``setPopover(_:)``: Sets a custom popover for the dropdown.
///   - ``onClicked(_:)``: Connects a handler for the primary button click.
///   - ``onActivate(_:)``: Connects a handler for keyboard activation.
@MainActor
public final class SplitButton: Widget {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `SplitButton`.
    public init() {
        let ptr = adw_split_button_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Whether the button can be smaller than its natural size, ellipsizing its label if needed.
    /// - Since: libadwaita 1.4
    public var canShrink: Bool {
        get { adw_split_button_get_can_shrink(opaquePointer) != 0 }
        set { adw_split_button_set_can_shrink(opaquePointer, newValue ? 1 : 0) }
    }

    /// A custom child widget displayed in the primary button area, replacing the default label or icon.
    public var child: Widget? {
        get { adw_split_button_get_child(opaquePointer).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_split_button_set_child(opaquePointer, newValue?.widgetPointer) }
    }

    /// The arrow direction of the dropdown indicator (e.g., down, up, left, right).
    public var direction: GtkArrowType {
        get { adw_split_button_get_direction(opaquePointer) }
        set { adw_split_button_set_direction(opaquePointer, newValue) }
    }

    /// The tooltip text displayed when hovering over the dropdown arrow area.
    /// - Since: libadwaita 1.2
    public var dropdownTooltip: String {
        get { String(cString: adw_split_button_get_dropdown_tooltip(opaquePointer)) }
        set { adw_split_button_set_dropdown_tooltip(opaquePointer, newValue) }
    }

    /// The name of the icon displayed on the primary button area.
    public var iconName: String? {
        get { adw_split_button_get_icon_name(opaquePointer).map { String(cString: $0) } }
        set { adw_split_button_set_icon_name(opaquePointer, newValue) }
    }

    /// The text label displayed on the primary button area.
    public var label: String? {
        get { adw_split_button_get_label(opaquePointer).map { String(cString: $0) } }
        set { adw_split_button_set_label(opaquePointer, newValue) }
    }

    /// Whether an underscore in the label indicates a mnemonic accelerator.
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

    /// Dismisses the dropdown menu or popover.
    public func popdown() {
        adw_split_button_popdown(opaquePointer)
    }

    /// Opens the dropdown menu or popover programmatically.
    public func popup() {
        adw_split_button_popup(opaquePointer)
    }

    /// Emitted when the button is activated via keyboard (e.g., pressing Enter or Space).
    ///
    /// - Parameter handler: A closure invoked when the button is keyboard-activated.
    /// - Returns: A signal connection that can be used to disconnect the handler.
    @discardableResult
    public func onActivate(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .activate, handler: handler)
    }

    /// Emitted when the primary button area is clicked.
    ///
    /// - Parameter handler: A closure invoked when the primary button is clicked.
    /// - Returns: A signal connection that can be used to disconnect the handler.
    @discardableResult
    public func onClicked(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .clicked, handler: handler)
    }
}
