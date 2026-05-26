// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Testing
@testable import Adwaita

@Suite(.serialized)
struct PangoMarkupTests {
    @Test func escapeCoversDistinctInputShapes() {
        let cases: [(String, String)] = [
            ("", ""),
            ("plain", "plain"),
            ("a & b", "a &amp; b"),
            ("<b>", "&lt;b&gt;"),
            (#""q""#, "&quot;q&quot;"),
            ("'a'", "&apos;a&apos;"),
            ("привет", "привет"),
            (
                #"foo<a href="javascript:alert(1)">x</a>bar"#,
                "foo&lt;a href=&quot;javascript:alert(1)&quot;&gt;x&lt;/a&gt;bar"
            ),
            ("&amp;", "&amp;amp;")
        ]

        for (input, expected) in cases {
            #expect(PangoMarkup.escape(input) == expected)
        }
    }

    @Test @MainActor func escapedTextCanBeInterpolatedIntoLabelMarkup() {
        ensureAdwInit()
        let original = #"5 < 7 & "quoted""#
        let label = Label("")
        label.markup = "<b>\(PangoMarkup.escape(original))</b>"

        #expect(label.text == original)
    }
}
#endif
