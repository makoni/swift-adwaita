// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Testing
@testable import Adwaita
import CAdwaita

/// Regression tests for the `gtkType` override on `Widget` subclasses.
///
/// `Widget.gtkType` defaults to `gtk_widget_get_type()`. If a subclass
/// fails to override it, `tryCast`/`isInstance(of:)` collapse to "is a
/// GtkWidget" and return false positives for *any* widget. Each assertion
/// below would FAIL (return a non-nil cast) for a type whose `gtkType` is
/// still the default, so this suite locks in the narrowing behaviour.
@Suite(.serialized)
struct GtkTypeOverrideTests {

    @Test @MainActor func _00_initAdwaita() {
        ensureAdwInit()
        #expect(Bool(true))
    }

    // MARK: - tryCast must narrow, not collapse to "is a GtkWidget"

    @Test @MainActor func boxDoesNotMisCastToOtherTypes() {
        let box = Box()
        // A Box is a Box.
        #expect(box.tryCast(Box.self) != nil)
        // A Box is NOT any of these unrelated widget types.
        #expect(box.tryCast(ScrolledWindow.self) == nil)
        #expect(box.tryCast(Label.self) == nil)
        #expect(box.tryCast(ListView.self) == nil)
        #expect(box.tryCast(Button.self) == nil)
        #expect(box.tryCast(Overlay.self) == nil)
        #expect(box.tryCast(Picture.self) == nil)
        #expect(box.tryCast(Grid.self) == nil)
        #expect(box.tryCast(Stack.self) == nil)
    }

    @Test @MainActor func labelDoesNotMisCastToContainers() {
        let label = Label("x")
        #expect(label.tryCast(Label.self) != nil)
        #expect(label.tryCast(Box.self) == nil)
        #expect(label.tryCast(ScrolledWindow.self) == nil)
        #expect(label.tryCast(ListView.self) == nil)
    }

    @Test @MainActor func containerTypesNarrowCorrectly() {
        let scrolled = ScrolledWindow()
        #expect(scrolled.tryCast(ScrolledWindow.self) != nil)
        #expect(scrolled.tryCast(Box.self) == nil)
        #expect(scrolled.tryCast(Stack.self) == nil)

        let stack = Stack()
        #expect(stack.tryCast(Stack.self) != nil)
        #expect(stack.tryCast(Box.self) == nil)
        #expect(stack.tryCast(ScrolledWindow.self) == nil)

        let overlay = Overlay()
        #expect(overlay.tryCast(Overlay.self) != nil)
        #expect(overlay.tryCast(Box.self) == nil)
    }

    @Test @MainActor func leafWidgetsNarrowCorrectly() {
        let button = Button(label: "x")
        #expect(button.tryCast(Button.self) != nil)
        #expect(button.tryCast(Label.self) == nil)
        #expect(button.tryCast(Box.self) == nil)

        let picture = Picture()
        #expect(picture.tryCast(Picture.self) != nil)
        #expect(picture.tryCast(Image.self) == nil)
        #expect(picture.tryCast(Box.self) == nil)
    }

    // MARK: - isInstance(of:) parity

    @Test @MainActor func isInstanceNarrows() {
        let box = Box()
        #expect(box.isInstance(of: Box.self))
        #expect(!box.isInstance(of: Label.self))
        #expect(!box.isInstance(of: ScrolledWindow.self))
    }
}
#endif
