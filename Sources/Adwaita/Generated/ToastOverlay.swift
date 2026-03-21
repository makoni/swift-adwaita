// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A widget showing toasts above its content.
@MainActor
public final class ToastOverlay: Widget {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ToastOverlay`.
    public init() {
        let ptr = adw_toast_overlay_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `child` property.
    public var child: Widget? {
        get { (adw_toast_overlay_get_child(opaquePointer)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_toast_overlay_set_child(opaquePointer, newValue?.widgetPointer) }
    }

    /// Calls `adw_toast_overlay_add_toast`.
    public func addToast(_ toast: OpaquePointer) {
        adw_toast_overlay_add_toast(opaquePointer, toast)
    }

    /// Calls `adw_toast_overlay_dismiss_all`.
    public func dismissAll() {
        adw_toast_overlay_dismiss_all(opaquePointer)
    }
}
