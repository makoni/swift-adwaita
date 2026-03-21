import CAdwaita
import GObjectSupport

/// An Adwaita toolbar view.
///
/// Wraps `AdwToolbarView`, which provides a container with top and bottom
/// toolbar areas around a central content widget.
@MainActor
public final class ToolbarView: Widget {
    /// Creates a new toolbar view.
    public init() {
        let ptr = adw_toolbar_view_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The content widget displayed between the toolbars.
    public var content: Widget? {
        get {
            guard let ptr = adw_toolbar_view_get_content(opaquePointer) else {
                return nil
            }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set {
            adw_toolbar_view_set_content(opaquePointer, newValue?.widgetPointer)
        }
    }

    /// Sets the content using the raw widget pointer.
    public func setContent(_ widget: Widget) {
        adw_toolbar_view_set_content(opaquePointer, widget.widgetPointer)
    }

    /// Adds a widget to the top toolbar area.
    public func addTopBar(_ widget: Widget) {
        adw_toolbar_view_add_top_bar(opaquePointer, widget.widgetPointer)
    }

    /// Adds a widget to the bottom toolbar area.
    public func addBottomBar(_ widget: Widget) {
        adw_toolbar_view_add_bottom_bar(opaquePointer, widget.widgetPointer)
    }

    /// Removes a child widget.
    public func remove(_ widget: Widget) {
        adw_toolbar_view_remove(opaquePointer, widget.widgetPointer)
    }

    /// The style of the top bar.
    public var topBarStyle: AdwToolbarStyle {
        get { adw_toolbar_view_get_top_bar_style(opaquePointer) }
        set { adw_toolbar_view_set_top_bar_style(opaquePointer, newValue) }
    }

    /// The style of the bottom bar.
    public var bottomBarStyle: AdwToolbarStyle {
        get { adw_toolbar_view_get_bottom_bar_style(opaquePointer) }
        set { adw_toolbar_view_set_bottom_bar_style(opaquePointer, newValue) }
    }

    /// Whether to reveal the top bars.
    public var revealTopBars: Bool {
        get { adw_toolbar_view_get_reveal_top_bars(opaquePointer) != 0 }
        set { adw_toolbar_view_set_reveal_top_bars(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether to reveal the bottom bars.
    public var revealBottomBars: Bool {
        get { adw_toolbar_view_get_reveal_bottom_bars(opaquePointer) != 0 }
        set { adw_toolbar_view_set_reveal_bottom_bars(opaquePointer, newValue ? 1 : 0) }
    }
}
