// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A widget presenting sidebar and content side by side or as an overlay.
/// - Since: libadwaita 1.4
@MainActor
public final class OverlaySplitView: Widget, Swipeable {
    override public class var gtkType: GType {
        adw_overlay_split_view_get_type()
    }

    // The underlying `AdwSwipeable` pointer.

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `OverlaySplitView`.
    public init() {
        let ptr = adw_overlay_split_view_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates an overlay split view with sidebar and content.
    public convenience init(sidebar: Widget, content: Widget) {
        self.init()
        self.sidebar = sidebar
        self.content = content
    }

    /// Whether the split view is collapsed into a single pane, showing only the sidebar or content at a time.
    /// - Since: libadwaita 1.4
    public var collapsed: Bool {
        get { adw_overlay_split_view_get_collapsed(opaquePointer) != 0 }
        set { adw_overlay_split_view_set_collapsed(opaquePointer, newValue ? 1 : 0) }
    }

    /// The content widget displayed alongside the sidebar.
    /// - Since: libadwaita 1.4
    public var content: Widget? {
        get { adw_overlay_split_view_get_content(opaquePointer).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_overlay_split_view_set_content(opaquePointer, newValue?.widgetPointer) }
    }

    /// Whether a swipe gesture can be used to hide the sidebar when it is overlaid.
    /// - Since: libadwaita 1.4
    public var enableHideGesture: Bool {
        get { adw_overlay_split_view_get_enable_hide_gesture(opaquePointer) != 0 }
        set { adw_overlay_split_view_set_enable_hide_gesture(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether a swipe gesture can be used to reveal the sidebar when it is hidden.
    /// - Since: libadwaita 1.4
    public var enableShowGesture: Bool {
        get { adw_overlay_split_view_get_enable_show_gesture(opaquePointer) != 0 }
        set { adw_overlay_split_view_set_enable_show_gesture(opaquePointer, newValue ? 1 : 0) }
    }

    /// The maximum width of the sidebar, in the unit specified by ``sidebarWidthUnit``.
    /// - Since: libadwaita 1.4
    public var maxSidebarWidth: Double {
        get { adw_overlay_split_view_get_max_sidebar_width(opaquePointer) }
        set { adw_overlay_split_view_set_max_sidebar_width(opaquePointer, newValue) }
    }

    /// The minimum width of the sidebar, in the unit specified by ``sidebarWidthUnit``.
    /// - Since: libadwaita 1.4
    public var minSidebarWidth: Double {
        get { adw_overlay_split_view_get_min_sidebar_width(opaquePointer) }
        set { adw_overlay_split_view_set_min_sidebar_width(opaquePointer, newValue) }
    }

    /// Whether the sidebar remains visible even when the content is wide enough, pinning it in place.
    /// - Since: libadwaita 1.4
    public var pinSidebar: Bool {
        get { adw_overlay_split_view_get_pin_sidebar(opaquePointer) != 0 }
        set { adw_overlay_split_view_set_pin_sidebar(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the sidebar is currently visible. Set to `false` to hide the sidebar overlay.
    /// - Since: libadwaita 1.4
    public var showSidebar: Bool {
        get { adw_overlay_split_view_get_show_sidebar(opaquePointer) != 0 }
        set { adw_overlay_split_view_set_show_sidebar(opaquePointer, newValue ? 1 : 0) }
    }

    /// The sidebar widget displayed beside or overlaid on the content.
    /// - Since: libadwaita 1.4
    public var sidebar: Widget? {
        get { adw_overlay_split_view_get_sidebar(opaquePointer).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_overlay_split_view_set_sidebar(opaquePointer, newValue?.widgetPointer) }
    }

    /// The position of the sidebar relative to the content (start or end).
    /// - Since: libadwaita 1.4
    public var sidebarPosition: GtkPackType {
        get { adw_overlay_split_view_get_sidebar_position(opaquePointer) }
        set { adw_overlay_split_view_set_sidebar_position(opaquePointer, newValue) }
    }

    /// The fraction of the total width allocated to the sidebar, between 0 and 1.
    /// - Since: libadwaita 1.4
    public var sidebarWidthFraction: Double {
        get { adw_overlay_split_view_get_sidebar_width_fraction(opaquePointer) }
        set { adw_overlay_split_view_set_sidebar_width_fraction(opaquePointer, newValue) }
    }

    /// The unit used for ``minSidebarWidth`` and ``maxSidebarWidth`` (e.g. pixels or scale-independent pixels).
    /// - Since: libadwaita 1.4
    public var sidebarWidthUnit: AdwLengthUnit {
        get { adw_overlay_split_view_get_sidebar_width_unit(opaquePointer) }
        set { adw_overlay_split_view_set_sidebar_width_unit(opaquePointer, newValue) }
    }
}
