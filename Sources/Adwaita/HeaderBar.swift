import CAdwaita
import GObjectSupport

/// An Adwaita header bar.
///
/// Wraps `AdwHeaderBar`, which provides a title bar area with window
/// controls and optional custom widgets.
@MainActor
public final class HeaderBar: Widget {
    /// Creates a new header bar.
    public init() {
        let ptr = adw_header_bar_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Adds a widget to the start of the header bar.
    public func packStart(_ child: Widget) {
        adw_header_bar_pack_start(opaquePointer, child.widgetPointer)
    }

    /// Adds a widget to the end of the header bar.
    public func packEnd(_ child: Widget) {
        adw_header_bar_pack_end(opaquePointer, child.widgetPointer)
    }

    /// Removes a child widget from the header bar.
    public func remove(_ child: Widget) {
        adw_header_bar_remove(opaquePointer, child.widgetPointer)
    }

    /// The centering policy.
    public var centeringPolicy: AdwCenteringPolicy {
        get { adw_header_bar_get_centering_policy(opaquePointer) }
        set { adw_header_bar_set_centering_policy(opaquePointer, newValue) }
    }

    /// Whether to show the back button.
    public var showBackButton: Bool {
        get { adw_header_bar_get_show_back_button(opaquePointer) != 0 }
        set { adw_header_bar_set_show_back_button(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether to show the title.
    public var showTitle: Bool {
        get { adw_header_bar_get_show_title(opaquePointer) != 0 }
        set { adw_header_bar_set_show_title(opaquePointer, newValue ? 1 : 0) }
    }
}
