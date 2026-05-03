// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

/// A bar that fills up to a certain level, useful for displaying signal strength, capacity, or ratings.
///
/// Wraps `GtkLevelBar`. Supports both continuous and discrete modes, with
/// customizable offset thresholds for color-coded feedback.
///
/// ```swift
/// // Continuous level bar (e.g., battery level)
/// let battery = LevelBar(min: 0, max: 100)
/// battery.value = 75
///
/// // Discrete level bar (e.g., signal strength)
/// let signal = LevelBar(min: 0, max: 5)
/// signal.mode = GTK_LEVEL_BAR_MODE_DISCRETE
/// signal.value = 3
///
/// // Custom thresholds for color feedback
/// let disk = LevelBar(min: 0, max: 100)
/// disk.addOffsetValue(name: "low", value: 25)
/// disk.addOffsetValue(name: "high", value: 75)
/// disk.addOffsetValue(name: "full", value: 95)
/// ```
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

    required init(raw pointer: UnsafeMutableRawPointer) {
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

    /// Adds an offset value to create custom level thresholds.
    ///
    /// Built-in offsets: "low", "high", "full".
    public func addOffsetValue(name: String, value: Double) {
        gtk_level_bar_add_offset_value(opaquePointer, name, value)
    }

    /// Removes an offset value by name.
    public func removeOffsetValue(name: String) {
        gtk_level_bar_remove_offset_value(opaquePointer, name)
    }

    /// Emitted when the value changes.
    ///
    /// - Parameter handler: Called when the level bar value changes.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onValueChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.onNotify(self, property: .value, handler: handler)
    }
}
