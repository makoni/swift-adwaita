// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A list box row with an embedded spin button for numeric input.
///
/// Wraps `AdwSpinRow`. Provides a titled row with +/- buttons for adjusting a
/// numeric value within a range, ideal for settings like font size or volume.
///
/// ```swift
/// let fontSize = SpinRow(title: "Font Size", min: 8, max: 72, step: 1)
/// fontSize.value = 14
/// fontSize.subtitle = "Points"
///
/// fontSize.onNotify(property: .value) {
///     print("Font size: \(fontSize.value)")
/// }
///
/// group.add(fontSize)
/// ```
/// - Since: libadwaita 1.4
@MainActor
public final class SpinRow: ActionRow {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `SpinRow` with the given range and step increment.
    public static func newWithRange(min: Double, max: Double, step: Double) -> SpinRow {
        let ptr = adw_spin_row_new_with_range(min, max, step)!
        return SpinRow(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a `SpinRow` with a title and range.
    public convenience init(title: String, min: Double, max: Double, step: Double) {
        let ptr = adw_spin_row_new_with_range(min, max, step)!
        self.init(raw: UnsafeMutableRawPointer(ptr))
        self.title = title
    }

    /// How fast the value changes when the +/- buttons are held.
    /// - Since: libadwaita 1.4
    public var climbRate: Double {
        get { adw_spin_row_get_climb_rate(opaquePointer) }
        set { adw_spin_row_set_climb_rate(opaquePointer, newValue) }
    }

    /// The number of decimal places to display.
    /// - Since: libadwaita 1.4
    public var digits: Int {
        get { Int(adw_spin_row_get_digits(opaquePointer)) }
        set { adw_spin_row_set_digits(opaquePointer, UInt32(newValue)) }
    }

    /// Whether only numeric characters are accepted as input.
    /// - Since: libadwaita 1.4
    public var numeric: Bool {
        get { adw_spin_row_get_numeric(opaquePointer) != 0 }
        set { adw_spin_row_set_numeric(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the value snaps to the nearest step increment.
    /// - Since: libadwaita 1.4
    public var snapToTicks: Bool {
        get { adw_spin_row_get_snap_to_ticks(opaquePointer) != 0 }
        set { adw_spin_row_set_snap_to_ticks(opaquePointer, newValue ? 1 : 0) }
    }

    /// When the spin button value updates: always, or only on valid input.
    /// - Since: libadwaita 1.4
    public var updatePolicy: GtkSpinButtonUpdatePolicy {
        get { adw_spin_row_get_update_policy(opaquePointer) }
        set { adw_spin_row_set_update_policy(opaquePointer, newValue) }
    }

    /// The current numeric value.
    /// - Since: libadwaita 1.4
    public var value: Double {
        get { adw_spin_row_get_value(opaquePointer) }
        set { adw_spin_row_set_value(opaquePointer, newValue) }
    }

    /// Whether the value wraps around from max to min (and vice versa).
    /// - Since: libadwaita 1.4
    public var wrap: Bool {
        get { adw_spin_row_get_wrap(opaquePointer) != 0 }
        set { adw_spin_row_set_wrap(opaquePointer, newValue ? 1 : 0) }
    }

    /// Sets the allowed range of values.
    public func setRange(_ min: Double, max: Double) {
        adw_spin_row_set_range(opaquePointer, min, max)
    }

    /// Manually refreshes the displayed value from the underlying adjustment.
    public func update() {
        adw_spin_row_update(opaquePointer)
    }

    /// Called to convert the user's text input into a numeric value.
    @discardableResult
    public func onInput(_ handler: @escaping @MainActor (Double) -> Void) -> SignalConnection {
        SignalHelper.connectDouble(self, signal: .input, handler: handler)
    }

    /// Called to format the numeric value for display.
    @discardableResult
    public func onOutput(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .output, handler: handler)
    }

    /// Called when the value wraps around from max to min or vice versa.
    @discardableResult
    public func onWrapped(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .wrapped, handler: handler)
    }
}
