import CAdwaita
import GObjectSupport

/// A button that opens a font dialog when clicked and displays the selected font.
///
/// Wraps `GtkFontDialogButton` (GTK 4.10+). Shows the currently selected font
/// and opens a system font chooser dialog when the user clicks it.
///
/// ```swift
/// let fontButton = FontDialogButton()
/// fontButton.fontDescription = "Sans 12"
///
/// fontButton.onFontChanged {
///     if let font = fontButton.fontDescription {
///         print("Selected font: \(font)")
///     }
/// }
///
/// box.append(fontButton)
/// ```
@MainActor
public final class FontDialogButton: Widget {
    /// Creates a new font dialog button.
    public init(dialog: FontDialog? = nil) {
        let dlg: OpaquePointer
        if let dialog {
            g_object_ref(dialog.pointer)
            dlg = dialog.opaquePointer
        } else {
            dlg = gtk_font_dialog_new()!
        }
        let ptr = gtk_font_dialog_button_new(dlg)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The currently selected font as a Pango font description string.
    public var fontDescription: String? {
        get {
            guard let desc = gtk_font_dialog_button_get_font_desc(opaquePointer) else { return nil }
            let cStr = pango_font_description_to_string(desc)
            defer { if let cStr { g_free(gpointer(mutating: cStr)) } }
            return cStr.map { String(cString: $0) }
        }
        set {
            if let newValue {
                let desc = pango_font_description_from_string(newValue)
                gtk_font_dialog_button_set_font_desc(opaquePointer, desc)
                if let desc { pango_font_description_free(desc) }
            }
        }
    }

    /// Emitted when the selected font changes.
    ///
    /// - Parameter handler: Called when a new font is selected.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onFontChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.onNotify(self, property: .fontDesc, handler: handler)
    }
}
