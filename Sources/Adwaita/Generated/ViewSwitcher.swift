// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// An adaptive view switcher.
@MainActor
public final class ViewSwitcher: Widget {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ViewSwitcher`.
    public init() {
        let ptr = adw_view_switcher_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `policy` property.
    public var policy: AdwViewSwitcherPolicy {
        get { adw_view_switcher_get_policy(opaquePointer) }
        set { adw_view_switcher_set_policy(opaquePointer, newValue) }
    }

    /// The `stack` property.
    public var stack: ViewStack? {
        get { (adw_view_switcher_get_stack(opaquePointer)).map { ViewStack(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_view_switcher_set_stack(opaquePointer, newValue?.opaquePointer) }
    }
}
