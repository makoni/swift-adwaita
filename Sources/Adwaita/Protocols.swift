import CAdwaita
import GObjectSupport

/// A type that can be used as a `GListModel` source for selection models,
/// filter/sort wrappers, and list views.
///
/// Conform to this protocol to allow your model to be passed directly
/// to ``SingleSelection``, ``NoSelection``, ``MultiSelection``,
/// ``FilterListModel``, ``SortListModel``, and other list-model consumers
/// without requiring an ``OpaquePointer``.
///
/// All conforming types must be ``GObjectRef`` subclasses.
@MainActor
public protocol ListModelConvertible: AnyObject {}

public extension ListModelConvertible {
    /// The underlying `GListModel` pointer.
    var listModelPointer: OpaquePointer {
        (self as! GObjectRef).opaquePointer
    }
}

/// A type that can be used as a `GtkSelectionModel` source for list views,
/// grid views, and column views.
///
/// Conform to this protocol to allow your selection model to be passed
/// directly to ``ListView``, ``GridView``, and ``ColumnView`` without
/// requiring an ``OpaquePointer``.
///
/// All conforming types must be ``GObjectRef`` subclasses.
@MainActor
public protocol SelectionModelConvertible: AnyObject {}

public extension SelectionModelConvertible {
    /// The underlying `GtkSelectionModel` pointer.
    var selectionModelPointer: OpaquePointer {
        (self as! GObjectRef).opaquePointer
    }
}

/// A widget that can contain child widgets via `append` and `remove`.
///
/// Conform to this protocol for widgets that support dynamically adding
/// and removing child widgets. Conforming types include ``Box``,
/// ``ListBox``, ``FlowBox``, ``WrapBox``, and ``Carousel``.
@MainActor
public protocol Container: AnyObject {
    /// Adds a child widget.
    func append(_ child: Widget)
    /// Removes a child widget.
    func remove(_ child: Widget)
}

/// A widget that supports swipe gestures via ``SwipeTracker``.
///
/// Conform to this protocol to allow your widget to be used as
/// the swipeable target for a ``SwipeTracker``.
///
/// All conforming types must be ``GObjectRef`` subclasses.
@MainActor
public protocol Swipeable: AnyObject {}

public extension Swipeable {
    /// The underlying `AdwSwipeable` pointer.
    var swipeablePointer: OpaquePointer {
        (self as! GObjectRef).opaquePointer
    }
}
