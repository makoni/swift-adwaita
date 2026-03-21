// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A helper widget for creating buttons.
@MainActor
public final class ButtonContent: Widget {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ButtonContent`.
    public init() {
        let ptr = adw_button_content_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `can-shrink` property.
    /// - Since: libadwaita 1.4
    public var canShrink: Bool {
        get { adw_button_content_get_can_shrink(opaquePointer) != 0 }
        set { adw_button_content_set_can_shrink(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `icon-name` property.
    public var iconName: String {
        get { String(cString: adw_button_content_get_icon_name(opaquePointer)) }
        set { adw_button_content_set_icon_name(opaquePointer, newValue) }
    }

    /// The `label` property.
    public var label: String {
        get { String(cString: adw_button_content_get_label(opaquePointer)) }
        set { adw_button_content_set_label(opaquePointer, newValue) }
    }

    /// The `use-underline` property.
    public var useUnderline: Bool {
        get { adw_button_content_get_use_underline(opaquePointer) != 0 }
        set { adw_button_content_set_use_underline(opaquePointer, newValue ? 1 : 0) }
    }
}
