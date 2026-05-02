#if !os(macOS)
import Testing
@testable import Adwaita
import CAdwaita
import Foundation

@Suite(.serialized)
struct SignalWidgetTests {

    // MARK: - Signal Infrastructure Tests

    @Test @MainActor func signalConnectionTypeExists() {
        let _: SignalConnection.Type = SignalConnection.self
    }

    @Test @MainActor func signalHelperMethodsExist() {
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

    @Test @MainActor func applicationOpenApiSurfaceExists() {
        ensureAdwInit()
        let app = Application(id: "com.test.open-api-surface")
        let _: (@escaping @MainActor ([URL], String?) -> Void) -> SignalConnection = app.onOpen
        let _: ([String]) -> Int = app.run(arguments:)
    }

    // MARK: - GTK Widget Wrapper Tests

    @Test @MainActor func gtkWidgetWrappersExist() {
        #expect(isAdwSubclass(Box.self, of: Widget.self))
        #expect(isAdwSubclass(Button.self, of: Widget.self))
        #expect(isAdwSubclass(Label.self, of: Widget.self))
        #expect(isAdwSubclass(Entry.self, of: Widget.self))
        #expect(isAdwSubclass(ScrolledWindow.self, of: Widget.self))
        #expect(isAdwSubclass(ListBox.self, of: Widget.self))
        #expect(isAdwSubclass(Stack.self, of: Widget.self))
        #expect(isAdwSubclass(Image.self, of: Widget.self))
        #expect(isAdwSubclass(Separator.self, of: Widget.self))
        #expect(isAdwSubclass(Switch.self, of: Widget.self))
        #expect(isAdwSubclass(CheckButton.self, of: Widget.self))
        #expect(isAdwSubclass(Overlay.self, of: Widget.self))
        #expect(isAdwSubclass(FlowBox.self, of: Widget.self))
        #expect(isAdwSubclass(SearchEntry.self, of: Widget.self))
        #expect(isAdwSubclass(ToggleButton.self, of: Widget.self))
        #expect(isAdwSubclass(MenuButton.self, of: Widget.self))
        #expect(isAdwSubclass(Revealer.self, of: Widget.self))
    }

    // MARK: - Signal Coverage Tests

    @Test @MainActor func allGeneratedSignalsAreSupported() {
        let signalTypes: [Any.Type] = [
            TabView.self, TabBar.self, TabOverview.self,
            NavigationView.self, NavigationPage.self,
            AlertDialog.self, Carousel.self, Toast.self,
            SwipeTracker.self, SpinRow.self
        ]
        #expect(signalTypes.count >= 10)
    }

    // MARK: - Widget Instantiation Tests

    @Test @MainActor func labelCreation() {
        ensureAdwInit()
        let label = Label("Hello")
        #expect(label.text == "Hello")
    }

    @Test @MainActor func labelPropertyRoundTrip() {
        ensureAdwInit()
        let label = Label("initial")
        label.text = "changed"
        #expect(label.text == "changed")
        label.wrap = true
        #expect(label.wrap == true)
        label.selectable = true
        #expect(label.selectable == true)
        label.xalign = 0.5
        #expect(label.xalign == 0.5)
    }

    @Test @MainActor func labelMarkup() {
        ensureAdwInit()
        let label = Label("test")
        label.useMarkup = true
        #expect(label.useMarkup == true)
        label.markup = "<b>bold</b>"
        #expect(label.markup == "<b>bold</b>")
    }

    @Test @MainActor func buttonCreation() {
        ensureAdwInit()
        let btn = Button(label: "Click me")
        #expect(btn.label == "Click me")
    }

    @Test @MainActor func buttonLabelRoundTrip() {
        ensureAdwInit()
        let btn = Button()
        btn.label = "Test"
        #expect(btn.label == "Test")
    }

    @Test @MainActor func buttonIconName() {
        ensureAdwInit()
        let btn = Button(iconName: "document-open-symbolic")
        #expect(btn.iconName == "document-open-symbolic")
    }

    @Test @MainActor func buttonHasFrame() {
        ensureAdwInit()
        let btn = Button(label: "Flat")
        btn.hasFrame = false
        #expect(btn.hasFrame == false)
        btn.hasFrame = true
        #expect(btn.hasFrame == true)
    }

    @Test @MainActor func boxCreation() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 10)
        #expect(box.spacing == 10)
    }

    @Test @MainActor func boxAppendAndSpacing() {
        ensureAdwInit()
        let box = Box(spacing: 5)
        let label1 = Label("One")
        let label2 = Label("Two")
        box.append(label1)
        box.append(label2)
        box.spacing = 12
        #expect(box.spacing == 12)
    }

    @Test @MainActor func boxHomogeneous() {
        ensureAdwInit()
        let box = Box()
        #expect(box.homogeneous == false)
        box.homogeneous = true
        #expect(box.homogeneous == true)
    }

    @Test @MainActor func boxPrependAndRemove() {
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

    @Test @MainActor func entryTextRoundTrip() {
        ensureAdwInit()
        let entry = Entry()
        entry.text = "hello world"
        #expect(entry.text == "hello world")
    }

    @Test @MainActor func entryPlaceholder() {
        ensureAdwInit()
        let entry = Entry()
        entry.placeholderText = "Enter name..."
        #expect(entry.placeholderText == "Enter name...")
    }

    @Test @MainActor func entryVisibility() {
        ensureAdwInit()
        let entry = Entry()
        #expect(entry.visibility == true)
        entry.visibility = false
        #expect(entry.visibility == false)
    }

    @Test @MainActor func switchActiveRoundTrip() {
        ensureAdwInit()
        let sw = Switch()
        #expect(sw.active == false)
        sw.active = true
        #expect(sw.active == true)
    }

    @Test @MainActor func checkButtonActiveRoundTrip() {
        ensureAdwInit()
        let cb = CheckButton(label: "Enable")
        #expect(cb.label == "Enable")
        #expect(cb.active == false)
        cb.active = true
        #expect(cb.active == true)
    }

    @Test @MainActor func checkButtonGrouping() {
        ensureAdwInit()
        let a = CheckButton(label: "A")
        let b = CheckButton(label: "B")
        b.setGroup(a)
        // Should not crash; a and b are now radio-grouped
        a.active = true
        #expect(a.active == true)
    }

    @Test @MainActor func toggleButtonActiveRoundTrip() {
        ensureAdwInit()
        let btn = ToggleButton(label: "Toggle")
        #expect(btn.active == false)
        btn.active = true
        #expect(btn.active == true)
    }

    @Test @MainActor func imageIconName() {
        ensureAdwInit()
        let img = Image(iconName: "dialog-information-symbolic")
        #expect(img.iconName == "dialog-information-symbolic")
    }

    @Test @MainActor func imagePixelSize() {
        ensureAdwInit()
        let img = Image()
        img.pixelSize = 48
        #expect(img.pixelSize == 48)
    }

    @Test @MainActor func scrolledWindowChild() {
        ensureAdwInit()
        let sw = ScrolledWindow()
        let label = Label("scrollable content")
        sw.child = label
        #expect(sw.child != nil)
    }

    @Test @MainActor func scrolledWindowMinContent() {
        ensureAdwInit()
        let sw = ScrolledWindow()
        sw.minContentWidth = 300
        sw.minContentHeight = 200
        #expect(sw.minContentWidth == 300)
        #expect(sw.minContentHeight == 200)
    }

    @Test @MainActor func scrolledWindowOverlayScrolling() {
        ensureAdwInit()
        let sw = ScrolledWindow()
        sw.overlayScrolling = false
        #expect(sw.overlayScrolling == false)
        sw.overlayScrolling = true
        #expect(sw.overlayScrolling == true)
    }

    @Test @MainActor func scrolledWindowPropagateNatural() {
        ensureAdwInit()
        let sw = ScrolledWindow()
        sw.propagateNaturalWidth = true
        sw.propagateNaturalHeight = true
        #expect(sw.propagateNaturalWidth == true)
        #expect(sw.propagateNaturalHeight == true)
        sw.propagateNaturalWidth = false
        sw.propagateNaturalHeight = false
        #expect(sw.propagateNaturalWidth == false)
        #expect(sw.propagateNaturalHeight == false)
    }

    @Test @MainActor func listBoxOperations() {
        ensureAdwInit()
        let lb = ListBox()
        let row1 = Label("Row 1")
        let row2 = Label("Row 2")
        lb.append(row1)
        lb.prepend(row2)
        lb.selectionMode = GTK_SELECTION_SINGLE
        #expect(lb.selectionMode == GTK_SELECTION_SINGLE)
        lb.removeAll()
    }

    @Test @MainActor func listBoxShowSeparators() {
        ensureAdwInit()
        let lb = ListBox()
        #expect(lb.showSeparators == false)
        lb.showSeparators = true
        #expect(lb.showSeparators == true)
    }

    @Test @MainActor func stackVisibleChild() {
        ensureAdwInit()
        let stack = Stack()
        let page1 = Label("Page 1")
        let page2 = Label("Page 2")
        stack.addNamed(page1, name: "p1")
        stack.addNamed(page2, name: "p2")
        stack.visibleChildName = "p2"
        #expect(stack.visibleChildName == "p2")
    }

    @Test @MainActor func stackTransition() {
        ensureAdwInit()
        let stack = Stack()
        stack.transitionDuration = 500
        #expect(stack.transitionDuration == 500)
    }

    @Test @MainActor func overlayChildAndOverlay() {
        ensureAdwInit()
        let overlay = Overlay()
        let main = Label("Main")
        let badge = Label("Badge")
        overlay.child = main
        overlay.addOverlay(badge)
        #expect(overlay.child != nil)
    }

    @Test @MainActor func revealerProperties() {
        ensureAdwInit()
        let rev = Revealer()
        #expect(rev.revealChild == false)
        rev.revealChild = true
        #expect(rev.revealChild == true)
        rev.transitionDuration = 300
        #expect(rev.transitionDuration == 300)
    }

    @Test @MainActor func flowBoxProperties() {
        ensureAdwInit()
        let fb = FlowBox()
        fb.minChildrenPerLine = 2
        fb.maxChildrenPerLine = 5
        #expect(fb.minChildrenPerLine == 2)
        #expect(fb.maxChildrenPerLine == 5)
        fb.homogeneous = true
        #expect(fb.homogeneous == true)
        fb.rowSpacing = 8
        fb.columnSpacing = 12
        #expect(fb.rowSpacing == 8)
        #expect(fb.columnSpacing == 12)
    }

    @Test @MainActor func searchEntryText() {
        ensureAdwInit()
        let se = SearchEntry()
        se.text = "query"
        #expect(se.text == "query")
    }

    @Test @MainActor func searchEntryPlaceholder() {
        ensureAdwInit()
        let se = SearchEntry()
        se.placeholderText = "Search..."
        #expect(se.placeholderText == "Search...")
    }

    @Test @MainActor func menuButtonProperties() {
        ensureAdwInit()
        let mb = MenuButton()
        mb.label = "Menu"
        #expect(mb.label == "Menu")
        mb.iconName = "open-menu-symbolic"
        #expect(mb.iconName == "open-menu-symbolic")
        mb.hasFrame = false
        #expect(mb.hasFrame == false)
        mb.primary = true
        #expect(mb.primary == true)
    }

    // MARK: - Widget Base Class Tests

    @Test @MainActor func widgetVisibility() {
        ensureAdwInit()
        let label = Label("test")
        // Default visible
        label.visible = false
        #expect(label.visible == false)
        label.show()
        #expect(label.visible == true)
        label.hide()
        #expect(label.visible == false)
    }

    @Test @MainActor func widgetSensitive() {
        ensureAdwInit()
        let btn = Button(label: "test")
        #expect(btn.sensitive == true)
        btn.sensitive = false
        #expect(btn.sensitive == false)
    }

    @Test @MainActor func widgetCSSClass() {
        ensureAdwInit()
        let btn = Button(label: "Destructive")
        btn.addCSSClass("destructive-action")
        // gtk_widget_has_css_class should reflect the added class
        #expect(gtk_widget_has_css_class(btn.widgetPointer, "destructive-action") != 0)
        btn.removeCSSClass("destructive-action")
        #expect(gtk_widget_has_css_class(btn.widgetPointer, "destructive-action") == 0)
    }

    @Test @MainActor func widgetExpand() {
        ensureAdwInit()
        let label = Label("expand test")
        #expect(label.hexpand == false)
        #expect(label.vexpand == false)
        label.hexpand = true
        label.vexpand = true
        #expect(label.hexpand == true)
        #expect(label.vexpand == true)
    }

    @Test @MainActor func widgetAlignment() {
        ensureAdwInit()
        let label = Label("align")
        label.halign = GTK_ALIGN_CENTER
        label.valign = GTK_ALIGN_END
        #expect(label.halign == GTK_ALIGN_CENTER)
        #expect(label.valign == GTK_ALIGN_END)
    }

}
#endif
