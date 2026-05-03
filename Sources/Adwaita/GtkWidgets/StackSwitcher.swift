// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

/// A widget that shows buttons for switching between pages of a `Stack`.
///
/// Wraps `GtkStackSwitcher`. Automatically creates a button for each
/// page in the associated ``Stack``.
///
/// ```swift
/// let stack = Stack()
/// stack.addTitled(Label("Page 1"), name: "page1", title: "First")
/// stack.addTitled(Label("Page 2"), name: "page2", title: "Second")
///
/// let switcher = StackSwitcher()
/// switcher.stack = stack
///
/// let vbox = Box(orientation: .vertical)
/// vbox.append(switcher)
/// vbox.append(stack)
/// ```
@MainActor
public final class StackSwitcher: Widget {
    /// Creates a new stack switcher.
    public init() {
        let ptr = gtk_stack_switcher_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The stack to switch between pages of.
    public var stack: Stack? {
        get {
            guard let ptr = gtk_stack_switcher_get_stack(opaquePointer) else { return nil }
            return Stack(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set { gtk_stack_switcher_set_stack(opaquePointer, newValue?.opaquePointer) }
    }
}
