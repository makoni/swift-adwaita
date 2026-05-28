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

// MARK: - Protocol

/// Marks types that wrap a `GtkGesture` and exposes ``setState(_:)``.
///
/// All concrete gesture wrapper classes conform to this protocol. Conform your
/// own `GObjectRef` subclasses to it if they wrap a `GtkGesture`-derived
/// GObject.
///
/// ``setState(_:)`` is a protocol *requirement* with a default implementation,
/// so a conformer that supplies its own implementation has it honoured even
/// when called through a `GestureProtocol` existential (witness-table
/// dispatch, not the static dispatch a bare extension method would get).
@MainActor
public protocol GestureProtocol: EventControllerProtocol {
    /// Sets the recognition state for the current event sequence.
    func setState(_ state: EventSequenceState)
}

public extension GestureProtocol {
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
    func setState(_ state: EventSequenceState) {
        gtk_gesture_set_state(opaquePointer, state.gtkValue)
    }
}

// MARK: - Base class (kept for external subclassing)

/// Base class for building custom GTK gesture wrappers.
///
/// Concrete built-in wrappers — ``GestureClick``, ``GestureDrag`` etc. — do
/// NOT inherit from this class (they inherit from `GObjectRef` directly to
/// avoid introducing extra levels in the ARC/deinit chain). This class is
/// provided for external code that needs a typed base when subclassing.
@MainActor
open class Gesture: GObjectRef, GestureProtocol {
    public required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }
}
