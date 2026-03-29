import CAdwaita
import GObjectSupport

/// A wrapper for `GtkListItem`, used inside ``SignalListItemFactory`` callbacks.
///
/// In `onSetup`, create widgets and set them as `child`.
/// In `onBind`, read `position` to look up your data and configure the child.
///
/// ```swift
/// let factory = SignalListItemFactory()
/// factory.onSetup { listItem in
///     listItem.child = Label("")
/// }
/// factory.onBind { listItem in
///     let index = listItem.position
///     if let label = listItem.child as? Label {
///         label.text = myData[index]
///     }
/// }
/// ```
@MainActor
public final class ListItem: GObjectRef {

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Wraps an existing `GtkListItem` pointer, adding a ref to borrow it.
    init(borrowedListItem pointer: OpaquePointer) {
        let raw = UnsafeMutableRawPointer(pointer)
        g_object_ref(raw)
        super.init(raw: raw)
    }

    // MARK: - Properties

    /// The widget displayed for this item. Set in `onSetup`, accessed in `onBind`.
    public var child: Widget? {
        get {
            guard let ptr = gtk_list_item_get_child(opaquePointer) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set {
            gtk_list_item_set_child(opaquePointer, newValue?.widgetPointer)
        }
    }

    /// The position of this item in the model. Use in `onBind` to look up your data.
    public var position: Int {
        Int(gtk_list_item_get_position(opaquePointer))
    }

    /// The `GObject` item from the model at this position.
    public var item: GObjectRef? {
        guard let ptr = gtk_list_item_get_item(opaquePointer) else { return nil }
        return GObjectRef(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Whether this item is currently selected.
    public var isSelected: Bool {
        gtk_list_item_get_selected(opaquePointer) != 0
    }
}
