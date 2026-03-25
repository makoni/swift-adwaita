import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized) struct TypeHierarchyTests {

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


}
