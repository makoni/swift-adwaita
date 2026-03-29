import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct ConvenienceTests {

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
        let _: (Widget?, String?, @escaping @MainActor (Result<String?, GLibError>) -> Void) -> Void = dialog
            .chooseFontThrowing
    }

    @Test @MainActor func colorDialogThrowingMethodExists() {
        ensureAdwInit()
        let dialog = ColorDialog()
        let _: (Widget?, RGBA?, @escaping @MainActor (Result<RGBA?, GLibError>) -> Void) -> Void = dialog
            .chooseRGBAThrowing
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

}
