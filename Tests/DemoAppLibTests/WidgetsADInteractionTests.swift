// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Foundation
import Testing
import Adwaita
@testable import DemoAppLib

/// Interaction tests for the widget examples ActionBar … DropDown: drive each
/// example's real controls out of the `buildWidget()` tree and assert the
/// effect the UI promises.
///
/// Deliberately not covered here:
/// - `AspectFrame` / `CenterBox` — already covered by
///   `DemoExampleInteractionTests`.
/// - `AnimatedImagePlayer` — loads through a modal `FileDialog` and needs real
///   media files.
/// - `Avatar`, `ColumnView`, `CssProvider`, `DrawingArea` — static showcases
///   with no example-defined controls (column resize/reorder needs a real
///   pointer). `CssProvider` would also leave its provider on the display.
/// - `ComboRow` — plain selection rows with no example-defined handler; what
///   is left is libadwaita's own behavior.
/// - `Clipboard` — Copy/Paste go through the display's system clipboard, which
///   would clobber the developer's clipboard and isn't reliable headless.
/// - `ColorPicker` dialog — the modal color chooser can't be driven; the label
///   is tested by setting the button's color directly.
@Suite(.serialized)
struct WidgetsADInteractionTests {
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

    // MARK: - Helpers

    /// Every descendant of `root` that is an instance of `T`, in tree order.
    @MainActor
    static func widgetsOfType<T: Widget>(_ root: Widget, _ type: T.Type) -> [T] {
        allWidgets(root).compactMap { $0.tryCast(type) }
    }

    /// The first label in `root` whose text satisfies `predicate`.
    @MainActor
    static func label(in root: Widget, where predicate: (String) -> Bool) -> Label? {
        widgetsOfType(root, Label.self).first { predicate($0.text) }
    }

    /// The first check button in `root` with exactly this label.
    @MainActor
    static func checkButtonLabeled(_ root: Widget, _ label: String) -> CheckButton? {
        widgetsOfType(root, CheckButton.self).first { $0.label == label }
    }

    /// The first `GtkDropTarget` controller attached to `widget`, borrowed
    /// (caller does not own a reference).
    @MainActor
    static func dropTargetPointer(on widget: Widget) -> UnsafeMutableRawPointer? {
        guard let model = gtk_widget_observe_controllers(widget.castedPointer()) else { return nil }
        defer { g_object_unref(UnsafeMutableRawPointer(model)) }
        for index in 0 ..< g_list_model_get_n_items(model) {
            guard let item = g_list_model_get_item(model, index) else { continue }
            // The widget keeps the controller alive; drop the ref get_item added.
            g_object_unref(item)
            let instance = item.assumingMemoryBound(to: GTypeInstance.self)
            if g_type_check_instance_is_a(instance, gtk_drop_target_get_type()) != 0 {
                return item
            }
        }
        return nil
    }

    /// Emits `GtkDropTarget::drop` with a string payload (what a real text drop
    /// delivers) and returns the handler's accept/reject result.
    @MainActor
    static func emitTextDrop(_ target: UnsafeMutableRawPointer, text: String) -> Bool {
        var payload = GValue()
        g_value_init(&payload, cadw_type_string())
        g_value_set_string(&payload, text)
        defer { g_value_unset(&payload) }

        var params = [GValue](repeating: GValue(), count: 4)
        g_value_init(&params[0], gtk_drop_target_get_type())
        g_value_set_object(&params[0], target)
        g_value_init(&params[1], g_value_get_type())
        withUnsafeMutablePointer(to: &payload) { g_value_set_boxed(&params[1], $0) }
        g_value_init(&params[2], cadw_type_double())
        g_value_set_double(&params[2], 10)
        g_value_init(&params[3], cadw_type_double())
        g_value_set_double(&params[3], 10)

        var result = GValue()
        g_value_init(&result, cadw_type_boolean())
        let signalID = g_signal_lookup("drop", gtk_drop_target_get_type())
        g_signal_emitv(params, signalID, 0, &result)
        let accepted = g_value_get_boolean(&result) != 0
        g_value_unset(&result)
        for index in params.indices { g_value_unset(&params[index]) }
        return accepted
    }

    /// Emits `GtkDropTarget::enter` at a fixed point and returns the preferred
    /// action the handler reported.
    @MainActor
    static func emitDropEnter(_ target: UnsafeMutableRawPointer) -> GdkDragAction {
        var params = [GValue](repeating: GValue(), count: 3)
        g_value_init(&params[0], gtk_drop_target_get_type())
        g_value_set_object(&params[0], target)
        g_value_init(&params[1], cadw_type_double())
        g_value_set_double(&params[1], 10)
        g_value_init(&params[2], cadw_type_double())
        g_value_set_double(&params[2], 10)

        var result = GValue()
        g_value_init(&result, gdk_drag_action_get_type())
        let signalID = g_signal_lookup("enter", gtk_drop_target_get_type())
        g_signal_emitv(params, signalID, 0, &result)
        let action = GdkDragAction(rawValue: g_value_get_flags(&result))
        g_value_unset(&result)
        for index in params.indices { g_value_unset(&params[index]) }
        return action
    }

    /// The string a drag source would hand to a drop target, read straight
    /// from its content provider.
    @MainActor
    static func dragSourceText(on widget: Widget) -> String? {
        guard let model = gtk_widget_observe_controllers(widget.castedPointer()) else { return nil }
        defer { g_object_unref(UnsafeMutableRawPointer(model)) }
        for index in 0 ..< g_list_model_get_n_items(model) {
            guard let item = g_list_model_get_item(model, index) else { continue }
            defer { g_object_unref(item) }
            let instance = item.assumingMemoryBound(to: GTypeInstance.self)
            guard g_type_check_instance_is_a(instance, gtk_drag_source_get_type()) != 0,
                let content = gtk_drag_source_get_content(OpaquePointer(item))
            else { continue }
            var value = GValue()
            g_value_init(&value, cadw_type_string())
            defer { g_value_unset(&value) }
            guard gdk_content_provider_get_value(content, &value, nil) != 0 else { return nil }
            return g_value_get_string(&value).map { String(cString: $0) }
        }
        return nil
    }

    // MARK: - ActionBar

    @Test @MainActor
    func actionBarRevealSwitch() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(ActionBarExample())
        defer { Self.tearDown(window) }

        let bar = widgetOfType(root, ActionBar.self)
        let switch_ = widgetOfType(root, Switch.self)
        #expect(bar != nil)
        #expect(switch_ != nil)
        #expect(bar?.revealed == true, "the bar should start revealed")
        #expect(switch_?.active == true, "the switch should start in sync with the bar")

        switch_?.active = false
        #expect(bar?.revealed == false)
        switch_?.active = true
        #expect(bar?.revealed == true)
    }

    @Test @MainActor
    func actionBarActionsDismissBar() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(ActionBarExample())
        defer { Self.tearDown(window) }

        let bar = widgetOfType(root, ActionBar.self)
        let switch_ = widgetOfType(root, Switch.self)
        #expect(bar != nil)
        #expect(switch_ != nil)

        for label in ["Cancel", "Apply"] {
            switch_?.active = true
            #expect(bar?.revealed == true)
            let button = buttonLabeled(root, label)
            #expect(button != nil, "\(label) button not found")
            button?.emitClicked()
            #expect(bar?.revealed == false, "\(label) should dismiss the action bar")
            #expect(switch_?.active == false, "\(label) should keep the Revealed switch in sync")
        }
    }

    // MARK: - AlertDialog

    @Test @MainActor
    func alertDialogButtonsPresentDialogs() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(AlertDialogExample())
        defer { Self.tearDown(window) }

        let showButtons = Self.widgetsOfType(root, Button.self).filter { $0.label == "Show" }
        #expect(showButtons.count == 3)

        let headings = ["Information", "Save Changes?", "Delete File?"]
        for (button, heading) in zip(showButtons, headings) {
            #expect(window.visibleDialog == nil)
            button.emitClicked()
            drainMainLoop()
            let dialog = window.visibleDialog?.tryCast(AlertDialog.self)
            #expect(dialog?.heading == heading, "expected the \"\(heading)\" dialog to be presented")
            dialog?.forceClose()
            drainMainLoop()
        }
    }

    // MARK: - Banner

    @Test @MainActor
    func bannerToggleButtonAndReset() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(BannerExample())
        defer { Self.tearDown(window) }

        let banner = widgetOfType(root, Banner.self)
        let toggle = buttonLabeled(root, "Toggle")
        let reset = buttonLabeled(root, "Reset")
        #expect(banner != nil)
        #expect(toggle != nil)
        #expect(reset != nil)
        #expect(banner?.revealed == true)

        toggle?.emitClicked()
        #expect(banner?.revealed == false)
        toggle?.emitClicked()
        #expect(banner?.revealed == true)

        // The banner's own "Update Now" button.
        if let banner {
            g_signal_emit_by_name_no_args(banner.pointer, "button-clicked")
        }
        #expect(banner?.title == "Updating...")
        #expect((banner?.buttonLabel ?? "").isEmpty, "the update button should be removed")

        toggle?.emitClicked()
        reset?.emitClicked()
        #expect(banner?.title == "New update available")
        #expect(banner?.buttonLabel == "Update Now")
        #expect(banner?.revealed == true, "Reset should reveal the banner again")
    }

    // MARK: - Button

    @Test @MainActor
    func buttonClickMeRelabels() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(ButtonExample())
        defer { Self.tearDown(window) }

        let button = buttonLabeled(root, "Click Me")
        #expect(button != nil)
        button?.emitClicked()
        #expect(button?.label == "Clicked!")
    }

    // MARK: - ButtonRow

    @Test @MainActor
    func buttonRowActivationReportsRow() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(ButtonRowExample())
        defer { Self.tearDown(window) }

        guard ButtonRow.isAvailable else {
            // Pre-1.6 runtimes have no `activated` signal; the example must not
            // show feedback it can't deliver.
            #expect(Self.label(in: root) { $0 == "Activate a row above" } == nil)
            return
        }

        let rows = Self.widgetsOfType(root, ButtonRow.self)
        #expect(rows.count == 3)
        let status = Self.label(in: root) { $0 == "Activate a row above" }
        #expect(status != nil, "activation status label not found")

        for row in rows {
            g_signal_emit_by_name_no_args(row.pointer, "activated")
            #expect(status?.text == "Activated: \(row.title)")
        }
    }

    // MARK: - Calendar

    @Test @MainActor
    func calendarDaySelectionUpdatesLabel() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(CalendarExample())
        defer { Self.tearDown(window) }

        let calendar = widgetOfType(root, Adwaita.Calendar.self)
        let result = Self.label(in: root) { $0 == "Select a date" }
        #expect(calendar != nil)
        #expect(result != nil)

        calendar?.year = 2024
        calendar?.month = 3
        calendar?.day = 15
        // The label uses the 1-based month, matching what the calendar shows.
        #expect(result?.text == "Selected: 2024-3-15")
    }

    // MARK: - CheckButton

    @Test @MainActor
    func checkButtonsReportSelection() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(CheckButtonExample())
        defer { Self.tearDown(window) }

        let featureA = Self.checkButtonLabeled(root, "Feature A")
        let featureC = Self.checkButtonLabeled(root, "Feature C")
        let status = Self.label(in: root) { $0 == "No selection" }
        #expect(featureA != nil)
        #expect(featureC != nil)
        #expect(status != nil)

        featureA?.active = true
        #expect(status?.text == "Selected: A")
        featureC?.active = true
        #expect(status?.text == "Selected: A, C")
        featureA?.active = false
        featureC?.active = false
        #expect(status?.text == "No selection")
    }

    @Test @MainActor
    func checkButtonRadioGroupReportsChoice() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(CheckButtonExample())
        defer { Self.tearDown(window) }

        let option1 = Self.checkButtonLabeled(root, "Option 1")
        let option3 = Self.checkButtonLabeled(root, "Option 3")
        let radioLabel = Self.label(in: root) { $0 == "Selected: Option 1" }
        #expect(option1?.active == true)
        #expect(radioLabel != nil)

        option3?.active = true
        #expect(option1?.active == false, "radio group should be mutually exclusive")
        #expect(radioLabel?.text == "Selected: Option 3")
        option1?.active = true
        #expect(option3?.active == false)
        #expect(radioLabel?.text == "Selected: Option 1")
    }

    @Test @MainActor
    func checkButtonTriStateClearsOnToggle() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(CheckButtonExample())
        defer { Self.tearDown(window) }

        let tri = Self.checkButtonLabeled(root, "Select all items")
        #expect(tri?.inconsistent == true, "should start indeterminate")
        tri?.active = true
        #expect(tri?.inconsistent == false, "toggling should leave the indeterminate state")
    }

    // MARK: - ColorPicker

    @Test @MainActor
    func colorPickerLabelTracksColor() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(ColorPickerExample())
        defer { Self.tearDown(window) }

        let button = widgetOfType(root, ColorDialogButton.self)
        let result = Self.label(in: root) { $0.hasPrefix("Selected:") }
        #expect(button != nil)
        #expect(result != nil)
        // The initial text must describe the initial color in the same
        // notation every later change uses.
        #expect(result?.text == "Selected: rgb(51, 153, 255)")

        button?.rgba = RGBA(red: 1, green: 0.5, blue: 0)
        #expect(result?.text == "Selected: rgb(255, 128, 0)")
    }

    // MARK: - DragDrop

    @Test @MainActor
    func dragDropSourcesCarryTheirItem() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(DragDropExample())
        defer { Self.tearDown(window) }

        for item in ["Apple", "Banana", "Cherry"] {
            let card = Self.label(in: root) { $0 == item }?.parent
            #expect(card != nil, "\(item) card not found")
            if let card {
                #expect(Self.dragSourceText(on: card) == item, "\(item) card should drag its own name")
            }
        }
    }

    @Test @MainActor
    func dragDropTargetHighlightsAndReceivesText() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(DragDropExample())
        defer { Self.tearDown(window) }

        let dropLabel = Self.label(in: root) { $0 == "Drop here" }
        let dropBox = dropLabel?.parent
        let target = dropBox.flatMap { Self.dropTargetPointer(on: $0) }
        #expect(dropBox != nil)
        #expect(target != nil, "drop box should have a GtkDropTarget")
        guard let dropBox, let dropLabel, let target else { return }

        #expect(Self.emitDropEnter(target) == GDK_ACTION_COPY, "entering should accept a copy")
        #expect(dropBox.hasCSSClass("accent"), "entering should highlight the target")
        g_signal_emit_by_name_no_args(target, "leave")
        #expect(!dropBox.hasCSSClass("accent"), "leaving should clear the highlight")

        #expect(Self.emitTextDrop(target, text: "Banana"))
        #expect(dropLabel.text == "Banana")
        #expect(Self.label(in: root) { $0 == "Received: Banana" } != nil)
    }

    // MARK: - DropDown

    @Test @MainActor
    func dropDownSelectionUpdatesLabel() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(DropDownExample())
        defer { Self.tearDown(window) }

        let dropDown = widgetOfType(root, DropDown.self)
        let result = Self.label(in: root) { $0 == "Selected: Apple" }
        #expect(dropDown != nil)
        #expect(result != nil)

        dropDown?.selected = 2
        #expect(result?.text == "Selected: Cherry")
        dropDown?.selected = 4
        #expect(result?.text == "Selected: Elderberry")
    }
}
#endif
