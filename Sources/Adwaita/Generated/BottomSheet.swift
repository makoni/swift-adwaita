// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A bottom sheet with an optional bottom bar.
/// - Since: libadwaita 1.6
@MainActor
public final class BottomSheet: Widget {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `BottomSheet`.
    public init() {
        let ptr = adw_bottom_sheet_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `align` property.
    /// - Since: libadwaita 1.6
    public var align: Float {
        get { adw_bottom_sheet_get_align(opaquePointer) }
        set { adw_bottom_sheet_set_align(opaquePointer, newValue) }
    }

    /// The `bottom-bar` property.
    /// - Since: libadwaita 1.6
    public var bottomBar: Widget? {
        get { (adw_bottom_sheet_get_bottom_bar(opaquePointer)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_bottom_sheet_set_bottom_bar(opaquePointer, newValue?.widgetPointer) }
    }

    /// The `bottom-bar-height` property (read-only).
    /// - Since: libadwaita 1.6
    public var bottomBarHeight: Int32 {
        adw_bottom_sheet_get_bottom_bar_height(opaquePointer)
    }

    /// The `can-close` property.
    /// - Since: libadwaita 1.6
    public var canClose: Bool {
        get { adw_bottom_sheet_get_can_close(opaquePointer) != 0 }
        set { adw_bottom_sheet_set_can_close(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `can-open` property.
    /// - Since: libadwaita 1.6
    public var canOpen: Bool {
        get { adw_bottom_sheet_get_can_open(opaquePointer) != 0 }
        set { adw_bottom_sheet_set_can_open(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `content` property.
    /// - Since: libadwaita 1.6
    public var content: Widget? {
        get { (adw_bottom_sheet_get_content(opaquePointer)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_bottom_sheet_set_content(opaquePointer, newValue?.widgetPointer) }
    }

    /// The `full-width` property.
    /// - Since: libadwaita 1.6
    public var fullWidth: Bool {
        get { adw_bottom_sheet_get_full_width(opaquePointer) != 0 }
        set { adw_bottom_sheet_set_full_width(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `modal` property.
    /// - Since: libadwaita 1.6
    public var modal: Bool {
        get { adw_bottom_sheet_get_modal(opaquePointer) != 0 }
        set { adw_bottom_sheet_set_modal(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `open` property.
    /// - Since: libadwaita 1.6
    public var open: Bool {
        get { adw_bottom_sheet_get_open(opaquePointer) != 0 }
        set { adw_bottom_sheet_set_open(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `reveal-bottom-bar` property.
    /// - Since: libadwaita 1.7
    public var revealBottomBar: Bool {
        get { adw_bottom_sheet_get_reveal_bottom_bar(opaquePointer) != 0 }
        set { adw_bottom_sheet_set_reveal_bottom_bar(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `sheet` property.
    /// - Since: libadwaita 1.6
    public var sheet: Widget? {
        get { (adw_bottom_sheet_get_sheet(opaquePointer)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_bottom_sheet_set_sheet(opaquePointer, newValue?.widgetPointer) }
    }

    /// The `sheet-height` property (read-only).
    /// - Since: libadwaita 1.6
    public var sheetHeight: Int32 {
        adw_bottom_sheet_get_sheet_height(opaquePointer)
    }

    /// The `show-drag-handle` property.
    /// - Since: libadwaita 1.6
    public var showDragHandle: Bool {
        get { adw_bottom_sheet_get_show_drag_handle(opaquePointer) != 0 }
        set { adw_bottom_sheet_set_show_drag_handle(opaquePointer, newValue ? 1 : 0) }
    }

    /// Connects to the `close-attempt` signal.
    @discardableResult
    public func onCloseAttempt(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "close-attempt", handler: handler)
    }
}
