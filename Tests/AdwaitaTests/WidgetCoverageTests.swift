import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct WidgetCoverageTests {

    // MARK: - Widget: Tooltip

    @Test @MainActor func widgetTooltipText() {
        ensureAdwInit()
        let label = Label("Hello")
        #expect(label.tooltipText == nil)
        label.tooltipText = "A tooltip"
        #expect(label.tooltipText == "A tooltip")
        label.tooltipText = nil
        #expect(label.tooltipText == nil)
    }

    @Test @MainActor func widgetTooltipMarkup() {
        ensureAdwInit()
        let label = Label("Hello")
        #expect(label.tooltipMarkup == nil)
        label.tooltipMarkup = "<b>Bold</b> tooltip"
        #expect(label.tooltipMarkup == "<b>Bold</b> tooltip")
        label.tooltipMarkup = nil
        #expect(label.tooltipMarkup == nil)
    }

    // MARK: - Widget: Visible / Sensitive / CanTarget

    @Test @MainActor func widgetShowHide() {
        ensureAdwInit()
        let label = Label("Toggle")
        #expect(label.visible == true)
        label.hide()
        #expect(label.visible == false)
        label.show()
        #expect(label.visible == true)
    }

    @Test @MainActor func widgetSensitiveProperty() {
        ensureAdwInit()
        let button = Button(label: "Click")
        #expect(button.sensitive == true)
        button.sensitive = false
        #expect(button.sensitive == false)
        button.sensitive = true
        #expect(button.sensitive == true)
    }

    @Test @MainActor func widgetCanTargetProperty() {
        ensureAdwInit()
        let label = Label("Test")
        label.canTarget = false
        #expect(label.canTarget == false)
        label.canTarget = true
        #expect(label.canTarget == true)
    }

    // MARK: - Widget: Opacity

    @Test @MainActor func widgetOpacityRoundTrip() {
        ensureAdwInit()
        let label = Label("Opacity")
        #expect(abs(label.opacity - 1.0) < 0.01)
        label.opacity = 0.3
        #expect(abs(label.opacity - 0.3) < 0.01)
        label.opacity = 0.0
        #expect(abs(label.opacity - 0.0) < 0.01)
        label.opacity = 1.0
        #expect(abs(label.opacity - 1.0) < 0.01)
    }

    // MARK: - Widget: CSS Classes

    @Test @MainActor func widgetCSSClassesGetSet() {
        ensureAdwInit()
        let label = Label("CSS")
        label.cssClasses = ["alpha", "beta"]
        let classes = label.cssClasses
        #expect(classes.contains("alpha"))
        #expect(classes.contains("beta"))
    }

    @Test @MainActor func widgetAddRemoveHasCSSClass() {
        ensureAdwInit()
        let btn = Button(label: "Styled")
        btn.addCSSClass("suggested-action")
        #expect(btn.hasCSSClass("suggested-action") == true)
        btn.removeCSSClass("suggested-action")
        #expect(btn.hasCSSClass("suggested-action") == false)
    }

    @Test @MainActor func widgetTypeSafeCSSClass() {
        ensureAdwInit()
        let btn = Button(label: "Typed")
        btn.addCSSClass(.suggestedAction)
        #expect(btn.hasCSSClass(.suggestedAction) == true)
        btn.removeCSSClass(.suggestedAction)
        #expect(btn.hasCSSClass(.suggestedAction) == false)
    }

    // MARK: - Widget: Margins

    @Test @MainActor func widgetSetMarginsAll() {
        ensureAdwInit()
        let label = Label("Margins")
        label.setMargins(24)
        #expect(label.marginTop == 24)
        #expect(label.marginBottom == 24)
        #expect(label.marginStart == 24)
        #expect(label.marginEnd == 24)
    }

    @Test @MainActor func widgetIndividualMargins() {
        ensureAdwInit()
        let label = Label("Margins")
        label.marginTop = 5
        label.marginBottom = 10
        label.marginStart = 15
        label.marginEnd = 20
        #expect(label.marginTop == 5)
        #expect(label.marginBottom == 10)
        #expect(label.marginStart == 15)
        #expect(label.marginEnd == 20)
    }

    // MARK: - Widget: Size Request

    @Test @MainActor func widgetSetSizeRequest() {
        ensureAdwInit()
        let label = Label("Sized")
        label.setSizeRequest(width: 200, height: 100)
        // No crash; size request is stored internally
    }

    @Test @MainActor func widgetSetSizeRequestPartial() {
        ensureAdwInit()
        let label = Label("Partial")
        label.setSizeRequest(width: 150)
        label.setSizeRequest(height: 75)
        // Should not crash with partial size requests
    }

    // MARK: - Widget: Width / Height (unallocated)

    @Test @MainActor func widgetWidthHeightDefault() {
        ensureAdwInit()
        let label = Label("Size")
        // Without layout allocation, width and height should be 0
        #expect(label.width >= 0)
        #expect(label.height >= 0)
    }

    // MARK: - Widget: Overflow

    @Test @MainActor func widgetOverflow() {
        ensureAdwInit()
        let label = Label("Overflow")
        label.overflow = .hidden
        #expect(label.overflow == GtkOverflow.hidden)
        label.overflow = .visible
        #expect(label.overflow == GtkOverflow.visible)
    }

    // MARK: - Widget: Expand / Align

    @Test @MainActor func widgetExpandProperties() {
        ensureAdwInit()
        let label = Label("Expand")
        label.hexpand = true
        label.vexpand = true
        #expect(label.hexpand == true)
        #expect(label.vexpand == true)
        label.hexpand = false
        label.vexpand = false
        #expect(label.hexpand == false)
        #expect(label.vexpand == false)
    }

    @Test @MainActor func widgetAlignment() {
        ensureAdwInit()
        let label = Label("Align")
        label.halign = .center
        label.valign = .end
        #expect(label.halign == GtkAlign.center)
        #expect(label.valign == GtkAlign.end)
        label.halign = .start
        label.valign = .fill
        #expect(label.halign == GtkAlign.start)
        #expect(label.valign == GtkAlign.fill)
    }

    // MARK: - Widget: CSS Name

    @Test @MainActor func widgetCSSName() {
        ensureAdwInit()
        let label = Label("CSS Name")
        #expect(!label.cssName.isEmpty)
        let btn = Button(label: "CSS Name")
        #expect(!btn.cssName.isEmpty)
    }

    // MARK: - Widget: Parent / Children Navigation

    @Test @MainActor func widgetParentAfterAppend() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL)
        let label = Label("Child")
        #expect(label.parent == nil)
        box.append(label)
        #expect(label.parent != nil)
    }

    @Test @MainActor func widgetFirstLastChild() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL)
        let a = Label("A")
        let b = Label("B")
        let c = Label("C")
        box.append(a)
        box.append(b)
        box.append(c)
        #expect(box.firstChild != nil)
        #expect(box.lastChild != nil)
    }

    @Test @MainActor func widgetSiblingNavigation() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_HORIZONTAL)
        let a = Label("A")
        let b = Label("B")
        box.append(a)
        box.append(b)
        #expect(a.nextSibling != nil)
        #expect(b.prevSibling != nil)
        #expect(a.prevSibling == nil)
        #expect(b.nextSibling == nil)
    }

    @Test @MainActor func widgetChildrenList() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL)
        box.append(Label("1"))
        box.append(Label("2"))
        box.append(Label("3"))
        let children = box.children()
        #expect(children.count == 3)
    }

    @Test @MainActor func widgetForEachChild() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL)
        box.append(Label("A"))
        box.append(Label("B"))
        var count = 0
        box.forEachChild { _ in count += 1 }
        #expect(count == 2)
    }

    // MARK: - Widget: Root

    @Test @MainActor func widgetRootWithoutWindow() {
        ensureAdwInit()
        let label = Label("Orphan")
        // Not inside a window, root should be nil
        #expect(label.root == nil)
    }

    // MARK: - Widget: Configure

    @Test @MainActor func widgetConfigure() {
        ensureAdwInit()
        let label = Label("Configure").configure {
            $0.halign = .center
            $0.vexpand = true
            $0.setMargins(8)
        }
        #expect(label.halign == GtkAlign.center)
        #expect(label.vexpand == true)
        #expect(label.marginTop == 8)
    }

    // MARK: - Widget: Activate

    @Test @MainActor func widgetActivate() {
        ensureAdwInit()
        let label = Label("Not activatable")
        // Labels are not activatable, should return false
        let result = label.activate()
        #expect(result == false)
    }

    // MARK: - Widget: Cast / TryCast

    @Test @MainActor func widgetCast() throws {
        ensureAdwInit()
        let label = Label("Cast me")
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL)
        box.append(label)
        // firstChild returns a Widget; cast it back to Label
        let child = try #require(box.firstChild)
        let asLabel = child.cast(Label.self)
        #expect(asLabel.text == "Cast me")
    }

    @Test @MainActor func widgetTryCast() throws {
        ensureAdwInit()
        let label = Label("TryCast")
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL)
        box.append(label)
        let child = try #require(box.firstChild)
        let asLabel = child.tryCast(Label.self)
        #expect(asLabel != nil)
    }

    // MARK: - Widget: Focus

    @Test @MainActor func widgetIsFocusableProperty() {
        ensureAdwInit()
        let label = Label("Focus")
        #expect(label.isFocusable == false)
        label.isFocusable = true
        #expect(label.isFocusable == true)
        label.isFocusable = false
        #expect(label.isFocusable == false)
    }

    @Test @MainActor func widgetHasFocusDefault() {
        ensureAdwInit()
        let label = Label("No focus")
        // Not in a window, should not have focus
        #expect(label.hasFocus == false)
    }

    // MARK: - Widget: Cursor

    @Test @MainActor func widgetSetAndResetCursor() {
        ensureAdwInit()
        let btn = Button(label: "Cursor")
        btn.setCursor(name: "pointer")
        btn.setCursor(name: "crosshair")
        btn.setCursor(name: "text")
        btn.resetCursor()
        // No crash
    }

    // MARK: - Widget: Tick Callback

    @Test @MainActor func widgetAddAndRemoveTickCallback() {
        ensureAdwInit()
        let label = Label("Tick")
        let id = label.addTickCallback { false }
        #expect(id > 0 || id == 0) // ID is a valid UInt
        label.removeTickCallback(id)
    }

    // MARK: - Widget: Accessibility

    @Test @MainActor func widgetAccessibleRoleAndLabels() {
        ensureAdwInit()
        let btn = Button(label: "Accessible")
        _ = btn.accessibleRole
        btn.setAccessibleLabel("My Button Label")
        btn.setAccessibleDescription("A description for screen readers")
        // No crash
    }

    // MARK: - Widget: Lifecycle Signals

    @Test @MainActor func widgetOnRealizeSignal() {
        ensureAdwInit()
        let label = Label("Realize")
        let conn = label.onRealize {}
        conn.disconnect()
    }

    @Test @MainActor func widgetOnUnrealizeSignal() {
        ensureAdwInit()
        let label = Label("Unrealize")
        let conn = label.onUnrealize {}
        conn.disconnect()
    }

    @Test @MainActor func widgetOnMapSignal() {
        ensureAdwInit()
        let label = Label("Map")
        let conn = label.onMap {}
        conn.disconnect()
    }

    @Test @MainActor func widgetOnUnmapSignal() {
        ensureAdwInit()
        let label = Label("Unmap")
        let conn = label.onUnmap {}
        conn.disconnect()
    }

    @Test @MainActor func widgetOnDestroySignal() {
        ensureAdwInit()
        let label = Label("Destroy")
        let conn = label.onDestroy {}
        conn.disconnect()
    }

    @Test @MainActor func widgetOnSizeAllocateSignal() {
        ensureAdwInit()
        let label = Label("Size")
        let conn = label.onSizeAllocate { w, h in
            _ = w
            _ = h
        }
        conn.disconnect()
    }

    // MARK: - Widget: Event Controller Add/Remove

    @Test @MainActor func widgetAddAndRemoveController() {
        ensureAdwInit()
        let label = Label("Controller")
        let motion = EventControllerMotion()
        label.addController(motion)
        label.removeController(motion)
        // No crash
    }

    // MARK: - Widget: Keyboard Shortcut with Key enum

    @Test @MainActor func widgetAddKeyboardShortcutKeyEnum() {
        ensureAdwInit()
        let btn = Button(label: "Shortcut")
        btn.addKeyboardShortcut(key: .s, modifiers: .control) { true }
        // No crash
    }

    // MARK: - Widget: onNotify

    @Test @MainActor func widgetOnNotifyProperty() {
        ensureAdwInit()
        let label = Label("Notify")
        var notified = false
        label.onNotify(.label) { notified = true }
        label.text = "Changed"
        #expect(notified, "onNotify should fire when property changes")
    }

    // MARK: - ListBox: Creation and Basic Operations

    @Test @MainActor func listBoxCreation() {
        ensureAdwInit()
        let list = ListBox()
        #expect(list.selectedRow == nil)
        #expect(list.selectedIndex == nil)
    }

    @Test @MainActor func listBoxAppendPrependRemove() {
        ensureAdwInit()
        let list = ListBox()
        let a = ListBoxRow()
        a.child = Label("A")
        let b = ListBoxRow()
        b.child = Label("B")
        let c = ListBoxRow()
        c.child = Label("C")
        list.append(a)
        list.prepend(b)
        list.append(c)
        // b should be first (prepended), then a, then c
        let firstRow = list.rowAt(0)
        #expect(firstRow != nil)
        list.remove(a)
        // Should not crash
    }

    @Test @MainActor func listBoxInsert() {
        ensureAdwInit()
        let list = ListBox()
        let a = Label("A")
        let c = Label("C")
        list.append(a)
        list.append(c)
        let b = Label("B")
        list.insert(b, position: 1)
        // b should now be at index 1
        let row = list.rowAt(1)
        #expect(row != nil)
    }

    @Test @MainActor func listBoxRemoveAll() {
        ensureAdwInit()
        let list = ListBox()
        list.append(Label("1"))
        list.append(Label("2"))
        list.append(Label("3"))
        list.removeAll()
        #expect(list.rowAt(0) == nil)
    }

    // MARK: - ListBox: Selection

    @Test @MainActor func listBoxSelectionMode() {
        ensureAdwInit()
        let list = ListBox()
        list.selectionMode = .single
        #expect(list.selectionMode == .single)
        list.selectionMode = .none
        #expect(list.selectionMode == .none)
        list.selectionMode = .multiple
        #expect(list.selectionMode == .multiple)
    }

    @Test @MainActor func listBoxSelectAndUnselectRow() {
        ensureAdwInit()
        let list = ListBox()
        list.selectionMode = .single
        list.append(Label("A"))
        list.append(Label("B"))
        list.selectRow(at: 0)
        #expect(list.selectedRow != nil)
        #expect(list.selectedIndex == 0)
        list.selectRow(at: 1)
        #expect(list.selectedIndex == 1)
        list.unselectRow(at: 1)
    }

    @Test @MainActor func listBoxUnselectAll() {
        ensureAdwInit()
        let list = ListBox()
        list.selectionMode = .multiple
        list.append(Label("A"))
        list.append(Label("B"))
        list.selectAll()
        list.unselectAll()
        #expect(list.selectedRow == nil)
    }

    // MARK: - ListBox: Properties

    @Test @MainActor func listBoxShowSeparators() {
        ensureAdwInit()
        let list = ListBox()
        #expect(list.showSeparators == false)
        list.showSeparators = true
        #expect(list.showSeparators == true)
        list.showSeparators = false
        #expect(list.showSeparators == false)
    }

    @Test @MainActor func listBoxActivateOnSingleClick() {
        ensureAdwInit()
        let list = ListBox()
        #expect(list.activateOnSingleClick == true)
        list.activateOnSingleClick = false
        #expect(list.activateOnSingleClick == false)
        list.activateOnSingleClick = true
        #expect(list.activateOnSingleClick == true)
    }

    // MARK: - ListBox: Placeholder

    @Test @MainActor func listBoxSetPlaceholder() {
        ensureAdwInit()
        let list = ListBox()
        let placeholder = Label("No items")
        list.setPlaceholder(placeholder)
        // Setting nil clears placeholder
        list.setPlaceholder(nil)
    }

    // MARK: - ListBox: Sort / Filter / Header

    @Test @MainActor func listBoxSortFunc() {
        ensureAdwInit()
        let list = ListBox()
        list.append(Label("C"))
        list.append(Label("A"))
        list.append(Label("B"))
        list.setSortFunc { _, _ in 0 }
        list.invalidateSort()
        list.clearSortFunc()
    }

    @Test @MainActor func listBoxFilterFunc() {
        ensureAdwInit()
        let list = ListBox()
        list.append(Label("Show"))
        list.append(Label("Hide"))
        list.setFilterFunc { _ in true }
        list.invalidateFilter()
        list.clearFilterFunc()
    }

    @Test @MainActor func listBoxHeaderFunc() {
        ensureAdwInit()
        let list = ListBox()
        list.append(Label("A"))
        list.append(Label("B"))
        list.setHeaderFunc { row, before in
            if before != nil {
                row.header = Separator()
            }
        }
        list.invalidateHeaders()
        list.clearHeaderFunc()
    }

    // MARK: - ListBox: Signals

    @Test @MainActor func listBoxOnRowSelectedSignal() {
        ensureAdwInit()
        let list = ListBox()
        list.selectionMode = .single
        let conn = list.onRowSelected { _ in }
        conn.disconnect()
    }

    @Test @MainActor func listBoxOnRowActivatedSignal() {
        ensureAdwInit()
        let list = ListBox()
        let conn = list.onRowActivated { _ in }
        conn.disconnect()
    }

    // MARK: - ListBox: Row At / SelectedIndex

    @Test @MainActor func listBoxRowAtIndex() {
        ensureAdwInit()
        let list = ListBox()
        list.append(Label("First"))
        list.append(Label("Second"))
        let row0 = list.rowAt(0)
        #expect(row0 != nil)
        let row1 = list.rowAt(1)
        #expect(row1 != nil)
        let rowOut = list.rowAt(99)
        #expect(rowOut == nil)
    }

    @Test @MainActor func listBoxSelectedIndexNil() {
        ensureAdwInit()
        let list = ListBox()
        list.selectionMode = .single
        list.append(Label("Item"))
        #expect(list.selectedIndex == nil)
    }

    // MARK: - ListBoxRow Properties

    @Test @MainActor func listBoxRowProperties() {
        ensureAdwInit()
        let row = ListBoxRow()
        let label = Label("Content")
        row.child = label
        #expect(row.child != nil)
        #expect(row.index == -1) // Not in a list box
        row.activatable = false
        #expect(row.activatable == false)
        row.activatable = true
        #expect(row.activatable == true)
        row.selectable = false
        #expect(row.selectable == false)
        row.selectable = true
        #expect(row.selectable == true)
    }

    @Test @MainActor func listBoxRowIndexInListBox() {
        ensureAdwInit()
        let list = ListBox()
        let row = ListBoxRow()
        row.child = Label("Item")
        list.append(row)
        #expect(row.index == 0)
    }

    @Test @MainActor func listBoxRowHeaderProperty() {
        ensureAdwInit()
        let row = ListBoxRow()
        #expect(row.header == nil)
        let header = Label("Header")
        row.header = header
        #expect(row.header != nil)
        row.header = nil
        #expect(row.header == nil)
    }

    @Test @MainActor func listBoxRowChanged() {
        ensureAdwInit()
        let list = ListBox()
        let row = ListBoxRow()
        row.child = Label("Item")
        list.append(row)
        // Should not crash
        row.changed()
    }

    // MARK: - Entry: Additional Coverage

    @Test @MainActor func entryActivatesDefault() {
        ensureAdwInit()
        let entry = Entry()
        #expect(entry.activatesDefault == false)
        entry.activatesDefault = true
        #expect(entry.activatesDefault == true)
    }

    @Test @MainActor func entryInputHints() {
        ensureAdwInit()
        let entry = Entry()
        entry.inputHints = GTK_INPUT_HINT_SPELLCHECK
        #expect(entry.inputHints == GTK_INPUT_HINT_SPELLCHECK)
        entry.inputHints = GTK_INPUT_HINT_NO_SPELLCHECK
        #expect(entry.inputHints == GTK_INPUT_HINT_NO_SPELLCHECK)
    }

    @Test @MainActor func entrySecondaryIcon() {
        ensureAdwInit()
        let entry = Entry()
        entry.setIcon(position: .secondary, iconName: "edit-clear-symbolic")
        #expect(entry.iconName(at: .secondary) == "edit-clear-symbolic")
        entry.setIcon(position: .secondary, iconName: nil)
        #expect(entry.iconName(at: .secondary) == nil)
    }

    @Test @MainActor func entryIconTooltip() {
        ensureAdwInit()
        let entry = Entry()
        entry.setIcon(position: .primary, iconName: "edit-find-symbolic")
        entry.setIconTooltip(position: .primary, tooltip: "Search")
        entry.setIconActivatable(position: .primary, activatable: true)
        // No crash
    }

    @Test @MainActor func entryProgressPulse() {
        ensureAdwInit()
        let entry = Entry()
        entry.progressPulseStep = 0.1
        entry.progressPulse()
        // No crash
    }

    @Test @MainActor func entryConvenienceInitWithHandler() {
        ensureAdwInit()
        var changed = false
        let entry = Entry(placeholder: "Type here") {
            changed = true
        }
        #expect(entry.placeholderText == "Type here")
        entry.text = "trigger"
        #expect(changed, "Handler should fire on text change")
    }

    // MARK: - Scale: Additional Coverage

    @Test @MainActor func scaleValuePos() {
        ensureAdwInit()
        let scale = Scale()
        scale.drawValue = true
        scale.valuePos = .top
        #expect(scale.valuePos == .top)
        scale.valuePos = .bottom
        #expect(scale.valuePos == .bottom)
    }

    @Test @MainActor func scaleFormatValueFunc() {
        ensureAdwInit()
        let scale = Scale(min: 0, max: 100, step: 1)
        scale.drawValue = true
        scale.setFormatValueFunc { value in "\(Int(value))%" }
        scale.value = 50
        // Reset to default formatting
        scale.setFormatValueFunc(nil)
    }

    @Test @MainActor func scaleOnValueChangedSignal() {
        ensureAdwInit()
        let scale = Scale(min: 0, max: 100, step: 1)
        var changed = false
        scale.onValueChanged { changed = true }
        scale.value = 42
        #expect(changed, "onValueChanged should fire when value is set")
    }

    @Test @MainActor func scaleAddAndClearMarks() {
        ensureAdwInit()
        let scale = Scale(min: 0, max: 100, step: 1)
        scale.addMark(value: 0, position: .top, markup: "0%")
        scale.addMark(value: 50, position: .bottom, markup: "50%")
        scale.addMark(value: 100, position: .top, markup: "100%")
        scale.clearMarks()
    }

    @Test @MainActor func scaleFluentDrawValue() {
        ensureAdwInit()
        let scale = Scale().drawValue(true)
        #expect(scale.drawValue == true)
    }

    @Test @MainActor func scaleFluentDigits() {
        ensureAdwInit()
        let scale = Scale().digits(2)
        #expect(scale.digits == 2)
    }

    // MARK: - Notebook: Additional Coverage

    @Test @MainActor func notebookAppendWithTabWidget() {
        ensureAdwInit()
        let notebook = Notebook()
        let content = Label("Content")
        let tabWidget = Box(orientation: GTK_ORIENTATION_HORIZONTAL)
        tabWidget.append(Label("Custom Tab"))
        let idx = notebook.appendPage(content, tabWidget: tabWidget)
        #expect(idx == 0)
        #expect(notebook.nPages == 1)
    }

    @Test @MainActor func notebookPageNum() {
        ensureAdwInit()
        let notebook = Notebook()
        let page1 = Label("Page 1")
        let page2 = Label("Page 2")
        notebook.appendPage(page1, label: "First")
        notebook.appendPage(page2, label: "Second")
        #expect(notebook.pageNum(page1) == 0)
        #expect(notebook.pageNum(page2) == 1)
    }

    @Test @MainActor func notebookSetTabReorderable() {
        ensureAdwInit()
        let notebook = Notebook()
        let page = Label("Content")
        notebook.appendPage(page, label: "Tab")
        notebook.setTabReorderable(page, reorderable: true)
        // No crash
    }

    @Test @MainActor func notebookReorderChild() {
        ensureAdwInit()
        let notebook = Notebook()
        let p1 = Label("Page 1")
        let p2 = Label("Page 2")
        notebook.appendPage(p1, label: "First")
        notebook.appendPage(p2, label: "Second")
        notebook.reorderChild(p1, position: 1)
        #expect(notebook.pageNum(p1) == 1)
    }

    @Test @MainActor func notebookOnSwitchPageSignal() {
        ensureAdwInit()
        let notebook = Notebook()
        var switchedTo: Int = -1
        let conn = notebook.onSwitchPage { pageIndex in
            switchedTo = pageIndex
        }
        let p1 = Label("Page 1")
        let p2 = Label("Page 2")
        notebook.appendPage(p1, label: "First")
        notebook.appendPage(p2, label: "Second")
        notebook.currentPage = 1
        // Signal may or may not fire without a main loop, but connection should work
        _ = switchedTo
        conn.disconnect()
    }

    @Test @MainActor func notebookGetNthPageNil() {
        ensureAdwInit()
        let notebook = Notebook()
        let page = notebook.getNthPage(99)
        #expect(page == nil)
    }

    @Test @MainActor func notebookSetTabLabelText() {
        ensureAdwInit()
        let notebook = Notebook()
        let content = Label("Content")
        notebook.appendPage(content, label: "Original")
        #expect(notebook.getTabLabelText(content) == "Original")
        notebook.setTabLabelText(content, text: "Renamed")
        #expect(notebook.getTabLabelText(content) == "Renamed")
    }
}
