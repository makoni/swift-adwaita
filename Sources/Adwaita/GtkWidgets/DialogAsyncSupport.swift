// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

final class DialogAsyncBox<T>: @unchecked Sendable {
    let closure: T

    init(_ closure: T) {
        self.closure = closure
    }
}

enum DialogAsyncSupport {
    static let dismissedDialogErrorCode: Int32 = 2

    static var dismissedDialogErrorDomain: GQuark {
        g_quark_from_string("gtk-dialog-error-quark")
    }

    static func isDismissed(_ error: UnsafeMutablePointer<GError>) -> Bool {
        error.pointee.domain == dismissedDialogErrorDomain && error.pointee.code == dismissedDialogErrorCode
    }

    static func retainBox(_ closure: some Sendable) -> UnsafeMutableRawPointer {
        Unmanaged.passRetained(DialogAsyncBox(closure)).toOpaque()
    }

    static func takeBox<T: Sendable>(
        _ userData: UnsafeMutableRawPointer?,
        as _: T.Type = T.self,
        context: StaticString
    ) -> DialogAsyncBox<T> {
        guard let userData else {
            preconditionFailure("Missing async dialog callback state in \(context)")
        }
        return Unmanaged<DialogAsyncBox<T>>.fromOpaque(userData).takeRetainedValue()
    }
}
