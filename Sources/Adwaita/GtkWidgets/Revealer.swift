import CAdwaita
import GObjectSupport

/// A container that animates showing/hiding its child.
///
/// Wraps `GtkRevealer`.
@MainActor
public final class Revealer: Widget {
    /// Creates a new revealer.
    public init() {
        let ptr = gtk_revealer_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    override internal init(raw pointer: UnsafeMutableRawPointer) {
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
    public var transitionDuration: UInt32 {
        get { gtk_revealer_get_transition_duration(opaquePointer) }
        set { gtk_revealer_set_transition_duration(opaquePointer, newValue) }
    }
}
