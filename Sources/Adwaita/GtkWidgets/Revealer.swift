import CAdwaita
import GObjectSupport

/// A container that animates showing and hiding its child widget.
///
/// Wraps `GtkRevealer`. The reveal animation type and duration are
/// configurable. Use ``revealChild`` to trigger the transition.
///
/// ```swift
/// let label = Label("Now you see me!")
/// let revealer = Revealer()
/// revealer.child = label
/// revealer.transitionType = GTK_REVEALER_TRANSITION_TYPE_SLIDE_DOWN
/// revealer.transitionDuration = 300
///
/// // Toggle visibility with animation
/// revealer.revealChild = true
///
/// revealer.onChildRevealed {
///     print("Animation finished, visible: \(revealer.childRevealed)")
/// }
/// ```
@MainActor
public final class Revealer: Widget {
    /// Creates a new revealer.
    public init() {
        let ptr = gtk_revealer_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The child widget.
    public var child: Widget? {
        get {
            guard let ptr = gtk_revealer_get_child(opaquePointer) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set { gtk_revealer_set_child(opaquePointer, newValue?.widgetPointer) }
    }

    /// Whether the child is revealed.
    public var revealChild: Bool {
        get { gtk_revealer_get_reveal_child(opaquePointer) != 0 }
        set { gtk_revealer_set_reveal_child(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the child is currently visible (accounting for animation).
    public var childRevealed: Bool {
        gtk_revealer_get_child_revealed(opaquePointer) != 0
    }

    /// The transition type.
    public var transitionType: GtkRevealerTransitionType {
        get { gtk_revealer_get_transition_type(opaquePointer) }
        set { gtk_revealer_set_transition_type(opaquePointer, newValue) }
    }

    /// The transition duration in milliseconds.
    public var transitionDuration: Int {
        get { Int(gtk_revealer_get_transition_duration(opaquePointer)) }
        set { gtk_revealer_set_transition_duration(opaquePointer, UInt32(newValue)) }
    }

    /// Called when the reveal animation completes (child-revealed property changes).
    @discardableResult
    public func onChildRevealed(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.onNotify(self, property: .custom("child-revealed"), handler: handler)
    }
}
