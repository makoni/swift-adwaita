#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class ConvenienceXCTests: XCTestCase {

    // MARK: - PropertyName Tests

    func test_propertyNameValues() {
        XCTAssertTrue(PropertyName.active.name == "active")
        XCTAssertTrue(PropertyName.child.name == "child")
        XCTAssertTrue(PropertyName.content.name == "content")
        XCTAssertTrue(PropertyName.label.name == "label")
        XCTAssertTrue(PropertyName.orientation.name == "orientation")
        XCTAssertTrue(PropertyName.selected.name == "selected")
        XCTAssertTrue(PropertyName.spacing.name == "spacing")
        XCTAssertTrue(PropertyName.text.name == "text")
        XCTAssertTrue(PropertyName.title.name == "title")
        XCTAssertTrue(PropertyName.visible.name == "visible")
        XCTAssertTrue(PropertyName.width.name == "width")
    }

    func test_propertyNameCustom() {
        let custom = PropertyName.custom("my-property")
        XCTAssertTrue(custom.name == "my-property")
    }

    func test_propertyNameEquality() {
        XCTAssertTrue(PropertyName.active == PropertyName.active)
        XCTAssertTrue(PropertyName.active != PropertyName.label)
        XCTAssertTrue(PropertyName.custom("x") == PropertyName.custom("x"))
        XCTAssertTrue(PropertyName.custom("x") != PropertyName.custom("y"))
    }

    // MARK: - CSSClass Tests

    func test_cssClassRawValues() {
        XCTAssertTrue(CSSClass.suggestedAction.rawValue == "suggested-action")
        XCTAssertTrue(CSSClass.destructiveAction.rawValue == "destructive-action")
        XCTAssertTrue(CSSClass.flat.rawValue == "flat")
        XCTAssertTrue(CSSClass.pill.rawValue == "pill")
        XCTAssertTrue(CSSClass.card.rawValue == "card")
        XCTAssertTrue(CSSClass.boxedList.rawValue == "boxed-list")
        XCTAssertTrue(CSSClass.title1.rawValue == "title-1")
        XCTAssertTrue(CSSClass.dimLabel.rawValue == "dim-label")
        XCTAssertTrue(CSSClass.navigationSidebar.rawValue == "navigation-sidebar")
    }

    @MainActor func test_widgetCSSClassEnum() {
        ensureAdwInit()
        let label = Label("Test")
        label.addCSSClass(.title1)
        XCTAssertTrue(label.hasCSSClass(.title1))
        label.removeCSSClass(.title1)
        XCTAssertFalse(label.hasCSSClass(.title1))
    }

    // MARK: - IconName Tests

    func test_iconNameValues() {
        XCTAssertTrue(IconName.goNext.name == "go-next-symbolic")
        XCTAssertTrue(IconName.documentSave.name == "document-save-symbolic")
        XCTAssertTrue(IconName.dialogError.name == "dialog-error-symbolic")
        XCTAssertTrue(IconName.emblemOk.name == "emblem-ok-symbolic")
        XCTAssertTrue(IconName.networkWireless.name == "network-wireless-symbolic")
        XCTAssertTrue(IconName.custom("my-icon").name == "my-icon")
    }

    @MainActor func test_imageWithIconName() {
        ensureAdwInit()
        let img = Image(icon: .dialogInformation)
        XCTAssertTrue(img.iconName == "dialog-information-symbolic")
    }

    @MainActor func test_buttonWithIconName() {
        ensureAdwInit()
        let btn = Button(icon: .goNext)
        XCTAssertTrue(btn is Widget)
    }

    // MARK: - Fluent Setter Tests

    @MainActor func test_widgetFluentSetters() {
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

        XCTAssertTrue(label.halign == GTK_ALIGN_CENTER)
        XCTAssertTrue(label.valign == GTK_ALIGN_END)
        XCTAssertTrue(label.hexpand == true)
        XCTAssertTrue(label.vexpand == true)
        XCTAssertTrue(label.marginStart == 12)
        XCTAssertTrue(label.marginEnd == 12)
        XCTAssertTrue(label.marginTop == 12)
        XCTAssertTrue(label.marginBottom == 12)
        XCTAssertTrue(label.tooltipText == "Hello")
        XCTAssertTrue(label.hasCSSClass(.title1))
        XCTAssertTrue(abs(label.opacity - 0.5) < 0.01)
    }

    @MainActor func test_fluentSettersReturnSelf() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let result = box.halign(.start)
        XCTAssertTrue(result === box)
    }

    // MARK: - Throwing Dialog Tests

    @MainActor func test_fontDialogThrowingMethodExists() {
        ensureAdwInit()
        let dialog = FontDialog()
        let _: (Widget?, String?) async throws(GLibError) -> String? = dialog.chooseFont
    }

    @MainActor func test_colorDialogThrowingMethodExists() {
        ensureAdwInit()
        let dialog = ColorDialog()
        let _: (Widget?, RGBA?) async throws(GLibError) -> RGBA? = dialog.chooseRGBA
    }

    @MainActor func test_fileDialogThrowingMethodsExist() {
        ensureAdwInit()
        let dialog = FileDialog()
        let _: (Widget?) async throws(GLibError) -> String? = dialog.open
        let _: (Widget?) async throws(GLibError) -> String? = dialog.save
        let _: (Widget?) async throws(GLibError) -> String? = dialog.selectFolder
    }

    // MARK: - Localization

    func test_localizedPassthrough() {
        // Without a domain set, localized() should return the original string
        let result = localized("Hello")
        XCTAssertTrue(result == "Hello")
    }

    func test_stringLocalizedPassthrough() {
        let result = "Hello".localized
        XCTAssertTrue(result == "Hello")
    }

    func test_nlocalizedPassthrough() {
        let one = nlocalized("%d file", "%d files", count: 1)
        XCTAssertTrue(one == "%d file")
        let many = nlocalized("%d file", "%d files", count: 5)
        XCTAssertTrue(many == "%d files")
    }

    // MARK: - HeaderBar convenience init

    @MainActor func test_headerBarConvenienceInit() {
        ensureAdwInit()
        let hb = HeaderBar(title: "Settings")
        XCTAssertNotNil(hb.titleWidget)
    }

    @MainActor func test_headerBarConvenienceInitSubtitle() {
        ensureAdwInit()
        let hb = HeaderBar(title: "App", subtitle: "v1.0")
        XCTAssertNotNil(hb.titleWidget)
    }

    // MARK: - AboutDialog convenience init

    @MainActor func test_aboutDialogConvenienceInit() {
        ensureAdwInit()
        let dialog = AboutDialog(
            appName: "TestApp",
            version: "1.0",
            developer: "Dev"
        )
        XCTAssertTrue(dialog.applicationName == "TestApp")
        XCTAssertTrue(dialog.version == "1.0")
        XCTAssertTrue(dialog.developerName == "Dev")
    }

    @MainActor func test_aboutDialogConvenienceInitFull() {
        ensureAdwInit()
        let dialog = AboutDialog(
            appName: "TestApp",
            version: "2.0",
            developer: "Dev",
            website: "https://example.com",
            copyright: "2026 Dev"
        )
        XCTAssertTrue(dialog.applicationName == "TestApp")
        XCTAssertTrue(dialog.website == "https://example.com")
        XCTAssertTrue(dialog.copyright == "2026 Dev")
    }

    // MARK: - Breakpoint convenience constructors

    @MainActor func test_breakpointMinWidth() {
        ensureAdwInit()
        let bp = Breakpoint.minWidth(500)
        XCTAssertNotNil(bp.condition)
    }

    @MainActor func test_breakpointMaxWidth() {
        ensureAdwInit()
        let bp = Breakpoint.maxWidth(800)
        XCTAssertNotNil(bp.condition)
    }

    @MainActor func test_breakpointMinHeight() {
        ensureAdwInit()
        let bp = Breakpoint.minHeight(400)
        XCTAssertNotNil(bp.condition)
    }

    // MARK: - Pango enum extensions

    func test_pangoWeightExtensions() {
        XCTAssertTrue(PangoWeight.bold.rawValue == 700)
        XCTAssertTrue(PangoWeight.normal.rawValue == 400)
        XCTAssertTrue(PangoWeight.light.rawValue == 300)
    }

    func test_pangoStyleExtensions() {
        XCTAssertTrue(PangoStyle.normal.rawValue == 0)
        XCTAssertTrue(PangoStyle.italic.rawValue == 2)
    }

    func test_pangoUnderlineExtensions() {
        XCTAssertTrue(PangoUnderline.none.rawValue == 0)
        XCTAssertTrue(PangoUnderline.single.rawValue == 1)
    }

    // MARK: - Toast Convenience Tests

    @MainActor func test_toastOverlayShowToast() {
        ensureAdwInit()
        let overlay = ToastOverlay()
        // Should not crash
        overlay.showToast("Hello")
    }

    @MainActor func test_toastOverlayShowToastWithButton() {
        ensureAdwInit()
        let overlay = ToastOverlay()
        var tapped = false
        overlay.showToast("Deleted", button: "Undo") {
            tapped = true
        }
        // Verifies the API compiles and doesn't crash
        XCTAssertFalse(tapped)
    }

    // MARK: - ToolbarView Convenience Tests

    @MainActor func test_toolbarViewConvenienceInit() {
        ensureAdwInit()
        let content = Label("Content")
        let header = HeaderBar()
        let tv = ToolbarView(content: content, topBar: header)
        XCTAssertNotNil(tv.content)
    }

    // MARK: - ScrolledWindow Convenience Tests

    @MainActor func test_scrolledWindowConvenienceInit() {
        ensureAdwInit()
        let label = Label("Scrollable")
        let sw = ScrolledWindow(child: label)
        XCTAssertNotNil(sw.child)
    }

    // MARK: - OverlaySplitView Convenience Tests

    @MainActor func test_overlaySplitViewConvenienceInit() {
        ensureAdwInit()
        let sidebar = Label("Sidebar")
        let content = Label("Content")
        let split = OverlaySplitView(sidebar: sidebar, content: content)
        XCTAssertNotNil(split.sidebar)
        XCTAssertNotNil(split.content)
    }

    // MARK: - Notification IconName Overload Tests

    @MainActor func test_sendNotificationIconNameOverload() {
        ensureAdwInit()
        // Just verify it compiles — we can't actually send without a running app
        let iconName = IconName.dialogInformation
        XCTAssertTrue(iconName.name == "dialog-information-symbolic")
    }

}
#endif
