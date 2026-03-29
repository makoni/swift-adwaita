import CAdwaita
import GObjectSupport

/// A title bar with window controls and custom widgets.
///
/// Wraps `AdwHeaderBar`, which provides a title bar with window controls
/// (close, minimize, maximize) and areas for packing custom widgets at
/// the start and end.
///
/// ```swift
/// let header = HeaderBar(title: "Settings", subtitle: "General")
///
/// // Add a menu button to the end
/// let menuBtn = MenuButton(icon: .openMenu)
/// header.packEnd(menuBtn)
///
/// // Add a back button to the start
/// let backBtn = Button(icon: .goBack)
/// header.packStart(backBtn)
/// ```
///
/// Use with ``ToolbarView`` as the top bar of your window.
@MainActor
public final class HeaderBar: Widget {
    /// Creates a new header bar.
    public init() {
        let ptr = adw_header_bar_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a header bar with a title.
    public convenience init(title: String, subtitle: String = "") {
        self.init()
        titleWidget = WindowTitle(title: title, subtitle: subtitle)
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
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

    /// The custom title widget.
    public var titleWidget: Widget? {
        get {
            guard let ptr = adw_header_bar_get_title_widget(opaquePointer) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set { adw_header_bar_set_title_widget(opaquePointer, newValue?.widgetPointer) }
    }

    /// The decoration layout.
    public var decorationLayout: String? {
        get {
            guard let cStr = adw_header_bar_get_decoration_layout(opaquePointer) else { return nil }
            return String(cString: cStr)
        }
        set { adw_header_bar_set_decoration_layout(opaquePointer, newValue) }
    }
}
