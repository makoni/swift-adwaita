// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

/// Provides access to the GDK display, which represents the connection
/// to the windowing system.
///
/// Wraps `GdkDisplay`. Use the ``default`` property to get the current display
/// and query connected monitors or display properties.
///
/// ```swift
/// if let display = Display.default {
///     print("Display name: \(display.name)")
///     print("Composited: \(display.isComposited)")
///
///     for monitor in display.monitors {
///         let geo = monitor.geometry
///         print("Monitor: \(geo.width)x\(geo.height)")
///     }
/// }
/// ```
@MainActor
public final class Display: GObjectRef {

    /// Returns the default display, or nil if none is available.
    public static var `default`: Display? {
        guard let ptr = gdk_display_get_default() else { return nil }
        return Display(borrowing: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The name of the display (e.g. `:0` on X11, `wayland-0` on Wayland).
    public var name: String {
        String(cString: gdk_display_get_name(opaquePointer))
    }

    /// Whether the display is composited.
    public var isComposited: Bool {
        gdk_display_is_composited(opaquePointer) != 0
    }

    /// Returns all monitors connected to this display.
    public var monitors: [Monitor] {
        guard let listModel = gdk_display_get_monitors(opaquePointer) else { return [] }
        let count = Int(g_list_model_get_n_items(listModel))
        var result: [Monitor] = []
        for i in 0 ..< count {
            guard let item = g_list_model_get_item(listModel, UInt32(i)) else { continue }
            result.append(Monitor(raw: UnsafeMutableRawPointer(item)))
        }
        return result
    }
}

// MARK: - Widget extension

public extension Widget {
    /// The display this widget belongs to.
    var display: Display {
        let ptr = gtk_widget_get_display(widgetPointer)!
        return Display(borrowing: UnsafeMutableRawPointer(ptr))
    }
}
