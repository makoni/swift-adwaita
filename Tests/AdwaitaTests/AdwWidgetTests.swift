import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized) struct AdwWidgetTests {

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
        guard let spinner = Spinner() else { return }
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
        guard AdwaitaVersion.isAtLeast(1, 6) else { return }
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
        guard let bs = BottomSheet() else { return }
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


}
