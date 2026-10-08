// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

/// The result of handling a ``SpinRow``'s ``input`` signal.
///
/// Return one of these from an ``SpinRow/onInput(_:)`` handler to tell
/// libadwaita what to do with the value the user typed.
public enum SpinRowInputResult {
    /// The value was parsed successfully; store it as the new value.
    case value(Double)

    /// The input could not be parsed; keep the current value unchanged.
    case useDefault

    /// The input is invalid; show the entry in its error state.
    case invalid
}
