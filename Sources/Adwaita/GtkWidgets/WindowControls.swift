import CAdwaita
import GObjectSupport

/// A widget displaying window control buttons (close, minimize, maximize).
///
/// Wraps `GtkWindowControls`. Shows the platform's window buttons (close,
/// minimize, maximize) for the specified side of the title bar.
///
/// ```swift
/// // In a custom header bar layout
/// let headerBar = CenterBox()
/// headerBar.startWidget = WindowControls(side: .start)
/// headerBar.centerWidget = Label("My App")
/// headerBar.endWidget = WindowControls(side: .end)
/// ```
@MainActor
public final class WindowControls: Widget {
    /// Creates new window controls.
    ///
    /// - Parameter side: Which side of the title bar (.start or .end).
    public init(side: GtkPackType = GTK_PACK_END) {
        let ptr = gtk_window_controls_new(side)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Which side of the title bar the controls are on.
    public var side: GtkPackType {
        get { gtk_window_controls_get_side(opaquePointer) }
        set { gtk_window_controls_set_side(opaquePointer, newValue) }
    }

    /// The decoration layout (e.g. "icon:minimize,maximize,close").
    public var decorationLayout: String? {
        get {
            guard let cStr = gtk_window_controls_get_decoration_layout(opaquePointer) else { return nil }
            return String(cString: cStr)
        }
        set { gtk_window_controls_set_decoration_layout(opaquePointer, newValue) }
    }

    /// Whether the controls are empty (no buttons shown).
    public var empty: Bool {
        gtk_window_controls_get_empty(opaquePointer) != 0
    }
}
