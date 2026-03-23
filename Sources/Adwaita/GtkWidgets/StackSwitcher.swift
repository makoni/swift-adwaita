import CAdwaita
import GObjectSupport

/// A widget that shows buttons for switching between pages of a `Stack`.
///
/// Wraps `GtkStackSwitcher`.
@MainActor
public final class StackSwitcher: Widget {
    /// Creates a new stack switcher.
    public init() {
        let ptr = gtk_stack_switcher_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The stack to switch between pages of.
    public var stack: Stack? {
        get {
            guard let ptr = gtk_stack_switcher_get_stack(opaquePointer) else { return nil }
            return Stack(raw: UnsafeMutableRawPointer(ptr))
        }
        set { gtk_stack_switcher_set_stack(opaquePointer, newValue?.opaquePointer) }
    }
}
