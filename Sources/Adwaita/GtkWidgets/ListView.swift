import CAdwaita
import GObjectSupport

/// A virtualized, scrollable list widget backed by a `GListModel`.
///
/// Wraps `GtkListView`. Unlike ``ListBox``, `ListView` only creates widgets
/// for visible items and recycles them during scrolling — making it suitable
/// for lists with thousands of items.
///
/// ```swift
/// // 1. Data
/// var messages: [Message] = [...]
///
/// // 2. Store (one proxy object per item)
/// let store = ListStore()
/// for _ in messages { store.appendPlaceholder() }
///
/// // 3. Factory (create & bind widgets)
/// let factory = SignalListItemFactory()
/// factory.onSetup { listItem in
///     listItem.child = Label("")
/// }
/// factory.onBind { listItem in
///     let msg = messages[listItem.position]
///     (listItem.child as? Label)?.text = msg.text
/// }
///
/// // 4. Selection + View
/// let selection = NoSelection(model: store)
/// let listView = ListView(model: selection, factory: factory)
/// ```
@MainActor
public final class ListView: Widget {

    /// Creates a list view with a selection model and item factory.
    public init(model: SingleSelection, factory: SignalListItemFactory) {
        let ptr = gtk_list_view_new(nil, nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_list_view_set_model(OpaquePointer(pointer), model.selectionModelPointer)
        gtk_list_view_set_factory(OpaquePointer(pointer), OpaquePointer(factory.pointer))
    }

    /// Creates a list view with no selection and an item factory.
    public init(model: NoSelection, factory: SignalListItemFactory) {
        let ptr = gtk_list_view_new(nil, nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_list_view_set_model(OpaquePointer(pointer), model.selectionModelPointer)
        gtk_list_view_set_factory(OpaquePointer(pointer), OpaquePointer(factory.pointer))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    // MARK: - Properties

    /// Whether to show separators between items.
    public var showSeparators: Bool {
        get { gtk_list_view_get_show_separators(opaquePointer) != 0 }
        set { gtk_list_view_set_show_separators(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether items are activated on single click (vs double click).
    public var singleClickActivate: Bool {
        get { gtk_list_view_get_single_click_activate(opaquePointer) != 0 }
        set { gtk_list_view_set_single_click_activate(opaquePointer, newValue ? 1 : 0) }
    }

    // MARK: - Signals

    /// Called when an item is activated (clicked or Enter pressed).
    ///
    /// The parameter is the position of the activated item.
    @discardableResult
    public func onActivate(_ handler: @escaping @MainActor (Int) -> Void) -> SignalConnection {
        SignalHelper.connectUInt(self, signal: "activate") { position in
            handler(Int(position))
        }
    }

    // MARK: - Scrolling

    /// Scrolls to the item at the given position.
    public func scrollTo(_ position: Int, flags: GtkListScrollFlags = GTK_LIST_SCROLL_NONE) {
        gtk_list_view_scroll_to(opaquePointer, UInt32(position), flags, nil)
    }

}
