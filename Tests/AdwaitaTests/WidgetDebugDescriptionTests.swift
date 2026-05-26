// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Testing
@testable import Adwaita

@Suite(.serialized)
struct WidgetDebugDescriptionTests {
    @Test @MainActor func debugDescriptionRedactsUserText() {
        ensureAdwInit()

        let box = Box(orientation: .vertical, spacing: 12)
        let label = Label("secret token")
        let button = Button(label: "delete production database")
        button.addCSSClass(.suggestedAction)
        box.append(label)
        box.append(button)

        let description = box.debugDescription

        #expect(description.contains("GtkBox"))
        #expect(description.contains("GtkLabel"))
        #expect(description.contains("GtkButton"))
        #expect(description.contains("suggested-action"))
        #expect(description.contains("secret token") == false)
        #expect(description.contains("delete production database") == false)
    }

    @Test @MainActor func debugDescriptionSingleWidgetHasOneLine() {
        ensureAdwInit()
        let label = Label("secret token")
        let lines = label.debugDescription.split(separator: "\n")

        #expect(lines.count == 1)
        #expect(lines[0].contains("GtkLabel"))
        #expect(lines[0].contains("secret token") == false)
    }

    @Test @MainActor func debugDescriptionListsParentAndSiblingsWithIndentation() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 8)
        box.append(Label("one"))
        box.append(Label("two"))
        box.append(Label("three"))

        let lines = box.debugDescription.split(separator: "\n").map(String.init)
        #expect(lines.count == 4)
        #expect(lines[0].hasPrefix("GtkBox"))
        #expect(lines[1].hasPrefix("  GtkLabel"))
        #expect(lines[2].hasPrefix("  GtkLabel"))
        #expect(lines[3].hasPrefix("  GtkLabel"))
    }

    @Test @MainActor func debugDescriptionShowsNestedDepthIndentation() {
        ensureAdwInit()
        let outer = Box(orientation: .vertical, spacing: 4)
        let inner = Box(orientation: .vertical, spacing: 4)
        inner.append(Label("hidden"))
        outer.append(inner)

        let lines = outer.debugDescription.split(separator: "\n").map(String.init)
        #expect(lines.count == 3)
        #expect(lines[0].hasPrefix("GtkBox"))
        #expect(lines[1].hasPrefix("  GtkBox"))
        #expect(lines[2].hasPrefix("    GtkLabel"))
    }

    @Test @MainActor func debugDescriptionIncludesCssClassesWhenPresent() {
        ensureAdwInit()
        let button = Button(label: "unsafe")
        button.addCSSClass(.suggestedAction)

        let line = button.debugDescription
        #expect(line.contains("suggested-action"))
    }

    @Test @MainActor func debugDescriptionOmitsCssSegmentWhenNoCssClass() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        box.cssClasses = []

        let line = box.debugDescription
        #expect(line.contains("css=[") == false)
    }

    @Test @MainActor func debugDescriptionIncludesVisibilityAndFocusableFlags() {
        ensureAdwInit()
        let button = Button(label: "unsafe")
        button.visible = false
        button.isFocusable = true

        let line = button.debugDescription
        #expect(line.contains("visible=false"))
        #expect(line.contains("focusable=true"))
    }

    @Test @MainActor func debugDescriptionHandlesLargeTreesWithoutOverflow() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        for index in 0 ..< 100 {
            box.append(Label("row-\(index)"))
        }

        let lines = box.debugDescription.split(separator: "\n")
        #expect(lines.count == 101)
    }
}
#endif
