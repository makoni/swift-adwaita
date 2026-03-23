import CAdwaita
import GObjectSupport

/// A controller for initiating drag operations from a widget.
///
/// Wraps `GtkDragSource`. Attach to a widget with `addController()`.
@MainActor
public final class DragSource: GObjectRef {
    /// Creates a new drag source controller.
    public init() {
        let ptr = gtk_drag_source_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The allowed drag actions (copy, move, link).
    public var actions: GdkDragAction {
        get { gtk_drag_source_get_actions(opaquePointer) }
        set { gtk_drag_source_set_actions(opaquePointer, newValue) }
    }

    /// Sets a text content provider for this drag source.
    public func setTextContent(_ text: String) {
        let value = UnsafeMutablePointer<GValue>.allocate(capacity: 1)
        value.initialize(to: GValue())
        g_value_init(value, cadw_type_string())
        g_value_set_string(value, text)
        let provider = gdk_content_provider_new_for_value(value)
        gtk_drag_source_set_content(opaquePointer, provider)
        g_value_unset(value)
        value.deallocate()
    }

    /// Cancels the current drag operation.
    public func dragCancel() {
        gtk_drag_source_drag_cancel(opaquePointer)
    }

    /// Connects to the `drag-begin` signal.
    @discardableResult
    public func onDragBegin(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connectPointer(self, signal: "drag-begin") { _ in handler() }
    }

    /// Connects to the `drag-end` signal.
    @discardableResult
    public func onDragEnd(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connectPointer(self, signal: "drag-end") { _ in handler() }
    }

    /// Connects to the `drag-cancel` signal.
    @discardableResult
    public func onDragCancelled(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connectPointer(self, signal: "drag-cancel") { _ in handler() }
    }
}
