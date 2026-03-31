// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A bottom sheet container that slides up from the bottom edge.
///
/// Wraps `AdwBottomSheet`. Provides a sheet that overlays the main content,
/// optionally with a persistent bottom bar that triggers it. The sheet can be
/// modal (dimming the content behind it) or non-modal, full-width or inset,
/// and can include a drag handle for interactive dismissal.
///
/// ```swift
/// let bottomSheet = BottomSheet()
///
/// // Set the main content
/// bottomSheet.content = mainScrollView
///
/// // Set the sheet content
/// bottomSheet.sheet = detailPanel
///
/// // Optionally add a bottom bar that is visible when the sheet is closed
/// bottomSheet.bottomBar = miniPlayerBar
///
/// // Configure behavior
/// bottomSheet.modal = true
/// bottomSheet.canClose = true
/// bottomSheet.showDragHandle = true
///
/// // Open the sheet programmatically
/// bottomSheet.open = true
///
/// // Handle close attempts (e.g. to save state)
/// bottomSheet.onCloseAttempt {
///     print("User tried to close the sheet")
/// }
/// ```
///
/// Key properties:
/// - ``content``: The main content widget behind the sheet.
/// - ``sheet``: The widget displayed inside the sheet.
/// - ``bottomBar``: An optional bar shown when the sheet is closed.
/// - ``open``: Whether the sheet is currently open.
/// - ``modal``: Whether the sheet dims and blocks the content behind it.
/// - ``canClose`` / ``canOpen``: Whether the user can close or open the sheet.
/// - ``fullWidth``: Whether the sheet spans the full window width.
/// - ``showDragHandle``: Whether a drag handle is shown at the top of the sheet.
/// - ``align``: Horizontal alignment of the sheet (0.0 = left, 1.0 = right).
///
/// - Since: libadwaita 1.6
@MainActor
public final class BottomSheet: Widget {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `BottomSheet`.
    ///
    /// - Note: Requires libadwaita 1.6+. Returns `nil` on older versions.
    public init?() {
        guard AdwaitaVersion.isAtLeast(1, 6) else { return nil }
        let ptr = adw_bottom_sheet_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Horizontal alignment of the sheet within the window, from 0.0 (left) to 1.0 (right).
    /// - Since: libadwaita 1.6
    public var align: Float {
        get { adw_bottom_sheet_get_align(opaquePointer) }
        set { adw_bottom_sheet_set_align(opaquePointer, newValue) }
    }

    /// The widget displayed as a bottom bar when the sheet is closed.
    /// - Since: libadwaita 1.6
    public var bottomBar: Widget? {
        get { adw_bottom_sheet_get_bottom_bar(opaquePointer).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_bottom_sheet_set_bottom_bar(opaquePointer, newValue?.widgetPointer) }
    }

    /// The current height of the bottom bar in pixels (read-only).
    /// - Since: libadwaita 1.6
    public var bottomBarHeight: Int {
        Int(adw_bottom_sheet_get_bottom_bar_height(opaquePointer))
    }

    /// Whether the user can close the sheet by swiping down or clicking outside.
    /// - Since: libadwaita 1.6
    public var canClose: Bool {
        get { adw_bottom_sheet_get_can_close(opaquePointer) != 0 }
        set { adw_bottom_sheet_set_can_close(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the user can open the sheet by interacting with the bottom bar.
    /// - Since: libadwaita 1.6
    public var canOpen: Bool {
        get { adw_bottom_sheet_get_can_open(opaquePointer) != 0 }
        set { adw_bottom_sheet_set_can_open(opaquePointer, newValue ? 1 : 0) }
    }

    /// The main content widget displayed behind the sheet.
    /// - Since: libadwaita 1.6
    public var content: Widget? {
        get { adw_bottom_sheet_get_content(opaquePointer).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_bottom_sheet_set_content(opaquePointer, newValue?.widgetPointer) }
    }

    /// Whether the sheet spans the full width of the window.
    /// - Since: libadwaita 1.6
    public var fullWidth: Bool {
        get { adw_bottom_sheet_get_full_width(opaquePointer) != 0 }
        set { adw_bottom_sheet_set_full_width(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the sheet dims and blocks interaction with the content behind it.
    /// - Since: libadwaita 1.6
    public var modal: Bool {
        get { adw_bottom_sheet_get_modal(opaquePointer) != 0 }
        set { adw_bottom_sheet_set_modal(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the sheet is currently open and visible.
    /// - Since: libadwaita 1.6
    public var open: Bool {
        get { adw_bottom_sheet_get_open(opaquePointer) != 0 }
        set { adw_bottom_sheet_set_open(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the bottom bar is revealed when the sheet is closed.
    /// - Since: libadwaita 1.7
    public var revealBottomBar: Bool {
        get { adw_bottom_sheet_get_reveal_bottom_bar(opaquePointer) != 0 }
        set { adw_bottom_sheet_set_reveal_bottom_bar(opaquePointer, newValue ? 1 : 0) }
    }

    /// The widget displayed inside the sliding sheet.
    /// - Since: libadwaita 1.6
    public var sheet: Widget? {
        get { adw_bottom_sheet_get_sheet(opaquePointer).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_bottom_sheet_set_sheet(opaquePointer, newValue?.widgetPointer) }
    }

    /// The current height of the sheet in pixels (read-only).
    /// - Since: libadwaita 1.6
    public var sheetHeight: Int {
        Int(adw_bottom_sheet_get_sheet_height(opaquePointer))
    }

    /// Whether a drag handle is shown at the top of the sheet for interactive dismissal.
    /// - Since: libadwaita 1.6
    public var showDragHandle: Bool {
        get { adw_bottom_sheet_get_show_drag_handle(opaquePointer) != 0 }
        set { adw_bottom_sheet_set_show_drag_handle(opaquePointer, newValue ? 1 : 0) }
    }

    /// Emitted when the user attempts to close the sheet while ``canClose`` is `false`.
    ///
    /// - Parameter handler: A closure invoked when a close attempt is blocked.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onCloseAttempt(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .closeAttempt, handler: handler)
    }
}
