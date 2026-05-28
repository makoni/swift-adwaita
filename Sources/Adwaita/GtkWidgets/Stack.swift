// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

/// A container that shows one of its children at a time, with optional transitions.
///
/// Wraps `GtkStack`. Useful for multi-page interfaces where only one page
/// is visible at a time. For Adwaita view switchers, use `ViewStack` instead.
///
/// ```swift
/// let stack = Stack()
/// stack.transitionType = GTK_STACK_TRANSITION_TYPE_SLIDE_LEFT_RIGHT
/// stack.transitionDuration = 200
///
/// let page1 = Label("First Page")
/// let page2 = Label("Second Page")
/// stack.addNamed(page1, name: "page1")
/// stack.addNamed(page2, name: "page2")
///
/// // Switch pages by name
/// stack.visibleChildName = "page2"
///
/// // React to page changes
/// stack.onVisibleChildChanged {
///     print("Switched to: \(stack.visibleChildName ?? "unknown")")
/// }
/// ```
@MainActor
public final class Stack: Widget {
    override public class var gtkType: GType {
        gtk_stack_get_type()
    }

    /// Creates a new stack.
    public init() {
        let ptr = gtk_stack_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Adds a child widget. The child can only be shown by setting it as `visibleChild` directly.
    public func addChild(_ child: Widget) {
        gtk_stack_add_child(opaquePointer, child.widgetPointer)
    }

    /// Adds a child with a name, allowing it to be shown via `visibleChildName`.
    public func addNamed(_ child: Widget, name: String) {
        gtk_stack_add_named(opaquePointer, child.widgetPointer, name)
    }

    /// Adds a child with a name and a human-readable title (for use with `GtkStackSwitcher`).
    public func addTitled(_ child: Widget, name: String?, title: String) {
        gtk_stack_add_titled(opaquePointer, child.widgetPointer, name, title)
    }

    /// Removes a child.
    public func remove(_ child: Widget) {
        gtk_stack_remove(opaquePointer, child.widgetPointer)
    }

    /// The visible child widget.
    public var visibleChild: Widget? {
        get {
            guard let ptr = gtk_stack_get_visible_child(opaquePointer) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set { gtk_stack_set_visible_child(opaquePointer, newValue?.widgetPointer) }
    }

    /// The name of the visible child.
    public var visibleChildName: String? {
        get {
            guard let cStr = gtk_stack_get_visible_child_name(opaquePointer) else { return nil }
            return String(cString: cStr)
        }
        set { gtk_stack_set_visible_child_name(opaquePointer, newValue) }
    }

    /// The animation type used when switching pages (e.g. slide, crossfade).
    public var transitionType: GtkStackTransitionType {
        get { gtk_stack_get_transition_type(opaquePointer) }
        set { gtk_stack_set_transition_type(opaquePointer, newValue) }
    }

    /// The transition duration in milliseconds.
    public var transitionDuration: Int {
        get { Int(gtk_stack_get_transition_duration(opaquePointer)) }
        set { gtk_stack_set_transition_duration(opaquePointer, UInt32(newValue)) }
    }

    /// Called when the visible child changes.
    @discardableResult
    public func onVisibleChildChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.onNotify(self, property: .custom("visible-child-name"), handler: handler)
    }
}
