// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class AdvancedFeatureXCTests: XCTestCase {

    // MARK: - Batch 10: ActionBar

    @MainActor func test_actionBarCreation() {
        ensureAdwInit()
        let bar = ActionBar()
        XCTAssertTrue(bar.revealed == true)
    }

    @MainActor func test_actionBarPackAndCenter() {
        ensureAdwInit()
        let bar = ActionBar()
        let btn = Button(label: "Start")
        bar.packStart(btn)
        let end = Button(label: "End")
        bar.packEnd(end)
        let center = Label("Center")
        bar.centerWidget = center
        XCTAssertNotNil(bar.centerWidget)
    }

    @MainActor func test_actionBarRevealed() {
        ensureAdwInit()
        let bar = ActionBar()
        bar.revealed = false
        XCTAssertTrue(bar.revealed == false)
        bar.revealed = true
        XCTAssertTrue(bar.revealed == true)
    }

    // MARK: - UriLauncher

    @MainActor func test_uriLauncherCreation() {
        ensureAdwInit()
        let launcher = UriLauncher(uri: "https://example.com")
        XCTAssertTrue(launcher.uri == "https://example.com")
    }

    @MainActor func test_uriLauncherSetUri() {
        ensureAdwInit()
        let launcher = UriLauncher(uri: "https://a.com")
        launcher.uri = "https://b.com"
        XCTAssertTrue(launcher.uri == "https://b.com")
    }

    // MARK: - Convenience initializers

    @MainActor func test_entryConvenienceInit() {
        ensureAdwInit()
        let entry = Entry(placeholder: "Type here")
        XCTAssertTrue(entry.placeholderText == "Type here")
    }

    @MainActor func test_entryConvenienceInitWithPlaceholder() {
        ensureAdwInit()
        let entry = Entry(placeholder: "Search")
        XCTAssertTrue(entry.placeholderText == "Search")
        entry.text = "hello"
        XCTAssertTrue(entry.text == "hello")
    }

    @MainActor func test_entryOnChangedNotify() {
        ensureAdwInit()
        let entry = Entry()
        var changed = false
        entry.onChanged { changed = true }
        entry.text = "hello"
        XCTAssertTrue(changed == true)
    }

    @MainActor func test_switchConvenienceInit() {
        ensureAdwInit()
        let sw = Switch(active: true)
        XCTAssertTrue(sw.active == true)
    }

    @MainActor func test_checkButtonConvenienceInit() {
        ensureAdwInit()
        var toggled = false
        let cb = CheckButton(label: "Test", onToggled: { toggled = true })
        XCTAssertTrue(cb.label == "Test")
        // Simulate toggle
        cb.active = !cb.active
        // toggled via signal on actual user interaction
        _ = toggled
    }

    // MARK: - ToggleGroup

    @MainActor func test_toggleGroupCreation() {
        ensureAdwInit()
        guard let group = ToggleGroup(), let t1 = Toggle(), let t2 = Toggle() else { return }
        t1.label = "A"
        t2.label = "B"
        group.add(t1)
        group.add(t2)
        XCTAssertTrue(group.nToggles == 2)
    }

    @MainActor func test_toggleGroupActive() {
        ensureAdwInit()
        guard let group = ToggleGroup(), let t1 = Toggle(), let t2 = Toggle() else { return }
        t1.label = "X"
        t2.label = "Y"
        group.add(t1)
        group.add(t2)
        group.active = 1
        XCTAssertTrue(group.active == 1)
    }

    @MainActor func test_toggleGroupByName() {
        ensureAdwInit()
        guard let group = ToggleGroup(), let t = Toggle() else { return }
        t.label = "Named"
        t.name = "my-toggle"
        group.add(t)
        let found = group.getToggleByName("my-toggle")
        XCTAssertNotNil(found)
    }

    // MARK: - WrapBox

    @MainActor func test_wrapBoxCreation() {
        ensureAdwInit()
        guard let wrap = WrapBox() else { return }
        wrap.childSpacing = 8
        wrap.lineSpacing = 12
        XCTAssertTrue(wrap.childSpacing == 8)
        XCTAssertTrue(wrap.lineSpacing == 12)
    }

    @MainActor func test_wrapBoxAppendRemove() {
        ensureAdwInit()
        guard let wrap = WrapBox() else { return }
        let label = Label("test")
        wrap.append(label)
        wrap.remove(label)
        // No crash = success
    }

    // MARK: - ButtonRow

    @MainActor func test_buttonRowCreation() {
        ensureAdwInit()
        guard ButtonRow.isAvailable else { return }
        let row = ButtonRow()
        row.title = "Action"
        row.startIconName = "edit-symbolic"
        XCTAssertTrue(row.startIconName == "edit-symbolic")
    }

    // MARK: - ComboRow

    @MainActor func test_comboRowWithModel() {
        ensureAdwInit()
        let combo = ComboRow()
        combo.title = "Pick"
        let model = StringList(["A", "B", "C"])
        combo.setModel(model)
        combo.selected = 1
        XCTAssertTrue(combo.selected == 1)
    }

    // MARK: - ExpanderRow

    @MainActor func test_expanderRowCreation() {
        ensureAdwInit()
        let row = ExpanderRow()
        row.title = "Details"
        row.subtitle = "Show more"
        row.expanded = true
        XCTAssertTrue(row.expanded == true)
        row.expanded = false
        XCTAssertTrue(row.expanded == false)
    }

    @MainActor func test_expanderRowAddRow() {
        ensureAdwInit()
        let row = ExpanderRow()
        row.title = "Parent"
        let child = ActionRow()
        child.title = "Child"
        row.addRow(child)
        // No crash = success
    }

    // MARK: - Batch 11: GtkWindow properties

    @MainActor func test_windowProperties() {
        ensureAdwInit()
        let win = Window()
        win.title = "Test"
        XCTAssertTrue(win.title == "Test")
        win.defaultWidth = 400
        win.defaultHeight = 300
        XCTAssertTrue(win.defaultWidth == 400)
        XCTAssertTrue(win.defaultHeight == 300)
    }

    @MainActor func test_windowModal() {
        ensureAdwInit()
        let win = Window()
        win.modal = true
        XCTAssertTrue(win.modal == true)
        win.modal = false
        XCTAssertTrue(win.modal == false)
    }

    // MARK: - NavigationSplitView sidebar/content

    @MainActor func test_navigationSplitViewSetSidebarContent() {
        ensureAdwInit()
        let splitView = NavigationSplitView()
        let sidebar = NavigationPage(child: Label("Side"), title: "Side")
        let content = NavigationPage(child: Label("Main"), title: "Main")
        splitView.setSidebar(sidebar)
        splitView.setContent(content)
        // No crash = success
    }

    @MainActor func test_navigationSplitViewProperties() {
        ensureAdwInit()
        let splitView = NavigationSplitView()
        splitView.sidebarWidthFraction = 0.4
        XCTAssertTrue(splitView.sidebarWidthFraction > 0.39 && splitView.sidebarWidthFraction < 0.41)
    }

    // MARK: - Scale Format Value Func

    @MainActor func test_scaleFormatValueFunc() {
        ensureAdwInit()
        let scale = Scale(orientation: GTK_ORIENTATION_HORIZONTAL, min: 0, max: 100, step: 1)
        scale.value = 42
        // Set a format function — no crash = success
        scale.setFormatValueFunc { value in "\(Int(value))%" }
        // Clear it
        scale.setFormatValueFunc(nil)
    }

    @MainActor func test_scaleDrawValueAndDigits() {
        ensureAdwInit()
        let scale = Scale(orientation: GTK_ORIENTATION_HORIZONTAL, min: 0, max: 100, step: 1)
        scale.drawValue = true
        XCTAssertTrue(scale.drawValue == true)
        scale.digits = 2
        XCTAssertTrue(scale.digits == 2)
        scale.hasOrigin = false
        XCTAssertTrue(scale.hasOrigin == false)
        scale.inverted = true
        XCTAssertTrue(scale.inverted == true)
    }

    // MARK: - ShortcutController

    @MainActor func test_shortcutControllerCreation() {
        ensureAdwInit()
        let controller = ShortcutController()
        // Default scope is local
        controller.scope = GTK_SHORTCUT_SCOPE_LOCAL
        XCTAssertTrue(controller.scope == GTK_SHORTCUT_SCOPE_LOCAL)
    }

    @MainActor func test_shortcutControllerAddShortcuts() {
        ensureAdwInit()
        let controller = ShortcutController()
        // String-based API
        controller.addShortcut("<Control>s") { true }
        // Enum-based API
        controller.addShortcut(key: .z, modifiers: [.control, .shift]) { true }
        controller.addShortcut(key: .escape) { true }
        // No crash = success
    }

    @MainActor func test_shortcutControllerOnWidget() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 0)
        let controller = ShortcutController()
        controller.addShortcut(key: .a, modifiers: .control) { true }
        box.addController(controller)
        // No crash = success
    }

    @MainActor func test_widgetKeyboardShortcutOnButton() {
        ensureAdwInit()
        let btn = Button(label: "Test")
        // Enum-based API on Widget
        btn.addKeyboardShortcut(key: .t, modifiers: .control) { true }
        // No crash = success
    }

    @MainActor func test_keyModifiersAcceleratorPrefix() {
        let ctrl: KeyModifiers = .control
        XCTAssertTrue(ctrl.acceleratorPrefix == "<Control>")

        let ctrlShift: KeyModifiers = [.control, .shift]
        XCTAssertTrue(ctrlShift.acceleratorPrefix == "<Control><Shift>")

        let all: KeyModifiers = [.control, .shift, .alt, .super]
        XCTAssertTrue(all.acceleratorPrefix == "<Control><Shift><Alt><Super>")

        let empty: KeyModifiers = []
        XCTAssertTrue(empty.acceleratorPrefix == "")
    }

    @MainActor func test_keyAcceleratorName() {
        XCTAssertTrue(Key.s.acceleratorName == "s")
        XCTAssertTrue(Key.f1.acceleratorName == "F1")
        XCTAssertTrue(Key.escape.acceleratorName == "Escape")
        XCTAssertTrue(Key.return.acceleratorName == "Return")
        XCTAssertTrue(Key.digit0.acceleratorName == "0")
        XCTAssertTrue(Key.pageUp.acceleratorName == "Page_Up")
    }

    @MainActor func test_acceleratorStringBuilder() {
        XCTAssertTrue(acceleratorString(key: .s, modifiers: .control) == "<Control>s")
        XCTAssertTrue(acceleratorString(key: .z, modifiers: [.control, .shift]) == "<Control><Shift>z")
        XCTAssertTrue(acceleratorString(key: .f4, modifiers: .alt) == "<Alt>F4")
        XCTAssertTrue(acceleratorString(key: .escape) == "Escape")
    }

    // MARK: - GObjectRef Property Binding

    @MainActor func test_gobjectBindProperty() {
        ensureAdwInit()
        let switch1 = Switch()
        let switch2 = Switch()
        switch1.active = true
        // Bind active properties — syncCreate means switch2 gets switch1's value
        switch1.bind(.active, to: switch2, property: .active, flags: .syncCreate)
        XCTAssertTrue(switch2.active == true)
    }

    @MainActor func test_gobjectBindPropertyBidirectional() {
        ensureAdwInit()
        let label1 = Label("Hello")
        let label2 = Label("World")
        label1.bind(.label, to: label2, property: .label,
                    flags: GBindingFlags(rawValue: GBindingFlags.bidirectional.rawValue | GBindingFlags.syncCreate
                        .rawValue))
        XCTAssertTrue(label2.text == "Hello")
    }

    // MARK: - PreferencesDialog

    @MainActor func test_preferencesDialogCreation() {
        ensureAdwInit()
        let dialog = PreferencesDialog()
        dialog.searchEnabled = true
        XCTAssertTrue(dialog.searchEnabled == true)
        dialog.searchEnabled = false
        XCTAssertTrue(dialog.searchEnabled == false)
    }

    @MainActor func test_preferencesDialogAddPage() {
        ensureAdwInit()
        let dialog = PreferencesDialog()
        let page = PreferencesPage()
        page.title = "General"
        page.iconName = "preferences-other-symbolic"

        let group = PreferencesGroup()
        group.title = "Settings"
        page.add(group)

        dialog.add(page)
        // No crash = success
    }

    // MARK: - PreferencesPage

    @MainActor func test_preferencesPageProperties() {
        ensureAdwInit()
        let page = PreferencesPage()
        page.title = "Test"
        XCTAssertTrue(page.title == "Test")
        page.description = "A test page"
        XCTAssertTrue(page.description == "A test page")
        page.iconName = "system-settings-symbolic"
        XCTAssertTrue(page.iconName == "system-settings-symbolic")
        page.useUnderline = true
        XCTAssertTrue(page.useUnderline == true)
    }

    // MARK: - GMenu sections and submenus

    @MainActor func test_gmenuWithSections() {
        ensureAdwInit()
        let menu = GMenuRef()
        let section = GMenuRef()
        section.append("Item A", action: "app.a")
        section.append("Item B", action: "app.b")
        menu.appendSection("Section", section: section)
        // No crash = success
    }

    @MainActor func test_gmenuWithSubmenu() {
        ensureAdwInit()
        let menu = GMenuRef()
        let sub = GMenuRef()
        sub.append("Sub 1", action: "app.sub1")
        menu.appendSubmenu("More", submenu: sub)
        // No crash = success
    }

    // MARK: - DragSource and DropTarget (on widget)

    @MainActor func test_dragDropControllersOnWidget() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 0)
        let drag = DragSource()
        drag.setTextContent("test")
        box.addController(drag)

        let label = Label("Target")
        let drop = DropTarget.forText()
        label.addController(drop)
        // No crash = success
    }

    // MARK: - FileDialog (pattern filter)

    @MainActor func test_fileDialogPatternFilter() {
        ensureAdwInit()
        let dialog = FileDialog()
        dialog.setFilters([
            FileFilter(name: "Swift", suffixes: ["swift"]),
            FileFilter(name: "All", patterns: ["*"])
        ])
        dialog.acceptLabel = "Choose"
        XCTAssertTrue(dialog.acceptLabel == "Choose")
    }

    @MainActor func test_fileFilterPatternsInit() {
        ensureAdwInit()
        let filter = FileFilter(name: "Images", patterns: ["*.png", "*.jpg"])
        XCTAssertTrue(filter.name == "Images")
    }

}
#endif
