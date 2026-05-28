// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A container widget that displays ``Toast`` notifications above its content.
///
/// Wraps `AdwToastOverlay`. Place this as a wrapper around your main
/// content so that toasts slide in from the bottom edge. Multiple
/// toasts are queued and shown one at a time.
///
/// ```swift
/// let overlay = ToastOverlay()
/// overlay.child = myContentWidget
///
/// // Show a simple text toast
/// overlay.showToast("Download complete")
///
/// // Show a toast with an action button
/// overlay.showToast("Item deleted", button: "Undo") {
///     // restore the item
/// }
///
/// // Or build a Toast manually for full control
/// let toast = Toast(title: "Custom toast")
/// toast.timeout = 5
/// toast.priority = ADW_TOAST_PRIORITY_HIGH
/// overlay.addToast(toast)
/// ```
@MainActor
public final class ToastOverlay: Widget {
    override public class var gtkType: GType {
        adw_toast_overlay_get_type()
    }


    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ToastOverlay`.
    public init() {
        let ptr = adw_toast_overlay_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The main content widget displayed beneath the toast area.
    public var child: Widget? {
        get { adw_toast_overlay_get_child(opaquePointer).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
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

    /// Dismisses all currently displayed and queued toasts immediately.
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
