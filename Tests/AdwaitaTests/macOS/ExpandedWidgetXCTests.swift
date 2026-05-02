#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class ExpandedWidgetXCTests: XCTestCase {

    // MARK: - BottomSheet (1.6+)

    @MainActor func test_bottomSheetAlignment() {
        ensureAdwInit()
        guard let bs = BottomSheet() else { return }
        bs.align = 0.0
        XCTAssertTrue(abs(bs.align - 0.0) < 0.01)
        bs.align = 1.0
        XCTAssertTrue(abs(bs.align - 1.0) < 0.01)
        bs.align = 0.5
        XCTAssertTrue(abs(bs.align - 0.5) < 0.01)
    }

    @MainActor func test_bottomSheetContentAndSheet() {
        ensureAdwInit()
        guard let bs = BottomSheet() else { return }
        let content = Label("Main Content")
        let sheet = Label("Sheet Content")
        bs.content = content
        bs.sheet = sheet
        XCTAssertNotNil(bs.content)
        XCTAssertNotNil(bs.sheet)
    }

    @MainActor func test_bottomSheetBottomBar() {
        ensureAdwInit()
        guard let bs = BottomSheet() else { return }
        let bar = Label("Bottom Bar")
        bs.bottomBar = bar
        XCTAssertNotNil(bs.bottomBar)
        XCTAssertTrue(bs.bottomBarHeight >= 0)
    }

    @MainActor func test_bottomSheetOpenClose() {
        ensureAdwInit()
        guard let bs = BottomSheet() else { return }
        bs.open = false
        XCTAssertTrue(bs.open == false)
        XCTAssertTrue(bs.sheetHeight >= 0)
    }

    @MainActor func test_bottomSheetCloseAttemptSignal() {
        ensureAdwInit()
        guard let bs = BottomSheet() else { return }
        var attempted = false
        let conn = bs.onCloseAttempt { attempted = true }
        // Signal connected without crash
        XCTAssertFalse(attempted)
        conn.disconnect()
    }

    // MARK: - SpinnerPaintable (1.6+)

    @MainActor func test_spinnerPaintableCreation() {
        ensureAdwInit()
        let label = Label("Host")
        guard let paintable = SpinnerPaintable(widget: label) else { return }
        XCTAssertNotNil(paintable.widget)
    }

    @MainActor func test_spinnerPaintableNilWidget() {
        ensureAdwInit()
        guard let paintable = SpinnerPaintable(widget: nil) else { return }
        XCTAssertNil(paintable.widget)
        let label = Label("New Host")
        paintable.widget = label
        XCTAssertNotNil(paintable.widget)
    }

    // MARK: - TabOverview

    @MainActor func test_tabOverviewCreation() {
        ensureAdwInit()
        let overview = TabOverview()
        XCTAssertTrue(overview.open == false)
        XCTAssertTrue(overview.enableNewTab == false)
        XCTAssertTrue(overview.enableSearch == true)
    }

    @MainActor func test_tabOverviewProperties() {
        ensureAdwInit()
        let overview = TabOverview()
        overview.enableNewTab = true
        XCTAssertTrue(overview.enableNewTab == true)
        overview.enableSearch = false
        XCTAssertTrue(overview.enableSearch == false)
        overview.inverted = true
        XCTAssertTrue(overview.inverted == true)
        overview.showStartTitleButtons = true
        XCTAssertTrue(overview.showStartTitleButtons == true)
        overview.showEndTitleButtons = false
        XCTAssertTrue(overview.showEndTitleButtons == false)
    }

    @MainActor func test_tabOverviewWithTabView() {
        ensureAdwInit()
        let overview = TabOverview()
        let tabView = TabView()
        overview.view = tabView
        XCTAssertNotNil(overview.view)
        let content = Label("Content")
        overview.child = content
        XCTAssertNotNil(overview.child)
    }

    @MainActor func test_tabOverviewCreateTabSignal() {
        ensureAdwInit()
        let overview = TabOverview()
        var created = false
        let conn = overview.onCreateTab { created = true }
        XCTAssertFalse(created)
        conn.disconnect()
    }

    // MARK: - EnumListModel

    @MainActor func test_enumListModelCreation() {
        ensureAdwInit()
        let colorSchemeType = adw_color_scheme_get_type()
        let model = EnumListModel(enumType: colorSchemeType)
        XCTAssertTrue(model.enumType == colorSchemeType)
    }

    @MainActor func test_enumListModelFindPosition() {
        ensureAdwInit()
        let model = EnumListModel(enumType: adw_color_scheme_get_type())
        let pos = model.findPosition(0)
        XCTAssertTrue(pos >= 0, "Position of the first enum value should be non-negative")
    }

    // MARK: - WrapBox (1.7+)

    @MainActor func test_wrapBoxProperties() {
        ensureAdwInit()
        guard let wrap = WrapBox() else { return }
        wrap.childSpacing = 8
        XCTAssertTrue(wrap.childSpacing == 8)
        wrap.lineSpacing = 12
        XCTAssertTrue(wrap.lineSpacing == 12)
        wrap.naturalLineLength = 300
        XCTAssertTrue(wrap.naturalLineLength == 300)
    }

    @MainActor func test_wrapBoxAlignment() {
        ensureAdwInit()
        guard let wrap = WrapBox() else { return }
        wrap.align = 0.0
        XCTAssertTrue(abs(wrap.align - 0.0) < 0.01)
        wrap.align = 0.5
        XCTAssertTrue(abs(wrap.align - 0.5) < 0.01)
    }

    @MainActor func test_wrapBoxJustify() {
        ensureAdwInit()
        guard let wrap = WrapBox() else { return }
        wrap.justify = ADW_JUSTIFY_FILL
        XCTAssertTrue(wrap.justify == ADW_JUSTIFY_FILL)
        wrap.justifyLastLine = true
        XCTAssertTrue(wrap.justifyLastLine == true)
    }

    @MainActor func test_wrapBoxLineHomogeneous() {
        ensureAdwInit()
        guard let wrap = WrapBox() else { return }
        wrap.lineHomogeneous = true
        XCTAssertTrue(wrap.lineHomogeneous == true)
        wrap.lineHomogeneous = false
        XCTAssertTrue(wrap.lineHomogeneous == false)
    }

    @MainActor func test_wrapBoxContainer() {
        ensureAdwInit()
        guard let wrap = WrapBox() else { return }
        let a = Label("A")
        let b = Label("B")
        let c = Label("C")
        wrap.append(a)
        wrap.append(b)
        wrap.append(c)
        wrap.remove(b)
        // Should not crash; a and c still in wrap box
    }

    // MARK: - ExpanderRow

    @MainActor func test_expanderRowProperties() {
        ensureAdwInit()
        let row = ExpanderRow()
        row.title = "Section"
        XCTAssertTrue(row.title == "Section")
        row.subtitle = "Details"
        XCTAssertTrue(row.subtitle == "Details")
        row.expanded = true
        XCTAssertTrue(row.expanded == true)
        row.showEnableSwitch = true
        XCTAssertTrue(row.showEnableSwitch == true)
        row.enableExpansion = false
        XCTAssertTrue(row.enableExpansion == false)
    }

    @MainActor func test_expanderRowAddRemoveRows() {
        ensureAdwInit()
        let row = ExpanderRow()
        let child1 = ActionRow()
        child1.title = "Child 1"
        let child2 = ActionRow()
        child2.title = "Child 2"
        row.addRow(child1)
        row.addRow(child2)
        row.remove(child1)
        // Should not crash
    }

    // MARK: - ComboRow

    @MainActor func test_comboRowWithStringList() {
        ensureAdwInit()
        let row = ComboRow()
        row.title = "Choose"
        let strings = StringList(["Apple", "Banana", "Cherry"])
        row.setModel(strings)
        XCTAssertTrue(row.title == "Choose")
        row.selected = 1
        XCTAssertTrue(row.selected == 1)
    }

    // MARK: - PasswordEntryRow

    @MainActor func test_passwordEntryRowCreation() {
        ensureAdwInit()
        let row = PasswordEntryRow()
        row.title = "Password"
        XCTAssertTrue(row.title == "Password")
    }

    // MARK: - Drag and Drop

    @MainActor func test_dragSourceTextContent() {
        ensureAdwInit()
        let drag = DragSource()
        drag.setTextContent("Hello Drag")
        let button = Button(label: "Drag Me")
        button.addController(drag)
        // Should not crash
    }

    @MainActor func test_dropTargetForText() {
        ensureAdwInit()
        let drop = DropTarget.forText()
        var received: String?
        drop.onDrop { text in
            received = text
            return true
        }
        let label = Label("Drop Here")
        label.addController(drop)
        XCTAssertNil(received, "No drop has occurred yet")
    }

    @MainActor func test_dragSourceOnWidget() {
        ensureAdwInit()
        let drag = DragSource()
        drag.setTextContent("Test")
        var began = false
        drag.onDragBegin { began = true }
        let label = Label("Source")
        label.addController(drag)
        XCTAssertFalse(began, "Drag has not started yet")
    }

    // MARK: - Revealer

    @MainActor func test_revealerTransitions() {
        ensureAdwInit()
        let revealer = Revealer()
        let content = Label("Hidden")
        revealer.child = content
        revealer.transitionType = .slideDown
        XCTAssertTrue(revealer.transitionType == .slideDown)
        revealer.revealChild = false
        XCTAssertTrue(revealer.revealChild == false)
        revealer.revealChild = true
        XCTAssertTrue(revealer.revealChild == true)
        revealer.transitionDuration = 500
        XCTAssertTrue(revealer.transitionDuration == 500)
    }

    // MARK: - FlowBox

    @MainActor func test_flowBoxChildManagement() {
        ensureAdwInit()
        let flow = FlowBox()
        flow.selectionMode = .single
        flow.minChildrenPerLine = 2
        flow.maxChildrenPerLine = 5
        XCTAssertTrue(flow.minChildrenPerLine == 2)
        XCTAssertTrue(flow.maxChildrenPerLine == 5)
        let a = Label("A")
        let b = Label("B")
        flow.append(a)
        flow.append(b)
        flow.remove(a)
    }

    // MARK: - ListBox Selection

    @MainActor func test_listBoxSelectionModes() {
        ensureAdwInit()
        let list = ListBox()
        list.selectionMode = .none
        XCTAssertTrue(list.selectionMode == .none)
        list.selectionMode = .single
        XCTAssertTrue(list.selectionMode == .single)
        list.selectionMode = .multiple
        XCTAssertTrue(list.selectionMode == .multiple)
    }

    @MainActor func test_listBoxRowActivation() {
        ensureAdwInit()
        var activatedIndex: Int = -1
        let list = ListBox()
        list.selectionMode = .single
        list.onRowActivated { row in
            activatedIndex = Int(row.index)
        }
        let label = Label("Item")
        list.append(label)
        // Signal connected without crash
        XCTAssertTrue(activatedIndex == -1, "No row activated yet")
    }

    // MARK: - Image

    @MainActor func test_imageTypeSafeIcon() {
        ensureAdwInit()
        let img = Image(icon: .dialogInformation)
        XCTAssertTrue(img.iconName == IconName.dialogInformation.name)
    }

    // MARK: - Calendar

    @MainActor func test_calendarDateProperties() {
        ensureAdwInit()
        let cal = Calendar()
        cal.year = 2025
        cal.month = 5
        cal.day = 15
        XCTAssertTrue(cal.year == 2025)
        XCTAssertTrue(cal.month == 5)
        XCTAssertTrue(cal.day == 15)
    }

    // MARK: - Adjustment

    @MainActor func test_adjustmentClampValue() {
        ensureAdwInit()
        let adj = Adjustment()
        adj.configure(value: 0, lower: 0, upper: 100, stepIncrement: 1, pageIncrement: 10, pageSize: 0)
        adj.value = 150
        adj.clampPage(lower: 0, upper: 100)
        XCTAssertTrue(adj.value <= 100)
    }
}
#endif
