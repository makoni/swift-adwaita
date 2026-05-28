// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita

/// The rendered rectangle of a widget within its parent coordinate space.
///
/// Returned by ``Widget/allocation``. Values are logical pixels (GTK CSS
/// pixel units, not device pixels on HiDPI). The underlying
/// `graphene_rect_t` floats are truncated toward zero with `Int(_:)`, so
/// a value of `0.9` becomes `0`. For scroll-into-view calculations this
/// precision is sufficient; for subpixel hit-testing work with
/// `gtk_widget_compute_bounds` directly. An unmapped widget returns zeros
/// for all fields.
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
    /// Uses `gtk_widget_compute_bounds` with the widget's parent as the
    /// coordinate reference — if the widget has no parent the bounds are
    /// expressed in the widget's own coordinate space (origin = 0, 0).
    /// Returns zeros for unmapped widgets. Useful for scroll-into-view
    /// calculations and hit-testing.
    var allocation: WidgetAllocation {
        let parentPtr = gtk_widget_get_parent(widgetPointer)
        let ancestor = parentPtr ?? widgetPointer
        var bounds = graphene_rect_t()
        guard gtk_widget_compute_bounds(widgetPointer, ancestor, &bounds) != 0 else {
            return WidgetAllocation(x: 0, y: 0, width: 0, height: 0)
        }
        return WidgetAllocation(
            x: Int(bounds.origin.x),
            y: Int(bounds.origin.y),
            width: Int(bounds.size.width),
            height: Int(bounds.size.height)
        )
    }
}
