// Auto-generated intermediate GTK class wrapper
import CAdwaita
import GObjectSupport

/// A row in a `ListBox`.
@MainActor
public class ListBoxRow: Widget {
    /// The index of this row, or -1 if not in a list box.
    public var index: Int {
        Int(gtk_list_box_row_get_index(castedPointer() as UnsafeMutablePointer<GtkListBoxRow>))
    }

    /// Whether this row is selected.
    public var isSelected: Bool {
        gtk_list_box_row_get_selectable(castedPointer() as UnsafeMutablePointer<GtkListBoxRow>) != 0
    }

    /// The child widget.
    public var child: Widget? {
        get {
            guard let ptr = gtk_list_box_row_get_child(castedPointer() as UnsafeMutablePointer<GtkListBoxRow>) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set {
            gtk_list_box_row_set_child(castedPointer() as UnsafeMutablePointer<GtkListBoxRow>, newValue?.widgetPointer)
        }
    }
}
