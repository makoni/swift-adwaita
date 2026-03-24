// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A widget showing toasts above its content.
@MainActor
public final class ToastOverlay: Widget {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
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

    /// Displays a toast notification.
    ///
    /// This method adds a reference before passing to the C function,
    /// which takes ownership (transfer-full). This ensures the Swift
    /// wrapper and the overlay don't conflict on ownership.
    public func addToast(_ toast: Toast) {
        g_object_ref(toast.pointer)
        adw_toast_overlay_add_toast(opaquePointer, toast.opaquePointer)
    }

    /// Calls `adw_toast_overlay_dismiss_all`.
    public func dismissAll() {
        adw_toast_overlay_dismiss_all(opaquePointer)
    }

    /// Shows a simple toast with the given title.
    public func showToast(_ title: String) {
        let toast = Toast(title: title)
        addToast(toast)
    }

    /// Shows a toast with a button that triggers a handler.
    public func showToast(_ title: String, button: String, handler: @escaping @MainActor () -> Void) {
        let toast = Toast(title: title)
        toast.buttonLabel = button
        toast.onButtonClicked(handler)
        addToast(toast)
    }
}
