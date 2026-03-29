// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// Metadata and state for a single page within a ``TabView``.
///
/// Wraps `AdwTabPage`. You do not create `TabPage` instances directly; they
/// are returned by ``TabView`` methods such as ``TabView/append(_:)`` and
/// ``TabView/addPage(_:parent:)``. Use the page object to set the tab title,
/// tooltip, loading indicator, attention dot, and pinned state.
///
/// ```swift
/// let tabView = TabView()
/// let page = tabView.append(Label(text: "Document 1"))
///
/// // Set tab metadata
/// page.title = "Document 1"
/// page.tooltip = "Unsaved changes"
///
/// // Show a loading spinner on the tab
/// page.loading = true
///
/// // Show an attention indicator
/// page.needsAttention = true
///
/// // Read-only state
/// let isPinned = page.pinned
/// let isSelected = page.selected
/// let child = page.child
/// ```
///
/// Key properties:
/// - ``title`` / ``tooltip``: Tab label text and hover tooltip.
/// - ``loading``: Whether a loading spinner is shown on the tab.
/// - ``needsAttention``: Whether an attention indicator dot is shown.
/// - ``pinned`` / ``selected``: Read-only pinned and selection state.
/// - ``child``: The widget displayed when the tab is active (read-only).
/// - ``indicatorActivatable`` / ``indicatorTooltip``: Custom indicator behavior.
@MainActor
public final class TabPage: GObjectRef {

    /// The content widget displayed when this tab is active.
    public var child: Widget {
        Widget(borrowing: UnsafeMutableRawPointer(adw_tab_page_get_child(opaquePointer)))
    }

    /// Whether the tab's indicator icon is interactive and can receive click events.
    public var indicatorActivatable: Bool {
        get { adw_tab_page_get_indicator_activatable(opaquePointer) != 0 }
        set { adw_tab_page_set_indicator_activatable(opaquePointer, newValue ? 1 : 0) }
    }

    /// The tooltip text displayed when hovering over the tab's indicator icon.
    /// - Since: libadwaita 1.2
    public var indicatorTooltip: String {
        get { String(cString: adw_tab_page_get_indicator_tooltip(opaquePointer)) }
        set { adw_tab_page_set_indicator_tooltip(opaquePointer, newValue) }
    }

    /// An optional search keyword associated with this tab, used for filtering in tab overview.
    /// - Since: libadwaita 1.3
    public var keyword: String? {
        get { adw_tab_page_get_keyword(opaquePointer).map { String(cString: $0) } }
        set { adw_tab_page_set_keyword(opaquePointer, newValue) }
    }

    /// Whether the tab overview should display a live, continuously updated thumbnail of this page.
    /// - Since: libadwaita 1.3
    public var liveThumbnail: Bool {
        get { adw_tab_page_get_live_thumbnail(opaquePointer) != 0 }
        set { adw_tab_page_set_live_thumbnail(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether a loading spinner is shown on the tab.
    public var loading: Bool {
        get { adw_tab_page_get_loading(opaquePointer) != 0 }
        set { adw_tab_page_set_loading(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether an attention indicator dot is shown on the tab to alert the user.
    public var needsAttention: Bool {
        get { adw_tab_page_get_needs_attention(opaquePointer) != 0 }
        set { adw_tab_page_set_needs_attention(opaquePointer, newValue ? 1 : 0) }
    }

    /// The parent tab page, or `nil` if this is a top-level page.
    public var parent: TabPage? {
        adw_tab_page_get_parent(opaquePointer).map { TabPage(borrowing: UnsafeMutableRawPointer($0)) }
    }

    /// Whether this tab is pinned to the beginning of the tab bar.
    public var pinned: Bool {
        adw_tab_page_get_pinned(opaquePointer) != 0
    }

    /// Whether this tab is currently selected (visible) in the tab view.
    public var selected: Bool {
        adw_tab_page_get_selected(opaquePointer) != 0
    }

    /// The horizontal alignment of the tab thumbnail in tab overview, from 0.0 (left) to 1.0 (right).
    /// - Since: libadwaita 1.3
    public var thumbnailXalign: Float {
        get { adw_tab_page_get_thumbnail_xalign(opaquePointer) }
        set { adw_tab_page_set_thumbnail_xalign(opaquePointer, newValue) }
    }

    /// The vertical alignment of the tab thumbnail in tab overview, from 0.0 (top) to 1.0 (bottom).
    /// - Since: libadwaita 1.3
    public var thumbnailYalign: Float {
        get { adw_tab_page_get_thumbnail_yalign(opaquePointer) }
        set { adw_tab_page_set_thumbnail_yalign(opaquePointer, newValue) }
    }

    /// The title text displayed on the tab label.
    public var title: String {
        get { String(cString: adw_tab_page_get_title(opaquePointer)) }
        set { adw_tab_page_set_title(opaquePointer, newValue) }
    }

    /// The tooltip text shown when hovering over the tab.
    public var tooltip: String? {
        get { adw_tab_page_get_tooltip(opaquePointer).map { String(cString: $0) } }
        set { adw_tab_page_set_tooltip(opaquePointer, newValue) }
    }

    /// Marks the tab's thumbnail as outdated, causing it to be regenerated
    /// the next time it is displayed in the tab overview.
    public func invalidateThumbnail() {
        adw_tab_page_invalidate_thumbnail(opaquePointer)
    }
}
