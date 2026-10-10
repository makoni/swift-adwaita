// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Foundation
import Testing
import Adwaita
@testable import DemoAppLib

/// Interaction tests for the composite examples A–M (About Dialog through
/// Multi-Window): drive each real control out of the `buildWidget()` tree and
/// assert the effect the UI promises.
///
/// Animations are switched off (`gtk-enable-animations = false`) where a control
/// starts one, so libadwaita skips straight to the final value and the effect is
/// observable without waiting on the frame clock.
///
/// Deliberately not covered here:
/// - `CustomCSS` — purely static (CSS classes and `cssName` badges), no controls.
/// - `InlineViewSwitcher` display-mode buttons — already covered by
///   `DemoExampleInteractionTests.inlineViewSwitcherDisplayMode`.
/// - `Carousel` indicator-style switch — already covered by
///   `DemoExampleInteractionTests.carouselIndicatorLinesToggle`.
/// - The rows inside the Dialog / Bottom Sheet sample content other than
///   Dark Mode — mock settings with no effect by design.
/// - The About dialog's links — they open the system browser.
/// - Real key presses for `KeyboardShortcuts` — synthesizing key events isn't
///   possible in-process, so the registered shortcuts' actions are activated
///   directly instead.
@Suite(.serialized)
struct CompositeAMInteractionTests {
    @MainActor
    static func setUp(
        _ example: any DemoExample, width: Int = 900, height: Int = 700
    ) -> (root: Widget, window: Window) {
        let root = example.buildWidget()
        let window = Window()
        window.setDefaultSize(width: width, height: height)
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

    /// Runs `body` with `gtk-enable-animations` off, restoring the previous value.
    @MainActor
    static func withAnimationsDisabled(_ body: () -> Void) {
        guard let settings = gtk_settings_get_default() else {
            body()
            return
        }
        let object = UnsafeMutableRawPointer(settings).assumingMemoryBound(to: GObject.self)
        var previous = GValueRef(true)
        previous.withUnsafeMutablePointer { g_object_get_property(object, "gtk-enable-animations", $0) }
        var off = GValueRef(false)
        off.withUnsafePointer { g_object_set_property(object, "gtk-enable-animations", $0) }
        defer { previous.withUnsafePointer { g_object_set_property(object, "gtk-enable-animations", $0) } }
        body()
    }

    /// Every button in `root`, in GTK child order.
    @MainActor
    static func buttons(_ root: Widget) -> [Button] {
        allWidgets(root).compactMap { $0.tryCast(Button.self) }
    }

    /// The first `Label` in `root` with exactly this text.
    @MainActor
    static func labelWithText(_ root: Widget, _ text: String) -> Label? {
        for widget in allWidgets(root) {
            if let label = widget.tryCast(Label.self), label.text == text { return label }
        }
        return nil
    }

    /// The first `ActionRow` (or subclass, re-wrapped as `T`) titled `title`.
    @MainActor
    static func row<T: ActionRow>(_ root: Widget, titled title: String, as type: T.Type = ActionRow.self) -> T? {
        for widget in allWidgets(root) {
            if let row = widget.tryCast(type), row.title == title { return row }
        }
        return nil
    }

    /// The first `SwitchRow` titled "Dark Mode" under `root`.
    @MainActor
    static func darkModeRow(_ root: Widget) -> SwitchRow? {
        allWidgets(root).lazy.compactMap { $0.tryCast(SwitchRow.self) }.first { $0.title == "Dark Mode" }
    }

    /// A "Dark Mode" row must drive the app's appearance and follow it when it
    /// changes elsewhere. The caller restores the color scheme.
    @MainActor
    static func expectDarkModeRowDrivesStyleManager(_ row: SwitchRow) {
        let styleManager = StyleManager.default
        #expect(row.active == styleManager.dark, "the row should show the current darkness")

        row.active = true
        #expect(styleManager.dark == true, "turning Dark Mode on should make the app dark")
        row.active = false
        #expect(styleManager.dark == false, "turning Dark Mode off should make the app light")

        styleManager.forceDark()
        #expect(row.active == true, "the row should follow the app's appearance")
        styleManager.forceLight()
        #expect(row.active == false, "the row should follow the app's appearance")
    }

    /// Every action name referenced by `model`, including nested sections and
    /// submenus, in menu order.
    @MainActor
    static func actionNames(in model: UnsafeMutablePointer<GMenuModel>) -> [String] {
        var names: [String] = []
        for index in 0 ..< g_menu_model_get_n_items(model) {
            if let value = g_menu_model_get_item_attribute_value(model, index, "action", nil) {
                names.append(String(cString: g_variant_get_string(value, nil)))
                g_variant_unref(value)
            }
            for link in ["section", "submenu"] {
                if let child = g_menu_model_get_item_link(model, index, link) {
                    names += actionNames(in: child)
                    g_object_unref(child)
                }
            }
        }
        return names
    }

    /// The `GtkShortcut`s held by `widget`'s shortcut controllers, in the order
    /// they were added, as (trigger string, shortcut) pairs. The caller owns
    /// nothing; the shortcuts stay alive with the widget.
    @MainActor
    static func shortcuts(on widget: Widget) -> [(trigger: String, shortcut: OpaquePointer)] {
        var out: [(String, OpaquePointer)] = []
        guard let controllers = gtk_widget_observe_controllers(widget.widgetPointer) else { return out }
        defer { g_object_unref(UnsafeMutableRawPointer(controllers)) }
        let controllerType = gtk_shortcut_controller_get_type()
        for index in 0 ..< g_list_model_get_n_items(controllers) {
            guard let item = g_list_model_get_item(controllers, index) else { continue }
            defer { g_object_unref(item) }
            let instance = item.assumingMemoryBound(to: GTypeInstance.self)
            guard g_type_check_instance_is_a(instance, controllerType) != 0 else { continue }
            let model = OpaquePointer(item)
            for shortcutIndex in 0 ..< g_list_model_get_n_items(model) {
                guard let raw = g_list_model_get_item(model, shortcutIndex) else { continue }
                // The controller keeps its own reference; drop the one we got.
                g_object_unref(raw)
                let shortcut = OpaquePointer(raw)
                guard let trigger = gtk_shortcut_get_trigger(shortcut),
                    let string = gtk_shortcut_trigger_to_string(trigger)
                else { continue }
                out.append((String(cString: string), shortcut))
                g_free(string)
            }
        }
        return out
    }

    // MARK: - About Dialog

    @Test @MainActor
    func aboutDialogButtonPresentsAboutDialog() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(AboutDialogExample())
        defer { Self.tearDown(window) }

        let button = buttonLabeled(root, "Show About Dialog")
        #expect(button != nil)
        #expect(window.visibleDialog == nil)

        button?.emitClicked()
        drainMainLoop()
        let dialog = window.visibleDialog
        #expect(dialog?.tryCast(AboutDialog.self) != nil, "the button should present an AdwAboutDialog")
        #expect(dialog?.tryCast(AboutDialog.self)?.applicationName == "swift-adwaita Demo")
    }

    // MARK: - Animation

    @Test @MainActor
    func animationFadeTogglesOpacity() {
        ensureDemoAdwInit()
        Self.withAnimationsDisabled {
            let (root, window) = Self.setUp(AnimationExample())
            defer { Self.tearDown(window) }

            let label = Self.labelWithText(root, "Fade In / Out")
            let fade = buttonLabeled(root, "Fade")
            #expect(label != nil)
            #expect(fade != nil)
            #expect(label?.opacity == 1)

            fade?.emitClicked()
            #expect(label?.opacity == 0, "Fade should fade the label out")
            fade?.emitClicked()
            #expect(label?.opacity == 1, "a second Fade should fade it back in")
        }
    }

    @Test @MainActor
    func animationSpringMovesDot() {
        ensureDemoAdwInit()
        Self.withAnimationsDisabled {
            let (root, window) = Self.setUp(AnimationExample())
            defer { Self.tearDown(window) }

            let dot = Self.labelWithText(root, "  ●  ")
            let spring = buttonLabeled(root, "Spring Bounce")
            #expect(dot != nil)
            #expect(spring != nil)
            #expect(dot?.marginStart == 0)

            spring?.emitClicked()
            #expect(dot?.marginStart == 300, "the spring should settle the dot at its target offset")
        }
    }

    // MARK: - Bottom Sheet

    @Test @MainActor
    func bottomSheetButtonTogglesSheet() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(BottomSheetExample())
        defer { Self.tearDown(window) }

        guard AdwaitaVersion.isAtLeast(1, 6) else {
            #expect(widgetOfType(root, BottomSheet.self) == nil)
            return
        }
        let sheet = widgetOfType(root, BottomSheet.self)
        let button = buttonLabeled(root, "Open Sheet")
        #expect(sheet != nil)
        #expect(button != nil)
        #expect(sheet?.open == false, "the sheet should start closed")

        button?.emitClicked()
        #expect(sheet?.open == true)
        button?.emitClicked()
        #expect(sheet?.open == false)
    }

    @Test @MainActor
    func bottomSheetDarkModeDrivesStyleManager() {
        ensureDemoAdwInit()
        let savedScheme = StyleManager.default.colorScheme
        let (root, window) = Self.setUp(BottomSheetExample())
        defer {
            Self.tearDown(window)
            StyleManager.default.colorScheme = savedScheme
            drainMainLoop()
        }

        guard AdwaitaVersion.isAtLeast(1, 6) else { return }
        buttonLabeled(root, "Open Sheet")?.emitClicked()
        drainMainLoop()
        let row = Self.darkModeRow(root)
        #expect(row != nil, "Dark Mode row not found in the sheet")
        if let row { Self.expectDarkModeRowDrivesStyleManager(row) }
    }

    // MARK: - Breakpoint

    @Test @MainActor
    func breakpointWideLayoutStatus() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(BreakpointExample(), width: 900)
        defer { Self.tearDown(window) }

        let cards = Self.labelWithText(root, "Card One")?.parent?.parent?.tryCast(Box.self)
        #expect(cards?.orientation == GTK_ORIENTATION_HORIZONTAL)
        // The status label must describe the wide state the same way the
        // unapply handler does, not a different initial string.
        #expect(Self.labelWithText(root, "Wide layout (\u{2265} 500sp)") != nil)
    }

    @Test @MainActor
    func breakpointNarrowLayoutStacksCards() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(BreakpointExample(), width: 400)
        defer { Self.tearDown(window) }

        let cards = Self.labelWithText(root, "Card One")?.parent?.parent?.tryCast(Box.self)
        #expect(cards != nil)
        #expect(cards?.orientation == GTK_ORIENTATION_VERTICAL, "narrow width should stack the cards")
        #expect(Self.labelWithText(root, "Narrow layout (< 500sp)") != nil)
    }

    // MARK: - Carousel

    @Test @MainActor
    func carouselNavigationButtons() {
        ensureDemoAdwInit()
        Self.withAnimationsDisabled {
            let (root, window) = Self.setUp(CarouselExample())
            defer { Self.tearDown(window) }

            let carousel = widgetOfType(root, Carousel.self)
            let buttons = Self.buttons(root)
            let prev = buttons.first { $0.iconName == "go-previous-symbolic" }
            let next = buttons.first { $0.iconName == "go-next-symbolic" }
            #expect(carousel?.nPages == 4)
            #expect(prev != nil)
            #expect(next != nil)
            #expect(carousel?.position == 0)

            prev?.emitClicked()
            #expect(carousel?.position == 0, "Previous on the first page should stay put")
            next?.emitClicked()
            #expect(carousel?.position == 1)
            next?.emitClicked()
            next?.emitClicked()
            #expect(carousel?.position == 3)
            next?.emitClicked()
            #expect(carousel?.position == 3, "Next on the last page should stay put")
            prev?.emitClicked()
            #expect(carousel?.position == 2)
        }
    }

    // MARK: - Data Binding

    @Test @MainActor
    func dataBindingControlsUpdateAllViews() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(DataBindingExample())
        defer { Self.tearDown(window) }

        let buttons = Self.buttons(root)
        let increment = buttons.first { $0.tooltipText == "Increment" }
        let decrement = buttons.first { $0.tooltipText == "Decrement" }
        let addFive = buttonLabeled(root, "+5")
        let reset = buttonLabeled(root, "Reset")
        let progress = widgetOfType(root, ProgressBar.self)
        let level = widgetOfType(root, LevelBar.self)
        #expect(increment != nil)
        #expect(decrement != nil)
        #expect(addFive != nil)
        #expect(reset != nil)

        func expectCounter(_ value: Int, _ comment: Comment) {
            #expect(Self.labelWithText(root, "\(value) / 20") != nil, comment)
            #expect(abs((progress?.fraction ?? -1) - Double(value) / 20) < 0.0001, comment)
            #expect(progress?.text == "\(value * 5)%", comment)
            #expect(level?.value == Double(value), comment)
        }

        decrement?.emitClicked()
        expectCounter(0, "decrement should clamp at 0")
        increment?.emitClicked()
        expectCounter(1, "increment")
        addFive?.emitClicked()
        expectCounter(6, "+5")
        for _ in 0 ..< 4 { addFive?.emitClicked() }
        expectCounter(20, "+5 should clamp at the maximum")
        increment?.emitClicked()
        expectCounter(20, "increment should clamp at the maximum")
        decrement?.emitClicked()
        expectCounter(19, "decrement")
        reset?.emitClicked()
        expectCounter(0, "reset")
    }

    // MARK: - Dialog

    @Test @MainActor
    func dialogRowsPresentTheirDialogs() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(DialogExample())
        defer { Self.tearDown(window) }

        let openers = Self.buttons(root).filter { $0.iconName == "go-next-symbolic" }
        #expect(openers.count == 2)
        guard openers.count == 2 else { return }

        openers[0].emitClicked()
        drainMainLoop()
        #expect(window.visibleDialog?.title == "Preferences")
        window.visibleDialog?.forceClose()
        drainMainLoop()
        #expect(window.visibleDialog == nil)

        openers[1].emitClicked()
        drainMainLoop()
        #expect(window.visibleDialog?.title == "Account Settings")
        window.visibleDialog?.forceClose()
        drainMainLoop()
    }

    @Test @MainActor
    func dialogDarkModeDrivesStyleManager() {
        ensureDemoAdwInit()
        let savedScheme = StyleManager.default.colorScheme
        let (root, window) = Self.setUp(DialogExample())
        defer {
            window.visibleDialog?.forceClose()
            Self.tearDown(window)
            StyleManager.default.colorScheme = savedScheme
            drainMainLoop()
        }

        Self.buttons(root).first { $0.iconName == "go-next-symbolic" }?.emitClicked()
        drainMainLoop()
        let dialog = window.visibleDialog
        #expect(dialog?.title == "Preferences")
        let row = dialog.flatMap { Self.darkModeRow($0) }
        #expect(row != nil, "Dark Mode row not found in the dialog")
        if let row { Self.expectDarkModeRowDrivesStyleManager(row) }
    }

    // MARK: - Inline View Switcher

    @Test @MainActor
    func inlineViewSwitcherShrinkAndHomogeneousSwitches() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(InlineViewSwitcherExample())
        defer { Self.tearDown(window) }

        // The <1.7 fallback is already asserted by
        // `DemoExampleInteractionTests.inlineViewSwitcherDisplayMode`.
        guard AdwaitaVersion.isAtLeast(1, 7) else { return }

        let switcher = widgetOfType(root, InlineViewSwitcher.self)
        let shrink = Self.row(root, titled: "Can shrink").flatMap { widgetOfType($0, Switch.self) }
        let homogeneous = Self.row(root, titled: "Homogeneous").flatMap { widgetOfType($0, Switch.self) }
        #expect(switcher != nil)
        #expect(shrink != nil)
        #expect(homogeneous != nil)
        #expect(switcher?.canShrink == true)
        #expect(switcher?.homogeneous == true)

        shrink?.active = false
        #expect(switcher?.canShrink == false)
        shrink?.active = true
        #expect(switcher?.canShrink == true)

        homogeneous?.active = false
        #expect(switcher?.homogeneous == false)
        homogeneous?.active = true
        #expect(switcher?.homogeneous == true)
    }

    // MARK: - Keyboard Shortcuts

    @Test @MainActor
    func keyboardShortcutsLogEveryRegisteredShortcut() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(KeyboardShortcutsExample())
        defer { Self.tearDown(window) }

        let host = allWidgets(root).first { $0.tryCast(Box.self) != nil && $0.isFocusable }
        let log = Self.labelWithText(root, "Press a shortcut to see it logged here...")
        #expect(host != nil, "the focusable shortcut host box was not found")
        #expect(log != nil)
        guard let host else { return }

        // Each listed shortcut's trigger, and the log line it should produce.
        let expected: [String: String] = [
            "<Control>s": "[Ctrl+S] managed scope",
            "<Control>z": "[Ctrl+Z] managed scope",
            "<Shift><Control>z": "[Ctrl+Shift+Z] managed scope",
            "<Control>n": "[Ctrl+N] managed scope",
            "<Control>w": "[Ctrl+W] managed scope",
            "F1": "[F1] local scope",
            "F2": "[F2] local scope",
            "<Control>space": "[Ctrl+Space] local scope",
        ]
        // GTK lists controllers most-recent first, so compare order-free.
        let registered = Self.shortcuts(on: host)
        #expect(Set(registered.map(\.trigger)) == Set(expected.keys))
        #expect(registered.count == expected.count)

        var logged: [String] = []
        for (trigger, shortcut) in registered {
            let action = gtk_shortcut_get_action(shortcut)
            #expect(
                gtk_shortcut_action_activate(action, GTK_SHORTCUT_ACTION_EXCLUSIVE, host.widgetPointer, nil) != 0,
                "\(trigger) did not handle the activation")
            if let line = expected[trigger] { logged.append(line) }
            #expect(log?.text == logged.joined(separator: "\n"), "\(trigger) should append its log line")
        }

        buttonLabeled(root, "Clear Log")?.emitClicked()
        #expect(log?.text == "Log cleared.")
    }

    // MARK: - List Rows

    @Test @MainActor
    func listRowsBluetoothSubtitleFollowsSwitch() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(ListRowsExample())
        defer { Self.tearDown(window) }

        let row = Self.row(root, titled: "Bluetooth")
        let toggle = row.flatMap { widgetOfType($0, Switch.self) }
        #expect(toggle != nil)
        #expect(toggle?.active == false)
        #expect(row?.subtitle == "Disabled")

        toggle?.active = true
        #expect(row?.subtitle == "Enabled", "the subtitle should follow the switch")
        toggle?.active = false
        #expect(row?.subtitle == "Disabled")
    }

    @Test @MainActor
    func listRowsResetRestoresDefaults() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(ListRowsExample())
        defer { Self.tearDown(window) }

        let bluetooth = Self.row(root, titled: "Bluetooth").flatMap { widgetOfType($0, Switch.self) }
        let location = Self.row(root, titled: "Location Services", as: SwitchRow.self)
        let camera = Self.row(root, titled: "Camera Access", as: SwitchRow.self)
        let microphone = Self.row(root, titled: "Microphone", as: SwitchRow.self)
        let reset = buttonLabeled(root, "Reset")
        #expect(bluetooth != nil)
        #expect(location != nil)
        #expect(camera != nil)
        #expect(microphone != nil)
        #expect(reset != nil)

        bluetooth?.active = true
        location?.active = false
        camera?.active = false
        microphone?.active = true

        reset?.emitClicked()
        #expect(bluetooth?.active == false)
        #expect(location?.active == true)
        #expect(camera?.active == true)
        #expect(microphone?.active == false)
        #expect(Self.row(root, titled: "Bluetooth")?.subtitle == "Disabled")
    }

    // MARK: - Menu Bar

    @Test @MainActor
    func menuBarItemsActivateTheirActions() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(MenuBarExample())
        defer { Self.tearDown(window) }

        let bar = widgetOfType(root, PopoverMenuBar.self)
        let status = Self.labelWithText(root, "Select a menu item")
        #expect(bar != nil)
        #expect(status != nil)
        guard let bar, let model = gtk_popover_menu_bar_get_menu_model(bar.opaquePointer) else { return }

        let names = Self.actionNames(in: model)
        #expect(names.count == 13)
        for name in names {
            #expect(gtk_widget_activate_action_variant(bar.widgetPointer, name, nil) != 0, "\(name) is not wired up")
            let shortName = name.split(separator: ".").last.map(String.init) ?? name
            #expect(status?.text == "\(shortName) activated!")
        }
    }

    // MARK: - Menu & Actions

    @Test @MainActor
    func menuButtonsItemsActivateTheirActions() {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(MenuExample())
        defer { Self.tearDown(window) }

        let log = Self.labelWithText(root, "Click a menu item...")
        let menuButtons = allWidgets(root).compactMap { $0.tryCast(MenuButton.self) }
        #expect(log != nil)
        #expect(menuButtons.count == 3)
        guard menuButtons.count == 3 else { return }

        let expectedLog: [(String) -> String] = [
            { "\($0) activated!" },
            { "\($0) (with icon) activated!" },
            { "submenu: \($0) activated!" },
        ]
        let expectedCounts = [6, 3, 3]
        for (index, button) in menuButtons.enumerated() {
            guard let model = gtk_menu_button_get_menu_model(button.opaquePointer) else {
                Issue.record("menu button \(index) has no menu model")
                continue
            }
            let names = Self.actionNames(in: model)
            #expect(names.count == expectedCounts[index])
            for name in names {
                #expect(
                    gtk_widget_activate_action_variant(button.widgetPointer, name, nil) != 0,
                    "\(name) is not wired up")
                let shortName = name.split(separator: ".").last.map(String.init) ?? name
                #expect(log?.text == expectedLog[index](shortName))
            }
        }
    }

    // MARK: - Multi-Window

    @Test @MainActor
    func multiWindowOpenButtonsCountAndOpenWindows() throws {
        ensureDemoAdwInit()
        let (root, window) = Self.setUp(MultiWindowExample())
        defer { Self.tearDown(window) }

        let openButtons = Self.buttons(root).filter { $0.label == "Open" }
        let counter = Self.labelWithText(root, "Windows opened: 0")
        #expect(openButtons.count == 2)
        #expect(counter != nil)
        guard openButtons.count == 2 else { return }

        // Without a running application nothing can open, so nothing is counted.
        if g_application_get_default() == nil {
            openButtons[0].emitClicked()
            openButtons[1].emitClicked()
            #expect(counter?.text == "Windows opened: 0", "no window opened, so the count must not move")
        }

        let app = Application(id: "me.test.CompositeAM.MultiWindow.t\(UInt32.random(in: 0 ..< UInt32.max))")
        try app.register()
        let previousDefault = g_application_get_default()
        g_application_set_default(app.castedPointer())
        defer {
            g_application_set_default(previousDefault)
            app.quit()
        }

        func appWindows() -> [UnsafeMutablePointer<CAdwaita.GtkWindow>] {
            var out: [UnsafeMutablePointer<CAdwaita.GtkWindow>] = []
            var node = gtk_application_get_windows(app.gtkApplicationPointer)
            while let current = node {
                if let data = current.pointee.data { out.append(data.assumingMemoryBound(to: CAdwaita.GtkWindow.self)) }
                node = current.pointee.next
            }
            return out
        }
        defer {
            for secondary in appWindows() { gtk_window_destroy(secondary) }
            drainMainLoop()
        }

        openButtons[0].emitClicked()
        drainMainLoop()
        #expect(counter?.text == "Windows opened: 1")
        let transient = appWindows().first { String(cString: gtk_window_get_title($0)) == "Window #1" }
        #expect(transient != nil, "the transient window should be titled Window #1")
        if let transient {
            #expect(UnsafeMutableRawPointer(gtk_window_get_transient_for(transient)) == window.pointer)
            #expect(gtk_window_get_modal(transient) == 0)
        }

        openButtons[1].emitClicked()
        drainMainLoop()
        #expect(counter?.text == "Windows opened: 2")
        let modal = appWindows().first { String(cString: gtk_window_get_title($0)) == "Modal #2" }
        #expect(modal != nil, "the modal window should be titled Modal #2")
        if let modal {
            #expect(UnsafeMutableRawPointer(gtk_window_get_transient_for(modal)) == window.pointer)
            #expect(gtk_window_get_modal(modal) != 0)
        }

        // Each window's own button closes it. The button's Swift wrapper is
        // gone by now, so a `[weak button]` capture here would do nothing.
        for (title, label) in [("Window #1", "Close This Window"), ("Modal #2", "Dismiss")] {
            guard let ptr = appWindows().first(where: { String(cString: gtk_window_get_title($0)) == title }) else {
                continue
            }
            let button = buttonLabeled(Widget(borrowing: UnsafeMutableRawPointer(ptr)), label)
            #expect(button != nil, "\(title) should have a \(label) button")
            button?.emitClicked()
            drainMainLoop()
            #expect(
                !appWindows().contains { String(cString: gtk_window_get_title($0)) == title },
                "\(label) should close \(title)")
        }
    }
}
#endif
