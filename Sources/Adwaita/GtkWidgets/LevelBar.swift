import CAdwaita
import GObjectSupport

/// A bar that fills up to a certain level.
///
/// Wraps `GtkLevelBar`.
@MainActor
public final class LevelBar: Widget {
    /// Creates a new level bar.
    public init() {
        let ptr = gtk_level_bar_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a level bar with a range.
    public init(min: Double, max: Double) {
        let ptr = gtk_level_bar_new_for_interval(min, max)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The current value.
    public var value: Double {
        get { gtk_level_bar_get_value(opaquePointer) }
        set { gtk_level_bar_set_value(opaquePointer, newValue) }
    }

    /// The minimum value.
    public var minValue: Double {
        get { gtk_level_bar_get_min_value(opaquePointer) }
        set { gtk_level_bar_set_min_value(opaquePointer, newValue) }
    }

    /// The maximum value.
    public var maxValue: Double {
        get { gtk_level_bar_get_max_value(opaquePointer) }
        set { gtk_level_bar_set_max_value(opaquePointer, newValue) }
    }

    /// Whether the level bar is inverted.
    public var inverted: Bool {
        get { gtk_level_bar_get_inverted(opaquePointer) != 0 }
        set { gtk_level_bar_set_inverted(opaquePointer, newValue ? 1 : 0) }
    }

    /// The level bar mode.
    public var mode: GtkLevelBarMode {
        get { gtk_level_bar_get_mode(opaquePointer) }
        set { gtk_level_bar_set_mode(opaquePointer, newValue) }
    }
}
