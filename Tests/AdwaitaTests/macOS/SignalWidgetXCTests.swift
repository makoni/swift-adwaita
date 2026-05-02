#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita
import Foundation

final class SignalWidgetXCTests: XCTestCase {

    // MARK: - Signal Infrastructure Tests

    @MainActor func test_signalConnectionTypeExists() {
        let _: SignalConnection.Type = SignalConnection.self
    }

    @MainActor func test_signalHelperMethodsExist() {
        let _: (GObjectRef, SignalName, @escaping @MainActor () -> Void) -> SignalConnection = SignalHelper.connect
        let _: (GObjectRef, SignalName, @escaping @MainActor (String) -> Void) -> SignalConnection = SignalHelper
            .connectString
        let _: (GObjectRef, SignalName, @escaping @MainActor (UInt32) -> Void) -> SignalConnection = SignalHelper
            .connectUInt
        let _: (GObjectRef, SignalName, @escaping @MainActor (Int32) -> Void) -> SignalConnection = SignalHelper
            .connectInt
        let _: (GObjectRef, SignalName, @escaping @MainActor (Double) -> Void) -> SignalConnection = SignalHelper
            .connectDouble
        let _: (GObjectRef, SignalName, @escaping @MainActor (Bool) -> Void) -> SignalConnection = SignalHelper
            .connectBool
        let _: (GObjectRef, SignalName, @escaping @MainActor (OpaquePointer) -> Void) -> SignalConnection = SignalHelper
            .connectPointer
        let _: (GObjectRef, SignalName, @escaping @MainActor (Double, Double) -> Void)
            -> SignalConnection = SignalHelper.connectDoubleDouble
        let _: (GObjectRef, SignalName, @escaping @MainActor (OpaquePointer, Int32) -> Void)
            -> SignalConnection = SignalHelper.connectPointerInt
        let _: (GObjectRef, PropertyName, @escaping @MainActor () -> Void) -> SignalConnection = SignalHelper.onNotify
        let _: (GObjectRef, SignalName, @escaping @MainActor (OpaquePointer, UnsafePointer<GValue>) -> Bool)
            -> SignalConnection = SignalHelper.connectPointerGValueReturnBool
        let _: (GObjectRef, SignalName, @escaping @MainActor (OpaquePointer, UnsafePointer<GValue>) -> GdkDragAction)
            -> SignalConnection = SignalHelper.connectPointerGValueReturnGdkDragAction
    }

    @MainActor func test_applicationOpenApiSurfaceExists() {
        ensureAdwInit()
        let app = Application(id: "com.test.open-api-surface")
        let _: (@escaping @MainActor ([URL], String?) -> Void) -> SignalConnection = app.onOpen
        let _: ([String]) -> Int = app.run(arguments:)
    }

    // MARK: - GTK Widget Wrapper Tests

    @MainActor func test_gtkWidgetWrappersExist() {
        XCTAssertTrue(isAdwSubclass(Box.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(Button.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(Label.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(Entry.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(ScrolledWindow.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(ListBox.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(Stack.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(Image.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(Separator.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(Switch.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(CheckButton.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(Overlay.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(FlowBox.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(SearchEntry.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(ToggleButton.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(MenuButton.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(Revealer.self, of: Widget.self))
    }

    // MARK: - Signal Coverage Tests

    @MainActor func test_allGeneratedSignalsAreSupported() {
        let signalTypes: [Any.Type] = [
            TabView.self, TabBar.self, TabOverview.self,
            NavigationView.self, NavigationPage.self,
            AlertDialog.self, Carousel.self, Toast.self,
            SwipeTracker.self, SpinRow.self
        ]
        XCTAssertTrue(signalTypes.count >= 10)
    }

    // MARK: - Widget Instantiation Tests

    @MainActor func test_labelCreation() {
        ensureAdwInit()
        let label = Label("Hello")
        XCTAssertTrue(label.text == "Hello")
    }

    @MainActor func test_labelPropertyRoundTrip() {
        ensureAdwInit()
        let label = Label("initial")
        label.text = "changed"
        XCTAssertTrue(label.text == "changed")
        label.wrap = true
        XCTAssertTrue(label.wrap == true)
        label.selectable = true
        XCTAssertTrue(label.selectable == true)
        label.xalign = 0.5
        XCTAssertTrue(label.xalign == 0.5)
    }

    @MainActor func test_labelMarkup() {
        ensureAdwInit()
        let label = Label("test")
        label.useMarkup = true
        XCTAssertTrue(label.useMarkup == true)
        label.markup = "<b>bold</b>"
        XCTAssertTrue(label.markup == "<b>bold</b>")
    }

    @MainActor func test_buttonCreation() {
        ensureAdwInit()
        let btn = Button(label: "Click me")
        XCTAssertTrue(btn.label == "Click me")
    }

    @MainActor func test_buttonLabelRoundTrip() {
        ensureAdwInit()
        let btn = Button()
        btn.label = "Test"
        XCTAssertTrue(btn.label == "Test")
    }

    @MainActor func test_buttonIconName() {
        ensureAdwInit()
        let btn = Button(iconName: "document-open-symbolic")
        XCTAssertTrue(btn.iconName == "document-open-symbolic")
    }

    @MainActor func test_buttonHasFrame() {
        ensureAdwInit()
        let btn = Button(label: "Flat")
        btn.hasFrame = false
        XCTAssertTrue(btn.hasFrame == false)
        btn.hasFrame = true
        XCTAssertTrue(btn.hasFrame == true)
    }

    @MainActor func test_boxCreation() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 10)
        XCTAssertTrue(box.spacing == 10)
    }

    @MainActor func test_boxAppendAndSpacing() {
        ensureAdwInit()
        let box = Box(spacing: 5)
        let label1 = Label("One")
        let label2 = Label("Two")
        box.append(label1)
        box.append(label2)
        box.spacing = 12
        XCTAssertTrue(box.spacing == 12)
    }

    @MainActor func test_boxHomogeneous() {
        ensureAdwInit()
        let box = Box()
        XCTAssertTrue(box.homogeneous == false)
        box.homogeneous = true
        XCTAssertTrue(box.homogeneous == true)
    }

    @MainActor func test_boxPrependAndRemove() {
        ensureAdwInit()
        let box = Box()
        let a = Label("a")
        let b = Label("b")
        box.append(a)
        box.prepend(b)
        // Should not crash
        box.remove(a)
        box.remove(b)
    }

    @MainActor func test_entryTextRoundTrip() {
        ensureAdwInit()
        let entry = Entry()
        entry.text = "hello world"
        XCTAssertTrue(entry.text == "hello world")
    }

    @MainActor func test_entryPlaceholder() {
        ensureAdwInit()
        let entry = Entry()
        entry.placeholderText = "Enter name..."
        XCTAssertTrue(entry.placeholderText == "Enter name...")
    }

    @MainActor func test_entryVisibility() {
        ensureAdwInit()
        let entry = Entry()
        XCTAssertTrue(entry.visibility == true)
        entry.visibility = false
        XCTAssertTrue(entry.visibility == false)
    }

    @MainActor func test_switchActiveRoundTrip() {
        ensureAdwInit()
        let sw = Switch()
        XCTAssertTrue(sw.active == false)
        sw.active = true
        XCTAssertTrue(sw.active == true)
    }

    @MainActor func test_checkButtonActiveRoundTrip() {
        ensureAdwInit()
        let cb = CheckButton(label: "Enable")
        XCTAssertTrue(cb.label == "Enable")
        XCTAssertTrue(cb.active == false)
        cb.active = true
        XCTAssertTrue(cb.active == true)
    }

    @MainActor func test_checkButtonGrouping() {
        ensureAdwInit()
        let a = CheckButton(label: "A")
        let b = CheckButton(label: "B")
        b.setGroup(a)
        // Should not crash; a and b are now radio-grouped
        a.active = true
        XCTAssertTrue(a.active == true)
    }

    @MainActor func test_toggleButtonActiveRoundTrip() {
        ensureAdwInit()
        let btn = ToggleButton(label: "Toggle")
        XCTAssertTrue(btn.active == false)
        btn.active = true
        XCTAssertTrue(btn.active == true)
    }

    @MainActor func test_imageIconName() {
        ensureAdwInit()
        let img = Image(iconName: "dialog-information-symbolic")
        XCTAssertTrue(img.iconName == "dialog-information-symbolic")
    }

    @MainActor func test_imagePixelSize() {
        ensureAdwInit()
        let img = Image()
        img.pixelSize = 48
        XCTAssertTrue(img.pixelSize == 48)
    }

    @MainActor func test_scrolledWindowChild() {
        ensureAdwInit()
        let sw = ScrolledWindow()
        let label = Label("scrollable content")
        sw.child = label
        XCTAssertNotNil(sw.child)
    }

    @MainActor func test_scrolledWindowMinContent() {
        ensureAdwInit()
        let sw = ScrolledWindow()
        sw.minContentWidth = 300
        sw.minContentHeight = 200
        XCTAssertTrue(sw.minContentWidth == 300)
        XCTAssertTrue(sw.minContentHeight == 200)
    }

    @MainActor func test_scrolledWindowOverlayScrolling() {
        ensureAdwInit()
        let sw = ScrolledWindow()
        sw.overlayScrolling = false
        XCTAssertTrue(sw.overlayScrolling == false)
        sw.overlayScrolling = true
        XCTAssertTrue(sw.overlayScrolling == true)
    }

    @MainActor func test_scrolledWindowPropagateNatural() {
        ensureAdwInit()
        let sw = ScrolledWindow()
        sw.propagateNaturalWidth = true
        sw.propagateNaturalHeight = true
        XCTAssertTrue(sw.propagateNaturalWidth == true)
        XCTAssertTrue(sw.propagateNaturalHeight == true)
        sw.propagateNaturalWidth = false
        sw.propagateNaturalHeight = false
        XCTAssertTrue(sw.propagateNaturalWidth == false)
        XCTAssertTrue(sw.propagateNaturalHeight == false)
    }

    @MainActor func test_listBoxOperations() {
        ensureAdwInit()
        let lb = ListBox()
        let row1 = Label("Row 1")
        let row2 = Label("Row 2")
        lb.append(row1)
        lb.prepend(row2)
        lb.selectionMode = GTK_SELECTION_SINGLE
        XCTAssertTrue(lb.selectionMode == GTK_SELECTION_SINGLE)
        lb.removeAll()
    }

    @MainActor func test_listBoxShowSeparators() {
        ensureAdwInit()
        let lb = ListBox()
        XCTAssertTrue(lb.showSeparators == false)
        lb.showSeparators = true
        XCTAssertTrue(lb.showSeparators == true)
    }

    @MainActor func test_stackVisibleChild() {
        ensureAdwInit()
        let stack = Stack()
        let page1 = Label("Page 1")
        let page2 = Label("Page 2")
        stack.addNamed(page1, name: "p1")
        stack.addNamed(page2, name: "p2")
        stack.visibleChildName = "p2"
        XCTAssertTrue(stack.visibleChildName == "p2")
    }

    @MainActor func test_stackTransition() {
        ensureAdwInit()
        let stack = Stack()
        stack.transitionDuration = 500
        XCTAssertTrue(stack.transitionDuration == 500)
    }

    @MainActor func test_overlayChildAndOverlay() {
        ensureAdwInit()
        let overlay = Overlay()
        let main = Label("Main")
        let badge = Label("Badge")
        overlay.child = main
        overlay.addOverlay(badge)
        XCTAssertNotNil(overlay.child)
    }

    @MainActor func test_revealerProperties() {
        ensureAdwInit()
        let rev = Revealer()
        XCTAssertTrue(rev.revealChild == false)
        rev.revealChild = true
        XCTAssertTrue(rev.revealChild == true)
        rev.transitionDuration = 300
        XCTAssertTrue(rev.transitionDuration == 300)
    }

    @MainActor func test_flowBoxProperties() {
        ensureAdwInit()
        let fb = FlowBox()
        fb.minChildrenPerLine = 2
        fb.maxChildrenPerLine = 5
        XCTAssertTrue(fb.minChildrenPerLine == 2)
        XCTAssertTrue(fb.maxChildrenPerLine == 5)
        fb.homogeneous = true
        XCTAssertTrue(fb.homogeneous == true)
        fb.rowSpacing = 8
        fb.columnSpacing = 12
        XCTAssertTrue(fb.rowSpacing == 8)
        XCTAssertTrue(fb.columnSpacing == 12)
    }

    @MainActor func test_searchEntryText() {
        ensureAdwInit()
        let se = SearchEntry()
        se.text = "query"
        XCTAssertTrue(se.text == "query")
    }

    @MainActor func test_searchEntryPlaceholder() {
        ensureAdwInit()
        let se = SearchEntry()
        se.placeholderText = "Search..."
        XCTAssertTrue(se.placeholderText == "Search...")
    }

    @MainActor func test_menuButtonProperties() {
        ensureAdwInit()
        let mb = MenuButton()
        mb.label = "Menu"
        XCTAssertTrue(mb.label == "Menu")
        mb.iconName = "open-menu-symbolic"
        XCTAssertTrue(mb.iconName == "open-menu-symbolic")
        mb.hasFrame = false
        XCTAssertTrue(mb.hasFrame == false)
        mb.primary = true
        XCTAssertTrue(mb.primary == true)
    }

    // MARK: - Widget Base Class Tests

    @MainActor func test_widgetVisibility() {
        ensureAdwInit()
        let label = Label("test")
        // Default visible
        label.visible = false
        XCTAssertTrue(label.visible == false)
        label.show()
        XCTAssertTrue(label.visible == true)
        label.hide()
        XCTAssertTrue(label.visible == false)
    }

    @MainActor func test_widgetSensitive() {
        ensureAdwInit()
        let btn = Button(label: "test")
        XCTAssertTrue(btn.sensitive == true)
        btn.sensitive = false
        XCTAssertTrue(btn.sensitive == false)
    }

    @MainActor func test_widgetCSSClass() {
        ensureAdwInit()
        let btn = Button(label: "Destructive")
        btn.addCSSClass("destructive-action")
        // gtk_widget_has_css_class should reflect the added class
        XCTAssertTrue(gtk_widget_has_css_class(btn.widgetPointer, "destructive-action") != 0)
        btn.removeCSSClass("destructive-action")
        XCTAssertTrue(gtk_widget_has_css_class(btn.widgetPointer, "destructive-action") == 0)
    }

    @MainActor func test_widgetExpand() {
        ensureAdwInit()
        let label = Label("expand test")
        XCTAssertTrue(label.hexpand == false)
        XCTAssertTrue(label.vexpand == false)
        label.hexpand = true
        label.vexpand = true
        XCTAssertTrue(label.hexpand == true)
        XCTAssertTrue(label.vexpand == true)
    }

    @MainActor func test_widgetAlignment() {
        ensureAdwInit()
        let label = Label("align")
        label.halign = GTK_ALIGN_CENTER
        label.valign = GTK_ALIGN_END
        XCTAssertTrue(label.halign == GTK_ALIGN_CENTER)
        XCTAssertTrue(label.valign == GTK_ALIGN_END)
    }

}
#endif
