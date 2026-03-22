import CAdwaita
import GObjectSupport

/// A horizontal bar for presenting contextual actions.
///
/// Wraps `GtkActionBar`. Useful for bottom toolbars with start/end/center widgets.
@MainActor
public final class ActionBar: Widget {
    /// Creates a new action bar.
    public init() {
        let ptr = gtk_action_bar_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The center widget.
    public var centerWidget: Widget? {
        get {
            guard let ptr = gtk_action_bar_get_center_widget(opaquePointer) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set { gtk_action_bar_set_center_widget(opaquePointer, newValue?.widgetPointer) }
    }

    /// Whether the action bar is revealed.
    public var revealed: Bool {
        get { gtk_action_bar_get_revealed(opaquePointer) != 0 }
        set { gtk_action_bar_set_revealed(opaquePointer, newValue ? 1 : 0) }
    }

    /// Packs a widget at the start of the action bar.
    public func packStart(_ child: Widget) {
        gtk_action_bar_pack_start(opaquePointer, child.widgetPointer)
    }

    /// Packs a widget at the end of the action bar.
    public func packEnd(_ child: Widget) {
        gtk_action_bar_pack_end(opaquePointer, child.widgetPointer)
    }

    /// Removes a widget from the action bar.
    public func remove(_ child: Widget) {
        gtk_action_bar_remove(opaquePointer, child.widgetPointer)
    }
}
