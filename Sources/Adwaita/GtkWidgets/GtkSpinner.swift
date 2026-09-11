// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

/// A spinning indicator for an operation of unknown duration.
///
/// Wraps `GtkSpinner`, which is part of GTK 4 itself and therefore available
/// on every supported runtime. Prefer ``Spinner`` (`AdwSpinner`) when you can
/// require libadwaita 1.6+ — it follows the Adwaita style more closely — but
/// note its initialiser is failable, so an app that supports the 1.5 baseline
/// needs a fallback. ``GtkSpinner`` is that fallback, and is fine as a default
/// choice.
///
/// Unlike `AdwSpinner`, which animates as soon as it is visible, `GtkSpinner`
/// has to be started explicitly:
///
/// ```swift
/// let spinner = GtkSpinner()
/// spinner.spinning = true
///
/// let box = Box(orientation: .horizontal, spacing: 8)
/// box.append(spinner)
/// box.append(Label("Loading…"))
/// ```
///
/// Stop it when the work finishes, so GTK can drop the animation timer:
///
/// ```swift
/// spinner.spinning = false
/// ```
@MainActor
public final class GtkSpinner: Widget {
    override public class var gtkType: GType {
        gtk_spinner_get_type()
    }

    /// Creates a new spinner. It is **not** spinning until ``spinning`` is set.
    public init() {
        let ptr = gtk_spinner_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Whether the spinner is animating.
    ///
    /// A spinner that is not spinning still occupies space; hide the widget
    /// (or swap it out of a ``Stack``) if you want the slot back.
    public var spinning: Bool {
        get { gtk_spinner_get_spinning(opaquePointer) != 0 }
        set { gtk_spinner_set_spinning(opaquePointer, newValue ? 1 : 0) }
    }

    /// Starts the animation. Equivalent to `spinning = true`.
    public func start() {
        gtk_spinner_start(opaquePointer)
    }

    /// Stops the animation. Equivalent to `spinning = false`.
    public func stop() {
        gtk_spinner_stop(opaquePointer)
    }
}
