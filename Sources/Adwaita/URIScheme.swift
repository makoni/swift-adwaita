// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

/// Helpers for validating URI schemes before handling activated links.
public enum URIScheme {
    /// Common built-in schemes used by labels and launchers.
    public enum Scheme: String, CaseIterable, Sendable {
        case http
        case https
        case mailto
        case file
    }

    @available(*, deprecated, renamed: "Scheme")
    public typealias Predefined = Scheme

    /// Wraps a URI handler and only forwards URIs whose scheme is explicitly
    /// allowed.
    ///
    /// Use this with ``Label/onActivateLink(_:)`` when labels may contain
    /// externally-provided markup.
    public static func allowlist(
        _ allowed: Scheme...,
        handler: @escaping @MainActor @Sendable (String) -> Void,
        onReject: (@MainActor @Sendable (String) -> Void)? = nil
    ) -> @MainActor @Sendable (String) -> Void {
        allowlist(Set(allowed), handler: handler, onReject: onReject)
    }

    /// Wraps a URI handler and only forwards URIs whose scheme is explicitly
    /// allowed.
    public static func allowlist(
        _ allowed: Set<Scheme>,
        handler: @escaping @MainActor @Sendable (String) -> Void,
        onReject: (@MainActor @Sendable (String) -> Void)? = nil
    ) -> @MainActor @Sendable (String) -> Void {
        let schemes = Set(allowed.map(\.rawValue))
        return { uri in
            let scheme = scheme(of: uri)
            if schemes.contains(scheme) {
                handler(uri)
            } else {
                onReject?(uri)
            }
        }
    }

    static func scheme(of uri: String) -> String {
        guard let colon = uri.firstIndex(of: ":") else { return "" }
        return uri[..<colon].lowercased()
    }
}
