// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A widget that displays a keyboard shortcut.
/// - Since: libadwaita 1.8
@MainActor
public final class ShortcutLabel: Widget {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ShortcutLabel`.
    public init(accelerator: String) {
        let ptr = adw_shortcut_label_new(accelerator)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `accelerator` property.
    /// - Since: libadwaita 1.8
    public var accelerator: String {
        get { String(cString: adw_shortcut_label_get_accelerator(opaquePointer)) }
        set { adw_shortcut_label_set_accelerator(opaquePointer, newValue) }
    }

    /// The `disabled-text` property.
    /// - Since: libadwaita 1.8
    public var disabledText: String {
        get { String(cString: adw_shortcut_label_get_disabled_text(opaquePointer)) }
        set { adw_shortcut_label_set_disabled_text(opaquePointer, newValue) }
    }
}
