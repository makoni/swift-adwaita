// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

/// A button that opens a color dialog when clicked and displays the selected color.
///
/// Wraps `GtkColorDialogButton` (GTK 4.10+). Displays a color swatch and
/// opens a system color chooser dialog when the user clicks it.
///
/// ```swift
/// let colorButton = ColorDialogButton()
/// colorButton.rgba = RGBA(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
///
/// colorButton.onColorChanged {
///     let color = colorButton.rgba
///     print("Selected color: R=\(color.red) G=\(color.green) B=\(color.blue)")
/// }
///
/// box.append(colorButton)
/// ```
@MainActor
public final class ColorDialogButton: Widget {
    /// Creates a new color dialog button.
    public init(dialog: ColorDialog? = nil) {
        let dlg: OpaquePointer
        if let dialog {
            g_object_ref(dialog.pointer)
            dlg = dialog.opaquePointer
        } else {
            dlg = gtk_color_dialog_new()!
        }
        let ptr = gtk_color_dialog_button_new(dlg)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The currently selected color.
    public var rgba: RGBA {
        get {
            let gdkColor = gtk_color_dialog_button_get_rgba(opaquePointer)!
            return RGBA(
                red: Double(gdkColor.pointee.red),
                green: Double(gdkColor.pointee.green),
                blue: Double(gdkColor.pointee.blue),
                alpha: Double(gdkColor.pointee.alpha)
            )
        }
        set {
            var gdkColor = GdkRGBA(
                red: Float(newValue.red),
                green: Float(newValue.green),
                blue: Float(newValue.blue),
                alpha: Float(newValue.alpha)
            )
            gtk_color_dialog_button_set_rgba(opaquePointer, &gdkColor)
        }
    }

    /// Emitted when the selected color changes.
    ///
    /// - Parameter handler: Called when a new color is selected.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onColorChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.onNotify(self, property: .rgba, handler: handler)
    }
}
