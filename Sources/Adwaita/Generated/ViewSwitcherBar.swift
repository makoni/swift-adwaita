// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A view switcher action bar.
@MainActor
public final class ViewSwitcherBar: Widget {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ViewSwitcherBar`.
    public init() {
        let ptr = adw_view_switcher_bar_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `reveal` property.
    public var reveal: Bool {
        get { adw_view_switcher_bar_get_reveal(opaquePointer) != 0 }
        set { adw_view_switcher_bar_set_reveal(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `stack` property.
    public var stack: ViewStack? {
        get { (adw_view_switcher_bar_get_stack(opaquePointer)).map { ViewStack(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_view_switcher_bar_set_stack(opaquePointer, newValue?.opaquePointer) }
    }
}
