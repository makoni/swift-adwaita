import CAdwaita
import GObjectSupport

/// A slider widget for selecting a value from a range.
///
/// Wraps `GtkScale`.
@MainActor
public final class Scale: Widget {
    /// Creates a new scale.
    public init(orientation: GtkOrientation = GTK_ORIENTATION_HORIZONTAL, min: Double = 0, max: Double = 100, step: Double = 1) {
        let ptr = gtk_scale_new_with_range(orientation, min, max, step)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    private var rangePointer: UnsafeMutablePointer<GtkRange> { castedPointer() }
    private var scalePointer: UnsafeMutablePointer<GtkScale> { castedPointer() }

    /// The current value.
    public var value: Double {
        get { gtk_range_get_value(rangePointer) }
        set { gtk_range_set_value(rangePointer, newValue) }
    }

    /// Whether to draw the value label.
    public var drawValue: Bool {
        get { gtk_scale_get_draw_value(scalePointer) != 0 }
        set { gtk_scale_set_draw_value(scalePointer, newValue ? 1 : 0) }
    }

    /// The number of decimal places to display.
    public var digits: Int32 {
        get { gtk_scale_get_digits(scalePointer) }
        set { gtk_scale_set_digits(scalePointer, newValue) }
    }

    /// Whether the slider has an origin.
    public var hasOrigin: Bool {
        get { gtk_scale_get_has_origin(scalePointer) != 0 }
        set { gtk_scale_set_has_origin(scalePointer, newValue ? 1 : 0) }
    }

    /// The position of the value label.
    public var valuePos: GtkPositionType {
        get { gtk_scale_get_value_pos(scalePointer) }
        set { gtk_scale_set_value_pos(scalePointer, newValue) }
    }

    /// Sets the range.
    public func setRange(min: Double, max: Double) {
        gtk_range_set_range(rangePointer, min, max)
    }

    /// Whether the range is inverted.
    public var inverted: Bool {
        get { gtk_range_get_inverted(rangePointer) != 0 }
        set { gtk_range_set_inverted(rangePointer, newValue ? 1 : 0) }
    }

    /// Connects to the `value-changed` signal.
    @discardableResult
    public func onValueChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "value-changed", handler: handler)
    }
}
