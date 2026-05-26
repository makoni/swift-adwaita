// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct LabelAttributesTests {
    @Test @MainActor func labelAttributesRoundTrip() {
        ensureAdwInit()
        let text = "Aé🙂Z"
        let label = Label(text)
        let attrs = TextAttributes()
        let range = text.index(after: text.startIndex) ..< text.index(before: text.endIndex)
        attrs.addUnderline(range: range, in: text)

        label.attributes = attrs

        let underlineRuns = capturedAttributes(in: label.attributes).filter { $0.type == PANGO_ATTR_UNDERLINE }
        #expect(underlineRuns.count == 1)
        #expect(underlineRuns.first?.start == 1)
        #expect(underlineRuns.first?.end == 7)
        #expect(label.useMarkup == false)
        #expect(label.text == text)
    }

    @Test @MainActor func settingAttributesKeepsMarkupTextIntact() {
        ensureAdwInit()
        let label = Label("")
        label.markup = "<b>hello</b>"
        let attrs = TextAttributes()
        attrs.addUnderline(range: label.text.startIndex ..< label.text.endIndex, in: label.text)

        label.attributes = attrs

        #expect(label.markup == "<b>hello</b>")
        #expect(label.text == "hello")
    }

    @Test @MainActor func labelAttributesGetterReturnsStableWrapper() {
        ensureAdwInit()
        let text = "abcdef"
        let label = Label(text)
        let attrs = TextAttributes()
        attrs.addBold(range: text.startIndex ..< text.index(text.startIndex, offsetBy: 3), in: text)
        label.attributes = attrs

        label.attributes?.addUnderline(range: text.index(text.startIndex, offsetBy: 1) ..< text.endIndex, in: text)
        let first = label.attributes
        let second = label.attributes

        #expect(first === second)
        let captured = capturedAttributes(in: label.attributes)
        #expect(captured.contains { $0.type == PANGO_ATTR_WEIGHT && $0.start == 0 && $0.end == 3 })
        #expect(captured.contains { $0.type == PANGO_ATTR_UNDERLINE && $0.start == 1 && $0.end == 6 })
    }

    @Test @MainActor func labelAttributesRoundTripPreservesMultipleAttributes() {
        ensureAdwInit()
        let text = "Search results"
        let attrs = TextAttributes()
        attrs.addBold(range: text.startIndex ..< text.index(text.startIndex, offsetBy: 6), in: text)
        attrs.addForegroundColor(
            RGBA(red: 0.4, green: 0.6, blue: 0.9),
            range: text.index(after: text.startIndex) ..< text.endIndex,
            in: text
        )

        let label = Label(text)
        label.attributes = attrs

        let captured = capturedAttributes(in: label.attributes)
        #expect(captured.contains { $0.type == PANGO_ATTR_WEIGHT && $0.start == 0 && $0.end == 6 })
        #expect(captured.contains { $0.type == PANGO_ATTR_FOREGROUND && $0.start == 1 && $0.end == text.utf8.count })
    }

    @Test @MainActor func labelAttributesCanBeCleared() {
        ensureAdwInit()
        let label = Label("Plain")
        let attrs = TextAttributes()
        attrs.addBold()
        label.attributes = attrs

        label.attributes = nil
        #expect(label.attributes == nil)
    }
}
#endif
