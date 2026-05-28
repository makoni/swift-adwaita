// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A stack of named views, typically driven by a ``ViewSwitcher``.
///
/// Wraps `AdwViewStack`. Holds multiple child widgets as named pages and
/// displays one at a time. Each page can have a title and icon that a
/// connected ``ViewSwitcher``, ``ViewSwitcherBar``, or ``InlineViewSwitcher``
/// uses to build its toggle buttons.
///
/// ```swift
/// let stack = ViewStack()
///
/// // Add pages with names, titles, and icons
/// stack.addTitledWithIcon(inboxView, name: "inbox",
///                         title: "Inbox", iconName: "mail-inbox-symbolic")
/// stack.addTitledWithIcon(sentView, name: "sent",
///                         title: "Sent", iconName: "mail-sent-symbolic")
/// stack.addTitledWithIcon(draftsView, name: "drafts",
///                         title: "Drafts", iconName: "mail-drafts-symbolic")
///
/// // Switch pages by name
/// stack.visibleChildName = "sent"
///
/// // Connect a view switcher
/// let switcher = ViewSwitcher()
/// switcher.stack = stack
/// ```
///
/// Key properties:
/// - ``visibleChild`` / ``visibleChildName``: The currently displayed page.
/// - ``hhomogeneous`` / ``vhomogeneous``: Whether all pages share the same size.
/// - ``enableTransitions`` / ``transitionDuration``: Animated transitions between pages.
///
/// Key methods:
/// - ``addTitledWithIcon(_:name:title:iconName:)``: Add a page with full metadata.
/// - ``addTitled(_:name:title:)`` / ``addNamed(_:name:)`` / ``add(_:)``: Simpler variants.
/// - ``remove(_:)``: Remove a child from the stack.
/// - ``getPage(_:)`` / ``getChildByName(_:)``: Look up pages or children.
@MainActor
public final class ViewStack: Widget {
    override public class var gtkType: GType {
        adw_view_stack_get_type()
    }


    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `ViewStack`.
    public init() {
        let ptr = adw_view_stack_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Whether animated transitions are enabled when switching pages.
    /// - Since: libadwaita 1.7
    public var enableTransitions: Bool {
        get { adw_view_stack_get_enable_transitions(opaquePointer) != 0 }
        set { adw_view_stack_set_enable_transitions(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether all pages are the same width as the widest page.
    public var hhomogeneous: Bool {
        get { adw_view_stack_get_hhomogeneous(opaquePointer) != 0 }
        set { adw_view_stack_set_hhomogeneous(opaquePointer, newValue ? 1 : 0) }
    }

    /// The duration of page transition animations, in milliseconds.
    /// - Since: libadwaita 1.7
    public var transitionDuration: Int {
        get { Int(adw_view_stack_get_transition_duration(opaquePointer)) }
        set { adw_view_stack_set_transition_duration(opaquePointer, UInt32(newValue)) }
    }

    /// Whether a page transition animation is currently in progress (read-only).
    /// - Since: libadwaita 1.7
    public var transitionRunning: Bool {
        adw_view_stack_get_transition_running(opaquePointer) != 0
    }

    /// Whether all pages are the same height as the tallest page.
    public var vhomogeneous: Bool {
        get { adw_view_stack_get_vhomogeneous(opaquePointer) != 0 }
        set { adw_view_stack_set_vhomogeneous(opaquePointer, newValue ? 1 : 0) }
    }

    /// The currently visible child widget.
    public var visibleChild: Widget? {
        get { adw_view_stack_get_visible_child(opaquePointer).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_view_stack_set_visible_child(opaquePointer, newValue?.widgetPointer) }
    }

    /// The name of the currently visible child.
    public var visibleChildName: String? {
        get { adw_view_stack_get_visible_child_name(opaquePointer).map { String(cString: $0) } }
        set { adw_view_stack_set_visible_child_name(opaquePointer, newValue) }
    }

    /// Adds a child widget without a name or title.
    ///
    /// - Parameter child: The widget to add.
    /// - Returns: The ``ViewStackPage`` for the new child.
    @discardableResult
    public func add(_ child: Widget) -> ViewStackPage {
        let ptr = adw_view_stack_add(opaquePointer, child.widgetPointer)!
        return ViewStackPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Adds a child widget with a name, allowing it to be shown via ``visibleChildName``.
    ///
    /// - Parameter child: The widget to add.
    /// - Parameter name: The name to identify this page.
    /// - Returns: The ``ViewStackPage`` for the new child.
    @discardableResult
    public func addNamed(_ child: Widget, name: String?) -> ViewStackPage {
        let ptr = adw_view_stack_add_named(opaquePointer, child.widgetPointer, name)!
        return ViewStackPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Adds a child widget with a name and title for use with ``ViewSwitcher``.
    ///
    /// - Parameter child: The widget to add.
    /// - Parameter name: The name to identify this page.
    /// - Parameter title: The human-readable title shown in switchers.
    /// - Returns: The ``ViewStackPage`` for the new child.
    @discardableResult
    public func addTitled(_ child: Widget, name: String?, title: String) -> ViewStackPage {
        let ptr = adw_view_stack_add_titled(opaquePointer, child.widgetPointer, name, title)!
        return ViewStackPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Adds a child with a name, title, and icon for use with ``ViewSwitcher``.
    ///
    /// - Parameter child: The widget to add.
    /// - Parameter name: The name to identify this page.
    /// - Parameter title: The human-readable title shown in switchers.
    /// - Parameter iconName: The icon name shown alongside the title.
    /// - Returns: The ``ViewStackPage`` for the new child.
    @discardableResult
    public func addTitledWithIcon(_ child: Widget, name: String?, title: String, iconName: String) -> ViewStackPage {
        let ptr = adw_view_stack_add_titled_with_icon(opaquePointer, child.widgetPointer, name, title, iconName)!
        return ViewStackPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Returns the child widget with the given name, or `nil` if not found.
    ///
    /// - Parameter name: The page name to look up.
    /// - Returns: The child widget, or `nil` if no page has that name.
    @discardableResult
    public func getChildByName(_ name: String) -> Widget? {
        adw_view_stack_get_child_by_name(opaquePointer, name).map { Widget(borrowing: UnsafeMutableRawPointer($0)) }
    }

    /// Returns the ``ViewStackPage`` metadata for the given child widget.
    ///
    /// - Parameter child: The child widget to look up.
    /// - Returns: The page object containing the child's title, icon, etc.
    @discardableResult
    public func getPage(_ child: Widget) -> ViewStackPage {
        let ptr = adw_view_stack_get_page(opaquePointer, child.widgetPointer)!
        return ViewStackPage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Removes a child widget from the stack.
    ///
    /// - Parameter child: The child widget to remove.
    public func remove(_ child: Widget) {
        adw_view_stack_remove(opaquePointer, child.widgetPointer)
    }
}
