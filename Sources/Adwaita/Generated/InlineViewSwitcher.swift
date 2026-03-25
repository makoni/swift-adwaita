// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// An inline view switcher rendered as a compact toggle group.
///
/// Wraps `AdwInlineViewSwitcher`. Displays toggle buttons for each page in a
/// connected ``ViewStack``, using a segmented-control style. Unlike
/// ``ViewSwitcher``, this widget does not adapt its layout -- it always renders
/// inline. Useful for secondary navigation within content areas rather than in
/// a header bar.
///
/// ```swift
/// let stack = ViewStack()
/// stack.addTitledWithIcon(dayView, name: "day",
///                         title: "Day", iconName: "view-day-symbolic")
/// stack.addTitledWithIcon(weekView, name: "week",
///                         title: "Week", iconName: "view-week-symbolic")
/// stack.addTitledWithIcon(monthView, name: "month",
///                         title: "Month", iconName: "view-month-symbolic")
///
/// let inlineSwitcher = InlineViewSwitcher()
/// inlineSwitcher.stack = stack
/// inlineSwitcher.homogeneous = true
///
/// // Place above the stack in a vertical box
/// let box = Box(orientation: .vertical, spacing: 8)
/// box.append(inlineSwitcher)
/// box.append(stack)
/// ```
///
/// Key properties:
/// - ``stack``: The ``ViewStack`` whose pages are shown as toggle buttons.
/// - ``displayMode``: Controls whether labels, icons, or both are shown.
/// - ``homogeneous``: Whether all buttons have equal width.
/// - ``canShrink``: Whether the switcher can shrink below its natural size.
///
/// - Since: libadwaita 1.7
@MainActor
public final class InlineViewSwitcher: Widget {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `InlineViewSwitcher`.
    public init() {
        let ptr = adw_inline_view_switcher_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Whether the switcher can be narrower than its natural size.
    /// - Since: libadwaita 1.7
    public var canShrink: Bool {
        get { adw_inline_view_switcher_get_can_shrink(opaquePointer) != 0 }
        set { adw_inline_view_switcher_set_can_shrink(opaquePointer, newValue ? 1 : 0) }
    }

    /// Controls whether labels, icons, or both are shown on the toggle buttons.
    /// - Since: libadwaita 1.7
    public var displayMode: AdwInlineViewSwitcherDisplayMode {
        get { adw_inline_view_switcher_get_display_mode(opaquePointer) }
        set { adw_inline_view_switcher_set_display_mode(opaquePointer, newValue) }
    }

    /// Whether all toggle buttons have equal width.
    /// - Since: libadwaita 1.7
    public var homogeneous: Bool {
        get { adw_inline_view_switcher_get_homogeneous(opaquePointer) != 0 }
        set { adw_inline_view_switcher_set_homogeneous(opaquePointer, newValue ? 1 : 0) }
    }

    /// The ``ViewStack`` whose pages are shown as toggle buttons.
    /// - Since: libadwaita 1.7
    public var stack: ViewStack? {
        get { (adw_inline_view_switcher_get_stack(opaquePointer)).map { ViewStack(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_inline_view_switcher_set_stack(opaquePointer, newValue?.opaquePointer) }
    }
}
