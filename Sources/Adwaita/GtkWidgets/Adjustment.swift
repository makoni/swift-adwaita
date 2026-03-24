import CAdwaita
import GObjectSupport

/// A representation of an adjustable bounded value.
///
/// Wraps `GtkAdjustment`. Used for scrollbars, scales, spin buttons, etc.
@MainActor
public final class Adjustment: GObjectRef {
    /// Creates a new adjustment.
    ///
    /// - Parameters:
    ///   - value: The initial value.
    ///   - lower: The minimum value.
    ///   - upper: The maximum value.
    ///   - stepIncrement: The step increment.
    ///   - pageIncrement: The page increment.
    ///   - pageSize: The page size.
    public init(
        value: Double = 0,
        lower: Double = 0,
        upper: Double = 1,
        stepIncrement: Double = 0.1,
        pageIncrement: Double = 0.5,
        pageSize: Double = 0
    ) {
        let ptr = gtk_adjustment_new(value, lower, upper, stepIncrement, pageIncrement, pageSize)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The current value.
    public var value: Double {
        get { gtk_adjustment_get_value(castedPointer()) }
        set { gtk_adjustment_set_value(castedPointer(), newValue) }
    }

    /// The minimum value.
    public var lower: Double {
        get { gtk_adjustment_get_lower(castedPointer()) }
        set { gtk_adjustment_set_lower(castedPointer(), newValue) }
    }

    /// The maximum value.
    public var upper: Double {
        get { gtk_adjustment_get_upper(castedPointer()) }
        set { gtk_adjustment_set_upper(castedPointer(), newValue) }
    }

    /// The step increment.
    public var stepIncrement: Double {
        get { gtk_adjustment_get_step_increment(castedPointer()) }
        set { gtk_adjustment_set_step_increment(castedPointer(), newValue) }
    }

    /// The page increment.
    public var pageIncrement: Double {
        get { gtk_adjustment_get_page_increment(castedPointer()) }
        set { gtk_adjustment_set_page_increment(castedPointer(), newValue) }
    }

    /// The page size.
    public var pageSize: Double {
        get { gtk_adjustment_get_page_size(castedPointer()) }
        set { gtk_adjustment_set_page_size(castedPointer(), newValue) }
    }

    /// Configures all properties at once.
    public func configure(
        value: Double,
        lower: Double,
        upper: Double,
        stepIncrement: Double,
        pageIncrement: Double,
        pageSize: Double
    ) {
        gtk_adjustment_configure(castedPointer(), value, lower, upper, stepIncrement, pageIncrement, pageSize)
    }

    /// Clamps the value to the valid range.
    public func clampPage(lower: Double, upper: Double) {
        gtk_adjustment_clamp_page(castedPointer(), lower, upper)
    }

    /// Connects to the `value-changed` signal.
    @discardableResult
    public func onValueChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .valueChanged, handler: handler)
    }

    /// Connects to the `changed` signal (bounds or increments changed).
    @discardableResult
    public func onChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .changed, handler: handler)
    }
}
