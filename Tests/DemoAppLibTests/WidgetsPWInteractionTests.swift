// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Foundation
import Testing
import Adwaita
@testable import DemoAppLib

/// Interaction tests for the widget examples `ProgressBar` … `WrapBox`: drive
/// each real control out of the `buildWidget()` tree and assert the effect the
/// UI promises on the widget it controls.
///
/// Deliberately not covered here:
/// - `Separator` / `WrapBox` / `ToggleGroup` — purely presentational; nothing
///   in the example reacts to the controls (toggle exclusivity is libadwaita's
///   own behavior).
/// - `UriLauncher` Launch with an allowed scheme — opens the system browser.
///   The preset buttons are covered by `uriLauncherPresetButtonsSetEntry`;
///   only the scheme-allowlist rejection path is driven here.
/// - `Video` playback / "Open Video..." — needs a modal `FileDialog` and a
///   real media file; only the property switches are driven.
/// - `SplitButton` icon/style popovers — their items only close the popover.
@Suite(.serialized)
struct WidgetsPWInteractionTests {
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

    /// Every descendant of `root` that is an instance of `T`, in GTK child order.
    @MainActor
    static func widgets<T: Widget>(_ root: Widget, _ type: T.Type) -> [T] {
        allWidgets(root).compactMap { $0.tryCast(type) }
    }

    /// The first label in `root` whose text satisfies `predicate`.
    @MainActor
    static func label(_ root: Widget, where predicate: (String) -> Bool) -> Label? {
        widgets(root, Label.self).first { predicate($0.text) }
    }

    /// The first button in `root` showing `iconName`.
    @MainActor
    static func button(_ root: Widget, iconName: String) -> Button? {
        widgets(root, Button.self).first { $0.iconName == iconName }
    }

    /// Runs `body` with the app-wide color scheme, restoring the original
    /// afterwards so other suites never see a forced scheme.
    @MainActor
    static func withColorSchemeRestored(_ body: (StyleManager) -> Void) {
        let styleManager = StyleManager.default
        let original = styleManager.colorScheme
        defer {
            styleManager.colorScheme = original
            drainMainLoop()
        }
        body(styleManager)
    }

    // MARK: - ProgressBar

    @Test @MainActor
    func progressBarButtonsStepFraction() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(ProgressBarExample())
        defer { Self.tearDown(window) }

        let bar = widgetOfType(root, ProgressBar.self)
        let inc = Self.button(root, iconName: "list-add-symbolic")
        let dec = Self.button(root, iconName: "list-remove-symbolic")
        let reset = buttonLabeled(root, "Reset")
        #expect(bar != nil)
        #expect(inc != nil)
        #expect(dec != nil)
        #expect(reset != nil)
        #expect(abs((bar?.fraction ?? 0) - 0.4) < 0.0001)

        inc?.emitClicked()
        #expect(abs((bar?.fraction ?? 0) - 0.5) < 0.0001)
        #expect(bar?.text == "50%")

        dec?.emitClicked()
        dec?.emitClicked()
        #expect(abs((bar?.fraction ?? 0) - 0.3) < 0.0001)
        #expect(bar?.text == "30%")

        reset?.emitClicked()
        #expect(bar?.fraction == 0)
        #expect(bar?.text == "0%")

        // Repeated steps must not drift (0.7 + 0.1 == 0.7999… would read "79%").
        for step in 1 ... 10 {
            inc?.emitClicked()
            #expect(bar?.text == "\(step * 10)%", "after \(step) increases")
        }
        #expect(bar?.fraction == 1.0)
        inc?.emitClicked()
        #expect(bar?.text == "100%", "Increase should stop at 100%")
        for step in 1 ... 10 {
            dec?.emitClicked()
            #expect(bar?.text == "\(100 - step * 10)%", "after \(step) decreases")
        }
        #expect(bar?.fraction == 0)
    }

    // MARK: - Revealer

    @Test @MainActor
    func revealerButtonsToggleTheirOwnRevealer() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(RevealerExample())
        defer { Self.tearDown(window) }

        let revealers = Self.widgets(root, Revealer.self)
        #expect(revealers.count == 3)
        guard revealers.count == 3 else { return }
        #expect(revealers.allSatisfy { $0.revealChild }, "all revealers should start revealed")

        for (index, title) in ["Toggle Slide Down", "Toggle Crossfade", "Toggle Slide Left"].enumerated() {
            let button = buttonLabeled(root, title)
            #expect(button != nil, "\(title) button not found")
            button?.emitClicked()
            #expect(revealers[index].revealChild == false, "\(title) should hide its revealer")
            for other in revealers.indices where other != index {
                #expect(revealers[other].revealChild, "\(title) should not touch other revealers")
            }
            button?.emitClicked()
            #expect(revealers[index].revealChild, "\(title) should reveal it again")
        }
    }

    // MARK: - Scale

    @Test @MainActor
    func scaleValueLabelsFollowTheScales() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(ScaleExample())
        defer { Self.tearDown(window) }

        let scales = Self.widgets(root, Scale.self)
        let basicLabel = Self.label(root) { $0 == "50" }
        let preciseLabel = Self.label(root) { $0 == "0.50" }
        #expect(scales.count == 3)
        #expect(basicLabel != nil, "basic scale value label not found")
        #expect(preciseLabel != nil, "precise scale value label not found")
        guard scales.count == 3 else { return }

        scales[0].value = 73
        #expect(basicLabel?.text == "73")

        // Values whose `* 100` is not exactly representable must not be
        // truncated (0.29 * 100 == 28.999…).
        for (value, text) in [(0.29, "0.29"), (0.07, "0.07"), (0.58, "0.58"), (1.0, "1.00"), (0.0, "0.00")] {
            scales[1].value = value
            #expect(preciseLabel?.text == text, "precise label should read \(text) for \(value)")
        }
    }

    // MARK: - Keyboard shortcuts

    /// The shortcut controllers attached to `widget`. The pointers are
    /// unowned: the widget keeps its controllers alive.
    @MainActor
    static func shortcutControllers(of widget: Widget) -> [OpaquePointer] {
        guard let controllers = gtk_widget_observe_controllers(widget.widgetPointer) else { return [] }
        defer { g_object_unref(UnsafeMutableRawPointer(controllers)) }
        var result: [OpaquePointer] = []
        for index in 0 ..< g_list_model_get_n_items(controllers) {
            guard let item = g_list_model_get_item(controllers, index) else { continue }
            g_object_unref(item)
            let isShortcutController =
                g_type_check_instance_is_a(
                    item.assumingMemoryBound(to: GTypeInstance.self),
                    gtk_shortcut_controller_get_type()
                ) != 0
            if isShortcutController { result.append(OpaquePointer(item)) }
        }
        return result
    }

    /// The `GtkShortcut` in `controller` whose trigger prints as `accelerator`
    /// (unowned: the controller keeps it alive).
    @MainActor
    static func shortcut(_ accelerator: String, in controller: OpaquePointer) -> OpaquePointer? {
        for index in 0 ..< g_list_model_get_n_items(controller) {
            guard let item = g_list_model_get_item(controller, index) else { continue }
            g_object_unref(item)
            let shortcut = OpaquePointer(item)
            guard let trigger = gtk_shortcut_get_trigger(shortcut),
                let printed = gtk_shortcut_trigger_to_string(trigger)
            else { continue }
            defer { g_free(printed) }
            if String(cString: printed) == accelerator { return shortcut }
        }
        return nil
    }

    /// Activates the shortcut whose trigger prints as `accelerator`, the same
    /// way GTK does once a key press matched it.
    @MainActor
    @discardableResult
    static func activateShortcut(_ accelerator: String, in controller: OpaquePointer, on widget: Widget) -> Bool {
        guard let shortcut = shortcut(accelerator, in: controller),
            let action = gtk_shortcut_get_action(shortcut)
        else { return false }
        return gtk_shortcut_action_activate(action, GTK_SHORTCUT_ACTION_EXCLUSIVE, widget.widgetPointer, nil) != 0
    }

    @Test @MainActor
    func shortcutsWorkWithoutFocusAndUpdateTheLog() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(ShortcutExample())
        defer { Self.tearDown(window) }

        // Built-in widgets (e.g. the ScrolledWindow) carry their own shortcut
        // controllers; pick the one holding the example's Ctrl+S.
        var found: (host: Widget, controller: OpaquePointer)?
        for widget in allWidgets(root) where found == nil {
            if let controller = Self.shortcutControllers(of: widget).first(where: {
                Self.shortcut("<Control>s", in: $0) != nil
            }) {
                found = (widget, controller)
            }
        }
        let log = Self.label(root) { $0 == "Press a shortcut..." }
        #expect(found != nil, "no widget carries the example's shortcut controller")
        #expect(log != nil, "log label not found")
        guard let (host, controller) = found else { return }

        // Nothing in the page is focusable by clicking the log area, so a
        // LOCAL-scope controller would never see the key presses the page asks
        // for. The controller must be managed by the window instead.
        #expect(
            gtk_shortcut_controller_get_scope(controller) == GTK_SHORTCUT_SCOPE_MANAGED,
            "shortcuts must fire without first focusing the example")

        #expect(Self.activateShortcut("<Control>s", in: controller, on: host))
        #expect(log?.text == "Ctrl+S — Save triggered!")
        #expect(Self.activateShortcut("<Shift><Control>z", in: controller, on: host))
        #expect(log?.text == "Ctrl+Shift+Z — Redo triggered!")
        #expect(Self.activateShortcut("<Control>2", in: controller, on: host))
        #expect(log?.text == "Ctrl+2 triggered!")
    }

    // MARK: - SourceView

    @Test @MainActor
    func sourceViewFollowsDarkStyle() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(SourceViewExample())
        defer { Self.tearDown(window) }

        let views = Self.widgets(root, SourceView.self)
        #expect(views.count == 2)
        let light = SourceStyleSchemeManager.default.preferredSchemeID(dark: false)
        let dark = SourceStyleSchemeManager.default.preferredSchemeID(dark: true)
        guard let light, let dark, light != dark else { return }

        Self.withColorSchemeRestored { styleManager in
            styleManager.colorScheme = .forceDark
            drainMainLoop()
            for view in views {
                #expect(view.buffer.styleScheme?.id == dark.rawValue, "editor should switch to the dark scheme")
            }
            styleManager.colorScheme = .forceLight
            drainMainLoop()
            for view in views {
                #expect(view.buffer.styleScheme?.id == light.rawValue, "editor should switch to the light scheme")
            }
        }
    }

    // MARK: - SpinRow

    @Test @MainActor
    func spinRowsWrapAndSnap() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(SpinRowExample())
        defer { Self.tearDown(window) }

        let rows = Self.widgets(root, SpinRow.self)
        #expect(rows.count == 4)
        guard rows.count == 4 else { return }
        let (hour, percentage) = (rows[2], rows[3])

        // "Snaps to nearest 10": typed values are snapped on update.
        gtk_editable_set_text(percentage.opaquePointer, "47")
        percentage.update()
        #expect(percentage.value == 50, "snap-to-ticks row should snap 47 to 50")

        // "Wraps around at boundaries": stepping past 23 goes back to 0. The
        // row's +/- buttons step on click gestures rather than `clicked`, so
        // step the row's internal GtkSpinButton the way they do.
        hour.value = 23
        let spinButton = allWidgets(hour).first { $0.isInstance(of: gtk_spin_button_get_type()) }
        #expect(spinButton != nil, "hour row spin button not found")
        if let spinButton {
            gtk_spin_button_spin(OpaquePointer(spinButton.pointer), GTK_SPIN_STEP_FORWARD, 1)
        }
        #expect(hour.value == 0, "wrapping row should wrap 23 + 1 to 0")
    }

    // MARK: - Spinner

    @Test @MainActor
    func spinnerToggleHidesAndShowsAllSpinners() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(SpinnerExample())
        defer { Self.tearDown(window) }

        guard AdwaitaVersion.isAtLeast(1, 6) else {
            #expect(widgetOfType(root, Spinner.self) == nil)
            return
        }
        let spinners = Self.widgets(root, Spinner.self)
        let toggle = buttonLabeled(root, "Toggle")
        #expect(spinners.count == 3)
        #expect(toggle != nil)
        #expect(spinners.allSatisfy { $0.visible })

        toggle?.emitClicked()
        #expect(spinners.allSatisfy { !$0.visible }, "Toggle should hide every spinner")
        toggle?.emitClicked()
        #expect(spinners.allSatisfy { $0.visible }, "Toggle should show them again")
    }

    // MARK: - SplitButton

    @Test @MainActor
    func splitButtonMainAndMenuOptionsReportSelection() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(SplitButtonExample())
        defer { Self.tearDown(window) }

        let split = widgetOfType(root, SplitButton.self)
        let status = Self.label(root) { $0 == "Click the button or dropdown" }
        #expect(split != nil)
        #expect(status != nil)

        split?.emitClicked()
        #expect(status?.text == "Main button clicked!")

        let optionB = buttonLabeled(root, "Option B")
        #expect(optionB != nil, "popover option not found in tree")
        optionB?.emitClicked()
        #expect(status?.text == "Option B selected")
    }

    // MARK: - StackSwitcher

    @Test @MainActor
    func stackSwitcherButtonsSwitchPages() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(StackSwitcherExample())
        defer { Self.tearDown(window) }

        let stack = widgetOfType(root, Stack.self)
        let switcher = widgetOfType(root, StackSwitcher.self)
        #expect(stack != nil)
        #expect(switcher != nil)
        guard let switcher else { return }
        #expect(stack?.visibleChildName == "home")

        let buttons = Self.widgets(switcher, ToggleButton.self)
        #expect(buttons.count == 3)
        guard buttons.count == 3 else { return }

        buttons[1].active = true
        #expect(stack?.visibleChildName == "settings")
        buttons[2].active = true
        #expect(stack?.visibleChildName == "about")
        #expect(buttons[1].active == false, "switcher buttons should stay exclusive")

        stack?.visibleChildName = "home"
        #expect(buttons[0].active, "switcher should follow the stack")
    }

    // MARK: - Switches

    @Test @MainActor
    func darkModeSwitchDrivesAndFollowsTheStyleManager() {
        ensureDemoAdwInit()
        Self.withColorSchemeRestored { styleManager in
            styleManager.colorScheme = .forceLight
            drainMainLoop()

            let (root, window) = Self.setUp(SwitchExample())
            defer { Self.tearDown(window) }

            let toggle = widgetOfType(root, Switch.self)
            #expect(toggle != nil, "Dark Mode switch not found")
            #expect(toggle?.active == false, "switch should start in sync with the light style")

            toggle?.active = true
            drainMainLoop()
            #expect(styleManager.dark, "turning the switch on should use the dark appearance")

            toggle?.active = false
            drainMainLoop()
            #expect(styleManager.dark == false, "turning it off should go back to light")

            // Changed elsewhere (e.g. the Style Manager example): the switch follows.
            styleManager.colorScheme = .forceDark
            drainMainLoop()
            #expect(toggle?.active == true, "switch should follow an external dark switch")
            styleManager.colorScheme = .forceLight
            drainMainLoop()
            #expect(toggle?.active == false, "switch should follow an external light switch")
        }
    }

    // MARK: - TextView

    @Test @MainActor
    func textViewControlsAndCounter() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(TextViewExample())
        defer { Self.tearDown(window) }

        let textView = widgetOfType(root, TextView.self)
        let info = Self.label(root) { $0.hasPrefix("Characters:") }
        let mono = Self.widgets(root, ToggleButton.self).first { $0.tryCast(Button.self)?.label == "Monospace" }
        let editable = Self.widgets(root, ToggleButton.self).first { $0.tryCast(Button.self)?.label == "Editable" }
        #expect(textView != nil)
        #expect(info != nil)
        #expect(mono != nil)
        #expect(editable != nil)
        guard let textView else { return }

        textView.buffer.text = "ab\ncd"
        #expect(info?.text == "Characters: 5 | Lines: 2")

        #expect(textView.monospace == false)
        mono?.active = true
        #expect(textView.monospace)
        mono?.active = false
        #expect(textView.monospace == false)

        #expect(textView.editable)
        editable?.active = false
        #expect(textView.editable == false)
        editable?.active = true
        #expect(textView.editable)
    }

    // MARK: - Toasts

    @Test @MainActor
    func toastButtonsShowToastsAndUndoFollowsUp() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(ToastExample())
        defer { Self.tearDown(window) }

        let showButtons = Self.widgets(root, Button.self).filter { $0.label == "Show" }
        #expect(showButtons.count == 4)
        guard showButtons.count == 4 else { return }

        func toastShowing(_ title: String) -> Bool {
            Self.label(root) { $0 == title } != nil
        }

        showButtons[0].emitClicked()
        drainMainLoop()
        #expect(toastShowing("Hello from swift-adwaita!"))
        widgetOfType(root, ToastOverlay.self)?.dismissAll()
        waitUntil { !toastShowing("Hello from swift-adwaita!") }

        showButtons[1].emitClicked()
        waitUntil { toastShowing("File deleted") && buttonLabeled(root, "Undo") != nil }
        #expect(toastShowing("File deleted"))
        let undo = buttonLabeled(root, "Undo")
        #expect(undo != nil, "toast Undo button not found")
        undo?.emitClicked()
        waitUntil { toastShowing("Undo successful") }
        #expect(toastShowing("Undo successful"), "Undo should show the follow-up toast")
    }

    // MARK: - TreeList

    @Test @MainActor
    func treeListExpandsFoldersWithLabelledChildren() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(TreeListExample())
        defer { Self.tearDown(window) }

        let listView = widgetOfType(root, ListView.self)
        #expect(listView != nil)
        guard let listView,
            let model = gtk_list_view_get_model(listView.opaquePointer)
        else { return }
        #expect(g_list_model_get_n_items(model) == 5, "five root items")

        guard let treeModelPtr = gtk_single_selection_get_model(model) else { return }
        let treeModel = TreeListModel(borrowing: UnsafeMutableRawPointer(treeModelPtr))
        let sources = treeModel.row(at: 0)
        #expect(sources?.isExpandable == true, "Sources should be expandable")
        #expect(treeModel.row(at: 3)?.isExpandable == false, "Package.swift is a leaf")

        sources?.expanded = true
        drainMainLoop()
        #expect(g_list_model_get_n_items(model) == 7, "Sources expands to App + Library")
        #expect(Self.label(root) { $0 == "App" } != nil, "expanded child should be labelled")

        treeModel.row(at: 1)?.expanded = true
        drainMainLoop()
        #expect(g_list_model_get_n_items(model) == 10, "App expands to three children")
        #expect(Self.label(root) { $0 == "AppDelegate.swift" } != nil)

        sources?.expanded = false
        drainMainLoop()
        #expect(g_list_model_get_n_items(model) == 5, "collapsing Sources hides its subtree")
    }

    // MARK: - UriLauncher

    @Test @MainActor
    func uriLauncherRejectsDisallowedSchemes() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(UriLauncherExample())
        defer { Self.tearDown(window) }

        let entry = widgetOfType(root, Entry.self)
        let status = Self.label(root) { $0 == "Idle" }
        #expect(entry != nil)
        #expect(status != nil)

        // Never launches: the allowlist rejects the scheme before UriLauncher.
        entry?.text = "javascript:alert(1)"
        buttonLabeled(root, "Launch")?.emitClicked()
        #expect(status?.text == "Only http(s)/file URIs are launched here")
    }

    // MARK: - Video

    @Test @MainActor
    func videoSwitchesDriveAutoplayAndLoop() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(VideoExample())
        defer { Self.tearDown(window) }

        let video = widgetOfType(root, Video.self)
        let switches = Self.widgets(root, Switch.self)
        #expect(video != nil)
        #expect(switches.count == 2)
        guard let video, switches.count == 2 else { return }
        let (autoplay, loop) = (switches[0], switches[1])
        #expect(video.autoplay == autoplay.active)
        #expect(video.loop == loop.active)

        autoplay.active = true
        #expect(video.autoplay)
        autoplay.active = false
        #expect(video.autoplay == false)

        loop.active = false
        #expect(video.loop == false)
        loop.active = true
        #expect(video.loop)
    }
}
#endif
