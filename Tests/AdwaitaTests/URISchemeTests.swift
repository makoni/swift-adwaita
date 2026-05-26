// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Testing
@testable import Adwaita

@Suite(.serialized)
struct URISchemeTests {
    @Test @MainActor func allowlistAcceptsConfiguredSchemesAndRejectsDangerousOnes() {
        var opened: [String] = []
        var rejected: [String] = []
        let handler = URIScheme.allowlist(.https, .mailto) { uri in
            opened.append(uri)
        } onReject: { uri in
            rejected.append(uri)
        }

        handler("HTTPS://example.com")
        handler("mailto:test@example.com")
        handler("javascript:alert(1)")
        handler("data:text/html;base64,AAAA")
        handler("vbscript:msgbox(1)")
        handler("custom:thing")
        handler("bareword")
        handler("")

        #expect(opened == ["HTTPS://example.com", "mailto:test@example.com"])
        #expect(
            rejected == [
                "javascript:alert(1)",
                "data:text/html;base64,AAAA",
                "vbscript:msgbox(1)",
                "custom:thing",
                "bareword",
                ""
            ]
        )
    }

    @Test @MainActor func fileSchemeIsRejectedWhenNotAllowlisted() {
        var rejected: [String] = []
        let handler = URIScheme.allowlist(.https) { _ in } onReject: { uri in
            rejected.append(uri)
        }

        handler("file:///tmp/notes.txt")

        #expect(rejected == ["file:///tmp/notes.txt"])
    }

    @Test @MainActor func fileSchemeIsAcceptedWhenAllowlisted() {
        var opened: [String] = []
        var rejected: [String] = []
        let handler = URIScheme.allowlist(.https, .file) { uri in
            opened.append(uri)
        } onReject: { uri in
            rejected.append(uri)
        }

        handler("file:///tmp/notes.txt")

        #expect(opened == ["file:///tmp/notes.txt"])
        #expect(rejected.isEmpty)
    }

    @Test @MainActor func allowlistWithoutRejectHandlerDoesNotCrashForRejectedUri() {
        var opened: [String] = []
        let handler: @MainActor @Sendable (String) -> Void = URIScheme.allowlist(.https) { uri in
            opened.append(uri)
        }

        handler("custom:ignored")
        handler("https://example.com")

        #expect(opened == ["https://example.com"])
    }
}
#endif
