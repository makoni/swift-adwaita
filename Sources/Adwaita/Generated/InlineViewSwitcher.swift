// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A view switcher that uses a toggle group.
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

    /// The `can-shrink` property.
    /// - Since: libadwaita 1.7
    public var canShrink: Bool {
        get { adw_inline_view_switcher_get_can_shrink(opaquePointer) != 0 }
        set { adw_inline_view_switcher_set_can_shrink(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `display-mode` property.
    /// - Since: libadwaita 1.7
    public var displayMode: AdwInlineViewSwitcherDisplayMode {
        get { adw_inline_view_switcher_get_display_mode(opaquePointer) }
        set { adw_inline_view_switcher_set_display_mode(opaquePointer, newValue) }
    }

    /// The `homogeneous` property.
    /// - Since: libadwaita 1.7
    public var homogeneous: Bool {
        get { adw_inline_view_switcher_get_homogeneous(opaquePointer) != 0 }
        set { adw_inline_view_switcher_set_homogeneous(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `stack` property.
    /// - Since: libadwaita 1.7
    public var stack: ViewStack? {
        get { (adw_inline_view_switcher_get_stack(opaquePointer)).map { ViewStack(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_inline_view_switcher_set_stack(opaquePointer, newValue?.opaquePointer) }
    }
}
