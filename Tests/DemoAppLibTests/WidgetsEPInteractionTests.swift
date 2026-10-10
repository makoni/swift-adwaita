// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Foundation
import Testing
import Adwaita
import CAdwaita
@testable import DemoAppLib

/// Interaction tests for the Widgets examples EmojiChooser … Picture: drive the
/// real controls out of the `buildWidget()` tree and assert the effect the UI
/// promises on the widget they control.
///
/// Deliberately not covered here:
/// - `Entry`, `Expander`, `ExpanderRow`, `FlowBox`, `Frame`, `Grid`, `Label`,
///   `Overlay`, `PasswordEntry` — static showcases; every control in them is
///   plain GTK/libadwaita behavior with no example code attached.
/// - `FileDialog` and Picture's "Load Image…" — open a modal portal/file
///   chooser and need a real file selection.
/// - `MediaControls` — loads through a modal `FileDialog` and needs a real
///   media file.
/// - `Gesture` — needs real pointer press/move/release sequences, which no
///   in-process signal can synthesize.
@Suite(.serialized)
struct WidgetsEPInteractionTests {
    @MainActor
    static func setUp(_ example: any DemoExample) -> (root: Widget, window: Window) {
        let root = example.buildWidget()
        let window = Window()
        window.setDefaultSize(width: 900, height: 700)
        window.content = root
        window.present()
        drainMainLoop()
        return (root, window)
    }

    @MainActor
    static func tearDown(_ window: Window) {
        window.destroy()
        drainMainLoop()
    }

    // MARK: - Emoji Chooser

    @Test @MainActor
    func emojiChooserPickUpdatesLabel() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(EmojiChooserExample())
        defer { Self.tearDown(window) }

        let chooser = widgetOfType(root, EmojiChooser.self)
        #expect(chooser != nil, "EmojiChooser not found in tree")
        guard let chooser else { return }

        emitEmojiPicked(chooser, "🎉")
        #expect(labelTexts(root).contains("🎉"), "picking an emoji should show it in the result label")
    }

    // MARK: - Filter & Sort

    @Test @MainActor
    func filterSortSearchFiltersAndUpdatesCount() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(FilterSortExample())
        defer { Self.tearDown(window) }

        let search = widgetOfType(root, SearchEntry.self)
        let listView = widgetOfType(root, ListView.self)
        #expect(search != nil)
        #expect(listView != nil)
        guard let search, let listView else { return }
        #expect(rowSuffixLabel(root, rowTitle: "Showing")?.text == "20 items")

        setSearch(search, "an")
        #expect(listItemCount(listView) == 4)
        #expect(listLabels(listView) == ["Banana", "Mango", "Orange", "Tangerine"])
        #expect(
            rowSuffixLabel(root, rowTitle: "Showing")?.text == "4 items",
            "the count row should follow the filter")

        setSearch(search, "")
        #expect(listItemCount(listView) == 20)
        #expect(rowSuffixLabel(root, rowTitle: "Showing")?.text == "20 items")
    }

    @Test @MainActor
    func filterSortOrderSurvivesFiltering() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(FilterSortExample())
        defer { Self.tearDown(window) }

        let search = widgetOfType(root, SearchEntry.self)
        let listView = widgetOfType(root, ListView.self)
        #expect(search != nil)
        #expect(listView != nil)
        guard let search, let listView else { return }

        buttonLabeled(root, "Z→A")?.emitClicked()
        drainMainLoop()
        #expect(listLabels(listView).first == "Watermelon", "Z→A should put Watermelon first")

        // Narrowing the list must keep the chosen order.
        setSearch(search, "an")
        #expect(listLabels(listView) == ["Tangerine", "Orange", "Mango", "Banana"])

        buttonLabeled(root, "A→Z")?.emitClicked()
        drainMainLoop()
        #expect(listLabels(listView) == ["Banana", "Mango", "Orange", "Tangerine"])

        // Widening it again must keep the order too.
        setSearch(search, "")
        #expect(listLabels(listView).prefix(3) == ["Apple", "Banana", "Cherry"])
    }

    @Test @MainActor
    func filterSortResetRestoresList() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(FilterSortExample())
        defer { Self.tearDown(window) }

        let search = widgetOfType(root, SearchEntry.self)
        let listView = widgetOfType(root, ListView.self)
        #expect(search != nil)
        #expect(listView != nil)
        guard let search, let listView else { return }

        buttonLabeled(root, "Z→A")?.emitClicked()
        setSearch(search, "an")
        #expect(listItemCount(listView) == 4)

        buttonLabeled(root, "Reset")?.emitClicked()
        drainMainLoop()
        #expect(search.text.isEmpty, "Reset should clear the search entry")
        #expect(listItemCount(listView) == 20)
        #expect(rowSuffixLabel(root, rowTitle: "Showing")?.text == "20 items")
        #expect(
            listLabels(listView).prefix(3) == ["Apple", "Banana", "Cherry"],
            "Reset should restore the original order")
    }

    // MARK: - Font Picker

    @Test @MainActor
    func fontPickerFontChangeUpdatesLabel() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(FontPickerExample())
        defer { Self.tearDown(window) }

        let fontButton = widgetOfType(root, FontDialogButton.self)
        #expect(fontButton != nil)
        #expect(labelTexts(root).contains("Selected: Sans 14"))

        fontButton?.fontDescription = "Monospace 10"
        #expect(labelTexts(root).contains("Selected: Monospace 10"), "changing the font should update the label")
    }

    // MARK: - Grid View

    @Test @MainActor
    func gridViewSelectedRowTracksSelection() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(GridViewExample())
        defer { Self.tearDown(window) }

        let gridView = widgetOfType(root, GridView.self)
        #expect(gridView != nil)
        guard let gridView, let model = gtk_grid_view_get_model(gridView.opaquePointer) else { return }
        let selection = SingleSelection(borrowing: UnsafeMutableRawPointer(model))

        // SingleSelection autoselects the first color, so the row must say so.
        #expect(selection.selected == 0)
        #expect(
            rowSuffixLabel(root, rowTitle: "Selected")?.text == "Red",
            "the Selected row should reflect the autoselected first item")

        selection.selected = 4
        #expect(rowSuffixLabel(root, rowTitle: "Selected")?.text == "Blue")
    }

    // MARK: - Level Bar

    @Test @MainActor
    func levelBarScalesDriveBars() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(LevelBarExample())
        defer { Self.tearDown(window) }

        let scales = widgetsOfType(root, Scale.self)
        let bars = widgetsOfType(root, LevelBar.self)
        #expect(scales.count == 2)
        #expect(bars.count == 3)
        guard scales.count == 2, bars.count == 3 else { return }

        // Initial state is in sync.
        #expect(abs(bars[0].value - 0.7) < 0.0001)
        #expect(abs(bars[1].value - 3) < 0.0001)

        scales[0].value = 25
        #expect(abs(bars[0].value - 0.25) < 0.0001, "continuous scale should drive the first bar (0–1)")

        scales[1].value = 5
        #expect(abs(bars[1].value - 5) < 0.0001, "discrete scale should drive the second bar")

        #expect(abs(bars[2].value - 0.4) < 0.0001, "the inverted bar has no control")
    }

    // MARK: - List View

    @Test @MainActor
    func listViewAddAndRemoveMessages() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(ListViewExample())
        defer { Self.tearDown(window) }

        let listView = widgetOfType(root, ListView.self)
        let addBtn = buttonLabeled(root, "Add")
        let removeBtn = buttonLabeled(root, "Remove")
        #expect(listView != nil)
        #expect(addBtn != nil)
        #expect(removeBtn != nil)
        guard let listView else { return }
        #expect(listItemCount(listView) == 15)
        #expect(rowSuffixLabel(root, rowTitle: "Items in model")?.text == "15")

        addBtn?.emitClicked()
        drainMainLoop()
        #expect(listItemCount(listView) == 16)
        #expect(rowSuffixLabel(root, rowTitle: "Items in model")?.text == "16")
        #expect(listLabels(listView).contains("Bob: Message #16"), "the new message should be bound and scrolled to")

        removeBtn?.emitClicked()
        removeBtn?.emitClicked()
        drainMainLoop()
        #expect(listItemCount(listView) == 14)
        #expect(rowSuffixLabel(root, rowTitle: "Items in model")?.text == "14")
    }

    // MARK: - Picture

    @Test @MainActor
    func pictureContentFitDropDown() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(PictureExample())
        defer { Self.tearDown(window) }

        let picture = widgetOfType(root, Picture.self)
        let dropDown = widgetOfType(root, DropDown.self)
        #expect(picture != nil)
        #expect(dropDown != nil)
        #expect(picture?.contentFit == GTK_CONTENT_FIT_CONTAIN)
        #expect(dropDown?.selected == 0)

        dropDown?.selected = 1
        #expect(picture?.contentFit == GTK_CONTENT_FIT_COVER)
        dropDown?.selected = 2
        #expect(picture?.contentFit == GTK_CONTENT_FIT_FILL)
        dropDown?.selected = 3
        #expect(picture?.contentFit == GTK_CONTENT_FIT_SCALE_DOWN)
        dropDown?.selected = 0
        #expect(picture?.contentFit == GTK_CONTENT_FIT_CONTAIN)
    }

    @Test @MainActor
    func pictureCanShrinkSwitch() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(PictureExample())
        defer { Self.tearDown(window) }

        let picture = widgetOfType(root, Picture.self)
        let switch_ = widgetOfType(root, Switch.self)
        #expect(picture != nil)
        #expect(switch_ != nil)
        #expect(picture?.canShrink == true)
        #expect(switch_?.active == true)

        switch_?.active = false
        #expect(picture?.canShrink == false)
        switch_?.active = true
        #expect(picture?.canShrink == true)
    }
}

// MARK: - Helpers

/// Every descendant of `root` (including `root`) that is an instance of `T`,
/// in GTK child order.
@MainActor
private func widgetsOfType<T: Widget>(_ root: Widget, _ type: T.Type) -> [T] {
    allWidgets(root).compactMap { $0.tryCast(type) }
}

/// The text of every `Label` under `root`, in GTK child order.
@MainActor
private func labelTexts(_ root: Widget) -> [String] {
    widgetsOfType(root, Label.self).map(\.text)
}

/// The labels of the rows a `ListView` currently has bound, in display order.
@MainActor
private func listLabels(_ listView: ListView) -> [String] {
    labelTexts(listView)
}

/// Number of items in the model a `ListView` displays.
@MainActor
private func listItemCount(_ listView: ListView) -> Int {
    guard let model = gtk_list_view_get_model(listView.opaquePointer) else { return -1 }
    return Int(g_list_model_get_n_items(model))
}

/// The dimmed suffix label of the `ActionRow` titled `rowTitle`.
@MainActor
private func rowSuffixLabel(_ root: Widget, rowTitle: String) -> Label? {
    for widget in allWidgets(root) {
        guard let row = widget.tryCast(ActionRow.self), row.title == rowTitle else { continue }
        return widgetsOfType(row, Label.self).first { $0.hasCSSClass("dim-label") }
    }
    return nil
}

/// Sets the search text and emits `search-changed` right away (a non-empty
/// text only emits it after GTK's search delay), then lets the list re-layout.
@MainActor
private func setSearch(_ search: SearchEntry, _ text: String) {
    search.text = text
    search.emitSearchChanged()
    drainMainLoop()
}

/// Emits `GtkEmojiChooser::emoji-picked` as if the user had clicked `emoji`.
/// `g_signal_emit_by_name` is variadic, so go through `g_signal_emitv`.
@MainActor
private func emitEmojiPicked(_ chooser: EmojiChooser, _ emoji: String) {
    let type = gtk_emoji_chooser_get_type()
    let signalID = g_signal_lookup("emoji-picked", type)
    var params = [GValue(), GValue()]
    g_value_init(&params[0], type)
    g_value_set_object(&params[0], chooser.pointer)
    g_value_init(&params[1], cadw_type_string())
    g_value_set_string(&params[1], emoji)
    params.withUnsafeMutableBufferPointer { buffer in
        g_signal_emitv(buffer.baseAddress, signalID, 0, nil)
    }
    g_value_unset(&params[0])
    g_value_unset(&params[1])
}
#endif
