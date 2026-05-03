// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

/// Tracks keyboard focus events.
///
/// Wraps `GtkEventControllerFocus`. Notifies when a widget gains or loses
/// keyboard focus. Attach to a widget with `addController()`.
///
/// ```swift
/// let focusController = EventControllerFocus()
/// focusController.onEnter {
///     print("Widget gained focus")
/// }
/// focusController.onLeave {
///     print("Widget lost focus")
/// }
/// entry.addController(focusController)
///
/// // Query focus state at any time
/// if focusController.isFocus {
///     print("Currently focused")
/// }
/// ```
@MainActor
public final class EventControllerFocus: GObjectRef {
    /// Creates a new focus event controller.
    public init() {
        let ptr = gtk_event_controller_focus_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Whether the widget has focus.
    public var isFocus: Bool {
        gtk_event_controller_focus_is_focus(opaquePointer) != 0
    }

    /// Whether the widget or one of its descendants has focus.
    public var containsFocus: Bool {
        gtk_event_controller_focus_contains_focus(opaquePointer) != 0
    }

    /// Emitted when the widget gains focus.
    ///
    /// - Parameter handler: Called when focus enters the widget.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onEnter(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .enter, handler: handler)
    }

    /// Emitted when the widget loses focus.
    ///
    /// - Parameter handler: Called when focus leaves the widget.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onLeave(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .leave, handler: handler)
    }
}
