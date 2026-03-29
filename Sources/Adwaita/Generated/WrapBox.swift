// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A box-like widget that can wrap into multiple lines.
/// - Since: libadwaita 1.7
@MainActor
public final class WrapBox: Widget, Container {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `WrapBox`.
    ///
    /// - Note: Requires libadwaita 1.7+. Returns `nil` on older versions.
    public init?() {
        guard AdwaitaVersion.isAtLeast(1, 7) else { return nil }
        let ptr = adw_wrap_box_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The alignment of children within each line, from `0.0` (start) to `1.0` (end).
    /// - Since: libadwaita 1.7
    public var align: Float {
        get { adw_wrap_box_get_align(opaquePointer) }
        set { adw_wrap_box_set_align(opaquePointer, newValue) }
    }

    /// The spacing between children within the same line, in the unit specified by ``childSpacingUnit``.
    /// - Since: libadwaita 1.7
    public var childSpacing: Int {
        get { Int(adw_wrap_box_get_child_spacing(opaquePointer)) }
        set { adw_wrap_box_set_child_spacing(opaquePointer, Int32(newValue)) }
    }

    /// The unit used for the ``childSpacing`` value (e.g., pixels or scale-independent pixels).
    /// - Since: libadwaita 1.7
    public var childSpacingUnit: AdwLengthUnit {
        get { adw_wrap_box_get_child_spacing_unit(opaquePointer) }
        set { adw_wrap_box_set_child_spacing_unit(opaquePointer, newValue) }
    }

    /// How children are distributed across the available space within each line.
    /// - Since: libadwaita 1.7
    public var justify: AdwJustifyMode {
        get { adw_wrap_box_get_justify(opaquePointer) }
        set { adw_wrap_box_set_justify(opaquePointer, newValue) }
    }

    /// Whether the last line of children is also justified according to the ``justify`` mode.
    /// - Since: libadwaita 1.7
    public var justifyLastLine: Bool {
        get { adw_wrap_box_get_justify_last_line(opaquePointer) != 0 }
        set { adw_wrap_box_set_justify_last_line(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether all children in a line are given equal height (horizontal layout) or width (vertical layout).
    /// - Since: libadwaita 1.7
    public var lineHomogeneous: Bool {
        get { adw_wrap_box_get_line_homogeneous(opaquePointer) != 0 }
        set { adw_wrap_box_set_line_homogeneous(opaquePointer, newValue ? 1 : 0) }
    }

    /// The spacing between wrapped lines, in the unit specified by ``lineSpacingUnit``.
    /// - Since: libadwaita 1.7
    public var lineSpacing: Int {
        get { Int(adw_wrap_box_get_line_spacing(opaquePointer)) }
        set { adw_wrap_box_set_line_spacing(opaquePointer, Int32(newValue)) }
    }

    /// The unit used for the ``lineSpacing`` value (e.g., pixels or scale-independent pixels).
    /// - Since: libadwaita 1.7
    public var lineSpacingUnit: AdwLengthUnit {
        get { adw_wrap_box_get_line_spacing_unit(opaquePointer) }
        set { adw_wrap_box_set_line_spacing_unit(opaquePointer, newValue) }
    }

    /// The preferred length of each line before wrapping occurs, in the unit specified by ``naturalLineLengthUnit``.
    /// - Since: libadwaita 1.7
    public var naturalLineLength: Int {
        get { Int(adw_wrap_box_get_natural_line_length(opaquePointer)) }
        set { adw_wrap_box_set_natural_line_length(opaquePointer, Int32(newValue)) }
    }

    /// The unit used for the ``naturalLineLength`` value (e.g., pixels or scale-independent pixels).
    /// - Since: libadwaita 1.7
    public var naturalLineLengthUnit: AdwLengthUnit {
        get { adw_wrap_box_get_natural_line_length_unit(opaquePointer) }
        set { adw_wrap_box_set_natural_line_length_unit(opaquePointer, newValue) }
    }

    /// The direction in which children are packed within each line (start-to-end or end-to-start).
    /// - Since: libadwaita 1.7
    public var packDirection: AdwPackDirection {
        get { adw_wrap_box_get_pack_direction(opaquePointer) }
        set { adw_wrap_box_set_pack_direction(opaquePointer, newValue) }
    }

    /// The policy controlling when children wrap to a new line (minimum size or natural size).
    /// - Since: libadwaita 1.7
    public var wrapPolicy: AdwWrapPolicy {
        get { adw_wrap_box_get_wrap_policy(opaquePointer) }
        set { adw_wrap_box_set_wrap_policy(opaquePointer, newValue) }
    }

    /// Whether new lines are added above (or to the left) instead of below (or to the right).
    /// - Since: libadwaita 1.7
    public var wrapReverse: Bool {
        get { adw_wrap_box_get_wrap_reverse(opaquePointer) != 0 }
        set { adw_wrap_box_set_wrap_reverse(opaquePointer, newValue ? 1 : 0) }
    }

    /// Appends a child widget to the end of the wrap box.
    ///
    /// - Parameter child: The widget to append.
    public func append(_ child: Widget) {
        adw_wrap_box_append(opaquePointer, child.widgetPointer)
    }

    /// Inserts a child widget immediately after a given sibling.
    ///
    /// - Parameter child: The widget to insert.
    /// - Parameter sibling: The existing child to insert after, or `nil` to prepend.
    public func insertChildAfter(_ child: Widget, sibling: Widget?) {
        adw_wrap_box_insert_child_after(opaquePointer, child.widgetPointer, sibling?.widgetPointer)
    }

    /// Prepends a child widget to the beginning of the wrap box.
    ///
    /// - Parameter child: The widget to prepend.
    public func prepend(_ child: Widget) {
        adw_wrap_box_prepend(opaquePointer, child.widgetPointer)
    }

    /// Removes a child widget from the wrap box.
    ///
    /// - Parameter child: The widget to remove.
    public func remove(_ child: Widget) {
        adw_wrap_box_remove(opaquePointer, child.widgetPointer)
    }

    /// Removes all child widgets from the wrap box.
    public func removeAll() {
        adw_wrap_box_remove_all(opaquePointer)
    }

    /// Moves a child widget to the position immediately after a given sibling.
    ///
    /// - Parameter child: The widget to reorder.
    /// - Parameter sibling: The existing child to place after, or `nil` to move to the beginning.
    public func reorderChildAfter(_ child: Widget, sibling: Widget?) {
        adw_wrap_box_reorder_child_after(opaquePointer, child.widgetPointer, sibling?.widgetPointer)
    }
}
