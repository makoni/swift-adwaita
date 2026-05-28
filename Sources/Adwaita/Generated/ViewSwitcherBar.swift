// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A bottom bar that acts as a view switcher for a ``ViewStack``.
///
/// Wraps `AdwViewSwitcherBar`. Designed to sit at the bottom of the window
/// and provide a narrow-layout fallback for ``ViewSwitcher``. When the header
/// bar's ``ViewSwitcher`` is too narrow to display properly, set
/// ``reveal`` to `true` to show this bottom bar instead.
///
/// ```swift
/// let stack = ViewStack()
/// stack.addTitledWithIcon(page1, name: "p1",
///                         title: "Page 1", iconName: "view-list-symbolic")
/// stack.addTitledWithIcon(page2, name: "p2",
///                         title: "Page 2", iconName: "view-grid-symbolic")
///
/// let switcherBar = ViewSwitcherBar()
/// switcherBar.stack = stack
///
/// // Reveal the bottom bar on narrow windows
/// switcherBar.reveal = true
///
/// // Layout: stack on top, switcher bar at the bottom
/// let box = Box(orientation: .vertical, spacing: 0)
/// box.append(stack)
/// box.append(switcherBar)
/// ```
///
/// Key properties:
/// - ``stack``: The ``ViewStack`` whose pages are displayed as buttons.
/// - ``reveal``: Whether the bottom bar is visible.
@MainActor
public final class ViewSwitcherBar: Widget {
    override public class var gtkType: GType {
        adw_view_switcher_bar_get_type()
    }

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ViewSwitcherBar`.
    public init() {
        let ptr = adw_view_switcher_bar_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Whether the bottom switcher bar is visible.
    public var reveal: Bool {
        get { adw_view_switcher_bar_get_reveal(opaquePointer) != 0 }
        set { adw_view_switcher_bar_set_reveal(opaquePointer, newValue ? 1 : 0) }
    }

    /// The ``ViewStack`` whose pages are displayed as buttons in the bar.
    public var stack: ViewStack? {
        get { adw_view_switcher_bar_get_stack(opaquePointer).map { ViewStack(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_view_switcher_bar_set_stack(opaquePointer, newValue?.opaquePointer) }
    }
}
