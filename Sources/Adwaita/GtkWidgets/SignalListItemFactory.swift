import CAdwaita
import GObjectSupport

/// A factory that creates and binds widgets for ``ListView`` items via signals.
///
/// Use `onSetup` to create the widget structure (called once per recycled slot)
/// and `onBind` to populate widgets with data (called when an item scrolls into view).
///
/// ```swift
/// let factory = SignalListItemFactory()
/// factory.onSetup { listItem in
///     let label = Label("")
///     label.hexpand = true
///     listItem.child = label
/// }
/// factory.onBind { listItem in
///     let message = messages[listItem.position]
///     // Update the child widget with data
/// }
/// ```
@MainActor
public final class SignalListItemFactory: GObjectRef {

    /// Creates a new signal-based list item factory.
    public init() {
        let ptr = gtk_signal_list_item_factory_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Called when a new widget slot is created. Create your widget structure here.
    ///
    /// The `ListItem.child` should be set to the root widget of your item layout.
    /// This is called once per recycled slot, not once per data item.
    @discardableResult
    public func onSetup(_ handler: @escaping @MainActor (ListItem) -> Void) -> SignalConnection {
        SignalHelper.connectPointer(self, signal: .setup) { ptr in
            let listItem = ListItem(borrowedListItem: ptr)
            handler(listItem)
        }
    }

    /// Called when a data item is bound to a widget slot. Populate the widget here.
    ///
    /// Use `listItem.position` to look up your data in a parallel Swift array,
    /// then configure the child widget accordingly.
    @discardableResult
    public func onBind(_ handler: @escaping @MainActor (ListItem) -> Void) -> SignalConnection {
        SignalHelper.connectPointer(self, signal: .bind) { ptr in
            let listItem = ListItem(borrowedListItem: ptr)
            handler(listItem)
        }
    }

    /// Called when a data item is unbound from a widget slot (optional).
    ///
    /// Use this to clean up any state set during `onBind`.
    @discardableResult
    public func onUnbind(_ handler: @escaping @MainActor (ListItem) -> Void) -> SignalConnection {
        SignalHelper.connectPointer(self, signal: .unbind) { ptr in
            let listItem = ListItem(borrowedListItem: ptr)
            handler(listItem)
        }
    }

    /// Called when a widget slot is destroyed (optional).
    @discardableResult
    public func onTeardown(_ handler: @escaping @MainActor (ListItem) -> Void) -> SignalConnection {
        SignalHelper.connectPointer(self, signal: .teardown) { ptr in
            let listItem = ListItem(borrowedListItem: ptr)
            handler(listItem)
        }
    }
}
