#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class TypeHierarchyXCTests: XCTestCase {

    @MainActor func test__00_initAdwaita() {
        ensureAdwInit()
        XCTAssertTrue(Bool(true))
    }

    // MARK: - Type Hierarchy Tests

    @MainActor func test_widgetInheritsFromGObjectRef() {
        XCTAssertTrue(isAdwSubclass(Widget.self, of: GObjectRef.self))
    }

    @MainActor func test_applicationWindowInheritsFromWidget() {
        XCTAssertTrue(isAdwSubclass(ApplicationWindow.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(ApplicationWindow.self, of: GObjectRef.self))
    }

    @MainActor func test_navigationPageInheritsFromWidget() {
        XCTAssertTrue(isAdwSubclass(NavigationPage.self, of: Widget.self))
    }

    @MainActor func test_actionRowInheritanceChain() {
        XCTAssertTrue(isAdwSubclass(ActionRow.self, of: PreferencesRow.self))
        XCTAssertTrue(isAdwSubclass(ActionRow.self, of: ListBoxRow.self))
        XCTAssertTrue(isAdwSubclass(ActionRow.self, of: Widget.self))
    }

    @MainActor func test_windowInheritsFromGtkWindow() {
        XCTAssertTrue(isAdwSubclass(Window.self, of: GtkWindow.self))
        XCTAssertTrue(isAdwSubclass(Window.self, of: Widget.self))
    }

    @MainActor func test_dialogInheritanceChain() {
        XCTAssertTrue(isAdwSubclass(Dialog.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(AboutDialog.self, of: Dialog.self))
        XCTAssertTrue(isAdwSubclass(AlertDialog.self, of: Dialog.self))
    }

    @MainActor func test_animationInheritanceChain() {
        XCTAssertTrue(isAdwSubclass(Animation.self, of: GObjectRef.self))
        XCTAssertTrue(isAdwSubclass(SpringAnimation.self, of: Animation.self))
        XCTAssertTrue(isAdwSubclass(TimedAnimation.self, of: Animation.self))
    }

    @MainActor func test_preferencesRowSubclasses() {
        XCTAssertTrue(isAdwSubclass(ActionRow.self, of: PreferencesRow.self))
        XCTAssertTrue(isAdwSubclass(ComboRow.self, of: ActionRow.self))
        XCTAssertTrue(isAdwSubclass(ExpanderRow.self, of: PreferencesRow.self))
        XCTAssertTrue(isAdwSubclass(EntryRow.self, of: PreferencesRow.self))
        XCTAssertTrue(isAdwSubclass(SpinRow.self, of: ActionRow.self))
        XCTAssertTrue(isAdwSubclass(SwitchRow.self, of: ActionRow.self))
        XCTAssertTrue(isAdwSubclass(PasswordEntryRow.self, of: EntryRow.self))
        XCTAssertTrue(isAdwSubclass(ButtonRow.self, of: PreferencesRow.self))
    }

    @MainActor func test_layoutManagerSubclasses() {
        XCTAssertTrue(isAdwSubclass(LayoutManager.self, of: GObjectRef.self))
        XCTAssertTrue(isAdwSubclass(ClampLayout.self, of: LayoutManager.self))
        XCTAssertTrue(isAdwSubclass(WrapLayout.self, of: LayoutManager.self))
    }

    // MARK: - Intermediate Classes

    @MainActor func test_intermediateClassHierarchy() {
        XCTAssertTrue(isAdwSubclass(GtkWindow.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(ListBoxRow.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(LayoutManager.self, of: GObjectRef.self))
    }

    // MARK: - C Type Accessibility Tests

    @MainActor func test_gTypeIsAccessible() {
        ensureAdwInit()
        let widgetType = gtk_widget_get_type()
        XCTAssertTrue(widgetType != 0, "gtk_widget_get_type should return non-zero")
    }

    @MainActor func test_adwInitFunctionExists() {
        ensureAdwInit()
        let fn = adw_init
        XCTAssertNotNil(fn)
    }

    // MARK: - Generated Wrapper Coverage

    @MainActor func test_allKeyGeneratedTypesExist() {
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
            // MultiLayoutView, Layout, LayoutSlot require libadwaita 1.6+
            WrapBox.self, WrapLayout.self,
            // Animations
            Animation.self, SpringAnimation.self, TimedAnimation.self,
            AnimationTarget.self, CallbackAnimationTarget.self,
            PropertyAnimationTarget.self,
            // View stack / switching
            ViewStack.self, ViewStackPage.self, ViewStackPages.self,
            ViewSwitcher.self, ViewSwitcherBar.self,
            // InlineViewSwitcher requires libadwaita 1.7+
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
            StyleManager.self, SwipeTracker.self, EnumListModel.self
        ]
        XCTAssertTrue(types.count >= 64, "Expected at least 64 generated types")
    }

    // MARK: - Hand-Written Wrapper Tests

    @MainActor func test_handWrittenWrappersExist() {
        XCTAssertTrue(isAdwSubclass(Application.self, of: GObjectRef.self))
        XCTAssertTrue(isAdwSubclass(ApplicationWindow.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(HeaderBar.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(ToolbarView.self, of: Widget.self))
        XCTAssertTrue(isAdwSubclass(StatusPage.self, of: Widget.self))
    }

    // MARK: - GValue Tests

    @MainActor func test_gvalueStringRoundTrip() {
        var gv = GValueRef("hello")
        XCTAssertTrue(gv.stringValue == "hello")
    }

    @MainActor func test_gvalueIntRoundTrip() {
        var gv = GValueRef(Int32(42))
        XCTAssertTrue(gv.intValue == 42)
    }

    @MainActor func test_gvalueUIntRoundTrip() {
        var gv = GValueRef(UInt32(100))
        XCTAssertTrue(gv.uintValue == 100)
    }

    @MainActor func test_gvalueBoolRoundTrip() {
        var gvTrue = GValueRef(true)
        var gvFalse = GValueRef(false)
        XCTAssertTrue(gvTrue.boolValue == true)
        XCTAssertTrue(gvFalse.boolValue == false)
    }

    @MainActor func test_gvalueDoubleRoundTrip() {
        var gv = GValueRef(3.14)
        XCTAssertTrue(gv.doubleValue == 3.14)
    }

    @MainActor func test_gvalueFloatRoundTrip() {
        var gv = GValueRef(Float(2.5))
        XCTAssertTrue(gv.floatValue == 2.5)
    }

    @MainActor func test_gvalueInt64RoundTrip() {
        var gv = GValueRef(Int64(999_999_999_999))
        gv.withUnsafePointer { ptr in
            XCTAssertTrue(g_value_get_int64(ptr) == 999_999_999_999)
        }
    }

    @MainActor func test_gvalueStringNilForNonString() {
        var gv = GValueRef(Int32(5))
        XCTAssertNil(gv.stringValue)
    }

    // MARK: - GType Shim Tests

    @MainActor func test_gTypeShimFunctions() {
        ensureAdwInit()
        XCTAssertTrue(cadw_type_string() != 0)
        XCTAssertTrue(cadw_type_int() != 0)
        XCTAssertTrue(cadw_type_uint() != 0)
        XCTAssertTrue(cadw_type_boolean() != 0)
        XCTAssertTrue(cadw_type_double() != 0)
        XCTAssertTrue(cadw_type_float() != 0)
        XCTAssertTrue(cadw_type_int64() != 0)
        XCTAssertTrue(cadw_type_object() != 0)
        XCTAssertTrue(cadw_type_uint64() != 0)
        // All fundamental types should be distinct
        XCTAssertTrue(cadw_type_string() != cadw_type_int())
        XCTAssertTrue(cadw_type_int() != cadw_type_boolean())
        XCTAssertTrue(cadw_type_double() != cadw_type_float())
        XCTAssertTrue(cadw_type_int() != cadw_type_uint())
        XCTAssertTrue(cadw_type_int64() != cadw_type_uint64())
    }

}
#endif
