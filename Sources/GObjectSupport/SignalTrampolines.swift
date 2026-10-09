// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import Foundation

// Wrapper types for crossing isolation boundaries in signal trampolines.
// These are safe because GTK signals are always emitted on the main thread,
// and MainActor.assumeIsolated asserts this at runtime.
struct UncheckedOpaquePointer: @unchecked Sendable { let value: OpaquePointer }
struct UncheckedOptionalOpaquePointer: @unchecked Sendable { let value: OpaquePointer? }
struct UncheckedGValuePointer: @unchecked Sendable { let value: UnsafePointer<GValue> }
struct UncheckedOptionalRawPointer: @unchecked Sendable { let value: UnsafeMutableRawPointer? }
struct UncheckedRawPointer: @unchecked Sendable { let value: UnsafeMutableRawPointer }
struct UncheckedDoublePointer: @unchecked Sendable { let value: UnsafeMutablePointer<Double> }

// MARK: - C-compatible trampoline functions

// C-compatible trampoline functions that bridge GObject signal callbacks to Swift closures.
//
// These are internal implementation details used by ``SignalHelper``.
// Each trampoline matches a specific C callback signature
// (`(instance, [params...], userData)`) and unpacks the boxed Swift closure
// from the `userData` pointer.
//
// ```swift
// // You do not call trampolines directly. They are used internally by
// // SignalHelper.connect and friends, for example:
// SignalHelper.connect(button, signal: .clicked) {
//     print("Clicked!")  // signalTrampoline0 is used under the hood
// }
// ```

/// Trampoline for `notify::property` signals: (GObject*, GParamSpec*, gpointer).
/// Ignores the GParamSpec parameter and calls a void handler.
func signalTrampolineNotify(
    _ instance: UnsafeMutableRawPointer,
    _ pspec: OpaquePointer,
    _ userData: UnsafeMutableRawPointer
) {
    let box = Unmanaged<ClosureBox<@MainActor () -> Void>>.fromOpaque(userData)
        .takeUnretainedValue()
    MainActor.assumeIsolated {
        box.closure()
    }
}

func signalTrampoline0(
    _ instance: UnsafeMutableRawPointer,
    _ userData: UnsafeMutableRawPointer
) {
    let box = Unmanaged<ClosureBox<@MainActor () -> Void>>.fromOpaque(userData)
        .takeUnretainedValue()
    MainActor.assumeIsolated {
        box.closure()
    }
}

func signalTrampolineString(
    _ instance: UnsafeMutableRawPointer,
    _ value: UnsafePointer<CChar>,
    _ userData: UnsafeMutableRawPointer
) {
    let box = Unmanaged<ClosureBox<@MainActor (String) -> Void>>.fromOpaque(userData)
        .takeUnretainedValue()
    let string = String(cString: value)
    MainActor.assumeIsolated {
        box.closure(string)
    }
}

/// Like ``signalTrampolineString`` but returns `gboolean` TRUE so the
/// signal is reported as handled. Used for signals whose default handler
/// must be suppressed once a Swift handler is attached — notably
/// `activate-link` on `GtkLabel` / `AdwAboutDialog`, whose default opens
/// the URI via `gtk_show_uri` regardless of scheme. Returning TRUE stops
/// that default so the Swift handler is the sole decision point.
func signalTrampolineStringReturnTrue(
    _ instance: UnsafeMutableRawPointer,
    _ value: UnsafePointer<CChar>,
    _ userData: UnsafeMutableRawPointer
) -> gboolean {
    let box = Unmanaged<ClosureBox<@MainActor (String) -> Void>>.fromOpaque(userData)
        .takeUnretainedValue()
    let string = String(cString: value)
    MainActor.assumeIsolated {
        box.closure(string)
    }
    return 1
}

func signalTrampolineUInt(
    _ instance: UnsafeMutableRawPointer,
    _ value: UInt32,
    _ userData: UnsafeMutableRawPointer
) {
    let box = Unmanaged<ClosureBox<@MainActor (UInt32) -> Void>>.fromOpaque(userData)
        .takeUnretainedValue()
    MainActor.assumeIsolated {
        box.closure(value)
    }
}

func signalTrampolineInt(
    _ instance: UnsafeMutableRawPointer,
    _ value: Int32,
    _ userData: UnsafeMutableRawPointer
) {
    let box = Unmanaged<ClosureBox<@MainActor (Int32) -> Void>>.fromOpaque(userData)
        .takeUnretainedValue()
    MainActor.assumeIsolated {
        box.closure(value)
    }
}

func signalTrampolineDouble(
    _ instance: UnsafeMutableRawPointer,
    _ value: Double,
    _ userData: UnsafeMutableRawPointer
) {
    let box = Unmanaged<ClosureBox<@MainActor (Double) -> Void>>.fromOpaque(userData)
        .takeUnretainedValue()
    MainActor.assumeIsolated {
        box.closure(value)
    }
}

func signalTrampolineBool(
    _ instance: UnsafeMutableRawPointer,
    _ value: gboolean,
    _ userData: UnsafeMutableRawPointer
) {
    let box = Unmanaged<ClosureBox<@MainActor (Bool) -> Void>>.fromOpaque(userData)
        .takeUnretainedValue()
    MainActor.assumeIsolated {
        box.closure(value != 0)
    }
}

func signalTrampolinePointer(
    _ instance: UnsafeMutableRawPointer,
    _ value: OpaquePointer,
    _ userData: UnsafeMutableRawPointer
) {
    let box = Unmanaged<ClosureBox<@MainActor (OpaquePointer) -> Void>>.fromOpaque(userData)
        .takeUnretainedValue()
    let wrapped = UncheckedOpaquePointer(value: value)
    MainActor.assumeIsolated {
        box.closure(wrapped.value)
    }
}

/// Trampoline variant for signals whose pointer parameter is nullable
/// in the C ABI — e.g. `GtkListBox::row-selected` emits NULL when the
/// selection is cleared. Using ``signalTrampolinePointer`` for these
/// signals wraps NULL as a Swift `OpaquePointer` with address 0, which
/// triggers `G_IS_OBJECT` criticals as soon as the closure touches it.
func signalTrampolineOptionalPointer(
    _ instance: UnsafeMutableRawPointer,
    _ value: OpaquePointer?,
    _ userData: UnsafeMutableRawPointer
) {
    let box = Unmanaged<ClosureBox<@MainActor (OpaquePointer?) -> Void>>.fromOpaque(userData)
        .takeUnretainedValue()
    let wrapped = UncheckedOptionalOpaquePointer(value: value)
    MainActor.assumeIsolated {
        box.closure(wrapped.value)
    }
}

func signalTrampolineDoubleDouble(
    _ instance: UnsafeMutableRawPointer,
    _ value1: Double,
    _ value2: Double,
    _ userData: UnsafeMutableRawPointer
) {
    let box = Unmanaged<ClosureBox<@MainActor (Double, Double) -> Void>>.fromOpaque(userData)
        .takeUnretainedValue()
    MainActor.assumeIsolated {
        box.closure(value1, value2)
    }
}

func signalTrampolineUIntUInt(
    _ instance: UnsafeMutableRawPointer,
    _ value1: UInt32,
    _ value2: UInt32,
    _ userData: UnsafeMutableRawPointer
) {
    let box = Unmanaged<ClosureBox<@MainActor (UInt32, UInt32) -> Void>>.fromOpaque(userData)
        .takeUnretainedValue()
    MainActor.assumeIsolated {
        box.closure(value1, value2)
    }
}

func signalTrampolinePointerInt(
    _ instance: UnsafeMutableRawPointer,
    _ ptr: OpaquePointer,
    _ value: Int32,
    _ userData: UnsafeMutableRawPointer
) {
    let box = Unmanaged<ClosureBox<@MainActor (OpaquePointer, Int32) -> Void>>.fromOpaque(userData)
        .takeUnretainedValue()
    let wrapped = UncheckedOpaquePointer(value: ptr)
    MainActor.assumeIsolated {
        box.closure(wrapped.value, value)
    }
}

func signalTrampolinePointerGValueBool(
    _ instance: UnsafeMutableRawPointer,
    _ ptr: OpaquePointer,
    _ gvalue: UnsafePointer<GValue>,
    _ userData: UnsafeMutableRawPointer
) -> gboolean {
    let box = Unmanaged<ClosureBox<@MainActor (OpaquePointer, UnsafePointer<GValue>) -> Bool>>.fromOpaque(userData)
        .takeUnretainedValue()
    let wrappedPtr = UncheckedOpaquePointer(value: ptr)
    let wrappedGV = UncheckedGValuePointer(value: gvalue)
    return MainActor.assumeIsolated {
        box.closure(wrappedPtr.value, wrappedGV.value) ? 1 : 0
    }
}

func signalTrampolinePointerGValueDragAction(
    _ instance: UnsafeMutableRawPointer,
    _ ptr: OpaquePointer,
    _ gvalue: UnsafePointer<GValue>,
    _ userData: UnsafeMutableRawPointer
) -> GdkDragAction {
    let box = Unmanaged<ClosureBox<@MainActor (OpaquePointer, UnsafePointer<GValue>) -> GdkDragAction>>
        .fromOpaque(userData)
        .takeUnretainedValue()
    let wrappedPtr = UncheckedOpaquePointer(value: ptr)
    let wrappedGV = UncheckedGValuePointer(value: gvalue)
    return MainActor.assumeIsolated {
        box.closure(wrappedPtr.value, wrappedGV.value)
    }
}

func signalTrampolineOpenFiles(
    _ instance: UnsafeMutableRawPointer,
    _ files: UnsafeMutablePointer<OpaquePointer?>?,
    _ count: Int32,
    _ hint: UnsafePointer<CChar>?,
    _ userData: UnsafeMutableRawPointer
) {
    let box = Unmanaged<ClosureBox<@MainActor ([URL], String?) -> Void>>.fromOpaque(userData)
        .takeUnretainedValue()
    let urls = openFileURLs(from: files, count: count)
    let openHint = hint.map(String.init(cString:)).flatMap { $0.isEmpty ? nil : $0 }
    MainActor.assumeIsolated {
        box.closure(urls, openHint)
    }
}

func signalTrampolineIntDoubleDouble(
    _ instance: UnsafeMutableRawPointer,
    _ value1: Int32,
    _ value2: Double,
    _ value3: Double,
    _ userData: UnsafeMutableRawPointer
) {
    let box = Unmanaged<ClosureBox<@MainActor (Int32, Double, Double) -> Void>>.fromOpaque(userData)
        .takeUnretainedValue()
    MainActor.assumeIsolated {
        box.closure(value1, value2, value3)
    }
}

func signalTrampolineUIntUIntUIntBool(
    _ instance: UnsafeMutableRawPointer,
    _ value1: UInt32,
    _ value2: UInt32,
    _ value3: UInt32,
    _ userData: UnsafeMutableRawPointer
) -> gboolean {
    let box = Unmanaged<ClosureBox<@MainActor (UInt32, UInt32, UInt32) -> Bool>>.fromOpaque(userData)
        .takeUnretainedValue()
    return MainActor.assumeIsolated {
        box.closure(value1, value2, value3) ? 1 : 0
    }
}

func signalTrampolineUIntUIntUInt(
    _ instance: UnsafeMutableRawPointer,
    _ value1: UInt32,
    _ value2: UInt32,
    _ value3: UInt32,
    _ userData: UnsafeMutableRawPointer
) {
    let box = Unmanaged<ClosureBox<@MainActor (UInt32, UInt32, UInt32) -> Void>>.fromOpaque(userData)
        .takeUnretainedValue()
    MainActor.assumeIsolated {
        box.closure(value1, value2, value3)
    }
}

func signalTrampolineReturnBool(
    _ instance: UnsafeMutableRawPointer,
    _ userData: UnsafeMutableRawPointer
) -> gboolean {
    let box = Unmanaged<ClosureBox<@MainActor () -> Bool>>.fromOpaque(userData)
        .takeUnretainedValue()
    return MainActor.assumeIsolated {
        box.closure() ? 1 : 0
    }
}

/// Trampoline for no-argument signals whose C return type is a GObject
/// (e.g. `AdwTabOverview::create-tab`, whose handler returns the newly
/// created `AdwTabPage`).
///
/// The trampoline must hand the object pointer back to the C marshaller in a
/// return register — a trampoline that returns `Void` leaves the register the
/// marshaller reads holding garbage, which is what crashed `create-tab` before
/// this existed. Whether the return is an *optional* pointer is irrelevant to
/// the ABI: `UnsafeMutableRawPointer?` maps to a C pointer that may be NULL and
/// is returned in `rax` just like the non-optional form, so it can safely carry
/// a NULL (see `signalTrampolineReturnObjectNullable`).
///
/// Ownership is governed by the GIR `transfer-ownership` annotation on the
/// signal's return value, not by anything here: `create-tab` is `transfer
/// none`, so the handler returns the object exactly like a C handler would
/// (`return adw_tab_view_append(view, page)`) — no extra reference is taken.
/// The balance is verified by a weak-pointer test that the page finalizes
/// exactly once when its tab is closed.
func signalTrampolineReturnObject(
    _ instance: UnsafeMutableRawPointer,
    _ userData: UnsafeMutableRawPointer
) -> UnsafeMutableRawPointer {
    let box = Unmanaged<ClosureBox<@MainActor () -> UnsafeMutableRawPointer>>.fromOpaque(userData)
        .takeUnretainedValue()
    let result = MainActor.assumeIsolated {
        UncheckedRawPointer(value: box.closure())
    }
    return result.value
}

/// Trampoline for no-argument signals whose C return type is a **nullable**
/// GObject returned without a reference (GIR `transfer-ownership="none"`),
/// e.g. `AdwTabView::create-window`.
///
/// Like `signalTrampolineReturnObject` but the handler may return `nil`, which
/// is passed through as `NULL` — the C marshaller treats a NULL object return
/// the same as an absent value. No reference is added (transfer none).
func signalTrampolineReturnObjectNullable(
    _ instance: UnsafeMutableRawPointer,
    _ userData: UnsafeMutableRawPointer
) -> UnsafeMutableRawPointer? {
    let box = Unmanaged<ClosureBox<@MainActor () -> UnsafeMutableRawPointer?>>.fromOpaque(userData)
        .takeUnretainedValue()
    let result = MainActor.assumeIsolated {
        UncheckedOptionalRawPointer(value: box.closure())
    }
    return result.value
}

/// Trampoline for no-argument signals whose C return type is a **nullable**
/// GObject returned with a full reference (GIR `transfer-ownership="full"`),
/// e.g. `AdwNavigationView::get-next-page`.
///
/// The `+1` reference is taken by the Swift handler while its wrapper is still
/// alive (see the `onGetNextPage` closure), so this trampoline is a plain
/// pass-through: by the time it runs the handler's temporary wrapper has already
/// been released, so it must not touch the reference (a `g_object_ref` here
/// would be a use-after-free).
func signalTrampolineReturnObjectRef(
    _ instance: UnsafeMutableRawPointer,
    _ userData: UnsafeMutableRawPointer
) -> UnsafeMutableRawPointer? {
    let box = Unmanaged<ClosureBox<@MainActor () -> UnsafeMutableRawPointer?>>.fromOpaque(userData)
        .takeUnretainedValue()
    let result = MainActor.assumeIsolated {
        UncheckedOptionalRawPointer(value: box.closure())
    }
    return result.value
}

/// Trampoline for signals with a single pointer parameter that return a
/// `gboolean`, e.g. `AdwTabView::close-page`. Returning `true` stops
/// propagation (the default handler does not run); `false` lets it run.
func signalTrampolinePointerReturnBool(
    _ instance: UnsafeMutableRawPointer,
    _ value: OpaquePointer,
    _ userData: UnsafeMutableRawPointer
) -> gboolean {
    let box = Unmanaged<ClosureBox<@MainActor (OpaquePointer) -> Bool>>.fromOpaque(userData)
        .takeUnretainedValue()
    let wrapped = UncheckedOpaquePointer(value: value)
    return MainActor.assumeIsolated {
        box.closure(wrapped.value) ? 1 : 0
    }
}

/// Trampoline for `AdwSpinRow::input`: the single parameter is an out-pointer
/// `double *new_value` the handler may write, and the return is a `gint`
/// (TRUE = value written, FALSE = default conversion, -1 = GTK_INPUT_ERROR).
func signalTrampolineInput(
    _ instance: OpaquePointer,
    _ newValue: UnsafeMutablePointer<Double>,
    _ userData: UnsafeMutableRawPointer
) -> Int32 {
    let box = Unmanaged<ClosureBox<@MainActor (OpaquePointer, UnsafeMutablePointer<Double>) -> Int32>>
        .fromOpaque(userData).takeUnretainedValue()
    let instancePtr = UncheckedOpaquePointer(value: instance)
    let wrapped = UncheckedDoublePointer(value: newValue)
    return MainActor.assumeIsolated {
        box.closure(instancePtr.value, wrapped.value)
    }
}

/// Trampoline for `GtkDragSource::drag-cancel`: `(GdkDrag*, GdkDragCancelReason)`,
/// returns `gboolean`. We always return `FALSE` so the standard cancel
/// animation runs; the Swift handler is invoked purely as an observer.
func signalTrampolineDragCancel(
    _ instance: UnsafeMutableRawPointer,
    _ drag: OpaquePointer?,
    _ reason: UInt32,
    _ userData: UnsafeMutableRawPointer
) -> gboolean {
    let box = Unmanaged<ClosureBox<@MainActor () -> Void>>.fromOpaque(userData)
        .takeUnretainedValue()
    MainActor.assumeIsolated {
        box.closure()
    }
    return 0
}

func signalTrampolineDoubleDoubleBool(
    _ instance: UnsafeMutableRawPointer,
    _ value1: Double,
    _ value2: Double,
    _ userData: UnsafeMutableRawPointer
) -> gboolean {
    let box = Unmanaged<ClosureBox<@MainActor (Double, Double) -> Bool>>.fromOpaque(userData)
        .takeUnretainedValue()
    return MainActor.assumeIsolated {
        box.closure(value1, value2) ? 1 : 0
    }
}

func signalTrampolineDoubleDoubleDragAction(
    _ instance: UnsafeMutableRawPointer,
    _ value1: Double,
    _ value2: Double,
    _ userData: UnsafeMutableRawPointer
) -> GdkDragAction {
    let box = Unmanaged<ClosureBox<@MainActor (Double, Double) -> GdkDragAction>>.fromOpaque(userData)
        .takeUnretainedValue()
    return MainActor.assumeIsolated {
        box.closure(value1, value2)
    }
}

private func openFileURLs(from files: UnsafeMutablePointer<OpaquePointer?>?, count: Int32) -> [URL] {
    guard let files, count > 0 else { return [] }
    var urls: [URL] = []
    urls.reserveCapacity(Int(count))

    for index in 0 ..< Int(count) {
        guard let file = files[index] else { continue }
        if let path = g_file_get_path(file) {
            urls.append(URL(fileURLWithPath: String(cString: path)).standardizedFileURL)
            g_free(path)
            continue
        }
        if let uri = g_file_get_uri(file) {
            let uriString = String(cString: uri)
            if let url = URL(string: uriString) {
                urls.append(url)
            }
            g_free(uri)
        }
    }

    return urls
}
