// Auto-generated intermediate GTK class wrapper
import CAdwaita
import GObjectSupport

/// A single row inside a `ListBox`.
///
/// Wraps `GtkListBoxRow`. The base row widget for `ListBox`. Each row holds
/// a child widget and can be made activatable, selectable, or given a custom
/// header. Subclassed by ``PreferencesRow`` and its descendants for richer
/// list-based UIs.
///
/// ```swift
/// let row = ListBoxRow()
///
/// let label = Label(str: "Item 1")
/// row.child = label
/// row.activatable = true
/// row.selectable = true
///
/// listBox.append(row)
/// ```
///
/// - Key properties:
///   - ``child``: The child widget displayed inside the row.
///   - ``activatable``: Whether the row can be activated by the user.
///   - ``selectable``: Whether the row can be selected.
///   - ``index``: The position of this row in its parent list box (read-only).
///   - ``header``: A header widget displayed above the row.
/// - Key methods:
///   - ``changed()``: Marks the row as changed to trigger filter/sort re-evaluation.
@MainActor
public class ListBoxRow: Widget {
    /// Creates a new list box row.
    public init() {
        let ptr = gtk_list_box_row_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
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
        set {
            gtk_list_box_row_set_activatable(castedPointer() as UnsafeMutablePointer<GtkListBoxRow>, newValue ? 1 : 0)
        }
    }

    /// Whether this row can be selected.
    public var selectable: Bool {
        get { gtk_list_box_row_get_selectable(castedPointer() as UnsafeMutablePointer<GtkListBoxRow>) != 0 }
        set { gtk_list_box_row_set_selectable(castedPointer() as UnsafeMutablePointer<GtkListBoxRow>, newValue ? 1 : 0)
        }
    }

    /// Marks this row as changed, triggering filter/sort/header re-evaluation.
    public func changed() {
        gtk_list_box_row_changed(castedPointer() as UnsafeMutablePointer<GtkListBoxRow>)
    }
}
