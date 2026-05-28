// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

/// A widget that shows progress as a horizontal filling bar.
///
/// Wraps `GtkProgressBar`. Set ``fraction`` to a value between 0.0 and 1.0
/// for determinate progress, or call ``pulse()`` repeatedly for indeterminate
/// activity indication.
///
/// ```swift
/// // Determinate progress
/// let bar = ProgressBar()
/// bar.fraction = 0.65
/// bar.showText = true
/// bar.text = "65%"
///
/// // Indeterminate (pulsing) progress
/// let spinner = ProgressBar()
/// spinner.pulseStep = 0.1
/// spinner.pulse()  // call repeatedly on a timer
/// ```
@MainActor
public final class ProgressBar: Widget {
    override public class var gtkType: GType {
        gtk_progress_bar_get_type()
    }

    /// Creates a new progress bar.
    public init() {
        let ptr = gtk_progress_bar_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The fraction of work completed (0.0 to 1.0).
    public var fraction: Double {
        get { gtk_progress_bar_get_fraction(opaquePointer) }
        set { gtk_progress_bar_set_fraction(opaquePointer, newValue) }
    }

    /// Whether to pulse the progress bar.
    public func pulse() {
        gtk_progress_bar_pulse(opaquePointer)
    }

    /// The fraction for each pulse step.
    public var pulseStep: Double {
        get { gtk_progress_bar_get_pulse_step(opaquePointer) }
        set { gtk_progress_bar_set_pulse_step(opaquePointer, newValue) }
    }

    /// Whether to show text on the progress bar.
    public var showText: Bool {
        get { gtk_progress_bar_get_show_text(opaquePointer) != 0 }
        set { gtk_progress_bar_set_show_text(opaquePointer, newValue ? 1 : 0) }
    }

    /// The text displayed on the progress bar.
    public var text: String? {
        get {
            guard let cStr = gtk_progress_bar_get_text(opaquePointer) else { return nil }
            return String(cString: cStr)
        }
        set { gtk_progress_bar_set_text(opaquePointer, newValue) }
    }

    /// Whether the progress bar is inverted.
    public var inverted: Bool {
        get { gtk_progress_bar_get_inverted(opaquePointer) != 0 }
        set { gtk_progress_bar_set_inverted(opaquePointer, newValue ? 1 : 0) }
    }

    /// The ellipsize mode.
    public var ellipsize: PangoEllipsizeMode {
        get { gtk_progress_bar_get_ellipsize(opaquePointer) }
        set { gtk_progress_bar_set_ellipsize(opaquePointer, newValue) }
    }

    /// Emitted when the fraction changes.
    ///
    /// - Parameter handler: Called when the progress fraction changes.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onFractionChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.onNotify(self, property: .custom("fraction"), handler: handler)
    }
}
