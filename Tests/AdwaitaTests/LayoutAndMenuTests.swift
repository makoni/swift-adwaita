import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized) struct LayoutAndMenuTests {

    // MARK: - GMenuRef

    @Test @MainActor func gmenuCreation() {
        ensureAdwInit()
        let menu = GMenuRef()
        _ = menu // verify creation doesn't crash
    }

    @Test @MainActor func gmenuAppendItems() {
        ensureAdwInit()
        let menu = GMenuRef()
        menu.append("Open", action: "app.open")
        menu.append("Save", action: "app.save")
    }

    @Test @MainActor func gmenuAppendItem() {
        ensureAdwInit()
        let menu = GMenuRef()
        let item = GMenuItemRef(label: "Quit", action: "app.quit")
        menu.appendItem(item)
    }

    @Test @MainActor func gmenuAppendSection() {
        ensureAdwInit()
        let menu = GMenuRef()
        let section = GMenuRef()
        section.append("Cut", action: "edit.cut")
        section.append("Copy", action: "edit.copy")
        menu.appendSection("Edit", section: section)
    }

    @Test @MainActor func gmenuAppendSectionNilLabel() {
        ensureAdwInit()
        let menu = GMenuRef()
        let section = GMenuRef()
        section.append("Paste", action: "edit.paste")
        menu.appendSection(nil, section: section)
    }

    @Test @MainActor func gmenuAppendSubmenu() {
        ensureAdwInit()
        let menu = GMenuRef()
        let submenu = GMenuRef()
        submenu.append("Zoom In", action: "view.zoomIn")
        submenu.append("Zoom Out", action: "view.zoomOut")
        menu.appendSubmenu("View", submenu: submenu)
    }

    @Test @MainActor func gmenuInsertAndRemove() {
        ensureAdwInit()
        let menu = GMenuRef()
        menu.append("First", action: "app.first")
        menu.insert(0, label: "Zeroth", action: "app.zeroth")
        menu.remove(0)
    }

    @Test @MainActor func gmenuRemoveAll() {
        ensureAdwInit()
        let menu = GMenuRef()
        menu.append("A", action: "app.a")
        menu.append("B", action: "app.b")
        menu.removeAll()
    }

    @Test @MainActor func gmenuFreeze() {
        ensureAdwInit()
        let menu = GMenuRef()
        menu.append("Static", action: "app.static")
        menu.freeze()
    }

    // MARK: - GMenuItemRef

    @Test @MainActor func gmenuItemCreation() {
        ensureAdwInit()
        let item = GMenuItemRef(label: "Open", action: "app.open")
        _ = item
    }

    @Test @MainActor func gmenuItemSetLabel() {
        ensureAdwInit()
        let item = GMenuItemRef(label: "Old", action: "app.test")
        item.setLabel("New")
    }

    @Test @MainActor func gmenuItemSetIconName() {
        ensureAdwInit()
        let item = GMenuItemRef(label: "Open", action: "app.open")
        item.setIconName("document-open-symbolic")
    }

    @Test @MainActor func gmenuItemSetAttribute() {
        ensureAdwInit()
        let item = GMenuItemRef(label: "Test", action: "app.test")
        item.setAttribute("custom-key", value: "custom-value")
    }

    @Test @MainActor func gmenuItemNilLabelAndAction() {
        ensureAdwInit()
        let item = GMenuItemRef(label: nil, action: nil)
        _ = item
    }

    // MARK: - Carousel (extended)

    @Test @MainActor func carouselNPagesEmpty() {
        ensureAdwInit()
        let carousel = Carousel()
        #expect(carousel.nPages == 0)
    }

    @Test @MainActor func carouselPositionDefault() {
        ensureAdwInit()
        let carousel = Carousel()
        #expect(carousel.position == 0.0)
    }

    @Test @MainActor func carouselInteractiveRoundTrip() {
        ensureAdwInit()
        let carousel = Carousel()
        #expect(carousel.interactive == true)
        carousel.interactive = false
        #expect(carousel.interactive == false)
        carousel.interactive = true
        #expect(carousel.interactive == true)
    }

    @Test @MainActor func carouselAllowMouseDragRoundTrip() {
        ensureAdwInit()
        let carousel = Carousel()
        carousel.allowMouseDrag = true
        #expect(carousel.allowMouseDrag == true)
        carousel.allowMouseDrag = false
        #expect(carousel.allowMouseDrag == false)
    }

    @Test @MainActor func carouselAllowScrollWheelRoundTrip() {
        ensureAdwInit()
        let carousel = Carousel()
        let initial = carousel.allowScrollWheel
        carousel.allowScrollWheel = !initial
        #expect(carousel.allowScrollWheel == !initial)
    }

    @Test @MainActor func carouselAllowLongSwipesRoundTrip() {
        ensureAdwInit()
        let carousel = Carousel()
        carousel.allowLongSwipes = true
        #expect(carousel.allowLongSwipes == true)
        carousel.allowLongSwipes = false
        #expect(carousel.allowLongSwipes == false)
    }

    @Test @MainActor func carouselRevealDuration() {
        ensureAdwInit()
        let carousel = Carousel()
        carousel.revealDuration = 500
        #expect(carousel.revealDuration == 500)
    }

    @Test @MainActor func carouselScrollTo() {
        ensureAdwInit()
        let carousel = Carousel()
        let page1 = Label("Page 1")
        let page2 = Label("Page 2")
        carousel.append(page1)
        carousel.append(page2)
        carousel.scrollTo(page1, animate: false)
    }

    @Test @MainActor func carouselOnPageChanged() {
        ensureAdwInit()
        let carousel = Carousel()
        var called = false
        let conn = carousel.onPageChanged { _ in
            called = true
        }
        #expect(conn is SignalConnection)
        conn.disconnect()
        _ = called
    }

    @Test @MainActor func carouselGetNthPage() {
        ensureAdwInit()
        let carousel = Carousel()
        let page1 = Label("First")
        carousel.append(page1)
        let retrieved = carousel.getNthPage(0)
        _ = retrieved // verify retrieval doesn't crash
    }

    // MARK: - CarouselIndicatorDots

    @Test @MainActor func carouselIndicatorDotsCreation() {
        ensureAdwInit()
        let dots = CarouselIndicatorDots()
        _ = dots
    }

    @Test @MainActor func carouselIndicatorDotsCarouselProperty() {
        ensureAdwInit()
        let dots = CarouselIndicatorDots()
        #expect(dots.carousel == nil)
        let carousel = Carousel()
        dots.carousel = carousel
        #expect(dots.carousel != nil)
        dots.carousel = nil
        #expect(dots.carousel == nil)
    }

    // MARK: - CarouselIndicatorLines

    @Test @MainActor func carouselIndicatorLinesCreation() {
        ensureAdwInit()
        let lines = CarouselIndicatorLines()
        _ = lines
    }

    @Test @MainActor func carouselIndicatorLinesCarouselProperty() {
        ensureAdwInit()
        let lines = CarouselIndicatorLines()
        #expect(lines.carousel == nil)
        let carousel = Carousel()
        lines.carousel = carousel
        #expect(lines.carousel != nil)
        lines.carousel = nil
        #expect(lines.carousel == nil)
    }

    // MARK: - ViewSwitcher

    @Test @MainActor func viewSwitcherCreation() {
        ensureAdwInit()
        let switcher = ViewSwitcher()
        _ = switcher
    }

    @Test @MainActor func viewSwitcherStackProperty() {
        ensureAdwInit()
        let switcher = ViewSwitcher()
        #expect(switcher.stack == nil)
        let stack = ViewStack()
        switcher.stack = stack
        #expect(switcher.stack != nil)
        switcher.stack = nil
        #expect(switcher.stack == nil)
    }

    @Test @MainActor func viewSwitcherPolicy() {
        ensureAdwInit()
        let switcher = ViewSwitcher()
        switcher.policy = .wide
        #expect(switcher.policy == .wide)
        switcher.policy = .narrow
        #expect(switcher.policy == .narrow)
    }

    // MARK: - ViewSwitcherBar

    @Test @MainActor func viewSwitcherBarCreation() {
        ensureAdwInit()
        let bar = ViewSwitcherBar()
        _ = bar
    }

    @Test @MainActor func viewSwitcherBarStackProperty() {
        ensureAdwInit()
        let bar = ViewSwitcherBar()
        #expect(bar.stack == nil)
        let stack = ViewStack()
        bar.stack = stack
        #expect(bar.stack != nil)
    }

    @Test @MainActor func viewSwitcherBarReveal() {
        ensureAdwInit()
        let bar = ViewSwitcherBar()
        #expect(bar.reveal == false)
        bar.reveal = true
        #expect(bar.reveal == true)
        bar.reveal = false
        #expect(bar.reveal == false)
    }

    // MARK: - InlineViewSwitcher

    @Test @MainActor func inlineViewSwitcherCreation() {
        ensureAdwInit()
        guard let switcher = InlineViewSwitcher() else {
            // libadwaita < 1.7; skip gracefully.
            return
        }
        _ = switcher
    }

    @Test @MainActor func inlineViewSwitcherStackProperty() {
        ensureAdwInit()
        guard let switcher = InlineViewSwitcher() else { return }
        #expect(switcher.stack == nil)
        let stack = ViewStack()
        switcher.stack = stack
        #expect(switcher.stack != nil)
    }

    @Test @MainActor func inlineViewSwitcherDisplayMode() {
        ensureAdwInit()
        guard let switcher = InlineViewSwitcher() else { return }
        switcher.displayMode = .icons
        #expect(switcher.displayMode == .icons)
        switcher.displayMode = .labels
        #expect(switcher.displayMode == .labels)
        switcher.displayMode = .both
        #expect(switcher.displayMode == .both)
    }

    @Test @MainActor func inlineViewSwitcherCanShrinkAndHomogeneous() {
        ensureAdwInit()
        guard let switcher = InlineViewSwitcher() else { return }
        switcher.canShrink = true
        #expect(switcher.canShrink == true)
        switcher.homogeneous = true
        #expect(switcher.homogeneous == true)
    }

    // MARK: - ViewStackPage

    @Test @MainActor func viewStackPageProperties() {
        ensureAdwInit()
        let stack = ViewStack()
        let child = Label("Hello")
        let page = stack.addTitled(child, name: "hello", title: "Hello")

        #expect(page.title == "Hello")
        #expect(page.name == "hello")

        page.title = "Changed"
        #expect(page.title == "Changed")

        page.iconName = "go-home-symbolic"
        #expect(page.iconName == "go-home-symbolic")

        page.badgeNumber = 42
        #expect(page.badgeNumber == 42)

        page.needsAttention = true
        #expect(page.needsAttention == true)

        page.useUnderline = true
        #expect(page.useUnderline == true)

        page.visible = false
        #expect(page.visible == false)
    }

    @Test @MainActor func viewStackPageChild() {
        ensureAdwInit()
        let stack = ViewStack()
        let child = Label("Content")
        let page = stack.add(child)
        _ = page.child // read-only; should not crash
    }

    // MARK: - Clamp

    @Test @MainActor func clampCreation() {
        ensureAdwInit()
        let clamp = Clamp()
        _ = clamp
    }

    @Test @MainActor func clampChildProperty() {
        ensureAdwInit()
        let clamp = Clamp()
        #expect(clamp.child == nil)
        let label = Label("Clamped")
        clamp.child = label
        #expect(clamp.child != nil)
    }

    @Test @MainActor func clampMaximumSizeRoundTrip() {
        ensureAdwInit()
        let clamp = Clamp()
        clamp.maximumSize = 800
        #expect(clamp.maximumSize == 800)
    }

    @Test @MainActor func clampTighteningThresholdRoundTrip() {
        ensureAdwInit()
        let clamp = Clamp()
        clamp.tighteningThreshold = 300
        #expect(clamp.tighteningThreshold == 300)
    }

    // MARK: - ClampLayout

    @Test @MainActor func clampLayoutCreation() {
        ensureAdwInit()
        let layout = ClampLayout()
        _ = layout
    }

    @Test @MainActor func clampLayoutMaximumSize() {
        ensureAdwInit()
        let layout = ClampLayout()
        layout.maximumSize = 1000
        #expect(layout.maximumSize == 1000)
    }

    @Test @MainActor func clampLayoutTighteningThreshold() {
        ensureAdwInit()
        let layout = ClampLayout()
        layout.tighteningThreshold = 500
        #expect(layout.tighteningThreshold == 500)
    }

    // MARK: - ClampScrollable

    @Test @MainActor func clampScrollableCreation() {
        ensureAdwInit()
        let clamp = ClampScrollable()
        _ = clamp
    }

    @Test @MainActor func clampScrollableChildProperty() {
        ensureAdwInit()
        let clamp = ClampScrollable()
        #expect(clamp.child == nil)
        let label = Label("Scrollable content")
        clamp.child = label
        #expect(clamp.child != nil)
    }

    @Test @MainActor func clampScrollableMaximumSize() {
        ensureAdwInit()
        let clamp = ClampScrollable()
        clamp.maximumSize = 700
        #expect(clamp.maximumSize == 700)
    }

    @Test @MainActor func clampScrollableTighteningThreshold() {
        ensureAdwInit()
        let clamp = ClampScrollable()
        clamp.tighteningThreshold = 350
        #expect(clamp.tighteningThreshold == 350)
    }

    // MARK: - Breakpoint

    @Test @MainActor func breakpointCreation() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "min-width: 600px")
        let bp = Breakpoint(condition: cond)
        _ = bp
    }

    @Test @MainActor func breakpointConditionProperty() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "max-width: 400sp")
        let bp = Breakpoint(condition: cond)
        #expect(bp.condition != nil)
        let condStr = bp.condition?.toString()
        #expect(condStr != nil)
    }

    @Test @MainActor func breakpointAddSetterBool() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "min-width: 500px")
        let bp = Breakpoint(condition: cond)
        let label = Label("Test")
        bp.addSetter(label, property: .visible, value: false)
    }

    @Test @MainActor func breakpointAddSetterString() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "min-width: 500px")
        let bp = Breakpoint(condition: cond)
        let label = Label("Test")
        bp.addSetter(label, property: .label, value: "Changed")
    }

    @Test @MainActor func breakpointOnApplySignal() {
        ensureAdwInit()
        let bp = Breakpoint.minWidth(600)
        var applied = false
        let conn = bp.onApply { applied = true }
        #expect(conn is SignalConnection)
        conn.disconnect()
        _ = applied
    }

    @Test @MainActor func breakpointOnUnapplySignal() {
        ensureAdwInit()
        let bp = Breakpoint.maxWidth(800)
        var unapplied = false
        let conn = bp.onUnapply { unapplied = true }
        #expect(conn is SignalConnection)
        conn.disconnect()
        _ = unapplied
    }

    // MARK: - BreakpointBin

    @Test @MainActor func breakpointBinCreation() {
        ensureAdwInit()
        let bin = BreakpointBin()
        _ = bin
    }

    @Test @MainActor func breakpointBinChildProperty() {
        ensureAdwInit()
        let bin = BreakpointBin()
        #expect(bin.child == nil)
        let label = Label("Content")
        bin.child = label
        #expect(bin.child != nil)
    }

    @Test @MainActor func breakpointBinAddBreakpoint() {
        ensureAdwInit()
        let bin = BreakpointBin()
        let bp = Breakpoint.minWidth(500)
        bin.addBreakpoint(bp)
        // No breakpoint is active until the bin is sized.
        #expect(bin.currentBreakpoint == nil)
    }

    // MARK: - SplitButton

    @Test @MainActor func splitButtonCreation() {
        ensureAdwInit()
        let btn = SplitButton()
        _ = btn
    }

    @Test @MainActor func splitButtonLabelProperty() {
        ensureAdwInit()
        let btn = SplitButton()
        btn.label = "Save"
        #expect(btn.label == "Save")
    }

    @Test @MainActor func splitButtonIconNameProperty() {
        ensureAdwInit()
        let btn = SplitButton()
        btn.iconName = "document-save-symbolic"
        #expect(btn.iconName == "document-save-symbolic")
    }

    @Test @MainActor func splitButtonChildProperty() {
        ensureAdwInit()
        let btn = SplitButton()
        #expect(btn.child == nil)
        let content = ButtonContent()
        content.label = "Custom"
        btn.child = content
        #expect(btn.child != nil)
    }

    @Test @MainActor func splitButtonMenuModel() {
        ensureAdwInit()
        let btn = SplitButton()
        let menu = GMenuRef()
        menu.append("Option A", action: "app.a")
        btn.setMenuModel(menu)
        btn.setMenuModel(nil)
    }

    @Test @MainActor func splitButtonDropdownTooltip() {
        ensureAdwInit()
        let btn = SplitButton()
        btn.dropdownTooltip = "More options"
        #expect(btn.dropdownTooltip == "More options")
    }

    @Test @MainActor func splitButtonOnClicked() {
        ensureAdwInit()
        let btn = SplitButton()
        var clicked = false
        let conn = btn.onClicked { clicked = true }
        #expect(conn is SignalConnection)
        conn.disconnect()
        _ = clicked
    }

    @Test @MainActor func splitButtonCanShrink() {
        ensureAdwInit()
        let btn = SplitButton()
        btn.canShrink = true
        #expect(btn.canShrink == true)
        btn.canShrink = false
        #expect(btn.canShrink == false)
    }

    @Test @MainActor func splitButtonUseUnderline() {
        ensureAdwInit()
        let btn = SplitButton()
        btn.useUnderline = true
        #expect(btn.useUnderline == true)
        btn.useUnderline = false
        #expect(btn.useUnderline == false)
    }

    // MARK: - ButtonContent

    @Test @MainActor func buttonContentCreation() {
        ensureAdwInit()
        let content = ButtonContent()
        _ = content
    }

    @Test @MainActor func buttonContentLabelProperty() {
        ensureAdwInit()
        let content = ButtonContent()
        content.label = "Download"
        #expect(content.label == "Download")
    }

    @Test @MainActor func buttonContentIconNameProperty() {
        ensureAdwInit()
        let content = ButtonContent()
        content.iconName = "folder-download-symbolic"
        #expect(content.iconName == "folder-download-symbolic")
    }

    @Test @MainActor func buttonContentUseUnderline() {
        ensureAdwInit()
        let content = ButtonContent()
        content.useUnderline = true
        #expect(content.useUnderline == true)
        content.useUnderline = false
        #expect(content.useUnderline == false)
    }

    @Test @MainActor func buttonContentCanShrink() {
        ensureAdwInit()
        let content = ButtonContent()
        content.canShrink = true
        #expect(content.canShrink == true)
        content.canShrink = false
        #expect(content.canShrink == false)
    }

    // MARK: - ShortcutLabel

    @Test @MainActor func shortcutLabelCreation() {
        ensureAdwInit()
        guard let label = ShortcutLabel(accelerator: "<Control>s") else {
            // libadwaita < 1.8; skip gracefully.
            return
        }
        _ = label
    }

    @Test @MainActor func shortcutLabelAccelerator() {
        ensureAdwInit()
        guard let label = ShortcutLabel(accelerator: "<Control>s") else { return }
        #expect(label.accelerator == "<Control>s")
        label.accelerator = "<Alt>F4"
        #expect(label.accelerator == "<Alt>F4")
    }

    @Test @MainActor func shortcutLabelDisabledText() {
        ensureAdwInit()
        guard let label = ShortcutLabel(accelerator: "<Control>z") else { return }
        label.disabledText = "Not available"
        #expect(label.disabledText == "Not available")
    }

    // MARK: - ShortcutsDialog

    @Test @MainActor func shortcutsDialogCreation() {
        ensureAdwInit()
        let dialog = ShortcutsDialog()
        _ = dialog
    }

    @Test @MainActor func shortcutsDialogAddSection() {
        ensureAdwInit()
        guard ShortcutsDialog.isAvailable else { return }
        let dialog = ShortcutsDialog()
        guard let section = ShortcutsSection(title: "General") else { return }
        dialog.add(section)
    }

    // MARK: - ShortcutsItem

    @Test @MainActor func shortcutsItemCreation() {
        ensureAdwInit()
        guard let item = ShortcutsItem(title: "Save", accelerator: "<Control>s") else {
            return
        }
        _ = item
    }

    @Test @MainActor func shortcutsItemTitleProperty() {
        ensureAdwInit()
        guard let item = ShortcutsItem(title: "Save", accelerator: "<Control>s") else { return }
        #expect(item.title == "Save")
        item.title = "Save As"
        #expect(item.title == "Save As")
    }

    @Test @MainActor func shortcutsItemAccelerator() {
        ensureAdwInit()
        guard let item = ShortcutsItem(title: "Undo", accelerator: "<Control>z") else { return }
        #expect(item.accelerator == "<Control>z")
        item.accelerator = "<Control><Shift>z"
        #expect(item.accelerator == "<Control><Shift>z")
    }

    @Test @MainActor func shortcutsItemSubtitle() {
        ensureAdwInit()
        guard let item = ShortcutsItem(title: "Find", accelerator: "<Control>f") else { return }
        item.subtitle = "Search in document"
        #expect(item.subtitle == "Search in document")
    }

    @Test @MainActor func shortcutsItemActionName() {
        ensureAdwInit()
        guard let item = ShortcutsItem(title: "Quit", accelerator: "<Control>q") else { return }
        item.actionName = "app.quit"
        #expect(item.actionName == "app.quit")
    }

    @Test @MainActor func shortcutsItemFromAction() {
        ensureAdwInit()
        guard let item = ShortcutsItem.newFromAction(title: "Quit", actionName: "app.quit") else {
            return
        }
        #expect(item.title == "Quit")
        #expect(item.actionName == "app.quit")
    }

    // MARK: - ShortcutsSection

    @Test @MainActor func shortcutsSectionCreation() {
        ensureAdwInit()
        guard let section = ShortcutsSection(title: "Editing") else {
            return
        }
        _ = section
    }

    @Test @MainActor func shortcutsSectionTitleProperty() {
        ensureAdwInit()
        guard let section = ShortcutsSection(title: "Navigation") else { return }
        #expect(section.title == "Navigation")
        section.title = "General"
        #expect(section.title == "General")
    }

    @Test @MainActor func shortcutsSectionAddItem() {
        ensureAdwInit()
        guard let section = ShortcutsSection(title: "Edit") else { return }
        guard let item = ShortcutsItem(title: "Cut", accelerator: "<Control>x") else { return }
        section.add(item)
    }

    @Test @MainActor func shortcutsSectionNilTitle() {
        ensureAdwInit()
        guard let section = ShortcutsSection(title: nil) else { return }
        #expect(section.title == nil)
        section.title = "Now has a title"
        #expect(section.title == "Now has a title")
    }
}
