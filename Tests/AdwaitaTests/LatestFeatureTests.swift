import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized) struct LatestFeatureTests {

    // MARK: - Individual Margin Fluent Setters

    @Test @MainActor func fluentMarginStart() {
        ensureAdwInit()
        let label = Label("Test").marginStart(8)
        #expect(label.marginStart == 8)
    }

    @Test @MainActor func fluentMarginEnd() {
        ensureAdwInit()
        let label = Label("Test").marginEnd(16)
        #expect(label.marginEnd == 16)
    }

    @Test @MainActor func fluentMarginTop() {
        ensureAdwInit()
        let label = Label("Test").marginTop(4)
        #expect(label.marginTop == 4)
    }

    @Test @MainActor func fluentMarginBottom() {
        ensureAdwInit()
        let label = Label("Test").marginBottom(12)
        #expect(label.marginBottom == 12)
    }

    // MARK: - Children Iteration Tests

    @Test @MainActor func widgetChildren() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 0)
        let a = Label("A")
        let b = Label("B")
        let c = Label("C")
        box.append(a)
        box.append(b)
        box.append(c)
        let kids = box.children()
        #expect(kids.count == 3)
    }

    @Test @MainActor func widgetForEachChild() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 0)
        box.append(Label("A"))
        box.append(Label("B"))
        var count = 0
        box.forEachChild { _ in count += 1 }
        #expect(count == 2)
    }

    // MARK: - MenuButton Convenience Tests

    @Test @MainActor func menuButtonLabelInit() {
        ensureAdwInit()
        let btn = MenuButton(label: "File")
        #expect(btn.label == "File")
    }

    @Test @MainActor func menuButtonIconInit() {
        ensureAdwInit()
        let btn = MenuButton(icon: .openMenu)
        #expect(btn.iconName == "open-menu-symbolic")
    }

    // MARK: - Revealer Signal Tests

    @Test @MainActor func revealerOnChildRevealed() {
        ensureAdwInit()
        let revealer = Revealer()
        // Just verify it connects without crashing
        let conn = revealer.onChildRevealed { }
        #expect(conn is SignalConnection)
    }

    // MARK: - Expander Signal Tests

    @Test @MainActor func expanderOnExpanded() {
        ensureAdwInit()
        let expander = Expander(label: "Details")
        let conn = expander.onExpanded { }
        #expect(conn is SignalConnection)
    }

    // MARK: - Popover Signal Tests

    @Test @MainActor func popoverOnVisibilityChanged() {
        ensureAdwInit()
        let popover = Popover()
        let conn = popover.onVisibilityChanged { }
        #expect(conn is SignalConnection)
    }

    // MARK: - Gesture Convenience Tests

    @Test @MainActor func widgetOnClick() {
        ensureAdwInit()
        var clicked = false
        let label = Label("Click me")
        let conn = label.onClick { clicked = true }
        #expect(conn is SignalConnection)
        #expect(!clicked)
    }

    @Test @MainActor func widgetOnClickDetailed() {
        ensureAdwInit()
        let label = Label("Click me")
        let conn = label.onClick { nPress, x, y in
            _ = (nPress, x, y)
        }
        #expect(conn is SignalConnection)
    }

    @Test @MainActor func widgetOnLongPress() {
        ensureAdwInit()
        let label = Label("Hold me")
        let conn = label.onLongPress { x, y in _ = (x, y) }
        #expect(conn is SignalConnection)
    }

    @Test @MainActor func widgetOnSwipe() {
        ensureAdwInit()
        let label = Label("Swipe me")
        let conn = label.onSwipe { vx, vy in _ = (vx, vy) }
        #expect(conn is SignalConnection)
    }

    // MARK: - findChild Tests

    @Test @MainActor func widgetFindChild() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 0)
        let inner = Box(orientation: GTK_ORIENTATION_HORIZONTAL, spacing: 0)
        let label = Label("Deep")
        inner.append(label)
        box.append(inner)
        // Should find the label inside the inner box
        let found = box.findChild(ofType: Label.self)
        #expect(found != nil)
    }

    @Test @MainActor func widgetFindChildEmpty() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 0)
        let found = box.findChild(ofType: Label.self)
        #expect(found == nil)
    }

    // MARK: - Grid Convenience Tests

    @Test @MainActor func gridConvenienceInit() {
        ensureAdwInit()
        let grid = Grid(columnSpacing: 8, rowSpacing: 12)
        #expect(grid.columnSpacing == 8)
        #expect(grid.rowSpacing == 12)
    }

    // MARK: - Paned Convenience Tests

    @Test @MainActor func panedConvenienceInit() {
        ensureAdwInit()
        let start = Label("Left")
        let end = Label("Right")
        let paned = Paned(start: start, end: end)
        #expect(paned.startChild != nil)
        #expect(paned.endChild != nil)
    }

    // MARK: - NavigationView Push Convenience Tests

    @Test @MainActor func navigationViewPushConvenience() {
        ensureAdwInit()
        let nav = NavigationView()
        let root = NavigationPage(child: Label("Root"), title: "Root")
        nav.add(root)
        let page = nav.push(title: "Detail", child: Label("Detail Content"))
        #expect(page.title == "Detail")
    }

    @Test @MainActor func navigationViewPushTagConvenience() {
        ensureAdwInit()
        let nav = NavigationView()
        let root = NavigationPage(child: Label("Root"), title: "Root")
        nav.add(root)
        let page = nav.push(title: "Settings", tag: "settings", child: Label("Settings"))
        #expect(page.title == "Settings")
        #expect(page.tag == "settings")
    }

    // MARK: - TextBuffer Convenience Tests

    @Test @MainActor func textBufferTextInRange() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Hello World"
        #expect(buf.text(in: 0..<5) == "Hello")
        #expect(buf.text(in: 6..<11) == "World")
    }

    @Test @MainActor func textBufferInsertAtOffset() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Hello World"
        buf.insert("Beautiful ", at: 6)
        #expect(buf.text == "Hello Beautiful World")
    }

    @Test @MainActor func textBufferApplyTagInRange() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Hello World"
        let tag = buf.createTag(name: "test-tag")
        tag.weight = 700
        buf.applyTag(tag, in: 0..<5)
        // Should not crash
        buf.removeTag(tag, in: 0..<5)
    }

    // MARK: - TextTag Preset Tests

    @Test @MainActor func textTagBoldPreset() {
        ensureAdwInit()
        let tag = TextTag.bold()
        #expect(tag.weight == 700)
    }

    @Test @MainActor func textTagItalicPreset() {
        ensureAdwInit()
        let tag = TextTag.italic()
        #expect(tag.style == .italic)
    }

    @Test @MainActor func textTagMonospacePreset() {
        ensureAdwInit()
        let tag = TextTag.monospace()
        // Just verify it doesn't crash — family is write-only
        #expect(tag is TextTag)
    }

    @Test @MainActor func textTagColoredPreset() {
        ensureAdwInit()
        let tag = TextTag.colored("red", name: "error")
        #expect(tag is TextTag)
    }

    // MARK: - Stack Signal Tests

    @Test @MainActor func stackOnVisibleChildChanged() {
        ensureAdwInit()
        let stack = Stack()
        let conn = stack.onVisibleChildChanged { }
        #expect(conn is SignalConnection)
    }

    // MARK: - Entry Selection Tests

    @Test @MainActor func entrySelectAll() {
        ensureAdwInit()
        let entry = Entry()
        entry.text = "Hello World"
        entry.selectAll()
        #expect(entry.hasSelection)
    }

    @Test @MainActor func entryCursorPosition() {
        ensureAdwInit()
        let entry = Entry()
        entry.text = "Hello"
        entry.cursorPosition = 3
        #expect(entry.cursorPosition == 3)
    }

    @Test @MainActor func entryClearSelection() {
        ensureAdwInit()
        let entry = Entry()
        entry.text = "Hello"
        entry.selectAll()
        entry.clearSelection()
        #expect(!entry.hasSelection)
    }

    // MARK: - Paned Signal Tests

    @Test @MainActor func panedOnPositionChanged() {
        ensureAdwInit()
        let paned = Paned()
        let conn = paned.onPositionChanged { }
        #expect(conn is SignalConnection)
    }

    // MARK: - Notebook Fluent Tests

    @Test @MainActor func notebookScrollableFluent() {
        ensureAdwInit()
        let nb = Notebook().scrollable()
        #expect(nb.scrollable == true)
    }

    @Test @MainActor func notebookTabPosFluent() {
        ensureAdwInit()
        let nb = Notebook().tabPos(GTK_POS_LEFT)
        #expect(nb.tabPos == GTK_POS_LEFT)
    }

    // MARK: - SpinButton Tests

    @Test @MainActor func spinButtonCreation() {
        ensureAdwInit()
        let spin = SpinButton(min: 0, max: 10, step: 1)
        #expect(spin.value == 0)
    }

    @Test @MainActor func spinButtonValue() {
        ensureAdwInit()
        let spin = SpinButton(min: 0, max: 100, step: 1)
        spin.value = 42
        #expect(spin.value == 42)
        #expect(spin.intValue == 42)
    }

    @Test @MainActor func spinButtonProperties() {
        ensureAdwInit()
        let spin = SpinButton(min: 0, max: 100, step: 1)
        spin.digits = 2
        #expect(spin.digits == 2)
        spin.numeric = true
        #expect(spin.numeric == true)
        spin.wrap = true
        #expect(spin.wrap == true)
        spin.snapToTicks = true
        #expect(spin.snapToTicks == true)
    }

    @Test @MainActor func spinButtonOnValueChanged() {
        ensureAdwInit()
        let spin = SpinButton(min: 0, max: 100, step: 1)
        let conn = spin.onValueChanged { }
        #expect(conn is SignalConnection)
    }

    // MARK: - GestureClick Button Tests

    @Test @MainActor func gestureClickButton() {
        ensureAdwInit()
        let gesture = GestureClick()
        gesture.button = 3
        #expect(gesture.button == 3)
    }

    // MARK: - Double/Right Click Tests

    @Test @MainActor func widgetOnDoubleClick() {
        ensureAdwInit()
        let label = Label("Test")
        let conn = label.onDoubleClick { }
        #expect(conn is SignalConnection)
    }

    @Test @MainActor func widgetOnRightClick() {
        ensureAdwInit()
        let label = Label("Test")
        let conn = label.onRightClick { x, y in _ = (x, y) }
        #expect(conn is SignalConnection)
    }

    @Test @MainActor func widgetOnRightClickSimple() {
        ensureAdwInit()
        let label = Label("Test")
        let conn = label.onRightClick { }
        #expect(conn is SignalConnection)
    }

    // MARK: - Scale Fluent Tests

    @Test @MainActor func scaleDrawValueFluent() {
        ensureAdwInit()
        let scale = Scale().drawValue()
        #expect(scale.drawValue == true)
    }

    @Test @MainActor func scaleDigitsFluent() {
        ensureAdwInit()
        let scale = Scale().digits(2)
        #expect(scale.digits == 2)
    }

    // MARK: - StringList Convenience Tests

    @Test @MainActor func stringListContains() {
        ensureAdwInit()
        let sl = StringList(["Apple", "Banana", "Cherry"])
        #expect(sl.contains("Banana") == true)
        #expect(sl.contains("Grape") == false)
    }

    @Test @MainActor func stringListIndexOf() {
        ensureAdwInit()
        let sl = StringList(["Apple", "Banana", "Cherry"])
        #expect(sl.indexOf("Banana") == 1)
        #expect(sl.indexOf("Cherry") == 2)
        #expect(sl.indexOf("Grape") == nil)
    }

    @Test @MainActor func stringListRemoveAll() {
        ensureAdwInit()
        let sl = StringList(["A", "B", "C"])
        #expect(sl.count == 3)
        sl.removeAll()
        #expect(sl.count == 0)
    }

    @Test @MainActor func stringListReplaceAll() {
        ensureAdwInit()
        let sl = StringList(["old1", "old2"])
        sl.replaceAll(["new1", "new2", "new3"])
        #expect(sl.count == 3)
        #expect(sl.getString(0) == "new1")
        #expect(sl.getString(2) == "new3")
    }

    @Test @MainActor func stringListAllStrings() {
        ensureAdwInit()
        let sl = StringList(["X", "Y", "Z"])
        #expect(sl.allStrings == ["X", "Y", "Z"])
    }

    // MARK: - Box Fluent Setter Tests

    @Test @MainActor func boxAppendAll() {
        ensureAdwInit()
        let box = Box()
        let labels = [Label("A"), Label("B"), Label("C")]
        box.appendAll(labels)
        // Should have children
        #expect(box.firstChild != nil)
    }

    @Test @MainActor func boxSpacingFluent() {
        ensureAdwInit()
        let box = Box().spacing(12)
        #expect(box.spacing == 12)
    }

    @Test @MainActor func boxHomogeneousFluent() {
        ensureAdwInit()
        let box = Box().homogeneous()
        #expect(box.homogeneous == true)
    }

    // MARK: - ListBox selectedIndex Tests

    @Test @MainActor func listBoxSelectedIndex() {
        ensureAdwInit()
        let lb = ListBox()
        lb.selectionMode = GTK_SELECTION_SINGLE
        lb.append(Label("Row 0"))
        lb.append(Label("Row 1"))
        // No selection initially
        #expect(lb.selectedIndex == nil)
        lb.selectRow(at: 1)
        #expect(lb.selectedIndex == 1)
    }

    // MARK: - SingleSelection Fluent Setter Tests

    @Test @MainActor func singleSelectionFluentSelected() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let sel = SingleSelection(model: store).selected(1)
        #expect(sel.selected == 1)
    }

    @Test @MainActor func singleSelectionFluentCanUnselect() {
        ensureAdwInit()
        let store = ListStore()
        let sel = SingleSelection(model: store).canUnselect(true)
        #expect(sel.canUnselect == true)
    }

    @Test @MainActor func singleSelectionFluentAutoselect() {
        ensureAdwInit()
        let store = ListStore()
        let sel = SingleSelection(model: store).autoselect(false)
        #expect(sel.autoselect == false)
    }

    // MARK: - EntryRow Text Property Tests

    @Test @MainActor func entryRowTextProperty() {
        ensureAdwInit()
        let row = EntryRow(title: "Name")
        row.text = "Hello"
        #expect(row.text == "Hello")
    }

    @Test @MainActor func entryRowConvenienceInitWithText() {
        ensureAdwInit()
        let row = EntryRow(title: "Name", text: "John")
        #expect(row.title == "Name")
        #expect(row.text == "John")
    }

    @Test @MainActor func entryRowOnChanged() {
        ensureAdwInit()
        let row = EntryRow(title: "Test")
        let conn = row.onChanged { }
        conn.disconnect()
    }

    @Test @MainActor func passwordEntryRowInheritsText() {
        ensureAdwInit()
        let row = PasswordEntryRow(title: "Password")
        row.text = "secret"
        #expect(row.text == "secret")
    }

    // MARK: - ExpanderRow Convenience Init Tests

    @Test @MainActor func expanderRowConvenienceInitWithExpanded() {
        ensureAdwInit()
        let row = ExpanderRow(title: "Section", subtitle: "Details", expanded: true)
        #expect(row.title == "Section")
        #expect(row.subtitle == "Details")
        #expect(row.expanded == true)
    }

    // MARK: - Carousel Convenience Tests

    @Test @MainActor func carouselAppendAll() {
        ensureAdwInit()
        let carousel = Carousel()
        let pages = [Label("1"), Label("2"), Label("3")]
        carousel.appendAll(pages)
        #expect(carousel.nPages == 3)
    }

    @Test @MainActor func carouselSpacingFluent() {
        ensureAdwInit()
        let carousel = Carousel().spacing(20)
        #expect(carousel.spacing == 20)
    }

    @Test @MainActor func carouselInteractiveFluent() {
        ensureAdwInit()
        let carousel = Carousel().interactive(false)
        #expect(carousel.interactive == false)
    }

    // MARK: - FlowBox appendAll Tests

    @Test @MainActor func flowBoxAppendAll() {
        ensureAdwInit()
        let fb = FlowBox()
        let labels = [Label("A"), Label("B")]
        fb.appendAll(labels)
        #expect(fb.firstChild != nil)
    }

}
