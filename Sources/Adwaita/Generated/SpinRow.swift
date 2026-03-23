// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// An [class@ActionRow] with an embedded spin button.
/// - Since: libadwaita 1.4
@MainActor
public final class SpinRow: ActionRow {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `SpinRow`.
    public static func newWithRange(min: Double, max: Double, step: Double) -> SpinRow {
        let ptr = adw_spin_row_new_with_range(min, max, step)!
        return SpinRow(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `climb-rate` property.
    /// - Since: libadwaita 1.4
    public var climbRate: Double {
        get { adw_spin_row_get_climb_rate(opaquePointer) }
        set { adw_spin_row_set_climb_rate(opaquePointer, newValue) }
    }

    /// The `digits` property.
    /// - Since: libadwaita 1.4
    public var digits: Int {
        get { Int(adw_spin_row_get_digits(opaquePointer)) }
        set { adw_spin_row_set_digits(opaquePointer, UInt32(newValue)) }
    }

    /// The `numeric` property.
    /// - Since: libadwaita 1.4
    public var numeric: Bool {
        get { adw_spin_row_get_numeric(opaquePointer) != 0 }
        set { adw_spin_row_set_numeric(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `snap-to-ticks` property.
    /// - Since: libadwaita 1.4
    public var snapToTicks: Bool {
        get { adw_spin_row_get_snap_to_ticks(opaquePointer) != 0 }
        set { adw_spin_row_set_snap_to_ticks(opaquePointer, newValue ? 1 : 0) }
    }

    /// The `update-policy` property.
    /// - Since: libadwaita 1.4
    public var updatePolicy: GtkSpinButtonUpdatePolicy {
        get { adw_spin_row_get_update_policy(opaquePointer) }
        set { adw_spin_row_set_update_policy(opaquePointer, newValue) }
    }

    /// The `value` property.
    /// - Since: libadwaita 1.4
    public var value: Double {
        get { adw_spin_row_get_value(opaquePointer) }
        set { adw_spin_row_set_value(opaquePointer, newValue) }
    }

    /// The `wrap` property.
    /// - Since: libadwaita 1.4
    public var wrap: Bool {
        get { adw_spin_row_get_wrap(opaquePointer) != 0 }
        set { adw_spin_row_set_wrap(opaquePointer, newValue ? 1 : 0) }
    }

    /// Calls `adw_spin_row_set_range`.
    public func setRange(_ min: Double, max: Double) {
        adw_spin_row_set_range(opaquePointer, min, max)
    }

    /// Calls `adw_spin_row_update`.
    public func update() {
        adw_spin_row_update(opaquePointer)
    }

    /// Connects to the `input` signal.
    @discardableResult
    public func onInput(_ handler: @escaping @MainActor (Double) -> Void) -> SignalConnection {
        SignalHelper.connectDouble(self, signal: "input", handler: handler)
    }

    /// Connects to the `output` signal.
    @discardableResult
    public func onOutput(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "output", handler: handler)
    }

    /// Connects to the `wrapped` signal.
    @discardableResult
    public func onWrapped(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "wrapped", handler: handler)
    }
}
