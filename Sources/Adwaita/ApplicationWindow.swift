// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

/// The main window for an Adwaita application.
///
/// Wraps `AdwApplicationWindow`, which provides adaptive layout features
/// (breakpoints, split views) on top of `GtkApplicationWindow`.
///
/// Inherits all window management from ``GtkWindow`` — title, sizing,
/// fullscreen, modal, close request, transient parent, and more.
///
/// ```swift
/// let window = ApplicationWindow(application: app, title: "My App", width: 800, height: 600)
///
/// let toolbar = ToolbarView()
/// toolbar.addTopBar(HeaderBar())
/// toolbar.content = myContentWidget
/// window.setContent(toolbar)
/// window.present()
/// ```
@MainActor
public final class ApplicationWindow: GtkWindow {
    /// Creates a new application window.
    ///
    /// - Parameter application: The application this window belongs to.
    public init(application: Application) {
        let ptr = adw_application_window_new(application.gtkApplicationPointer)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a new application window with title and default size.
    ///
    /// - Parameters:
    ///   - application: The application this window belongs to.
    ///   - title: The window title.
    ///   - width: The default width in pixels. Defaults to 800.
    ///   - height: The default height in pixels. Defaults to 600.
    public convenience init(application: Application, title: String, width: Int = 800, height: Int = 600) {
        self.init(application: application)
        self.title = title
        setDefaultSize(width: width, height: height)
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The underlying `AdwApplicationWindow` pointer.
    public var adwWindowPointer: UnsafeMutablePointer<AdwApplicationWindow> {
        castedPointer()
    }

    /// The content widget of the window.
    public var content: Widget? {
        get {
            guard let ptr = adw_application_window_get_content(adwWindowPointer) else {
                return nil
            }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set {
            adw_application_window_set_content(adwWindowPointer, newValue?.widgetPointer)
        }
    }

    /// Sets the content widget of the window.
    public func setContent(_ widget: Widget) {
        adw_application_window_set_content(adwWindowPointer, widget.widgetPointer)
    }

    /// Registers a responsive breakpoint on this window.
    ///
    /// When the condition is met, the breakpoint applies its setters
    /// (see ``Breakpoint/addSetter(_:property:value:)-(_,_,Bool)``) and
    /// reverts them when it no longer matches. Mirrors the `addBreakpoint`
    /// method already exposed on ``Window``; `AdwApplicationWindow`
    /// inherits the same C machinery from `AdwWindow`.
    ///
    /// ```swift
    /// let compact = Breakpoint.maxWidth(600)
    /// compact.addSetter(saveButton, property: .visible, value: false)
    /// window.addBreakpoint(compact)
    /// ```
    public func addBreakpoint(_ breakpoint: Breakpoint) {
        g_object_ref(breakpoint.pointer)
        adw_application_window_add_breakpoint(adwWindowPointer, breakpoint.opaquePointer)
    }
}
