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

    /// Sets an icon paintable for the drag, with a hotspot offset.
    ///
    /// The hotspot determines the cursor position within the icon during
    /// the drag. Pass (0, 0) for top-left.
    ///
    /// ```swift
    /// if let texture = Texture(filename: "/path/to/icon.png") {
    ///     dragSource.setIcon(texture, hotX: 16, hotY: 16)
    /// }
    /// ```
    public func setIcon(_ paintable: Texture, hotX: Int = 0, hotY: Int = 0) {
        gtk_drag_source_set_icon(
            opaquePointer,
            OpaquePointer(paintable.pointer),
            Int32(hotX),
            Int32(hotY)
        )
    }

    /// Whether a drag operation is currently active.
    public var isDragging: Bool {
        gtk_drag_source_get_drag(opaquePointer) != nil
    }

    /// Emitted when a drag is started.
    ///
    /// - Parameter handler: Called when the drag begins.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onDragBegin(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connectPointer(self, signal: .dragBegin) { _ in handler() }
    }

    /// Emitted when a drag ends.
    ///
    /// - Parameter handler: Called when the drag ends.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onDragEnd(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connectPointer(self, signal: .dragEnd) { _ in handler() }
    }

    /// Emitted when a drag is cancelled.
    ///
    /// - Parameter handler: Called when the drag is cancelled.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onDragCancelled(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connectPointer(self, signal: .dragCancel) { _ in handler() }
    }
}
