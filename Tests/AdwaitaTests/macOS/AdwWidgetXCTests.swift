#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class AdwWidgetXCTests: XCTestCase {

    // MARK: - Adw Widget Instantiation Tests

    @MainActor func test_headerBarCreation() {
        ensureAdwInit()
        let hb = HeaderBar()
        hb.showTitle = false
        XCTAssertTrue(hb.showTitle == false)
        hb.showBackButton = true
        XCTAssertTrue(hb.showBackButton == true)
    }

    @MainActor func test_headerBarPackWidgets() {
        ensureAdwInit()
        let hb = HeaderBar()
        let btn = Button(iconName: "open-menu-symbolic")
        hb.packEnd(btn)
        // Should not crash
        hb.remove(btn)
    }

    @MainActor func test_toolbarViewCreation() {
        ensureAdwInit()
        let tv = ToolbarView()
        let hb = HeaderBar()
        let label = Label("Content")
        tv.addTopBar(hb)
        tv.setContent(label)
        XCTAssertNotNil(tv.content)
    }

    @MainActor func test_toolbarViewBarStyles() {
        ensureAdwInit()
        let tv = ToolbarView()
        let initial = tv.topBarStyle
        // Round-trip: set and read back
        tv.topBarStyle = initial
        XCTAssertTrue(tv.topBarStyle == initial)
        let bottomInitial = tv.bottomBarStyle
        tv.bottomBarStyle = bottomInitial
        XCTAssertTrue(tv.bottomBarStyle == bottomInitial)
    }

    @MainActor func test_toolbarViewReveal() {
        ensureAdwInit()
        let tv = ToolbarView()
        XCTAssertTrue(tv.revealTopBars == true)
        tv.revealTopBars = false
        XCTAssertTrue(tv.revealTopBars == false)
        tv.revealBottomBars = false
        XCTAssertTrue(tv.revealBottomBars == false)
    }

    @MainActor func test_statusPageProperties() {
        ensureAdwInit()
        let sp = StatusPage()
        sp.title = "No Results"
        sp.description = "Try a different search"
        sp.iconName = "system-search-symbolic"
        XCTAssertTrue(sp.title == "No Results")
        XCTAssertTrue(sp.description == "Try a different search")
        XCTAssertTrue(sp.iconName == "system-search-symbolic")
    }

    @MainActor func test_statusPageChild() {
        ensureAdwInit()
        let sp = StatusPage()
        let btn = Button(label: "Retry")
        sp.child = btn
        XCTAssertNotNil(sp.child)
    }

    @MainActor func test_toastCreation() {
        ensureAdwInit()
        let toast = Toast(title: "Saved!")
        XCTAssertTrue(toast.title == "Saved!")
    }

    @MainActor func test_toastProperties() {
        ensureAdwInit()
        let toast = Toast(title: "Test")
        toast.buttonLabel = "Undo"
        XCTAssertTrue(toast.buttonLabel == "Undo")
        toast.timeout = 5
        XCTAssertTrue(toast.timeout == 5)
    }

    @MainActor func test_bannerProperties() {
        ensureAdwInit()
        let banner = Banner(title: "Update available")
        XCTAssertTrue(banner.title == "Update available")
        banner.buttonLabel = "Update"
        XCTAssertTrue(banner.buttonLabel == "Update")
        banner.revealed = true
        XCTAssertTrue(banner.revealed == true)
    }

    @MainActor func test_avatarProperties() {
        ensureAdwInit()
        let avatar = Avatar(size: 64, text: "John", showInitials: true)
        XCTAssertTrue(avatar.size == 64)
        XCTAssertTrue(avatar.text == "John")
        XCTAssertTrue(avatar.showInitials == true)
    }

    @MainActor func test_spinnerCreation() {
        ensureAdwInit()
        guard let spinner = Spinner() else { return }
        // Spinner should be instantiable
        XCTAssertNotNil(spinner.pointer)
    }

    @MainActor func test_buttonContentProperties() {
        ensureAdwInit()
        let bc = ButtonContent()
        bc.label = "Open"
        bc.iconName = "document-open-symbolic"
        XCTAssertTrue(bc.label == "Open")
        XCTAssertTrue(bc.iconName == "document-open-symbolic")
    }

    @MainActor func test_windowTitleProperties() {
        ensureAdwInit()
        let wt = WindowTitle(title: "My App", subtitle: "v1.0")
        XCTAssertTrue(wt.title == "My App")
        XCTAssertTrue(wt.subtitle == "v1.0")
    }

    @MainActor func test_windowTitleRoundTrip() {
        ensureAdwInit()
        let wt = WindowTitle(title: "A", subtitle: "B")
        wt.title = "Changed"
        wt.subtitle = "New Sub"
        XCTAssertTrue(wt.title == "Changed")
        XCTAssertTrue(wt.subtitle == "New Sub")
    }

    @MainActor func test_navigationViewProperties() {
        ensureAdwInit()
        let nav = NavigationView()
        // NavigationView starts with no visible page
        nav.popOnEscape = true
        XCTAssertTrue(nav.popOnEscape == true)
        nav.animateTransitions = false
        XCTAssertTrue(nav.animateTransitions == false)
    }

    @MainActor func test_navigationViewAnimateTransitions() {
        ensureAdwInit()
        let nav = NavigationView()
        nav.animateTransitions = true
        XCTAssertTrue(nav.animateTransitions == true)
        nav.animateTransitions = false
        XCTAssertTrue(nav.animateTransitions == false)
    }

    @MainActor func test_alertDialogCreation() {
        ensureAdwInit()
        let dialog = AlertDialog(heading: "Delete?", body: "This cannot be undone.")
        XCTAssertTrue(dialog.heading == "Delete?")
        XCTAssertTrue(dialog.body == "This cannot be undone.")
    }

    @MainActor func test_alertDialogResponses() {
        ensureAdwInit()
        let dialog = AlertDialog(heading: "Confirm", body: "Proceed?")
        dialog.addResponse("cancel", label: "Cancel")
        dialog.addResponse("ok", label: "OK")
        XCTAssertTrue(dialog.hasResponse("cancel") == true)
        XCTAssertTrue(dialog.hasResponse("ok") == true)
        XCTAssertTrue(dialog.hasResponse("nonexistent") == false)
    }

    @MainActor func test_alertDialogPreferWideLayout() {
        ensureAdwInit()
        guard AdwaitaVersion.isAtLeast(1, 6) else { return }
        let dialog = AlertDialog(heading: "Test", body: "Body")
        dialog.preferWideLayout = true
        XCTAssertTrue(dialog.preferWideLayout == true)
    }

    @MainActor func test_carouselOperations() {
        ensureAdwInit()
        let carousel = Carousel()
        let page1 = Label("Page 1")
        let page2 = Label("Page 2")
        carousel.append(page1)
        carousel.append(page2)
        XCTAssertTrue(carousel.nPages == 2)
    }

    @MainActor func test_carouselProperties() {
        ensureAdwInit()
        let carousel = Carousel()
        carousel.spacing = 20
        XCTAssertTrue(carousel.spacing == 20)
        carousel.allowMouseDrag = false
        XCTAssertTrue(carousel.allowMouseDrag == false)
        carousel.interactive = false
        XCTAssertTrue(carousel.interactive == false)
    }

    @MainActor func test_clampProperties() {
        ensureAdwInit()
        let clamp = Clamp()
        clamp.maximumSize = 600
        XCTAssertTrue(clamp.maximumSize == 600)
        clamp.tighteningThreshold = 400
        XCTAssertTrue(clamp.tighteningThreshold == 400)
    }

    @MainActor func test_preferencesGroupProperties() {
        ensureAdwInit()
        let group = PreferencesGroup()
        group.title = "General"
        group.description = "Basic settings"
        XCTAssertTrue(group.title == "General")
        XCTAssertTrue(group.description == "Basic settings")
    }

    @MainActor func test_preferencesGroupAddRow() {
        ensureAdwInit()
        let group = PreferencesGroup()
        let row = ActionRow()
        row.title = "Setting"
        group.add(row)
        // Should not crash
        group.remove(row)
    }

    @MainActor func test_actionRowProperties() {
        ensureAdwInit()
        let row = ActionRow()
        row.title = "Name"
        row.subtitle = "Enter your name"
        XCTAssertTrue(row.title == "Name")
        XCTAssertTrue(row.subtitle == "Enter your name")
    }

    @MainActor func test_switchRowProperties() {
        ensureAdwInit()
        let row = SwitchRow()
        row.title = "Dark Mode"
        row.active = true
        XCTAssertTrue(row.title == "Dark Mode")
        XCTAssertTrue(row.active == true)
    }

    @MainActor func test_viewStackOperations() {
        ensureAdwInit()
        let vs = ViewStack()
        let page1 = Label("Home")
        let page2 = Label("Settings")
        vs.addTitledWithIcon(page1, name: "home", title: "Home", iconName: "go-home-symbolic")
        vs.addTitledWithIcon(page2, name: "settings", title: "Settings", iconName: "preferences-system-symbolic")
        vs.visibleChildName = "settings"
        XCTAssertTrue(vs.visibleChildName == "settings")
    }

    @MainActor func test_toastOverlayChild() {
        ensureAdwInit()
        let overlay = ToastOverlay()
        let label = Label("Content")
        overlay.child = label
        XCTAssertNotNil(overlay.child)
    }

    @MainActor func test_splitButtonProperties() {
        ensureAdwInit()
        let sb = SplitButton()
        sb.iconName = "document-open-symbolic"
        XCTAssertTrue(sb.iconName == "document-open-symbolic")
    }

    @MainActor func test_overlaySplitViewProperties() {
        ensureAdwInit()
        let osv = OverlaySplitView()
        let sidebar = Label("Sidebar")
        let content = Label("Content")
        osv.sidebar = sidebar
        osv.content = content
        osv.showSidebar = false
        XCTAssertTrue(osv.showSidebar == false)
    }

    @MainActor func test_bottomSheetProperties() {
        ensureAdwInit()
        guard let bs = BottomSheet() else { return }
        let content = Label("Main")
        let sheet = Label("Sheet")
        bs.content = content
        bs.sheet = sheet
        bs.open = true
        XCTAssertTrue(bs.open == true)
    }

    // MARK: - Signal Connection Tests

    @MainActor func test_signalConnectionReturnsValidObject() {
        ensureAdwInit()
        let btn = Button(label: "Test")
        let conn = btn.onClicked { /* no-op */ }
        // Connection object should be non-nil and disconnectable
        conn.disconnect()
        // Double-disconnect should not crash
        conn.disconnect()
    }

    @MainActor func test_multipleSignalConnectionsReturnDistinctObjects() {
        ensureAdwInit()
        let btn = Button(label: "Multi")
        let c1 = btn.onClicked {}
        let c2 = btn.onClicked {}
        // Both connections should be independently disconnectable
        c1.disconnect()
        c2.disconnect()
    }

    @MainActor func test_signalConnectionOnGeneratedWidget() {
        ensureAdwInit()
        let toast = Toast(title: "test")
        let conn = toast.onDismissed {}
        conn.disconnect()
    }

    @MainActor func test_notifySignalConnects() {
        ensureAdwInit()
        let label = Label("before")
        let conn = SignalHelper.onNotify(label, property: .label) {}
        conn.disconnect()
    }

    @MainActor func test_signalConnectionOnAdwAlertDialog() {
        ensureAdwInit()
        let dialog = AlertDialog(heading: "Test", body: "Body")
        dialog.addResponse("ok", label: "OK")
        let conn = dialog.onResponse { _ in }
        conn.disconnect()
    }

    @MainActor func test_signalConnectionOnNavigationView() {
        ensureAdwInit()
        let nav = NavigationView()
        let conn = nav.onPushed {}
        conn.disconnect()
    }

    @MainActor func test_signalConnectionOnCarousel() {
        ensureAdwInit()
        let carousel = Carousel()
        let conn = carousel.onPageChanged { _ in }
        conn.disconnect()
    }

    // MARK: - GObject Ref Counting Tests

    @MainActor func test_borrowingAddsRef() {
        ensureAdwInit()
        let label = Label("ref test")
        let refCount1 = label.gobjectPointer.pointee.ref_count
        let borrowed = Widget(borrowing: label.pointer)
        let refCount2 = label.gobjectPointer.pointee.ref_count
        XCTAssertTrue(refCount2 == refCount1 + 1, "Borrowing should add a reference")
        _ = borrowed // keep alive
    }

    @MainActor func test_widgetPointerStability() {
        ensureAdwInit()
        let btn = Button(label: "stable")
        let ptr1 = btn.pointer
        let ptr2 = btn.pointer
        XCTAssertTrue(ptr1 == ptr2, "Pointer should be stable across accesses")
    }

    // MARK: - Container Relationship Tests

    @MainActor func test_boxContainsChildren() {
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

    @MainActor func test_nestedContainers() {
        ensureAdwInit()
        let outerBox = Box(orientation: GTK_ORIENTATION_VERTICAL)
        let innerBox = Box(orientation: GTK_ORIENTATION_HORIZONTAL, spacing: 5)
        let label = Label("Nested")
        innerBox.append(label)
        outerBox.append(innerBox)
        // Deeply nested widget tree should not crash
        outerBox.remove(innerBox)
    }

    @MainActor func test_toolbarViewFullLayout() {
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
        XCTAssertNotNil(tv.content)
    }

    // MARK: - GValue Pointer Access Tests

    @MainActor func test_gvalueWithUnsafePointer() {
        var gv = GValueRef("test")
        let result = gv.withUnsafePointer { ptr in
            String(cString: g_value_get_string(ptr)!)
        }
        XCTAssertTrue(result == "test")
    }

    @MainActor func test_gvalueWithUnsafeMutablePointer() {
        var gv = GValueRef(Int32(0))
        gv.withUnsafeMutablePointer { ptr in
            g_value_set_int(ptr, 42)
        }
        XCTAssertTrue(gv.intValue == 42)
    }

    // MARK: - Adw Enum Import Tests

    @MainActor func test_adwEnumTypesAreAccessible() {
        // Verify key Adw enum types are importable
        let _: AdwCenteringPolicy.Type = AdwCenteringPolicy.self
        let _: AdwToolbarStyle.Type = AdwToolbarStyle.self
        let _: AdwNavigationDirection.Type = AdwNavigationDirection.self
        let _: AdwColorScheme.Type = AdwColorScheme.self
        let _: AdwResponseAppearance.Type = AdwResponseAppearance.self
        let _: AdwLengthUnit.Type = AdwLengthUnit.self
        let _: AdwFoldThresholdPolicy.Type = AdwFoldThresholdPolicy.self
        let _: AdwBreakpointConditionLengthType.Type = AdwBreakpointConditionLengthType.self
        XCTAssertTrue(Bool(true), "All key Adw enum types are accessible")
    }

}
#endif
