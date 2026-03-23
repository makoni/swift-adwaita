// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A freeform window.
@MainActor
public class Window: GtkWindow {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `Window`.
    public init() {
        let ptr = adw_window_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `adaptive-preview` property.
    /// - Since: libadwaita 1.7
    public var adaptivePreview: Bool {
        get { adw_window_get_adaptive_preview(castedPointer() as UnsafeMutablePointer<AdwWindow>) != 0 }
        set { adw_window_set_adaptive_preview(castedPointer() as UnsafeMutablePointer<AdwWindow>, newValue ? 1 : 0) }
    }

    /// The `content` property.
    public var content: Widget? {
        get { (adw_window_get_content(castedPointer() as UnsafeMutablePointer<AdwWindow>)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_window_set_content(castedPointer() as UnsafeMutablePointer<AdwWindow>, newValue?.widgetPointer) }
    }

    /// The `current-breakpoint` property (read-only).
    /// - Since: libadwaita 1.4
    public var currentBreakpoint: Breakpoint? {
        (adw_window_get_current_breakpoint(castedPointer() as UnsafeMutablePointer<AdwWindow>)).map { Breakpoint(borrowing: UnsafeMutableRawPointer($0)) }
    }

    /// The `visible-dialog` property (read-only).
    /// - Since: libadwaita 1.5
    public var visibleDialog: Dialog? {
        (adw_window_get_visible_dialog(castedPointer() as UnsafeMutablePointer<AdwWindow>)).map { Dialog(borrowing: UnsafeMutableRawPointer($0)) }
    }

    /// Adds a breakpoint (transfer-full: adds a ref before passing).
    public func addBreakpoint(_ breakpoint: Breakpoint) {
        g_object_ref(breakpoint.pointer)
        adw_window_add_breakpoint(castedPointer() as UnsafeMutablePointer<AdwWindow>, breakpoint.opaquePointer)
    }
}
