import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct ExpandedWidgetTests {

    // MARK: - BottomSheet (1.6+)

    @Test @MainActor func bottomSheetProperties() {
        ensureAdwInit()
        guard let bs = BottomSheet() else { return }
        bs.modal = true
        #expect(bs.modal == true)
        bs.canClose = false
        #expect(bs.canClose == false)
        bs.canOpen = true
        #expect(bs.canOpen == true)
        bs.showDragHandle = true
        #expect(bs.showDragHandle == true)
        bs.fullWidth = true
        #expect(bs.fullWidth == true)
    }

    @Test @MainActor func bottomSheetAlignment() {
        ensureAdwInit()
        guard let bs = BottomSheet() else { return }
        bs.align = 0.0
        #expect(abs(bs.align - 0.0) < 0.01)
        bs.align = 1.0
        #expect(abs(bs.align - 1.0) < 0.01)
        bs.align = 0.5
        #expect(abs(bs.align - 0.5) < 0.01)
    }

    @Test @MainActor func bottomSheetContentAndSheet() {
        ensureAdwInit()
        guard let bs = BottomSheet() else { return }
        let content = Label("Main Content")
        let sheet = Label("Sheet Content")
        bs.content = content
        bs.sheet = sheet
        #expect(bs.content != nil)
        #expect(bs.sheet != nil)
    }

    @Test @MainActor func bottomSheetBottomBar() {
        ensureAdwInit()
        guard let bs = BottomSheet() else { return }
        let bar = Label("Bottom Bar")
        bs.bottomBar = bar
        #expect(bs.bottomBar != nil)
        #expect(bs.bottomBarHeight >= 0)
    }

    @Test @MainActor func bottomSheetOpenClose() {
        ensureAdwInit()
        guard let bs = BottomSheet() else { return }
        bs.open = false
        #expect(bs.open == false)
        #expect(bs.sheetHeight >= 0)
    }

    @Test @MainActor func bottomSheetCloseAttemptSignal() {
        ensureAdwInit()
        guard let bs = BottomSheet() else { return }
        var attempted = false
        let conn = bs.onCloseAttempt { attempted = true }
        // Signal connected without crash
        #expect(!attempted)
        conn.disconnect()
    }

    // MARK: - Spinner (1.6+)

    @Test @MainActor func spinnerCreation() {
        ensureAdwInit()
        guard let spinner = Spinner() else { return }
        #expect(spinner.visible == true)
    }

    // MARK: - SpinnerPaintable (1.6+)

    @Test @MainActor func spinnerPaintableCreation() {
        ensureAdwInit()
        let label = Label("Host")
        guard let paintable = SpinnerPaintable(widget: label) else { return }
        #expect(paintable.widget != nil)
    }

    @Test @MainActor func spinnerPaintableNilWidget() {
        ensureAdwInit()
        guard let paintable = SpinnerPaintable(widget: nil) else { return }
        #expect(paintable.widget == nil)
        let label = Label("New Host")
        paintable.widget = label
        #expect(paintable.widget != nil)
    }

    // MARK: - TabOverview

    @Test @MainActor func tabOverviewCreation() {
        ensureAdwInit()
        let overview = TabOverview()
        #expect(overview.open == false)
        #expect(overview.enableNewTab == false)
        #expect(overview.enableSearch == true)
    }

    @Test @MainActor func tabOverviewProperties() {
        ensureAdwInit()
        let overview = TabOverview()
        overview.enableNewTab = true
        #expect(overview.enableNewTab == true)
        overview.enableSearch = false
        #expect(overview.enableSearch == false)
        overview.inverted = true
        #expect(overview.inverted == true)
        overview.showStartTitleButtons = true
        #expect(overview.showStartTitleButtons == true)
        overview.showEndTitleButtons = false
        #expect(overview.showEndTitleButtons == false)
    }

    @Test @MainActor func tabOverviewWithTabView() {
        ensureAdwInit()
        let overview = TabOverview()
        let tabView = TabView()
        overview.view = tabView
        #expect(overview.view != nil)
        let content = Label("Content")
        overview.child = content
        #expect(overview.child != nil)
    }

    @Test @MainActor func tabOverviewCreateTabSignal() {
        ensureAdwInit()
        let overview = TabOverview()
        var created = false
        let conn = overview.onCreateTab { created = true }
        #expect(!created)
        conn.disconnect()
    }

    // MARK: - EnumListModel

    @Test @MainActor func enumListModelCreation() {
        ensureAdwInit()
        let colorSchemeType = adw_color_scheme_get_type()
        let model = EnumListModel(enumType: colorSchemeType)
        #expect(model.enumType == colorSchemeType)
    }

    @Test @MainActor func enumListModelFindPosition() {
        ensureAdwInit()
        let model = EnumListModel(enumType: adw_color_scheme_get_type())
        let pos = model.findPosition(0)
        #expect(pos >= 0, "Position of the first enum value should be non-negative")
    }

    // MARK: - WrapBox (1.7+)

    @Test @MainActor func wrapBoxProperties() {
        ensureAdwInit()
        guard let wrap = WrapBox() else { return }
        wrap.childSpacing = 8
        #expect(wrap.childSpacing == 8)
        wrap.lineSpacing = 12
        #expect(wrap.lineSpacing == 12)
        wrap.naturalLineLength = 300
        #expect(wrap.naturalLineLength == 300)
    }

    @Test @MainActor func wrapBoxAlignment() {
        ensureAdwInit()
        guard let wrap = WrapBox() else { return }
        wrap.align = 0.0
        #expect(abs(wrap.align - 0.0) < 0.01)
        wrap.align = 0.5
        #expect(abs(wrap.align - 0.5) < 0.01)
    }

    @Test @MainActor func wrapBoxJustify() {
        ensureAdwInit()
        guard let wrap = WrapBox() else { return }
        wrap.justify = ADW_JUSTIFY_FILL
        #expect(wrap.justify == ADW_JUSTIFY_FILL)
        wrap.justifyLastLine = true
        #expect(wrap.justifyLastLine == true)
    }

    @Test @MainActor func wrapBoxLineHomogeneous() {
        ensureAdwInit()
        guard let wrap = WrapBox() else { return }
        wrap.lineHomogeneous = true
        #expect(wrap.lineHomogeneous == true)
        wrap.lineHomogeneous = false
        #expect(wrap.lineHomogeneous == false)
    }

    @Test @MainActor func wrapBoxContainer() {
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

    @Test @MainActor func expanderRowProperties() {
        ensureAdwInit()
        let row = ExpanderRow()
        row.title = "Section"
        #expect(row.title == "Section")
        row.subtitle = "Details"
        #expect(row.subtitle == "Details")
        row.expanded = true
        #expect(row.expanded == true)
        row.showEnableSwitch = true
        #expect(row.showEnableSwitch == true)
        row.enableExpansion = false
        #expect(row.enableExpansion == false)
    }

    @Test @MainActor func expanderRowAddRemoveRows() {
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

    @Test @MainActor func comboRowWithStringList() {
        ensureAdwInit()
        let row = ComboRow()
        row.title = "Choose"
        let strings = StringList(["Apple", "Banana", "Cherry"])
        row.setModel(strings)
        #expect(row.title == "Choose")
        row.selected = 1
        #expect(row.selected == 1)
    }

    // MARK: - PasswordEntryRow

    @Test @MainActor func passwordEntryRowCreation() {
        ensureAdwInit()
        let row = PasswordEntryRow()
        row.title = "Password"
        #expect(row.title == "Password")
    }

    // MARK: - Drag and Drop

    @Test @MainActor func dragSourceTextContent() {
        ensureAdwInit()
        let drag = DragSource()
        drag.setTextContent("Hello Drag")
        let button = Button(label: "Drag Me")
        button.addController(drag)
        // Should not crash
    }

    @Test @MainActor func dropTargetForText() {
        ensureAdwInit()
        let drop = DropTarget.forText()
        var received: String?
        drop.onDrop { text in
            received = text
            return true
        }
        let label = Label("Drop Here")
        label.addController(drop)
        #expect(received == nil, "No drop has occurred yet")
    }

    @Test @MainActor func dragSourceOnWidget() {
        ensureAdwInit()
        let drag = DragSource()
        drag.setTextContent("Test")
        var began = false
        drag.onDragBegin { began = true }
        let label = Label("Source")
        label.addController(drag)
        #expect(!began, "Drag has not started yet")
    }

    // MARK: - Revealer

    @Test @MainActor func revealerTransitions() {
        ensureAdwInit()
        let revealer = Revealer()
        let content = Label("Hidden")
        revealer.child = content
        revealer.transitionType = .slideDown
        #expect(revealer.transitionType == .slideDown)
        revealer.revealChild = false
        #expect(revealer.revealChild == false)
        revealer.revealChild = true
        #expect(revealer.revealChild == true)
        revealer.transitionDuration = 500
        #expect(revealer.transitionDuration == 500)
    }

    // MARK: - Expander

    @Test @MainActor func expanderProperties() {
        ensureAdwInit()
        let expander = Expander(label: "Show Details")
        #expect(expander.label == "Show Details")
        expander.expanded = true
        #expect(expander.expanded == true)
        let content = Label("Details here")
        expander.child = content
        #expect(expander.child != nil)
    }

    // MARK: - FlowBox

    @Test @MainActor func flowBoxChildManagement() {
        ensureAdwInit()
        let flow = FlowBox()
        flow.selectionMode = .single
        flow.minChildrenPerLine = 2
        flow.maxChildrenPerLine = 5
        #expect(flow.minChildrenPerLine == 2)
        #expect(flow.maxChildrenPerLine == 5)
        let a = Label("A")
        let b = Label("B")
        flow.append(a)
        flow.append(b)
        flow.remove(a)
    }

    // MARK: - ListBox Selection

    @Test @MainActor func listBoxSelectionModes() {
        ensureAdwInit()
        let list = ListBox()
        list.selectionMode = .none
        #expect(list.selectionMode == .none)
        list.selectionMode = .single
        #expect(list.selectionMode == .single)
        list.selectionMode = .multiple
        #expect(list.selectionMode == .multiple)
    }

    @Test @MainActor func listBoxRowActivation() {
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
        #expect(activatedIndex == -1, "No row activated yet")
    }

    // MARK: - Image

    @Test @MainActor func imageIconName() {
        ensureAdwInit()
        let img = Image(iconName: "dialog-information-symbolic")
        img.pixelSize = 48
        #expect(img.pixelSize == 48)
    }

    @Test @MainActor func imageTypeSafeIcon() {
        ensureAdwInit()
        let img = Image(icon: .dialogInformation)
        #expect(img.iconName == IconName.dialogInformation.name)
    }

    // MARK: - Calendar

    @Test @MainActor func calendarDateProperties() {
        ensureAdwInit()
        let cal = Calendar()
        cal.year = 2025
        cal.month = 5
        cal.day = 15
        #expect(cal.year == 2025)
        #expect(cal.month == 5)
        #expect(cal.day == 15)
    }

    // MARK: - Adjustment

    @Test @MainActor func adjustmentConfigure() {
        ensureAdwInit()
        let adj = Adjustment()
        adj.configure(value: 50, lower: 0, upper: 100, stepIncrement: 1, pageIncrement: 10, pageSize: 0)
        #expect(abs(adj.value - 50) < 0.01)
        #expect(abs(adj.lower - 0) < 0.01)
        #expect(abs(adj.upper - 100) < 0.01)
    }

    @Test @MainActor func adjustmentClampValue() {
        ensureAdwInit()
        let adj = Adjustment()
        adj.configure(value: 0, lower: 0, upper: 100, stepIncrement: 1, pageIncrement: 10, pageSize: 0)
        adj.value = 150
        adj.clampPage(lower: 0, upper: 100)
        #expect(adj.value <= 100)
    }
}
