// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// An auxiliary class used by [class@TabView].
@MainActor
public final class TabPage: GObjectRef {

    /// The `child` property (read-only).
    public var child: Widget {
        Widget(borrowing: UnsafeMutableRawPointer(adw_tab_page_get_child(opaquePointer)))
    }

    /// The `indicator-activatable` property.
    public var indicatorActivatable: Bool {
        get { adw_tab_page_get_indicator_activatable(opaquePointer) != 0 }
        set { adw_tab_page_set_indicator_activatable(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `indicator-tooltip` property.
    /// - Since: libadwaita 1.2
    public var indicatorTooltip: String {
        get { String(cString: adw_tab_page_get_indicator_tooltip(opaquePointer)) }
        set { adw_tab_page_set_indicator_tooltip(opaquePointer, newValue) }
    }

    /// The `keyword` property.
    /// - Since: libadwaita 1.3
    public var keyword: String? {
        get { (adw_tab_page_get_keyword(opaquePointer)).map { String(cString: $0) } }
        set { adw_tab_page_set_keyword(opaquePointer, newValue) }
    }

    /// The `live-thumbnail` property.
    /// - Since: libadwaita 1.3
    public var liveThumbnail: Bool {
        get { adw_tab_page_get_live_thumbnail(opaquePointer) != 0 }
        set { adw_tab_page_set_live_thumbnail(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `loading` property.
    public var loading: Bool {
        get { adw_tab_page_get_loading(opaquePointer) != 0 }
        set { adw_tab_page_set_loading(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `needs-attention` property.
    public var needsAttention: Bool {
        get { adw_tab_page_get_needs_attention(opaquePointer) != 0 }
        set { adw_tab_page_set_needs_attention(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `parent` property (read-only).
    public var parent: TabPage? {
        (adw_tab_page_get_parent(opaquePointer)).map { TabPage(borrowing: UnsafeMutableRawPointer($0)) }
    }

    /// The `pinned` property (read-only).
    public var pinned: Bool {
        adw_tab_page_get_pinned(opaquePointer) != 0
    }

    /// The `selected` property (read-only).
    public var selected: Bool {
        adw_tab_page_get_selected(opaquePointer) != 0
    }

    /// The `thumbnail-xalign` property.
    /// - Since: libadwaita 1.3
    public var thumbnailXalign: Float {
        get { adw_tab_page_get_thumbnail_xalign(opaquePointer) }
        set { adw_tab_page_set_thumbnail_xalign(opaquePointer, newValue) }
    }

    /// The `thumbnail-yalign` property.
    /// - Since: libadwaita 1.3
    public var thumbnailYalign: Float {
        get { adw_tab_page_get_thumbnail_yalign(opaquePointer) }
        set { adw_tab_page_set_thumbnail_yalign(opaquePointer, newValue) }
    }

    /// The `title` property.
    public var title: String {
        get { String(cString: adw_tab_page_get_title(opaquePointer)) }
        set { adw_tab_page_set_title(opaquePointer, newValue) }
    }

    /// The `tooltip` property.
    public var tooltip: String? {
        get { (adw_tab_page_get_tooltip(opaquePointer)).map { String(cString: $0) } }
        set { adw_tab_page_set_tooltip(opaquePointer, newValue) }
    }

    /// Calls `adw_tab_page_invalidate_thumbnail`.
    public func invalidateThumbnail() {
        adw_tab_page_invalidate_thumbnail(opaquePointer)
    }
}
