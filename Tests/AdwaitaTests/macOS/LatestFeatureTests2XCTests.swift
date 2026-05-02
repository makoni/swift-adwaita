#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class LatestFeatureXCTests2: XCTestCase {

    // MARK: - SpinButton Tests

    @MainActor func test_spinButtonCreation() {
        ensureAdwInit()
        let spin = SpinButton(min: 0, max: 10, step: 1)
        XCTAssertTrue(spin.value == 0)
    }

    @MainActor func test_spinButtonValue() {
        ensureAdwInit()
        let spin = SpinButton(min: 0, max: 100, step: 1)
        spin.value = 42
        XCTAssertTrue(spin.value == 42)
        XCTAssertTrue(spin.intValue == 42)
    }

    @MainActor func test_spinButtonProperties() {
        ensureAdwInit()
        let spin = SpinButton(min: 0, max: 100, step: 1)
        spin.digits = 2
        XCTAssertTrue(spin.digits == 2)
        spin.numeric = true
        XCTAssertTrue(spin.numeric == true)
        spin.wrap = true
        XCTAssertTrue(spin.wrap == true)
        spin.snapToTicks = true
        XCTAssertTrue(spin.snapToTicks == true)
    }

    @MainActor func test_spinButtonOnValueChanged() {
        ensureAdwInit()
        let spin = SpinButton(min: 0, max: 100, step: 1)
        let conn = spin.onValueChanged {}
        XCTAssertTrue(conn is SignalConnection)
    }

    // MARK: - GestureClick Button Tests

    @MainActor func test_gestureClickButton() {
        ensureAdwInit()
        let gesture = GestureClick()
        gesture.button = 3
        XCTAssertTrue(gesture.button == 3)
    }

    // MARK: - Double/Right Click Tests

    @MainActor func test_widgetOnDoubleClick() {
        ensureAdwInit()
        let label = Label("Test")
        let conn = label.onDoubleClick {}
        XCTAssertTrue(conn is SignalConnection)
    }

    @MainActor func test_widgetOnRightClick() {
        ensureAdwInit()
        let label = Label("Test")
        let conn = label.onRightClick { x, y in _ = (x, y) }
        XCTAssertTrue(conn is SignalConnection)
    }

    @MainActor func test_widgetOnRightClickSimple() {
        ensureAdwInit()
        let label = Label("Test")
        let conn = label.onRightClick {}
        XCTAssertTrue(conn is SignalConnection)
    }

    // MARK: - Scale Fluent Tests

    @MainActor func test_scaleDrawValueFluent() {
        ensureAdwInit()
        let scale = Scale().drawValue()
        XCTAssertTrue(scale.drawValue == true)
    }

    @MainActor func test_scaleDigitsFluent() {
        ensureAdwInit()
        let scale = Scale().digits(2)
        XCTAssertTrue(scale.digits == 2)
    }

    // MARK: - StringList Convenience Tests

    @MainActor func test_stringListContains() {
        ensureAdwInit()
        let sl = StringList(["Apple", "Banana", "Cherry"])
        XCTAssertTrue(sl.contains("Banana") == true)
        XCTAssertTrue(sl.contains("Grape") == false)
    }

    @MainActor func test_stringListIndexOf() {
        ensureAdwInit()
        let sl = StringList(["Apple", "Banana", "Cherry"])
        XCTAssertTrue(sl.indexOf("Banana") == 1)
        XCTAssertTrue(sl.indexOf("Cherry") == 2)
        XCTAssertNil(sl.indexOf("Grape"))
    }

    @MainActor func test_stringListRemoveAll() {
        ensureAdwInit()
        let sl = StringList(["A", "B", "C"])
        XCTAssertTrue(sl.count == 3)
        sl.removeAll()
        XCTAssertTrue(sl.count == 0)
    }

    @MainActor func test_stringListReplaceAll() {
        ensureAdwInit()
        let sl = StringList(["old1", "old2"])
        sl.replaceAll(["new1", "new2", "new3"])
        XCTAssertTrue(sl.count == 3)
        XCTAssertTrue(sl.getString(0) == "new1")
        XCTAssertTrue(sl.getString(2) == "new3")
    }

    @MainActor func test_stringListAllStrings() {
        ensureAdwInit()
        let sl = StringList(["X", "Y", "Z"])
        XCTAssertTrue(sl.allStrings == ["X", "Y", "Z"])
    }

    // MARK: - Box Fluent Setter Tests

    @MainActor func test_boxAppendAll() {
        ensureAdwInit()
        let box = Box()
        let labels = [Label("A"), Label("B"), Label("C")]
        box.appendAll(labels)
        // Should have children
        XCTAssertNotNil(box.firstChild)
    }

    @MainActor func test_boxSpacingFluent() {
        ensureAdwInit()
        let box = Box().spacing(12)
        XCTAssertTrue(box.spacing == 12)
    }

    @MainActor func test_boxHomogeneousFluent() {
        ensureAdwInit()
        let box = Box().homogeneous()
        XCTAssertTrue(box.homogeneous == true)
    }

    // MARK: - ListBox selectedIndex Tests

    @MainActor func test_listBoxSelectedIndex() {
        ensureAdwInit()
        let lb = ListBox()
        lb.selectionMode = GTK_SELECTION_SINGLE
        lb.append(Label("Row 0"))
        lb.append(Label("Row 1"))
        // No selection initially
        XCTAssertNil(lb.selectedIndex)
        lb.selectRow(at: 1)
        XCTAssertTrue(lb.selectedIndex == 1)
    }

    // MARK: - SingleSelection Fluent Setter Tests

    @MainActor func test_singleSelectionFluentSelected() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let sel = SingleSelection(model: store).selected(1)
        XCTAssertTrue(sel.selected == 1)
    }

    @MainActor func test_singleSelectionFluentCanUnselect() {
        ensureAdwInit()
        let store = ListStore()
        let sel = SingleSelection(model: store).canUnselect(true)
        XCTAssertTrue(sel.canUnselect == true)
    }

    @MainActor func test_singleSelectionFluentAutoselect() {
        ensureAdwInit()
        let store = ListStore()
        let sel = SingleSelection(model: store).autoselect(false)
        XCTAssertTrue(sel.autoselect == false)
    }

    // MARK: - EntryRow Text Property Tests

    @MainActor func test_entryRowTextProperty() {
        ensureAdwInit()
        let row = EntryRow(title: "Name")
        row.text = "Hello"
        XCTAssertTrue(row.text == "Hello")
    }

    @MainActor func test_entryRowConvenienceInitWithText() {
        ensureAdwInit()
        let row = EntryRow(title: "Name", text: "John")
        XCTAssertTrue(row.title == "Name")
        XCTAssertTrue(row.text == "John")
    }

    @MainActor func test_entryRowOnChanged() {
        ensureAdwInit()
        let row = EntryRow(title: "Test")
        let conn = row.onChanged {}
        conn.disconnect()
    }

    @MainActor func test_passwordEntryRowInheritsText() {
        ensureAdwInit()
        let row = PasswordEntryRow(title: "Password")
        row.text = "secret"
        XCTAssertTrue(row.text == "secret")
    }

    // MARK: - ExpanderRow Convenience Init Tests

    @MainActor func test_expanderRowConvenienceInitWithExpanded() {
        ensureAdwInit()
        let row = ExpanderRow(title: "Section", subtitle: "Details", expanded: true)
        XCTAssertTrue(row.title == "Section")
        XCTAssertTrue(row.subtitle == "Details")
        XCTAssertTrue(row.expanded == true)
    }

    // MARK: - Carousel Convenience Tests

    @MainActor func test_carouselAppendAll() {
        ensureAdwInit()
        let carousel = Carousel()
        let pages = [Label("1"), Label("2"), Label("3")]
        carousel.appendAll(pages)
        XCTAssertTrue(carousel.nPages == 3)
    }

    @MainActor func test_carouselSpacingFluent() {
        ensureAdwInit()
        let carousel = Carousel().spacing(20)
        XCTAssertTrue(carousel.spacing == 20)
    }

    @MainActor func test_carouselInteractiveFluent() {
        ensureAdwInit()
        let carousel = Carousel().interactive(false)
        XCTAssertTrue(carousel.interactive == false)
    }

    // MARK: - FlowBox appendAll Tests

    @MainActor func test_flowBoxAppendAll() {
        ensureAdwInit()
        let fb = FlowBox()
        let labels = [Label("A"), Label("B")]
        fb.appendAll(labels)
        XCTAssertNotNil(fb.firstChild)
    }

}
#endif
