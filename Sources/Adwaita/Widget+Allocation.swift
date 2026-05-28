// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita

/// The rendered rectangle of a widget within its parent coordinate space.
///
/// Returned by ``Widget/allocation``. Values are integer logical pixels
/// (GTK CSS pixel units, not device pixels on HiDPI). An unmapped widget
/// returns zeros for all fields.
public struct WidgetAllocation: Sendable, Equatable {
    /// The x offset from the parent's origin in logical pixels.
    public let x: Int
    /// The y offset from the parent's origin in logical pixels.
    public let y: Int
    /// The allocated width in logical pixels.
    public let width: Int
    /// The allocated height in logical pixels.
    public let height: Int
}

public extension Widget {
    /// The rendered rectangle of this widget within its parent coordinate space.
    ///
    /// Returns the layout allocation — the rectangle the parent's layout
    /// manager assigned to this widget. Values are integer logical pixels.
    /// Returns zeros for unmapped widgets. Suitable for scroll-into-view
    /// calculations where integer-pixel granularity is sufficient.
    ///
    /// > Note: `gtk_widget_get_allocation` is deprecated since GTK 4.12 in
    /// > favour of `gtk_widget_compute_bounds`. That replacement traverses
    /// > the full widget hierarchy to apply CSS transforms and clip regions,
    /// > which can trigger `Gtk-CRITICAL` assertions for viewport/scrolled-
    /// > window widgets that are only partially initialised at query time. For
    /// > scroll-offset queries the allocation cache is always accurate and
    /// > safe to read without hierarchy traversal. Use
    /// > `gtk_widget_compute_bounds` directly when you need subpixel accuracy
    /// > or CSS-transform-aware bounds.
    var allocation: WidgetAllocation {
        // gtk_widget_get_allocation is deprecated in GTK 4.12 in favour of
        // gtk_widget_compute_bounds, but compute_bounds traverses the widget
        // hierarchy to apply clip regions, which internally calls
        // gtk_scrolled_window_get_child on viewport parents and emits
        // Gtk-CRITICALs when the scrolled-window hierarchy is only partially
        // realised (e.g. during initial layout). The allocation cache that
        // get_allocation reads is safe and accurate for scroll-into-view
        // queries; no hierarchy traversal is involved.
        var a = GtkAllocation()
        swiftadw_widget_get_allocation(widgetPointer, &a)
        return WidgetAllocation(x: Int(a.x), y: Int(a.y), width: Int(a.width), height: Int(a.height))
    }
}
