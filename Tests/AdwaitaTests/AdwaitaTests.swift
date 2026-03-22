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

    // MARK: - GMenu and Actions Tests

    @Test @MainActor func gmenuCreationAndAppend() {
        ensureAdwInit()
        let menu = GMenuRef()
        menu.append("Quit", action: "app.quit")
        menu.append("About", action: "app.about")
        // Should not crash
        #expect(menu.pointer != nil)
    }

    @Test @MainActor func gmenuSectionAndSubmenu() {
        ensureAdwInit()
        let menu = GMenuRef()
        let section = GMenuRef()
        section.append("Cut", action: "app.cut")
        section.append("Copy", action: "app.copy")
        menu.appendSection("Edit", section: section)

        let submenu = GMenuRef()
        submenu.append("Zoom In", action: "app.zoom-in")
        menu.appendSubmenu("View", submenu: submenu)
        #expect(menu.pointer != nil)
    }

    @Test @MainActor func gmenuItemWithIcon() {
        ensureAdwInit()
        let item = GMenuItemRef(label: "Open", action: "app.open")
        item.setIconName("document-open-symbolic")
        item.setLabel("Open File")
        #expect(item.pointer != nil)
    }

    @Test @MainActor func simpleActionCreation() {
        ensureAdwInit()
        let action = SimpleAction(name: "test")
        #expect(action.enabled == true)
        action.enabled = false
        #expect(action.enabled == false)
    }

    @Test @MainActor func simpleActionSignal() {
        ensureAdwInit()
        let action = SimpleAction(name: "click")
        let conn = action.onActivate { }
        conn.disconnect()
    }

    @Test @MainActor func menuButtonWithModel() {
        ensureAdwInit()
        let menu = GMenuRef()
        menu.append("Item 1", action: "app.item1")
        let btn = MenuButton()
        btn.setMenuModel(menu)
        #expect(btn.pointer != nil)
    }

    // MARK: - New GTK Widget Tests

    @Test @MainActor func progressBarProperties() {
        ensureAdwInit()
        let pb = ProgressBar()
        pb.fraction = 0.75
        #expect(pb.fraction == 0.75)
        pb.showText = true
        #expect(pb.showText == true)
        pb.text = "75%"
        #expect(pb.text == "75%")
        pb.inverted = true
        #expect(pb.inverted == true)
    }

    @Test @MainActor func progressBarPulse() {
        ensureAdwInit()
        let pb = ProgressBar()
        pb.pulseStep = 0.1
        #expect(pb.pulseStep == 0.1)
        pb.pulse()
        // Should not crash
        #expect(pb.pointer != nil)
    }

    @Test @MainActor func scaleProperties() {
        ensureAdwInit()
        let scale = Scale(orientation: GTK_ORIENTATION_HORIZONTAL, min: 0, max: 100, step: 1)
        scale.value = 50
        #expect(scale.value == 50)
        scale.drawValue = true
        #expect(scale.drawValue == true)
        scale.hasOrigin = true
        #expect(scale.hasOrigin == true)
        scale.digits = 0
        #expect(scale.digits == 0)
    }

    @Test @MainActor func scaleInverted() {
        ensureAdwInit()
        let scale = Scale(orientation: GTK_ORIENTATION_HORIZONTAL, min: 0, max: 10, step: 1)
        scale.inverted = true
        #expect(scale.inverted == true)
    }

    @Test @MainActor func levelBarProperties() {
        ensureAdwInit()
        let lb = LevelBar(min: 0, max: 10)
        lb.value = 7
        #expect(lb.value == 7)
        #expect(lb.minValue == 0)
        #expect(lb.maxValue == 10)
        lb.inverted = true
        #expect(lb.inverted == true)
    }

    @Test @MainActor func textViewProperties() {
        ensureAdwInit()
        let tv = TextView()
        tv.text = "Hello, World!"
        #expect(tv.text == "Hello, World!")
        tv.editable = false
        #expect(tv.editable == false)
        tv.monospace = true
        #expect(tv.monospace == true)
        tv.cursorVisible = false
        #expect(tv.cursorVisible == false)
    }

    @Test @MainActor func textViewMargins() {
        ensureAdwInit()
        let tv = TextView()
        tv.leftMargin = 10
        tv.rightMargin = 10
        tv.topMargin = 5
        tv.bottomMargin = 5
        #expect(tv.leftMargin == 10)
        #expect(tv.rightMargin == 10)
        #expect(tv.topMargin == 5)
        #expect(tv.bottomMargin == 5)
    }

    @Test @MainActor func stringListOperations() {
        ensureAdwInit()
        let sl = StringList(["Alpha", "Beta", "Gamma"])
        #expect(sl.count == 3)
        #expect(sl.getString(0) == "Alpha")
        #expect(sl.getString(1) == "Beta")
        #expect(sl.getString(2) == "Gamma")
        sl.append("Delta")
        #expect(sl.count == 4)
        sl.remove(1)
        #expect(sl.count == 3)
        #expect(sl.getString(1) == "Gamma")
    }

    @Test @MainActor func cssProviderLoadFromString() {
        ensureAdwInit()
        let css = CSSProvider()
        css.loadFromString("button { color: red; }")
        css.addToDefaultDisplay()
        css.removeFromDefaultDisplay()
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

    // MARK: - Event Controller Tests

    @Test @MainActor func gestureClickCreation() {
        ensureAdwInit()
        let gesture = GestureClick()
        #expect(gesture.pointer != nil)
    }

    @Test @MainActor func gestureClickSignalConnection() {
        ensureAdwInit()
        let gesture = GestureClick()
        let conn1 = gesture.onPressed { _, _, _ in }
        let conn2 = gesture.onReleased { _, _, _ in }
        // Signal handlers should be connected without crashing
        conn1.disconnect()
        conn2.disconnect()
    }

    @Test @MainActor func gestureClickAddToWidget() {
        ensureAdwInit()
        let btn = Button(label: "Test")
        let gesture = GestureClick()
        btn.addController(gesture)
        // Should not crash
        #expect(Bool(true))
    }

    @Test @MainActor func eventControllerKeyCreation() {
        ensureAdwInit()
        let controller = EventControllerKey()
        #expect(controller.pointer != nil)
    }

    @Test @MainActor func eventControllerKeySignalConnection() {
        ensureAdwInit()
        let controller = EventControllerKey()
        let conn1 = controller.onKeyPressed { _, _, _ in return false }
        let conn2 = controller.onKeyReleased { _, _, _ in }
        conn1.disconnect()
        conn2.disconnect()
    }

    @Test @MainActor func eventControllerKeyAddToWidget() {
        ensureAdwInit()
        let entry = Entry()
        let controller = EventControllerKey()
        entry.addController(controller)
        #expect(Bool(true))
    }

    @Test @MainActor func eventControllerMotionCreation() {
        ensureAdwInit()
        let controller = EventControllerMotion()
        #expect(controller.pointer != nil)
    }

    @Test @MainActor func eventControllerMotionSignalConnection() {
        ensureAdwInit()
        let controller = EventControllerMotion()
        let conn1 = controller.onMotion { _, _ in }
        let conn2 = controller.onEnter { _, _ in }
        let conn3 = controller.onLeave { }
        conn1.disconnect()
        conn2.disconnect()
        conn3.disconnect()
    }

    @Test @MainActor func eventControllerMotionAddToWidget() {
        ensureAdwInit()
        let label = Label("Hover me")
        let controller = EventControllerMotion()
        label.addController(controller)
        #expect(Bool(true))
    }

    @Test @MainActor func eventControllerScrollCreation() {
        ensureAdwInit()
        let controller = EventControllerScroll()
        #expect(controller.pointer != nil)
    }

    @Test @MainActor func eventControllerScrollWithFlags() {
        ensureAdwInit()
        let controller = EventControllerScroll(flags: GTK_EVENT_CONTROLLER_SCROLL_VERTICAL)
        #expect(controller.pointer != nil)
    }

    @Test @MainActor func eventControllerScrollSignalConnection() {
        ensureAdwInit()
        let controller = EventControllerScroll()
        let conn1 = controller.onScroll { _, _ in return false }
        let conn2 = controller.onScrollBegin { }
        let conn3 = controller.onScrollEnd { }
        conn1.disconnect()
        conn2.disconnect()
        conn3.disconnect()
    }

    @Test @MainActor func eventControllerScrollAddToWidget() {
        ensureAdwInit()
        let box = Box()
        let controller = EventControllerScroll()
        box.addController(controller)
        #expect(Bool(true))
    }

    @Test @MainActor func multipleControllersOnOneWidget() {
        ensureAdwInit()
        let btn = Button(label: "Multi")
        let click = GestureClick()
        let key = EventControllerKey()
        let motion = EventControllerMotion()
        let scroll = EventControllerScroll()
        btn.addController(click)
        btn.addController(key)
        btn.addController(motion)
        btn.addController(scroll)
        #expect(Bool(true))
    }

    @Test @MainActor func eventControllerInheritance() {
        #expect(isSubclass(GestureClick.self, of: GObjectRef.self))
        #expect(isSubclass(EventControllerKey.self, of: GObjectRef.self))
        #expect(isSubclass(EventControllerMotion.self, of: GObjectRef.self))
        #expect(isSubclass(EventControllerScroll.self, of: GObjectRef.self))
    }

    // MARK: - Window onCloseRequest Signal

    @Test @MainActor func windowOnCloseRequestSignalConnection() {
        ensureAdwInit()
        let window = Window()
        let conn = window.onCloseRequest { return true }
        conn.disconnect()
    }

    // MARK: - Widget Lifecycle Signals

    @Test @MainActor func widgetLifecycleSignalConnections() {
        ensureAdwInit()
        let label = Label("lifecycle")
        let c1 = label.onRealize { }
        let c2 = label.onUnrealize { }
        let c3 = label.onMap { }
        let c4 = label.onUnmap { }
        let c5 = label.onDestroy { }
        c1.disconnect()
        c2.disconnect()
        c3.disconnect()
        c4.disconnect()
        c5.disconnect()
    }

    // MARK: - Button Convenience Initializers

    @Test @MainActor func buttonConvenienceInitWithLabel() {
        ensureAdwInit()
        var clicked = false
        let btn = Button(label: "Click", onClicked: { clicked = true })
        #expect(btn.label == "Click")
        // The handler is connected; we cannot easily trigger it without a main loop,
        // but we verify the button was created with the correct label.
    }

    @Test @MainActor func buttonConvenienceInitWithIcon() {
        ensureAdwInit()
        let btn = Button(iconName: "edit-copy-symbolic", onClicked: { })
        #expect(btn.iconName == "edit-copy-symbolic")
    }

    // MARK: - SpringParams Properties

    @Test @MainActor func springParamsProperties() {
        ensureAdwInit()
        let sp = SpringParams(dampingRatio: 0.8, mass: 1.0, stiffness: 100.0)
        #expect(sp.dampingRatio == 0.8)
        #expect(sp.mass == 1.0)
        #expect(sp.stiffness == 100.0)
        #expect(sp.damping > 0)
    }

    @Test @MainActor func springParamsFullInit() {
        ensureAdwInit()
        let sp = SpringParams(damping: 10.0, mass: 2.0, stiffness: 50.0)
        #expect(sp.damping == 10.0)
        #expect(sp.mass == 2.0)
        #expect(sp.stiffness == 50.0)
    }

    // MARK: - BreakpointCondition

    @Test @MainActor func breakpointConditionParseAndToString() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "min-width: 600px")
        let str = cond.toString()
        #expect(str.contains("600"))
    }

    @Test @MainActor func breakpointConditionLength() {
        ensureAdwInit()
        let cond = BreakpointCondition.length(
            type: ADW_BREAKPOINT_CONDITION_MIN_WIDTH,
            value: 400,
            unit: .px
        )
        let str = cond.toString()
        #expect(str.contains("400"))
    }

    @Test @MainActor func breakpointConditionAnd() {
        ensureAdwInit()
        let a = BreakpointCondition.length(
            type: ADW_BREAKPOINT_CONDITION_MIN_WIDTH,
            value: 400,
            unit: .px
        )
        let b = BreakpointCondition.length(
            type: ADW_BREAKPOINT_CONDITION_MAX_WIDTH,
            value: 800,
            unit: .px
        )
        let combined = BreakpointCondition.and(a, b)
        let str = combined.toString()
        #expect(str.contains("400"))
        #expect(str.contains("800"))
    }

    // MARK: - Enum Extensions

    @Test @MainActor func gtkOrientationEnumExtensions() {
        #expect(GtkOrientation.vertical == GTK_ORIENTATION_VERTICAL)
        #expect(GtkOrientation.horizontal == GTK_ORIENTATION_HORIZONTAL)
    }

    @Test @MainActor func gtkAlignEnumExtensions() {
        #expect(GtkAlign.fill == GTK_ALIGN_FILL)
        #expect(GtkAlign.start == GTK_ALIGN_START)
        #expect(GtkAlign.end == GTK_ALIGN_END)
        #expect(GtkAlign.center == GTK_ALIGN_CENTER)
    }

    @Test @MainActor func gtkSelectionModeEnumExtensions() {
        #expect(GtkSelectionMode.none == GTK_SELECTION_NONE)
        #expect(GtkSelectionMode.single == GTK_SELECTION_SINGLE)
        #expect(GtkSelectionMode.multiple == GTK_SELECTION_MULTIPLE)
    }

    @Test @MainActor func adwColorSchemeEnumExtensions() {
        // Verify the extensions exist and are distinct
        let d = AdwColorScheme.default
        let fd = AdwColorScheme.forceDark
        let fl = AdwColorScheme.forceLight
        #expect(fd != fl)
        #expect(d != fd)
    }

    // MARK: - SignalHelper connectReturnBool

    @Test @MainActor func signalHelperConnectReturnBoolExists() {
        let _: (GObjectRef, String, @escaping @MainActor () -> Bool) -> SignalConnection = SignalHelper.connectReturnBool
    }

    // MARK: - Grid

    @Test @MainActor func gridCreation() {
        ensureAdwInit()
        let grid = Grid()
        #expect(grid.pointer != nil)
    }

    @Test @MainActor func gridProperties() {
        ensureAdwInit()
        let grid = Grid()
        grid.columnSpacing = 10
        #expect(grid.columnSpacing == 10)
        grid.rowSpacing = 8
        #expect(grid.rowSpacing == 8)
        grid.columnHomogeneous = true
        #expect(grid.columnHomogeneous)
        grid.rowHomogeneous = true
        #expect(grid.rowHomogeneous)
    }

    @Test @MainActor func gridAttachAndRetrieve() {
        ensureAdwInit()
        let grid = Grid()
        let label = Label("test")
        grid.attach(label, column: 0, row: 0)
        let child = grid.childAt(column: 0, row: 0)
        #expect(child != nil)
        #expect(child!.pointer == label.pointer)
    }

    @Test @MainActor func gridMultiColumnSpan() {
        ensureAdwInit()
        let grid = Grid()
        let label = Label("wide")
        grid.attach(label, column: 0, row: 0, width: 3, height: 2)
        // The widget should be found at column 0, row 0
        #expect(grid.childAt(column: 0, row: 0) != nil)
    }

    @Test @MainActor func gridInsertRemoveRow() {
        ensureAdwInit()
        let grid = Grid()
        let label = Label("r1")
        grid.attach(label, column: 0, row: 0)
        grid.insertRow(at: 0)
        // After inserting row 0, the label moves to row 1
        #expect(grid.childAt(column: 0, row: 1) != nil)
    }

    // MARK: - Popover

    @Test @MainActor func popoverCreation() {
        ensureAdwInit()
        let popover = Popover()
        #expect(popover.pointer != nil)
    }

    @Test @MainActor func popoverProperties() {
        ensureAdwInit()
        let popover = Popover()
        popover.hasArrow = false
        #expect(!popover.hasArrow)
        popover.hasArrow = true
        #expect(popover.hasArrow)
        popover.autohide = false
        #expect(!popover.autohide)
        popover.position = .bottom
        #expect(popover.position == .bottom)
    }

    @Test @MainActor func popoverChild() {
        ensureAdwInit()
        let popover = Popover()
        let label = Label("popup content")
        popover.child = label
        #expect(popover.child != nil)
        #expect(popover.child!.pointer == label.pointer)
    }

    // MARK: - PopoverMenu

    @Test @MainActor func popoverMenuCreation() {
        ensureAdwInit()
        let menu = PopoverMenu(model: nil)
        #expect(menu.pointer != nil)
    }

    // MARK: - Picture

    @Test @MainActor func pictureCreation() {
        ensureAdwInit()
        let picture = Picture()
        #expect(picture.pointer != nil)
    }

    @Test @MainActor func pictureCanShrink() {
        ensureAdwInit()
        let picture = Picture()
        picture.canShrink = false
        #expect(!picture.canShrink)
        picture.canShrink = true
        #expect(picture.canShrink)
    }

    @Test @MainActor func pictureAlternativeText() {
        ensureAdwInit()
        let picture = Picture()
        picture.alternativeText = "A photo"
        #expect(picture.alternativeText == "A photo")
    }

    // MARK: - DropDown

    @Test @MainActor func dropDownFromStrings() {
        ensureAdwInit()
        let dd = DropDown(strings: ["One", "Two", "Three"])
        #expect(dd.pointer != nil)
        #expect(dd.selected == 0)
    }

    @Test @MainActor func dropDownSelection() {
        ensureAdwInit()
        let dd = DropDown(strings: ["A", "B", "C"])
        dd.selected = 2
        #expect(dd.selected == 2)
    }

    @Test @MainActor func dropDownEnableSearch() {
        ensureAdwInit()
        let dd = DropDown(strings: ["X"])
        dd.enableSearch = true
        #expect(dd.enableSearch)
        dd.enableSearch = false
        #expect(!dd.enableSearch)
    }

    // MARK: - Adjustment

    @Test @MainActor func adjustmentCreation() {
        ensureAdwInit()
        let adj = Adjustment(value: 50, lower: 0, upper: 100, stepIncrement: 1, pageIncrement: 10, pageSize: 0)
        #expect(adj.value == 50)
        #expect(adj.lower == 0)
        #expect(adj.upper == 100)
        #expect(adj.stepIncrement == 1)
        #expect(adj.pageIncrement == 10)
    }

    @Test @MainActor func adjustmentSetValue() {
        ensureAdwInit()
        let adj = Adjustment(value: 0, lower: 0, upper: 100)
        adj.value = 75
        #expect(adj.value == 75)
    }

    @Test @MainActor func adjustmentConfigure() {
        ensureAdwInit()
        let adj = Adjustment()
        adj.configure(value: 25, lower: 10, upper: 50, stepIncrement: 2, pageIncrement: 5, pageSize: 0)
        #expect(adj.value == 25)
        #expect(adj.lower == 10)
        #expect(adj.upper == 50)
        #expect(adj.stepIncrement == 2)
    }

    // MARK: - Paned

    @Test @MainActor func panedCreation() {
        ensureAdwInit()
        let paned = Paned()
        #expect(paned.pointer != nil)
    }

    @Test @MainActor func panedProperties() {
        ensureAdwInit()
        let paned = Paned()
        paned.position = 200
        #expect(paned.position == 200)
        paned.wideHandle = true
        #expect(paned.wideHandle)
        paned.resizeStartChild = false
        #expect(!paned.resizeStartChild)
        paned.shrinkEndChild = false
        #expect(!paned.shrinkEndChild)
    }

    @Test @MainActor func panedChildren() {
        ensureAdwInit()
        let paned = Paned()
        let left = Label("Left")
        let right = Label("Right")
        paned.startChild = left
        paned.endChild = right
        #expect(paned.startChild != nil)
        #expect(paned.endChild != nil)
        #expect(paned.startChild!.pointer == left.pointer)
    }

    // MARK: - Expander

    @Test @MainActor func expanderCreation() {
        ensureAdwInit()
        let exp = Expander(label: "Details")
        #expect(exp.pointer != nil)
    }

    @Test @MainActor func expanderProperties() {
        ensureAdwInit()
        let exp = Expander(label: "Details")
        #expect(exp.label == "Details")
        exp.expanded = true
        #expect(exp.expanded)
        exp.expanded = false
        #expect(!exp.expanded)
        exp.useMarkup = true
        #expect(exp.useMarkup)
    }

    @Test @MainActor func expanderChild() {
        ensureAdwInit()
        let exp = Expander(label: "More")
        let content = Label("Hidden content")
        exp.child = content
        #expect(exp.child != nil)
        #expect(exp.child!.pointer == content.pointer)
    }

    // MARK: - Notebook

    @Test @MainActor func notebookCreation() {
        ensureAdwInit()
        let nb = Notebook()
        #expect(nb.pointer != nil)
        #expect(nb.nPages == 0)
    }

    @Test @MainActor func notebookAddPages() {
        ensureAdwInit()
        let nb = Notebook()
        let page1 = Label("Page 1 content")
        let page2 = Label("Page 2 content")
        let idx1 = nb.appendPage(page1, label: "Tab 1")
        let idx2 = nb.appendPage(page2, label: "Tab 2")
        #expect(idx1 == 0)
        #expect(idx2 == 1)
        #expect(nb.nPages == 2)
    }

    @Test @MainActor func notebookCurrentPage() {
        ensureAdwInit()
        let nb = Notebook()
        nb.appendPage(Label("A"), label: "A")
        nb.appendPage(Label("B"), label: "B")
        nb.appendPage(Label("C"), label: "C")
        nb.currentPage = 2
        #expect(nb.currentPage == 2)
    }

    @Test @MainActor func notebookProperties() {
        ensureAdwInit()
        let nb = Notebook()
        nb.showTabs = false
        #expect(!nb.showTabs)
        nb.scrollable = true
        #expect(nb.scrollable)
        nb.tabPos = .left
        #expect(nb.tabPos == .left)
    }

    @Test @MainActor func notebookTabLabel() {
        ensureAdwInit()
        let nb = Notebook()
        let page = Label("Content")
        nb.appendPage(page, label: "Original")
        #expect(nb.getTabLabelText(page) == "Original")
        nb.setTabLabelText(page, text: "Renamed")
        #expect(nb.getTabLabelText(page) == "Renamed")
    }

    // MARK: - GestureLongPress

    @Test @MainActor func gestureLongPressCreation() {
        ensureAdwInit()
        let gesture = GestureLongPress()
        #expect(gesture.pointer != nil)
    }

    @Test @MainActor func gestureLongPressDelayFactor() {
        ensureAdwInit()
        let gesture = GestureLongPress()
        gesture.delayFactor = 2.0
        #expect(gesture.delayFactor == 2.0)
    }

    @Test @MainActor func gestureLongPressSignals() {
        ensureAdwInit()
        let gesture = GestureLongPress()
        let c1 = gesture.onPressed { _, _ in }
        let c2 = gesture.onCancelled { }
        c1.disconnect()
        c2.disconnect()
    }

    // MARK: - GestureDrag

    @Test @MainActor func gestureDragCreation() {
        ensureAdwInit()
        let gesture = GestureDrag()
        #expect(gesture.pointer != nil)
    }

    @Test @MainActor func gestureDragSignals() {
        ensureAdwInit()
        let gesture = GestureDrag()
        let c1 = gesture.onDragBegin { _, _ in }
        let c2 = gesture.onDragUpdate { _, _ in }
        let c3 = gesture.onDragEnd { _, _ in }
        c1.disconnect()
        c2.disconnect()
        c3.disconnect()
    }

    // MARK: - EventControllerFocus

    @Test @MainActor func eventControllerFocusCreation() {
        ensureAdwInit()
        let focus = EventControllerFocus()
        #expect(focus.pointer != nil)
        #expect(!focus.isFocus)
        #expect(!focus.containsFocus)
    }

    @Test @MainActor func eventControllerFocusSignals() {
        ensureAdwInit()
        let focus = EventControllerFocus()
        let c1 = focus.onEnter { }
        let c2 = focus.onLeave { }
        c1.disconnect()
        c2.disconnect()
    }

    // MARK: - FileDialog

    @Test @MainActor func fileDialogCreation() {
        ensureAdwInit()
        let dialog = FileDialog()
        #expect(dialog.pointer != nil)
    }

    @Test @MainActor func fileDialogProperties() {
        ensureAdwInit()
        let dialog = FileDialog()
        dialog.title = "Open File"
        #expect(dialog.title == "Open File")
        dialog.modal = false
        #expect(!dialog.modal)
        dialog.initialName = "document.txt"
        #expect(dialog.initialName == "document.txt")
        dialog.acceptLabel = "Choose"
        #expect(dialog.acceptLabel == "Choose")
    }

    // MARK: - ColorDialog

    @Test @MainActor func colorDialogCreation() {
        ensureAdwInit()
        let dialog = ColorDialog()
        #expect(dialog.pointer != nil)
    }

    @Test @MainActor func colorDialogProperties() {
        ensureAdwInit()
        let dialog = ColorDialog()
        dialog.title = "Pick Color"
        #expect(dialog.title == "Pick Color")
        dialog.withAlpha = false
        #expect(!dialog.withAlpha)
    }

    @Test @MainActor func rgbaStruct() {
        let color = RGBA(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.8)
        #expect(color.red == 1.0)
        #expect(color.green == 0.5)
        #expect(color.blue == 0.0)
        #expect(color.alpha == 0.8)
    }

    // MARK: - FontDialog

    @Test @MainActor func fontDialogCreation() {
        ensureAdwInit()
        let dialog = FontDialog()
        #expect(dialog.pointer != nil)
    }

    @Test @MainActor func fontDialogProperties() {
        ensureAdwInit()
        let dialog = FontDialog()
        dialog.title = "Choose Font"
        #expect(dialog.title == "Choose Font")
        dialog.modal = false
        #expect(!dialog.modal)
    }

    // MARK: - Clipboard

    @Test @MainActor func clipboardFromWidget() {
        ensureAdwInit()
        let button = Button(label: "test")
        // Clipboard can only be obtained after the widget has a display.
        // In headless tests this may not work, but the type should exist.
        let _: (Widget) -> Clipboard = { $0.clipboard }
        _ = button
    }

    // MARK: - DragSource

    @Test @MainActor func dragSourceCreation() {
        ensureAdwInit()
        let source = DragSource()
        #expect(source.pointer != nil)
    }

    @Test @MainActor func dragSourceActions() {
        ensureAdwInit()
        let source = DragSource()
        source.actions = GDK_ACTION_COPY
        #expect(source.actions == GDK_ACTION_COPY)
    }

    // MARK: - DropTarget

    @Test @MainActor func dropTargetCreation() {
        ensureAdwInit()
        let target = DropTarget.forText()
        #expect(target.pointer != nil)
    }

    @Test @MainActor func dropTargetProperties() {
        ensureAdwInit()
        let target = DropTarget.forText()
        target.preload = true
        #expect(target.preload)
    }

    // MARK: - FileFilter

    @Test @MainActor func fileFilterCreation() {
        ensureAdwInit()
        let filter = FileFilter()
        filter.name = "Swift Files"
        #expect(filter.name == "Swift Files")
    }

    @Test @MainActor func fileFilterConvenienceInit() {
        ensureAdwInit()
        let filter = FileFilter(name: "Images", mimeTypes: ["image/png", "image/jpeg"])
        #expect(filter.name == "Images")
    }

    @Test @MainActor func fileFilterSuffix() {
        ensureAdwInit()
        let filter = FileFilter(name: "Code", suffixes: ["swift", "c", "h"])
        #expect(filter.name == "Code")
    }

    @Test @MainActor func fileDialogSetFilters() {
        ensureAdwInit()
        let dialog = FileDialog()
        let filter1 = FileFilter(name: "Swift", suffixes: ["swift"])
        let filter2 = FileFilter(name: "All", suffixes: ["*"])
        dialog.setFilters([filter1, filter2])
        dialog.setDefaultFilter(filter1)
        // No crash = success
    }

    // MARK: - Frame

    @Test @MainActor func frameCreation() {
        ensureAdwInit()
        let frame = Frame(label: "Test")
        #expect(frame.pointer != nil)
        #expect(frame.label == "Test")
    }

    @Test @MainActor func frameChild() {
        ensureAdwInit()
        let frame = Frame(label: "Container")
        let label = Label("Content")
        frame.child = label
        #expect(frame.child != nil)
        #expect(frame.child!.pointer == label.pointer)
    }

    @Test @MainActor func frameLabelAlign() {
        ensureAdwInit()
        let frame = Frame(label: "Aligned")
        frame.labelXAlign = 0.5
        #expect(frame.labelXAlign == 0.5)
    }

    // MARK: - CenterBox

    @Test @MainActor func centerBoxCreation() {
        ensureAdwInit()
        let cb = CenterBox()
        #expect(cb.pointer != nil)
    }

    @Test @MainActor func centerBoxChildren() {
        ensureAdwInit()
        let cb = CenterBox()
        let start = Label("Start")
        let center = Label("Center")
        let end = Label("End")
        cb.startWidget = start
        cb.centerWidget = center
        cb.endWidget = end
        #expect(cb.startWidget!.pointer == start.pointer)
        #expect(cb.centerWidget!.pointer == center.pointer)
        #expect(cb.endWidget!.pointer == end.pointer)
    }

    // MARK: - ColorDialogButton

    @Test @MainActor func colorDialogButtonCreation() {
        ensureAdwInit()
        let btn = ColorDialogButton()
        #expect(btn.pointer != nil)
    }

    @Test @MainActor func colorDialogButtonRGBA() {
        ensureAdwInit()
        let btn = ColorDialogButton()
        btn.rgba = RGBA(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        let c = btn.rgba
        #expect(c.red == 1.0)
        #expect(c.green == 0.0)
        #expect(c.blue == 0.0)
    }

    // MARK: - FontDialogButton

    @Test @MainActor func fontDialogButtonCreation() {
        ensureAdwInit()
        let btn = FontDialogButton()
        #expect(btn.pointer != nil)
    }

    // MARK: - Per-side margins

    @Test @MainActor func widgetPerSideMargins() {
        ensureAdwInit()
        let label = Label("test")
        label.marginTop = 10
        label.marginBottom = 20
        label.marginStart = 5
        label.marginEnd = 15
        #expect(label.marginTop == 10)
        #expect(label.marginBottom == 20)
        #expect(label.marginStart == 5)
        #expect(label.marginEnd == 15)
    }

    // MARK: - Keyboard shortcuts

    @Test @MainActor func widgetAddKeyboardShortcut() {
        ensureAdwInit()
        let button = Button(label: "test")
        button.addKeyboardShortcut("<Control>s") { true }
        // No crash = success
    }

    // MARK: - DrawingArea

    @Test @MainActor func drawingAreaCreation() {
        ensureAdwInit()
        let da = DrawingArea()
        #expect(da.contentWidth == 0)
        #expect(da.contentHeight == 0)
    }

    @Test @MainActor func drawingAreaContentSize() {
        ensureAdwInit()
        let da = DrawingArea()
        da.contentWidth = 300
        da.contentHeight = 200
        #expect(da.contentWidth == 300)
        #expect(da.contentHeight == 200)
    }

    @Test @MainActor func drawingAreaSetDrawFunc() {
        ensureAdwInit()
        let da = DrawingArea()
        da.contentWidth = 100
        da.contentHeight = 100
        da.setDrawFunc { _, _, _ in }
        // No crash = success
    }

    // MARK: - Calendar

    @Test @MainActor func calendarCreation() {
        ensureAdwInit()
        let cal = Calendar()
        #expect(cal.year > 2000)
        #expect(cal.month >= 1 && cal.month <= 12)
        #expect(cal.day >= 1 && cal.day <= 31)
    }

    @Test @MainActor func calendarShowProperties() {
        ensureAdwInit()
        let cal = Calendar()
        cal.showWeekNumbers = true
        #expect(cal.showWeekNumbers == true)
        cal.showDayNames = false
        #expect(cal.showDayNames == false)
        cal.showHeading = false
        #expect(cal.showHeading == false)
    }

    @Test @MainActor func calendarMarking() {
        ensureAdwInit()
        let cal = Calendar()
        cal.markDay(15)
        #expect(cal.dayIsMarked(15) == true)
        cal.unmarkDay(15)
        #expect(cal.dayIsMarked(15) == false)
        cal.markDay(10)
        cal.markDay(20)
        cal.clearMarks()
        #expect(cal.dayIsMarked(10) == false)
        #expect(cal.dayIsMarked(20) == false)
    }

    // MARK: - TextBuffer

    @Test @MainActor func textBufferCreation() {
        ensureAdwInit()
        let buf = TextBuffer()
        #expect(buf.text == "")
        #expect(buf.charCount == 0)
        #expect(buf.lineCount == 1)
    }

    @Test @MainActor func textBufferSetText() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Hello, World!"
        #expect(buf.text == "Hello, World!")
        #expect(buf.charCount == 13)
    }

    @Test @MainActor func textBufferMultiLine() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Line 1\nLine 2\nLine 3"
        #expect(buf.lineCount == 3)
    }

    @Test @MainActor func textBufferModified() {
        ensureAdwInit()
        let buf = TextBuffer()
        #expect(buf.modified == false)
        buf.text = "changed"
        #expect(buf.modified == true)
        buf.modified = false
        #expect(buf.modified == false)
    }

    @Test @MainActor func textBufferInsertAtCursor() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.insertAtCursor("Hello")
        buf.insertAtCursor(" World")
        #expect(buf.text == "Hello World")
    }

    @Test @MainActor func textBufferSelectAll() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Select me"
        buf.selectAll()
        #expect(buf.hasSelection == true)
        #expect(buf.selectedText == "Select me")
    }

    @Test @MainActor func textBufferPlaceCursor() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Cursor test"
        buf.placeCursorAtStart()
        buf.placeCursorAtEnd()
        // No crash = success
    }

    // MARK: - TextView enhancements

    @Test @MainActor func textViewBuffer() {
        ensureAdwInit()
        let tv = TextView()
        let buf = tv.buffer
        buf.text = "Via buffer"
        #expect(tv.text == "Via buffer")
    }

    @Test @MainActor func textViewJustification() {
        ensureAdwInit()
        let tv = TextView()
        tv.justification = .center
        #expect(tv.justification == .center)
    }

    @Test @MainActor func textViewAcceptsTab() {
        ensureAdwInit()
        let tv = TextView()
        #expect(tv.acceptsTab == true)
        tv.acceptsTab = false
        #expect(tv.acceptsTab == false)
    }

    @Test @MainActor func textViewOverwrite() {
        ensureAdwInit()
        let tv = TextView()
        #expect(tv.overwrite == false)
        tv.overwrite = true
        #expect(tv.overwrite == true)
    }

    // MARK: - Video

    @Test @MainActor func videoCreation() {
        ensureAdwInit()
        let video = Video()
        #expect(video.autoplay == false)
        #expect(video.loop == false)
    }

    @Test @MainActor func videoProperties() {
        ensureAdwInit()
        let video = Video()
        video.autoplay = true
        #expect(video.autoplay == true)
        video.loop = true
        #expect(video.loop == true)
    }

    // MARK: - ApplicationWindow enhancements

    @Test @MainActor func windowModalProperty() {
        ensureAdwInit()
        let app = Application(id: "com.test.windowmodal")
        let win = ApplicationWindow(application: app)
        #expect(win.modal == false)
        win.modal = true
        #expect(win.modal == true)
    }

    @Test @MainActor func windowResizableProperty() {
        ensureAdwInit()
        let app = Application(id: "com.test.windowresizable")
        let win = ApplicationWindow(application: app)
        #expect(win.resizable == true)
        win.resizable = false
        #expect(win.resizable == false)
    }

    @Test @MainActor func windowDecoratedProperty() {
        ensureAdwInit()
        let app = Application(id: "com.test.windowdecorated")
        let win = ApplicationWindow(application: app)
        #expect(win.decorated == true)
        win.decorated = false
        #expect(win.decorated == false)
    }

    // MARK: - StyleManager

    @Test @MainActor func styleManagerDefault() {
        ensureAdwInit()
        let sm = StyleManager.default
        // Should not crash and should be usable
        _ = sm.dark
        _ = sm.highContrast
        _ = sm.systemSupportsColorSchemes
    }

    @Test @MainActor func styleManagerColorScheme() {
        ensureAdwInit()
        let sm = StyleManager.default
        sm.forceDark()
        #expect(sm.colorScheme == .forceDark)
        sm.forceLight()
        #expect(sm.colorScheme == .forceLight)
        sm.preferDark()
        #expect(sm.colorScheme == .preferDark)
        sm.preferLight()
        #expect(sm.colorScheme == .preferLight)
        sm.resetColorScheme()
        #expect(sm.colorScheme == .default)
    }

    // MARK: - NavigationView

    @Test @MainActor func navigationViewAddPage() {
        ensureAdwInit()
        let navView = NavigationView()
        let content = Label("Page")
        let page = NavigationPage(child: content, title: "Test Page")
        navView.add(page)
        #expect(navView.visiblePage != nil)
    }

    @Test @MainActor func navigationViewPushPop() {
        ensureAdwInit()
        let navView = NavigationView()
        let page1 = NavigationPage(child: Label("1"), title: "Page 1")
        navView.add(page1)
        let page2 = NavigationPage(child: Label("2"), title: "Page 2")
        navView.push(page2)
        // Pop should succeed
        let popped = navView.pop()
        #expect(popped == true)
    }

    // MARK: - GtkJustification enum

    @Test @MainActor func justificationEnum() {
        #expect(GtkJustification.left == GTK_JUSTIFY_LEFT)
        #expect(GtkJustification.right == GTK_JUSTIFY_RIGHT)
        #expect(GtkJustification.center == GTK_JUSTIFY_CENTER)
        #expect(GtkJustification.fill == GTK_JUSTIFY_FILL)
    }

    // MARK: - SearchBar

    @Test @MainActor func searchBarCreation() {
        ensureAdwInit()
        let bar = SearchBar()
        #expect(bar.searchModeEnabled == false)
        #expect(bar.showCloseButton == false)
    }

    @Test @MainActor func searchBarProperties() {
        ensureAdwInit()
        let bar = SearchBar()
        bar.searchModeEnabled = true
        #expect(bar.searchModeEnabled == true)
        bar.showCloseButton = true
        #expect(bar.showCloseButton == true)
        let entry = SearchEntry()
        bar.child = entry
        #expect(bar.child != nil)
    }

    // MARK: - EmojiChooser

    @Test @MainActor func emojiChooserCreation() {
        ensureAdwInit()
        let chooser = EmojiChooser()
        // No crash = success
        _ = chooser.widgetPointer
    }

    // MARK: - PopoverMenuBar

    @Test @MainActor func popoverMenuBarCreation() {
        ensureAdwInit()
        let menu = GMenuRef()
        menu.append("Open", action: "app.open")
        menu.append("Quit", action: "app.quit")
        let bar = PopoverMenuBar(model: menu)
        // No crash = success
        _ = bar.widgetPointer
    }

    // MARK: - Fixed

    @Test @MainActor func fixedCreation() {
        ensureAdwInit()
        let fixed = Fixed()
        let label = Label("Hello")
        fixed.put(label, x: 10, y: 20)
        // No crash = success
    }

    @Test @MainActor func fixedMove() {
        ensureAdwInit()
        let fixed = Fixed()
        let btn = Button(label: "Move me")
        fixed.put(btn, x: 0, y: 0)
        fixed.move(btn, x: 50, y: 100)
        // No crash = success
    }

    // MARK: - TextBuffer undo/redo

    @Test @MainActor func textBufferUndoRedo() {
        ensureAdwInit()
        let buf = TextBuffer()
        #expect(buf.enableUndo == true) // enabled by default
        buf.beginUserAction()
        buf.text = "Hello"
        buf.endUserAction()
        #expect(buf.canUndo == true)
        buf.undo()
        #expect(buf.text == "")
        #expect(buf.canRedo == true)
        buf.redo()
        #expect(buf.text == "Hello")
    }

    // MARK: - ListBox enhancements

    @Test @MainActor func listBoxSelectRow() {
        ensureAdwInit()
        let lb = ListBox()
        lb.selectionMode = .single
        let l1 = Label("Row 1")
        let l2 = Label("Row 2")
        lb.append(l1)
        lb.append(l2)
        lb.selectRow(at: 0)
        #expect(lb.selectedRow != nil)
    }

    @Test @MainActor func listBoxRowAt() {
        ensureAdwInit()
        let lb = ListBox()
        let l1 = Label("A")
        lb.append(l1)
        let row = lb.rowAt(0)
        #expect(row != nil)
        let noRow = lb.rowAt(99)
        #expect(noRow == nil)
    }

    @Test @MainActor func listBoxPlaceholder() {
        ensureAdwInit()
        let lb = ListBox()
        let placeholder = Label("No items")
        lb.setPlaceholder(placeholder)
        // No crash = success
    }

    // MARK: - Widget focus

    @Test @MainActor func widgetFocusable() {
        ensureAdwInit()
        let label = Label("Focus test")
        #expect(label.isFocusable == false)
        label.isFocusable = true
        #expect(label.isFocusable == true)
    }

    @Test @MainActor func widgetCanTarget() {
        ensureAdwInit()
        let btn = Button(label: "Target")
        #expect(btn.canTarget == true)
        btn.canTarget = false
        #expect(btn.canTarget == false)
    }

    // MARK: - Overlay enhancements

    @Test @MainActor func overlayClipAndMeasure() {
        ensureAdwInit()
        let overlay = Overlay()
        let main = Label("Main")
        let badge = Label("Badge")
        overlay.child = main
        overlay.addOverlay(badge)
        overlay.setClipOverlay(badge, clip: true)
        #expect(overlay.getClipOverlay(badge) == true)
        overlay.setMeasureOverlay(badge, measure: true)
        #expect(overlay.getMeasureOverlay(badge) == true)
    }

    // MARK: - MenuButton popover property

    @Test @MainActor func menuButtonPopover() {
        ensureAdwInit()
        let btn = MenuButton()
        #expect(btn.popover == nil)
        let popover = Popover()
        btn.popover = popover
        #expect(btn.popover != nil)
    }

    // MARK: - Application signals

    @Test @MainActor func applicationSignals() {
        ensureAdwInit()
        let app = Application(id: "com.test.signals")
        // Just verify signal connection doesn't crash
        app.onStartup {}
        app.onShutdown {}
    }

    // MARK: - AspectFrame

    @Test @MainActor func aspectFrameCreation() {
        ensureAdwInit()
        let af = AspectFrame(xalign: 0.5, yalign: 0.5, ratio: 16.0/9.0)
        #expect(af.ratio > 1.7 && af.ratio < 1.8)
        #expect(af.obeyChild == false)
    }

    @Test @MainActor func aspectFrameProperties() {
        ensureAdwInit()
        let af = AspectFrame()
        af.xalign = 0.0
        #expect(af.xalign == 0.0)
        af.yalign = 1.0
        #expect(af.yalign == 1.0)
        af.ratio = 2.0
        #expect(af.ratio == 2.0)
        af.obeyChild = true
        #expect(af.obeyChild == true)
        let label = Label("Child")
        af.child = label
        #expect(af.child != nil)
    }

    // MARK: - StackSwitcher

    @Test @MainActor func stackSwitcherCreation() {
        ensureAdwInit()
        let sw = StackSwitcher()
        #expect(sw.stack == nil)
    }

    @Test @MainActor func stackSwitcherWithStack() {
        ensureAdwInit()
        let sw = StackSwitcher()
        let stack = Stack()
        sw.stack = stack
        #expect(sw.stack != nil)
    }

    // MARK: - WindowControls

    @Test @MainActor func windowControlsCreation() {
        ensureAdwInit()
        let wc = WindowControls(side: .end)
        #expect(wc.side == .end)
    }

    @Test @MainActor func windowControlsProperties() {
        ensureAdwInit()
        let wc = WindowControls()
        wc.side = .start
        #expect(wc.side == .start)
        wc.decorationLayout = "close"
        #expect(wc.decorationLayout == "close")
    }

    // MARK: - MediaControls

    @Test @MainActor func mediaControlsCreation() {
        ensureAdwInit()
        let mc = MediaControls()
        #expect(mc.mediaStream == nil)
    }

    // MARK: - Widget cursor

    @Test @MainActor func widgetCursor() {
        ensureAdwInit()
        let btn = Button(label: "Cursor")
        btn.setCursor(name: "pointer")
        btn.resetCursor()
        // No crash = success
    }

    // MARK: - Widget tick callback

    @Test @MainActor func widgetTickCallback() {
        ensureAdwInit()
        let label = Label("Tick")
        let id = label.addTickCallback { false } // immediately removes itself
        // Can also remove manually
        label.removeTickCallback(id)
    }

    // MARK: - Widget accessibility

    @Test @MainActor func widgetAccessibility() {
        ensureAdwInit()
        let btn = Button(label: "Accessible")
        btn.setAccessibleLabel("My Button")
        btn.setAccessibleDescription("A test button")
        _ = btn.accessibleRole
        // No crash = success
    }

    // MARK: - FlowBox enhancements

    @Test @MainActor func flowBoxSignals() {
        ensureAdwInit()
        let fb = FlowBox()
        fb.activateOnSingleClick = true
        #expect(fb.activateOnSingleClick == true)
        fb.onChildActivated {}
        fb.onSelectedChildrenChanged {}
        // No crash = success
    }

    @Test @MainActor func flowBoxSelectAll() {
        ensureAdwInit()
        let fb = FlowBox()
        fb.selectionMode = .multiple
        fb.append(Label("A"))
        fb.append(Label("B"))
        fb.selectAll()
        fb.unselectAll()
        // No crash = success
    }

    // MARK: - CallbackAnimationTarget convenience

    @Test @MainActor func callbackAnimationTargetConvenience() {
        ensureAdwInit()
        var received = false
        let target = CallbackAnimationTarget { _ in
            received = true
        }
        _ = target
        // No crash creating target = success
    }

    // MARK: - CSSProvider convenience

    @Test @MainActor func cssProviderLoadGlobal() {
        ensureAdwInit()
        let provider = CSSProvider.loadGlobal("button { color: red; }")
        provider.removeFromDefaultDisplay()
        // No crash = success
    }

    // MARK: - GtkPackType enum

    @Test @MainActor func packTypeEnum() {
        #expect(GtkPackType.start == GTK_PACK_START)
        #expect(GtkPackType.end == GTK_PACK_END)
    }

    // MARK: - Batch 7: Entry enhancements

    @Test @MainActor func entryHasFrame() {
        ensureAdwInit()
        let entry = Entry()
        #expect(entry.hasFrame == true)
        entry.hasFrame = false
        #expect(entry.hasFrame == false)
    }

    @Test @MainActor func entryAlignment() {
        ensureAdwInit()
        let entry = Entry()
        entry.alignment = 0.5
        #expect(entry.alignment == 0.5)
        entry.alignment = 1.0
        #expect(entry.alignment == 1.0)
    }

    @Test @MainActor func entryActivatesDefault() {
        ensureAdwInit()
        let entry = Entry()
        #expect(entry.activatesDefault == false)
        entry.activatesDefault = true
        #expect(entry.activatesDefault == true)
    }

    @Test @MainActor func entryProgressFraction() {
        ensureAdwInit()
        let entry = Entry()
        #expect(entry.progressFraction == 0.0)
        entry.progressFraction = 0.5
        #expect(entry.progressFraction == 0.5)
    }

    @Test @MainActor func entryProgressPulse() {
        ensureAdwInit()
        let entry = Entry()
        entry.progressPulseStep = 0.2
        #expect(entry.progressPulseStep == 0.2)
        entry.progressPulse()
        // No crash = success
    }

    @Test @MainActor func entryInputPurpose() {
        ensureAdwInit()
        let entry = Entry()
        entry.inputPurpose = .email
        #expect(entry.inputPurpose == GtkInputPurpose.email)
        entry.inputPurpose = .password
        #expect(entry.inputPurpose == GtkInputPurpose.password)
    }

    @Test @MainActor func entryIcons() {
        ensureAdwInit()
        let entry = Entry()
        entry.setIcon(position: .primary, iconName: "edit-find-symbolic")
        #expect(entry.iconName(at: .primary) == "edit-find-symbolic")
        entry.setIcon(position: .secondary, iconName: "edit-clear-symbolic")
        #expect(entry.iconName(at: .secondary) == "edit-clear-symbolic")
    }

    @Test @MainActor func entryIconTooltipAndActivatable() {
        ensureAdwInit()
        let entry = Entry()
        entry.setIcon(position: .primary, iconName: "edit-find-symbolic")
        entry.setIconTooltip(position: .primary, tooltip: "Search")
        entry.setIconActivatable(position: .primary, activatable: true)
        // No crash = success
    }

    @Test @MainActor func entryIconPressSignal() {
        ensureAdwInit()
        let entry = Entry()
        entry.onIconPress { _ in }
        // No crash = success
    }

    // MARK: - Scale marks

    @Test @MainActor func scaleAddMark() {
        ensureAdwInit()
        let scale = Scale(orientation: .horizontal, min: 0, max: 100, step: 1)
        scale.addMark(value: 0, position: .top, markup: "0")
        scale.addMark(value: 50, position: .top, markup: "50")
        scale.addMark(value: 100, position: .top, markup: "100")
        // No crash = success
    }

    @Test @MainActor func scaleClearMarks() {
        ensureAdwInit()
        let scale = Scale(orientation: .horizontal, min: 0, max: 10, step: 1)
        scale.addMark(value: 5, position: .bottom)
        scale.clearMarks()
        // No crash = success
    }

    // MARK: - Label enhancements

    @Test @MainActor func labelYalign() {
        ensureAdwInit()
        let label = Label("Test")
        label.yalign = 0.0
        #expect(label.yalign == 0.0)
        label.yalign = 1.0
        #expect(label.yalign == 1.0)
    }

    @Test @MainActor func labelMaxWidthChars() {
        ensureAdwInit()
        let label = Label("Test")
        label.maxWidthChars = 20
        #expect(label.maxWidthChars == 20)
    }

    @Test @MainActor func labelWidthChars() {
        ensureAdwInit()
        let label = Label("Test")
        label.widthChars = 10
        #expect(label.widthChars == 10)
    }

    @Test @MainActor func labelLines() {
        ensureAdwInit()
        let label = Label("Test")
        label.lines = 3
        #expect(label.lines == 3)
    }

    @Test @MainActor func labelMnemonicWidget() {
        ensureAdwInit()
        let label = Label("_Test")
        label.useUnderline = true
        #expect(label.useUnderline == true)
        let entry = Entry()
        label.mnemonicWidget = entry
        #expect(label.mnemonicWidget != nil)
    }

    @Test @MainActor func labelNaturalWrapMode() {
        ensureAdwInit()
        let label = Label("Test")
        label.naturalWrapMode = .word
        #expect(label.naturalWrapMode == GtkNaturalWrapMode.word)
    }

    // MARK: - ListBox sort/filter

    @Test @MainActor func listBoxSortFunc() {
        ensureAdwInit()
        let list = ListBox()
        list.append(Label("B"))
        list.append(Label("A"))
        list.setSortFunc { _, _ in 0 }
        list.invalidateSort()
        list.clearSortFunc()
        // No crash = success
    }

    @Test @MainActor func listBoxFilterFunc() {
        ensureAdwInit()
        let list = ListBox()
        list.append(Label("Visible"))
        list.append(Label("Hidden"))
        list.setFilterFunc { _ in true }
        list.invalidateFilter()
        list.clearFilterFunc()
        // No crash = success
    }

    // MARK: - Widget size queries

    @Test @MainActor func widgetWidthHeight() {
        ensureAdwInit()
        let label = Label("Test")
        // Before layout, width/height are 0
        #expect(label.width >= 0)
        #expect(label.height >= 0)
    }

    @Test @MainActor func widgetCssName() {
        ensureAdwInit()
        let label = Label("Test")
        #expect(!label.cssName.isEmpty)
    }

    // MARK: - Box reorder

    @Test @MainActor func boxReorderChildAfter() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let a = Label("A")
        let b = Label("B")
        let c = Label("C")
        box.append(a)
        box.append(b)
        box.append(c)
        // Move A after C
        box.reorderChildAfter(a, sibling: c)
        // No crash = success
    }

    // MARK: - Image enhancements

    @Test @MainActor func imageFromResource() {
        ensureAdwInit()
        let img = Image()
        img.setFromResource(nil)
        // No crash = success
    }

    @Test @MainActor func imageClear() {
        ensureAdwInit()
        let img = Image(iconName: "dialog-information-symbolic")
        img.clear()
        // After clearing, icon should be nil
        #expect(img.iconName == nil)
    }

    // MARK: - ToolbarView edge extension

    @Test @MainActor func toolbarViewExtendContentToEdges() {
        ensureAdwInit()
        let tv = ToolbarView()
        #expect(tv.extendContentToTopEdge == false)
        tv.extendContentToTopEdge = true
        #expect(tv.extendContentToTopEdge == true)
        #expect(tv.extendContentToBottomEdge == false)
        tv.extendContentToBottomEdge = true
        #expect(tv.extendContentToBottomEdge == true)
    }

    // MARK: - MainContext delay

    @Test @MainActor func mainContextDelay() {
        ensureAdwInit()
        // Just verify it compiles and doesn't crash
        // (actual execution requires the main loop)
        var called = false
        MainContext.delay(ms: 1) { called = true }
        _ = called
    }

    // MARK: - New enum extensions

    @Test @MainActor func inputPurposeEnum() {
        #expect(GtkInputPurpose.freeForm == GTK_INPUT_PURPOSE_FREE_FORM)
        #expect(GtkInputPurpose.digits == GTK_INPUT_PURPOSE_DIGITS)
        #expect(GtkInputPurpose.number == GTK_INPUT_PURPOSE_NUMBER)
        #expect(GtkInputPurpose.phone == GTK_INPUT_PURPOSE_PHONE)
        #expect(GtkInputPurpose.url == GTK_INPUT_PURPOSE_URL)
        #expect(GtkInputPurpose.email == GTK_INPUT_PURPOSE_EMAIL)
        #expect(GtkInputPurpose.password == GTK_INPUT_PURPOSE_PASSWORD)
        #expect(GtkInputPurpose.pin == GTK_INPUT_PURPOSE_PIN)
        #expect(GtkInputPurpose.terminal == GTK_INPUT_PURPOSE_TERMINAL)
    }

    @Test @MainActor func entryIconPositionEnum() {
        #expect(GtkEntryIconPosition.primary == GTK_ENTRY_ICON_PRIMARY)
        #expect(GtkEntryIconPosition.secondary == GTK_ENTRY_ICON_SECONDARY)
    }

    @Test @MainActor func naturalWrapModeEnum() {
        #expect(GtkNaturalWrapMode.inherit == GTK_NATURAL_WRAP_INHERIT)
        #expect(GtkNaturalWrapMode.none == GTK_NATURAL_WRAP_NONE)
        #expect(GtkNaturalWrapMode.word == GTK_NATURAL_WRAP_WORD)
    }

    // MARK: - Batch 8: SplitButton menuModel/popover

    @Test @MainActor func splitButtonMenuModel() {
        ensureAdwInit()
        let btn = SplitButton()
        let menu = GMenuRef()
        menu.append("Test", action: "app.test")
        btn.setMenuModel(menu)
        // No crash = success
    }

    @Test @MainActor func splitButtonPopover() {
        ensureAdwInit()
        let btn = SplitButton()
        let pop = Popover()
        pop.child = Label("Custom")
        btn.setPopover(pop)
        // No crash = success
    }

    @Test @MainActor func splitButtonClickedSignal() {
        ensureAdwInit()
        let btn = SplitButton()
        btn.label = "Test"
        btn.onClicked {}
        btn.onActivate {}
        // No crash = success
    }

    // MARK: - PreferencesDialog add/remove

    @Test @MainActor func preferencesDialogAddRemove() {
        ensureAdwInit()
        let dialog = PreferencesDialog()
        let page = PreferencesPage()
        page.title = "General"
        dialog.add(page)
        dialog.remove(page)
        // No crash = success
    }

    // MARK: - CheckButton enhancements

    @Test @MainActor func checkButtonInconsistent() {
        ensureAdwInit()
        let check = CheckButton(label: "Test")
        #expect(check.inconsistent == false)
        check.inconsistent = true
        #expect(check.inconsistent == true)
    }

    @Test @MainActor func checkButtonChild() {
        ensureAdwInit()
        let check = CheckButton()
        let label = Label("Custom child")
        check.child = label
        #expect(check.child != nil)
    }

    @Test @MainActor func checkButtonUseUnderline() {
        ensureAdwInit()
        let check = CheckButton(label: "_Mnemonic")
        check.useUnderline = true
        #expect(check.useUnderline == true)
    }

    // MARK: - DropDown showArrow

    @Test @MainActor func dropDownShowArrow() {
        ensureAdwInit()
        let dd = DropDown(strings: ["A", "B"])
        #expect(dd.showArrow == true)
        dd.showArrow = false
        #expect(dd.showArrow == false)
    }

    // MARK: - SearchEntry searchDelay

    @Test @MainActor func searchEntryDelay() {
        ensureAdwInit()
        let entry = SearchEntry()
        entry.searchDelay = 500
        #expect(entry.searchDelay == 500)
    }

    // MARK: - ToggleButton enhancements

    @Test @MainActor func toggleButtonChild() {
        ensureAdwInit()
        let btn = ToggleButton()
        let label = Label("Custom")
        btn.child = label
        #expect(btn.child != nil)
    }

    @Test @MainActor func toggleButtonHasFrame() {
        ensureAdwInit()
        let btn = ToggleButton(label: "Test")
        #expect(btn.hasFrame == true)
        btn.hasFrame = false
        #expect(btn.hasFrame == false)
    }

    // MARK: - Widget tree navigation

    @Test @MainActor func widgetParent() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let label = Label("Child")
        box.append(label)
        #expect(label.parent != nil)
    }

    @Test @MainActor func widgetFirstLastChild() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let a = Label("A")
        let b = Label("B")
        box.append(a)
        box.append(b)
        #expect(box.firstChild != nil)
        #expect(box.lastChild != nil)
    }

    @Test @MainActor func widgetSiblings() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let a = Label("A")
        let b = Label("B")
        box.append(a)
        box.append(b)
        #expect(a.nextSibling != nil)
        #expect(b.prevSibling != nil)
    }

    @Test @MainActor func widgetActivate() {
        ensureAdwInit()
        let btn = Button(label: "Test")
        // activate() on a button without a parent returns false
        let result = btn.activate()
        _ = result
        // No crash = success
    }

    // MARK: - TextView onChanged

    @Test @MainActor func textViewOnChanged() {
        ensureAdwInit()
        let tv = TextView()
        var changed = false
        tv.onChanged { changed = true }
        tv.text = "Hello"
        #expect(changed == true)
    }

    // MARK: - Batch 9: Widget CSS helpers

    @Test @MainActor func widgetHasCSSClass() {
        ensureAdwInit()
        let label = Label("test")
        label.addCSSClass("dim-label")
        #expect(label.hasCSSClass("dim-label") == true)
        #expect(label.hasCSSClass("nonexistent") == false)
    }

    @Test @MainActor func widgetCSSClassesGetSet() {
        ensureAdwInit()
        let label = Label("test")
        label.cssClasses = ["bold", "accent"]
        let classes = label.cssClasses
        #expect(classes.contains("bold"))
        #expect(classes.contains("accent"))
    }

    @Test @MainActor func widgetOverflow() {
        ensureAdwInit()
        let label = Label("test")
        label.overflow = .hidden
        #expect(label.overflow == GtkOverflow.hidden)
        label.overflow = .visible
        #expect(label.overflow == GtkOverflow.visible)
    }

    // MARK: - Breakpoint addSetter overloads

    @Test @MainActor func breakpointAddSetterBool() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "max-width: 500px")
        let bp = Breakpoint(condition: cond)
        let label = Label("test")
        // Should not crash
        bp.addSetter(label, property: "visible", value: false)
    }

    @Test @MainActor func breakpointAddSetterInt() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "max-width: 500px")
        let bp = Breakpoint(condition: cond)
        let box = Box(orientation: .vertical, spacing: 0)
        bp.addSetter(box, property: "spacing", value: 12)
    }

    @Test @MainActor func breakpointAddSetterString() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "max-width: 500px")
        let bp = Breakpoint(condition: cond)
        let label = Label("original")
        bp.addSetter(label, property: "label", value: "compact")
    }

    @Test @MainActor func breakpointAddSetterDouble() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "max-width: 500px")
        let bp = Breakpoint(condition: cond)
        let label = Label("test")
        bp.addSetter(label, property: "opacity", value: 0.5)
    }

    // MARK: - Application lifecycle

    @Test @MainActor func applicationLifecycleMethods() {
        ensureAdwInit()
        let app = Application(id: "com.test.lifecycle")
        // hold/release should not crash
        app.hold()
        app.release()
    }

    // MARK: - TextTag

    @Test @MainActor func textTagCreation() {
        ensureAdwInit()
        let tag = TextTag(name: "bold")
        _ = tag
        // No crash = success
    }

    @Test @MainActor func textTagWeight() {
        ensureAdwInit()
        let buf = TextBuffer()
        let tag = buf.createTag(name: "bold")
        tag.weight = 700
        #expect(tag.weight == 700)
    }

    @Test @MainActor func textTagStrikethrough() {
        ensureAdwInit()
        let buf = TextBuffer()
        let tag = buf.createTag(name: "strike")
        tag.strikethrough = true
        #expect(tag.strikethrough == true)
    }

    @Test @MainActor func textTagScale() {
        ensureAdwInit()
        let buf = TextBuffer()
        let tag = buf.createTag(name: "big")
        tag.scale = 1.5
        #expect(tag.scale > 1.4 && tag.scale < 1.6)
    }

    @Test @MainActor func textTagSizePoints() {
        ensureAdwInit()
        let buf = TextBuffer()
        let tag = buf.createTag(name: "sized")
        tag.sizePoints = 24.0
        #expect(tag.sizePoints > 23.9 && tag.sizePoints < 24.1)
    }

    // MARK: - TextBuffer tags

    @Test @MainActor func textBufferCreateAndApplyTag() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Hello World"
        let tag = buf.createTag(name: "highlight")
        tag.weight = 700
        buf.applyTag(tag, startOffset: 0, endOffset: 5)
        // No crash = success
    }

    @Test @MainActor func textBufferRemoveTag() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Hello World"
        let tag = buf.createTag(name: "temp")
        buf.applyTag(tag, startOffset: 0, endOffset: 5)
        buf.removeTag(tag, startOffset: 0, endOffset: 5)
        // No crash = success
    }

    @Test @MainActor func textBufferRemoveAllTags() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Hello World"
        let tag1 = buf.createTag(name: "a")
        let tag2 = buf.createTag(name: "b")
        buf.applyTag(tag1, startOffset: 0, endOffset: 5)
        buf.applyTag(tag2, startOffset: 0, endOffset: 5)
        buf.removeAllTags(startOffset: 0, endOffset: 5)
        // No crash = success
    }

    // MARK: - AdwEasing extended values

    @Test @MainActor func adwEasingExtendedValues() {
        // Verify all easing enum extensions are distinct values
        let easings: [AdwEasing] = [
            .easeInQuad, .easeOutQuad, .easeInOutQuad,
            .easeInQuart, .easeOutQuart, .easeInOutQuart,
            .easeInQuint, .easeOutQuint, .easeInOutQuint,
            .easeInBounce, .easeOutBounce, .easeInOutBounce,
        ]
        // All should be distinct
        let unique = Set(easings.map { $0.rawValue })
        #expect(unique.count == 12)
    }

    // MARK: - GtkOverflow enum

    @Test @MainActor func gtkOverflowEnum() {
        #expect(GtkOverflow.visible != GtkOverflow.hidden)
    }

    // MARK: - LevelBar offsets

    @Test @MainActor func levelBarOffsetValues() {
        ensureAdwInit()
        let bar = LevelBar()
        bar.addOffsetValue(name: "custom-low", value: 0.25)
        bar.addOffsetValue(name: "custom-high", value: 0.75)
        // No crash = success
        bar.removeOffsetValue(name: "custom-low")
        bar.removeOffsetValue(name: "custom-high")
    }

    // MARK: - AdwAnimationState enum

    @Test @MainActor func adwAnimationStateEnum() {
        let states: [AdwAnimationState] = [.idle, .paused, .playing, .finished]
        let unique = Set(states.map { $0.rawValue })
        #expect(unique.count == 4)
    }
}
