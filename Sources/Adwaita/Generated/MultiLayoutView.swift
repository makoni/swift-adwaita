// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A container that switches between multiple layout arrangements of the same children.
///
/// Wraps `AdwMultiLayoutView`. Holds one or more ``Layout`` objects, each
/// defining a different widget tree that references named ``LayoutSlot``
/// placeholders. Assigning a layout (by object or by name) causes the
/// view to rearrange its children accordingly -- useful for adapting
/// between wide and narrow screen sizes.
///
/// - Note: Requires libadwaita 1.6+. The initializer returns `nil` at runtime
///   if the installed version is too old.
///
/// - Since: libadwaita 1.6
@MainActor
public final class MultiLayoutView: Widget {
    override public class var gtkType: GType {
        adw_multi_layout_view_get_type()
    }


    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `MultiLayoutView`. Returns `nil` if libadwaita < 1.6.
    public init?() {
        guard AdwaitaVersion.isAtLeast(1, 6) else { return nil }
        let ptr = cadw_multi_layout_view_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The currently active layout that determines how children are arranged.
    /// - Since: libadwaita 1.6
    public var layout: Layout? {
        get { cadw_multi_layout_view_get_layout(pointer).map { Layout(borrowing: UnsafeMutableRawPointer($0)) } }
        set { cadw_multi_layout_view_set_layout(pointer, newValue?.pointer) }
    }

    /// The name of the currently active layout, or `nil` if none is set.
    ///
    /// Setting this switches to the layout with the matching name.
    /// - Since: libadwaita 1.6
    public var layoutName: String? {
        get { cadw_multi_layout_view_get_layout_name(pointer).map { String(cString: $0) } }
        set { cadw_multi_layout_view_set_layout_name(pointer, newValue) }
    }

    /// Adds a layout (transfer-full: adds a ref before passing).
    public func addLayout(_ layout: Layout) {
        g_object_ref(layout.pointer)
        cadw_multi_layout_view_add_layout(pointer, layout.pointer)
    }

    /// Returns the child widget assigned to the given slot identifier.
    ///
    /// - Parameter id: The identifier of the ``LayoutSlot`` to look up.
    /// - Returns: The widget assigned to that slot, or `nil` if none is set.
    @discardableResult
    public func getChild(_ id: String) -> Widget? {
        cadw_multi_layout_view_get_child(pointer, id).map { Widget(borrowing: UnsafeMutableRawPointer($0)) }
    }

    /// Returns the layout with the given name.
    @discardableResult
    public func getLayoutByName(_ name: String) -> Layout? {
        cadw_multi_layout_view_get_layout_by_name(pointer, name).map { Layout(borrowing: UnsafeMutableRawPointer($0)) }
    }

    /// Removes a layout.
    public func removeLayout(_ layout: Layout) {
        cadw_multi_layout_view_remove_layout(pointer, layout.pointer)
    }

    /// Assigns a widget to the layout slot with the given identifier.
    ///
    /// - Parameter id: The identifier of the ``LayoutSlot`` to populate.
    /// - Parameter child: The widget to place in that slot.
    public func setChild(_ id: String, child: Widget) {
        cadw_multi_layout_view_set_child(pointer, id, child.widgetPointer)
    }
}
