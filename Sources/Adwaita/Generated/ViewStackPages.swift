// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A collection object representing all pages in a ``ViewStack``.
///
/// Wraps `AdwViewStackPages`. Provides access to the selected page within a
/// ``ViewStack``. This is primarily used internally by view-switching widgets
/// to track and change the current selection.
///
/// ```swift
/// let stack = ViewStack()
/// stack.addTitled(page1Widget, name: "page1", title: "Page 1")
/// stack.addTitled(page2Widget, name: "page2", title: "Page 2")
///
/// // ViewStackPages is obtained from the stack's selection model;
/// // you can read or set the selected page through it.
/// ```
///
/// Key properties:
/// - ``selectedPage``: The currently selected ``ViewStackPage``.
///
/// - Since: libadwaita 1.4
@MainActor
public final class ViewStackPages: GObjectRef {

    /// The currently selected page in the view stack.
    /// - Since: libadwaita 1.4
    public var selectedPage: ViewStackPage? {
        get {
            adw_view_stack_pages_get_selected_page(opaquePointer)
                .map { ViewStackPage(borrowing: UnsafeMutableRawPointer($0)) }
        }
        set { adw_view_stack_pages_set_selected_page(opaquePointer, newValue?.opaquePointer) }
    }
}
