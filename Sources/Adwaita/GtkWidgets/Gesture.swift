// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

/// The recognition state of a pointer or touch event sequence in a gesture.
///
/// Maps to `GtkEventSequenceState`.
public enum EventSequenceState: Sendable, Equatable {
    /// The sequence is handled but not exclusively claimed.
    case none
    /// The sequence is claimed exclusively by this gesture.
    case claimed
    /// The sequence is rejected by this gesture, freeing it for others.
    case denied

    init(_ raw: GtkEventSequenceState) {
        switch raw {
        case GTK_EVENT_SEQUENCE_NONE: self = .none
        case GTK_EVENT_SEQUENCE_CLAIMED: self = .claimed
        case GTK_EVENT_SEQUENCE_DENIED: self = .denied
        default: self = .none
        }
    }

    var gtkValue: GtkEventSequenceState {
        switch self {
        case .none: GTK_EVENT_SEQUENCE_NONE
        case .claimed: GTK_EVENT_SEQUENCE_CLAIMED
        case .denied: GTK_EVENT_SEQUENCE_DENIED
        }
    }
}

/// Base class for all GTK gesture wrappers.
///
/// Extends ``EventController`` with gesture-specific state management.
/// You do not instantiate `Gesture` directly — use a concrete subclass
/// such as ``GestureClick``, ``GestureDrag``, or ``GestureLongPress``.
@MainActor
open class Gesture: EventController {
    public required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Sets the recognition state for the current event sequence.
    ///
    /// Wraps `gtk_gesture_set_state`. Call from inside a signal handler
    /// (e.g. `onPressed`) to claim or deny a pointer/touch sequence:
    ///
    /// - `.claimed`: this gesture exclusively owns the sequence; other
    ///   gestures on the same widget stop receiving events for it.
    /// - `.denied`: this gesture gives up the sequence; other gestures
    ///   may still receive it.
    ///
    /// Calling this with no active sequence is a GTK no-op.
    public func setState(_ state: EventSequenceState) {
        gtk_gesture_set_state(opaquePointer, state.gtkValue)
    }
}
