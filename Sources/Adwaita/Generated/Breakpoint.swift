// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// Describes a breakpoint for [class@Window] or [class@Dialog].
/// - Since: libadwaita 1.4
@MainActor
public final class Breakpoint: GObjectRef {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Borrows a reference to an existing Breakpoint.
    override internal init(borrowing pointer: UnsafeMutableRawPointer) {
        super.init(borrowing: pointer)
    }

    /// Creates a new `Breakpoint`.
    ///
    /// The C function takes ownership of the condition (transfer-full),
    /// so we pass a copy to keep the Swift wrapper valid.
    public init(condition: BreakpointCondition) {
        let conditionCopy = adw_breakpoint_condition_copy(condition.pointer)!
        let ptr = adw_breakpoint_new(conditionCopy)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `condition` property.
    /// - Since: libadwaita 1.4
    public var condition: BreakpointCondition? {
        // getter is transfer-none: we must copy
        get { adw_breakpoint_get_condition(opaquePointer).map { BreakpointCondition(borrowing: $0) } }
        // setter is transfer-none: C side copies internally
        set { adw_breakpoint_set_condition(opaquePointer, newValue?.pointer) }
    }

    /// Connects to the `apply` signal.
    @discardableResult
    public func onApply(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "apply", handler: handler)
    }

    /// Connects to the `unapply` signal.
    @discardableResult
    public func onUnapply(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "unapply", handler: handler)
    }
}
