// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// An adaptive dialog container.
/// - Since: libadwaita 1.5
@MainActor
open class Dialog: Widget {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Borrows a reference to an existing Dialog.
    override internal init(borrowing pointer: UnsafeMutableRawPointer) {
        super.init(borrowing: pointer)
    }

    /// Creates a new `Dialog`.
    public init() {
        let ptr = adw_dialog_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `can-close` property.
    /// - Since: libadwaita 1.5
    public var canClose: Bool {
        get { adw_dialog_get_can_close(castedPointer() as UnsafeMutablePointer<AdwDialog>) != 0 }
        set { adw_dialog_set_can_close(castedPointer() as UnsafeMutablePointer<AdwDialog>, newValue ? 1 : 0) }
    }

    /// The `child` property.
    /// - Since: libadwaita 1.5
    public var child: Widget? {
        get { (adw_dialog_get_child(castedPointer() as UnsafeMutablePointer<AdwDialog>)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_dialog_set_child(castedPointer() as UnsafeMutablePointer<AdwDialog>, newValue?.widgetPointer) }
    }

    /// The `content-height` property.
    /// - Since: libadwaita 1.5
    public var contentHeight: Int {
        get { Int(adw_dialog_get_content_height(castedPointer() as UnsafeMutablePointer<AdwDialog>)) }
        set { adw_dialog_set_content_height(castedPointer() as UnsafeMutablePointer<AdwDialog>, Int32(newValue)) }
    }

    /// The `content-width` property.
    /// - Since: libadwaita 1.5
    public var contentWidth: Int {
        get { Int(adw_dialog_get_content_width(castedPointer() as UnsafeMutablePointer<AdwDialog>)) }
        set { adw_dialog_set_content_width(castedPointer() as UnsafeMutablePointer<AdwDialog>, Int32(newValue)) }
    }

    /// The `current-breakpoint` property (read-only).
    /// - Since: libadwaita 1.5
    public var currentBreakpoint: Breakpoint? {
        (adw_dialog_get_current_breakpoint(castedPointer() as UnsafeMutablePointer<AdwDialog>)).map { Breakpoint(borrowing: UnsafeMutableRawPointer($0)) }
    }

    /// The `default-widget` property.
    /// - Since: libadwaita 1.5
    public var defaultWidget: Widget? {
        get { (adw_dialog_get_default_widget(castedPointer() as UnsafeMutablePointer<AdwDialog>)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_dialog_set_default_widget(castedPointer() as UnsafeMutablePointer<AdwDialog>, newValue?.widgetPointer) }
    }

    /// The `focus-widget` property.
    /// - Since: libadwaita 1.5
    public var focusWidget: Widget? {
        get { (adw_dialog_get_focus(castedPointer() as UnsafeMutablePointer<AdwDialog>)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_dialog_set_focus(castedPointer() as UnsafeMutablePointer<AdwDialog>, newValue?.widgetPointer) }
    }

    /// The `follows-content-size` property.
    /// - Since: libadwaita 1.5
    public var followsContentSize: Bool {
        get { adw_dialog_get_follows_content_size(castedPointer() as UnsafeMutablePointer<AdwDialog>) != 0 }
        set { adw_dialog_set_follows_content_size(castedPointer() as UnsafeMutablePointer<AdwDialog>, newValue ? 1 : 0) }
    }

    /// The `presentation-mode` property.
    /// - Since: libadwaita 1.5
    public var presentationMode: AdwDialogPresentationMode {
        get { adw_dialog_get_presentation_mode(castedPointer() as UnsafeMutablePointer<AdwDialog>) }
        set { adw_dialog_set_presentation_mode(castedPointer() as UnsafeMutablePointer<AdwDialog>, newValue) }
    }

    /// The `title` property.
    /// - Since: libadwaita 1.5
    public var title: String {
        get { String(cString: adw_dialog_get_title(castedPointer() as UnsafeMutablePointer<AdwDialog>)) }
        set { adw_dialog_set_title(castedPointer() as UnsafeMutablePointer<AdwDialog>, newValue) }
    }

    /// Adds a breakpoint (transfer-full: adds a ref before passing).
    public func addBreakpoint(_ breakpoint: Breakpoint) {
        g_object_ref(breakpoint.pointer)
        adw_dialog_add_breakpoint(castedPointer() as UnsafeMutablePointer<AdwDialog>, breakpoint.opaquePointer)
    }

    /// Calls `adw_dialog_close`.
    public func close() -> Bool {
        return adw_dialog_close(castedPointer() as UnsafeMutablePointer<AdwDialog>) != 0
    }

    /// Calls `adw_dialog_force_close`.
    public func forceClose() {
        adw_dialog_force_close(castedPointer() as UnsafeMutablePointer<AdwDialog>)
    }

    /// Calls `adw_dialog_present`.
    public func present(_ parent: Widget?) {
        adw_dialog_present(castedPointer() as UnsafeMutablePointer<AdwDialog>, parent?.widgetPointer)
    }

    /// Connects to the `close-attempt` signal.
    @discardableResult
    public func onCloseAttempt(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "close-attempt", handler: handler)
    }

    /// Connects to the `closed` signal.
    @discardableResult
    public func onClosed(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "closed", handler: handler)
    }
}
