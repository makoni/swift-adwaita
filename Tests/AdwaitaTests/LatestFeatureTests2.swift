import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct LatestFeatureTests2 {

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
        let conn = spin.onValueChanged {}
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
        let conn = label.onDoubleClick {}
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
        let conn = label.onRightClick {}
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
        let conn = row.onChanged {}
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
