import CAdwaita
import GObjectSupport

/// A numeric input widget with increment/decrement buttons.
///
/// Wraps `GtkSpinButton`. For Adwaita-styled spin inputs, prefer `SpinRow`.
@MainActor
public final class SpinButton: Widget {
    /// Creates a spin button with a range.
    public init(min: Double = 0, max: Double = 100, step: Double = 1) {
        let ptr = gtk_spin_button_new_with_range(min, max, step)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    private var spinPointer: OpaquePointer { opaquePointer }

    /// The current value.
    public var value: Double {
        get { gtk_spin_button_get_value(spinPointer) }
        set { gtk_spin_button_set_value(spinPointer, newValue) }
    }

    /// The current value as an integer.
    public var intValue: Int {
        Int(gtk_spin_button_get_value_as_int(spinPointer))
    }

    /// The number of decimal places to display.
    public var digits: Int {
        get { Int(gtk_spin_button_get_digits(spinPointer)) }
        set { gtk_spin_button_set_digits(spinPointer, UInt32(newValue)) }
    }

    /// Whether only numeric input is accepted.
    public var numeric: Bool {
        get { gtk_spin_button_get_numeric(spinPointer) != 0 }
        set { gtk_spin_button_set_numeric(spinPointer, newValue ? 1 : 0) }
    }

    /// Whether the value wraps around at the limits.
    public var wrap: Bool {
        get { gtk_spin_button_get_wrap(spinPointer) != 0 }
        set { gtk_spin_button_set_wrap(spinPointer, newValue ? 1 : 0) }
    }

    /// Whether the value snaps to the nearest step increment.
    public var snapToTicks: Bool {
        get { gtk_spin_button_get_snap_to_ticks(spinPointer) != 0 }
        set { gtk_spin_button_set_snap_to_ticks(spinPointer, newValue ? 1 : 0) }
    }

    /// Sets the range of allowed values.
    public func setRange(min: Double, max: Double) {
        gtk_spin_button_set_range(spinPointer, min, max)
    }

    /// Sets the step and page increments.
    public func setIncrements(step: Double, page: Double) {
        gtk_spin_button_set_increments(spinPointer, step, page)
    }

    /// Emitted when the value changes.
    ///
    /// - Parameter handler: Called when the spin button value changes.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onValueChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .valueChanged, handler: handler)
    }
}
