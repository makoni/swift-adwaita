// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A layout manager that arranges children in rows, wrapping to the next line as needed.
///
/// Wraps `AdwWrapLayout`. Behaves like a horizontal box that automatically
/// wraps children into additional lines when the available width is exceeded.
/// Supports configurable spacing, alignment, justification, and wrap direction.
///
/// ```swift
/// let wrapLayout = WrapLayout()
/// wrapLayout.childSpacing = 8
/// wrapLayout.lineSpacing = 8
/// wrapLayout.align = 0.5
/// wrapLayout.naturalLineLength = 400
/// wrapLayout.wrapReverse = false
/// ```
///
/// - Since: libadwaita 1.7
@MainActor
public final class WrapLayout: LayoutManager {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `WrapLayout`.
    public init() {
        let ptr = adw_wrap_layout_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Alignment of children within each line, from 0.0 (start) to 1.0 (end).
    /// - Since: libadwaita 1.7
    public var align: Float {
        get { adw_wrap_layout_get_align(opaquePointer) }
        set { adw_wrap_layout_set_align(opaquePointer, newValue) }
    }

    /// The spacing between children within the same line.
    /// - Since: libadwaita 1.7
    public var childSpacing: Int {
        get { Int(adw_wrap_layout_get_child_spacing(opaquePointer)) }
        set { adw_wrap_layout_set_child_spacing(opaquePointer, Int32(newValue)) }
    }

    /// The unit used for the child spacing value (e.g. pixels or scale-independent).
    /// - Since: libadwaita 1.7
    public var childSpacingUnit: AdwLengthUnit {
        get { adw_wrap_layout_get_child_spacing_unit(opaquePointer) }
        set { adw_wrap_layout_set_child_spacing_unit(opaquePointer, newValue) }
    }

    /// How children are distributed across each line when extra space is available.
    /// - Since: libadwaita 1.7
    public var justify: AdwJustifyMode {
        get { adw_wrap_layout_get_justify(opaquePointer) }
        set { adw_wrap_layout_set_justify(opaquePointer, newValue) }
    }

    /// Whether the last line is also justified when justification is enabled.
    /// - Since: libadwaita 1.7
    public var justifyLastLine: Bool {
        get { adw_wrap_layout_get_justify_last_line(opaquePointer) != 0 }
        set { adw_wrap_layout_set_justify_last_line(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether all lines are given equal height.
    /// - Since: libadwaita 1.7
    public var lineHomogeneous: Bool {
        get { adw_wrap_layout_get_line_homogeneous(opaquePointer) != 0 }
        set { adw_wrap_layout_set_line_homogeneous(opaquePointer, newValue ? 1 : 0) }
    }

    /// The spacing between wrapped lines.
    /// - Since: libadwaita 1.7
    public var lineSpacing: Int {
        get { Int(adw_wrap_layout_get_line_spacing(opaquePointer)) }
        set { adw_wrap_layout_set_line_spacing(opaquePointer, Int32(newValue)) }
    }

    /// The unit used for the line spacing value.
    /// - Since: libadwaita 1.7
    public var lineSpacingUnit: AdwLengthUnit {
        get { adw_wrap_layout_get_line_spacing_unit(opaquePointer) }
        set { adw_wrap_layout_set_line_spacing_unit(opaquePointer, newValue) }
    }

    /// The preferred length of each line before wrapping occurs.
    /// - Since: libadwaita 1.7
    public var naturalLineLength: Int {
        get { Int(adw_wrap_layout_get_natural_line_length(opaquePointer)) }
        set { adw_wrap_layout_set_natural_line_length(opaquePointer, Int32(newValue)) }
    }

    /// The unit used for the natural line length value.
    /// - Since: libadwaita 1.7
    public var naturalLineLengthUnit: AdwLengthUnit {
        get { adw_wrap_layout_get_natural_line_length_unit(opaquePointer) }
        set { adw_wrap_layout_set_natural_line_length_unit(opaquePointer, newValue) }
    }

    /// The direction in which children are packed within each line.
    /// - Since: libadwaita 1.7
    public var packDirection: AdwPackDirection {
        get { adw_wrap_layout_get_pack_direction(opaquePointer) }
        set { adw_wrap_layout_set_pack_direction(opaquePointer, newValue) }
    }

    /// The policy that determines when children wrap to a new line.
    /// - Since: libadwaita 1.7
    public var wrapPolicy: AdwWrapPolicy {
        get { adw_wrap_layout_get_wrap_policy(opaquePointer) }
        set { adw_wrap_layout_set_wrap_policy(opaquePointer, newValue) }
    }

    /// Whether new lines are added above (or before) the previous ones instead of below (or after).
    /// - Since: libadwaita 1.7
    public var wrapReverse: Bool {
        get { adw_wrap_layout_get_wrap_reverse(opaquePointer) != 0 }
        set { adw_wrap_layout_set_wrap_reverse(opaquePointer, newValue ? 1 : 0) }
    }
}
