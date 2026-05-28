// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

/// A toggle switch widget.
///
/// Wraps `GtkSwitch`. For Adwaita-styled switches in lists, prefer `SwitchRow`.
///
/// ```swift
/// let toggle = Switch(active: false)
/// toggle.onActiveChanged {
///     print("Switch is now: \(toggle.active ? "ON" : "OFF")")
/// }
/// ```
@MainActor
public final class Switch: Widget {
    override public class var gtkType: GType {
        gtk_switch_get_type()
    }

    /// Creates a new switch.
    public init() {
        let ptr = gtk_switch_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a switch with an initial state and an optional change handler.
    public convenience init(active: Bool, onActiveChanged handler: (@MainActor () -> Void)? = nil) {
        self.init()
        self.active = active
        if let handler { onActiveChanged(handler) }
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Whether the switch is active.
    public var active: Bool {
        get { gtk_switch_get_active(opaquePointer) != 0 }
        set { gtk_switch_set_active(opaquePointer, newValue ? 1 : 0) }
    }

    /// Connects to changes of the `active` property.
    @discardableResult
    public func onActiveChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.onNotify(self, property: .active, handler: handler)
    }
}
