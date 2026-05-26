// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Testing
@testable import Adwaita

@Suite(.serialized)
struct StringPangoByteOffsetTests {
    @Test func pangoByteOffsetMatchesUTF8Offsets() {
        let text = "Aé🙂Б"

        let start = text.startIndex
        let afterA = text.index(after: start)
        let afterEAcute = text.index(after: afterA)
        let afterEmoji = text.index(after: afterEAcute)
        let end = text.endIndex

        #expect(text.pangoByteOffset(of: start) == 0)
        #expect(text.pangoByteOffset(of: afterA) == 1)
        #expect(text.pangoByteOffset(of: afterEAcute) == 3)
        #expect(text.pangoByteOffset(of: afterEmoji) == 7)
        #expect(text.pangoByteOffset(of: end) == 9)
    }

    @Test func pangoByteRangeMatchesUTF8Span() {
        let text = "Aé🙂Б"
        let rangeStart = text.index(after: text.startIndex)
        let rangeEnd = text.index(before: text.endIndex)

        #expect(text.pangoByteRange(for: rangeStart ..< rangeEnd) == 1 ..< 7)
    }

    @Test func pangoByteOffsetHandlesEmptyString() {
        let text = ""
        #expect(text.pangoByteOffset(of: text.startIndex) == 0)
        #expect(text.pangoByteRange(for: text.startIndex ..< text.endIndex) == 0 ..< 0)
    }

    @Test func pangoByteOffsetHandlesASCIIEndIndex() {
        let text = "abc"
        #expect(text.pangoByteOffset(of: text.endIndex) == 3)
    }

    @Test func pangoByteOffsetHandlesCombiningMarks() {
        let text = "e\u{0301}"
        #expect(text.pangoByteOffset(of: text.endIndex) == 3)
        #expect(text.pangoByteRange(for: text.startIndex ..< text.endIndex) == 0 ..< 3)
    }
}
#endif
