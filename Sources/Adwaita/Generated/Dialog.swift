// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// An adaptive dialog container that can display as a sheet or a full window.
///
/// Wraps `AdwDialog`. Provides a generic dialog that adapts its
/// presentation to the available space -- appearing as a centered sheet
/// on large screens and a bottom sheet or full-screen page on small ones.
/// Set ``child`` to the dialog's content and call ``present(_:)`` to show it.
///
/// ```swift
/// let dialog = Dialog()
/// dialog.title = "Preferences"
/// dialog.contentWidth = 400
/// dialog.contentHeight = 300
///
/// let content = PreferencesPage()
/// // ... configure content ...
/// dialog.child = content
///
/// dialog.onClosed {
///     print("Dialog was closed")
/// }
///
/// dialog.present(parentWindow)
/// ```
///
/// Subclasses like ``AlertDialog`` and ``AboutDialog`` build on this
/// base for specialised use cases.
///
/// - Since: libadwaita 1.5
@MainActor
public class Dialog: Widget {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `Dialog`.
    public init() {
        let ptr = adw_dialog_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Whether the dialog can be closed by the user (e.g. pressing Escape).
    ///
    /// Set to `false` to prevent closing until a condition is met.
    /// - Since: libadwaita 1.5
    public var canClose: Bool {
        get { adw_dialog_get_can_close(castedPointer() as UnsafeMutablePointer<AdwDialog>) != 0 }
        set { adw_dialog_set_can_close(castedPointer() as UnsafeMutablePointer<AdwDialog>, newValue ? 1 : 0) }
    }

    /// The content widget displayed inside the dialog.
    /// - Since: libadwaita 1.5
    public var child: Widget? {
        get {
            adw_dialog_get_child(castedPointer() as UnsafeMutablePointer<AdwDialog>)
                .map { Widget(borrowing: UnsafeMutableRawPointer($0)) }
        }
        set { adw_dialog_set_child(castedPointer() as UnsafeMutablePointer<AdwDialog>, newValue?.widgetPointer) }
    }

    /// The preferred height of the dialog content, in pixels.
    /// - Since: libadwaita 1.5
    public var contentHeight: Int {
        get { Int(adw_dialog_get_content_height(castedPointer() as UnsafeMutablePointer<AdwDialog>)) }
        set { adw_dialog_set_content_height(castedPointer() as UnsafeMutablePointer<AdwDialog>, Int32(newValue)) }
    }

    /// The preferred width of the dialog content, in pixels.
    /// - Since: libadwaita 1.5
    public var contentWidth: Int {
        get { Int(adw_dialog_get_content_width(castedPointer() as UnsafeMutablePointer<AdwDialog>)) }
        set { adw_dialog_set_content_width(castedPointer() as UnsafeMutablePointer<AdwDialog>, Int32(newValue)) }
    }

    /// The currently active breakpoint, or `nil` if none apply (read-only).
    /// - Since: libadwaita 1.5
    public var currentBreakpoint: Breakpoint? {
        adw_dialog_get_current_breakpoint(castedPointer() as UnsafeMutablePointer<AdwDialog>)
            .map { Breakpoint(borrowing: UnsafeMutableRawPointer($0)) }
    }

    /// The widget activated when the user presses Enter.
    /// - Since: libadwaita 1.5
    public var defaultWidget: Widget? {
        get {
            adw_dialog_get_default_widget(castedPointer() as UnsafeMutablePointer<AdwDialog>)
                .map { Widget(borrowing: UnsafeMutableRawPointer($0)) }
        }
        set {
            adw_dialog_set_default_widget(castedPointer() as UnsafeMutablePointer<AdwDialog>, newValue?.widgetPointer)
        }
    }

    /// The widget that currently has keyboard focus within the dialog.
    /// - Since: libadwaita 1.5
    public var focusWidget: Widget? {
        get {
            adw_dialog_get_focus(castedPointer() as UnsafeMutablePointer<AdwDialog>)
                .map { Widget(borrowing: UnsafeMutableRawPointer($0)) }
        }
        set { adw_dialog_set_focus(castedPointer() as UnsafeMutablePointer<AdwDialog>, newValue?.widgetPointer) }
    }

    /// Whether the dialog resizes to match its content's natural size.
    /// - Since: libadwaita 1.5
    public var followsContentSize: Bool {
        get { adw_dialog_get_follows_content_size(castedPointer() as UnsafeMutablePointer<AdwDialog>) != 0 }
        set { adw_dialog_set_follows_content_size(castedPointer() as UnsafeMutablePointer<AdwDialog>, newValue ? 1 : 0)
        }
    }

    /// How the dialog is presented (auto, floating, or bottom sheet).
    /// - Since: libadwaita 1.5
    public var presentationMode: AdwDialogPresentationMode {
        get { adw_dialog_get_presentation_mode(castedPointer() as UnsafeMutablePointer<AdwDialog>) }
        set { adw_dialog_set_presentation_mode(castedPointer() as UnsafeMutablePointer<AdwDialog>, newValue) }
    }

    /// The title displayed in the dialog's header.
    /// - Since: libadwaita 1.5
    public var title: String {
        get { String(cString: adw_dialog_get_title(castedPointer() as UnsafeMutablePointer<AdwDialog>)) }
        set { adw_dialog_set_title(castedPointer() as UnsafeMutablePointer<AdwDialog>, newValue) }
    }

    /// Adds a responsive breakpoint to the dialog.
    ///
    /// Breakpoints allow the dialog layout to adapt when its size changes.
    ///
    /// - Parameter breakpoint: The breakpoint to add.
    public func addBreakpoint(_ breakpoint: Breakpoint) {
        g_object_ref(breakpoint.pointer)
        adw_dialog_add_breakpoint(castedPointer() as UnsafeMutablePointer<AdwDialog>, breakpoint.opaquePointer)
    }

    /// Attempts to close the dialog.
    ///
    /// If ``canClose`` is `false`, the close is blocked and ``onCloseAttempt(_:)``
    /// is emitted instead.
    ///
    /// - Returns: `true` if the dialog was closed, `false` if prevented.
    public func close() -> Bool {
        adw_dialog_close(castedPointer() as UnsafeMutablePointer<AdwDialog>) != 0
    }

    /// Closes the dialog unconditionally, ignoring ``canClose``.
    public func forceClose() {
        adw_dialog_force_close(castedPointer() as UnsafeMutablePointer<AdwDialog>)
    }

    /// Presents the dialog relative to a parent widget.
    ///
    /// - Parameter parent: The widget the dialog is presented from, or `nil`.
    public func present(_ parent: Widget?) {
        adw_dialog_present(castedPointer() as UnsafeMutablePointer<AdwDialog>, parent?.widgetPointer)
    }

    /// Emitted when the user tries to close the dialog while ``canClose`` is `false`.
    ///
    /// - Parameter handler: Called when a close attempt is blocked.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onCloseAttempt(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .closeAttempt, handler: handler)
    }

    /// Emitted after the dialog has been closed.
    ///
    /// - Parameter handler: Called when the dialog finishes closing.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onClosed(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .closed, handler: handler)
    }
}
