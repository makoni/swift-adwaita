import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct AdvancedFeatureTests {

    // MARK: - Batch 10: ActionBar

    @Test @MainActor func actionBarCreation() {
        ensureAdwInit()
        let bar = ActionBar()
        #expect(bar.revealed == true)
    }

    @Test @MainActor func actionBarPackAndCenter() {
        ensureAdwInit()
        let bar = ActionBar()
        let btn = Button(label: "Start")
        bar.packStart(btn)
        let end = Button(label: "End")
        bar.packEnd(end)
        let center = Label("Center")
        bar.centerWidget = center
        #expect(bar.centerWidget != nil)
    }

    @Test @MainActor func actionBarRevealed() {
        ensureAdwInit()
        let bar = ActionBar()
        bar.revealed = false
        #expect(bar.revealed == false)
        bar.revealed = true
        #expect(bar.revealed == true)
    }

    // MARK: - UriLauncher

    @Test @MainActor func uriLauncherCreation() {
        ensureAdwInit()
        let launcher = UriLauncher(uri: "https://example.com")
        #expect(launcher.uri == "https://example.com")
    }

    @Test @MainActor func uriLauncherSetUri() {
        ensureAdwInit()
        let launcher = UriLauncher(uri: "https://a.com")
        launcher.uri = "https://b.com"
        #expect(launcher.uri == "https://b.com")
    }

    // MARK: - Convenience initializers

    @Test @MainActor func entryConvenienceInit() {
        ensureAdwInit()
        let entry = Entry(placeholder: "Type here")
        #expect(entry.placeholderText == "Type here")
    }

    @Test @MainActor func entryConvenienceInitWithPlaceholder() {
        ensureAdwInit()
        let entry = Entry(placeholder: "Search")
        #expect(entry.placeholderText == "Search")
        entry.text = "hello"
        #expect(entry.text == "hello")
    }

    @Test @MainActor func entryOnChangedNotify() {
        ensureAdwInit()
        let entry = Entry()
        var changed = false
        entry.onChanged { changed = true }
        entry.text = "hello"
        #expect(changed == true)
    }

    @Test @MainActor func switchConvenienceInit() {
        ensureAdwInit()
        let sw = Switch(active: true)
        #expect(sw.active == true)
    }

    @Test @MainActor func checkButtonConvenienceInit() {
        ensureAdwInit()
        var toggled = false
        let cb = CheckButton(label: "Test", onToggled: { toggled = true })
        #expect(cb.label == "Test")
        // Simulate toggle
        cb.active = !cb.active
        // toggled via signal on actual user interaction
        _ = toggled
    }

    // MARK: - ToggleGroup

    @Test @MainActor func toggleGroupCreation() {
        ensureAdwInit()
        guard let group = ToggleGroup(), let t1 = Toggle(), let t2 = Toggle() else { return }
        t1.label = "A"
        t2.label = "B"
        group.add(t1)
        group.add(t2)
        #expect(group.nToggles == 2)
    }

    @Test @MainActor func toggleGroupActive() {
        ensureAdwInit()
        guard let group = ToggleGroup(), let t1 = Toggle(), let t2 = Toggle() else { return }
        t1.label = "X"
        t2.label = "Y"
        group.add(t1)
        group.add(t2)
        group.active = 1
        #expect(group.active == 1)
    }

    @Test @MainActor func toggleGroupByName() {
        ensureAdwInit()
        guard let group = ToggleGroup(), let t = Toggle() else { return }
        t.label = "Named"
        t.name = "my-toggle"
        group.add(t)
        let found = group.getToggleByName("my-toggle")
        #expect(found != nil)
    }

    // MARK: - WrapBox

    @Test @MainActor func wrapBoxCreation() {
        ensureAdwInit()
        guard let wrap = WrapBox() else { return }
        wrap.childSpacing = 8
        wrap.lineSpacing = 12
        #expect(wrap.childSpacing == 8)
        #expect(wrap.lineSpacing == 12)
    }

    @Test @MainActor func wrapBoxAppendRemove() {
        ensureAdwInit()
        guard let wrap = WrapBox() else { return }
        let label = Label("test")
        wrap.append(label)
        wrap.remove(label)
        // No crash = success
    }

    // MARK: - ButtonRow

    @Test @MainActor func buttonRowCreation() {
        ensureAdwInit()
        guard ButtonRow.isAvailable else { return }
        let row = ButtonRow()
        row.title = "Action"
        row.startIconName = "edit-symbolic"
        #expect(row.startIconName == "edit-symbolic")
    }

    // MARK: - ComboRow

    @Test @MainActor func comboRowWithModel() {
        ensureAdwInit()
        let combo = ComboRow()
        combo.title = "Pick"
        let model = StringList(["A", "B", "C"])
        combo.setModel(model)
        combo.selected = 1
        #expect(combo.selected == 1)
    }

    // MARK: - ExpanderRow

    @Test @MainActor func expanderRowCreation() {
        ensureAdwInit()
        let row = ExpanderRow()
        row.title = "Details"
        row.subtitle = "Show more"
        row.expanded = true
        #expect(row.expanded == true)
        row.expanded = false
        #expect(row.expanded == false)
    }

    @Test @MainActor func expanderRowAddRow() {
        ensureAdwInit()
        let row = ExpanderRow()
        row.title = "Parent"
        let child = ActionRow()
        child.title = "Child"
        row.addRow(child)
        // No crash = success
    }

    // MARK: - Batch 11: GtkWindow properties

    @Test @MainActor func windowProperties() {
        ensureAdwInit()
        let win = Window()
        win.title = "Test"
        #expect(win.title == "Test")
        win.defaultWidth = 400
        win.defaultHeight = 300
        #expect(win.defaultWidth == 400)
        #expect(win.defaultHeight == 300)
    }

    @Test @MainActor func windowModal() {
        ensureAdwInit()
        let win = Window()
        win.modal = true
        #expect(win.modal == true)
        win.modal = false
        #expect(win.modal == false)
    }

    // MARK: - NavigationSplitView sidebar/content

    @Test @MainActor func navigationSplitViewSetSidebarContent() {
        ensureAdwInit()
        let splitView = NavigationSplitView()
        let sidebar = NavigationPage(child: Label("Side"), title: "Side")
        let content = NavigationPage(child: Label("Main"), title: "Main")
        splitView.setSidebar(sidebar)
        splitView.setContent(content)
        // No crash = success
    }

    @Test @MainActor func navigationSplitViewProperties() {
        ensureAdwInit()
        let splitView = NavigationSplitView()
        splitView.sidebarWidthFraction = 0.4
        #expect(splitView.sidebarWidthFraction > 0.39 && splitView.sidebarWidthFraction < 0.41)
    }

    // MARK: - Scale Format Value Func

    @Test @MainActor func scaleFormatValueFunc() {
        ensureAdwInit()
        let scale = Scale(orientation: GTK_ORIENTATION_HORIZONTAL, min: 0, max: 100, step: 1)
        scale.value = 42
        // Set a format function — no crash = success
        scale.setFormatValueFunc { value in "\(Int(value))%" }
        // Clear it
        scale.setFormatValueFunc(nil)
    }

    @Test @MainActor func scaleDrawValueAndDigits() {
        ensureAdwInit()
        let scale = Scale(orientation: GTK_ORIENTATION_HORIZONTAL, min: 0, max: 100, step: 1)
        scale.drawValue = true
        #expect(scale.drawValue == true)
        scale.digits = 2
        #expect(scale.digits == 2)
        scale.hasOrigin = false
        #expect(scale.hasOrigin == false)
        scale.inverted = true
        #expect(scale.inverted == true)
    }

    // MARK: - ShortcutController

    @Test @MainActor func shortcutControllerCreation() {
        ensureAdwInit()
        let controller = ShortcutController()
        // Default scope is local
        controller.scope = GTK_SHORTCUT_SCOPE_LOCAL
        #expect(controller.scope == GTK_SHORTCUT_SCOPE_LOCAL)
    }

    @Test @MainActor func shortcutControllerAddShortcuts() {
        ensureAdwInit()
        let controller = ShortcutController()
        // String-based API
        controller.addShortcut("<Control>s") { true }
        // Enum-based API
        controller.addShortcut(key: .z, modifiers: [.control, .shift]) { true }
        controller.addShortcut(key: .escape) { true }
        // No crash = success
    }

    @Test @MainActor func shortcutControllerOnWidget() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 0)
        let controller = ShortcutController()
        controller.addShortcut(key: .a, modifiers: .control) { true }
        box.addController(controller)
        // No crash = success
    }

    @Test @MainActor func widgetKeyboardShortcutOnButton() {
        ensureAdwInit()
        let btn = Button(label: "Test")
        // Enum-based API on Widget
        btn.addKeyboardShortcut(key: .t, modifiers: .control) { true }
        // No crash = success
    }

    @Test @MainActor func keyModifiersAcceleratorPrefix() {
        let ctrl: KeyModifiers = .control
        #expect(ctrl.acceleratorPrefix == "<Control>")

        let ctrlShift: KeyModifiers = [.control, .shift]
        #expect(ctrlShift.acceleratorPrefix == "<Control><Shift>")

        let all: KeyModifiers = [.control, .shift, .alt, .super]
        #expect(all.acceleratorPrefix == "<Control><Shift><Alt><Super>")

        let empty: KeyModifiers = []
        #expect(empty.acceleratorPrefix == "")
    }

    @Test @MainActor func keyAcceleratorName() {
        #expect(Key.s.acceleratorName == "s")
        #expect(Key.f1.acceleratorName == "F1")
        #expect(Key.escape.acceleratorName == "Escape")
        #expect(Key.return.acceleratorName == "Return")
        #expect(Key.digit0.acceleratorName == "0")
        #expect(Key.pageUp.acceleratorName == "Page_Up")
    }

    @Test @MainActor func acceleratorStringBuilder() {
        #expect(acceleratorString(key: .s, modifiers: .control) == "<Control>s")
        #expect(acceleratorString(key: .z, modifiers: [.control, .shift]) == "<Control><Shift>z")
        #expect(acceleratorString(key: .f4, modifiers: .alt) == "<Alt>F4")
        #expect(acceleratorString(key: .escape) == "Escape")
    }

    // MARK: - GObjectRef Property Binding

    @Test @MainActor func gobjectBindProperty() {
        ensureAdwInit()
        let switch1 = Switch()
        let switch2 = Switch()
        switch1.active = true
        // Bind active properties — syncCreate means switch2 gets switch1's value
        switch1.bind(.active, to: switch2, property: .active, flags: G_BINDING_SYNC_CREATE)
        #expect(switch2.active == true)
    }

    @Test @MainActor func gobjectBindPropertyBidirectional() {
        ensureAdwInit()
        let label1 = Label("Hello")
        let label2 = Label("World")
        label1.bind(.label, to: label2, property: .label,
                    flags: [.bidirectional, .syncCreate])
        #expect(label2.text == "Hello")
    }

    // MARK: - PreferencesDialog

    @Test @MainActor func preferencesDialogCreation() {
        ensureAdwInit()
        let dialog = PreferencesDialog()
        dialog.searchEnabled = true
        #expect(dialog.searchEnabled == true)
        dialog.searchEnabled = false
        #expect(dialog.searchEnabled == false)
    }

    @Test @MainActor func preferencesDialogAddPage() {
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

    @Test @MainActor func preferencesPageProperties() {
        ensureAdwInit()
        let page = PreferencesPage()
        page.title = "Test"
        #expect(page.title == "Test")
        page.description = "A test page"
        #expect(page.description == "A test page")
        page.iconName = "system-settings-symbolic"
        #expect(page.iconName == "system-settings-symbolic")
        page.useUnderline = true
        #expect(page.useUnderline == true)
    }

    // MARK: - GMenu sections and submenus

    @Test @MainActor func gmenuWithSections() {
        ensureAdwInit()
        let menu = GMenuRef()
        let section = GMenuRef()
        section.append("Item A", action: "app.a")
        section.append("Item B", action: "app.b")
        menu.appendSection("Section", section: section)
        // No crash = success
    }

    @Test @MainActor func gmenuWithSubmenu() {
        ensureAdwInit()
        let menu = GMenuRef()
        let sub = GMenuRef()
        sub.append("Sub 1", action: "app.sub1")
        menu.appendSubmenu("More", submenu: sub)
        // No crash = success
    }

    // MARK: - DragSource and DropTarget (on widget)

    @Test @MainActor func dragDropControllersOnWidget() {
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

    @Test @MainActor func fileDialogPatternFilter() {
        ensureAdwInit()
        let dialog = FileDialog()
        dialog.setFilters([
            FileFilter(name: "Swift", suffixes: ["swift"]),
            FileFilter(name: "All", patterns: ["*"])
        ])
        dialog.acceptLabel = "Choose"
        #expect(dialog.acceptLabel == "Choose")
    }

    @Test @MainActor func fileFilterPatternsInit() {
        ensureAdwInit()
        let filter = FileFilter(name: "Images", patterns: ["*.png", "*.jpg"])
        #expect(filter.name == "Images")
    }

}
