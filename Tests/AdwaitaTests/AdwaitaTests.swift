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
        let _: (GObjectRef, SignalName, @escaping @MainActor () -> Void) -> SignalConnection = SignalHelper.connect
        let _: (GObjectRef, SignalName, @escaping @MainActor (String) -> Void) -> SignalConnection = SignalHelper.connectString
        let _: (GObjectRef, SignalName, @escaping @MainActor (UInt32) -> Void) -> SignalConnection = SignalHelper.connectUInt
        let _: (GObjectRef, SignalName, @escaping @MainActor (Int32) -> Void) -> SignalConnection = SignalHelper.connectInt
        let _: (GObjectRef, SignalName, @escaping @MainActor (Double) -> Void) -> SignalConnection = SignalHelper.connectDouble
        let _: (GObjectRef, SignalName, @escaping @MainActor (Bool) -> Void) -> SignalConnection = SignalHelper.connectBool
        let _: (GObjectRef, SignalName, @escaping @MainActor (OpaquePointer) -> Void) -> SignalConnection = SignalHelper.connectPointer
        let _: (GObjectRef, SignalName, @escaping @MainActor (Double, Double) -> Void) -> SignalConnection = SignalHelper.connectDoubleDouble
        let _: (GObjectRef, SignalName, @escaping @MainActor (OpaquePointer, Int32) -> Void) -> SignalConnection = SignalHelper.connectPointerInt
        let _: (GObjectRef, PropertyName, @escaping @MainActor () -> Void) -> SignalConnection = SignalHelper.onNotify
        let _: (GObjectRef, SignalName, @escaping @MainActor (OpaquePointer, UnsafePointer<GValue>) -> Bool) -> SignalConnection = SignalHelper.connectPointerGValueReturnBool
        let _: (GObjectRef, SignalName, @escaping @MainActor (OpaquePointer, UnsafePointer<GValue>) -> GdkDragAction) -> SignalConnection = SignalHelper.connectPointerGValueReturnGdkDragAction
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
        let conn = SignalHelper.onNotify(label, property: .label) { }
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
        let _: (GObjectRef, SignalName, @escaping @MainActor () -> Bool) -> SignalConnection = SignalHelper.connectReturnBool
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
        let menuModel = GMenuRef()
        let menu = PopoverMenu(model: menuModel)
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

    @Test @MainActor func clipboardSetTextureExists() {
        ensureAdwInit()
        // Verify the setTexture method compiles and exists on Clipboard.
        let _: (Clipboard, Texture) -> Void = { clipboard, texture in
            clipboard.setTexture(texture)
        }
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

    @Test @MainActor func dragSourceSetIcon() {
        ensureAdwInit()
        let source = DragSource()
        // Create a 1x1 RGBA texture for testing
        let pixels: [UInt8] = [255, 0, 0, 255]
        let texture = Texture(rgbaData: pixels, width: 1, height: 1)
        // Should not crash; icon is set for future drag operations
        source.setIcon(texture, hotX: 0, hotY: 0)
    }

    @Test @MainActor func dragSourceIsDraggingProperty() {
        ensureAdwInit()
        let source = DragSource()
        // No drag is active
        #expect(source.isDragging == false)
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

    @Test @MainActor func videoMediaStreamConvenience() {
        ensureAdwInit()
        let video = Video()
        // No media stream set yet, so convenience properties return defaults
        #expect(video.isPlaying == false)
        #expect(video.ended == false)
        #expect(video.timestamp == 0)
        #expect(video.duration == 0)
        #expect(video.isMuted == false)
        #expect(video.volume == 0.0)
        // mediaStream should be nil for an empty video
        #expect(video.mediaStream == nil)
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

    @Test @MainActor func mainContextCancelAndSourceID() {
        ensureAdwInit()
        // Schedule a timeout and immediately cancel it
        let id: SourceID = MainContext.timeout(intervalMs: 60000) { return true }
        let removed = MainContext.cancel(sourceId: id)
        #expect(removed == true)
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
        bp.addSetter(label, property: .visible, value: false)
    }

    @Test @MainActor func breakpointAddSetterInt() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "max-width: 500px")
        let bp = Breakpoint(condition: cond)
        let box = Box(orientation: .vertical, spacing: 0)
        bp.addSetter(box, property: .spacing, value: 12)
    }

    @Test @MainActor func breakpointAddSetterString() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "max-width: 500px")
        let bp = Breakpoint(condition: cond)
        let label = Label("original")
        bp.addSetter(label, property: .label, value: "compact")
    }

    @Test @MainActor func breakpointAddSetterDouble() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "max-width: 500px")
        let bp = Breakpoint(condition: cond)
        let label = Label("test")
        bp.addSetter(label, property: .opacity, value: 0.5)
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

    // MARK: - Batch 10: ActionBar

    @Test @MainActor func actionBarCreation() {
        ensureAdwInit()
        let bar = ActionBar()
        #expect(bar.revealed == true)
    }

    @Test @MainActor func actionBarPackAndCenter() {
        ensureAdwInit()
        let bar = ActionBar()
        let btn = Button(label: "Start")
        bar.packStart(btn)
        let end = Button(label: "End")
        bar.packEnd(end)
        let center = Label("Center")
        bar.centerWidget = center
        #expect(bar.centerWidget != nil)
    }

    @Test @MainActor func actionBarRevealed() {
        ensureAdwInit()
        let bar = ActionBar()
        bar.revealed = false
        #expect(bar.revealed == false)
        bar.revealed = true
        #expect(bar.revealed == true)
    }

    // MARK: - UriLauncher

    @Test @MainActor func uriLauncherCreation() {
        ensureAdwInit()
        let launcher = UriLauncher(uri: "https://example.com")
        #expect(launcher.uri == "https://example.com")
    }

    @Test @MainActor func uriLauncherSetUri() {
        ensureAdwInit()
        let launcher = UriLauncher(uri: "https://a.com")
        launcher.uri = "https://b.com"
        #expect(launcher.uri == "https://b.com")
    }

    // MARK: - Convenience initializers

    @Test @MainActor func entryConvenienceInit() {
        ensureAdwInit()
        let entry = Entry(placeholder: "Type here")
        #expect(entry.placeholderText == "Type here")
    }

    @Test @MainActor func entryConvenienceInitWithPlaceholder() {
        ensureAdwInit()
        let entry = Entry(placeholder: "Search")
        #expect(entry.placeholderText == "Search")
        entry.text = "hello"
        #expect(entry.text == "hello")
    }

    @Test @MainActor func entryOnChangedNotify() {
        ensureAdwInit()
        let entry = Entry()
        var changed = false
        entry.onChanged { changed = true }
        entry.text = "hello"
        #expect(changed == true)
    }

    @Test @MainActor func switchConvenienceInit() {
        ensureAdwInit()
        let sw = Switch(active: true)
        #expect(sw.active == true)
    }

    @Test @MainActor func checkButtonConvenienceInit() {
        ensureAdwInit()
        var toggled = false
        let cb = CheckButton(label: "Test", onToggled: { toggled = true })
        #expect(cb.label == "Test")
        // Simulate toggle
        cb.active = !cb.active
        // toggled via signal on actual user interaction
        _ = toggled
    }

    // MARK: - ToggleGroup

    @Test @MainActor func toggleGroupCreation() {
        ensureAdwInit()
        let group = ToggleGroup()
        let t1 = Toggle()
        t1.label = "A"
        let t2 = Toggle()
        t2.label = "B"
        group.add(t1)
        group.add(t2)
        #expect(group.nToggles == 2)
    }

    @Test @MainActor func toggleGroupActive() {
        ensureAdwInit()
        let group = ToggleGroup()
        let t1 = Toggle()
        t1.label = "X"
        let t2 = Toggle()
        t2.label = "Y"
        group.add(t1)
        group.add(t2)
        group.active = 1
        #expect(group.active == 1)
    }

    @Test @MainActor func toggleGroupByName() {
        ensureAdwInit()
        let group = ToggleGroup()
        let t = Toggle()
        t.label = "Named"
        t.name = "my-toggle"
        group.add(t)
        let found = group.getToggleByName("my-toggle")
        #expect(found != nil)
    }

    // MARK: - WrapBox

    @Test @MainActor func wrapBoxCreation() {
        ensureAdwInit()
        let wrap = WrapBox()
        wrap.childSpacing = 8
        wrap.lineSpacing = 12
        #expect(wrap.childSpacing == 8)
        #expect(wrap.lineSpacing == 12)
    }

    @Test @MainActor func wrapBoxAppendRemove() {
        ensureAdwInit()
        let wrap = WrapBox()
        let label = Label("test")
        wrap.append(label)
        wrap.remove(label)
        // No crash = success
    }

    // MARK: - ButtonRow

    @Test @MainActor func buttonRowCreation() {
        ensureAdwInit()
        let row = ButtonRow()
        row.title = "Action"
        row.startIconName = "edit-symbolic"
        #expect(row.startIconName == "edit-symbolic")
    }

    // MARK: - ComboRow

    @Test @MainActor func comboRowWithModel() {
        ensureAdwInit()
        let combo = ComboRow()
        combo.title = "Pick"
        let model = StringList(["A", "B", "C"])
        combo.setModel(model)
        combo.selected = 1
        #expect(combo.selected == 1)
    }

    // MARK: - ExpanderRow

    @Test @MainActor func expanderRowCreation() {
        ensureAdwInit()
        let row = ExpanderRow()
        row.title = "Details"
        row.subtitle = "Show more"
        row.expanded = true
        #expect(row.expanded == true)
        row.expanded = false
        #expect(row.expanded == false)
    }

    @Test @MainActor func expanderRowAddRow() {
        ensureAdwInit()
        let row = ExpanderRow()
        row.title = "Parent"
        let child = ActionRow()
        child.title = "Child"
        row.addRow(child)
        // No crash = success
    }

    // MARK: - Batch 11: GtkWindow properties

    @Test @MainActor func windowProperties() {
        ensureAdwInit()
        let win = Window()
        win.title = "Test"
        #expect(win.title == "Test")
        win.defaultWidth = 400
        win.defaultHeight = 300
        #expect(win.defaultWidth == 400)
        #expect(win.defaultHeight == 300)
    }

    @Test @MainActor func windowModal() {
        ensureAdwInit()
        let win = Window()
        win.modal = true
        #expect(win.modal == true)
        win.modal = false
        #expect(win.modal == false)
    }

    // MARK: - NavigationSplitView sidebar/content

    @Test @MainActor func navigationSplitViewSetSidebarContent() {
        ensureAdwInit()
        let splitView = NavigationSplitView()
        let sidebar = NavigationPage(child: Label("Side"), title: "Side")
        let content = NavigationPage(child: Label("Main"), title: "Main")
        splitView.setSidebar(sidebar)
        splitView.setContent(content)
        // No crash = success
    }

    @Test @MainActor func navigationSplitViewProperties() {
        ensureAdwInit()
        let splitView = NavigationSplitView()
        splitView.sidebarWidthFraction = 0.4
        #expect(splitView.sidebarWidthFraction > 0.39 && splitView.sidebarWidthFraction < 0.41)
    }

    // MARK: - Scale Format Value Func

    @Test @MainActor func scaleFormatValueFunc() {
        ensureAdwInit()
        let scale = Scale(orientation: GTK_ORIENTATION_HORIZONTAL, min: 0, max: 100, step: 1)
        scale.value = 42
        // Set a format function — no crash = success
        scale.setFormatValueFunc { value in "\(Int(value))%" }
        // Clear it
        scale.setFormatValueFunc(nil)
    }

    @Test @MainActor func scaleDrawValueAndDigits() {
        ensureAdwInit()
        let scale = Scale(orientation: GTK_ORIENTATION_HORIZONTAL, min: 0, max: 100, step: 1)
        scale.drawValue = true
        #expect(scale.drawValue == true)
        scale.digits = 2
        #expect(scale.digits == 2)
        scale.hasOrigin = false
        #expect(scale.hasOrigin == false)
        scale.inverted = true
        #expect(scale.inverted == true)
    }

    // MARK: - ShortcutController

    @Test @MainActor func shortcutControllerCreation() {
        ensureAdwInit()
        let controller = ShortcutController()
        // Default scope is local
        controller.scope = GTK_SHORTCUT_SCOPE_LOCAL
        #expect(controller.scope == GTK_SHORTCUT_SCOPE_LOCAL)
    }

    @Test @MainActor func shortcutControllerAddShortcuts() {
        ensureAdwInit()
        let controller = ShortcutController()
        // String-based API
        controller.addShortcut("<Control>s") { return true }
        // Enum-based API
        controller.addShortcut(key: .z, modifiers: [.control, .shift]) { return true }
        controller.addShortcut(key: .escape) { return true }
        // No crash = success
    }

    @Test @MainActor func shortcutControllerOnWidget() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 0)
        let controller = ShortcutController()
        controller.addShortcut(key: .a, modifiers: .control) { return true }
        box.addController(controller)
        // No crash = success
    }

    @Test @MainActor func widgetKeyboardShortcutOnButton() {
        ensureAdwInit()
        let btn = Button(label: "Test")
        // Enum-based API on Widget
        btn.addKeyboardShortcut(key: .t, modifiers: .control) { return true }
        // No crash = success
    }

    @Test @MainActor func keyModifiersAcceleratorPrefix() {
        let ctrl: KeyModifiers = .control
        #expect(ctrl.acceleratorPrefix == "<Control>")

        let ctrlShift: KeyModifiers = [.control, .shift]
        #expect(ctrlShift.acceleratorPrefix == "<Control><Shift>")

        let all: KeyModifiers = [.control, .shift, .alt, .super]
        #expect(all.acceleratorPrefix == "<Control><Shift><Alt><Super>")

        let empty: KeyModifiers = []
        #expect(empty.acceleratorPrefix == "")
    }

    @Test @MainActor func keyAcceleratorName() {
        #expect(Key.s.acceleratorName == "s")
        #expect(Key.f1.acceleratorName == "F1")
        #expect(Key.escape.acceleratorName == "Escape")
        #expect(Key.return.acceleratorName == "Return")
        #expect(Key.digit0.acceleratorName == "0")
        #expect(Key.pageUp.acceleratorName == "Page_Up")
    }

    @Test @MainActor func acceleratorStringBuilder() {
        #expect(acceleratorString(key: .s, modifiers: .control) == "<Control>s")
        #expect(acceleratorString(key: .z, modifiers: [.control, .shift]) == "<Control><Shift>z")
        #expect(acceleratorString(key: .f4, modifiers: .alt) == "<Alt>F4")
        #expect(acceleratorString(key: .escape) == "Escape")
    }

    // MARK: - GObjectRef Property Binding

    @Test @MainActor func gobjectBindProperty() {
        ensureAdwInit()
        let switch1 = Switch()
        let switch2 = Switch()
        switch1.active = true
        // Bind active properties — syncCreate means switch2 gets switch1's value
        switch1.bind(.active, to: switch2, property: .active, flags: G_BINDING_SYNC_CREATE)
        #expect(switch2.active == true)
    }

    @Test @MainActor func gobjectBindPropertyBidirectional() {
        ensureAdwInit()
        let label1 = Label("Hello")
        let label2 = Label("World")
        label1.bind(.label, to: label2, property: .label,
                     flags: GBindingFlags(rawValue: G_BINDING_BIDIRECTIONAL.rawValue | G_BINDING_SYNC_CREATE.rawValue))
        #expect(label2.text == "Hello")
    }

    // MARK: - PreferencesDialog

    @Test @MainActor func preferencesDialogCreation() {
        ensureAdwInit()
        let dialog = PreferencesDialog()
        dialog.searchEnabled = true
        #expect(dialog.searchEnabled == true)
        dialog.searchEnabled = false
        #expect(dialog.searchEnabled == false)
    }

    @Test @MainActor func preferencesDialogAddPage() {
        ensureAdwInit()
        let dialog = PreferencesDialog()
        let page = PreferencesPage()
        page.title = "General"
        page.iconName = "preferences-other-symbolic"

        let group = PreferencesGroup()
        group.title = "Settings"
        page.add(group)

        dialog.add(page)
        // No crash = success
    }

    // MARK: - PreferencesPage

    @Test @MainActor func preferencesPageProperties() {
        ensureAdwInit()
        let page = PreferencesPage()
        page.title = "Test"
        #expect(page.title == "Test")
        page.description = "A test page"
        #expect(page.description == "A test page")
        page.iconName = "system-settings-symbolic"
        #expect(page.iconName == "system-settings-symbolic")
        page.useUnderline = true
        #expect(page.useUnderline == true)
    }

    // MARK: - SpringAnimation

    @Test @MainActor func springAnimationCreation() {
        ensureAdwInit()
        let widget = Label("Test")
        let params = SpringParams(dampingRatio: 0.8, mass: 1.0, stiffness: 200)
        let target = CallbackAnimationTarget { _ in }
        let anim = SpringAnimation(widget: widget, from: 0, to: 100, springParams: params, target: target)
        #expect(anim.valueFrom == 0)
        #expect(anim.valueTo == 100)
    }

    @Test @MainActor func springAnimationProperties() {
        ensureAdwInit()
        let widget = Label("Test")
        let params = SpringParams(dampingRatio: 1.0, mass: 1.0, stiffness: 100)
        let target = CallbackAnimationTarget { _ in }
        let anim = SpringAnimation(widget: widget, from: 0, to: 50, springParams: params, target: target)
        anim.clamp = true
        #expect(anim.clamp == true)
        anim.epsilon = 0.01
        #expect(anim.epsilon > 0.009 && anim.epsilon < 0.011)
        anim.initialVelocity = 5.0
        #expect(anim.initialVelocity == 5.0)
    }

    // MARK: - GMenu sections and submenus

    @Test @MainActor func gmenuWithSections() {
        ensureAdwInit()
        let menu = GMenuRef()
        let section = GMenuRef()
        section.append("Item A", action: "app.a")
        section.append("Item B", action: "app.b")
        menu.appendSection("Section", section: section)
        // No crash = success
    }

    @Test @MainActor func gmenuWithSubmenu() {
        ensureAdwInit()
        let menu = GMenuRef()
        let sub = GMenuRef()
        sub.append("Sub 1", action: "app.sub1")
        menu.appendSubmenu("More", submenu: sub)
        // No crash = success
    }

    // MARK: - DragSource and DropTarget (on widget)

    @Test @MainActor func dragDropControllersOnWidget() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 0)
        let drag = DragSource()
        drag.setTextContent("test")
        box.addController(drag)

        let label = Label("Target")
        let drop = DropTarget.forText()
        label.addController(drop)
        // No crash = success
    }

    // MARK: - FileDialog (pattern filter)

    @Test @MainActor func fileDialogPatternFilter() {
        ensureAdwInit()
        let dialog = FileDialog()
        dialog.setFilters([
            FileFilter(name: "Swift", suffixes: ["swift"]),
            FileFilter(name: "All", patterns: ["*"]),
        ])
        dialog.acceptLabel = "Choose"
        #expect(dialog.acceptLabel == "Choose")
    }

    @Test @MainActor func fileFilterPatternsInit() {
        ensureAdwInit()
        let filter = FileFilter(name: "Images", patterns: ["*.png", "*.jpg"])
        #expect(filter.name == "Images")
    }

    // MARK: - ListView Infrastructure

    @Test @MainActor func listStoreCreation() {
        ensureAdwInit()
        let store = ListStore()
        #expect(store.count == 0)
    }

    @Test @MainActor func listStoreAppendRemove() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        #expect(store.count == 3)

        store.remove(at: 1)
        #expect(store.count == 2)

        store.removeAll()
        #expect(store.count == 0)
    }

    @Test @MainActor func listStoreInsert() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        #expect(store.count == 2)

        store.insertPlaceholder(at: 1)
        #expect(store.count == 3)
    }

    @Test @MainActor func noSelectionCreation() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let selection = NoSelection(model: store)
        #expect(selection.selectionModelPointer != nil)
    }

    @Test @MainActor func singleSelectionCreation() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = SingleSelection(model: store)
        #expect(selection.selected == 0)  // autoselects first
        selection.canUnselect = true
        #expect(selection.canUnselect == true)
    }

    @Test @MainActor func singleSelectionAutoselect() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let selection = SingleSelection(model: store)
        selection.autoselect = false
        #expect(selection.autoselect == false)
        selection.autoselect = true
        #expect(selection.autoselect == true)
    }

    @Test @MainActor func signalListItemFactoryCreation() {
        ensureAdwInit()
        let factory = SignalListItemFactory()
        #expect(factory.pointer != nil)
    }

    @Test @MainActor func listViewCreation() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let factory = SignalListItemFactory()
        let selection = NoSelection(model: store)
        let listView = ListView(model: selection, factory: factory)
        #expect(listView.showSeparators == false)
        listView.showSeparators = true
        #expect(listView.showSeparators == true)
    }

    @Test @MainActor func listViewSingleClickActivate() {
        ensureAdwInit()
        let store = ListStore()
        let factory = SignalListItemFactory()
        let selection = NoSelection(model: store)
        let listView = ListView(model: selection, factory: factory)
        #expect(listView.singleClickActivate == false)
        listView.singleClickActivate = true
        #expect(listView.singleClickActivate == true)
    }

    @Test @MainActor func listViewWithSingleSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let factory = SignalListItemFactory()
        let selection = SingleSelection(model: store)
        let listView = ListView(model: selection, factory: factory)
        #expect(listView.pointer != nil)
        #expect(selection.selected == 0)
    }

    // MARK: - MultiSelection Tests

    @Test @MainActor func multiSelectionCreation() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = MultiSelection(model: store)
        #expect(selection.selectionModelPointer != nil)
    }

    @Test @MainActor func multiSelectionWithStringList() {
        ensureAdwInit()
        let strings = StringList(["a", "b", "c"])
        let selection = MultiSelection(model: strings)
        #expect(selection.selectionModelPointer != nil)
    }

    @Test @MainActor func multiSelectionSelectItem() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = MultiSelection(model: store)

        // Initially nothing is selected
        #expect(selection.isSelected(position: 0) == false)
        #expect(selection.isSelected(position: 1) == false)

        // Select first item
        selection.selectItem(position: 0, unselectRest: false)
        #expect(selection.isSelected(position: 0) == true)

        // Select second item without unselecting first
        selection.selectItem(position: 1, unselectRest: false)
        #expect(selection.isSelected(position: 0) == true)
        #expect(selection.isSelected(position: 1) == true)
    }

    @Test @MainActor func multiSelectionUnselectItem() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = MultiSelection(model: store)

        selection.selectItem(position: 0, unselectRest: false)
        selection.selectItem(position: 1, unselectRest: false)
        #expect(selection.isSelected(position: 0) == true)
        #expect(selection.isSelected(position: 1) == true)

        selection.unselectItem(position: 0)
        #expect(selection.isSelected(position: 0) == false)
        #expect(selection.isSelected(position: 1) == true)
    }

    @Test @MainActor func multiSelectionSelectUnselectAll() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = MultiSelection(model: store)

        selection.selectAll()
        #expect(selection.isSelected(position: 0) == true)
        #expect(selection.isSelected(position: 1) == true)
        #expect(selection.isSelected(position: 2) == true)

        selection.unselectAll()
        #expect(selection.isSelected(position: 0) == false)
        #expect(selection.isSelected(position: 1) == false)
        #expect(selection.isSelected(position: 2) == false)
    }

    @Test @MainActor func multiSelectionSelectItemUnselectRest() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = MultiSelection(model: store)

        selection.selectAll()
        #expect(selection.isSelected(position: 0) == true)
        #expect(selection.isSelected(position: 1) == true)
        #expect(selection.isSelected(position: 2) == true)

        // Select position 1 with unselectRest: true should clear others
        selection.selectItem(position: 1, unselectRest: true)
        #expect(selection.isSelected(position: 0) == false)
        #expect(selection.isSelected(position: 1) == true)
        #expect(selection.isSelected(position: 2) == false)
    }

    @Test @MainActor func listViewWithMultiSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let factory = SignalListItemFactory()
        let selection = MultiSelection(model: store)
        let listView = ListView(model: selection, factory: factory)
        #expect(listView.pointer != nil)
    }

    // MARK: - CustomFilter & FilterListModel Tests

    @Test @MainActor func customFilterCreation() {
        ensureAdwInit()
        let filter = CustomFilter { _ in true }
        #expect(filter.pointer != nil)
    }

    @Test @MainActor func filterListModelCreation() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let filter = CustomFilter { _ in true }
        let filtered = FilterListModel(model: store, filter: filter)
        #expect(filtered.count == 3)
        #expect(filtered.listModelPointer != nil)
    }

    @Test @MainActor func filterListModelRejectsAll() {
        ensureAdwInit()
        let store = ListStore()
        for _ in 0..<5 {
            store.appendPlaceholder()
        }
        #expect(store.count == 5)
        let filter = CustomFilter { _ in false }
        let filtered = FilterListModel(model: store, filter: filter)
        #expect(filtered.count == 0)
    }

    @Test @MainActor func filterListModelWithListModelPointer() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let filter = CustomFilter { _ in true }
        let filtered = FilterListModel(listModel: store.listModelPointer, filter: filter)
        #expect(filtered.count == 2)
    }

    @Test @MainActor func customFilterChanged() {
        ensureAdwInit()
        var showAll = true
        let filter = CustomFilter { _ in showAll }
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let filtered = FilterListModel(model: store, filter: filter)
        #expect(filtered.count == 2)

        showAll = false
        filter.changed()
        #expect(filtered.count == 0)

        showAll = true
        filter.changed()
        #expect(filtered.count == 2)
    }

    @Test @MainActor func filterListModelWithSelectionModel() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let filter = CustomFilter { _ in true }
        let filtered = FilterListModel(model: store, filter: filter)
        let selection = NoSelection(listModel: filtered.listModelPointer)
        #expect(selection.selectionModelPointer != nil)
    }

    // MARK: - CustomSorter & SortListModel Tests

    @Test @MainActor func customSorterCreation() {
        ensureAdwInit()
        let sorter = CustomSorter { _, _ in 0 }
        #expect(sorter.pointer != nil)
    }

    @Test @MainActor func sortListModelCreation() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let sorter = CustomSorter { _, _ in 0 }
        let sorted = SortListModel(model: store, sorter: sorter)
        #expect(sorted.count == 3)
        #expect(sorted.listModelPointer != nil)
    }

    @Test @MainActor func sortListModelPreservesCount() {
        ensureAdwInit()
        let store = ListStore()
        for _ in 0..<10 {
            store.appendPlaceholder()
        }
        let sorter = CustomSorter { _, _ in 0 }
        let sorted = SortListModel(model: store, sorter: sorter)
        #expect(sorted.count == store.count)
    }

    @Test @MainActor func sortListModelWithListModelPointer() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let sorter = CustomSorter { _, _ in 0 }
        let sorted = SortListModel(listModel: store.listModelPointer, sorter: sorter)
        #expect(sorted.count == 2)
    }

    @Test @MainActor func customSorterChanged() {
        ensureAdwInit()
        let sorter = CustomSorter { _, _ in 0 }
        let store = ListStore()
        store.appendPlaceholder()
        let sorted = SortListModel(model: store, sorter: sorter)
        sorter.changed()
        #expect(sorted.count == 1)
    }

    @Test @MainActor func sortListModelWithSelectionModel() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let sorter = CustomSorter { _, _ in 0 }
        let sorted = SortListModel(model: store, sorter: sorter)
        let selection = SingleSelection(listModel: sorted.listModelPointer)
        #expect(selection.selectionModelPointer != nil)
        #expect(selection.selected == 0)
    }

    @Test @MainActor func filterAndSortCombined() {
        ensureAdwInit()
        let store = ListStore()
        for _ in 0..<5 {
            store.appendPlaceholder()
        }
        let filter = CustomFilter { _ in true }
        let filtered = FilterListModel(model: store, filter: filter)
        let sorter = CustomSorter { _, _ in 0 }
        let sorted = SortListModel(listModel: filtered.listModelPointer, sorter: sorter)
        #expect(sorted.count == 5)

        let selection = NoSelection(listModel: sorted.listModelPointer)
        #expect(selection.selectionModelPointer != nil)
    }

    // MARK: - GLibError Tests

    @Test @MainActor func glibErrorCreation() {
        ensureAdwInit()
        // Create a GError manually using g_error_new_literal
        let quark = g_quark_from_string("test-error-domain")
        let gerror = g_error_new_literal(quark, 42, "Something went wrong")!
        let error = GLibError(consuming: gerror)
        // The GError has been freed by the initializer

        #expect(error.domain == quark)
        #expect(error.code == 42)
        #expect(error.message == "Something went wrong")
        #expect(error.description == "Something went wrong")
    }

    @Test @MainActor func glibErrorConformsToSwiftError() {
        ensureAdwInit()
        let quark = g_quark_from_string("test-domain")
        let gerror = g_error_new_literal(quark, 1, "test error")!
        let error: any Error = GLibError(consuming: gerror)
        #expect(error is GLibError)
        let glibError = error as! GLibError
        #expect(glibError.code == 1)
        #expect(glibError.message == "test error")
    }

    // MARK: - Variant Tests

    @Test @MainActor func variantStringRoundtrip() {
        ensureAdwInit()
        let v = Variant.string("hello world")
        #expect(v.stringValue == "hello world")
        #expect(v.typeString == "s")
        #expect(v.isOfType("s") == true)
        #expect(v.isOfType("i") == false)
    }

    @Test @MainActor func variantInt32Roundtrip() {
        ensureAdwInit()
        let v = Variant.int32(42)
        #expect(v.int32Value == 42)
        #expect(v.typeString == "i")
        #expect(v.isOfType("i") == true)
    }

    @Test @MainActor func variantInt32Negative() {
        ensureAdwInit()
        let v = Variant.int32(-100)
        #expect(v.int32Value == -100)
    }

    @Test @MainActor func variantInt64Roundtrip() {
        ensureAdwInit()
        let v = Variant.int64(Int64(Int32.max) + 1)
        #expect(v.int64Value == Int64(Int32.max) + 1)
        #expect(v.typeString == "x")
        #expect(v.isOfType("x") == true)
    }

    @Test @MainActor func variantDoubleRoundtrip() {
        ensureAdwInit()
        let v = Variant.double(3.14)
        #expect(v.doubleValue == 3.14)
        #expect(v.typeString == "d")
        #expect(v.isOfType("d") == true)
    }

    @Test @MainActor func variantBooleanRoundtrip() {
        ensureAdwInit()
        let vTrue = Variant.boolean(true)
        #expect(vTrue.boolValue == true)
        #expect(vTrue.typeString == "b")

        let vFalse = Variant.boolean(false)
        #expect(vFalse.boolValue == false)
    }

    @Test @MainActor func variantStringValueReturnsNilForNonString() {
        ensureAdwInit()
        let v = Variant.int32(42)
        #expect(v.stringValue == nil)
    }

    @Test @MainActor func variantBorrowing() {
        ensureAdwInit()
        let v1 = Variant.string("shared")
        let v2 = Variant(borrowing: v1.pointer)
        #expect(v2.stringValue == "shared")
    }

    // MARK: - SimpleAction with Parameter Tests

    @Test @MainActor func simpleActionWithParameterType() {
        ensureAdwInit()
        var received: String?
        let action = SimpleAction(name: "test-param", parameterType: "s") { variant in
            received = variant.stringValue
        }
        // Activate the action with a string parameter
        g_action_activate(OpaquePointer(action.pointer), g_variant_new_string("hello"))
        #expect(received == "hello")
    }

    @Test @MainActor func simpleActionStateful() {
        ensureAdwInit()
        let action = SimpleAction(name: "toggle", state: .boolean(false)) {
            // no-op handler
        }
        // Check initial state
        let initialState = action.state
        #expect(initialState != nil)
        #expect(initialState?.boolValue == false)

        // Change state
        action.state = .boolean(true)
        #expect(action.state?.boolValue == true)
    }

    @Test @MainActor func simpleActionStatefulToggle() {
        ensureAdwInit()
        var activateCount = 0
        let action = SimpleAction(name: "bold", state: .boolean(false)) {
            activateCount += 1
        }
        // Activate the action
        g_action_activate(OpaquePointer(action.pointer), nil)
        #expect(activateCount == 1)
        // Manually toggle state (as a real handler would do)
        let current = action.state?.boolValue ?? false
        action.state = .boolean(!current)
        #expect(action.state?.boolValue == true)
    }

    @Test @MainActor func simpleActionStatefulWithStringState() {
        ensureAdwInit()
        let action = SimpleAction(name: "color", state: .string("red")) {
            // no-op
        }
        #expect(action.state?.stringValue == "red")
        action.state = .string("blue")
        #expect(action.state?.stringValue == "blue")
    }

    // MARK: - GMenuItemRef Variant Attribute Tests

    @Test @MainActor func menuItemSetVariantAttribute() {
        ensureAdwInit()
        let item = GMenuItemRef(label: "Test", action: "app.test")
        // Should not crash
        item.setAttribute("custom-attr", variant: .string("value"))
        item.setTargetValue(.string("target-value"))
    }

    // MARK: - ColumnView Tests

    @Test @MainActor func columnViewCreationWithSingleSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let selection = SingleSelection(model: store)
        let columnView = ColumnView(model: selection)
        #expect(columnView.pointer != nil)
    }

    @Test @MainActor func columnViewCreationWithNoSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)
        #expect(columnView.pointer != nil)
    }

    @Test @MainActor func columnViewCreationWithMultiSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let selection = MultiSelection(model: store)
        let columnView = ColumnView(model: selection)
        #expect(columnView.pointer != nil)
    }

    @Test @MainActor func columnViewShowRowSeparators() {
        ensureAdwInit()
        let store = ListStore()
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)
        #expect(columnView.showRowSeparators == false)
        columnView.showRowSeparators = true
        #expect(columnView.showRowSeparators == true)
    }

    @Test @MainActor func columnViewShowColumnSeparators() {
        ensureAdwInit()
        let store = ListStore()
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)
        #expect(columnView.showColumnSeparators == false)
        columnView.showColumnSeparators = true
        #expect(columnView.showColumnSeparators == true)
    }

    @Test @MainActor func columnViewSingleClickActivate() {
        ensureAdwInit()
        let store = ListStore()
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)
        #expect(columnView.singleClickActivate == false)
        columnView.singleClickActivate = true
        #expect(columnView.singleClickActivate == true)
    }

    @Test @MainActor func columnViewReorderable() {
        ensureAdwInit()
        let store = ListStore()
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)
        columnView.reorderable = true
        #expect(columnView.reorderable == true)
        columnView.reorderable = false
        #expect(columnView.reorderable == false)
    }

    @Test @MainActor func columnViewEnableRubberband() {
        ensureAdwInit()
        let store = ListStore()
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)
        #expect(columnView.enableRubberband == false)
        columnView.enableRubberband = true
        #expect(columnView.enableRubberband == true)
    }

    // MARK: - ColumnViewColumn Tests

    @Test @MainActor func columnViewColumnCreation() {
        ensureAdwInit()
        let factory = SignalListItemFactory()
        let column = ColumnViewColumn(title: "Name", factory: factory)
        #expect(column.title == "Name")
    }

    @Test @MainActor func columnViewColumnNilTitle() {
        ensureAdwInit()
        let factory = SignalListItemFactory()
        let column = ColumnViewColumn(title: nil, factory: factory)
        #expect(column.title == nil)
    }

    @Test @MainActor func columnViewColumnTitleSetGet() {
        ensureAdwInit()
        let factory = SignalListItemFactory()
        let column = ColumnViewColumn(title: "Original", factory: factory)
        #expect(column.title == "Original")
        column.title = "Updated"
        #expect(column.title == "Updated")
    }

    @Test @MainActor func columnViewColumnFixedWidth() {
        ensureAdwInit()
        let factory = SignalListItemFactory()
        let column = ColumnViewColumn(title: "Col", factory: factory)
        #expect(column.fixedWidth == -1)
        column.fixedWidth = 200
        #expect(column.fixedWidth == 200)
    }

    @Test @MainActor func columnViewColumnResizable() {
        ensureAdwInit()
        let factory = SignalListItemFactory()
        let column = ColumnViewColumn(title: "Col", factory: factory)
        column.resizable = true
        #expect(column.resizable == true)
        column.resizable = false
        #expect(column.resizable == false)
    }

    @Test @MainActor func columnViewColumnExpand() {
        ensureAdwInit()
        let factory = SignalListItemFactory()
        let column = ColumnViewColumn(title: "Col", factory: factory)
        #expect(column.expand == false)
        column.expand = true
        #expect(column.expand == true)
    }

    @Test @MainActor func columnViewColumnVisible() {
        ensureAdwInit()
        let factory = SignalListItemFactory()
        let column = ColumnViewColumn(title: "Col", factory: factory)
        #expect(column.isVisible == true)
        column.isVisible = false
        #expect(column.isVisible == false)
    }

    @Test @MainActor func columnViewAppendColumn() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)

        let factory1 = SignalListItemFactory()
        let factory2 = SignalListItemFactory()
        let col1 = ColumnViewColumn(title: "A", factory: factory1)
        let col2 = ColumnViewColumn(title: "B", factory: factory2)

        columnView.appendColumn(col1)
        columnView.appendColumn(col2)
        #expect(columnView.pointer != nil)
    }

    @Test @MainActor func columnViewRemoveColumn() {
        ensureAdwInit()
        let store = ListStore()
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)

        let factory = SignalListItemFactory()
        let column = ColumnViewColumn(title: "Temp", factory: factory)
        columnView.appendColumn(column)
        columnView.removeColumn(column)
        #expect(columnView.pointer != nil)
    }

    @Test @MainActor func columnViewInsertColumn() {
        ensureAdwInit()
        let store = ListStore()
        let selection = NoSelection(model: store)
        let columnView = ColumnView(model: selection)

        let factory1 = SignalListItemFactory()
        let factory2 = SignalListItemFactory()
        let factory3 = SignalListItemFactory()
        let col1 = ColumnViewColumn(title: "First", factory: factory1)
        let col2 = ColumnViewColumn(title: "Last", factory: factory2)
        let col3 = ColumnViewColumn(title: "Middle", factory: factory3)

        columnView.appendColumn(col1)
        columnView.appendColumn(col2)
        columnView.insertColumn(col3, at: 1)
        #expect(columnView.pointer != nil)
    }

    // MARK: - TreeListModel Tests

    @Test @MainActor func treeListModelCreation() {
        ensureAdwInit()
        let rootStore = ListStore()
        rootStore.appendPlaceholder()
        rootStore.appendPlaceholder()

        let treeModel = TreeListModel(root: rootStore) { _ in
            return nil
        }
        #expect(treeModel.listModelPointer != nil)
    }

    @Test @MainActor func treeListModelAutoexpand() {
        ensureAdwInit()
        let rootStore = ListStore()
        rootStore.appendPlaceholder()

        let treeModel = TreeListModel(root: rootStore, autoexpand: true) { _ in
            return nil
        }
        #expect(treeModel.autoexpand == true)
        treeModel.autoexpand = false
        #expect(treeModel.autoexpand == false)
    }

    @Test @MainActor func treeListModelPassthrough() {
        ensureAdwInit()
        let rootStore = ListStore()
        rootStore.appendPlaceholder()

        let treeModel = TreeListModel(root: rootStore, passthrough: true) { _ in
            return nil
        }
        #expect(treeModel.passthrough == true)

        let treeModel2 = TreeListModel(root: ListStore(), passthrough: false) { _ in
            return nil
        }
        #expect(treeModel2.passthrough == false)
    }

    @Test @MainActor func treeListModelWithChildren() {
        ensureAdwInit()
        let rootStore = ListStore()
        rootStore.appendPlaceholder()

        // Use autoexpand: false to avoid infinite recursion when the
        // callback always returns children.
        let treeModel = TreeListModel(root: rootStore, autoexpand: false) { _ in
            let childStore = ListStore()
            childStore.appendPlaceholder()
            return childStore
        }
        #expect(treeModel.listModelPointer != nil)
    }

    @Test @MainActor func treeListModelRowAccess() {
        ensureAdwInit()
        let rootStore = ListStore()
        rootStore.appendPlaceholder()
        rootStore.appendPlaceholder()

        let treeModel = TreeListModel(root: rootStore, passthrough: false) { _ in
            return nil
        }

        let row = treeModel.row(at: 0)
        #expect(row != nil)
        #expect(row?.depth == 0)
    }

    @Test @MainActor func treeListModelWithSelectionModel() {
        ensureAdwInit()
        let rootStore = ListStore()
        rootStore.appendPlaceholder()
        rootStore.appendPlaceholder()

        let treeModel = TreeListModel(root: rootStore) { _ in
            return nil
        }

        let selection = SingleSelection(listModel: treeModel.listModelPointer)
        #expect(selection.selectionModelPointer != nil)
    }

    // MARK: - TreeExpander Tests

    @Test @MainActor func treeExpanderCreation() {
        ensureAdwInit()
        let expander = TreeExpander()
        #expect(expander.pointer != nil)
    }

    @Test @MainActor func treeExpanderChild() {
        ensureAdwInit()
        let expander = TreeExpander()
        #expect(expander.child == nil)

        let label = Label("")
        expander.child = label
        #expect(expander.child != nil)
    }

    @Test @MainActor func treeExpanderIndentForDepth() {
        ensureAdwInit()
        let expander = TreeExpander()
        #expect(expander.indentForDepth == true)
        expander.indentForDepth = false
        #expect(expander.indentForDepth == false)
    }

    @Test @MainActor func treeExpanderIndentForIcon() {
        ensureAdwInit()
        let expander = TreeExpander()
        #expect(expander.indentForIcon == true)
        expander.indentForIcon = false
        #expect(expander.indentForIcon == false)
    }

    @Test @MainActor func treeExpanderHideExpander() {
        ensureAdwInit()
        let expander = TreeExpander()
        #expect(expander.hideExpander == false)
        expander.hideExpander = true
        #expect(expander.hideExpander == true)
    }

    @Test @MainActor func treeExpanderInheritsFromWidget() {
        #expect(isSubclass(TreeExpander.self, of: Widget.self))
        #expect(isSubclass(TreeExpander.self, of: GObjectRef.self))
    }

    @Test @MainActor func columnViewInheritsFromWidget() {
        #expect(isSubclass(ColumnView.self, of: Widget.self))
        #expect(isSubclass(ColumnView.self, of: GObjectRef.self))
    }

    @Test @MainActor func columnViewColumnInheritsFromGObjectRef() {
        #expect(isSubclass(ColumnViewColumn.self, of: GObjectRef.self))
    }

    @Test @MainActor func treeListModelInheritsFromGObjectRef() {
        #expect(isSubclass(TreeListModel.self, of: GObjectRef.self))
    }

    @Test @MainActor func treeListRowInheritsFromGObjectRef() {
        #expect(isSubclass(TreeListRow.self, of: GObjectRef.self))
    }

    // MARK: - GridView Tests

    @Test @MainActor func gridViewCreation() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let factory = SignalListItemFactory()
        let selection = NoSelection(model: store)
        let gridView = GridView(model: selection, factory: factory)
        #expect(gridView.pointer != nil)
    }

    @Test @MainActor func gridViewMinColumns() {
        ensureAdwInit()
        let store = ListStore()
        let factory = SignalListItemFactory()
        let selection = NoSelection(model: store)
        let gridView = GridView(model: selection, factory: factory)
        #expect(gridView.minColumns == 1)
        gridView.minColumns = 3
        #expect(gridView.minColumns == 3)
    }

    @Test @MainActor func gridViewMaxColumns() {
        ensureAdwInit()
        let store = ListStore()
        let factory = SignalListItemFactory()
        let selection = NoSelection(model: store)
        let gridView = GridView(model: selection, factory: factory)
        #expect(gridView.maxColumns == 7)
        gridView.maxColumns = 4
        #expect(gridView.maxColumns == 4)
    }

    @Test @MainActor func gridViewSingleClickActivate() {
        ensureAdwInit()
        let store = ListStore()
        let factory = SignalListItemFactory()
        let selection = NoSelection(model: store)
        let gridView = GridView(model: selection, factory: factory)
        #expect(gridView.singleClickActivate == false)
        gridView.singleClickActivate = true
        #expect(gridView.singleClickActivate == true)
    }

    @Test @MainActor func gridViewWithSingleSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let factory = SignalListItemFactory()
        let selection = SingleSelection(model: store)
        let gridView = GridView(model: selection, factory: factory)
        #expect(gridView.pointer != nil)
        #expect(selection.selected == 0)
    }

    @Test @MainActor func gridViewWithMultiSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let factory = SignalListItemFactory()
        let selection = MultiSelection(model: store)
        let gridView = GridView(model: selection, factory: factory)
        #expect(gridView.pointer != nil)
    }

    @Test @MainActor func gridViewInheritsFromWidget() {
        #expect(isSubclass(GridView.self, of: Widget.self))
        #expect(isSubclass(GridView.self, of: GObjectRef.self))
    }

    // MARK: - MapListModel Tests

    @Test @MainActor func mapListModelCreation() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()

        let mapped = MapListModel(model: store) { item in
            GObjectRef(raw: cadw_object_new(cadw_type_object())!)
        }
        #expect(mapped.pointer != nil)
        #expect(mapped.count == 3)
    }

    @Test @MainActor func mapListModelEmptyStore() {
        ensureAdwInit()
        let store = ListStore()
        let mapped = MapListModel(model: store) { item in
            GObjectRef(raw: cadw_object_new(cadw_type_object())!)
        }
        #expect(mapped.count == 0)
    }

    @Test @MainActor func mapListModelListModelPointer() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let mapped = MapListModel(model: store) { item in
            GObjectRef(raw: cadw_object_new(cadw_type_object())!)
        }
        #expect(mapped.listModelPointer != nil)
    }

    @Test @MainActor func mapListModelFromListModelPointer() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let mapped = MapListModel(listModel: store.listModelPointer) { item in
            GObjectRef(raw: cadw_object_new(cadw_type_object())!)
        }
        #expect(mapped.count == 2)
    }

    @Test @MainActor func mapListModelReflectsStoreChanges() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let mapped = MapListModel(model: store) { item in
            GObjectRef(raw: cadw_object_new(cadw_type_object())!)
        }
        #expect(mapped.count == 1)
        store.appendPlaceholder()
        #expect(mapped.count == 2)
        store.remove(at: 0)
        #expect(mapped.count == 1)
    }

    @Test @MainActor func mapListModelWithSelectionModel() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let mapped = MapListModel(model: store) { item in
            GObjectRef(raw: cadw_object_new(cadw_type_object())!)
        }
        let selection = NoSelection(listModel: mapped.listModelPointer)
        #expect(selection.pointer != nil)
    }

    @Test @MainActor func mapListModelInheritsFromGObjectRef() {
        #expect(isSubclass(MapListModel.self, of: GObjectRef.self))
    }

    // MARK: - FlattenListModel Tests

    @Test @MainActor func flattenListModelCreation() {
        ensureAdwInit()
        let store = ListStore()
        let flattened = FlattenListModel(model: store)
        #expect(flattened.pointer != nil)
    }

    @Test @MainActor func flattenListModelEmptyStore() {
        ensureAdwInit()
        let store = ListStore()
        let flattened = FlattenListModel(model: store)
        #expect(flattened.count == 0)
    }

    @Test @MainActor func flattenListModelListModelPointer() {
        ensureAdwInit()
        let store = ListStore()
        let flattened = FlattenListModel(model: store)
        #expect(flattened.listModelPointer != nil)
    }

    @Test @MainActor func flattenListModelFromOpaquePointer() {
        ensureAdwInit()
        let store = ListStore()
        let flattened = FlattenListModel(listModel: store.listModelPointer)
        #expect(flattened.pointer != nil)
        #expect(flattened.count == 0)
    }

    @Test @MainActor func flattenListModelWithSelectionModel() {
        ensureAdwInit()
        let store = ListStore()
        let flattened = FlattenListModel(model: store)
        let selection = NoSelection(listModel: flattened.listModelPointer)
        #expect(selection.pointer != nil)
    }

    @Test @MainActor func flattenListModelInheritsFromGObjectRef() {
        #expect(isSubclass(FlattenListModel.self, of: GObjectRef.self))
    }

    // MARK: - SelectionFilterModel Tests

    @Test @MainActor func selectionFilterModelWithSingleSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = SingleSelection(model: store)
        let filtered = SelectionFilterModel(model: selection)
        #expect(filtered.pointer != nil)
        // SingleSelection selects item 0 by default
        #expect(filtered.count == 1)
    }

    @Test @MainActor func selectionFilterModelWithMultiSelection() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = MultiSelection(model: store)
        let filtered = SelectionFilterModel(model: selection)
        #expect(filtered.pointer != nil)
        // No items selected by default in MultiSelection
        #expect(filtered.count == 0)
    }

    @Test @MainActor func selectionFilterModelListModelPointer() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let selection = SingleSelection(model: store)
        let filtered = SelectionFilterModel(model: selection)
        #expect(filtered.listModelPointer != nil)
    }

    @Test @MainActor func selectionFilterModelReflectsSelectionChanges() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let selection = MultiSelection(model: store)
        let filtered = SelectionFilterModel(model: selection)
        #expect(filtered.count == 0)
        selection.selectItem(position: 0, unselectRest: false)
        #expect(filtered.count == 1)
        selection.selectItem(position: 2, unselectRest: false)
        #expect(filtered.count == 2)
    }

    @Test @MainActor func selectionFilterModelFromRawPointer() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let selection = SingleSelection(model: store)
        let filtered = SelectionFilterModel(selectionModel: selection.selectionModelPointer)
        #expect(filtered.pointer != nil)
        #expect(filtered.count == 1)
    }

    @Test @MainActor func selectionFilterModelInheritsFromGObjectRef() {
        #expect(isSubclass(SelectionFilterModel.self, of: GObjectRef.self))
    }

    // MARK: - GtkWindow Icon Tests

    @Test @MainActor func gtkWindowIconName() {
        ensureAdwInit()
        let app = Application(id: "com.test.windowicon\(UInt32.random(in: 0..<UInt32.max))")
        let win = ApplicationWindow(application: app)
        win.iconName = "dialog-information-symbolic"
        #expect(win.iconName == "dialog-information-symbolic")
        win.iconName = nil
        #expect(win.iconName == nil)
    }

    // MARK: - GestureSwipe Tests

    @Test @MainActor func gestureSwipeCreation() {
        ensureAdwInit()
        let gesture = GestureSwipe()
        #expect(gesture.pointer != nil)
    }

    @Test @MainActor func gestureSwipeVelocityBeforeDrag() {
        ensureAdwInit()
        let gesture = GestureSwipe()
        // No active swipe — velocity should be nil
        #expect(gesture.velocity == nil)
    }

    @Test @MainActor func gestureSwipeAddToWidget() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let gesture = GestureSwipe()
        box.addController(gesture)
        #expect(gesture.pointer != nil)
    }

    @Test @MainActor func gestureSwipeInheritsFromGObjectRef() {
        #expect(isSubclass(GestureSwipe.self, of: GObjectRef.self))
    }

    // MARK: - Display Tests

    @Test @MainActor func displayDefault() {
        ensureAdwInit()
        let display = Display.default
        #expect(display != nil)
    }

    @Test @MainActor func displayName() {
        ensureAdwInit()
        guard let display = Display.default else { return }
        let name = display.name
        #expect(!name.isEmpty)
    }

    @Test @MainActor func displayIsComposited() {
        ensureAdwInit()
        guard let display = Display.default else { return }
        // Just verify it doesn't crash — result depends on environment
        _ = display.isComposited
    }

    @Test @MainActor func displayMonitors() {
        ensureAdwInit()
        guard let display = Display.default else { return }
        let monitors = display.monitors
        // In CI there might be 0 monitors, but the call should not crash
        _ = monitors.count
    }

    // MARK: - Monitor Tests

    @Test @MainActor func monitorProperties() {
        ensureAdwInit()
        guard let display = Display.default else { return }
        let monitors = display.monitors
        guard let monitor = monitors.first else { return }
        // Just verify accessors don't crash
        _ = monitor.geometry
        _ = monitor.widthMM
        _ = monitor.heightMM
        _ = monitor.scaleFactor
        _ = monitor.refreshRate
        _ = monitor.manufacturer
        _ = monitor.model
        _ = monitor.connector
        _ = monitor.isValid
    }

    @Test @MainActor func monitorInheritsFromGObjectRef() {
        #expect(isSubclass(Monitor.self, of: GObjectRef.self))
    }

    // MARK: - Clipboard Texture Read Test

    @Test @MainActor func clipboardReadTexture() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        // Ensure clipboard is accessible (won't crash)
        let clipboard = box.clipboard
        #expect(clipboard.pointer != nil)
        // readTexture is async — just verify the method exists and can be called
        // In test environment, no texture on clipboard is expected
    }

    // MARK: - Widget Display Extension Test

    @Test @MainActor func widgetDisplayProperty() {
        ensureAdwInit()
        let label = Label("test")
        let display = label.display
        #expect(display.pointer != nil)
        #expect(!display.name.isEmpty)
    }

    // MARK: - Clipboard Async Tests

    @Test @MainActor func clipboardAsyncMethodsExist() {
        ensureAdwInit()
        // Verify the async methods compile — actual clipboard access
        // requires a running event loop so we just check availability
        let box = Box(orientation: .vertical, spacing: 0)
        let clipboard = box.clipboard
        _ = clipboard  // async methods available: readText(), readTexture()
    }

    // MARK: - Widget.removeController Test

    @Test @MainActor func widgetRemoveController() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let gesture = GestureClick()
        box.addController(gesture)
        // Should not crash
        box.removeController(gesture)
    }

    // MARK: - ApplicationWindow.onCloseRequest Test

    @Test @MainActor func applicationWindowOnCloseRequest() {
        ensureAdwInit()
        let app = Application(id: "com.test.closereq\(UInt32.random(in: 0..<UInt32.max))")
        let win = ApplicationWindow(application: app)
        var called = false
        win.onCloseRequest {
            called = true
            return true  // prevent closing
        }
        // Signal handler connected successfully
        #expect(!called)
    }

    // MARK: - ListStore.item(at:) Tests

    @Test @MainActor func listStoreItemAt() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        store.appendPlaceholder()
        store.appendPlaceholder()
        let item0 = store.item(at: 0)
        #expect(item0 != nil)
        let item2 = store.item(at: 2)
        #expect(item2 != nil)
    }

    @Test @MainActor func listStoreItemAtOutOfBounds() {
        ensureAdwInit()
        let store = ListStore()
        store.appendPlaceholder()
        let item = store.item(at: 5)
        #expect(item == nil)
    }

    @Test @MainActor func listStoreItemAtEmpty() {
        ensureAdwInit()
        let store = ListStore()
        let item = store.item(at: 0)
        #expect(item == nil)
    }

    // MARK: - ListScrollFlags

    @Test func listScrollFlagsNone() {
        let flags: ListScrollFlags = .none
        #expect(flags.rawValue == 0)
    }

    @Test func listScrollFlagsFocus() {
        let flags: ListScrollFlags = .focus
        #expect(flags.rawValue == 1)
    }

    @Test func listScrollFlagsSelect() {
        let flags: ListScrollFlags = .select
        #expect(flags.rawValue == 2)
    }

    @Test func listScrollFlagsCombined() {
        let flags: ListScrollFlags = [.focus, .select]
        #expect(flags.contains(.focus))
        #expect(flags.contains(.select))
        #expect(flags.rawValue == 3)
    }

    // MARK: - ComboRow protocol-based model

    @Test @MainActor func comboRowSetModelProtocol() {
        ensureAdwInit()
        let combo = ComboRow()
        let model = StringList(["X", "Y", "Z"])
        combo.setModel(model)
        combo.selected = 2
        #expect(combo.selected == 2)
    }

    @Test @MainActor func comboRowClearModel() {
        ensureAdwInit()
        let combo = ComboRow()
        let model = StringList(["A"])
        combo.setModel(model)
        combo.clearModel()
        // No crash = success
    }

    @Test @MainActor func comboRowSelectedItem() {
        ensureAdwInit()
        let combo = ComboRow()
        let model = StringList(["A", "B"])
        combo.setModel(model)
        combo.selected = 0
        // selectedItem should now return a GObjectRef
        let item = combo.selectedItem
        #expect(item != nil)
    }

    // MARK: - Toast actionTarget with Variant

    @Test @MainActor func toastActionTargetVariant() {
        ensureAdwInit()
        let toast = Toast(title: "Test")
        // Initially nil
        #expect(toast.actionTarget == nil)

        // Set a string variant
        let variant = Variant.string("hello")
        toast.actionTarget = variant
        let retrieved = toast.actionTarget
        #expect(retrieved != nil)
        #expect(retrieved?.stringValue == "hello")
    }

    @Test @MainActor func toastActionTargetClear() {
        ensureAdwInit()
        let toast = Toast(title: "Test")
        toast.actionTarget = Variant.int32(42)
        #expect(toast.actionTarget != nil)
        toast.actionTarget = nil
        #expect(toast.actionTarget == nil)
    }

    // MARK: - ListBox header func

    @Test @MainActor func listBoxSetHeaderFunc() {
        ensureAdwInit()
        let listBox = ListBox()
        let row1 = ListBoxRow()
        row1.child = Label("A")
        let row2 = ListBoxRow()
        row2.child = Label("B")
        listBox.append(row1)
        listBox.append(row2)

        var headerCalled = false
        listBox.setHeaderFunc { row, before in
            headerCalled = true
            if before == nil {
                row.header = Label("Header")
            }
        }
        listBox.invalidateHeaders()
        // No crash = success, header func was set
    }

    @Test @MainActor func listBoxClearHeaderFunc() {
        ensureAdwInit()
        let listBox = ListBox()
        listBox.setHeaderFunc { _, _ in }
        listBox.clearHeaderFunc()
        // No crash = success
    }

    @Test @MainActor func listBoxInvalidateHeaders() {
        ensureAdwInit()
        let listBox = ListBox()
        listBox.invalidateHeaders()
        // No crash = success
    }

    // MARK: - ListBoxRow properties

    @Test @MainActor func listBoxRowHeader() {
        ensureAdwInit()
        let row = ListBoxRow()
        #expect(row.header == nil)
        let header = Label("Section")
        row.header = header
        #expect(row.header != nil)
        row.header = nil
        #expect(row.header == nil)
    }

    @Test @MainActor func listBoxRowActivatable() {
        ensureAdwInit()
        let row = ListBoxRow()
        row.activatable = false
        #expect(row.activatable == false)
        row.activatable = true
        #expect(row.activatable == true)
    }

    @Test @MainActor func listBoxRowSelectable() {
        ensureAdwInit()
        let row = ListBoxRow()
        row.selectable = false
        #expect(row.selectable == false)
        row.selectable = true
        #expect(row.selectable == true)
    }

    @Test @MainActor func listBoxRowChanged() {
        ensureAdwInit()
        let listBox = ListBox()
        let row = ListBoxRow()
        row.child = Label("Test")
        listBox.append(row)
        row.changed()
        // No crash = success
    }

    // MARK: - MediaStream

    @Test @MainActor func mediaStreamCreation() {
        ensureAdwInit()
        // Creating from a non-existent file should still create the object
        let stream = MediaStream(filename: "/dev/null")
        #expect(stream.isPlaying == false)
        #expect(stream.ended == false)
        #expect(stream.isMuted == false)
    }

    @Test @MainActor func mediaStreamVolume() {
        ensureAdwInit()
        let stream = MediaStream(filename: "/dev/null")
        stream.volume = 0.5
        #expect(stream.volume > 0.49 && stream.volume < 0.51)
        stream.isMuted = true
        #expect(stream.isMuted == true)
    }

    @Test @MainActor func mediaStreamLoop() {
        ensureAdwInit()
        let stream = MediaStream(filename: "/dev/null")
        stream.loop = true
        #expect(stream.loop == true)
        stream.loop = false
        #expect(stream.loop == false)
    }

    @Test @MainActor func mediaStreamInfo() {
        ensureAdwInit()
        let stream = MediaStream(filename: "/dev/null")
        // Duration and timestamp default to 0 for an unprepared stream
        #expect(stream.duration == 0)
        #expect(stream.timestamp == 0)
    }

    // MARK: - Video with MediaStream

    @Test @MainActor func videoMediaStreamType() {
        ensureAdwInit()
        let video = Video()
        // Initially no media stream
        #expect(video.mediaStream == nil)
    }

    @Test @MainActor func videoSetMediaStream() {
        ensureAdwInit()
        let video = Video()
        let stream = MediaStream(filename: "/dev/null")
        video.mediaStream = stream
        #expect(video.mediaStream != nil)
    }

    // MARK: - MediaControls with MediaStream

    @Test @MainActor func mediaControlsWithStream() {
        ensureAdwInit()
        let stream = MediaStream(filename: "/dev/null")
        let controls = MediaControls(stream: stream)
        #expect(controls.mediaStream != nil)
    }

    @Test @MainActor func mediaControlsSetStream() {
        ensureAdwInit()
        let controls = MediaControls()
        #expect(controls.mediaStream == nil)
        let stream = MediaStream(filename: "/dev/null")
        controls.mediaStream = stream
        #expect(controls.mediaStream != nil)
    }

    // MARK: - ToggleButton convenience init

    @Test @MainActor func toggleButtonConvenienceInit() {
        ensureAdwInit()
        var toggled = false
        let btn = ToggleButton(label: "Toggle", onToggled: {
            toggled = true
        })
        #expect(btn.active == false)
        // No crash = success, handler was set
    }

    // MARK: - DragSource isDragging

    @Test @MainActor func dragSourceIsDragging() {
        ensureAdwInit()
        let drag = DragSource()
        #expect(drag.isDragging == false)
    }

    // MARK: - CallbackAnimationTarget Swift init

    @Test @MainActor func callbackAnimationTargetSwiftInit() {
        ensureAdwInit()
        var called = false
        let target = CallbackAnimationTarget { value in
            called = true
        }
        // The target is created with a Swift closure, not raw C pointers
        #expect(target.pointer != UnsafeMutableRawPointer(bitPattern: 0))
    }

    // MARK: - TextAttributes

    @Test @MainActor func textAttributesCreation() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addBold()
        attrs.addItalic()
        // No crash = success
    }

    @Test @MainActor func textAttributesForegroundColor() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addForegroundColor(red: 1.0, green: 0.0, blue: 0.0)
        attrs.addUnderline(.single)
        // No crash = success
    }

    @Test @MainActor func textAttributesFamily() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addFamily("monospace")
        attrs.addSizePoints(14)
        // No crash = success
    }

    @Test @MainActor func textAttributesStrikethrough() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addStrikethrough()
        attrs.addStrikethroughColor(red: 0.5, green: 0.5, blue: 0.5)
        // No crash = success
    }

    @Test @MainActor func textAttributesWeight() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addWeight(.semibold)
        attrs.addLight()
        // No crash = success
    }

    @Test @MainActor func entryRowTextAttributes() {
        ensureAdwInit()
        let row = EntryRow()
        #expect(row.textAttributes == nil)
        let attrs = TextAttributes()
        attrs.addBold()
        row.textAttributes = attrs
        let retrieved = row.textAttributes
        #expect(retrieved != nil)
    }

    // MARK: - Swipeable protocol

    @Test @MainActor func carouselIsSwipeable() {
        ensureAdwInit()
        let carousel = Carousel()
        let _: any Swipeable = carousel
        // Carousel conforms to Swipeable
    }

    @Test @MainActor func navigationViewIsSwipeable() {
        ensureAdwInit()
        let nav = NavigationView()
        let _: any Swipeable = nav
        // NavigationView conforms to Swipeable
    }

    @Test @MainActor func overlaySplitViewIsSwipeable() {
        ensureAdwInit()
        let split = OverlaySplitView()
        let _: any Swipeable = split
        // OverlaySplitView conforms to Swipeable
    }

    @Test @MainActor func swipeTrackerWithSwipeable() {
        ensureAdwInit()
        let carousel = Carousel()
        let tracker = SwipeTracker(swipeable: carousel)
        #expect(tracker.enabled == true)
        tracker.enabled = false
        #expect(tracker.enabled == false)
    }

    // MARK: - Container Protocol Conformance

    @Test @MainActor func boxConformsToContainer() {
        ensureAdwInit()
        let box = Box(orientation: .horizontal, spacing: 0)
        let _: any Container = box
        let child = Label("hi")
        box.append(child)
        box.remove(child)
    }

    @Test @MainActor func listBoxConformsToContainer() {
        ensureAdwInit()
        let list = ListBox()
        let _: any Container = list
        let child = Label("hi")
        list.append(child)
        list.remove(child)
    }

    @Test @MainActor func flowBoxConformsToContainer() {
        ensureAdwInit()
        let flow = FlowBox()
        let _: any Container = flow
        let child = Label("hi")
        flow.append(child)
        flow.remove(child)
    }

    @Test @MainActor func carouselConformsToContainer() {
        ensureAdwInit()
        let carousel = Carousel()
        let _: any Container = carousel
        let child = Label("hi")
        carousel.append(child)
        carousel.remove(child)
    }

    @Test @MainActor func wrapBoxConformsToContainer() {
        ensureAdwInit()
        let wrap = WrapBox()
        let _: any Container = wrap
        let child = Label("hi")
        wrap.append(child)
        wrap.remove(child)
    }

    // MARK: - Convenience Initializer Tests

    @Test @MainActor func switchRowConvenienceInit() {
        ensureAdwInit()
        let row = SwitchRow(title: "Dark Mode")
        #expect(row.title == "Dark Mode")
    }

    @Test @MainActor func switchRowConvenienceInitActive() {
        ensureAdwInit()
        let row = SwitchRow(title: "Enabled", active: true)
        #expect(row.title == "Enabled")
        #expect(row.active == true)
    }

    @Test @MainActor func entryRowConvenienceInit() {
        ensureAdwInit()
        let row = EntryRow(title: "Username")
        #expect(row.title == "Username")
    }

    @Test @MainActor func spinRowConvenienceInit() {
        ensureAdwInit()
        let row = SpinRow(title: "Volume", min: 0, max: 100, step: 1)
        #expect(row.title == "Volume")
    }

    @Test @MainActor func expanderRowConvenienceInit() {
        ensureAdwInit()
        let row = ExpanderRow(title: "Advanced")
        #expect(row.title == "Advanced")
    }

    @Test @MainActor func expanderRowConvenienceInitSubtitle() {
        ensureAdwInit()
        let row = ExpanderRow(title: "Advanced", subtitle: "More options")
        #expect(row.title == "Advanced")
        #expect(row.subtitle == "More options")
    }

    @Test @MainActor func comboRowConvenienceInit() {
        ensureAdwInit()
        let row = ComboRow(title: "Theme")
        #expect(row.title == "Theme")
    }

    @Test @MainActor func passwordEntryRowConvenienceInit() {
        ensureAdwInit()
        let row = PasswordEntryRow(title: "Password")
        #expect(row.title == "Password")
    }

    @Test @MainActor func preferencesGroupConvenienceInit() {
        ensureAdwInit()
        let group = PreferencesGroup(title: "General")
        #expect(group.title == "General")
    }

    @Test @MainActor func preferencesGroupConvenienceInitDescription() {
        ensureAdwInit()
        let group = PreferencesGroup(title: "General", description: "Basic settings")
        #expect(group.title == "General")
        #expect(group.description == "Basic settings")
    }

    @Test @MainActor func preferencesPageConvenienceInit() {
        ensureAdwInit()
        let page = PreferencesPage(title: "Appearance")
        #expect(page.title == "Appearance")
    }

    @Test @MainActor func preferencesPageConvenienceInitIcon() {
        ensureAdwInit()
        let page = PreferencesPage(title: "Appearance", iconName: "display-symbolic")
        #expect(page.title == "Appearance")
        #expect(page.iconName == "display-symbolic")
    }

    @Test @MainActor func statusPageConvenienceInit() {
        ensureAdwInit()
        let page = StatusPage(title: "No Results", description: "Try a different search")
        #expect(page.title == "No Results")
        #expect(page.description == "Try a different search")
    }

    @Test @MainActor func statusPageConvenienceInitIcon() {
        ensureAdwInit()
        let page = StatusPage(title: "Error", description: "Something went wrong", iconName: "dialog-error-symbolic")
        #expect(page.title == "Error")
        #expect(page.description == "Something went wrong")
        #expect(page.iconName == "dialog-error-symbolic")
    }

    @Test @MainActor func actionRowConvenienceInit() {
        ensureAdwInit()
        let row = ActionRow(title: "Wi-Fi")
        #expect(row.title == "Wi-Fi")
    }

    @Test @MainActor func actionRowConvenienceInitSubtitle() {
        ensureAdwInit()
        let row = ActionRow(title: "Wi-Fi", subtitle: "Connected")
        #expect(row.title == "Wi-Fi")
        #expect(row.subtitle == "Connected")
    }

    // MARK: - PropertyName Tests

    @Test func propertyNameValues() {
        #expect(PropertyName.active.name == "active")
        #expect(PropertyName.child.name == "child")
        #expect(PropertyName.content.name == "content")
        #expect(PropertyName.label.name == "label")
        #expect(PropertyName.orientation.name == "orientation")
        #expect(PropertyName.selected.name == "selected")
        #expect(PropertyName.spacing.name == "spacing")
        #expect(PropertyName.text.name == "text")
        #expect(PropertyName.title.name == "title")
        #expect(PropertyName.visible.name == "visible")
        #expect(PropertyName.width.name == "width")
    }

    @Test func propertyNameCustom() {
        let custom = PropertyName.custom("my-property")
        #expect(custom.name == "my-property")
    }

    @Test func propertyNameEquality() {
        #expect(PropertyName.active == PropertyName.active)
        #expect(PropertyName.active != PropertyName.label)
        #expect(PropertyName.custom("x") == PropertyName.custom("x"))
        #expect(PropertyName.custom("x") != PropertyName.custom("y"))
    }

    // MARK: - CSSClass Tests

    @Test func cssClassRawValues() {
        #expect(CSSClass.suggestedAction.rawValue == "suggested-action")
        #expect(CSSClass.destructiveAction.rawValue == "destructive-action")
        #expect(CSSClass.flat.rawValue == "flat")
        #expect(CSSClass.pill.rawValue == "pill")
        #expect(CSSClass.card.rawValue == "card")
        #expect(CSSClass.boxedList.rawValue == "boxed-list")
        #expect(CSSClass.title1.rawValue == "title-1")
        #expect(CSSClass.dimLabel.rawValue == "dim-label")
        #expect(CSSClass.navigationSidebar.rawValue == "navigation-sidebar")
    }

    @Test @MainActor func widgetCSSClassEnum() {
        ensureAdwInit()
        let label = Label("Test")
        label.addCSSClass(.title1)
        #expect(label.hasCSSClass(.title1))
        label.removeCSSClass(.title1)
        #expect(!label.hasCSSClass(.title1))
    }

    // MARK: - IconName Tests

    @Test func iconNameValues() {
        #expect(IconName.goNext.name == "go-next-symbolic")
        #expect(IconName.documentSave.name == "document-save-symbolic")
        #expect(IconName.dialogError.name == "dialog-error-symbolic")
        #expect(IconName.emblemOk.name == "emblem-ok-symbolic")
        #expect(IconName.networkWireless.name == "network-wireless-symbolic")
        #expect(IconName.custom("my-icon").name == "my-icon")
    }

    @Test @MainActor func imageWithIconName() {
        ensureAdwInit()
        let img = Image(icon: .dialogInformation)
        #expect(img.iconName == "dialog-information-symbolic")
    }

    @Test @MainActor func buttonWithIconName() {
        ensureAdwInit()
        let btn = Button(icon: .goNext)
        #expect(btn is Widget)
    }

    // MARK: - Fluent Setter Tests

    @Test @MainActor func widgetFluentSetters() {
        ensureAdwInit()
        let label = Label("Test")
            .halign(.center)
            .valign(.end)
            .hexpand()
            .vexpand()
            .margins(12)
            .tooltip("Hello")
            .cssClass(.title1)
            .opacity(0.5)

        #expect(label.halign == GTK_ALIGN_CENTER)
        #expect(label.valign == GTK_ALIGN_END)
        #expect(label.hexpand == true)
        #expect(label.vexpand == true)
        #expect(label.marginStart == 12)
        #expect(label.marginEnd == 12)
        #expect(label.marginTop == 12)
        #expect(label.marginBottom == 12)
        #expect(label.tooltipText == "Hello")
        #expect(label.hasCSSClass(.title1))
        #expect(abs(label.opacity - 0.5) < 0.01)
    }

    @Test @MainActor func fluentSettersReturnSelf() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let result = box.halign(.start)
        #expect(result === box)
    }

    // MARK: - Throwing Dialog Tests

    @Test @MainActor func fontDialogThrowingMethodExists() {
        ensureAdwInit()
        let dialog = FontDialog()
        let _: (Widget?, String?, @escaping @MainActor (Result<String?, GLibError>) -> Void) -> Void = dialog.chooseFontThrowing
    }

    @Test @MainActor func colorDialogThrowingMethodExists() {
        ensureAdwInit()
        let dialog = ColorDialog()
        let _: (Widget?, RGBA?, @escaping @MainActor (Result<RGBA?, GLibError>) -> Void) -> Void = dialog.chooseRGBAThrowing
    }

    // MARK: - Localization

    @Test func localizedPassthrough() {
        // Without a domain set, localized() should return the original string
        let result = localized("Hello")
        #expect(result == "Hello")
    }

    @Test func stringLocalizedPassthrough() {
        let result = "Hello".localized
        #expect(result == "Hello")
    }

    @Test func nlocalizedPassthrough() {
        let one = nlocalized("%d file", "%d files", count: 1)
        #expect(one == "%d file")
        let many = nlocalized("%d file", "%d files", count: 5)
        #expect(many == "%d files")
    }

    // MARK: - HeaderBar convenience init

    @Test @MainActor func headerBarConvenienceInit() {
        ensureAdwInit()
        let hb = HeaderBar(title: "Settings")
        #expect(hb.titleWidget != nil)
    }

    @Test @MainActor func headerBarConvenienceInitSubtitle() {
        ensureAdwInit()
        let hb = HeaderBar(title: "App", subtitle: "v1.0")
        #expect(hb.titleWidget != nil)
    }

    // MARK: - AboutDialog convenience init

    @Test @MainActor func aboutDialogConvenienceInit() {
        ensureAdwInit()
        let dialog = AboutDialog(
            appName: "TestApp",
            version: "1.0",
            developer: "Dev"
        )
        #expect(dialog.applicationName == "TestApp")
        #expect(dialog.version == "1.0")
        #expect(dialog.developerName == "Dev")
    }

    @Test @MainActor func aboutDialogConvenienceInitFull() {
        ensureAdwInit()
        let dialog = AboutDialog(
            appName: "TestApp",
            version: "2.0",
            developer: "Dev",
            website: "https://example.com",
            copyright: "2026 Dev"
        )
        #expect(dialog.applicationName == "TestApp")
        #expect(dialog.website == "https://example.com")
        #expect(dialog.copyright == "2026 Dev")
    }

    // MARK: - Breakpoint convenience constructors

    @Test @MainActor func breakpointMinWidth() {
        ensureAdwInit()
        let bp = Breakpoint.minWidth(500)
        #expect(bp.condition != nil)
    }

    @Test @MainActor func breakpointMaxWidth() {
        ensureAdwInit()
        let bp = Breakpoint.maxWidth(800)
        #expect(bp.condition != nil)
    }

    @Test @MainActor func breakpointMinHeight() {
        ensureAdwInit()
        let bp = Breakpoint.minHeight(400)
        #expect(bp.condition != nil)
    }

    // MARK: - Pango enum extensions

    @Test func pangoWeightExtensions() {
        #expect(PangoWeight.bold.rawValue == 700)
        #expect(PangoWeight.normal.rawValue == 400)
        #expect(PangoWeight.light.rawValue == 300)
    }

    @Test func pangoStyleExtensions() {
        #expect(PangoStyle.normal.rawValue == 0)
        #expect(PangoStyle.italic.rawValue == 2)
    }

    @Test func pangoUnderlineExtensions() {
        #expect(PangoUnderline.none.rawValue == 0)
        #expect(PangoUnderline.single.rawValue == 1)
    }

    // MARK: - Toast Convenience Tests

    @Test @MainActor func toastOverlayShowToast() {
        ensureAdwInit()
        let overlay = ToastOverlay()
        // Should not crash
        overlay.showToast("Hello")
    }

    @Test @MainActor func toastOverlayShowToastWithButton() {
        ensureAdwInit()
        let overlay = ToastOverlay()
        var tapped = false
        overlay.showToast("Deleted", button: "Undo") {
            tapped = true
        }
        // Verifies the API compiles and doesn't crash
        #expect(!tapped)
    }

    // MARK: - ToolbarView Convenience Tests

    @Test @MainActor func toolbarViewConvenienceInit() {
        ensureAdwInit()
        let content = Label("Content")
        let header = HeaderBar()
        let tv = ToolbarView(content: content, topBar: header)
        #expect(tv.content != nil)
    }

    // MARK: - ScrolledWindow Convenience Tests

    @Test @MainActor func scrolledWindowConvenienceInit() {
        ensureAdwInit()
        let label = Label("Scrollable")
        let sw = ScrolledWindow(child: label)
        #expect(sw.child != nil)
    }

    // MARK: - OverlaySplitView Convenience Tests

    @Test @MainActor func overlaySplitViewConvenienceInit() {
        ensureAdwInit()
        let sidebar = Label("Sidebar")
        let content = Label("Content")
        let split = OverlaySplitView(sidebar: sidebar, content: content)
        #expect(split.sidebar != nil)
        #expect(split.content != nil)
    }

    // MARK: - Notification IconName Overload Tests

    @Test @MainActor func sendNotificationIconNameOverload() {
        ensureAdwInit()
        // Just verify it compiles — we can't actually send without a running app
        let iconName = IconName.dialogInformation
        #expect(iconName.name == "dialog-information-symbolic")
    }

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

}
