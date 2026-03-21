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

    /// Creates a new `Breakpoint`.
    public init(condition: OpaquePointer) {
        let ptr = adw_breakpoint_new(condition)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `condition` property.
    /// - Since: libadwaita 1.4
    public var condition: OpaquePointer? {
        get { adw_breakpoint_get_condition(opaquePointer) }
        set { adw_breakpoint_set_condition(opaquePointer, newValue) }
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
