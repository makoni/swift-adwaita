// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// An Adwaita application window with adaptive layout support.
///
/// Wraps `AdwWindow`. Extends ``GtkWindow`` with Adwaita features such
/// as adaptive breakpoints and dialog management. Set the ``content``
/// property to your top-level layout (typically a ``ToolbarView`` with
/// a ``HeaderBar``).
///
/// ```swift
/// let window = Window()
/// window.title = "My App"
/// window.defaultWidth = 800
/// window.defaultHeight = 600
///
/// let header = HeaderBar(title: "My App")
/// let toolbar = ToolbarView()
/// toolbar.topBar = header
/// toolbar.content = myMainContent
///
/// window.content = toolbar
/// window.present()
/// ```
///
/// Use ``addBreakpoint(_:)`` to adapt the layout at different window sizes.
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

    /// Whether the adaptive preview mode is enabled, allowing interactive testing of breakpoints at different window sizes.
    /// - Since: libadwaita 1.7
    public var adaptivePreview: Bool {
        get { adw_window_get_adaptive_preview(castedPointer() as UnsafeMutablePointer<AdwWindow>) != 0 }
        set { adw_window_set_adaptive_preview(castedPointer() as UnsafeMutablePointer<AdwWindow>, newValue ? 1 : 0) }
    }

    /// The top-level content widget displayed inside the window.
    public var content: Widget? {
        get { (adw_window_get_content(castedPointer() as UnsafeMutablePointer<AdwWindow>)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_window_set_content(castedPointer() as UnsafeMutablePointer<AdwWindow>, newValue?.widgetPointer) }
    }

    /// The breakpoint currently applied to this window based on its size, or `nil` if none match (read-only).
    /// - Since: libadwaita 1.4
    public var currentBreakpoint: Breakpoint? {
        (adw_window_get_current_breakpoint(castedPointer() as UnsafeMutablePointer<AdwWindow>)).map { Breakpoint(borrowing: UnsafeMutableRawPointer($0)) }
    }

    /// The currently visible dialog presented in this window, or `nil` if no dialog is shown (read-only).
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
