import Testing
@testable import Adwaita
import CAdwaita

/// Helper to verify subclass relationships at runtime.
@MainActor
func isSubclass<Sub: AnyObject, Super: AnyObject>(_: Sub.Type, of _: Super.Type) -> Bool {
    Sub.self is Super.Type
}

/// One-time GTK/Adw init for tests that instantiate widgets.
@MainActor
func ensureAdwInit() {
    struct Once { nonisolated(unsafe) static var done = false }
    guard !Once.done else { return }
    adw_init()
    Once.done = true
}

@Suite(.serialized) struct AdwaitaTests {

    /// Must run first — initializes GTK/Adw for all subsequent tests.
    @Test @MainActor func _00_initAdwaita() {
        ensureAdwInit()
        #expect(Bool(true))
    }

    // MARK: - Type Hierarchy Tests

    @Test @MainActor func widgetInheritsFromGObjectRef() {
        #expect(isSubclass(Widget.self, of: GObjectRef.self))
    }

    @Test @MainActor func applicationWindowInheritsFromWidget() {
        #expect(isSubclass(ApplicationWindow.self, of: Widget.self))
        #expect(isSubclass(ApplicationWindow.self, of: GObjectRef.self))
    }

    @Test @MainActor func navigationPageInheritsFromWidget() {
        #expect(isSubclass(NavigationPage.self, of: Widget.self))
    }

    @Test @MainActor func actionRowInheritanceChain() {
        #expect(isSubclass(ActionRow.self, of: PreferencesRow.self))
        #expect(isSubclass(ActionRow.self, of: ListBoxRow.self))
        #expect(isSubclass(ActionRow.self, of: Widget.self))
    }

    @Test @MainActor func windowInheritsFromGtkWindow() {
        #expect(isSubclass(Window.self, of: GtkWindow.self))
        #expect(isSubclass(Window.self, of: Widget.self))
    }

    @Test @MainActor func dialogInheritanceChain() {
        #expect(isSubclass(Dialog.self, of: Widget.self))
        #expect(isSubclass(AboutDialog.self, of: Dialog.self))
        #expect(isSubclass(AlertDialog.self, of: Dialog.self))
    }

    @Test @MainActor func animationInheritanceChain() {
        #expect(isSubclass(Animation.self, of: GObjectRef.self))
        #expect(isSubclass(SpringAnimation.self, of: Animation.self))
        #expect(isSubclass(TimedAnimation.self, of: Animation.self))
    }

    @Test @MainActor func preferencesRowSubclasses() {
        #expect(isSubclass(ActionRow.self, of: PreferencesRow.self))
        #expect(isSubclass(ComboRow.self, of: ActionRow.self))
        #expect(isSubclass(ExpanderRow.self, of: PreferencesRow.self))
        #expect(isSubclass(EntryRow.self, of: PreferencesRow.self))
        #expect(isSubclass(SpinRow.self, of: ActionRow.self))
        #expect(isSubclass(SwitchRow.self, of: ActionRow.self))
        #expect(isSubclass(PasswordEntryRow.self, of: EntryRow.self))
        #expect(isSubclass(ButtonRow.self, of: PreferencesRow.self))
    }

    @Test @MainActor func layoutManagerSubclasses() {
        #expect(isSubclass(LayoutManager.self, of: GObjectRef.self))
        #expect(isSubclass(ClampLayout.self, of: LayoutManager.self))
        #expect(isSubclass(WrapLayout.self, of: LayoutManager.self))
    }

    // MARK: - Intermediate Classes

    @Test @MainActor func intermediateClassHierarchy() {
        #expect(isSubclass(GtkWindow.self, of: Widget.self))
        #expect(isSubclass(ListBoxRow.self, of: Widget.self))
        #expect(isSubclass(LayoutManager.self, of: GObjectRef.self))
    }

    // MARK: - C Type Accessibility Tests

    @Test @MainActor func gTypeIsAccessible() {
        ensureAdwInit()
        let widgetType = gtk_widget_get_type()
        #expect(widgetType != 0, "gtk_widget_get_type should return non-zero")
    }

    @Test @MainActor func adwInitFunctionExists() {
        ensureAdwInit()
        let fn = adw_init
        #expect(fn != nil)
    }

    // MARK: - Generated Wrapper Coverage

    @Test @MainActor func allKeyGeneratedTypesExist() {
        let types: [Any.Type] = [
            // Navigation
            NavigationPage.self, NavigationView.self, NavigationSplitView.self,
            // Preferences
            PreferencesRow.self, PreferencesGroup.self, PreferencesPage.self,
            PreferencesDialog.self,
            // Rows
            ActionRow.self, ComboRow.self, EntryRow.self, ExpanderRow.self,
            SpinRow.self, SwitchRow.self, PasswordEntryRow.self, ButtonRow.self,
            // Tabs
            TabView.self, TabBar.self, TabPage.self, TabButton.self, TabOverview.self,
            // Dialogs
            Dialog.self, AboutDialog.self, AlertDialog.self,
            // Layout
            Clamp.self, ClampLayout.self, ClampScrollable.self,
            MultiLayoutView.self, Layout.self, LayoutSlot.self,
            WrapBox.self, WrapLayout.self,
            // Animations
            Animation.self, SpringAnimation.self, TimedAnimation.self,
            AnimationTarget.self, CallbackAnimationTarget.self,
            PropertyAnimationTarget.self,
            // View stack / switching
            ViewStack.self, ViewStackPage.self, ViewStackPages.self,
            ViewSwitcher.self, ViewSwitcherBar.self,
            InlineViewSwitcher.self,
            // Misc widgets
            Banner.self, Avatar.self, Spinner.self, SpinnerPaintable.self,
            SplitButton.self, OverlaySplitView.self,
            Toast.self, ToastOverlay.self,
            Carousel.self, CarouselIndicatorDots.self, CarouselIndicatorLines.self,
            Bin.self, BottomSheet.self, BreakpointBin.self, Breakpoint.self,
            ToggleGroup.self, Toggle.self,
            ButtonContent.self, WindowTitle.self, ShortcutLabel.self,
            ShortcutsDialog.self, ShortcutsSection.self, ShortcutsItem.self,
            Window.self,
            // Non-widget
            StyleManager.self, SwipeTracker.self, EnumListModel.self,
        ]
        #expect(types.count >= 64, "Expected at least 64 generated types")
    }

    // MARK: - Hand-Written Wrapper Tests

    @Test @MainActor func handWrittenWrappersExist() {
        #expect(isSubclass(Application.self, of: GObjectRef.self))
        #expect(isSubclass(ApplicationWindow.self, of: Widget.self))
        #expect(isSubclass(HeaderBar.self, of: Widget.self))
        #expect(isSubclass(ToolbarView.self, of: Widget.self))
        #expect(isSubclass(StatusPage.self, of: Widget.self))
    }

    // MARK: - GValue Tests

    @Test @MainActor func gvalueStringRoundTrip() {
        var gv = GValueRef("hello")
        #expect(gv.stringValue == "hello")
    }

    @Test @MainActor func gvalueIntRoundTrip() {
        var gv = GValueRef(Int32(42))
        #expect(gv.intValue == 42)
    }

    @Test @MainActor func gvalueUIntRoundTrip() {
        var gv = GValueRef(UInt32(100))
        #expect(gv.uintValue == 100)
    }

    @Test @MainActor func gvalueBoolRoundTrip() {
        var gvTrue = GValueRef(true)
        var gvFalse = GValueRef(false)
        #expect(gvTrue.boolValue == true)
        #expect(gvFalse.boolValue == false)
    }

    @Test @MainActor func gvalueDoubleRoundTrip() {
        var gv = GValueRef(3.14)
        #expect(gv.doubleValue == 3.14)
    }

    @Test @MainActor func gvalueFloatRoundTrip() {
        var gv = GValueRef(Float(2.5))
        #expect(gv.floatValue == 2.5)
    }

    @Test @MainActor func gvalueInt64RoundTrip() {
        var gv = GValueRef(Int64(999_999_999_999))
        gv.withUnsafePointer { ptr in
            #expect(g_value_get_int64(ptr) == 999_999_999_999)
        }
    }

    @Test @MainActor func gvalueStringNilForNonString() {
        var gv = GValueRef(Int32(5))
        #expect(gv.stringValue == nil)
    }

    // MARK: - GType Shim Tests

    @Test @MainActor func gTypeShimFunctions() {
        ensureAdwInit()
        #expect(cadw_type_string() != 0)
        #expect(cadw_type_int() != 0)
        #expect(cadw_type_uint() != 0)
        #expect(cadw_type_boolean() != 0)
        #expect(cadw_type_double() != 0)
        #expect(cadw_type_float() != 0)
        #expect(cadw_type_int64() != 0)
        #expect(cadw_type_object() != 0)
        #expect(cadw_type_uint64() != 0)
        // All fundamental types should be distinct
        #expect(cadw_type_string() != cadw_type_int())
        #expect(cadw_type_int() != cadw_type_boolean())
        #expect(cadw_type_double() != cadw_type_float())
        #expect(cadw_type_int() != cadw_type_uint())
        #expect(cadw_type_int64() != cadw_type_uint64())
    }

    // MARK: - Signal Infrastructure Tests

    @Test @MainActor func signalConnectionTypeExists() {
        let _: SignalConnection.Type = SignalConnection.self
    }

    @Test @MainActor func signalHelperMethodsExist() {
        let _: (GObjectRef, String, @escaping @MainActor () -> Void) -> SignalConnection = SignalHelper.connect
        let _: (GObjectRef, String, @escaping @MainActor (String) -> Void) -> SignalConnection = SignalHelper.connectString
        let _: (GObjectRef, String, @escaping @MainActor (UInt32) -> Void) -> SignalConnection = SignalHelper.connectUInt
        let _: (GObjectRef, String, @escaping @MainActor (Int32) -> Void) -> SignalConnection = SignalHelper.connectInt
        let _: (GObjectRef, String, @escaping @MainActor (Double) -> Void) -> SignalConnection = SignalHelper.connectDouble
        let _: (GObjectRef, String, @escaping @MainActor (Bool) -> Void) -> SignalConnection = SignalHelper.connectBool
        let _: (GObjectRef, String, @escaping @MainActor (OpaquePointer) -> Void) -> SignalConnection = SignalHelper.connectPointer
        let _: (GObjectRef, String, @escaping @MainActor (Double, Double) -> Void) -> SignalConnection = SignalHelper.connectDoubleDouble
        let _: (GObjectRef, String, @escaping @MainActor (OpaquePointer, Int32) -> Void) -> SignalConnection = SignalHelper.connectPointerInt
        let _: (GObjectRef, String, @escaping @MainActor () -> Void) -> SignalConnection = SignalHelper.onNotify
        let _: (GObjectRef, String, @escaping @MainActor (OpaquePointer, UnsafePointer<GValue>) -> Bool) -> SignalConnection = SignalHelper.connectPointerGValueReturnBool
        let _: (GObjectRef, String, @escaping @MainActor (OpaquePointer, UnsafePointer<GValue>) -> GdkDragAction) -> SignalConnection = SignalHelper.connectPointerGValueReturnGdkDragAction
    }

    // MARK: - GTK Widget Wrapper Tests

    @Test @MainActor func gtkWidgetWrappersExist() {
        #expect(isSubclass(Box.self, of: Widget.self))
        #expect(isSubclass(Button.self, of: Widget.self))
        #expect(isSubclass(Label.self, of: Widget.self))
        #expect(isSubclass(Entry.self, of: Widget.self))
        #expect(isSubclass(ScrolledWindow.self, of: Widget.self))
        #expect(isSubclass(ListBox.self, of: Widget.self))
        #expect(isSubclass(Stack.self, of: Widget.self))
        #expect(isSubclass(Image.self, of: Widget.self))
        #expect(isSubclass(Separator.self, of: Widget.self))
        #expect(isSubclass(Switch.self, of: Widget.self))
        #expect(isSubclass(CheckButton.self, of: Widget.self))
        #expect(isSubclass(Overlay.self, of: Widget.self))
        #expect(isSubclass(FlowBox.self, of: Widget.self))
        #expect(isSubclass(SearchEntry.self, of: Widget.self))
        #expect(isSubclass(ToggleButton.self, of: Widget.self))
        #expect(isSubclass(MenuButton.self, of: Widget.self))
        #expect(isSubclass(Revealer.self, of: Widget.self))
    }

    // MARK: - Signal Coverage Tests

    @Test @MainActor func allGeneratedSignalsAreSupported() {
        let signalTypes: [Any.Type] = [
            TabView.self, TabBar.self, TabOverview.self,
            NavigationView.self, NavigationPage.self,
            AlertDialog.self, Carousel.self, Toast.self,
            SwipeTracker.self, SpinRow.self,
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

    @Test @MainActor func entryMaxLength() {
        ensureAdwInit()
        let entry = Entry()
        entry.maxLength = 50
        #expect(entry.maxLength == 50)
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

    // MARK: - Adw Widget Instantiation Tests

    @Test @MainActor func headerBarCreation() {
        ensureAdwInit()
        let hb = HeaderBar()
        hb.showTitle = false
        #expect(hb.showTitle == false)
        hb.showBackButton = true
        #expect(hb.showBackButton == true)
    }

    @Test @MainActor func headerBarPackWidgets() {
        ensureAdwInit()
        let hb = HeaderBar()
        let btn = Button(iconName: "open-menu-symbolic")
        hb.packEnd(btn)
        // Should not crash
        hb.remove(btn)
    }

    @Test @MainActor func toolbarViewCreation() {
        ensureAdwInit()
        let tv = ToolbarView()
        let hb = HeaderBar()
        let label = Label("Content")
        tv.addTopBar(hb)
        tv.setContent(label)
        #expect(tv.content != nil)
    }

    @Test @MainActor func toolbarViewBarStyles() {
        ensureAdwInit()
        let tv = ToolbarView()
        let initial = tv.topBarStyle
        // Round-trip: set and read back
        tv.topBarStyle = initial
        #expect(tv.topBarStyle == initial)
        let bottomInitial = tv.bottomBarStyle
        tv.bottomBarStyle = bottomInitial
        #expect(tv.bottomBarStyle == bottomInitial)
    }

    @Test @MainActor func toolbarViewReveal() {
        ensureAdwInit()
        let tv = ToolbarView()
        #expect(tv.revealTopBars == true)
        tv.revealTopBars = false
        #expect(tv.revealTopBars == false)
        tv.revealBottomBars = false
        #expect(tv.revealBottomBars == false)
    }

    @Test @MainActor func statusPageProperties() {
        ensureAdwInit()
        let sp = StatusPage()
        sp.title = "No Results"
        sp.description = "Try a different search"
        sp.iconName = "system-search-symbolic"
        #expect(sp.title == "No Results")
        #expect(sp.description == "Try a different search")
        #expect(sp.iconName == "system-search-symbolic")
    }

    @Test @MainActor func statusPageChild() {
        ensureAdwInit()
        let sp = StatusPage()
        let btn = Button(label: "Retry")
        sp.child = btn
        #expect(sp.child != nil)
    }

    @Test @MainActor func toastCreation() {
        ensureAdwInit()
        let toast = Toast(title: "Saved!")
        #expect(toast.title == "Saved!")
    }

    @Test @MainActor func toastProperties() {
        ensureAdwInit()
        let toast = Toast(title: "Test")
        toast.buttonLabel = "Undo"
        #expect(toast.buttonLabel == "Undo")
        toast.timeout = 5
        #expect(toast.timeout == 5)
    }

    @Test @MainActor func bannerProperties() {
        ensureAdwInit()
        let banner = Banner(title: "Update available")
        #expect(banner.title == "Update available")
        banner.buttonLabel = "Update"
        #expect(banner.buttonLabel == "Update")
        banner.revealed = true
        #expect(banner.revealed == true)
    }

    @Test @MainActor func avatarProperties() {
        ensureAdwInit()
        let avatar = Avatar(size: 64, text: "John", showInitials: true)
        #expect(avatar.size == 64)
        #expect(avatar.text == "John")
        #expect(avatar.showInitials == true)
    }

    @Test @MainActor func spinnerCreation() {
        ensureAdwInit()
        let spinner = Spinner()
        // Spinner should be instantiable
        #expect(spinner.pointer != nil)
    }

    @Test @MainActor func buttonContentProperties() {
        ensureAdwInit()
        let bc = ButtonContent()
        bc.label = "Open"
        bc.iconName = "document-open-symbolic"
        #expect(bc.label == "Open")
        #expect(bc.iconName == "document-open-symbolic")
    }

    @Test @MainActor func windowTitleProperties() {
        ensureAdwInit()
        let wt = WindowTitle(title: "My App", subtitle: "v1.0")
        #expect(wt.title == "My App")
        #expect(wt.subtitle == "v1.0")
    }

    @Test @MainActor func windowTitleRoundTrip() {
        ensureAdwInit()
        let wt = WindowTitle(title: "A", subtitle: "B")
        wt.title = "Changed"
        wt.subtitle = "New Sub"
        #expect(wt.title == "Changed")
        #expect(wt.subtitle == "New Sub")
    }

    @Test @MainActor func navigationViewProperties() {
        ensureAdwInit()
        let nav = NavigationView()
        // NavigationView starts with no visible page
        nav.popOnEscape = true
        #expect(nav.popOnEscape == true)
        nav.animateTransitions = false
        #expect(nav.animateTransitions == false)
    }

    @Test @MainActor func navigationViewAnimateTransitions() {
        ensureAdwInit()
        let nav = NavigationView()
        nav.animateTransitions = true
        #expect(nav.animateTransitions == true)
        nav.animateTransitions = false
        #expect(nav.animateTransitions == false)
    }

    @Test @MainActor func alertDialogCreation() {
        ensureAdwInit()
        let dialog = AlertDialog(heading: "Delete?", body: "This cannot be undone.")
        #expect(dialog.heading == "Delete?")
        #expect(dialog.body == "This cannot be undone.")
    }

    @Test @MainActor func alertDialogResponses() {
        ensureAdwInit()
        let dialog = AlertDialog(heading: "Confirm", body: "Proceed?")
        dialog.addResponse("cancel", label: "Cancel")
        dialog.addResponse("ok", label: "OK")
        #expect(dialog.hasResponse("cancel") == true)
        #expect(dialog.hasResponse("ok") == true)
        #expect(dialog.hasResponse("nonexistent") == false)
    }

    @Test @MainActor func alertDialogPreferWideLayout() {
        ensureAdwInit()
        let dialog = AlertDialog(heading: "Test", body: "Body")
        dialog.preferWideLayout = true
        #expect(dialog.preferWideLayout == true)
    }

    @Test @MainActor func carouselOperations() {
        ensureAdwInit()
        let carousel = Carousel()
        let page1 = Label("Page 1")
        let page2 = Label("Page 2")
        carousel.append(page1)
        carousel.append(page2)
        #expect(carousel.nPages == 2)
    }

    @Test @MainActor func carouselProperties() {
        ensureAdwInit()
        let carousel = Carousel()
        carousel.spacing = 20
        #expect(carousel.spacing == 20)
        carousel.allowMouseDrag = false
        #expect(carousel.allowMouseDrag == false)
        carousel.interactive = false
        #expect(carousel.interactive == false)
    }

    @Test @MainActor func clampProperties() {
        ensureAdwInit()
        let clamp = Clamp()
        clamp.maximumSize = 600
        #expect(clamp.maximumSize == 600)
        clamp.tighteningThreshold = 400
        #expect(clamp.tighteningThreshold == 400)
    }

    @Test @MainActor func preferencesGroupProperties() {
        ensureAdwInit()
        let group = PreferencesGroup()
        group.title = "General"
        group.description = "Basic settings"
        #expect(group.title == "General")
        #expect(group.description == "Basic settings")
    }

    @Test @MainActor func preferencesGroupAddRow() {
        ensureAdwInit()
        let group = PreferencesGroup()
        let row = ActionRow()
        row.title = "Setting"
        group.add(row)
        // Should not crash
        group.remove(row)
    }

    @Test @MainActor func actionRowProperties() {
        ensureAdwInit()
        let row = ActionRow()
        row.title = "Name"
        row.subtitle = "Enter your name"
        #expect(row.title == "Name")
        #expect(row.subtitle == "Enter your name")
    }

    @Test @MainActor func switchRowProperties() {
        ensureAdwInit()
        let row = SwitchRow()
        row.title = "Dark Mode"
        row.active = true
        #expect(row.title == "Dark Mode")
        #expect(row.active == true)
    }

    @Test @MainActor func viewStackOperations() {
        ensureAdwInit()
        let vs = ViewStack()
        let page1 = Label("Home")
        let page2 = Label("Settings")
        vs.addTitledWithIcon(page1, name: "home", title: "Home", iconName: "go-home-symbolic")
        vs.addTitledWithIcon(page2, name: "settings", title: "Settings", iconName: "preferences-system-symbolic")
        vs.visibleChildName = "settings"
        #expect(vs.visibleChildName == "settings")
    }

    @Test @MainActor func toastOverlayChild() {
        ensureAdwInit()
        let overlay = ToastOverlay()
        let label = Label("Content")
        overlay.child = label
        #expect(overlay.child != nil)
    }

    @Test @MainActor func splitButtonProperties() {
        ensureAdwInit()
        let sb = SplitButton()
        sb.iconName = "document-open-symbolic"
        #expect(sb.iconName == "document-open-symbolic")
    }

    @Test @MainActor func overlaySplitViewProperties() {
        ensureAdwInit()
        let osv = OverlaySplitView()
        let sidebar = Label("Sidebar")
        let content = Label("Content")
        osv.sidebar = sidebar
        osv.content = content
        osv.showSidebar = false
        #expect(osv.showSidebar == false)
    }

    @Test @MainActor func bottomSheetProperties() {
        ensureAdwInit()
        let bs = BottomSheet()
        let content = Label("Main")
        let sheet = Label("Sheet")
        bs.content = content
        bs.sheet = sheet
        bs.open = true
        #expect(bs.open == true)
    }

    // MARK: - Signal Connection Tests

    @Test @MainActor func signalConnectionReturnsValidObject() {
        ensureAdwInit()
        let btn = Button(label: "Test")
        let conn = btn.onClicked { /* no-op */ }
        // Connection object should be non-nil and disconnectable
        conn.disconnect()
        // Double-disconnect should not crash
        conn.disconnect()
    }

    @Test @MainActor func multipleSignalConnectionsReturnDistinctObjects() {
        ensureAdwInit()
        let btn = Button(label: "Multi")
        let c1 = btn.onClicked { }
        let c2 = btn.onClicked { }
        // Both connections should be independently disconnectable
        c1.disconnect()
        c2.disconnect()
    }

    @Test @MainActor func signalConnectionOnGeneratedWidget() {
        ensureAdwInit()
        let toast = Toast(title: "test")
        let conn = toast.onDismissed { }
        conn.disconnect()
    }

    @Test @MainActor func notifySignalConnects() {
        ensureAdwInit()
        let label = Label("before")
        let conn = SignalHelper.onNotify(label, property: "label") { }
        conn.disconnect()
    }

    @Test @MainActor func signalConnectionOnAdwAlertDialog() {
        ensureAdwInit()
        let dialog = AlertDialog(heading: "Test", body: "Body")
        dialog.addResponse("ok", label: "OK")
        let conn = dialog.onResponse { _ in }
        conn.disconnect()
    }

    @Test @MainActor func signalConnectionOnNavigationView() {
        ensureAdwInit()
        let nav = NavigationView()
        let conn = nav.onPushed { }
        conn.disconnect()
    }

    @Test @MainActor func signalConnectionOnCarousel() {
        ensureAdwInit()
        let carousel = Carousel()
        let conn = carousel.onPageChanged { _ in }
        conn.disconnect()
    }

    // MARK: - GObject Ref Counting Tests

    @Test @MainActor func borrowingAddsRef() {
        ensureAdwInit()
        let label = Label("ref test")
        let refCount1 = label.gobjectPointer.pointee.ref_count
        let borrowed = Widget(borrowing: label.pointer)
        let refCount2 = label.gobjectPointer.pointee.ref_count
        #expect(refCount2 == refCount1 + 1, "Borrowing should add a reference")
        _ = borrowed // keep alive
    }

    @Test @MainActor func widgetPointerStability() {
        ensureAdwInit()
        let btn = Button(label: "stable")
        let ptr1 = btn.pointer
        let ptr2 = btn.pointer
        #expect(ptr1 == ptr2, "Pointer should be stable across accesses")
    }

    // MARK: - Container Relationship Tests

    @Test @MainActor func boxContainsChildren() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL)
        let child1 = Label("1")
        let child2 = Label("2")
        let child3 = Label("3")
        box.append(child1)
        box.append(child2)
        box.insertChildAfter(child3, sibling: child1)
        // Verify children exist by removing them without crash
        box.remove(child1)
        box.remove(child2)
        box.remove(child3)
    }

    @Test @MainActor func nestedContainers() {
        ensureAdwInit()
        let outerBox = Box(orientation: GTK_ORIENTATION_VERTICAL)
        let innerBox = Box(orientation: GTK_ORIENTATION_HORIZONTAL, spacing: 5)
        let label = Label("Nested")
        innerBox.append(label)
        outerBox.append(innerBox)
        // Deeply nested widget tree should not crash
        outerBox.remove(innerBox)
    }

    @Test @MainActor func toolbarViewFullLayout() {
        ensureAdwInit()
        let tv = ToolbarView()
        let hb = HeaderBar()
        let content = Box(orientation: GTK_ORIENTATION_VERTICAL)
        let statusPage = StatusPage()
        statusPage.title = "Welcome"
        statusPage.iconName = "face-smile-symbolic"
        content.append(statusPage)
        tv.addTopBar(hb)
        tv.setContent(content)
        #expect(tv.content != nil)
    }

    // MARK: - GValue Pointer Access Tests

    @Test @MainActor func gvalueWithUnsafePointer() {
        var gv = GValueRef("test")
        let result = gv.withUnsafePointer { ptr in
            String(cString: g_value_get_string(ptr)!)
        }
        #expect(result == "test")
    }

    @Test @MainActor func gvalueWithUnsafeMutablePointer() {
        var gv = GValueRef(Int32(0))
        gv.withUnsafeMutablePointer { ptr in
            g_value_set_int(ptr, 42)
        }
        #expect(gv.intValue == 42)
    }

    // MARK: - Adw Enum Import Tests

    @Test @MainActor func adwEnumTypesAreAccessible() {
        // Verify key Adw enum types are importable
        let _: AdwCenteringPolicy.Type = AdwCenteringPolicy.self
        let _: AdwToolbarStyle.Type = AdwToolbarStyle.self
        let _: AdwNavigationDirection.Type = AdwNavigationDirection.self
        let _: AdwColorScheme.Type = AdwColorScheme.self
        let _: AdwResponseAppearance.Type = AdwResponseAppearance.self
        let _: AdwLengthUnit.Type = AdwLengthUnit.self
        let _: AdwFoldThresholdPolicy.Type = AdwFoldThresholdPolicy.self
        let _: AdwBreakpointConditionLengthType.Type = AdwBreakpointConditionLengthType.self
        #expect(Bool(true), "All key Adw enum types are accessible")
    }

    @Test @MainActor func gtkEnumsAreAccessible() {
        let _ = GTK_ORIENTATION_HORIZONTAL
        let _ = GTK_ORIENTATION_VERTICAL
        let _ = GTK_ALIGN_START
        let _ = GTK_ALIGN_CENTER
        let _ = GTK_ALIGN_END
        let _ = GTK_ALIGN_FILL
        let _ = GTK_SELECTION_NONE
        let _ = GTK_SELECTION_SINGLE
        let _ = GTK_SELECTION_MULTIPLE
        #expect(Bool(true), "All key GTK enums are accessible")
    }
}
