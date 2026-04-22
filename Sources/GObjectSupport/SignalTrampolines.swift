import CAdwaita
import Foundation

// Wrapper types for crossing isolation boundaries in signal trampolines.
// These are safe because GTK signals are always emitted on the main thread,
// and MainActor.assumeIsolated asserts this at runtime.
struct UncheckedOpaquePointer: @unchecked Sendable { let value: OpaquePointer }
struct UncheckedGValuePointer: @unchecked Sendable { let value: UnsafePointer<GValue> }

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
