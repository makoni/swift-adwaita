// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

/// How far along the event propagation chain a controller receives events.
///
/// Maps to `GtkPropagationPhase`.
public enum PropagationPhase: Sendable, Equatable {
    /// Events are not delivered to the controller.
    case none
    /// Events are delivered in the capture phase (top-down, before children).
    case capture
    /// Events are delivered in the bubble phase (bottom-up, after children). Default.
    case bubble
    /// Events are delivered only when the widget is the target.
    case target

    init(_ raw: GtkPropagationPhase) {
        switch raw {
        case GTK_PHASE_NONE: self = .none
        case GTK_PHASE_CAPTURE: self = .capture
        case GTK_PHASE_BUBBLE: self = .bubble
        case GTK_PHASE_TARGET: self = .target
        default: self = .bubble
        }
    }

    var gtkValue: GtkPropagationPhase {
        switch self {
        case .none: GTK_PHASE_NONE
        case .capture: GTK_PHASE_CAPTURE
        case .bubble: GTK_PHASE_BUBBLE
        case .target: GTK_PHASE_TARGET
        }
    }
}

// MARK: - Protocol

/// Marks types that wrap a `GtkEventController` and provides a default
/// implementation of ``propagationPhase`` via a protocol extension.
///
/// All concrete event-controller and gesture wrapper classes conform to this
/// protocol. Conform your own `GObjectRef` subclasses to it if they wrap a
/// `GtkEventController`-derived GObject.
public protocol EventControllerProtocol: GObjectRef {}

public extension EventControllerProtocol {
    /// Where in the event propagation chain this controller receives events.
    ///
    /// Wraps `gtk_event_controller_get/set_propagation_phase`. The default
    /// for most controllers is `.bubble` (post-widget delivery).
    ///
    /// Set to `.capture` to intercept events before they reach child widgets —
    /// useful for container-level gesture handling that must run before any
    /// child handles the event.
    var propagationPhase: PropagationPhase {
        get { PropagationPhase(gtk_event_controller_get_propagation_phase(opaquePointer)) }
        set { gtk_event_controller_set_propagation_phase(opaquePointer, newValue.gtkValue) }
    }
}

// MARK: - Base class (kept for external subclassing)

/// Base class for building custom GTK event controller wrappers.
///
/// Concrete built-in wrappers — ``GestureClick``, ``EventControllerKey`` etc.
/// — do NOT inherit from this class (they inherit from `GObjectRef` directly
/// to avoid introducing extra levels in the ARC/deinit chain). This class is
/// provided for external code that needs a typed base when subclassing.
@MainActor
open class EventController: GObjectRef, EventControllerProtocol {
    public required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }
}
