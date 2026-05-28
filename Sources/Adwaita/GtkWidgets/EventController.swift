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
        case GTK_PHASE_NONE:    self = .none
        case GTK_PHASE_CAPTURE: self = .capture
        case GTK_PHASE_BUBBLE:  self = .bubble
        case GTK_PHASE_TARGET:  self = .target
        default:                self = .bubble
        }
    }

    var gtkValue: GtkPropagationPhase {
        switch self {
        case .none:    return GTK_PHASE_NONE
        case .capture: return GTK_PHASE_CAPTURE
        case .bubble:  return GTK_PHASE_BUBBLE
        case .target:  return GTK_PHASE_TARGET
        }
    }
}

/// Base class for all GTK event controller wrappers.
///
/// Provides the ``propagationPhase`` property shared by all controllers and
/// gestures. You do not instantiate `EventController` directly — use a
/// concrete subclass such as ``GestureClick``, ``EventControllerKey``, or
/// ``EventControllerScroll``.
@MainActor
open class EventController: GObjectRef {
    public required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Where in the event propagation chain this controller receives events.
    ///
    /// Wraps `gtk_event_controller_get/set_propagation_phase`. The default
    /// for most controllers is `.bubble` (post-widget delivery).
    ///
    /// Set to `.capture` to intercept events before they reach child widgets —
    /// useful for container-level gesture handling that must run before any
    /// child handles the event.
    public var propagationPhase: PropagationPhase {
        get { PropagationPhase(gtk_event_controller_get_propagation_phase(opaquePointer)) }
        set { gtk_event_controller_set_propagation_phase(opaquePointer, newValue.gtkValue) }
    }
}
