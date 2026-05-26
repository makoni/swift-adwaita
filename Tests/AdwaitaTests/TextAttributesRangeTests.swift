// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct TextAttributesRangeTests {
    @Test @MainActor func rangeAwareAttributesUsePangoByteOffsets() {
        ensureAdwInit()
        let text = "Aé🙂Z"
        let attrs = TextAttributes()
        let lower = text.index(after: text.startIndex)
        let upper = text.index(before: text.endIndex)

        attrs.addBold(range: lower ..< upper, in: text)

        let boldRuns = capturedAttributes(in: attrs).filter { $0.type == PANGO_ATTR_WEIGHT }
        #expect(boldRuns.count == 1)
        #expect(boldRuns.first?.start == 1)
        #expect(boldRuns.first?.end == 7)
    }

    @Test @MainActor func rangeAwareAttributesHandleCyrillicText() {
        ensureAdwInit()
        let text = "Привет"
        let attrs = TextAttributes()
        let lower = text.startIndex
        let upper = text.index(text.startIndex, offsetBy: 3)

        attrs.addUnderline(range: lower ..< upper, in: text)

        let underlineRuns = capturedAttributes(in: attrs).filter { $0.type == PANGO_ATTR_UNDERLINE }
        #expect(underlineRuns.count == 1)
        #expect(underlineRuns.first?.start == 0)
        #expect(underlineRuns.first?.end == 6)
    }

    @Test @MainActor func rangeAwareAttributesHandleCombiningMarks() {
        ensureAdwInit()
        let text = "e\u{0301}!"
        let attrs = TextAttributes()
        let accentRange = text.startIndex ..< text.index(before: text.endIndex)

        attrs.addItalic(range: accentRange, in: text)

        let italicRuns = capturedAttributes(in: attrs).filter { $0.type == PANGO_ATTR_STYLE }
        #expect(italicRuns.count == 1)
        #expect(italicRuns.first?.start == 0)
        #expect(italicRuns.first?.end == 3)
    }

    @Test @MainActor func emptyRangeCreatesZeroLengthAttribute() {
        ensureAdwInit()
        let text = "hello"
        let attrs = TextAttributes()
        let cursor = text.index(text.startIndex, offsetBy: 2)

        attrs.addBold(range: cursor ..< cursor, in: text)

        let boldRuns = capturedAttributes(in: attrs).filter { $0.type == PANGO_ATTR_WEIGHT }
        #expect(boldRuns.count == 1)
        #expect(boldRuns.first?.start == 2)
        #expect(boldRuns.first?.end == 2)
    }

    @Test @MainActor func overlappingAttributesArePreserved() {
        ensureAdwInit()
        let text = "abcdef"
        let attrs = TextAttributes()
        attrs.addBold(range: text.startIndex ..< text.index(text.startIndex, offsetBy: 4), in: text)
        attrs.addUnderline(range: text.index(text.startIndex, offsetBy: 2) ..< text.endIndex, in: text)
        attrs.addBackgroundColor(
            RGBA(red: 1.0, green: 0.95, blue: 0.6),
            range: text.index(after: text.startIndex) ..< text.index(text.startIndex, offsetBy: 3),
            in: text
        )

        let captured = capturedAttributes(in: attrs)
        #expect(captured.contains { $0.type == PANGO_ATTR_WEIGHT && $0.start == 0 && $0.end == 4 })
        #expect(captured.contains { $0.type == PANGO_ATTR_UNDERLINE && $0.start == 2 && $0.end == 6 })
        #expect(captured.contains { $0.type == PANGO_ATTR_BACKGROUND && $0.start == 1 && $0.end == 3 })
    }

    @Test @MainActor func clampedPangoByteRangeClampsOutOfBoundsOffsets() {
        ensureAdwInit()
        let text = "Aé🙂Z"
        let attrs = TextAttributes()

        let clamped = attrs.clampedPangoByteRange(for: -5 ..< 200, in: text)
        #expect(clamped == 0 ..< text.utf8.count)
    }

    @Test @MainActor func clampedPangoByteRangeAcceptsBoundaryOffsets() {
        ensureAdwInit()
        let text = "Aé🙂Z"
        let attrs = TextAttributes()

        #expect(attrs.isMidCodepointBoundary(0, in: text) == false)
        #expect(attrs.isMidCodepointBoundary(1, in: text) == false)
        #expect(attrs.isMidCodepointBoundary(3, in: text) == false)
        #expect(attrs.isMidCodepointBoundary(7, in: text) == false)
        #expect(attrs.isMidCodepointBoundary(text.utf8.count, in: text) == false)
        #expect(attrs.isMidCodepointBoundary(2, in: text) == true)
        #expect(attrs.isMidCodepointBoundary(5, in: text) == true)
        #expect(attrs.isMidCodepointBoundary(6, in: text) == true)
    }

    @Test @MainActor func clampedPangoByteRangeNormalizesFullyOutOfBoundsRange() {
        ensureAdwInit()
        let text = "hello"
        let attrs = TextAttributes()

        let normalized = attrs.clampedPangoByteRange(for: 10 ..< 12, in: text)
        #expect(normalized == 5 ..< 5)
    }

    @Test @MainActor func removeAllClearsInsertedAttributes() {
        ensureAdwInit()
        let text = "hello world"
        let attrs = TextAttributes()
        attrs.addItalic(range: text.startIndex ..< text.endIndex, in: text)
        attrs.addUnderline()

        #expect(capturedAttributes(in: attrs).isEmpty == false)

        attrs.removeAll()
        #expect(capturedAttributes(in: attrs).isEmpty)
    }
}
#endif
