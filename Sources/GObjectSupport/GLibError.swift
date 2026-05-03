// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita

/// A Swift error wrapping a GLib GError.
///
/// When a GLib/GTK function sets a `GError*`, create a ``GLibError`` using
/// ``init(consuming:)`` to bridge it into Swift's error handling. The
/// initializer copies the domain, code, and message, then frees the
/// underlying `GError`.
///
/// ```swift
/// var gerror: UnsafeMutablePointer<GError>?
/// let ok = some_glib_function(&gerror)
/// if ok == 0, let gerror {
///     let error = GLibError(consuming: gerror)
///     print("GLib error \(error.code): \(error.message)")
/// }
/// ```
public struct GLibError: Error, CustomStringConvertible {
    /// The GLib error domain (a GQuark).
    public let domain: UInt32
    /// The error code within the domain.
    public let code: Int32
    /// The human-readable error message.
    public let message: String

    /// Creates from a GError pointer and frees the GError.
    ///
    /// - Parameter error: A non-null GError pointer. Ownership is transferred
    ///   to this initializer — the GError is freed after copying its fields.
    public init(consuming error: UnsafeMutablePointer<GError>) {
        domain = error.pointee.domain
        code = error.pointee.code
        message = String(cString: error.pointee.message)
        g_error_free(error)
    }

    public var description: String {
        message
    }
}
