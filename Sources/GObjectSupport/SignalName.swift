/// Type-safe signal names for GObject/GTK/libadwaita signals.
///
/// Eliminates raw string literals from signal connection calls.
/// Use `.custom(String)` for signals not covered by the predefined cases.
///
/// ```swift
/// // Use predefined signal names
/// SignalHelper.connect(button, signal: .clicked) {
///     print("Clicked")
/// }
///
/// // Observe property changes via notify
/// SignalHelper.connect(entry, signal: .notify("text")) {
///     print("Text property changed")
/// }
///
/// // Use a custom signal name for signals not in the enum
/// SignalHelper.connect(widget, signal: .custom("my-signal")) {
///     print("Custom signal fired")
/// }
/// ```
public enum SignalName: Sendable, Equatable {

    // MARK: - Application & Window lifecycle

    case activate
    case open
    case startup
    case shutdown
    case closeRequest
    case realize
    case unrealize
    case map
    case unmap
    case destroy

    // MARK: - Button & Click signals

    case clicked
    case pressed
    case released
    case toggled
    case cancelled

    // MARK: - Activation

    case activated
    case activateLink
    case entryActivated

    // MARK: - Text & Input

    case changed
    case searchChanged
    case apply
    case iconPress
    case modifiedChanged

    // MARK: - Value signals

    case valueChanged

    // MARK: - List & Selection

    case rowActivated
    case rowSelected
    case childActivated
    case selectedChildrenChanged
    case selectionChanged

    // MARK: - Dialog & Popover

    case closeAttempt
    case closed
    case response

    // MARK: - Toast & Banner

    case buttonClicked
    case dismissed

    // MARK: - Drag & Drop

    case dragBegin
    case dragUpdate
    case dragEnd
    case dragCancel
    case drop

    // MARK: - Navigation

    case pushed
    case popped
    case replaced
    case getNextPage
    case hidden
    case hiding
    case showing
    case shown

    // MARK: - Tab / Page management

    case closePage
    case createTab
    case createWindow
    case indicatorActivated
    case pageAttached
    case pageChanged
    case pageDetached
    case pageReordered
    case setupMenu

    // MARK: - Swipe

    case beginSwipe
    case endSwipe
    case updateSwipe
    case prepare
    case swipe

    // MARK: - List item factory

    case setup
    case bind
    case unbind
    case teardown

    // MARK: - Gesture / Event controller

    case enter
    case leave
    case motion
    case keyPressed
    case keyReleased
    case scroll
    case scrollBegin
    case scrollEnd

    // MARK: - Calendar

    case daySelected
    case prevMonth
    case nextMonth
    case prevYear
    case nextYear

    // MARK: - Notebook

    case switchPage

    // MARK: - SpinRow

    case input
    case output
    case wrapped

    // MARK: - Animation

    case done

    // MARK: - Extra drag (TabBar / TabOverview)

    case extraDragDrop
    case extraDragValue

    // MARK: - Other

    case emojiPicked
    case invalidate
    case unapply

    // MARK: - Property notification

    /// Property change notification (`notify::property-name`).
    case notify(String)

    // MARK: - Custom

    /// A signal name not covered by the predefined cases.
    case custom(String)

    /// The GLib signal name string passed to `g_signal_connect`.
    public var name: String {
        switch self {
        // Application & Window lifecycle
        case .activate: "activate"
        case .open: "open"
        case .startup: "startup"
        case .shutdown: "shutdown"
        case .closeRequest: "close-request"
        case .realize: "realize"
        case .unrealize: "unrealize"
        case .map: "map"
        case .unmap: "unmap"
        case .destroy: "destroy"
        // Button & Click
        case .clicked: "clicked"
        case .pressed: "pressed"
        case .released: "released"
        case .toggled: "toggled"
        case .cancelled: "cancelled"
        // Activation
        case .activated: "activated"
        case .activateLink: "activate-link"
        case .entryActivated: "entry-activated"
        // Text & Input
        case .changed: "changed"
        case .searchChanged: "search-changed"
        case .apply: "apply"
        case .iconPress: "icon-press"
        case .modifiedChanged: "modified-changed"
        // Value
        case .valueChanged: "value-changed"
        // List & Selection
        case .rowActivated: "row-activated"
        case .rowSelected: "row-selected"
        case .childActivated: "child-activated"
        case .selectedChildrenChanged: "selected-children-changed"
        case .selectionChanged: "selection-changed"
        // Dialog & Popover
        case .closeAttempt: "close-attempt"
        case .closed: "closed"
        case .response: "response"
        // Toast & Banner
        case .buttonClicked: "button-clicked"
        case .dismissed: "dismissed"
        // Drag & Drop
        case .dragBegin: "drag-begin"
        case .dragUpdate: "drag-update"
        case .dragEnd: "drag-end"
        case .dragCancel: "drag-cancel"
        case .drop: "drop"
        // Navigation
        case .pushed: "pushed"
        case .popped: "popped"
        case .replaced: "replaced"
        case .getNextPage: "get-next-page"
        case .hidden: "hidden"
        case .hiding: "hiding"
        case .showing: "showing"
        case .shown: "shown"
        // Tab / Page management
        case .closePage: "close-page"
        case .createTab: "create-tab"
        case .createWindow: "create-window"
        case .indicatorActivated: "indicator-activated"
        case .pageAttached: "page-attached"
        case .pageChanged: "page-changed"
        case .pageDetached: "page-detached"
        case .pageReordered: "page-reordered"
        case .setupMenu: "setup-menu"
        // Swipe
        case .beginSwipe: "begin-swipe"
        case .endSwipe: "end-swipe"
        case .updateSwipe: "update-swipe"
        case .prepare: "prepare"
        case .swipe: "swipe"
        // List item factory
        case .setup: "setup"
        case .bind: "bind"
        case .unbind: "unbind"
        case .teardown: "teardown"
        // Gesture / Event controller
        case .enter: "enter"
        case .leave: "leave"
        case .motion: "motion"
        case .keyPressed: "key-pressed"
        case .keyReleased: "key-released"
        case .scroll: "scroll"
        case .scrollBegin: "scroll-begin"
        case .scrollEnd: "scroll-end"
        // Calendar
        case .daySelected: "day-selected"
        case .prevMonth: "prev-month"
        case .nextMonth: "next-month"
        case .prevYear: "prev-year"
        case .nextYear: "next-year"
        // Notebook
        case .switchPage: "switch-page"
        // SpinRow
        case .input: "input"
        case .output: "output"
        case .wrapped: "wrapped"
        // Animation
        case .done: "done"
        // Extra drag
        case .extraDragDrop: "extra-drag-drop"
        case .extraDragValue: "extra-drag-value"
        // Other
        case .emojiPicked: "emoji-picked"
        case .invalidate: "invalidate"
        case .unapply: "unapply"
        // Property notification
        case let .notify(property): "notify::\(property)"
        // Custom
        case let .custom(name): name
        }
    }

    /// Whether this signal uses the notify trampoline (3-arg: instance, GParamSpec*, userData).
    public var isNotify: Bool {
        if case .notify = self { return true }
        // Also handle custom strings that start with "notify::"
        if case let .custom(name) = self { return name.hasPrefix("notify::") }
        return false
    }
}
