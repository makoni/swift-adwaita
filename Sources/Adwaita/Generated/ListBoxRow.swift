// Auto-generated intermediate GTK class wrapper
import CAdwaita
import GObjectSupport

/// A row in a `ListBox`.
@MainActor
public class ListBoxRow: Widget {
    /// Creates a new list box row.
    public init() {
        let ptr = gtk_list_box_row_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

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

    /// The header widget displayed above this row.
    ///
    /// Set by the header function passed to `ListBox.setHeaderFunc()`.
    public var header: Widget? {
        get {
            guard let ptr = gtk_list_box_row_get_header(castedPointer() as UnsafeMutablePointer<GtkListBoxRow>) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set {
            gtk_list_box_row_set_header(castedPointer() as UnsafeMutablePointer<GtkListBoxRow>, newValue?.widgetPointer)
        }
    }

    /// Whether this row is activatable by the user.
    public var activatable: Bool {
        get { gtk_list_box_row_get_activatable(castedPointer() as UnsafeMutablePointer<GtkListBoxRow>) != 0 }
        set { gtk_list_box_row_set_activatable(castedPointer() as UnsafeMutablePointer<GtkListBoxRow>, newValue ? 1 : 0) }
    }

    /// Whether this row can be selected.
    public var selectable: Bool {
        get { gtk_list_box_row_get_selectable(castedPointer() as UnsafeMutablePointer<GtkListBoxRow>) != 0 }
        set { gtk_list_box_row_set_selectable(castedPointer() as UnsafeMutablePointer<GtkListBoxRow>, newValue ? 1 : 0) }
    }

    /// Marks this row as changed, triggering filter/sort/header re-evaluation.
    public func changed() {
        gtk_list_box_row_changed(castedPointer() as UnsafeMutablePointer<GtkListBoxRow>)
    }
}
