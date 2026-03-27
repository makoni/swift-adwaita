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
/// - Note: Requires libadwaita 1.7+. The initializer returns `nil` at runtime
///   if the installed version is too old.
///
/// - Since: libadwaita 1.7
@MainActor
public final class InlineViewSwitcher: Widget {

    /// Display mode constants for ``InlineViewSwitcher``.
    public enum DisplayMode: Int32 {
        /// Show only labels.
        case labels = 0
        /// Show only icons.
        case icons = 1
        /// Show both labels and icons.
        case both = 2
    }

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `InlineViewSwitcher`. Returns `nil` if libadwaita < 1.7.
    public init?() {
        guard AdwaitaVersion.isAtLeast(1, 7) else { return nil }
        let ptr = cadw_inline_view_switcher_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Whether the switcher can be narrower than its natural size.
    /// - Since: libadwaita 1.7
    public var canShrink: Bool {
        get { cadw_inline_view_switcher_get_can_shrink(pointer) != 0 }
        set { cadw_inline_view_switcher_set_can_shrink(pointer, newValue ? 1 : 0) }
    }

    /// Controls whether labels, icons, or both are shown on the toggle buttons.
    /// - Since: libadwaita 1.7
    public var displayMode: DisplayMode {
        get { DisplayMode(rawValue: cadw_inline_view_switcher_get_display_mode(pointer)) ?? .both }
        set { cadw_inline_view_switcher_set_display_mode(pointer, newValue.rawValue) }
    }

    /// Whether all toggle buttons have equal width.
    /// - Since: libadwaita 1.7
    public var homogeneous: Bool {
        get { cadw_inline_view_switcher_get_homogeneous(pointer) != 0 }
        set { cadw_inline_view_switcher_set_homogeneous(pointer, newValue ? 1 : 0) }
    }

    /// The ``ViewStack`` whose pages are shown as toggle buttons.
    /// - Since: libadwaita 1.7
    public var stack: ViewStack? {
        get { (cadw_inline_view_switcher_get_stack(pointer)).map { ViewStack(borrowing: UnsafeMutableRawPointer($0)) } }
        set { cadw_inline_view_switcher_set_stack(pointer, newValue?.pointer) }
    }
}
