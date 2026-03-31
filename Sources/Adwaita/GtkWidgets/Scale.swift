import CAdwaita
import GObjectSupport

/// A slider widget for selecting a value from a range.
///
/// Wraps `GtkScale`.
@MainActor
public final class Scale: Widget {
    /// Creates a new scale.
    public init(
        orientation: GtkOrientation = GTK_ORIENTATION_HORIZONTAL,
        min: Double = 0,
        max: Double = 100,
        step: Double = 1
    ) {
        let ptr = gtk_scale_new_with_range(orientation, min, max, step)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    private var rangePointer: UnsafeMutablePointer<GtkRange> {
        castedPointer()
    }

    private var scalePointer: UnsafeMutablePointer<GtkScale> {
        castedPointer()
    }

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
    public var digits: Int {
        get { Int(gtk_scale_get_digits(scalePointer)) }
        set { gtk_scale_set_digits(scalePointer, Int32(newValue)) }
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

    /// Adds a mark at the given value with optional markup text.
    public func addMark(value: Double, position: GtkPositionType = .top, markup: String? = nil) {
        gtk_scale_add_mark(scalePointer, value, position, markup)
    }

    /// Removes all marks from the scale.
    public func clearMarks() {
        gtk_scale_clear_marks(scalePointer)
    }

    /// Sets a custom function to format the displayed value.
    ///
    /// The closure receives the current value and returns the string to display.
    /// Pass `nil` to reset to the default formatting.
    ///
    /// Example:
    /// ```swift
    /// scale.setFormatValueFunc { value in "\(Int(value))%" }
    /// ```
    public func setFormatValueFunc(_ format: (@MainActor (Double) -> String)?) {
        guard let format else {
            gtk_scale_set_format_value_func(scalePointer, nil, nil, nil)
            return
        }
        let box = Unmanaged.passRetained(PublicClosureBox(format)).toOpaque()
        gtk_scale_set_format_value_func(
            scalePointer,
            { _, value, userData in
                guard let userData else { return g_strdup("") }
                let box = Unmanaged<PublicClosureBox<@MainActor (Double) -> String>>
                    .fromOpaque(userData).takeUnretainedValue()
                let str = MainActor.assumeIsolated {
                    box.closure(value)
                }
                return g_strdup(str)
            },
            box,
            { userData in
                guard let userData else { return }
                Unmanaged<AnyObject>.fromOpaque(userData).release()
            }
        )
    }

    /// Emitted when the value changes.
    ///
    /// - Parameter handler: Called when the scale value changes.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onValueChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .valueChanged, handler: handler)
    }

    /// Sets whether to draw the value and returns self for chaining.
    @discardableResult
    public func drawValue(_ draw: Bool = true) -> Self {
        drawValue = draw
        return self
    }

    /// Sets the number of decimal places and returns self for chaining.
    @discardableResult
    public func digits(_ digits: Int) -> Self {
        self.digits = digits
        return self
    }
}
